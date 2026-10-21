## Title: OpDMC
## Version: 0.2-0
## Date: 2026-10-19
## Author: Ambrosio Torres (Researcher [Ctr. Integr. Biodivers. Discov. - Museum für Naturkunde, Berlin, Germany)
## Maintainer: Ambrosio Torres <atorresgalvis@gmail.com> <Ambrosio.TorresGalvis@mfn.berlin>
## Depends: R version (>= 4.2.2). Package seqinr (4.2-23)
## Description: Finds Optimal Diagnostic Molecular Combinations based on the stability of their specificity.
## License: GPL (3)
## Usage: OpDMC("MegaseliaTraining.fasta", "SpeciesListMegaselia.csv", iter = 5000, MnLen = 3, exclusive = 2, RefStrength = 0.10, OutName = "OpDMC_Megaselia.csv", GapsNew = FALSE)

require("seqinr")

OpDMC <- function(FastaFile, species, iter = 20000,
				  MnLen = 8, exclusive = 4, RefStrength = 0.25,
				  OutName = "OpDMC_output.csv", GapsNew = FALSE){

	# PARAMETER CHECKS

	if (MnLen < 2) {
		MnLen <- 2
		message("The MnLen parameter cannot be smaller than 2. ", "Thus, it was reset automatically to 2.")
	}
	if (exclusive < 1) {
		exclusive <- 1
		message("The exclusive parameter cannot be smaller than 1. ", "Thus, it was reset automatically to 1.")
	}
	if (MnLen < exclusive) {
		MnLen <- exclusive
		message("The MnLen parameter cannot be smaller than the exclusive parameter. ", "Thus, it was reset automatically.")
	}
	if (iter < 1) {
		stop("iter must be >= 1.")
	}
	if (RefStrength < 0 || RefStrength > 1) {
		stop("RefStrength must be between 0 and 1.")
	}
	iteraciones <- as.integer(iter)
	minlength <- as.integer(MnLen)
	refinStrength <- RefStrength

	# INTERNAL STOPPING RULES
	#
	# These are deliberately NOT exposed as user parameters.
	#
	# 20  = baseline consensus
	# 50  = possible convergence hit 1
	# 80  = possible convergence hit 2
	# 110 = possible convergence hit 3 
	# 140 = possible convergence hit 4 -> STOP
	#
	# Any change in the consensus resets the counter.
	# If convergence is never reached, the internal hard cap is
	# 469 distinct valid DMCs.

	conv_checkpoints <- c(20L, 50L, 80L, 110L, 140L, 170L, 200L, 230L, 260L, 290L, 320L, 350L, 380L, 410L, 430L, 450L)
	conv_required <- 4L
	max_solutions <- 469L

	# SMALL HELPER FUNCTIONS

	lappend <- function (lst, ...){
		c(lst, list(...))
	}

	# Check whether a candidate DMC satisfies the requested
	# exclusivity against all non-query sequences.

	is_valid_dmc <- function(key, sites, raw_records, clado, exclusive) {
		refs <- raw_records[-clado]
		if (length(refs) == 0) {
			return(TRUE)
		}
		size <- length(key)
		for (j in seq_along(refs)) {
			tocomp <- unname(sapply(refs[j], `[`, sites))[, 1]
			matchi <- sum(toupper(key) == toupper(tocomp), na.rm = TRUE)
			if (matchi > (size - exclusive)) {
				return(FALSE)
			}
		}
		TRUE
	}

	# Weighted random sampling.
	#
	# This preserves the original 10:90 roulette logic but:
	#
	# 1. scores are indexed by the actual site position;
	# 2. sites > 90 are removed before the loop because they can
	#    never be accepted by the original roulette;
	# 3. an impossible request returns NULL rather than hanging.

	draw_weighted_sites <- function(pool, n, score_map) {
		if (n == 0) {
			return(numeric(0))
		}
		if (length(pool) == 0) {
			return(NULL)
		}
		scores <- score_map[as.character(pool)]
		pool <- pool[!is.na(scores) & scores <= 90]
		if (length(pool) < n) {
			return(NULL)
		}
		selected <- numeric(0)
		while (length(selected) < n) {
			idx <- sample.int(length(pool), 1)
			site <- pool[idx]
			dado <- sample(10:90, 1)
			site_score <- score_map[as.character(site)]
			if (!is.na(site_score) && site_score <= dado) {
				selected <- c(selected, site)
				pool <- pool[-idx]
			}
		}
		selected
	}

	# Majority-consensus DMC.
	#
	# Exactly the same function is used:
	#
	# - during convergence checkpoints
	# - for the final consensus DMC
	#
	# Therefore provisional and final consensus DMCs are defined
	# using the same criterion.

	build_consensus_dmc <- function(lista_use, fallback_dmc, raw_records, clado, exclusive) {
		if (length(lista_use) == 0 || is.null(fallback_dmc)) {
			return(NULL)
		}
		histograma <- unlist(lapply(lista_use, names), use.names = FALSE)
		histograma <- sort(table(histograma), decreasing = TRUE)
		target_len <- length(fallback_dmc)
		chosen_sites <- NULL
		for (extra in 0:6) {
			tama <- target_len + extra
			if (tama > length(histograma)) {
				break
			}
			candidate_pool <- as.numeric(names(histograma)[seq_len(tama)])
			vueltas <- combn(candidate_pool, target_len)

			# Preserve original behaviour:
			# if several combinations are valid,
			# retain the last valid one encountered.

			for (vu in seq_len(ncol(vueltas))) {
				sites <- vueltas[, vu]
				key <- unname(sapply(raw_records[clado[1]], `[`, sites))[, 1]
				names(key) <- sites
				if (is_valid_dmc(key, sites, raw_records, clado, exclusive)) {
					chosen_sites <- sites
				}
			}
			if (!is.null(chosen_sites)) {
				break
			}
		}
		if (is.null(chosen_sites)) {
			result <- fallback_dmc
		} else {
			result <- unname(sapply(raw_records[clado[1]], `[`, chosen_sites))[, 1]
			names(result) <- chosen_sites
		}
		result[order(as.numeric(names(result)))]
	}

	consensus_signature <- function(dmc) {
		if (is.null(dmc)) {
			return(NULL)
		}
		paste(paste(names(dmc), toupper(dmc), sep = ":"), collapse = "|")
	}

	# READ FASTA

	raw_records <- read.fasta(FastaFile, whole.header = TRUE, forceDNAtolower = TRUE)

	# REMOVE DUPLICATED SEQUENCES

	cadena <- NULL
	identi <- NULL
	for (i in seq_along(raw_records)) {
		cuerda <- paste(as.character(raw_records[[i]]), collapse = "")
		if (!is.element(cuerda, cadena)) {
			cadena <- c(cadena, cuerda)
			identi <- c(identi, i)
		}
	}
	raw_records <- raw_records[identi]

	# VARIABLE SITES

	VarSites <- NULL
	for (i in seq_along(raw_records[[1]])) {
		states <- unname(sapply(raw_records, `[`, i))
		if (length(unique(states)) > 1) {
			VarSites <- c(VarSites, i)
		}
	}

	# QUERY TAXA

	datos <- read.csv(species, header = FALSE)
	TablaFinal <- NULL
	message("Identifying possible DMCs for the species:")
	for (cladin in seq_len(nrow(datos))) {
		avance <- round(((cladin - 1) / nrow(datos)) * 100)
		qTAXA <- as.character(datos[cladin, 1])
		clado <- which(grepl(qTAXA, attributes(raw_records)$names))
		cat(paste("\tDoing", qTAXA, "\t-\t", paste0(avance, "%"), "of the species have been completed.\n"))
		if (length(clado) == 0) {
			stop(
				paste(
					"The species",
					qTAXA,
					"is not present in your fasta file.",
					"Please make sure you have at least one sequence/specimen in your fasta file",
					"for each species included in your query-taxa file."
				)
			)
		}

		# SITES SHARED BY ALL QUERY SEQUENCES

		shared <- NULL
		for (site in VarSites) {
			query_states <- unname(sapply(raw_records[clado], `[`, site))
			if (length(unique(query_states)) == 1) {
				query_state <- toupper(query_states[1])
				if (GapsNew || !(query_state %in% c("-", "N", "?"))) {
					shared <- c(shared, site)
				}
			}
		}
		if (length(shared) < minlength) {
			stop(paste("The query taxon", qTAXA, "has fewer than", minlength, "shared variable sites available for constructing a DMC."))
		}

		# SITE WEIGHTS

		unica <- NULL
		puntajes <- numeric(length(shared))
		for (i in seq_along(shared)) {
			site <- shared[i]
			a <- unique(unname(sapply(raw_records[clado], `[`, site)))
			ref_states <- unname(sapply(raw_records[-clado], `[`, site))
			b <- unique(ref_states)
			if (!is.element(a, b)) {
				unica <- c(unica, site)
				puntajes[i] <- 0
			} else {
				puntajes[i] <- (sum(ref_states == a) / length(ref_states)) * 100
			}
		}

		# Site scores are named with the actual alignment position.
		# This prevents the previous index mismatch after shared2
		# becomes smaller.

		names(puntajes) <- as.character(shared)
		unicount <- length(unica)

		# Scores > 90 can never pass the original 10:90 roulette.

		eligible_sites <- shared[puntajes <= 90]
		max_candidate_length <- length(eligible_sites)
		if (max_candidate_length < minlength) {
			stop(paste("The query taxon", qTAXA, "has fewer than", minlength, "sites eligible under the current weighted-sampling rule."))
		}
		maxlength <- min((MnLen * 2) + 1, max_candidate_length)
		n_nonunique_eligible <- sum(!(eligible_sites %in% unica))

		# SIZE OF THE ACTUAL CANDIDATE SPACE
		#
		# This also prevents the duplicate-heavy branch with many
		# exclusive sites from sampling forever once every distinct
		# candidate has already been seen.

		candidate_space_for_size <- function(k) {
			if (unicount >= minlength) {
				if (k == minlength) {
					return(choose(unicount, minlength))
				}
				return(0)
			}
			if (unicount > 0) {
				n_extra <- k - unicount
				if (n_extra < 0 || n_extra > n_nonunique_eligible) {
					return(0)
				}
				return(choose(n_nonunique_eligible, n_extra))
			}
			if (k > max_candidate_length) {
				return(0)
			}
			choose(max_candidate_length, k)
		}

		count_possible <- function(minlen, maxlen) {
			if (maxlen < minlen) {
				return(0)
			}
			sum(vapply(minlen:maxlen, candidate_space_for_size, numeric(1)))
		}

		# INITIALIZE SEARCH

		lista <- list()
		AltrDNC <- NULL
		minimo <- maxlength
		soluciones <- 0L
		iteraciones2 <- iteraciones
		previous_consensus <- NULL
		consecutive_convergences <- 0L
		stop_search <- FALSE
		IterPosibles <- count_possible(minlength, maxlength)
		if (is.finite(IterPosibles) && IterPosibles < iteraciones2) {
			iteraciones2 <- max(1L, round(IterPosibles / 3))
		}
		breakadicionales <- max(1L, round(iteraciones2 * 0.2))
		veces <- 0L
		buffi <- character(0)
		seen_by_size <- setNames(rep(0, max_candidate_length), as.character(seq_len(max_candidate_length)))
		space_exhausted <- FALSE

		# SEARCH

		while (soluciones < 2 && !stop_search && !space_exhausted) {

			# Increase maximum DMC length when needed

			if (veces == 6) {
				if (maxlength >= max_candidate_length) {
					if (soluciones == 0) {
						stop(paste("No DMC was identified for", qTAXA, "within the specified search effort, and the maximum", "available candidate length has been reached."))
					}
					break
				}
				maxlength <- min(maxlength + 1L, max_candidate_length)
				minimo <- maxlength
				message("None of the combinations tested are suitable to become a DMC.")
				message(paste("The maximum length of the DMCs has been reset to", maxlength))
				iteraciones2 <- iteraciones
				IterPosibles <- count_possible(minlength, maxlength)
				if (is.finite(IterPosibles) && IterPosibles < iteraciones2) {
					iteraciones2 <- max(1L, round(IterPosibles / 3))
				}
				breakadicionales <- max(1L, round(iteraciones2 * 0.2))
				veces <- 0L
			}
			reales <- 0L

			# SAMPLE CANDIDATE DMCs

			while (reales < iteraciones2 && !stop_search && !space_exhausted) {

				# Choose only DMC lengths for which unseen
				# candidates still exist.
				#
				# sample.int() is used here to avoid R's special
				# sample(x) behaviour when x has length 1.

				if (minimo <= minlength || unicount >= minlength) {
					size_options <- minlength
				} else {
					size_options <- minlength:maxlength
				}
				remaining_by_size <- vapply(size_options, function(k) {  candidate_space_for_size(k) - seen_by_size[as.character(k)] }, numeric(1))
				size_options <- size_options[remaining_by_size > 0]
				if (length(size_options) == 0) {
					space_exhausted <- TRUE
					break
				}
				size_total <- size_options[sample.int(length(size_options), 1)]

				# Build candidate

				if (unicount > 0 && unicount < minlength) {

					# Fully exclusive sites are always included.

					n_extra <- size_total - unicount
					sampled <- draw_weighted_sites(setdiff(shared, unica), n_extra, puntajes)
					if (is.null(sampled)) {
						reales <- reales + 1L
						next
					}
					tokey <- c(sampled, unica)
				} else if (unicount >= minlength) {

					# Enough fully exclusive sites to form a
					# minimum-length DMC directly.

					tokey <- sample(unica, minlength)
				} else {
					sampled <- draw_weighted_sites(shared, size_total, puntajes)
					if (is.null(sampled)) {
						reales <- reales + 1L
						next
					}
					tokey <- sampled
				}
				tokey <- as.numeric(tokey)
				tokey2 <- paste(sort(tokey), collapse = "-")

				# DUPLICATES
				#
				# A repeated DMC is neither:
				#
				# - a new iteration
				# - a new solution
				# - a new observation for the consensus histogram

				if (tokey2 %in% buffi) {
					next
				}
				buffi <- c(buffi, tokey2)
				seen_by_size[as.character(length(tokey))] <- seen_by_size[as.character(length(tokey))] + 1
				reales <- reales + 1L
				key <- unname(sapply(raw_records[clado[1]], `[`, tokey))[, 1]
				names(key) <- tokey

				# TEST CANDIDATE

				if (is_valid_dmc(key, tokey, raw_records, clado, exclusive)) {
					if (length(key) <= minimo && length(key) >= minlength) {
						minimo <- length(key)
						AltrDNC <- key
					}
					lista <- lappend(lista, key)
					soluciones <- soluciones + 1L

					# CONVERGENCE CHECK
					#
					# Only activated after a valid DMC of exactly
					# MnLen has been found.
					#
					# Therefore difficult taxa that only produce
					# longer DMCs continue receiving the requested
					# search effort.

					if (minimo <= minlength && soluciones %in% conv_checkpoints) {
						current_dmc <- build_consensus_dmc(lista, AltrDNC, raw_records, clado, exclusive)
						current_consensus <- consensus_signature(current_dmc)
						if (!is.null(previous_consensus)) {
							if (identical(current_consensus, previous_consensus)) {
								consecutive_convergences <- consecutive_convergences +
									1L
							} else {
								consecutive_convergences <- 0L
							}
						}
						previous_consensus <- current_consensus

						# Stop only after the required number of consecutive hits

						if (consecutive_convergences >= conv_required) {
							message(paste("Consensus DMC stabilized after", conv_required, "consecutive convergence hits. Stopping at", soluciones, "optimal DMCs."))
							stop_search <- TRUE
							break
						}
					}

					# INTERNAL HARD CAP

					if (soluciones >= max_solutions) {
						message(paste("Maximum of", max_solutions, "optimal DMCs reached. Stopping search."))
						stop_search <- TRUE
						break
					}
				}
			}
			if (space_exhausted) {
				break
			}
			veces <- veces + 1L
			if (soluciones < 2 && !stop_search) {
				iteraciones2 <- breakadicionales
			}
		}
		if (length(lista) == 0 || is.null(AltrDNC)) {
			stop(paste("No valid DMC was recovered for", qTAXA, "."))
		}

		# REFINEMENT

		if (minimo <= minlength) {

			# Once a minimum-length DMC exists there is nothing
			# shorter to refine while respecting MnLen.

			lista2 <- lista
		} else {
			lista2 <- vector("list", length(lista))
			for (i in seq_along(lista)) {
				key2 <- lista[[i]]

				# RefStrength = 0 now explicitly means:
				# DO NOT REFINE

				if (length(key2) <= minlength || refinStrength == 0) {
					lista2[[i]] <- key2
					next
				}
				Posibles <- list()
				for (cha in (length(key2) - 1):minlength) {
					Posibles <- c(Posibles, combn(seq_along(key2), cha, simplify = FALSE))
				}
				if (length(Posibles) == 0) {
					lista2[[i]] <- key2
					next
				}
				n_refine <- min(length(Posibles), round(length(Posibles) * refinStrength))
				if (n_refine <= 0) {
					lista2[[i]] <- key2
					next
				}
				cuales <- sample(seq_along(Posibles), n_refine)

				# Start with the original valid DMC.
				# Valid shorter refinements can replace it;
				# invalid refinements can no longer overwrite an
				# already successful refinement.

				best_key <- key2
				for (j in seq_along(cuales)) {
					key3 <- key2[Posibles[[cuales[j]]]]
					tokey3 <- as.numeric(names(key3))
					if (is_valid_dmc(key3, tokey3, raw_records, clado, exclusive)) {
						if (length(key3) <= length(best_key)) {
							best_key <- key3
						}
					}
				}
				lista2[[i]] <- best_key
				if (length(best_key) <= minimo && length(best_key) >= minlength) {
					minimo <- length(best_key)
					AltrDNC <- best_key
				}
			}
		}

		# FINAL MAJORITY-CONSENSUS DMC

		rDNC <- build_consensus_dmc(lista2, AltrDNC, raw_records, clado, exclusive)
		if (is.null(rDNC)) {
			rDNC <- AltrDNC
		}
		rDNC <- rDNC[order(as.numeric(names(rDNC)))]
		AltrDNC <- AltrDNC[order(as.numeric(names(AltrDNC)))]

		# FORMAT OUTPUT

		rDNCpropio <- paste(names(rDNC), toupper(rDNC), sep = ": ")
		AltrDNCpropio <- paste(names(AltrDNC), toupper(AltrDNC), sep = ": ")
		rDNCpropio <- paste("[", paste(rDNCpropio, collapse = ", "), "]", sep = "")
		AltrDNCpropio <- paste("[", paste(AltrDNCpropio, collapse = ", "), "]", sep = "")
		PaLaTabla <- cbind(as.character(qTAXA), rDNCpropio, AltrDNCpropio)
		colnames(PaLaTabla) <- c("Species", "DMC", "Alter-DMC")
		TablaFinal <- rbind(TablaFinal, PaLaTabla)
		write.csv(TablaFinal, file = OutName)
	}
	message("100% of the species completed.")
}

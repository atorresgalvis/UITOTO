home <- tabPanel(title = "Home", 
                 value = "home",
                 hr(),
				 htmlOutput('outpt_title'),
                 HTML("<h3><center><b>Center for Integrative Biodiversity Discovery (CIBD)</b></center></h3>"),
                 HTML("<h4><center><b>Museum für Naturkunde - Leibniz Institute for Evolution and Biodiversity Science</b></center></h4>"),
                 br(), br(),
                 column(width = 4, align = "center",
                        tab_Icon(texto = "Find Diagnostic Molecular Combinations (DMCs)", 
                        cor = colores[1], icon = "lupa.png", id = "Search")
                 ),
                 column(width = 4, align = "center",
                        tab_Icon(texto = "Taxonomic verification and identification using DMCs", 
                        cor = colores[2], icon = "adn.png", id = "Identifier")
                        )
				 ,
				 column(width = 4, align = "center",
                        tab_Icon(texto = "Visualize DMCs", 
                        cor = colores[1], icon = "letras.png", id = "Visualizer")
                        )
				 ,
				 br(), br(), br(),
                 column(width = 12,
                        wellPanel(
                          HTML("<h4>Taxonomists generally use techniques to diagnose taxa and identify 
                          species that rely on morphological or anatomical comparisons, especially by 
                          trying to propose primary homology hypotheses. As new species descriptions 
                          require diagnoses, this means for species described with integrative methods 
                          (“integrative taxonomy”) should present diagnoses for all the different 
                          data types. However, many such species descriptions only present the barcode 
                          for the type or consensus sequences for the species; i.e., the descriptions 
                          lack molecular diagnoses. <br>
                          <b>UITOTO</b> is a project composed of different modules for deriving, 
                          testing and visualizing Diagnostic Molecular Combinations (DMCs): <br>
                          <ul>
							<li> The first module (<em>Find Diagnostic Molecular Combinations [DMCs]</em>) 
							is a new method intended to overcome the main technical and algorithmic issues 
							associated with identifying reliable DMCs, focused on high-throughput taxonomy. 
							This method assigns a weight to each site based on the Jaccard index (i.e., 
							the number of sequences in which the site states differ from the site state 
							in the query taxon). Afterward,	it uses a Weighted Random Sampling approach 
							to build the candidate combinations	to become DMCs. 
							At the same time, the method uses a stability measure of the specificity of 
							the candidate combinations to assess their reliability. This measure relies 
							on the minimum number of exclusive character states for each one of the 
							candidate combinations (this number of exclusive character states
							is set by the user). 
							As a final step, with the most frequent sites in the combinations that 
							meet the preceding criterion, the final DMC is built (which must also meet the 
							same criterion). </li>
							<li> The second module (<em>Taxonomic verification and identification using DMCs</em>)
							integrates three different approaches: <em>ALnID</em>, <em>Identifier</em>, and 
							<em>IdentifierU</em>. This comprehensive suite empowers users with flexibility 
							and precision in taxonomic verification and identification, harnessing the 
							potential of Diagnostic Molecular Combinations (DMCs) obtained from the first 
							module or from other software. Remarkably, this module allows using both 
							aligned and unaligned sequences, widening the scope of analysis.
							<ul>
								<li> The <em>ALnID</em> approach unlocks the potential of 
								unaligned sequences. By using pairwise sequence alignment algorithms with 
								customizable settings, users can align the unknown sequences from a FASTA 
								file against the reference sequences utilized to derive the DMCs provided. 
								Subsequently, it behaves similarly to the <em>Identifier</em> 
								approach (see below).
								</li>
								<li> The <em>Identifier</em> approach allows the identification of specimens, 
								leveraging aligned sequences provided in a FASTA file and a pool of DMCs. 
								This approach assigns matching species, employing specific DMC patterns and 
								a user-defined number of mismatches allowed. It generates an output file 
								with the corresponding matches for each unknown specimen.
								</li>
								<li> Finally, the <em>IdentifierU</em> approach follows an alignment-free 
								methodology. Through iterative exploration utilizing a dynamic sliding window, 
								it compares the extracted patterns with each provided DMC pattern. Users can 
								also set a number of mismatches allowed.
								</li>
							</ul>
							</li>
							<li> The third module (<em>Visualize DMCs</em>) 
							allows the visualization of the available DMCs (i.e. The output from the first module or other software). </li> 
                          </ul>
                               </h4>")
                        ),
						actionBttn(inputId = "Presentation", 
							label = "Presentation", 
							style = "fill", 
							color = "success", 
							icon = icon("book"), size = "l"),            
 
                 )
)

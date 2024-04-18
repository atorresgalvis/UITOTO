box_voronoys <- function(texto, cor){
  HTML(paste('<div class = "box_voronoys" style = "border:1px solid', 
             cor, '; background-color: ', 
             cor, ';">', 
             h1(texto), '</div>'))
}

tab_Icon <- function(texto, cor, icon, id){
  HTML(paste0('<a id="', id,'" href="#" class="action-button">
                  <div class = "voronoys-block" style = "background-color:', cor, ';"> 
                  <span class = "name">', texto, '</span>
                  <div class="img_block">
                    <div class="img_block_conteiner">
                      <img src="img/',icon,'">
                    </div>
                  </div>
              </div></a>'))
}

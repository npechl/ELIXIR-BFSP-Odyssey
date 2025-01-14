# Odyssey

Odyssey is an R shiny application for the exploration of Molecular Biodiversity in Greece.


## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)
- [Related_Publications](#related_publications)

## Installation

```r
# Install necessary packages
install.packages("shiny")


```

## Usage
```r
# Run the Shiny app
source("R/libraries.R")
source("R/dataset.R")
source("ui.R")
source("server.R")

shinyApp(ui, server)

```

## Contributing
Your input is invaluable - whether it's suggesting a new chart/analysis or reporting a bug, we welcome and greatly appreciate your feedback! 

Feel free to open a [GitHub issue](https://github.com/npechl/MBioG/issues) or contact us via `inab.bioinformatics@lists.certh.gr`.


## License
This work, as a whole, is licensed under the [MIT license](https://github.com/npechl/MBioG/blob/main/LICENSE).

The code contained in this website is simultaneously available under the MIT license; this means that you are free to use it in your own packages, as long as you cite the source.

## Authors
- [Nikos Pechlivanis](https://github.com/npechl)
- [Natasa Anastasiadou](https://github.com/NatAnastas)

## Related_Publications
- N. Pechlivanis, A. Anastasiadou, A. Papageorgiou, E. Pafilis, and F. Psomopoulos, “Odyssey: an Interactive R Shiny App Approach to explore Molecular Biodiversity in Greece,” **23rd European Conference On Computational Biology (ECCB24)**, Sep. 2024, doi: [10.5281/ZENODO.14186452](https://zenodo.org/records/14186453).

<div align='center'>
<img src="https://github.com/natanast/odyssey/blob/main/pic/ECCB2024_poster.png" alt="ECCB2024 Poster" style="height: 750px; width:550px;"/>
</div>

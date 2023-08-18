TUSCA+
=======
The complementary nature of ANOVA Simultaneous Component Analysis (ASCA) and Tucker3 tensor decompositions (TUSCA+) is demonstrated on designed datasets. We show how ASCA+ [\[1\]](#references) can be used to (a) identify statistically sufficient Tucker3 [\[2\]](#references) models; (b) identify statistically important triads making their interpretation easier; and (c) eliminate non-significant triads making visualization and interpretation simpler. 
ASCA+ code was used from https://github.com/josecamachop/MEDA-Toolbox. 
![abstractfigure](https://github.com/FarnooshKoleini/TUSCA-/assets/99754293/709cce72-d9e7-4174-8e8d-a699efd678bd)

## Setup

### 1. The `ASCA+` toolbox
 * downloading the toolbox from https://github.com/josecamachop/MEDA-Toolbox and add it on the MATLAB path.

### 2. Download tuckals, chstruct, chgraphics packages
  * Download there toolboxes and add them on the path.

## Demo

Download `Blue_Crab_nested_parfor.m` and run the following script to reproduce [3 7 3] tucker3 model and getting the backward elimination results:

`Blue_Crab_nested_parfor.m`

## References

\[1\] Camacho, J., Díaz, C., & Sánchez‐Rovira, P. (2022). Permutation tests for ASCA in multivariate longitudinal intervention studies. Journal of Chemometrics, e3398. 

\[2\] Gemperline, P. J., Miller, K. H., West, T. L., Weinstein, J. E., Hamilton, J. C., & Bray, J. T. (1992). Principal component analysis, trace elements, and blue crab shell disease. Analytical Chemistry (Washington), 64(9), 523A-532A. doi:10.1021/ac00033a719

TUSCA+
=======
The complementary nature of ANOVA Simultaneous Component Analysis (ASCA) and Tucker3 tensor decompositions (TUSCA+) is demonstrated on designed datasets. We show how ASCA can be used to (a) identify statistically sufficient Tucker3 models; (b) identify statistically important triads making their interpretation easier; and (c) eliminate non-significant triads making visualization and interpretation simpler. 
ASCA+ code was used from https://github.com/josecamachop/MEDA-Toolbox. 
![abstractfigure](https://github.com/FarnooshKoleini/TUSCA-/assets/99754293/709cce72-d9e7-4174-8e8d-a699efd678bd)

## Setup

### 1. The `ASCA+` toolbox
 * downloading the toolbox from https://github.com/josecamachop/MEDA-Toolbox and add it on the MATLAB path.

### 2. Download tuckals, chstruct, chgraphics files
  * Download there toolboxes and add them on the path.
  * 
## Demo

Forward pass the randomly created pose and shape parameters from the SMPL layer and display the human body mesh and joints:

`python demo.m`

## Acknowledgements
The code **largely** builds on the [manopth](https://github.com/hassony2/manopth) repository from [Yana Hasson](https://github.com/hassony2), which implements the [MANO](http://mano.is.tue.mpg.de) hand model [\[2\]](#references) layer.

The code is a PyTorch port of the original [SMPL](http://smpl.is.tue.mpg.de) model from [chumpy](https://github.com/mattloper/chumpy). It builds on the work of [Loper](https://github.com/mattloper) et al. [\[1\]](#references).

The code [reuses](https://github.com/gulvarol/smpl/pytorch/rodrigues_layer.py) [part of the code](https://github.com/MandyMo/pytorch_HMR/blob/master/src/util.py) by [Zhang Xiong](https://github.com/MandyMo) to compute the rotation utilities.

If you find this code useful for your research, please cite the original [SMPL](http://smpl.is.tue.mpg.de) publication:

```
@article{SMPL:2015,
    author = {Loper, Matthew and Mahmood, Naureen and Romero, Javier and Pons-Moll, Gerard and Black, Michael J.},
    title = {{SMPL}: A Skinned Multi-Person Linear Model},
    journal = {ACM Trans. Graphics (Proc. SIGGRAPH Asia)},
    number = {6},
    pages = {248:1--248:16},
    volume = {34},
    year = {2015}
}
```

## References

\[1\] Matthew Loper, Naureen Mahmood, Javier Romero, Gerard Pons-Moll, and Michael J. Black, "SMPL: A Skinned Multi-Person Linear Model," SIGGRAPH Asia, 2015.

\[2\] Javier Romero, Dimitrios Tzionas, and Michael J. Black, "Embodied Hands: Modeling and Capturing Hands and Bodies Together," SIGGRAPH Asia, 2017.

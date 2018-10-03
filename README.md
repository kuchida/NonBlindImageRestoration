
# [Non-blind Image Restoration Based on Convolutional Neural Network](https://arxiv.org/abs/1809.03757)

## Contents

**demos**:  demo scripts: `demo_{*}.m`.

**model**:  a model for non-blind image restoration. It is trained with the equivalent training dataset to [DnCNN-3](https://github.com/cszn/DnCNN), but with the true degradation attributions.

**testsets**: datasets: Set5, Set14, and BSD100 are inculuded.

## Execution

1. Install [MatConvNet](http://www.vlfeat.org/matconvnet/).
1. In MATLAB, `>> run matconvnet/matlab/vl_setupnn.m`.
1. Then, Run demo as `>> run demos/demo_{*}.m`.

## Comparison

### DnCNN

To compare with [DnCNN-3](https://github.com/cszn/DnCNN) model,
copy their `model/DnCNN3.mat` to our `model/` directory and change to `useDnCNN = 1;` in the scripts.

<small>
Please note that DnCNN-3 model itself is expected to achieve higher performance if trained directly with perturbed degradations. This comparison is intended to demonstrate that CNN-based model performs poorly on images with untrained degradation model.
</small>

### BM3D

To compare with [BM3D](http://www.cs.tut.fi/~foi/GCF-BM3D/), download their MATLAB software in `bm3d/` directory and change to `useBM3D = 1;` in the scripts.

## Citation

```
@article{uchida2018nonblind,
  title={Non-blind Image Restoration Based on Convolutional Neural Network},
  author={Uchida, Kazutaka and Tanaka, Masayuki and Okutomi, Masatoshi},
  journal={arXiv preprint arXiv:1809.03757},
  year={2018}
}
```

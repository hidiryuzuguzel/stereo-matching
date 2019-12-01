# stereo-matching
Dense disparity estimation via local stereo matching

![diagram](docs/stereo-matching-diagram.JPG)

## Overview
The code implements the local color-weighted disparity estimation algorithm and evaluates its performance on a set of stereo image pairs. The algorithm includes the following steps:

1. Cost function calculation
2. Cost aggregation based on:
    1. Box filtering 
    2. Gaussian filtering
    3. Local color-weighted filtering
3. Winner-takes-all (WTA) disparity estimation
4. Detection of occlusions
5. Computation confidence values for disparity estimates
6. Post-filtering to tackle occlusions and bad pixels (needs map from 4. and 5.)

## Performance Evaluation of the algorithm
- Calculation of BAD quality metric given the true disparity map
- Comparison of the performance of block matching and Gaussian smoothing for different sizes of aggregation windows
- Comparison of local color-weighted filtering against the two others above
- Visual assessment of the effect of occlusion filling

## Results:
- One slice of cost volume

![one_slice_cost_volume](docs/one_slice_cost_volume.JPG)

- Left disparity estimation without aggregation

![left_disp_wo_agg](docs/left_disparity_estimation_wo_aggregation.JPG)

- Left disparity estimation with block aggregation

![left_disp_blk_agg](docs/left_disparity_estimation_block_aggregation.JPG)

- Left disparity estimation with gaussian aggregation

![left_disp_gaussian_agg](docs/left_disparity_estimation_gaussian_aggregation.JPG)

- Comparison of block and gaussian filtering

![cmp_blk_gauss_filtering](docs/compare_blk_gaussian_filtering.JPG)

- Left and right disparity estimation with gaussian aggregation

![cmp_lr_disp_map](docs/compare_left_right_disparity_maps.JPG)

- Left occlusion map

![left_occlusion_map](docs/left_occlusion_map.JPG)

- Left confidence map

![left_confidence_map](docs/left_confidence_map.JPG)

- Left compansated (filled) occlusion map

![left_occlusion_map_filled](docs/left_occlusion_map_filled.JPG)

- Comparison of color-weighted aggregation and the others

![cmp_colorweighted_filtering](docs/compare_blk_gaussian_colorweighted_agg.JPG)

- Left disparity estimation with color-weighted aggregation

![left_disp_colorweighted](docs/left_disparity_estimation_colorweighted.JPG)


for %%d in (iris, wine, sonar.all, glass, ecoli, ionosphere, spectrometer, breast-cancer-wisconsin, pima-indians-diabetes, statlog-vehicle, vowel-context, yeast, image-segmentation, optdigits, statlog-satimage, pendigits) do (
	for /l %%k in (1, 1, 200) do RScript --vanilla Clustering.Experiments.UI.R -o results\sensitivityTest_km_%%d_svm_result.csv -d "%%d" -c "svmLinear" -a "km" -k %%k -n TRUE
)

%for %%d in (magic, letter) do (
%	for /l %%k in (1, 1, 400) do RScript --vanilla Clustering.Experiments.UI.R -o results\sensitivityTest_km_%%d_svm_result.csv -d "%%d" -c "svmLinear" -a "km" -k %%k -n TRUE
%)

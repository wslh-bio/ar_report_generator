#!/bin/bash

./render_report.R \
'Test Project' \
'Person One' \
test_data/samples.csv \
ar_report_config.yaml \
--snpmatrix test_data/snp_distance_matrix.tsv \
--tree test_data/core_genome.tree \
--cgstats test_data/core_genome_statistics.txt \
--artable test_data/ar_predictions.tsv \
--additionaldatatables test_data/*.mash.tsv

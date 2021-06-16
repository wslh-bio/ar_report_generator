#!/bin/bash

./render_report.R \
'Test Project' \
'Person One' \
test_data/samples.csv \
ar_report_config.yaml \
--snpmatrix test_data/snp_distance_matrix.tsv \
--tree test_data/core_genome.tree

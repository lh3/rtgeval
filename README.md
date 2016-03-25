## Getting Started

```sh
wget -O- https://github.com/lh3/rtgeval/releases/download/v0.1/rtgevalkit-0.1_x64-linux.tar.bz2 | tar -jxf -
[ -d ref.sdf ] || rtgeval.kit/rtg format -o ref.sdf ref.fa  # create RTG index
rtgeval.kit/run-eval -s ref.sdf -b confident.bed truth.vcf.gz test.vcf.gz
cat test.re.eval
```
where `confident.bed` gives confident regions, `truth.vcf.gz` the truth VCF and
`test.vcf.gz` the VCF to evaluate. `test.re.eval` gives the true positives
(TP), false negatives (FN) and false positives (FP) measured in three ways,
which will be explained below.

For the CHM1-CHM13 benchmark data, it is recommended to invoke `rtgeval` with
```sh
rtgeval.kit/run-eval -s ref.sdf -b conf.bed -l2 -L100 -h hrun.bed truth.vcf test.vcf
```
This ignores 1bp INDELs and homopolymer INDELs.

## Introduction

This repo implements a wrapper for [RTG's vcfeval][vcfeval], a sophisticated
open source variant comparison tool developed by [Realtime Genomics][rtg]. It
simplifies the use of `vcfeval` and potentially helps to get consistent results
given VCFs produced by different variant callers.

The wrapper calls [bgt][bgt] to decompose complex and multi-allelic variants to
the smallest possible alleles, optionally filters each allele and regroups
overlapping multi-alleles into one VCF line (apparently `rtg vcfeval` works
better this way). The wrapper then calls [hapdip][hapdip] and `rtg` to perform
three types of evaluations:

1. Positional. With this approach, a TN is a true variant that is within 10bp
   around a called variant; a FN is a true variant that is not within 10bp; a
   FP is a called variant that is not within 10bp around a true variant. FN
   and FP intervals can be found in `PREFIX.de-fnp.bed.gz`.

2. Allelic. The wrapper calls `rtg vcfeval --squash-ploidy`. For biallelic
   variants, this type of evaluation measures if an allele from one VCF is
   confirmed in the other VCF, disregarding genotypes. The behavior for
   multi-allelic variants is unclear. FN and FP calls are reported in
   `PREFIX.vea/f?.vcf.gz`.

3. Genotypic. The wrapper calls `rtg vcfeval`. Genotype errors are also
   counted. This is the most stringent type of evaluation. False calls are
   reported in `PREFIX.veg/f?.vcf.gz`.

[rtg]: http://www.realtimegenomics.com
[bgt]: https://github.com/lh3/bgt
[vcfeval]: http://realtimegenomics.com/products/rtg-tools/
[hapdip]: https://github.com/lh3/hapdip

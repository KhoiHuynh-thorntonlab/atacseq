#!/bin/bash
module load bedtools

###
## bam.justbampe.final.narrowPeak is final averaged and union peak file
####
awk -F $'\t' 'BEGIN {OFS = FS}{ print $1,$2 + $10}' bam.justbampe.final.narrowPeak > delete.txt

awk -F $'\t' 'BEGIN {OFS = FS}{ if($1 == "chr3R" && $2 > 4552934 && $2 < 31845060) print $0}' delete.txt > delete2.txt

awk -F $'\t' 'BEGIN {OFS = FS}{ if($1 == "chrX" && $2 > 277911 && $2 < 22628490) print $0}' delete.txt >> delete2.txt

awk -F $'\t' 'BEGIN {OFS = FS}{ if($1 == "chr3L" && $2 > 158639 && $2 < 22962476 ) print $0}' delete.txt >> delete2.txt

awk -F $'\t' 'BEGIN {OFS = FS}{ if($1 == "chr2L" && $2 > 82455 && $2 < 22011009 ) print $0}' delete.txt >> delete2.txt

awk -F $'\t' 'BEGIN {OFS = FS}{ if($1 == "chr2R" && $2 > 5398184 && $2 < 24684540 ) print $0}' delete.txt >> delete2.txt


awk 'BEGIN{OFS=FS="\t"}{print $1,$2,$2+1}' delete2.txt > delete3.txt

bedtools intersect -v -a delete3.txt -b /dfs5/bio/khoih/overlap.SV.bed > delete4.txt



#####
# generate reference file that has chromsome and peak summit for anova steps
#####
awk 'BEGIN{OFS=FS="\t"}{print $1,$2}' delete4.txt | sort -k 1,1 -k2,2n > ref.txt

rm delete*.txt

#####
## generate reference range for CLmatrix.sh
####

awk 'BEGIN{OFS=FS="\t"}{print $1,$2,$3} delete2.txt > delete5.txt
bedtools intersect -v -a delete5.txt -b /dfs5/bio/khoih/overlap.SV.bed > delete6.txt

while IFS= read -r line
do
  var1=$(echo "$line" | cut -f 2)
  var2=$(echo "$line" | cut -f 3)
  var3=$(echo "$line" | cut -f 1)
  for i in $(seq $var1 $var2); do
        j=`expr $i + 1`
        echo "$var3     $i      $j" >> final.bed;
  done
done < delete6.txt


sort -k 1,1 -k2,2n final.bed > final2.bed


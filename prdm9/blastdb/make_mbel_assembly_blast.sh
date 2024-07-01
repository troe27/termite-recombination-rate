fasta='./New_Mbel_no_comma.fa'

# sed 's/,/_/g' New_Mbel.fa > ./New_Mbel_no_comma.fa

makeblastdb -in $fasta  -parse_seqids -blastdb_version 5  -title "Mbel_assembly" -dbtype nucl -out Mbeldb_assembly

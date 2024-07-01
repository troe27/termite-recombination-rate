fasta='./transcriptome.fasta'

makeblastdb -in $fasta  -parse_seqids -blastdb_version 5  -title "Mbel_transcript" -dbtype nucl -out Mbeldb


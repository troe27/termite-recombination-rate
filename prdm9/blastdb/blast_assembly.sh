n_threads=20
queryprot=./all_bhits.fna
db=mbeldb/Mbeldb_assembly
outfile=./blast_hits_assembly

blastn -query $queryprot -db $db -num_threads $n_threads -out $outfile -evalue 1e-5

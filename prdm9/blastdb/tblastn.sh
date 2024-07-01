n_threads=8
queryprot=./prot_sub_domains.faa
db=mbeldb/Mbeldb
outfile=./blast_hits_ssxrd_krab

tblastn -query $queryprot -db $db -num_threads $n_threads -out $outfile -evalue 1e-5
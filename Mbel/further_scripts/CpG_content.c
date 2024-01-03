#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
    int wind_size = 100000;
    int i, j, ii, a_count, t_count, g_count, c_count, cpg_count, x_count, lower_case, upper_case, tot_count, print_done=0, eol_count=0;
    double a_frac, t_frac, g_frac, c_frac, x_frac, upper_frac, lower_frac, cpg_exp, cpg_obs_exp;
    FILE *fasta, *out_file;
    char base_char, base_char_previous, contig_name[200], out_file_name[200];
    /*fasta = fopen("/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/New_Mbel.fa", "r");*/
    fasta = fopen("/proj/snic2021-23-365/private/termite_analysis/Mbel/ref_genome_mod_contig_names/annotation/hifiasm_repeatmasker/hifiasm_scaff10x_arks.fa.masked_underscore", "r");
    if (fasta == NULL){
      fprintf(stderr, "Can't open fasta-file!\n");
      exit(1);
    }
    sprintf(out_file_name, "Mbel_per_base_content_wind_%db_repeatmask_xcount.txt", wind_size);
    out_file = fopen(out_file_name, "w");
    fprintf(out_file,"contig\ta_frac\tt_frac\tg_frac\tc_frac\tx_count\tlower_frac\tupper_frac\ttot_count\tcpg_count\tcpg_exp\tcpg_obs_exp\n");
    while ((base_char=fgetc(fasta)) && base_char != EOF){
        /*printf("base_char=%c",base_char);*/
        a_count=0;
        t_count=0;
        g_count=0;
        c_count=0;
	cpg_count=0;
        x_count=0;
        lower_case=0;
        upper_case=0;
        while (base_char == '\n') {eol_count++; base_char=fgetc(fasta);}
        while (base_char=='>') {
            /*fprintf(out_file,"%c",base_char);
            while ((base_char=fgetc(fasta)) && base_char != '\n') {
                fprintf(out_file,"%c",base_char);
            }*/
            for (ii=0;ii<200;ii++){contig_name[ii]='\0';}
            j=0;
            while ((base_char=fgetc(fasta)) && base_char != ' ' && base_char != '_' && base_char != '\n') {
                contig_name[j] = base_char;
                j++;
            }
            while (base_char != '\n'){
                base_char=fgetc(fasta);
            }
            eol_count++;
            /*fprintf(out_file,"\n");*/
            base_char=fgetc(fasta);
            if (base_char==EOF){
                fclose(fasta);
                fclose(out_file);
                printf("EOL=%d\n",eol_count);
                return 0;
            }
        }
        if (base_char=='a') {a_count++; lower_case++;}
        else if (base_char=='t') {t_count++; lower_case++;}
        else if (base_char=='g') {g_count++; lower_case++;}
        else if (base_char=='c') {c_count++; lower_case++;}
        else if (base_char=='A') {a_count++; upper_case++;}
        else if (base_char=='T') {t_count++; upper_case++;}
        else if (base_char=='G') {g_count++; upper_case++;}
        else if (base_char=='C') {c_count++; upper_case++;}
        else {x_count++;}
        for (i=1;i<wind_size;i++){
	    base_char_previous = base_char;
            base_char=fgetc(fasta);
            while (base_char == '\n') {eol_count++; base_char=fgetc(fasta);}
            if (base_char != EOF){
                if (base_char=='>') {
                    tot_count = lower_case + upper_case + x_count;
                    a_frac = (double)a_count/tot_count;
                    t_frac = (double)t_count/tot_count;
                    g_frac = (double)g_count/tot_count;
                    c_frac = (double)c_count/tot_count;
                    x_frac = (double)x_count/tot_count;
                    lower_frac = (double)lower_case/tot_count;
                    upper_frac = (double)upper_case/tot_count;
	    	    cpg_exp = (double)(g_count*c_count)/tot_count;
	    	    cpg_obs_exp = (double)cpg_count/cpg_exp;
            	    fprintf(out_file, "%s\t%f\t%f\t%f\t%f\t%d\t%f\t%f\t%d\t%d\t%f\t%f\n", contig_name, a_frac, t_frac, g_frac, c_frac, x_count, lower_frac, upper_frac, tot_count, cpg_count, cpg_exp, cpg_obs_exp);
                    for (ii=0;ii<200;ii++){contig_name[ii]='\0';}
                    j=0;
                    while ((base_char=fgetc(fasta)) && base_char != ' ' && base_char != '_' && base_char != '\n') {
                      contig_name[j] = base_char;
                      j++;
                    }
                    while (base_char != '\n'){
                        base_char=fgetc(fasta);
                    }
                    /*fprintf(out_file,"%c",base_char);
                    while ((base_char=fgetc(fasta)) && base_char != '\n') {
                        fprintf(out_file,"%c",base_char);
                    }*/
                    eol_count++;
                    /*fprintf(out_file,"\n");*/
                    print_done=1;
                    break;
                }
                else {
                    if (base_char=='a') {a_count++; lower_case++;}
                    else if (base_char=='t') {t_count++; lower_case++;}
                    else if (base_char=='g') {
			g_count++; 
			lower_case++;
			if (base_char_previous=='c' || base_char_previous=='C'){
				cpg_count++;
			}
		    }
                    else if (base_char=='c') {c_count++; lower_case++;}
                    else if (base_char=='A') {a_count++; upper_case++;}
                    else if (base_char=='T') {t_count++; upper_case++;}
                    else if (base_char=='G') {
			g_count++; 
			upper_case++;
			if (base_char_previous=='c' || base_char_previous=='C'){
				cpg_count++;
			}
		    }
                    else if (base_char=='C') {c_count++; upper_case++;}
                    else {x_count++;}
                }
            }
            else {
                tot_count = lower_case + upper_case + x_count;
                a_frac = (double)a_count/tot_count;
                t_frac = (double)t_count/tot_count;
                g_frac = (double)g_count/tot_count;
                c_frac = (double)c_count/tot_count;
                x_frac = (double)x_count/tot_count;
                lower_frac = (double)lower_case/tot_count;
                upper_frac = (double)upper_case/tot_count;
		cpg_exp = (double)(g_count*c_count)/tot_count;
		cpg_obs_exp = (double)cpg_count/cpg_exp;
                fprintf(out_file, "%s\t%f\t%f\t%f\t%f\t%d\t%f\t%f\t%d\t%d\t%f\t%f\n", contig_name, a_frac, t_frac, g_frac, c_frac, x_count, lower_frac, upper_frac, tot_count, cpg_count, cpg_exp, cpg_obs_exp);
                fclose(fasta);
                fclose(out_file);
                printf("EOL=%d\n",eol_count);
                return 0;
            }
        }
        if (print_done == 0){
            tot_count = lower_case + upper_case + x_count;
            a_frac = (double)a_count/tot_count;
            t_frac = (double)t_count/tot_count;
            g_frac = (double)g_count/tot_count;
            c_frac = (double)c_count/tot_count;
            x_frac = (double)x_count/tot_count;
            lower_frac = (double)lower_case/tot_count;
            upper_frac = (double)upper_case/tot_count;
	    cpg_exp = (double)(g_count*c_count)/tot_count;
	    cpg_obs_exp = (double)cpg_count/cpg_exp;
            fprintf(out_file, "%s\t%f\t%f\t%f\t%f\t%d\t%f\t%f\t%d\t%d\t%f\t%f\n", contig_name, a_frac, t_frac, g_frac, c_frac, x_count, lower_frac, upper_frac, tot_count, cpg_count, cpg_exp, cpg_obs_exp);
        }
        else {
            print_done = 0;
        }
    }
    printf("EOL=%d\n",eol_count);
    fclose(fasta);
    fclose(out_file);
    return 0;
} 


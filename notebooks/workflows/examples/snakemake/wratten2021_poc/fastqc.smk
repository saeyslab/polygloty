rule fastqc:
    input:
        get_fastqs,
    output:
        directory("results/fastqc/{sample}"),
    log:
        "logs/fastqc/{sample}.log",
    conda:
        "envs/fastqc.yaml"
    params:
        "--quiet --outdir",
    shell:
        "mkdir {output}; fastqc {input} {params} {output} 2> {log}"
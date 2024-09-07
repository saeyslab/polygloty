version 1.0

# ... license ...

task Fastqc {
    input {
        File seqFile
        String outdirPath
        Boolean casava = false
        ## ... other arguments ...

        # Set javaXmx a little high.
        String javaXmx="1750M"
        Int threads = 1
        String memory = "2GiB"
        Int timeMinutes = 1 + ceil(size(seqFile, "G")) * 4
        String dockerImage = "quay.io/biocontainers/fastqc:0.12.1--hdfd78af_0"

        Array[File]? noneArray
        File? noneFile
    }

    # Chops of the .gz extension if present.
    String name = basename(sub(seqFile, "\.gz$",""))
    # This regex chops of the extension just as fastqc does it.
    String reportDir = outdirPath + "/" + sub(name, "\.[^\.]*$", "_fastqc")

    # We reimplement the perl wrapper here. This has the advantage that it
    # gives us more control over the amount of memory used.
    command <<<
        set -e
        mkdir -p "~{outdirPath}"
        FASTQC_DIR="/usr/local/opt/fastqc-0.12.1"
        export CLASSPATH="$FASTQC_DIR:$FASTQC_DIR/sam-1.103.jar:$FASTQC_DIR/jbzip2-0.9.jar:$FASTQC_DIR/cisd-jhdf5.jar"
        java -Djava.awt.headless=true -XX:ParallelGCThreads=1 \
        -Xms200M -Xmx~{javaXmx} \
        ~{"-Dfastqc.output_dir=" + outdirPath} \
        ~{true="-Dfastqc.casava=true" false="" casava} \
        # ... other arguments ...
        ~{"-Dfastqc.kmer_size=" + kmers} \
        ~{"-Djava.io.tmpdir=" + dir} \
        uk.ac.babraham.FastQC.FastQCApplication \
        ~{seqFile}
    >>>

    output {
        File htmlReport = reportDir + ".html"
        File reportZip = reportDir + ".zip"
        File? summary = if extract then reportDir + "/summary.txt" else noneFile
        File? rawReport = if extract then reportDir + "/fastqc_data.txt" else noneFile
        Array[File]? images = if extract then glob(reportDir + "/Images/*.png") else noneArray
    }

    runtime {
        cpu: threads
        memory: memory
        time_minutes: timeMinutes
        docker: dockerImage
    }

    parameter_meta {
        # inputs
        seqFile: {description: "A fastq file.", category: "required"}
        outdirPath: {description: "The path to write the output to.", catgory: "required"}
        # ... other arguments ...
        dockerImage: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.", category: "advanced"}

        # outputs
        htmlReport: {description: "HTML report file."}
        reportZip: {description: "Source data file."}
        summary: {description: "Summary file."}
        rawReport: {description: "Raw report file."}
        images: {description: "Images in report file."}
    }

    meta {
        WDL_AID: {
            exclude: ["noneFile", "noneArray"]
        }
    }
}

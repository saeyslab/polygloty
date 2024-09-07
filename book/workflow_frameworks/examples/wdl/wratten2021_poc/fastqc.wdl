task FastQCone {
  input {
     File reads
  }

  command {
     zcat "${reads}" | fastqc stdin:readsone
  }

  output {
	 File fastqc_res = "readsone_fastqc.html"
  }
  
  runtime {
     docker: 'pegi3s/fastqc'
  }
}

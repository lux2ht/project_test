nextflow.enable.dsl = 2

workflow {
  Channel.fromPath(params.fq1)
         .ifEmpty { error "Input file not found: ${params.fq1}" }
         .set { reads }

  def (zips, htmls) = fastqc(reads)
  multiqc(zips)
}


process fastqc {
  tag "$fq"

  input:
  path fq

  output:
  tuple path("*.zip"), path("*.html")

  publishDir "results/fastqc", mode: 'copy'

  script:
  """
  fastqc $fq
  """
}

process multiqc {
  input:
  path fastqc_reports

  output:
  path "multiqc_report.html"

  publishDir "results/multiqc", mode: 'copy'

  script:
  """
  multiqc .
  """
}
#!/usr/bin/env nextflow 

/* 
 * Copyright (c) 2020-2021, Seqera Labs 
 * Copyright (c) 2013-2019, Centre for Genomic Regulation (CRG).
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. 
 * 
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0.
 */

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 *
 * Authors:
 * - Paolo Di Tommaso <paolo.ditommaso@gmail.com>
 * - Emilio Palumbo <emiliopalumbo@gmail.com>
 * - Evan Floden <evanfloden@gmail.com>
 */

/* 
 * enables modules 
 */
nextflow.enable.dsl = 2

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */

params.reads = "$baseDir/data/ggal/ggal_gut_{1,2}.fq"
params.transcriptome = "$baseDir/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
params.outdir = "results"
params.multiqc = "$baseDir/multiqc"

log.info """\
 R N A S E Q - N F   P I P E L I N E
 ===================================
 transcriptome: ${params.transcriptome}
 reads        : ${params.reads}
 outdir       : ${params.outdir}
 """

// import modules
include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

/* 
 * main script flow
 */
workflow {
  read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true ) 
  RNASEQ( params.transcriptome, read_pairs_ch )
  MULTIQC( RNASEQ.out, params.multiqc )
}

/* 
 * completion handler
 */
workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
    println "new"
    log.info("Hello")
    log.info ( """\
    Pipeline execution summary
    ---------------------------
    Script Id   : ${workflow.scriptId}
    ScriptName  : ${workflow.scriptName}
    Scriptfile  : ${workflow.scriptFile}
    Repsoitory  : ${workflow.repository}
    Commit ID   : ${workflow.commitId}
    Revision    : ${workflow.revision}
    ProjectDir  : ${workflow.projectDir}
    LaunchDir   : ${workflow.launchDir}
    Workdir     : ${workflow.workDir}
    Homedir     : ${workflow.homeDir}
    userName    : ${workflow.userName}
    Config files : ${workflow.configFiles}
    Docker image : ${workflow.container}
    Container Engine  : ${workflow.containerEngine}
    commandline : ${workflow.commandLine}
    profile     : ${workflow.profile}
    Run name    : ${workflow.runName}
    session Id  : ${workflow.sessionId}
    Resume      : ${workflow.resume}
    Stub-RUn Execution : ${workflow.stubRun}
    Start Time  : ${workflow.start}
    Manifest    : ${workflow.manifest}
    Completed at: ${workflow.complete}
    Duration    : ${workflow.duration}
    Success     : ${workflow.success}
    workDir     : ${workflow.workDir}
    exit status : ${workflow.exitStatus}
    Error report: ${workflow.errorReport ?: '-'}

    """
    .stripIndent())
    
    
}

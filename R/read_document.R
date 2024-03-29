#' Generic Function to Read in a Document
#'
#' Generic function to read in a .pdf, .txt, .html, .rtf, .docx, or .doc file.
#'
#' @param file The path to the a .pdf, .txt, .html, .rtf, .docx, or .doc file.
#' @param skip The number of lines to skip.
#' @param remove.empty logical.  If `TRUE` empty elements in the vector are
#' removed.
#' @param trim logical.  If `TRUE` the leading/training white space is
#' removed.
#' @param combine logical.  If `TRUE` the vector is concatenated into a
#' single string via [textshape::combine()].
#' @param format For .doc files only.  Logical.  If `TRUE` the output will
#' keep doc formatting (e.g., bold, italics, underlined).  This corresponds to
#' the \code{-f} flag in **antiword**.
#' @param ocr logical.  If `TRUE` .pdf documents with a non-text pull using
#' [pdftools::pdf_text()][pdftools::pdftools] will be re-run using OCR via the
#' [tesseract::ocr()] function.  This will create temporary .png
#' files and will require a much larger compute time.
#' @param ... Other arguments passed to [read_pdf()],
#' [read_html()], [read_docx()], [read_doc()], or [base::readLines()].
#' @return Returns a [base::list()] of string [base::vector()]s.
#' @export
#' @examples
#' ## .pdf
#' pdf_doc <- system.file("docs/rl10075oralhistoryst002.pdf",
#'     package = "textreadr")
#' read_document(pdf_doc)
#'
#' ## .html
#' html_doc <- system.file("docs/textreadr_creed.html", package = "textreadr")
#' read_document(html_doc)
#'
#' ## .docx
#' docx_doc <- system.file("docs/Yasmine_Interview_Transcript.docx",
#'     package = "textreadr")
#' read_document(docx_doc)
#'
#' ## .doc
#' doc_doc <- system.file("docs/Yasmine_Interview_Transcript.doc",
#'     package = "textreadr")
#' read_document(doc_doc)
#'
#' ## .txt
#' txt_doc <- system.file('docs/textreadr_creed.txt', package = "textreadr")
#' read_document(txt_doc)
#' 
#' ## .pptx 
#' pptx_doc <- system.file('docs/Hello_World.pptx', package = "textreadr")
#' read_document(pptx_doc)
#' 
#' ## .rtf
#' \dontrun{
#' rtf_doc <- download(
#'     'https://raw.githubusercontent.com/trinker/textreadr/master/inst/docs/trans7.rtf'
#' )
#' read_document(rtf_doc)
#' }
#' 
#' \dontrun{
#' ## URLs
#' read_document('http://www.talkstats.com/index.php')
#' }
read_document <- function(file, skip = 0, remove.empty = TRUE, trim = TRUE,
    combine = FALSE, format = FALSE, ocr = TRUE, ...){

    filetype <- tools::file_ext(file)
        
    if (!filetype %in% c('pdf', 'docx', 'doc',  'rtf', 'html', 'txt', 'pptx') && grepl('^([fh]ttp)', file)){
        filetype <- 'html'
    } else {
     
        filetype <- ifelse(filetype %in% c('php', 'htm'), 'html', filetype)
    }

    fun <- switch(filetype,
        pdf = {function(x, ...) {read_pdf(x, remove.empty = FALSE, trim = FALSE, ocr = ocr, ...)[["text"]]}},
        docx = {function(x, ...) {read_docx(x, remove.empty = FALSE, trim = FALSE, ...)}},
        odt = {function(x, ...) {read_odt(x, remove.empty = FALSE, trim = FALSE, ...)}},        
        doc = {function(x, ...) {read_doc(x, remove.empty = FALSE, trim = FALSE, format=format, ...)}},
        rtf = {function(x, ...) {read_rtf(x, remove.empty = FALSE, trim = FALSE, ...)}},
        html = {function(x, ...) {read_html(x, remove.empty = FALSE, trim = FALSE, ...)}},
        xml = {function(x, ...) {read_xml(x, remove.empty = FALSE, trim = FALSE, ...)}},        
        txt = {function(x, ...) {suppressWarnings(readLines(x, ...))}},
        pptx = {function(x, ...) {read_pptx(x, remove.empty = FALSE, trim = FALSE, ...)[["text"]]}},
        {function(x, ...) {suppressWarnings(readLines(x, ...))}}
    )

    out <- try(fun(file, ...), silent = TRUE)
    if (inherits(out, 'try-error')) return(NULL)

    ## formatting
    if (isTRUE(remove.empty)) out <- out[!grepl("^\\s*$", out)]
    if (skip > 0) out <- out[-seq(skip)]
    if (isTRUE(trim)) out <- trimws(out)
    if (length(out) == 0) out <- ''
    

    if (isTRUE(combine)) out <- textshape::combine(out)
    out

}

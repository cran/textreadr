#' Coerce Text toTranscripts Into R
#'
#' Coerce text into a transcript.
#'
#' @param text Character string: if file is not supplied and this is, then data
#' are read from the value of text. Notice that a literal string can be used to
#' include (small) data sets within R code.
#' @param person.regex A capturing regex describing what is a person portion of
#' a string.
#' @param col.names  A character vector specifying the column names of the
#' transcript columns.
#' @param text.var A character string specifying the name of the text variable
#' will ensure that variable is classed as character.  If `NULL`
#' [read_transcript()] attempts to guess the text.variable
#' (dialogue).
#' @param merge.broke.tot logical.  If `TRUE` and if the file being read in
#' is .docx with broken space between a single turn of talk read_transcript
#' will attempt to merge these into a single turn of talk.
#' @param header logical.  If `TRUE` the file contains the names of the
#' variables as its first line.
#' @param dash A character string to replace the en and em dashes special
#' characters (default is to remove).
#' @param ellipsis A character string to replace the ellipsis special characters.
#' @param quote2bracket logical. If `TRUE` replaces curly quotes with curly
#' braces (default is `FALSE`).  If `FALSE` curly quotes are removed.
#' @param rm.empty.rows logical.  If `TRUE`
#' [read_transcript()]  attempts to remove empty rows.
#' @param na A character string to be interpreted as an `NA` value.
#' @param sep The field separator character. Values on each line of the file are
#' separated by this character.  The default of `NULL` instructs
#' [read_transcript()] to use a separator suitable for the file
#' type being read in.
#' @param skip Integer; the number of lines of the data file to skip before
#' beginning to read data.
#' @param comment.char A character vector of length one containing a single
#' character or an empty string. Use `""` to turn off the interpretation of
#' comments altogether.
#' @param max.person.nchar The max number of characters long names are expected
#' to be.  This information is used to warn the user if a separator appears beyond
#' this length in the text.
#' @param ... Further arguments to be passed to [utils::read.table()],
#' [readxl::read_excel()], or [read_doc()].
#' @return Returns a dataframe of dialogue and people.
#' @export
#' @examples
#' ## EXAMPLE 1
#' as_transcript("34    The New York Times reports a lot of words here.
#' 12    Greenwire reports a lot of words.
#' 31    Only three words.
#'  2    The Financial Times reports a lot of words.
#'  9    Greenwire short.
#' 13    The New York Times reports a lot of words again.",
#'     col.names = c("NO", "ARTICLE"), sep = "   ")
#'
#' ## EXAMPLE 2
#' as_transcript("34..    The New York Times reports a lot of words here.
#' 12..    Greenwire reports a lot of words.
#' 31..    Only three words.
#'  2..    The Financial Times reports a lot of words.
#'  9..    Greenwire short.
#' 13..    The New York Times reports a lot of words again.",
#'     col.names = c("NO", "ARTICLE"), sep = "\\.\\.")
#'
#' ## EXAMPLE 3
#' as_transcript("JAKE The New York Times reports a lot of words here.
#' JIM Greenwire reports a lot of words.
#' JILL Only three words.
#' GRACE The Financial Times reports a lot of words.
#' JIM Greenwire short.
#' JILL The New York Times reports a lot of words again.",
#'    person.regex = '(^[A-Z]{3,})'
#' )
as_transcript <- function(text, person.regex = NULL, col.names = c("Person", "Dialogue"), text.var = NULL, merge.broke.tot = TRUE,
    header = FALSE, dash = "", ellipsis = "...", quote2bracket = FALSE,
    rm.empty.rows = TRUE, na = "", sep = NULL, skip = 0, comment.char = "",
    max.person.nchar = 20, ...) {

    if (!is.null(person.regex)){
        sep <- ":"
        text <- unlist(strsplit(text, '\n'))
        text <- paste(gsub(person.regex, '\\1:', text, perl = TRUE), collapse = "\n")
    }

    suppressWarnings(read_transcript(col.names = col.names, text.var = text.var, merge.broke.tot = merge.broke.tot,
        header = header, dash = dash, ellipsis = ellipsis, quote2bracket = quote2bracket,
        rm.empty.rows = rm.empty.rows, na = na, sep = sep, skip = skip, text =text,
        comment.char = comment.char, max.person.nchar = max.person.nchar, ...))

}

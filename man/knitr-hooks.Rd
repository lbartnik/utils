% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/knitr.R
\name{ansi_handler}
\alias{ansi_handler}
\alias{create_trimming_hook}
\title{Callbacks for knitr.}
\usage{
ansi_handler(x, options)

create_trimming_hook(output_hook)
}
\arguments{
\item{x}{Text snippet.}

\item{options}{options.}

\item{output_hook}{\code{knitr}'s output hook used to print the
transformed output.}
}
\description{
\code{ansi_handler} converts ANSI color codes to HTML tags;
this is the callback for \code{knitr}, see \link{ansi_to_html} for the actual
implementation.

\code{create_trimming_hook} Creates an output callback
function (hook) for \code{knitr}. When registered, it gets triggered by
the \code{output.lines} option passed in a \code{knitr}'s code snippet. See this
\href{https://stackoverflow.com/questions/23114654/knitr-output-hook-with-an-output-lines-option-that-works-like-echo-26}{Stack Overflow}
question for more details.
}
\examples{
\dontrun{
knitr::knit_hooks$set(output = ansi_handler)
knitr::knit_hooks$set(message = ansi_handler)
}
\dontrun{
output_hook <- knit_hooks$get("output")
trimming_hook <- create_trimming_hook(output_hook)
knit_hooks$set(output = trimming_hook)
}
}
\seealso{
ansi_to_html
}

# Create question list from SCTA project file

This simple script converts a SCTA project file into a LaTeX formatted table of
the questions.

The returned tabled is formatted using the latex packages `tabu` and `booktabs`,
which generally is perceived to produce agreeable table results. The table is
written as a `longtable` so it will be able to span several pages with
appropriate headers and footers.

For an example of what the output may look like,
see [examples/output.pdf](examples/output.pdf).

Note that this does not create a tex file that compiles on its own. It is
designed to create output that can be included in an already existing tex
document, so you will have to make your own preablem, `\begin{document}` etc.

## Installation

To use the script, download or clone it and convert you XML-files with some XML
processor. [Saxon](http://saxon.sourceforge.net/) is one possibility (on macOS
you can also install it using `brew install saxon` if you
use [homebrew](https://homebrew.io)).

I simple conversion example:
```bash
saxon -s:<path to projectfile> -xsl:question-list.xslt
```


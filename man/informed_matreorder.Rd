% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/informed_matreorder.R
\name{informed_matreorder}
\alias{informed_matreorder}
\title{Infer longitudinal hierarchy using informed matrix reordering}
\usage{
informed_matreorder(
  contestants,
  convention,
  n = 50,
  shuffles = 10,
  require.corroboration = FALSE,
  initial.ranks = NULL,
  interactions
)
}
\arguments{
\item{contestants}{A dataframe with the identities of the contestants for 
                   each study period along with the relevant data for 
                   adding them to the hierarchy. There should be one row per
                   contestant per study period.
                   Periods should appear in chronological order.
                   The dataframe should contain the following columns: 
                   \describe{
                     \item{period}{Study period.}
                     \item{id}{Identity of contestant.}
                     \item{convention1}{The primary convention by which new
                     individuals are added to the hierarchy. Interpretation
                     of this column varies depending on the value of the 
                     \strong{convention} argument.}
                     \item{convention2}{Optional. The secondary data for 
                     resolving ties in convention1. Interpretation
                     of this column varies depending on the value of the 
                     \strong{convention} argument.}
}}

\item{convention}{A flag determining how new individuals are added to the
hierarchy. The value of this flag influences how the convention1
and convention2 columns of the contestants argument are interpreted.
Currently this function supports four options:
\describe{
 \item{mri}{New contestants are added to the hierarchy
 according to maternal rank inheritance with youngest
 ascendancy. \strong{convention1} should be a vector of 
 mother identities for each contestant. \strong{convention2}
 should be an optional vector of intra-litter ranks (lower 
 numbers = higher rank) for resolving the order of 
 contestants from the same mother
 joining the hierarchy in the same study period.}
 \item{tenure}{New contestants are added to the hierarchy
 according their tenure in the group. \strong{convention1} should be a vector of 
 dates on which each contestant joined the group. \strong{convention2} should be an
 optional vector of numerical data for resolving ties
 in convention1 (e.g., body size). Higher values are 
 considered higher rank.}
 \item{age}{New contestants are added to the hierarchy
 according their age (older = higher rank).
 \strong{convention1} should be a vector of birthdates or 
 numerical age classes. \strong{convention2} should be an
 optional vector of numerical data for resolving ties
 in convention1 (e.g., body size). Higher values are 
 considered higher rank.}
 \item{phys_attr}{New contestants are added to the hierarchy
 according to some physical attribute (larger value = higher rank). 
 \strong{convention1} should be a vector of numerical attribute
 measurements. \strong{convention2} should be an
 optional vector of numerical data for resolving ties
 in convention1. Higher values are 
 considered higher rank.}
}}

\item{n}{Number of separate reordering attempts per study period. Recommended 100.}

\item{shuffles}{Number of reshuffling steps per reordering attempt. Recommended at least 10.}

\item{require.corroboration}{A logical indicating whether to require corroborating
evidence from multiple study periods before changing a contestant's position
in the order. Useful for reducing the sensitivity of the method to aberrant
observations that don't reflect a lasting change in the true latent hierarchy.
If true, evidence indicating a change in status must be corroborated by
an additional observation in the following periods. See Strauss & Holekamp
(in revision) for full details.}

\item{initial.ranks}{The initial ordering of individuals for the first study
period. Required if using maternal rank inheritance as the convention.
For other conventions, if initial.ranks is not specified,
 the order determined by convention1 is used to create the initial order.}

\item{interactions}{A dataframe of interaction data with the following columns:
\describe{
 \item{winner}{Identities of winners.}
 \item{loser}{Identities of losers.}
 \item{period}{Study period in which interactions occurred.}}}
}
\value{
Produces a dataframe with the following columns: 
         \describe{
         \item{period}{Study period.}
         \item{id}{Identity of contestant.}
         \item{rank}{Ordinal rank of contestant in study period. Lower numbers
         equal higher rank.}
         \item{stan.rank}{Rank of contestant standardized for group size.
         Values range from 1 (highest rank) to -1 (lowest rank).}
         \item{old.order}{Identity of contestants arranged in the previous order (the order they
         were in before updating the order based on observations from current
         study period).}
       }
}
\description{
Implements the Informed MatReorder method described in Strauss & Holekamp (in revision)
to infer a dominance hierarchy over multiple study periods. For each
study period, ranks are inferred as modifications of the ranks from the previous
study period. First, new contestants are added according to the convention specified
by the user, and emigrated/dead contestants are removed. Then, matrix reordering is used
to change the position of contestants for whom data from the current study period
are inconsistent with this ordering. The optimal order is selected as the order 
that is most consistent with the data from the current period and is minimally 
changed from the previous study period.
}
\examples{
conts <- C.crocuta.female$contestants[C.crocuta.female$contestants$period <= 1990,]
female.ranks <- informed_matreorder(contestants = conts, 
convention = 'mri', n =1, shuffles = 10, require.corroboration = TRUE, 
initial.ranks = C.crocuta.female$initial.ranks,
interactions = C.crocuta.female$interactions)


}
\references{
Strauss ED & Holekamp KE (in revision). Journal of Animal Ecology.
}

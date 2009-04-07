polr.mi <- function (formula, mi.object, ... ) 
{
    call   <- match.call( )
    m      <- m(mi.object)
    result <- vector( "list", m )
    names( result ) <- as.character(paste( "Imputation", seq( m ), sep = "" ))
    mi.data <- mi.completed(mi.object)
    mi.data <- mi.postprocess(mi.data)
  
    for ( i in 1:m ) {
      result[[i]] <- polr( formula, data = mi.data[[i]], ... )
    }
    coef   <- vector( "list", m )
    se     <- vector( "list", m )
    for( j in 1:m ) {
      coef[[j]]<- lapply(result, summary)[[j]]$coefficients[ ,1]
      se[[j]]  <- lapply(result, summary)[[j]]$coef[ ,2]
    }
    pooled <- mi.pooled(coef, se, m)
    mi.pooled.object <- new("mi.pooled",
                          call = call, 
                          mi.pooled = pooled,
                          mi.fit = result)
    return( mi.pooled.object )
}
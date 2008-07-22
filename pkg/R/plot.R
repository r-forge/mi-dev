# ==============================================================================
# S4 plot function for mi object
# ==============================================================================

setMethod( "plot", signature( x = "mi", y="missing" ),
  function ( x, m = 1, vrb = NULL, vrb.name = "Variable Score",
                        gray.scale = FALSE, mfrow=c( 1, 4 ), ... ) {
    if ( m(x) < m )  { 
      stop( message = paste( "Index of imputation 'm' must be within the range of 1 to", m(x) ) ) 
    } else{
      mids <- imp(x,m);
      Y    <- as.data.frame( x@data[ , names( mids ) ] );
      names( Y ) <- names( mids );
      par( mfrow = mfrow );
      for( i in 1:dim( Y )[2] ) {
        par( ask = TRUE );
        if( !is.null( mids[[i]] ) ) {
          plot( x = mids[[i]], y = Y[ ,names( mids )[i]], main = names( Y )[ i ] );
        }
      }
    }
  }
)

# ==============================================================================
# S4 plot function for mi.method object
# ==============================================================================

setMethod( "plot", signature( x = "mi.method", y ="ANY"), 
  function( x, y, main = deparse( substitute( y ) ), gray.scale = FALSE ){      
    fit   <- fitted( x )
    res   <- resid( x, y )
    sigma <- sigma.hat( x )
    vrb.obs <- y
    vrb.imp <- imputed( x, y )
    mi.hist(  vrb.obs, object, xlab=main, main = main, gray.scale = gray.scale )
    residual.plot( fit, res, sigma, main = main, gray.scale = gray.scale )
    binnedplot ( fit[ !is.na( y )], res[ !is.na( y )], 
              nclass = sqrt( length( fit[  !is.na( y )] ) ), main = main )
    mi.scatterplot( vrb.obs, vrb.imp, fit, xlab = "predicted", ylab = main, 
                      main = main, gray.scale = gray.scale )
    #plot( 0, 0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE )
  }
)

# ==============================================================================
# S4 plot function for mi.mixed object
# =======================================================================
setMethod("plot", signature(x = "mi.mixed",y="ANY"), 
 function ( x, y, main=deparse( substitute( y ) ), gray.scale = FALSE ) {
  #par(mfrow=c(1,4))
  fit     <- fitted( x )
  res     <- resid( x, y )
  sigma   <- sigma.hat( x )
  vrb.obs <- y
  vrb.imp <- imputed( x, y )
  fit1 <- fit[[1]]
  fit2 <- fit[[2]]
  res1 <- res[[1]]
  res2 <- res[[2]]    
  mi.hist ( vrb.obs, x, xlab = main, main = main, gray.scale = gray.scale )
  binnedplot( fit1[ !is.na( y ) ], res1[ !is.na( y ) ], nclass=sqrt(length(fit1[ !is.na( y ) ])), main = main)
  residual.plot ( fit2[y>0], res2[y>0], sigma, main = main, gray.scale = gray.scale )
  #mtext( "sqrt", 2, cex = 0.7, adj = 1 )
  mi.scatterplot ( vrb.obs, vrb.imp, fit1*fit2,xlab = "predicted", ylab = main, main = main, gray.scale = gray.scale, display.zero=FALSE )
}
)

# ==============================================================================
# S4 plot function for mi.sqrtcontinuous object
# ==============================================================================

setMethod("plot", signature(x = "mi.sqrtcontinuous",y ="ANY"), 
function ( x, y, main=deparse( substitute( Yobs ) ), gray.scale = FALSE, ... ) {
  #par(mfrow=c(1,4))
  fit     <- fitted( x )
  res     <- resid( x, y )
  sigma   <- sigma.hat( x )
  vrb.obs <- y
  vrb.imp <- imputed( x, y )
  sqrta <- vrb.obs
  sqrta[!is.na(vrb.obs)] <-sqrt(vrb.obs[!is.na(vrb.obs)])
  mi.hist( vrb.obs, x, main = main, xlab=main, gray.scale = gray.scale )
  #mtext( "sqrt", 1, cex = 0.7, adj = 1 )
  residual.plot( fit, res, sigma, main = main, xlab= "Predicted",  ylab = paste( "Residual" ), gray.scale = gray.scale )
  mtext( "sqrt", 2, cex = 0.7, adj = 1 )
  mi.scatterplot( vrb.obs, vrb.imp, X=fit, xlab= "Predicted",  ylab =  main , main = main, gray.scale = gray.scale )
  plot( 0, 0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE )
} 
)

# ==============================================================================
# S4 plot function for mi.polr object
# ==============================================================================

setMethod("plot", signature(x = "mi.polr",y="ANY"), 
function ( x, y, main=deparse( substitute( y ) ), gray.scale = FALSE ) {
  #par(mfrow=c(1,4))
  y       <- factor2num( y )
  fit     <- factor2num( fitted( x ))
  res     <- factor2num( resid( x, y ))
  sigma   <- factor2num( sigma.hat( x ) )
  vrb.obs <- factor2num( y )
  vrb.imp <- factor2num( imputed( x, y ) )
  mi.hist( vrb.obs, x, xlab = main, main = main, gray.scale = gray.scale ) 
  binnedplot( fit[  !is.na( y ) ], res[  !is.na( y ) ], nclass = sqrt( length( fit[ !is.na( y ) ] ) ), main = main )
  mtext( "Binned Residual", 3, cex = 0.7, adj = NA ) 
  mi.scatterplot( vrb.obs, vrb.imp, fit, xlab = "predicted", ylab = main, main = main, gray.scale = gray.scale )
  plot( 0, 0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE )
} 
)

# ==============================================================================
# S4 plot function for mi.categorical object
# ==============================================================================

setMethod("plot", signature(x = "mi.categorical", y="ANY"), 
function ( x, y, main=deparse( substitute( Yobs ) ),gray.scale = FALSE ) {
  #par(mfrow=c(1,4))
  fit     <- fitted( x )
  res     <- resid( x, y )
  sigma   <- sigma.hat( x )
  vrb.obs <- y
  vrb.imp <- imputed( x, y )
  mi.hist( vrb.obs, x, type = vrb.typ, xlab = main, main = main, gray.scale = gray.scale )
  binnedplot( fit[ !is.na(y) ], res[ !is.na(y) ], nclass = sqrt( length( fit[ !is.na(y)] ) ), main = main)
  mtext( "Binned Residual", 3, cex = 0.7, adj = NA ) 
  mi.scatterplot( vrb.obs, vrb.imp, fit, xlab = "predicted", ylab = main, main = main, gray.scale = gray.scale )
  plot( 0, 0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE )

} 
)

# ==============================================================================
# S4 plot function for mi.dichotomous object
# =======================================================================
setMethod("plot", signature(x = "mi.dichotomous",y="ANY"), 
function ( x, y, main=deparse( substitute( Yobs ) ), gray.scale = FALSE ) {
          #par(mfrow=c(1,4))
          fit     <- fitted( x )
          res     <- resid( x, y )
          sigma   <- sigma.hat( x )
          vrb.obs <- y
          vrb.imp <- imputed( x, y )
          mi.hist ( vrb.obs, x, xlab = main, main = main, gray.scale = gray.scale )
          binnedplot ( fit[ !is.na( y )], res[ !is.na( y )], nclass = sqrt( length( fit[  !is.na( y )] ) ), main = main )
          mtext( "Binned Residual", 3, cex = 0.7, adj = NA )
          mi.scatterplot( vrb.obs, vrb.imp, fit, xlab = "Predicted", ylab = main, main = main, gray.scale = gray.scale )
          plot( 0, 0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE )
} 
)


# ==============================================================================
# S4 plot function for mi.logcontinuous object
# =======================================================================
setMethod("plot", signature(x = "mi.logcontinuous",y="ANY"), 
  function ( x, y, main=deparse( substitute( y ) ), gray.scale = FALSE, ... ) {
    par(mfrow=c(1,4))
    fit     <- fitted( x )
    res     <- resid( x, y )
    sigma   <- sigma.hat( x )
    vrb.obs <- y
    vrb.imp <- imputed( x, y ) 
    loga  <- vrb.obs
    loga[!is.na(vrb.obs)] <-log(vrb.obs[!is.na(vrb.obs)])
    mi.hist( loga, x, type = vrb.typ, main = main, xlab=paste("log(",main,")"), gray.scale = gray.scale )
    mtext( "log", 1, cex = 0.7, adj = 1 )
    residual.plot( log(fit), res, sigma, main = main, xlab= "log(Predicted)",  ylab = paste( "log(Residual)" ), gray.scale = gray.scale )
    mtext( "log", 1, cex = 0.7, adj = 1 )
    mtext( "log", 2, cex = 0.7, adj = 1 )
    mi.scatterplot( loga, log(vrb.imp), fit, xlab= "predicted",  ylab = paste( "log(", main, ")" ) , main = main, gray.scale = gray.scale )
    mtext( "log", 2, cex = 0.7, adj = 1 )
    plot( 0, 0, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "", frame.plot = FALSE )
  } 
)
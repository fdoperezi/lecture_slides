library(knitr)
opts_chunk$set(prompt=TRUE, eval=FALSE, tidy=FALSE, strip.white=FALSE, comment=NA, highlight=FALSE, message=FALSE, warning=FALSE, size='scriptsize', fig.width=4, fig.height=4)
options(digits=3)
options(width=60, dev='pdf')
thm <- knit_theme$get("acid")
knit_theme$set(thm)
load(file="C:/Develop/data/etf_data.RData")
re_turns <- c(asset1=0.02, asset2=0.04)
risk_free <- 0.01
std_devs <- c(asset1=0.8, asset2=1.6)
cor_rel <- 0.6
co_var <- matrix(c(1, cor_rel, cor_rel, 1), nc=2)
co_var <- t(t(std_devs*co_var)*std_devs)
weight_s <- seq(from=-1, to=2, length.out=31)
portf_rets <- weight_s*re_turns[1] +
  (1 - weight_s)*re_turns[2]
portf_sd <- sqrt(co_var[1, 1]*weight_s^2 +
         co_var[2, 2]*(1 - weight_s)^2 +
         2*weight_s*(1 - weight_s)*co_var[1, 2])
in_dex <- which.max((portf_rets-risk_free)/portf_sd)
max_sr <- (portf_rets[in_dex]-risk_free)/portf_sd[in_dex]
# plot scatterplot of portfolios
x11(width=(wid_th <- 6), height=(hei_ght <- 5))
par(mar=c(3,3,2,1)+0.1, oma=c(0, 0, 0, 0), mgp=c(2, 1, 0))
plot(portf_sd, portf_rets, t="l",
 main=paste0("Two assets correlation = ", 100*cor_rel, "%"),
 xlim=c(0, max(portf_sd)),
 ylim=c(0, max(portf_rets)))
# Add red point for maximum Sharpe ratio portfolio
points(portf_sd[in_dex], portf_rets[in_dex],
 col="red", lwd=3)
text(x=portf_sd[in_dex], y=portf_rets[in_dex],
     labels=paste(c("maxSR\n",
 structure(c(weight_s[in_dex], 1-weight_s[in_dex]),
         names=names(re_turns))), collapse=" "),
     pos=2, cex=0.8)
# Add points for individual assets
points(std_devs, re_turns, col="green", lwd=3)
text(std_devs, re_turns, labels=names(re_turns), pos=2, cex=0.8)
# Add point at risk_free rate and draw Capital Market Line
points(x=0, y=risk_free)
text(0, risk_free, labels="risk-free", pos=4, cex=0.8)
abline(a=risk_free, b=max_sr, col="blue")
range_s <- par("usr")
text(portf_sd[in_dex]/2, (portf_rets[in_dex]+risk_free)/2,
     labels="Capital Market Line", cex=0.8, , pos=3,
     srt=45*atan(max_sr*(range_s[2]-range_s[1])/
             (range_s[4]-range_s[3])*
             hei_ght/wid_th)/(0.25*pi))
load(file="C:/Develop/data/etf_data.RData")
# vector of symbol names
some_symbols <- c("VTI", "IEF")
# vector of portfolio weights
weight_s <- seq(from=-1, to=2, length.out=31)
# calculate portfolio returns and volatilities
ret_sd <- sapply(weight_s, function(wei_ght) {
  portf_rets <- env_etf$re_turns[, some_symbols] %*% c(wei_ght, 1-wei_ght)
  100*c(ret=mean(portf_rets), sd=sd(portf_rets))
})  # end sapply
risk_free <- 0.01
ret_sd <- rbind(ret_sd, (ret_sd[1, ]-risk_free)/ret_sd[2, ])
rownames(ret_sd)[3] <- "sr"
in_dex <- which.max(ret_sd[3, ])
max_sr <- ret_sd[3, in_dex]
# plot scatterplot of portfolios in x11() window
x11(width=(wid_th <- 6), height=(hei_ght <- 4))
par(mar=c(3,3,2,1)+0.1, oma=c(0, 0, 0, 0), mgp=c(2, 1, 0))
plot(x=ret_sd[2, ], y=ret_sd[1, ], t="l",
     xlim=c(0, max(ret_sd[2, ]/2)),
     ylim=c(min(0, min(ret_sd[1, ])), max(ret_sd[1, ])),
     xlab=rownames(ret_sd)[2], ylab=rownames(ret_sd)[1])
title(main="Stock and bond portfolios", line=-1)
# Add red point for maximum Sharpe ratio portfolio
points(x=ret_sd[2, in_dex], y=ret_sd[1, in_dex],
 col="red", lwd=3)
text(x=ret_sd[2, in_dex], y=ret_sd[1, in_dex],
     labels=paste(c("maxSR\n",
 structure(c(weight_s[in_dex], 1-weight_s[in_dex]),
         names=some_symbols)), collapse=" "),
     pos=3, cex=0.8)
# Add points for individual assets
re_turns <- 100*sapply(env_etf$re_turns[, some_symbols], mean)
std_devs <- 100*sapply(env_etf$re_turns[, some_symbols], sd)
points(std_devs, re_turns, col="green", lwd=3)
text(std_devs, re_turns, labels=names(re_turns), pos=2, cex=0.8)
# Add point at risk_free rate and draw Capital Market Line
points(x=0, y=risk_free)
text(0, risk_free, labels="risk-free", pos=4, cex=0.8)
abline(a=risk_free, b=max_sr, col="blue")
range_s <- par("usr")
text(ret_sd[2, in_dex]/3, (ret_sd[1, in_dex]+risk_free)/2,
     labels="Capital Market Line", cex=0.8, , pos=3,
     srt=45*atan(max_sr*(range_s[2]-range_s[1])/
             (range_s[4]-range_s[3])*
             hei_ght/wid_th)/(0.25*pi))
# plot max Sharpe ratio portfolio returns
library(quantmod)
optim_rets <-
  xts(x=env_etf$re_turns[, some_symbols] %*%
  c(weight_s[in_dex], 1-weight_s[in_dex]),
order.by=index(env_etf$re_turns))
chart_Series(x=cumsum(optim_rets),
       name="Max Sharpe two-asset portfolio")
load(file="C:/Develop/data/etf_data.RData")
# vector of symbol names
some_symbols <- c("VTI", "IEF", "XLP")
n_weights <- length(some_symbols)
# calculate random portfolios
n_portf <- 1000
ret_sd <- sapply(1:n_portf, function(in_dex) {
  weight_s <- runif(n_weights, min=0, max=10)
  weight_s <- weight_s/sqrt(sum(weight_s^2))
  portf_rets <- env_etf$re_turns[, some_symbols] %*% weight_s
  100*c(ret=mean(portf_rets), sd=sd(portf_rets))
})  # end sapply
# plot scatterplot of random portfolios
x11(width=(wid_th <- 6), height=(hei_ght <- 5))
plot(x=ret_sd[2, ], y=ret_sd[1, ], xlim=c(0, max(ret_sd[2, ])),
     main="Random portfolios",
     ylim=c(min(0, min(ret_sd[1, ])), max(ret_sd[1, ])),
     xlab=rownames(ret_sd)[2], ylab=rownames(ret_sd)[1])
# vector of initial portfolio weights equal to 1
weight_s <- rep(1, n_weights)
names(weight_s) <- some_symbols
# objective function equal to standard deviation of returns
object_ive <- function(weights) {
  portf_rets <- env_etf$re_turns[, some_symbols] %*% weights
  sd(portf_rets)/sqrt(sum(weights^2))
}  # end object_ive
# object_ive() for equal weight portfolio
object_ive(weight_s)
object_ive(2*weight_s)
# perform portfolio optimization
optim_run <- optim(par=weight_s,
             fn=object_ive,
             method="L-BFGS-B",
             upper=rep(10, n_weights),
             lower=rep(-10, n_weights))
# Rescale the optimal weights
weight_s <- optim_run$par/sqrt(sum(optim_run$par^2))
# minimum variance portfolio returns
library(quantmod)
optim_rets <- xts(x=env_etf$re_turns[, some_symbols] %*% weight_s,
            order.by=index(env_etf$re_turns))
chart_Series(x=cumsum(optim_rets), name="minvar portfolio")
# Add red point for minimum variance portfolio
optim_sd <- 100*sd(optim_rets)
optim_ret <- 100*mean(optim_rets)
points(x=optim_sd, y=optim_ret, col="red", lwd=3)
text(x=optim_sd, y=optim_ret, labels="minvar", pos=2, cex=0.8)
# objective function equal to minus Sharpe ratio
risk_free <- 0.01
object_ive <- function(weights) {
  portf_rets <- 100*env_etf$re_turns[, some_symbols] %*% weights
  -mean(portf_rets-risk_free)/sd(portf_rets)
}  # end object_ive
# perform portfolio optimization
optim_run <- optim(par=weight_s,
             fn=object_ive,
             method="L-BFGS-B",
             upper=rep(10, n_weights),
             lower=rep(-10, n_weights))
# maximum Sharpe ratio portfolio returns
weight_s <- optim_run$par/sqrt(sum(optim_run$par^2))
optim_rets <- xts(x=env_etf$re_turns[, some_symbols] %*% weight_s,
            order.by=index(env_etf$re_turns))
chart_Series(x=cumsum(optim_rets), name="maxSR portfolio")
optim_sd <- 100*sd(optim_rets)
optim_ret <- 100*mean(optim_rets)
points(x=optim_sd, y=optim_ret,
 col="blue", lwd=3)
text(x=optim_sd, y=optim_ret,
     labels="maxSR", pos=2, cex=0.8)
max_sr <- (optim_ret-risk_free)/optim_sd
# Add points for individual assets
re_turns <- 100*sapply(env_etf$re_turns[, some_symbols], mean)
std_devs <- 100*sapply(env_etf$re_turns[, some_symbols], sd)
points(std_devs, re_turns, col="green", lwd=3)
text(std_devs, re_turns, labels=names(re_turns), pos=2, cex=0.8)
# Add point at risk_free rate and draw Capital Market Line
points(x=0, y=risk_free)
text(0, risk_free, labels="risk-free", pos=4, cex=0.8)
abline(a=risk_free, b=max_sr, col="blue")
range_s <- par("usr")
text(optim_sd/3, (optim_ret+risk_free)/2.5,
     labels="Capital Market Line", cex=0.8, , pos=3,
     srt=45*atan(max_sr*(range_s[2]-range_s[1])/
             (range_s[4]-range_s[3])*
             hei_ght/wid_th)/(0.25*pi))
library(PortfolioAnalytics)
# plot the efficient frontier
load(file="C:/Develop/data/etf_data.RData")
# create list of symbols for optimized portfolio
sym_bols <- c("VTI", "VNQ", "DBC")
# create initial vector of portfolio weights
portf_weights <- rep(1, length(sym_bols))
names(portf_weights) <- sym_bols
# objective equal to minus Sharpe ratio
object_ive <- function(weights) {
  portf_rets <- env_etf$re_turns[, sym_bols] %*% weights
  -mean(portf_rets)/sd(portf_rets)
}  # end object_ive
# objective for equal weight portfolio
object_ive(portf_weights)
par(oma=c(1, 1, 1, 1), mgp=c(2, 1, 0), mar=c(5, 1, 1, 1), cex.lab=0.8, cex.axis=0.8, cex.main=0.8, cex.sub=0.5)
# vectorize objective function with respect to third weight
vec_object <- Vectorize(
  FUN=function(weight) object_ive(c(1, 1, weight)),
  vectorize.args="weight"
)  # end Vectorize
# plot objective function with respect to third weight
curve(expr=vec_object,
      type="l", xlim=c(-4.0, 1.0),
      xlab=paste("weight of", names(portf_weights[3])),
      ylab="", lwd=2)
title(main="Objective Function", line=-1)  # add title
# vectorize function with respect to all weights
vec_object <- Vectorize(
  FUN=function(w1, w2, w3)
    object_ive(c(w1, w2, w3)),
  vectorize.args=c("w2", "w3"))  # end Vectorize
# calculate objective on 2-d (w2 x w3) parameter grid
w2 <- seq(-5, 5, length=50)
w3 <- seq(-5, 5, length=50)
grid_object <- outer(w2, w3, FUN=vec_object, w1=1)
rownames(grid_object) <- round(w2, 2)
colnames(grid_object) <- round(w3, 2)
# perspective plot of objective function
persp(w2, w3, -grid_object,
theta=45, phi=30, shade=0.5,
col=rainbow(50), border="green",
main="objective function")
# interactive perspective plot of objective function
library(rgl)
persp3d(z=-grid_object, zlab="objective",
  col="green", main="objective function")
persp3d(
  x=function(w2, w3)
    -vec_object(w1=1, w2, w3),
  xlim=c(-5, 5), ylim=c(-5, 5),
  col="green", axes=FALSE)
# optimization to find weights with maximum Sharpe ratio
optim_run <- optim(par=portf_weights,
             fn=object_ive,
             method="L-BFGS-B",
             upper=c(1.1, 10, 10),
             lower=c(0.9, -10, -10))
# optimal parameters
optim_run$par
# optimal Sharpe ratio
-object_ive(optim_run$par)
par(oma=c(1, 0, 1, 0), mgp=c(2, 1, 0), mar=c(2, 1, 2, 1), cex.lab=0.8, cex.axis=0.8, cex.main=0.8, cex.sub=0.5)
library(PortfolioAnalytics)
# returns of optimal portfolio
optim_rets <- xts(env_etf$re_turns[, sym_bols] %*%
optim_run$par, order.by=index(env_etf$re_turns))
# assign colnames to this xts
colnames(optim_rets) <- "optim_rets"
# plot in two vertical panels
layout(matrix(c(1,2), 2),
 widths=c(1,1), heights=c(1,3))
# barplot of optimal portfolio weights
barplot(optim_run$par,
  names.arg=names(optim_run$par),
  las=3, ylab="", xlab="Symbol", main="")
# plot optimal returns with "VTI", "VNQ" and "DBC"
chart.CumReturns(
  cbind(optim_rets, env_etf$re_turns[, names(portf_weights)]),
  lwd=2, ylab="", legend.loc="topleft", main="")
library(PortfolioAnalytics)  # load package "PortfolioAnalytics"
# get documentation for package "PortfolioAnalytics"
packageDescription("PortfolioAnalytics")  # get short description

help(package="PortfolioAnalytics")  # load help page

data(package="PortfolioAnalytics")  # list all datasets in "PortfolioAnalytics"

ls("package:PortfolioAnalytics")  # list all objects in "PortfolioAnalytics"

detach("package:PortfolioAnalytics")  # remove PortfolioAnalytics from search path
library(PortfolioAnalytics)
# load ETF returns
load(file="C:/Develop/data/etf_data.RData")
portf_names <- c("VTI", "IEF", "DBC", "XLF",
  "VNQ", "XLP", "XLV", "XLU", "XLB", "XLE")
# initial portfolio to equal weights
portf_init <- rep(1/length(portf_names),
            length(portf_names))
# named vector
names(portf_init) <- portf_names
# create portfolio object
portf_init <- portfolio.spec(
  assets=portf_init)
library(PortfolioAnalytics)
# add constraints
portf_maxSR <- add.constraint(
  portfolio=portf_init,  # initial portfolio
  type="weight_sum",  # constraint sum weights
  min_sum=0.9, max_sum=1.1)
# add constraints
portf_maxSR <- add.constraint(
  portfolio=portf_maxSR,
  type="long_only")  # box constraint min=0, max=1
# add objectives
portf_maxSR <- add.objective(
  portfolio=portf_maxSR,
  type="return",  # maximize mean return
  name="mean")
# add objectives
portf_maxSR <- add.objective(
  portfolio=portf_maxSR,
  type="risk",  # minimize StdDev
  name="StdDev")
load(file="C:/Develop/data/portf_optim.RData")
library(PortfolioAnalytics)
# perform optimization of weights
maxSR_DEOpt <- optimize.portfolio(
  R=env_etf$re_turns[, portf_names],  # specify returns
  portfolio=portf_maxSR,  # specify portfolio
  optimize_method="DEoptim", # use DEoptim
  maxSR=TRUE,  # maximize Sharpe
  trace=TRUE, traceDE=0)
# plot optimization
chart.RiskReward(maxSR_DEOpt,
  risk.col="StdDev",
  return.col="mean")
options(width=50)
library(PortfolioAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
maxSR_DEOpt$weights
maxSR_DEOpt$objective_measures$mean[1]
maxSR_DEOpt$objective_measures$StdDev[[1]]
library(PortfolioAnalytics)
# plot optimization
chart.RiskReward(maxSR_DEOpt,
  risk.col="StdDev",
  return.col="mean")

# plot risk/ret points in portfolio scatterplot
risk_ret_points <- function(rets=env_etf$re_turns,
  risk=c("sd", "ETL"), sym_bols=c("VTI", "IEF")) {
  risk <- match.arg(risk)  # match to arg list
  if (risk=="ETL") {
    stopifnot(
"package:PerformanceAnalytics" %in% search() ||
require("PerformanceAnalytics", quietly=TRUE))
  }  # end if
  risk <- match.fun(risk)  # match to function
  risk_ret <- t(sapply(rets[, sym_bols],
     function(x_ts)
 c(ret=mean(x_ts), risk=abs(risk(x_ts)))))
  points(x=risk_ret[, "risk"], y=risk_ret[, "ret"],
   col="red", lwd=3)
  text(x=risk_ret[, "risk"], y=risk_ret[, "ret"],
 labels=rownames(risk_ret), col="red",
 lwd=2, pos=4)
}  # end risk_ret_points

risk_ret_points()
library(PortfolioAnalytics)
plot_portf <- function(portfolio,
      rets_data=env_etf$re_turns) {
  portf_weights <- portfolio$weights
  portf_names <- names(portf_weights)
  # calculate xts of portfolio
  portf_max <- xts(
    rets_data[, portf_names] %*% portf_weights,
    order.by=index(rets_data))
  colnames(portf_max) <-
    deparse(substitute(portfolio))
  graph_params <- par(oma=c(1, 0, 1, 0),
    mgp=c(2, 1, 0), mar=c(2, 1, 2, 1),
    cex.lab=0.8, cex.axis=1.0,
    cex.main=0.8, cex.sub=0.5)
  layout(matrix(c(1,2), 2),
    widths=c(1,1), heights=c(1,3))
  barplot(portf_weights, names.arg=portf_names,
    las=3, ylab="", xlab="Symbol", main="")
  title(main=paste("Loadings",
          colnames(portf_max)), line=-1)
  chart.CumReturns(
    cbind(portf_max, rets_data[, c("IEF", "VTI")]),
    lwd=2, ylab="", legend.loc="topleft", main="")
  title(main=paste0(colnames(portf_max),
              ", IEF, VTI"), line=-1)
  par(graph_params)  # restore original parameters
  invisible(portf_max)
}  # end plot_portf
maxSR_DEOpt_xts <- plot_portf(portfolio=maxSR_DEOpt)
library(PortfolioAnalytics)
# add leverage constraint abs(weight_sum)
portf_maxSRN <- add.constraint(
  portfolio=portf_init, type="leverage",
  min_sum=0.9, max_sum=1.1)
# add box constraint long/short
portf_maxSRN <- add.constraint(
  portfolio=portf_maxSRN,
  type="box", min=-0.2, max=0.2)

# add objectives
portf_maxSRN <- add.objective(
  portfolio=portf_maxSRN,
  type="return",  # maximize mean return
  name="mean")
# add objectives
portf_maxSRN <- add.objective(
  portfolio=portf_maxSRN,
  type="risk",  # minimize StdDev
  name="StdDev")
load(file="C:/Develop/data/portf_optim.RData")
library(PortfolioAnalytics)
# perform optimization of weights
maxSRN_DEOpt <- optimize.portfolio(
  R=env_etf$re_turns[, portf_names],  # specify returns
  portfolio=portf_maxSRN,  # specify portfolio
  optimize_method="DEoptim", # use DEoptim
  maxSR=TRUE,  # maximize Sharpe
  trace=TRUE, traceDE=0)
# plot optimization
chart.RiskReward(maxSRN_DEOpt,
  risk.col="StdDev",
  return.col="mean",
  xlim=c(
    maxSR_DEOpt$objective_measures$StdDev[[1]]-0.001,
    0.016))
  points(x=maxSR_DEOpt$objective_measures$StdDev[[1]],
   y=maxSR_DEOpt$objective_measures$mean[1],
   col="green", lwd=3)
  text(x=maxSR_DEOpt$objective_measures$StdDev[[1]],
   y=maxSR_DEOpt$objective_measures$mean[1],
 labels="maxSR", col="green",
 lwd=2, pos=4)
# plot risk/ret points in portfolio scatterplot
risk_ret_points()
library(PortfolioAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
maxSRN_DEOpt$weights
maxSRN_DEOpt$objective_measures$mean[1]
maxSRN_DEOpt$objective_measures$StdDev[[1]]
library(PortfolioAnalytics)
maxSRN_DEOpt_xts <-
  plot_portf(portfolio=maxSRN_DEOpt)
library(PerformanceAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
chart.CumReturns(
  cbind(maxSR_DEOpt_xts, maxSRN_DEOpt_xts),
  lwd=2, ylab="",
  legend.loc="topleft", main="")
options(width=50)
library(PerformanceAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
rbind(maxSR_DEOpt$weights, maxSRN_DEOpt$weights)
c(maxSR_DEOpt$objective_measures$mean,
maxSRN_DEOpt$objective_measures$mean)
c(maxSR_DEOpt$objective_measures$StdDev[[1]],
maxSRN_DEOpt$objective_measures$StdDev[[1]])
library(PortfolioAnalytics)
# add constraints
portf_maxSTARR <- add.constraint(
  portfolio=portf_init,  # initial portfolio
  type="weight_sum",  # constraint sum weights
  min_sum=0.9, max_sum=1.1)
# add constraints
portf_maxSTARR <- add.constraint(
  portfolio=portf_maxSTARR,
  type="long_only")  # box constraint min=0, max=1
# add objectives
portf_maxSTARR <- add.objective(
  portfolio=portf_maxSTARR,
  type="return",  # maximize mean return
  name="mean")
# add objectives
portf_maxSTARR <- add.objective(
  portfolio=portf_maxSTARR,
  type="risk",  # minimize Expected Sshortfall
  name="ES")
load(file="C:/Develop/data/portf_optim.RData")
library(PortfolioAnalytics)
# perform optimization of weights
maxSTARR_DEOpt <- optimize.portfolio(
  R=env_etf$re_turns[, portf_names],  # specify returns
  portfolio=portf_maxSTARR,  # specify portfolio
  optimize_method="DEoptim", # use DEoptim
  maxSTARR=TRUE,  # maximize STARR
  trace=TRUE, traceDE=0)

# plot optimization
chart.RiskReward(maxSTARR_DEOpt,
  risk.col="ES",
  return.col="mean")
# plot risk/ret points in portfolio scatterplot
risk_ret_points(risk="ETL")
options(width=50)
library(PortfolioAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
maxSTARR_DEOpt$weights
maxSTARR_DEOpt$objective_measures$mean[1]
maxSTARR_DEOpt$objective_measures$ES[[1]]
library(PortfolioAnalytics)
maxSTARR_DEOpt_xts <-
  plot_portf(portfolio=maxSTARR_DEOpt)
library(PerformanceAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
chart.CumReturns(
  cbind(maxSR_DEOpt_xts, maxSTARR_DEOpt_xts),
  lwd=2, ylab="",
  legend.loc="topleft", main="")
options(width=50)
library(PerformanceAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
rbind(maxSR_DEOpt$weights, maxSTARR_DEOpt$weights)
c(maxSR_DEOpt$objective_measures$mean,
maxSTARR_DEOpt$objective_measures$mean)
c(maxSR_DEOpt$objective_measures$StdDev[[1]],
maxSTARR_DEOpt$objective_measures$ES[[1]])
library(PortfolioAnalytics)
# plot the efficient frontier
chart.EfficientFrontier(maxSR_DEOpt,
          match.col="StdDev",
          n.portfolios=15, type="l")
points(x=maxSRN_DEOpt$objective_measures$StdDev[[1]],
   y=maxSRN_DEOpt$objective_measures$mean[1],
   col="green", lwd=3)
text(x=maxSRN_DEOpt$objective_measures$StdDev[[1]],
   y=maxSRN_DEOpt$objective_measures$mean[1],
 labels="maxSRN", col="green",
 lwd=2, pos=4)
library(PortfolioAnalytics)
# add constraints
portf_minES <- add.constraint(
  portfolio=portf_init,  # initial portfolio
  type="weight_sum",  # constraint sum weights
  min_sum=0.9, max_sum=1.1)
# add constraints
portf_minES <- add.constraint(
  portfolio=portf_minES,
  type="long_only")  # box constraint min=0, max=1
# add objectives
portf_minES <- add.objective(
  portfolio=portf_minES,
  type="risk",  # minimize ES
  name="ES")
load(file="C:/Develop/data/portf_optim.RData")
library(PortfolioAnalytics)
# perform optimization of weights
minES_ROI <- optimize.portfolio(
  R=env_etf$re_turns[, portf_names],  # specify returns
  portfolio=portf_minES,  # specify portfolio
  optimize_method="ROI", # use ROI
  trace=TRUE, traceDE=0)

# plot optimization
chart.RiskReward(maxSTARR_DEOpt,
  risk.col="ES",
  return.col="mean")
  points(x=minES_ROI$objective_measures$ES[[1]],
   y=mean(minES_ROI_xts),
   col="green", lwd=3)
  text(x=minES_ROI$objective_measures$ES[[1]],
   y=mean(minES_ROI_xts),
 labels="minES", col="green",
 lwd=2, pos=4)
# plot risk/ret points in portfolio scatterplot
risk_ret_points(risk="ETL")
options(width=50)
library(PortfolioAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
minES_ROI$weights
minES_ROI$objective_measures$ES[[1]]
library(PortfolioAnalytics)
minES_ROI_xts <-
  plot_portf(portfolio=minES_ROI)
library(PerformanceAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
chart.CumReturns(
  cbind(maxSR_DEOpt_xts, minES_ROI_xts),
  lwd=2, ylab="",
  legend.loc="topleft", main="")
options(width=50)
library(PerformanceAnalytics)
load(file="C:/Develop/data/portf_optim.RData")
rbind(maxSR_DEOpt$weights, minES_ROI$weights)
c(maxSR_DEOpt$objective_measures$mean,
minES_ROI$objective_measures$mean)
c(maxSR_DEOpt$objective_measures$StdDev[[1]],
minES_ROI$objective_measures$ES[[1]])
load(file="C:/Develop/data/portf_optim.RData")
library(PortfolioAnalytics)
options(width=50)
# perform optimization of weights
maxSR_DEOpt <- optimize.portfolio(
  R=env_etf$re_turns["/2011", portf_names],
  portfolio=portf_maxSR,  # specify portfolio
  optimize_method="DEoptim", # use DEoptim
  maxSR=TRUE,  # maximize Sharpe
  trace=TRUE, traceDE=0)
weights_1h <- maxSR_DEOpt$weights

# plot optimization
maxSR_DEOpt_xts <-
  plot_portf(portfolio=maxSR_DEOpt)
load(file="C:/Develop/data/portf_optim.RData")
library(PortfolioAnalytics)
options(width=50)
# perform optimization of weights
maxSR_DEOpt <- optimize.portfolio(
  R=env_etf$re_turns["2011/", portf_names],
  portfolio=portf_maxSR,  # specify portfolio
  optimize_method="DEoptim", # use DEoptim
  maxSR=TRUE,  # maximize Sharpe
  trace=TRUE, traceDE=0)
weights_2h <- maxSR_DEOpt$weights

# plot optimization
maxSR_DEOpt_xts <-
  plot_portf(portfolio=maxSR_DEOpt)
options(width=50)
weights_1h
weights_2h
weights_1h - weights_2h
par(oma=c(1,0,1,0), mgp=c(2,1,0), mar=c(2,1,2,1), cex.lab=0.8, cex.axis=1.0, cex.main=0.8, cex.sub=0.5)
par(mfrow=c(2,1))  # set plot panels
barplot(weights_1h,
  names.arg=names(weights_1h),
  las=3, ylab="", xlab="",
  main="Portfolio Weights First Half")
barplot(weights_2h,
  names.arg=names(weights_2h),
  las=3, ylab="", xlab="",
  main="Portfolio Weights Second Half")

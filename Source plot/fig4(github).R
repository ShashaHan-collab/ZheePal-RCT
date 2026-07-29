library(dplyr)
library(ggplot2)
library(cowplot)
library(grid)
library(binom)
library(glue)

load("fig4.RData")

###          ###
### subfig_a ###
###          ###
plot_panel_a <- function(df, dim_name,y_label = FALSE,legend = FALSE){
  df <- df %>% filter(dimension == dim_name)
  p <- ggplot(df, aes(x_pos, prop, group = group)) +
    geom_col(
      aes(color = group),
      fill = df$fill_color,
      width = 0.67,
      position = position_dodge(width = 0.71),
      linewidth = 1.8
    ) +
    geom_errorbar(
      aes(ymin = lower, ymax = upper, color = group),
      width = 0.05,
      linewidth = 1,
      position = position_dodge(width = 0.71)
    ) +
    scale_x_continuous(
      breaks = c(1, 2, 3),
      labels = c(
        "Intention\nto act",
        "Action among\nintended",
        "Action among\nunintended"
      )
    ) +
    scale_y_continuous(breaks = seq(0, 100, 20)) +
    coord_cartesian(ylim = c(0, 100),clip = "off")+
    scale_color_manual(
      values = c("ZheePal" = "#C72D94",
                 "Usual"   = "#3E4A5C")
    ) +
    geom_segment(aes(x = 0.5, xend = 3.5, y = -4, yend = -4), color = "black", linewidth = 0.5)+
    geom_segment(aes(y = 0, yend = 100, x = 0.42, xend = 0.42), color = "black", linewidth=0.5) + 
    geom_segment(x = 0.5, xend = 0.5, y = -4, yend = -8, color = "black", linewidth = 0.5) + 
    geom_segment(x = 3.5, xend = 3.5, y = -4, yend = -8, color = "black", linewidth = 0.5) + 
    geom_segment(
      data = data.frame(y = seq(0, 100, 20)),
      aes(x = 0.42, xend = 0.35, y = y, yend = y),
      inherit.aes = FALSE,  
      color = "black",
      linewidth = 0.5
    ) +
    labs(
      x = dim_name,
      y = if (y_label) "Proportion (%)" else "",
      title = ""
    ) +
    theme_minimal() +
    theme(
      legend.title = element_blank(),
      legend.position = if (legend) "top" else "none",
      legend.text = element_text(size = 11),
      panel.grid = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_text(size = 31, color = "black", margin = margin(r = -15, l = 10)),
      axis.title.y = element_text(size = 32, color = "black"),
      axis.title.x = element_text(size = 32, color = "black",margin = margin(t=20)),
      plot.title = element_blank(),
      plot.margin = margin(t = 5, r = 180, b = 5, l = 5),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA)
    )
  p
}


ap_cognitive <- plot_panel_a(A_df_long, "Cognitive", y_label = TRUE)
ap_mental    <- plot_panel_a(A_df_long, "Mental")
legend_labela1 <- ggdraw() +
  draw_grob(
    gridtext::richtext_grob(
      "<span style='color:#C72D94;'>ZheePal</span>versus<span style='color:#3E4A5C;'>usual</span>",
      x = 0.4, y = 0.5,
      hjust = 0, vjust = 0,
      gp = gpar(fontsize = 28)
    )
  )
legend_items <- tribble(
  ~label,                 ~fill,       ~color,
  "Intention to act",      "#FFFFFF",  "#3E4A5C",
  "Action among intended", "#E8EAED",  "#3E4A5C",
  "Action among unintended","#D1D5DB", "#3E4A5C"
)

gap <- c(0, 1.5, 2.0) 
legend_items <- legend_items %>%
  mutate(
    x_tile = cumsum(gap),
    y_tile = 1
  )

p_legenda2 <- ggplot(legend_items, aes(x = x_tile, y = y_tile)) +
  geom_tile(aes(width = 0.15, height = 0.15, fill = fill, color = color),
            linewidth = 0.8) +
  geom_text(aes(x = x_tile + 0.13, y = y_tile, label = label),
            hjust = 0, vjust = 0.5, size = 6) +
  scale_fill_identity() +
  scale_color_identity() +
  theme_void() +
  xlim(-0.5, max(legend_items$x_tile) + 2) +
  ylim(0.5, 1.5)


###          ###
### subfig_b ###
###          ###
for (key in c("all", "train")){
  prefix <- c("cog", "men")
  suffix <- c("mlow", "mh_h")
  for (i in seq_along(prefix)) {
    for (j in seq_along(suffix)) {
      varname <- paste0("do_", prefix[i], "_dat_", suffix[j])
      varname0 <- paste0("do_", prefix[i], "_dat0_", suffix[j])
      assign(varname, get(paste0(key, "_", varname)))
      assign(varname0, get(paste0(key, "_", varname)))
    }
  }
  
  plot_group_trend <- function(do_dat_mlow, do_dat_mh_h,title,
                               do_dat0_mlow = NULL,do_dat0_mh_h = NULL, four_week = TRUE,  y_label=FALSE, x_label=FALSE, beh) {
    do_dat_mlow <- do_dat_mlow[2:4, ]
    do_dat_mh_h <- do_dat_mh_h[2:4, ]
    do_dat0_mlow <- do_dat0_mlow[2:4, ]
    do_dat0_mh_h <- do_dat0_mh_h[2:4, ]
    
    time_points <- if (key == "all") c("0 week willingness",
                                       "2 week actual behavior",
                                       "4 week actual behavior") 
    else c("0 week knowledge",
           "2 week actual behavior",
           "4 week actual behavior")
    time_points_label <- c("0 weeks","2 weeks","4 weeks")
    
    color_map <- c(
      "ZheePal Lower perceived" = "#00b0be",
      "ZheePal High perceived"  = "#ea801c",
      "Usual Lower perceived"   = "#3594cc",
      "Usual High perceived"    = "#c99b38"
    )
    
    linetype_map <- c(
      "ZheePal Lower perceived" = "solid",
      "ZheePal High perceived"  = "solid",
      "Usual Lower perceived"   = "solid",
      "Usual High perceived"    = "solid"
    )
    
    process_data <- function(df, group_name, linetype) {
      counts <- suppressWarnings(as.numeric(df[[2]]))
      totals <- suppressWarnings(as.numeric(df[[3]]))
      pct    <- suppressWarnings(as.numeric(df[[4]]))
      
      ok <- !is.na(counts) & !is.na(totals) & totals > 0 & counts >= 0 & counts <= totals
      lower <- upper <- rep(NA_real_, length(pct))
      if (any(ok)) {
        ci <- binom.confint(counts[ok], totals[ok], conf.level = 0.95, methods = "wilson")
        lower[ok] <- ci$lower * 100
        upper[ok] <- ci$upper * 100
      }
      
      data.frame(
        time       = df[[1]],
        risk       = group_name,
        group      = linetype,     
        p          = pct,
        lower      = lower,
        upper      = upper,
        group_risk = paste(linetype, group_name, sep = " "),
        stringsAsFactors = FALSE
      )
    }
    
    df <- rbind(
      process_data(do_dat_mlow, "Lower perceived", "ZheePal"),
      process_data(do_dat_mh_h, "High perceived", "ZheePal")
    )
    
    if (!is.null(do_dat0_mlow) & !is.null(do_dat0_mh_h)) {
      df <- rbind(
        df,
        process_data(do_dat0_mlow, "Lower perceived", "Usual"),
        process_data(do_dat0_mh_h, "High perceived", "Usual")
      )
    }
    
    df$time <- factor(df$time, levels = time_points, labels = time_points_label)
    df$risk <- factor(df$risk,
                      levels = c("Lower perceived", "High perceived"))
    
    risk_levels <- c("Lower perceived", "High perceived" )
    group_levels <- unique(df$group)  
    df$group_risk <- factor(df$group_risk,
                            levels = as.vector(t(outer(group_levels, risk_levels, paste, sep=" "))))
    legend_order <- levels(df$group_risk)
    df$point_shape <- ifelse(df$time == levels(df$time)[1], 1, 16)
    df$point_stroke <- ifelse(df$time == levels(df$time)[1], 3, 3) 
    
    p <- ggplot(df, aes(x = time, y = p, group = group_risk,
                        color = group_risk, linetype = group_risk)) +
      geom_line(size = 2, na.rm = TRUE) +
      geom_point(aes(shape = point_shape, stroke = point_stroke), size = 8, na.rm = TRUE) +
      scale_shape_identity() +   
      geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.12, na.rm = TRUE, size = 1) +
      labs(x = if (x_label) title else "", y = if (y_label) "Proportion (%)"else "", color = "Group Risk", linetype = "Group Risk") +
      scale_y_continuous(breaks = seq(0, 100, 20)) +
      coord_cartesian(ylim = c(0, 100), clip = "off")+
      scale_color_manual(values = color_map) +
      scale_linetype_manual(values = linetype_map) +
      geom_segment(aes(x = 1, xend = 3, y = -4, yend = -4), color = "black", linewidth = 0.5)+
      geom_segment(aes(y = 0, yend = 100, x = 0.6, xend = 0.6), color = "black", linewidth=0.5) + 
      geom_segment(x = 1, xend = 1, y = -4, yend = -8, color = "black", linewidth = 0.5) + 
      geom_segment(x = 2, xend = 2, y = -4, yend = -8, color = "black", linewidth = 0.5) + 
      geom_segment(x = 3, xend = 3, y = -4, yend = -8, color = "black", linewidth = 0.5) + 
      geom_segment(
        data = data.frame(y = seq(0, 100, 20)),
        aes(x = 0.6, xend = 0.53, y = y, yend = y),
        inherit.aes = FALSE,  
        color = "black",
        linewidth = 0.5
      ) +
      theme_minimal() +
      theme(
        legend.position = "none",
        legend.key.size = unit(1, "cm"),
        panel.grid = element_blank(),
        axis.text.x = element_text(size = 33, color = "black", vjust=-1),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(size = 33, color = "black", margin = margin(r = -10, l = 5)),
        axis.ticks.y = element_blank(),
        axis.title.y = element_text(size = 34, color = "black"),
        axis.title.x = element_text(size = 34, color = "black", margin = margin(t = 30)),
        plot.margin = margin(t = 0, r=150),
        panel.background = element_rect(fill = "transparent", colour = NA),
        plot.background = element_rect(fill = "transparent", colour = NA)
      ) 
    
    return(p)
  }
  
  
  if (key == "all"){
    plot_info <- list(
      list(prefix = "cog", title2 = "Cognitive", ll=TRUE, rr = TRUE, beh = "Help-seeking"),
      list(prefix = "men", title2 = "Mental", ll=FALSE, rr = TRUE, beh = "Help-seeking")
    )
  } else {
    plot_info <- list(
      list(prefix = "cog", title2 = "Cognitive", ll=TRUE, rr = TRUE, beh = "Advice adherence"),
      list(prefix = "men", title2 = "Mental", ll=FALSE, rr = TRUE, beh = "Advice adherence")
    )
  }
  
  
  for (info in plot_info) {
    
    dat_mlow <- get(paste0("do_", info$prefix, "_dat_mlow"))
    dat_mh_h <- get(paste0("do_", info$prefix, "_dat_mh_h"))
    
    dat0_mlow <- get(paste0("do_", info$prefix, "_dat0_mlow"))
    dat0_mh_h <- get(paste0("do_", info$prefix, "_dat0_mh_h"))
    
    p <- plot_group_trend(
      dat_mlow, dat_mh_h,
      info$title2,
      dat0_mlow, dat0_mh_h, four_week = TRUE, y_label=info$ll, x_label=info$rr, info$beh
    )
    
    out_file <- glue("plot/fig4/do_{info$prefix}_risk_{key}")
    ggsave(paste0(out_file, ".pdf"), plot = p, width = 10, height = 6.5, device = cairo_pdf, family = "Aptos", bg = "transparent")
  }
  
  
  x_lab1 <- ggdraw() +draw_label("Help-seeking",x = 0.55,size = 23,fontface = "plain")
  x_lab2 <- ggdraw() +draw_label("Advice adherence",x = 0.55,size = 23,fontface = "plain")
  ggsave("plot/fig4/bx_lab1.pdf", plot = x_lab1, width = 10, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
  ggsave("plot/fig4/bx_lab2.pdf", plot = x_lab2, width = 10, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
  
  
  
  legend_df <- data.frame(
    label = c(
      "ZheePal high perceived", "ZheePal low perceived",
      "Usual high perceived", "Usual low perceived",
      "Intention", "Action"
    ),
    col = c("#ea801c", "#00b0be", "#c99b38", "#3594cc", "#C7C4B1", "#C7C4B1"),
    shape = c(NA, NA, NA, NA, 1, 16), 
    linetype = c("solid", "solid", "solid", "solid", NA, NA),
    x = c(1, 1, 1.9, 1.9, 2.6, 2.6),
    y = c(1.3, 1, 1.3, 1, 1.3, 1)
  )
  
  point_df <- legend_df %>% filter(!is.na(shape)) %>%
    mutate(stroke_val = ifelse(label == "Intention", 1.5, 2.5))
  
  p_legend <- ggplot(legend_df) +
    geom_segment(
      data = legend_df %>% filter(!is.na(linetype)),
      aes(x = x, xend = x + 0.15, y = y, yend = y, color = label, linetype = linetype),
      size = 1
    ) +
    geom_point(
      data = legend_df %>% filter(!is.na(shape)),
      aes(x = x+0.15, y = y, shape = factor(label), fill = label),
      size = 3,
      color = "#C7C4B1",
      stroke = point_df$stroke_val 
    ) +
    geom_text(
      aes(x = x + 0.2, y = y, label = label),
      hjust = 0,
      size = 4
    ) +
    scale_color_manual(values = setNames(legend_df$col[1:4], legend_df$label[1:4])) +
    scale_fill_manual(values = c("Intention" = "white", "Action" = "#C7C4B1")) +
    scale_shape_manual(values = c("Intention" = 1, "Action" = 16)) +
    theme_void() +
    coord_cartesian(xlim = c(0.5, 3.5), ylim = c(0.5, 2.5), clip = "off") +
    theme(legend.position = "none",
          plot.margin = margin(5,5,5,5))
  
  ggsave("plot/fig4/legendb.pdf", p_legend, width = 9, height = 2, device = cairo_pdf, family = "Aptos", bg = "transparent")
  
}


###          ###
### subfig_c ###
###          ###
cp_left <- ggplot(C_df_left_long, aes(x = x_pos, y = Time)) +
  geom_boxplot(
    aes(fill = Group, colour = Group),
    coef = 1.5,
    width = 0.4,        
    linewidth = 1,      
    fatten = 1,
    outlier.shape = NA,
    staplewidth = 0.4
  ) +
  scale_fill_manual(values = c(
    "ZheePal" = "#f0b077",
    "Usual"   = "#8cc5e3"
  ),
  labels = c(
    "ZheePal" = "ZheePal     ",
    "Usual"   = "Usual"
  )) +
  scale_colour_manual(values = c(
    "ZheePal" = "#ea801c",
    "Usual"   = "#3594cc"
  ),
  labels = c(
    "ZheePal" = "ZheePal     ",
    "Usual"   = "Usual"
  )) +
  scale_y_continuous(
    breaks = seq(0, 60, 10)
  ) +
  scale_x_continuous(
    breaks = c(1, 1.6)
  ) +
  coord_cartesian(ylim = c(0, 60), clip = "off") +
  geom_segment(x = 0.75, xend = 1.85, y = -2, yend = -2,
               color = "black", linewidth = 0.5) +
  geom_segment(y = 0, yend = 60, x = 0.6, xend = 0.6,
               color = "black", linewidth = 0.5) +
  geom_segment(x = 0.75, xend = 0.75, y = -2, yend = -3,
               color = "black", linewidth = 0.5) +
  geom_segment(x = 1.85, xend = 1.85, y = -2, yend = -3,
               color = "black", linewidth = 0.5) +
  geom_segment(
    data = data.frame(y = seq(0, 60, 10)),
    aes(x = 0.6, xend = 0.53, y = y, yend = y),
    inherit.aes = FALSE,
    color = "black",
    linewidth = 0.5
  ) +
  labs(
    x = NULL,
    y = "Duration (min)"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    
    legend.position = c(-0.2,1.35),
    legend.direction = "vertical",
    legend.justification = c(0,1),
    legend.title = element_blank(),
    legend.text = element_text(size = 20),
    legend.key.width  = unit(1.2, "cm"),
    legend.key.height = unit(0.8, "cm"),
    legend.key.spacing.y = unit(0.5, "cm"),
    
    axis.text.x = element_blank(),
    axis.text.y = element_text(size = 22, color = "black", margin = margin(r = 5)),
    axis.ticks = element_blank(),
    axis.title.y = element_text(size = 23, margin = margin(r = 30)),
    plot.margin = margin(t = 130, r = 80, b = 50, l = 5),
    text = element_text(face = "plain"),
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "transparent", colour = NA)
  )


radar <- function(summary_data) {
  
  ppp <- matrix(summary_data$pp, nrow=2, ncol=12)
  colnames(ppp) <- c(
    "", "Cognitive", "",
    "", "Anxiety", "",
    "", "Depression", "",
    "", "Loneliness", ""
  )
  rownames(ppp) <- unique(summary_data$group)
  
  name_col_inter <- c(
    "Risk", "Symptom", "Advice",
    "Risk", "Symptom", "Advice",
    "Risk", "Symptom", "Advice",
    "Risk", "Symptom", "Advice"
  )
  
  kl <- seq(2*pi+pi/2-pi/12, pi/2-pi/12, length.out = 13)[-13]  
  color <- c("#3594cc", "#ea801c")
  lwd = 2
  rad_low_lim <- 1
  start <- 0
  radial.plot(rep(rad_low_lim,12), rp.type="p", radial.lim=c(rad_low_lim,8.5), labels="",
              label.pos=kl, start=start, show.grid=FALSE, line.col=NA, point.col=NA, radial.labels=NA)
  n_labels <- length(c("", "0", "20", "40", "60", "80", "100", NA))
  radius_for_labels <- c(0, 7.6, 0, 0, 7.6, 0, 0, 7.6, 0, 0, 7.6, 0)
  sr <- c(0, -45, 0, 0, 45, 0, 0, -45, 0, 0, 45, 0)
  for(i in seq_along(radius_for_labels)) {
    text(x = cos(kl[i]) * radius_for_labels[i], 
         y = sin(kl[i]) * radius_for_labels[i], 
         srt = sr[i],
         labels = colnames(ppp)[i], cex = 2.7, font = 0)
  }
  radius_for_labels_inter <- c(6.6, 6.6, 6.6, 6.6, 6.6, 6.6, 6.6, 6.6, 6.6, 6.6, 6.6, 6.6)
  sr_inter <- c(-16, -45, -69, 69, 45, 16, -16, -45, -69, 69, 45, 16)
  for(i in seq_along(radius_for_labels)) {
    text(x = cos(kl[i]) * radius_for_labels_inter[i], 
         y = sin(kl[i]) * radius_for_labels_inter[i], 
         srt = sr_inter[i],
         labels = name_col_inter[i], cex = 2.3, font = 0)
  }
  
  
  angles <- rep(0,7)
  for (i in seq_along(angles)) {
    text_pos <-c((i-1)*sin(pi/3+pi/45), (i-1)*cos(pi/3+pi/45))
    text(text_pos[2], text_pos[1], labels = c("", "0", "20", "40", "60", "80", "100", NA)[i], srt = -20, col = "black",cex = 2.3)
  }
  
  l_l_pos <- 7.2
  
  line_radius <- 1:6  
  angles <- seq(0, 2*pi, length.out=200)
  
  lines(l_l_pos * cos(angles), l_l_pos * sin(angles), lwd=1, col="black")
  
  for (r in line_radius) {
    x <- r * cos(angles)
    y <- r * sin(angles)
    lines(x, y, lwd=1, col="#C7C4B1")
  }
  
  for (i in 1:12) {
    x <- c(0, 6 * cos(kl[i]))
    x_label <- c(l_l_pos * cos(kl[i]+pi/12), (l_l_pos+0.3) * cos(kl[i]+pi/12))
    y <- c(0, 6 * sin(kl[i]))
    y_label <- c(l_l_pos * sin(kl[i]+pi/12), (l_l_pos+0.3)* sin(kl[i]+pi/12))
    lines(x, y, col="#C7C4B1", lwd=1) 
    
    
    if (i %in% c(1, 4, 7, 10)){
      lines(x_label, y_label, col="black", lwd=1)
    }
  }
  
  for (j in 1:2) {
    r <- ppp[j,] - rad_low_lim
    x <- (r+1) * cos(kl + start)
    y <- (r+1) * sin(kl + start)
    polygon(c(x, x[1]), c(y, y[1]), col=adjustcolor(color[j], alpha.f=0.15), border=color[j], lwd=8)
    points(
      x,
      y,
      col=color[j],
      pch=21,
      bg = color[j],
      cex=5
    )
  }
  
  legend_x <- -8.6
  legend_y <- 7.2
  legend_labels <- rev(rownames(ppp))
  
  points(
    x = rep(legend_x, 2),
    y = legend_y + seq(0, -1, length.out=2),
    pch = 22,
    bg = adjustcolor(rev(color), alpha.f = 0.15),
    col = rev(color),
    cex = 5,
    lwd = 3
  )
  text(
    x = legend_x + 0.4,
    y = legend_y + seq(0, -1, length.out=2),
    labels = legend_labels,
    cex = 2.6,
    adj = 0
  )
 
}

CairoPDF("plot/fig4/c_right.pdf", width = 16, height = 13, family = "Aptos", bg = "transparent")
radar(C_df_right_long)
dev.off()


###          ###
### subfig_d ###
###          ###
level_labs_sta <- c(
  "1" = "Very\ndissatisfied",
  "2" = "Dissatisfied",
  "3" = "Okay",
  "4" = "Satisfied",
  "5" = "Very\nsatisfied"
)

level_labs_wil <- c(
  "1" = "Very\nunacceptable",
  "2" = "Unacceptable",
  "3" = "Okay",
  "4" = "acceptable",
  "5" = "Very\nacceptable"
)
plot_bar_count_d <- function(df, level_labels, x_lab = "", acc=FALSE) {
  
  p <- ggplot(df, aes(x = level, y = n, fill = group)) +
    geom_col(position = position_dodge(width = 0.8), width = 0.8) +
    scale_y_continuous(
      breaks = seq(0, 500, 100)
    ) +
    coord_cartesian(ylim = c(0, 500),clip = "off")+
    scale_fill_manual(values = c(
      "ZheePal" = "#e2939c",
      "Usual"   = "#bec8d3"
    )) +
    scale_x_discrete(labels = level_labels) +
    labs(x = x_lab, y = NULL, fill = NULL) +
    geom_segment(aes(x =1, xend = 5, y = -15, yend = -15), color = "black",linewidth=0.5) +
    geom_segment(aes(x =1, xend = 1, y = -15, yend = -30), color = "black",linewidth=0.5) +
    geom_segment(aes(x =2, xend = 2, y = -15, yend = -30), color = "black",linewidth=0.5) +
    geom_segment(aes(x =3, xend = 3, y = -15, yend = -30), color = "black",linewidth=0.5) +
    geom_segment(aes(x =4, xend = 4, y = -15, yend = -30), color = "black",linewidth=0.5) +
    geom_segment(aes(x =5, xend = 5, y = -15, yend = -30), color = "black",linewidth=0.5) +
    geom_segment(aes(y = 0, yend = 500, x = 0.4, xend = 0.4), color = "black",linewidth=0.5)+
    geom_segment(data = data.frame(
      x = 0.4, xend = 0.3,
      y = seq(0, 500, 100),
      yend = seq(0, 500, 100)),
      aes(x = x, xend = xend, y = y, yend = yend),
      color = "black", linewidth = 0.5, inherit.aes = FALSE
    )+
    theme_minimal() +
    theme(
      axis.text.x = element_text(size = 26, color = "black", margin = margin(t = 30), angle=45, hjust=1),
      axis.text.y = element_text(size = 31, color = "black", margin = margin(r = 20)),
      axis.title.x = element_text(size = 30, color = "black", margin = margin(t = 10)),
      axis.ticks = element_blank(),
      axis.line = element_blank(),
      legend.position = "none",
      panel.grid = element_blank(),
      plot.margin = if (acc) margin(r = 200, t=0, l = 0, b = 0) else margin(r = 200, t=20, l = 0, b = 0) ,
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.background = element_rect(fill = "transparent", colour = NA)
    )
  
  return(p)
}


p_satis <- plot_bar_count_d(df_satis_count, level_labs_sta, x_lab="Satisfaction")
p_will <- plot_bar_count_d(df_will_count, level_labs_wil, x_lab="Acceptability", acc=TRUE)
dy_lab <- ggdraw() + draw_label("Number of pariticpants", y = 0.50,x=0.2, angle = 90, size = 28)

p_d3 <- ggplot(D_df3_prop, aes(x = Dimension, y = Proportion, fill = Group)) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.8
  ) +
  scale_y_continuous(
    breaks = seq(0, 100, 20),
    labels = function(x) paste0(x, "%")
  ) +
  coord_cartesian(ylim = c(0, 100),clip = "off")+
  scale_fill_manual(values = c("ZheePal" = "#e2939c",
                               "Usual"   = "#bec8d3"),
                    labels = c("ZheePal        ", "Usual")) +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL
  ) +
  geom_segment(aes(y = 0, yend = 100, x = 0.3, xend = 0.3), color = "black",linewidth=0.5)+
  geom_segment(data = data.frame(
    x = 0.3, xend = 0.22,
    y = seq(0, 100, 20),
    yend = seq(0, 100, 20)),
    aes(x = x, xend = xend, y = y, yend = yend),
    color = "black", linewidth = 0.5, inherit.aes = FALSE
  )+
  geom_segment(x = 0.5, xend = 5.5, y = -3, yend = -3, color = "black", linewidth = 0.5) +
  geom_segment(x = 0.5, xend = 0.5, y = -3, yend = -6, color = "black", linewidth = 0.5) +
  geom_segment(x = 5.5, xend = 5.5, y = -3, yend = -6, color = "black", linewidth = 0.5) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 25, color = "black", angle = 45, hjust=1),
    axis.text.y = element_text(size = 30.5, color = "black", margin = margin(r = 20)),
    legend.position = "none",
    panel.grid = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_blank(),
    plot.margin = margin(r = 300),
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "transparent", colour = NA)
  )
legend_labeld <- ggdraw() +
  draw_grob(
    gridtext::richtext_grob(
      "<span style='color:#e2939c;'>ZheePal</span>versus<span style='color:#bec8d3;'>usual</span>",
      x = 0.25, y = 0.2,
      hjust = 0, vjust = 0,
      gp = gpar(fontsize = 28)
    )
  )

p_d4 <- ggplot(D_df4, aes(x = Dimension, y = Proportion)) +
  geom_col(width = 0.7, fill = "#FEE9D1") +
  scale_y_continuous(
    breaks = seq(0, 100, 25),
    labels = function(x) paste0(x, "%")
  ) +
  coord_cartesian(ylim = c(0, 100),clip = "off")+
  labs(
    x = NULL,
    y = NULL
  )  +
  geom_segment(y = 0, yend = 100, x = 0.3, xend = 0.3, color = "black",linewidth=0.5)+
  geom_segment(data = data.frame(
    x = 0.3, xend = 0.2,
    y = seq(0, 100, 25),
    yend = seq(0, 100, 25)),
    aes(x = x, xend = xend, y = y, yend = yend),
    color = "black", linewidth = 0.5, inherit.aes = FALSE
  )+
  geom_segment(x = 0.5, xend = 5.5, y = -3, yend = -3, color = "black", linewidth = 0.5) +
  geom_segment(x = 0.5, xend = 0.5, y = -3, yend = -6, color = "black", linewidth = 0.5) +
  geom_segment(x = 5.5, xend = 5.5, y = -3, yend = -6, color = "black", linewidth = 0.5) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 24, color = "black", angle = 45, hjust=1),
    axis.text.y = element_text(size = 28, color = "black", margin = margin(r = 20)),
    axis.title.y = element_text(size = 31, margin = margin(r = 35)),
    legend.position = "none",
    panel.grid = element_blank(),
    axis.ticks.y = element_blank(),
    axis.ticks.x = element_blank(),
    plot.margin = margin(r = 300, t=10, l = 80, b = 15),
    panel.background = element_rect(fill = "transparent", colour = NA),
    plot.background = element_rect(fill = "transparent", colour = NA)
  )


ggsave("plot/fig4/panelb_cognitive.pdf", ap_cognitive, width = 10, height = 6.5, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/panelb_mental.pdf",    ap_mental,    width = 10, height = 6.5, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/a_plegend1.pdf", legend_labela1,  width = 10, height = 1, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/a_plegend2.pdf", p_legenda2,  width =10, height =1.45, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/c_left.pdf", plot = cp_left, width = 5, height = 7, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/d_lab.pdf", plot = dy_lab, width = 1, height = 8, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/d_sta.pdf", plot = p_satis, width = 11, height = 6.8, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/d_wil.pdf", plot = p_will, width = 11, height = 6.8, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/d_rea.pdf", plot = p_d3, width = 13, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/d_plegend.pdf", plot = legend_labeld, width = 6, height = 0.5, device = cairo_pdf, family = "Aptos", bg = "transparent")
ggsave("plot/fig4/d_advan.pdf", plot = p_d4, width = 13, height = 6, device = cairo_pdf, family = "Aptos", bg = "transparent")







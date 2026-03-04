# analyze_data.R — полностью рабочий вариант

# Пути к файлу CSV и графику
csv_file <- "r_task/sample_data.csv"
plot_file <- "r_task/score_boxplot.png"

# Проверяем, что CSV существует
if (!file.exists(csv_file)) {
  stop("CSV файл не найден! Проверь, что sample_data.csv лежит в r_task/")
}

# Читаем CSV
data <- read.csv(csv_file)

# Выводим среднее значение Score
print(paste("Mean Score:", mean(data$Score)))

# Выводим максимальное значение Score в группе Treatment
print(paste("Max Score in Treatment:", max(data$Score[data$Group=="Treatment"])))

# Строим boxplot и сохраняем
png(plot_file)
boxplot(Score ~ Group, data=data, main="Score Distribution by Group", col=c("lightgreen", "pink"))
dev.off()

print(paste("График сохранён в", plot_file))
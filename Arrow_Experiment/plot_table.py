import matplotlib.pyplot as plt
import numpy as np

# 数据准备
experiments = ["Deflection 450", "Deflection 550", "Deflection 650"]
experiment_counts = [10, 10, 10]  # 每组实验次数

# 绘制柱状图
plt.figure(figsize=(8, 6))
plt.bar(experiments, experiment_counts, color='skyblue', edgecolor='black')
plt.title("Experiment 4", fontsize=14)
plt.xlabel("Deflection direction", fontsize=12)
plt.ylabel("Number of experiments", fontsize=12)
plt.xticks(fontsize=10, rotation=15)
plt.yticks(fontsize=10)
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()

# 保存图表
plt.savefig('/Users/jiangguilin/Desktop/Experiment4.png')
plt.show()

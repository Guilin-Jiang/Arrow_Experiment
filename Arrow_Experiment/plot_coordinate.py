import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# 读取文件路径的列表
file_paths = [
    '/Users/jiangguilin/Desktop/选箭系统项目/落点坐标1.09-1.15/实验1坐标/06_max_left_landing_coordinates.csv',
    '/Users/jiangguilin/Desktop/选箭系统项目/落点坐标1.09-1.15/实验1坐标/06_max_right_landing_coordinates.csv',
    '/Users/jiangguilin/Desktop/选箭系统项目/落点坐标1.09-1.15/实验1坐标/06_min_left_landing_coordinates.csv',
    '/Users/jiangguilin/Desktop/选箭系统项目/落点坐标1.09-1.15/实验1坐标/06_min_right_landing_coordinates.csv'
]

# 定义读取坐标的函数
def read_coordinates(file_path):
    try:
        data = pd.read_csv(file_path, header=None, names=['X', 'Y'], encoding='utf-8')
    except UnicodeDecodeError:
        data = pd.read_csv(file_path, header=None, names=['X', 'Y'], encoding='GBK')
    return data['X'], data['Y']

# 创建靶子
def draw_target():
    fig, ax = plt.subplots(figsize=(8, 8))
    ax.plot(0, 0, 'ko', markersize=5)
    ax.set_xlim(-25, 25)
    ax.set_ylim(-25, 25)
    ax.set_aspect('equal', 'box')
    return fig, ax

# 绘制所有射击点并计算标准差
def plot_shots():
    fig, ax = draw_target()

    for file_path in file_paths:
        x, y = read_coordinates(file_path)
        file_name = os.path.splitext(os.path.basename(file_path))[0]
        label = '_'.join(file_name.split('_')[:3])

        # 计算标准差
        std_x = np.std(x)
        std_y = np.std(y)

        # 打印标准差
        print(f"{label} - X Standard Deviation: {std_x:.2f}, Y Standard Deviation: {std_y:.2f}")

        # 绘制点，调整大小，设置标签
        ax.scatter(x, y, label=f'{label} - Shots', s=20)

    # 显示图例
    ax.legend()

    # 显示标题
    plt.title('Ten Ring Target with Shot Locations')

    save_path = os.path.expanduser('/Users/jiangguilin/Desktop/experiment1_shot.png')  # 将图像保存到桌面
    plt.savefig(save_path, bbox_inches='tight')  # bbox_inches='tight' 确保图像紧凑保存
    print(f"图像已保存到：{save_path}")
    
    # 显示靶子图
    plt.show()

# 调用绘图函数
plot_shots()

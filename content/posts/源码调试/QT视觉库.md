---
title: "Ot视觉库"
date: 2024-10-13 09:39:23
draft: false
categories: ["图像识别"]
tags: ["Qt"]
summary: "图像识别"
typora-root-url: ./..\..\..\static
---

> ### QT自动绑定信号槽

```c++
private slots:	
	void on_btnAdd_clicked();
```

> ### Application::processEvents作用

```c++
void frmImageSource::on_btnExecute_clicked()
{
	ui.btnExecute->setEnabled(false);//
	QApplication::processEvents();}这段代码QApplication::processEvents();
}
解释：
ui.btnExecute->setEnabled(false);：这行代码将按钮 btnExecute 设置为不可用（禁用状态），通常是为了防止用户在执行某个操作时再次点击按钮，从而避免重复执行同一操作。

QApplication::processEvents();：这一行代码会处理所有待处理的事件。这意味着即使按钮被禁用，用户界面仍然会保持响应状态，能够处理其他事件，比如窗口的重绘、其他控件的交互等。
```


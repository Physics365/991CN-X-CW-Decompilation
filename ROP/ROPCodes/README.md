# ROP 汇编器

## 简介

汇编器(asm.py) python编写完成，可以极大程度简化ROP编写过程

## 用法

### Windows
```
python .exe .\asm.py xxx
```
例子:
```
python.exe .\asm.py .\Examples\Single-Line-Print.asm
```
### Linux
```
python ./asm.py xxx
```
例子:
```
python ./asm.py ./Examples/Single-Line-Print.asm
```

## ROP示例(汇编器参考语法)

- [单行拼字](./Examples/Single-Line-Print.asm)  
- [双行拼字](./Examples/Double-Line-Print.asm)
- [三行拼字](./Examples/Triple-Line-Print.asm)
- [循环/按键/拼字](./Examples/Loop.asm)

## ROP持久化保存
- 什么？你嫌打一遍ROP拼字耗时太长？   
- 那就试试持久化你的ROP(关机不会消失！！)，每次只需少量代码即可
- [数据持久化](./Examples/Persistence/DataPersistence.md)

# auto-vtcm
编译cube &amp; vtcm环境、运行vtcm模拟器、退出环境的自动化脚本 <br/>
cube环境及vtcm由北京工业大学可信计算北京市重点实验室开发 => [here](https://github.com/TCLab-BJUT)

## 使用方法
### 安装依赖
* 安装gcc、make和内核开发套件
* ~~安装libwebsockets-dev~~
### 编译环境
```shell
chmod u+x ./vtcm_build.sh
./vtcm_build.sh
```
### 设置UUID
```shell
chmod u+x ./setuuid.sh
./setuuid.sh
```
### 运行模拟器
```shell
sudo chmod 777 ./vtcm_run.sh
sudo ./vtcm_run.sh
```
### 退出
```shell
sudo chmod 777 ./vtcm_exit.sh
sudo ./vtcm_exit.sh
```
### 写入环境变量设置
```shell
chmod u+x ./vtcm_setenv.sh
./vtcm_setenv.sh
```
### 恢复默认bashrc
```shell
chmod u+x ./restorebashrc.sh
./restorebashrc.sh
```
### qemu的tpm与host模拟器通信
```shell
sudo chmod 777 ./init_qemutcm.sh
sudo ./init_qemutcm.sh
```
***请在qemu使用，使用前需要确保qemu已经支持了tpm并已经与host的vtcm进行连接***

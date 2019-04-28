# auto-vtcm
编译cube &amp; vtcm环境、运行vtcm模拟器、退出环境的自动化脚本 <br/>
cube环境及vtcm由北京工业大学可信计算北京市重点实验室开发 => [here](https://github.com/TCLab-BJUT) <br/>具体使用查看[使用方法](#使用方法)，查看[快速开始](#快速开始)迅速开始基本操作

## 快速开始

```shell
# 增加执行权限
chmod u+x ./vtcmtools.sh
# 安装依赖
sudo apt install gcc make # 根据系统自行判断选择软件包管理工具
```

### 运行vtcm模拟器

```shell
./vtcmtools.sh build
# 运行
./vtcmtools.sh run
# 停止
./vtcmtools.sh quit
```

### 使用cube_manage开发

```shell
./vtcmtools.sh dev
```

### 清理所有文件

```shell
./vtcmtools.sh clean
```

### 开发模式与vtcm模拟器模式转换

```shell
# 开发模式 -> vtcm模拟器模式
./vtcmtools.sh setenv
# vtcm模拟器模式 -> 开发模式
./vtcmtools.sh setenv-dev
```



## 使用方法

### 安装依赖
* 安装gcc、make等开发工具~~和内核开发套件~~
* ~~安装libwebsockets-dev~~
### 设置脚本执行权限

```shell
chmod u+x ./vtcmtools.sh
```

### 执行工具

```shell
./vtcmtools.sh [command]
```

### Command列表

#### build

执行：下载，打补丁，编译，设置UUID，设置vtcm环境变量

#### dev

执行：下载开发工具，打补丁，编译，设置UUID，设置开发环境变量

#### clean

清理全部内容

#### download

仅下载全部所需包（vtcm）

#### download-dev

仅下载全部所需包（开发）

#### setuuid

设置UUID

#### patchcode

打补丁

#### setenv

设置环境变量（vtcm）

#### setenv-dev

设置环境变量（开发）

#### rmenv

删除所设置的环境变量

#### run

运行vtcm模拟器并载入vtcmd_dev模块

#### quit

关闭vtcm模拟器并卸载vtcmd_dev模块

#### vtcmd_dev

载入vtcmd_dev模块

#### unvtcmd_dev

卸载vtcmd_dev模块

#### initvm

初始化虚拟机TPM

***请在VM使用，使用前需要确保qemu已经支持了tpm并已经与host的vtcm进行连接***

#### restorebashrc

（谨慎使用）使用系统默认的bashrc覆盖现有文件


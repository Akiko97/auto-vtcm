# auto-vtcm
编译cube &amp; vtcm环境、运行vtcm模拟器、退出环境的自动化脚本 <br/>
cube环境及vtcm由北京工业大学可信计算北京市重点实验室开发 => [here](https://github.com/TCLab-BJUT) <br/>具体使用查看[使用方法](#使用方法)，查看[快速开始](#快速开始)迅速开始基本操作

## 快速开始

```shell
chmod u+x ./vtcmtools.sh
./vtcmtools.sh build
# 运行
./vtcmtools.sh run
# 停止
./vtcmtools.sh quit
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

执行：下载，打补丁，编译，设置UUID，设置环境变量

#### download

仅下载全部所需包

#### setuuid

设置UUID

#### patchcode

打补丁

#### setenv

设置环境变量

#### rmenv

删除环境变量

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


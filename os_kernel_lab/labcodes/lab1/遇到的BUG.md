## Lab4如何用gdb调试

直接用make debug会发现作业文件给出的默认断点设在了kernel的init这部分，找了半天找不到Lab4需要的bootmain的入口。

后来发现需要更改一个文件：`tools/gdbinit.`更改内容如下：

    file obj/bootblock.o
    target remote:1234
    break bootmain
    continue

其实就是指明了需要debug的程序时bootblock，然后在bootmain处打上断点，不用找半天bootmain入口在哪里。

## Lab5里的BUG

    	uint32_t ebp=read_ebp();
    	uint32_t eip=read_eip();
    	int i;   //这里有个细节问题，就是不能for int i，这里面的C标准似乎不允许
    	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
    	{
    		cprintf("ebp:0x%08x eip:0x%08x ",ebp,eip);
    		uint32_t *args=(uint32_t *)ebp+2;
    		cprintf("arg :0x%08x 0x%08x 0x%08x 0x%08x\n",*(args+0),*(args+1),*(args+2),*(args+3));
    //因为使用的是栈数据结构，因此可以直接根据ebp就能读取到各个栈帧的地址和值，ebp+4处为返回地址，
    //ebp+8处为第一个参数值（最后一个入栈的参数值，对应32位系统），ebp-4处为第一个局部变量，ebp处为上一层 ebp 值。
    		print_debuginfo(eip-1);
    		eip=((uint32_t *)ebp+1);
    		ebp=((uint32_t *)ebp+0);

Lab5中的问题是，我们习惯用的for循环是一个`for(int i=0......)`这样的结构，但是好像这里的C语言不支持这种循环，只要把i的声明写在for循环内就不能正常运行循环，一定要在循环外面声明。

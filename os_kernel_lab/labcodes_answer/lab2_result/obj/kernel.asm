
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 a0 11 00       	mov    $0x11a000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 a0 11 c0       	mov    %eax,0xc011a000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 90 11 c0       	mov    $0xc0119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100045:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c010004a:	83 ec 04             	sub    $0x4,%esp
c010004d:	50                   	push   %eax
c010004e:	6a 00                	push   $0x0
c0100050:	68 00 c0 11 c0       	push   $0xc011c000
c0100055:	e8 24 54 00 00       	call   c010547e <memset>
c010005a:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c010005d:	e8 37 16 00 00       	call   c0101699 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100062:	c7 45 f4 40 5c 10 c0 	movl   $0xc0105c40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100069:	83 ec 08             	sub    $0x8,%esp
c010006c:	ff 75 f4             	pushl  -0xc(%ebp)
c010006f:	68 5c 5c 10 c0       	push   $0xc0105c5c
c0100074:	e8 22 02 00 00       	call   c010029b <cprintf>
c0100079:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c010007c:	e8 d6 08 00 00       	call   c0100957 <print_kerninfo>

    grade_backtrace();
c0100081:	e8 80 00 00 00       	call   c0100106 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100086:	e8 89 31 00 00       	call   c0103214 <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 91 17 00 00       	call   c0101821 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 12 19 00 00       	call   c01019a7 <idt_init>

    clock_init();               // init clock interrupt
c0100095:	e8 46 0d 00 00       	call   c0100de0 <clock_init>
    intr_enable();              // enable irq interrupt
c010009a:	e8 d1 18 00 00       	call   c0101970 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009f:	eb fe                	jmp    c010009f <kern_init+0x69>

c01000a1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a1:	f3 0f 1e fb          	endbr32 
c01000a5:	55                   	push   %ebp
c01000a6:	89 e5                	mov    %esp,%ebp
c01000a8:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000ab:	83 ec 04             	sub    $0x4,%esp
c01000ae:	6a 00                	push   $0x0
c01000b0:	6a 00                	push   $0x0
c01000b2:	6a 00                	push   $0x0
c01000b4:	e8 11 0d 00 00       	call   c0100dca <mon_backtrace>
c01000b9:	83 c4 10             	add    $0x10,%esp
}
c01000bc:	90                   	nop
c01000bd:	c9                   	leave  
c01000be:	c3                   	ret    

c01000bf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000bf:	f3 0f 1e fb          	endbr32 
c01000c3:	55                   	push   %ebp
c01000c4:	89 e5                	mov    %esp,%ebp
c01000c6:	53                   	push   %ebx
c01000c7:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000ca:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000cd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d6:	51                   	push   %ecx
c01000d7:	52                   	push   %edx
c01000d8:	53                   	push   %ebx
c01000d9:	50                   	push   %eax
c01000da:	e8 c2 ff ff ff       	call   c01000a1 <grade_backtrace2>
c01000df:	83 c4 10             	add    $0x10,%esp
}
c01000e2:	90                   	nop
c01000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000e6:	c9                   	leave  
c01000e7:	c3                   	ret    

c01000e8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000e8:	f3 0f 1e fb          	endbr32 
c01000ec:	55                   	push   %ebp
c01000ed:	89 e5                	mov    %esp,%ebp
c01000ef:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000f2:	83 ec 08             	sub    $0x8,%esp
c01000f5:	ff 75 10             	pushl  0x10(%ebp)
c01000f8:	ff 75 08             	pushl  0x8(%ebp)
c01000fb:	e8 bf ff ff ff       	call   c01000bf <grade_backtrace1>
c0100100:	83 c4 10             	add    $0x10,%esp
}
c0100103:	90                   	nop
c0100104:	c9                   	leave  
c0100105:	c3                   	ret    

c0100106 <grade_backtrace>:

void
grade_backtrace(void) {
c0100106:	f3 0f 1e fb          	endbr32 
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100110:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100115:	83 ec 04             	sub    $0x4,%esp
c0100118:	68 00 00 ff ff       	push   $0xffff0000
c010011d:	50                   	push   %eax
c010011e:	6a 00                	push   $0x0
c0100120:	e8 c3 ff ff ff       	call   c01000e8 <grade_backtrace0>
c0100125:	83 c4 10             	add    $0x10,%esp
}
c0100128:	90                   	nop
c0100129:	c9                   	leave  
c010012a:	c3                   	ret    

c010012b <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012b:	f3 0f 1e fb          	endbr32 
c010012f:	55                   	push   %ebp
c0100130:	89 e5                	mov    %esp,%ebp
c0100132:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100145:	0f b7 c0             	movzwl %ax,%eax
c0100148:	83 e0 03             	and    $0x3,%eax
c010014b:	89 c2                	mov    %eax,%edx
c010014d:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100152:	83 ec 04             	sub    $0x4,%esp
c0100155:	52                   	push   %edx
c0100156:	50                   	push   %eax
c0100157:	68 61 5c 10 c0       	push   $0xc0105c61
c010015c:	e8 3a 01 00 00       	call   c010029b <cprintf>
c0100161:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100164:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100168:	0f b7 d0             	movzwl %ax,%edx
c010016b:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100170:	83 ec 04             	sub    $0x4,%esp
c0100173:	52                   	push   %edx
c0100174:	50                   	push   %eax
c0100175:	68 6f 5c 10 c0       	push   $0xc0105c6f
c010017a:	e8 1c 01 00 00       	call   c010029b <cprintf>
c010017f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100182:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100186:	0f b7 d0             	movzwl %ax,%edx
c0100189:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010018e:	83 ec 04             	sub    $0x4,%esp
c0100191:	52                   	push   %edx
c0100192:	50                   	push   %eax
c0100193:	68 7d 5c 10 c0       	push   $0xc0105c7d
c0100198:	e8 fe 00 00 00       	call   c010029b <cprintf>
c010019d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c01001a0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a4:	0f b7 d0             	movzwl %ax,%edx
c01001a7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ac:	83 ec 04             	sub    $0x4,%esp
c01001af:	52                   	push   %edx
c01001b0:	50                   	push   %eax
c01001b1:	68 8b 5c 10 c0       	push   $0xc0105c8b
c01001b6:	e8 e0 00 00 00       	call   c010029b <cprintf>
c01001bb:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001be:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c2:	0f b7 d0             	movzwl %ax,%edx
c01001c5:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ca:	83 ec 04             	sub    $0x4,%esp
c01001cd:	52                   	push   %edx
c01001ce:	50                   	push   %eax
c01001cf:	68 99 5c 10 c0       	push   $0xc0105c99
c01001d4:	e8 c2 00 00 00       	call   c010029b <cprintf>
c01001d9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001dc:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001e1:	83 c0 01             	add    $0x1,%eax
c01001e4:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c01001e9:	90                   	nop
c01001ea:	c9                   	leave  
c01001eb:	c3                   	ret    

c01001ec <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ec:	f3 0f 1e fb          	endbr32 
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	90                   	nop
c01001f4:	5d                   	pop    %ebp
c01001f5:	c3                   	ret    

c01001f6 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f6:	f3 0f 1e fb          	endbr32 
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fd:	90                   	nop
c01001fe:	5d                   	pop    %ebp
c01001ff:	c3                   	ret    

c0100200 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100200:	f3 0f 1e fb          	endbr32 
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
c0100207:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c010020a:	e8 1c ff ff ff       	call   c010012b <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020f:	83 ec 0c             	sub    $0xc,%esp
c0100212:	68 a8 5c 10 c0       	push   $0xc0105ca8
c0100217:	e8 7f 00 00 00       	call   c010029b <cprintf>
c010021c:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c010021f:	e8 c8 ff ff ff       	call   c01001ec <lab1_switch_to_user>
    lab1_print_cur_status();
c0100224:	e8 02 ff ff ff       	call   c010012b <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100229:	83 ec 0c             	sub    $0xc,%esp
c010022c:	68 c8 5c 10 c0       	push   $0xc0105cc8
c0100231:	e8 65 00 00 00       	call   c010029b <cprintf>
c0100236:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100239:	e8 b8 ff ff ff       	call   c01001f6 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023e:	e8 e8 fe ff ff       	call   c010012b <lab1_print_cur_status>
}
c0100243:	90                   	nop
c0100244:	c9                   	leave  
c0100245:	c3                   	ret    

c0100246 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100246:	f3 0f 1e fb          	endbr32 
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100250:	83 ec 0c             	sub    $0xc,%esp
c0100253:	ff 75 08             	pushl  0x8(%ebp)
c0100256:	e8 73 14 00 00       	call   c01016ce <cons_putc>
c010025b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010025e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100261:	8b 00                	mov    (%eax),%eax
c0100263:	8d 50 01             	lea    0x1(%eax),%edx
c0100266:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100269:	89 10                	mov    %edx,(%eax)
}
c010026b:	90                   	nop
c010026c:	c9                   	leave  
c010026d:	c3                   	ret    

c010026e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026e:	f3 0f 1e fb          	endbr32 
c0100272:	55                   	push   %ebp
c0100273:	89 e5                	mov    %esp,%ebp
c0100275:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100278:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010027f:	ff 75 0c             	pushl  0xc(%ebp)
c0100282:	ff 75 08             	pushl  0x8(%ebp)
c0100285:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100288:	50                   	push   %eax
c0100289:	68 46 02 10 c0       	push   $0xc0100246
c010028e:	e8 3a 55 00 00       	call   c01057cd <vprintfmt>
c0100293:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100296:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100299:	c9                   	leave  
c010029a:	c3                   	ret    

c010029b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010029b:	f3 0f 1e fb          	endbr32 
c010029f:	55                   	push   %ebp
c01002a0:	89 e5                	mov    %esp,%ebp
c01002a2:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a5:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ae:	83 ec 08             	sub    $0x8,%esp
c01002b1:	50                   	push   %eax
c01002b2:	ff 75 08             	pushl  0x8(%ebp)
c01002b5:	e8 b4 ff ff ff       	call   c010026e <vcprintf>
c01002ba:	83 c4 10             	add    $0x10,%esp
c01002bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c3:	c9                   	leave  
c01002c4:	c3                   	ret    

c01002c5 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c5:	f3 0f 1e fb          	endbr32 
c01002c9:	55                   	push   %ebp
c01002ca:	89 e5                	mov    %esp,%ebp
c01002cc:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002cf:	83 ec 0c             	sub    $0xc,%esp
c01002d2:	ff 75 08             	pushl  0x8(%ebp)
c01002d5:	e8 f4 13 00 00       	call   c01016ce <cons_putc>
c01002da:	83 c4 10             	add    $0x10,%esp
}
c01002dd:	90                   	nop
c01002de:	c9                   	leave  
c01002df:	c3                   	ret    

c01002e0 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002e0:	f3 0f 1e fb          	endbr32 
c01002e4:	55                   	push   %ebp
c01002e5:	89 e5                	mov    %esp,%ebp
c01002e7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002f1:	eb 14                	jmp    c0100307 <cputs+0x27>
        cputch(c, &cnt);
c01002f3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002f7:	83 ec 08             	sub    $0x8,%esp
c01002fa:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002fd:	52                   	push   %edx
c01002fe:	50                   	push   %eax
c01002ff:	e8 42 ff ff ff       	call   c0100246 <cputch>
c0100304:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c0100307:	8b 45 08             	mov    0x8(%ebp),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100310:	0f b6 00             	movzbl (%eax),%eax
c0100313:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100316:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010031a:	75 d7                	jne    c01002f3 <cputs+0x13>
    }
    cputch('\n', &cnt);
c010031c:	83 ec 08             	sub    $0x8,%esp
c010031f:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100322:	50                   	push   %eax
c0100323:	6a 0a                	push   $0xa
c0100325:	e8 1c ff ff ff       	call   c0100246 <cputch>
c010032a:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100330:	c9                   	leave  
c0100331:	c3                   	ret    

c0100332 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100332:	f3 0f 1e fb          	endbr32 
c0100336:	55                   	push   %ebp
c0100337:	89 e5                	mov    %esp,%ebp
c0100339:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010033c:	90                   	nop
c010033d:	e8 d9 13 00 00       	call   c010171b <cons_getc>
c0100342:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100349:	74 f2                	je     c010033d <getchar+0xb>
        /* do nothing */;
    return c;
c010034b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010034e:	c9                   	leave  
c010034f:	c3                   	ret    

c0100350 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100350:	f3 0f 1e fb          	endbr32 
c0100354:	55                   	push   %ebp
c0100355:	89 e5                	mov    %esp,%ebp
c0100357:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c010035a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010035e:	74 13                	je     c0100373 <readline+0x23>
        cprintf("%s", prompt);
c0100360:	83 ec 08             	sub    $0x8,%esp
c0100363:	ff 75 08             	pushl  0x8(%ebp)
c0100366:	68 e7 5c 10 c0       	push   $0xc0105ce7
c010036b:	e8 2b ff ff ff       	call   c010029b <cprintf>
c0100370:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100373:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010037a:	e8 b3 ff ff ff       	call   c0100332 <getchar>
c010037f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100386:	79 0a                	jns    c0100392 <readline+0x42>
            return NULL;
c0100388:	b8 00 00 00 00       	mov    $0x0,%eax
c010038d:	e9 82 00 00 00       	jmp    c0100414 <readline+0xc4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100392:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100396:	7e 2b                	jle    c01003c3 <readline+0x73>
c0100398:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010039f:	7f 22                	jg     c01003c3 <readline+0x73>
            cputchar(c);
c01003a1:	83 ec 0c             	sub    $0xc,%esp
c01003a4:	ff 75 f0             	pushl  -0x10(%ebp)
c01003a7:	e8 19 ff ff ff       	call   c01002c5 <cputchar>
c01003ac:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c01003af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b2:	8d 50 01             	lea    0x1(%eax),%edx
c01003b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003bb:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003c1:	eb 4c                	jmp    c010040f <readline+0xbf>
        }
        else if (c == '\b' && i > 0) {
c01003c3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003c7:	75 1a                	jne    c01003e3 <readline+0x93>
c01003c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003cd:	7e 14                	jle    c01003e3 <readline+0x93>
            cputchar(c);
c01003cf:	83 ec 0c             	sub    $0xc,%esp
c01003d2:	ff 75 f0             	pushl  -0x10(%ebp)
c01003d5:	e8 eb fe ff ff       	call   c01002c5 <cputchar>
c01003da:	83 c4 10             	add    $0x10,%esp
            i --;
c01003dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003e1:	eb 2c                	jmp    c010040f <readline+0xbf>
        }
        else if (c == '\n' || c == '\r') {
c01003e3:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003e7:	74 06                	je     c01003ef <readline+0x9f>
c01003e9:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003ed:	75 8b                	jne    c010037a <readline+0x2a>
            cputchar(c);
c01003ef:	83 ec 0c             	sub    $0xc,%esp
c01003f2:	ff 75 f0             	pushl  -0x10(%ebp)
c01003f5:	e8 cb fe ff ff       	call   c01002c5 <cputchar>
c01003fa:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100400:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c0100405:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100408:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c010040d:	eb 05                	jmp    c0100414 <readline+0xc4>
        c = getchar();
c010040f:	e9 66 ff ff ff       	jmp    c010037a <readline+0x2a>
        }
    }
}
c0100414:	c9                   	leave  
c0100415:	c3                   	ret    

c0100416 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100416:	f3 0f 1e fb          	endbr32 
c010041a:	55                   	push   %ebp
c010041b:	89 e5                	mov    %esp,%ebp
c010041d:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c0100420:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100425:	85 c0                	test   %eax,%eax
c0100427:	75 5f                	jne    c0100488 <__panic+0x72>
        goto panic_dead;
    }
    is_panic = 1;
c0100429:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c0100430:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100433:	8d 45 14             	lea    0x14(%ebp),%eax
c0100436:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100439:	83 ec 04             	sub    $0x4,%esp
c010043c:	ff 75 0c             	pushl  0xc(%ebp)
c010043f:	ff 75 08             	pushl  0x8(%ebp)
c0100442:	68 ea 5c 10 c0       	push   $0xc0105cea
c0100447:	e8 4f fe ff ff       	call   c010029b <cprintf>
c010044c:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010044f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100452:	83 ec 08             	sub    $0x8,%esp
c0100455:	50                   	push   %eax
c0100456:	ff 75 10             	pushl  0x10(%ebp)
c0100459:	e8 10 fe ff ff       	call   c010026e <vcprintf>
c010045e:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100461:	83 ec 0c             	sub    $0xc,%esp
c0100464:	68 06 5d 10 c0       	push   $0xc0105d06
c0100469:	e8 2d fe ff ff       	call   c010029b <cprintf>
c010046e:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100471:	83 ec 0c             	sub    $0xc,%esp
c0100474:	68 08 5d 10 c0       	push   $0xc0105d08
c0100479:	e8 1d fe ff ff       	call   c010029b <cprintf>
c010047e:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100481:	e8 25 06 00 00       	call   c0100aab <print_stackframe>
c0100486:	eb 01                	jmp    c0100489 <__panic+0x73>
        goto panic_dead;
c0100488:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100489:	e8 ee 14 00 00       	call   c010197c <intr_disable>
    while (1) {
        kmonitor(NULL);
c010048e:	83 ec 0c             	sub    $0xc,%esp
c0100491:	6a 00                	push   $0x0
c0100493:	e8 4c 08 00 00       	call   c0100ce4 <kmonitor>
c0100498:	83 c4 10             	add    $0x10,%esp
c010049b:	eb f1                	jmp    c010048e <__panic+0x78>

c010049d <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010049d:	f3 0f 1e fb          	endbr32 
c01004a1:	55                   	push   %ebp
c01004a2:	89 e5                	mov    %esp,%ebp
c01004a4:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c01004a7:	8d 45 14             	lea    0x14(%ebp),%eax
c01004aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004ad:	83 ec 04             	sub    $0x4,%esp
c01004b0:	ff 75 0c             	pushl  0xc(%ebp)
c01004b3:	ff 75 08             	pushl  0x8(%ebp)
c01004b6:	68 1a 5d 10 c0       	push   $0xc0105d1a
c01004bb:	e8 db fd ff ff       	call   c010029b <cprintf>
c01004c0:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c01004c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004c6:	83 ec 08             	sub    $0x8,%esp
c01004c9:	50                   	push   %eax
c01004ca:	ff 75 10             	pushl  0x10(%ebp)
c01004cd:	e8 9c fd ff ff       	call   c010026e <vcprintf>
c01004d2:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c01004d5:	83 ec 0c             	sub    $0xc,%esp
c01004d8:	68 06 5d 10 c0       	push   $0xc0105d06
c01004dd:	e8 b9 fd ff ff       	call   c010029b <cprintf>
c01004e2:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01004e5:	90                   	nop
c01004e6:	c9                   	leave  
c01004e7:	c3                   	ret    

c01004e8 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004e8:	f3 0f 1e fb          	endbr32 
c01004ec:	55                   	push   %ebp
c01004ed:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ef:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c01004f4:	5d                   	pop    %ebp
c01004f5:	c3                   	ret    

c01004f6 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004f6:	f3 0f 1e fb          	endbr32 
c01004fa:	55                   	push   %ebp
c01004fb:	89 e5                	mov    %esp,%ebp
c01004fd:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100508:	8b 45 10             	mov    0x10(%ebp),%eax
c010050b:	8b 00                	mov    (%eax),%eax
c010050d:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100517:	e9 d2 00 00 00       	jmp    c01005ee <stab_binsearch+0xf8>
        int true_m = (l + r) / 2, m = true_m;
c010051c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100522:	01 d0                	add    %edx,%eax
c0100524:	89 c2                	mov    %eax,%edx
c0100526:	c1 ea 1f             	shr    $0x1f,%edx
c0100529:	01 d0                	add    %edx,%eax
c010052b:	d1 f8                	sar    %eax
c010052d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100530:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100533:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100536:	eb 04                	jmp    c010053c <stab_binsearch+0x46>
            m --;
c0100538:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c010053c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010053f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100542:	7c 1f                	jl     c0100563 <stab_binsearch+0x6d>
c0100544:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100547:	89 d0                	mov    %edx,%eax
c0100549:	01 c0                	add    %eax,%eax
c010054b:	01 d0                	add    %edx,%eax
c010054d:	c1 e0 02             	shl    $0x2,%eax
c0100550:	89 c2                	mov    %eax,%edx
c0100552:	8b 45 08             	mov    0x8(%ebp),%eax
c0100555:	01 d0                	add    %edx,%eax
c0100557:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010055b:	0f b6 c0             	movzbl %al,%eax
c010055e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100561:	75 d5                	jne    c0100538 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100569:	7d 0b                	jge    c0100576 <stab_binsearch+0x80>
            l = true_m + 1;
c010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056e:	83 c0 01             	add    $0x1,%eax
c0100571:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100574:	eb 78                	jmp    c01005ee <stab_binsearch+0xf8>
        }

        // actual binary search
        any_matches = 1;
c0100576:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100580:	89 d0                	mov    %edx,%eax
c0100582:	01 c0                	add    %eax,%eax
c0100584:	01 d0                	add    %edx,%eax
c0100586:	c1 e0 02             	shl    $0x2,%eax
c0100589:	89 c2                	mov    %eax,%edx
c010058b:	8b 45 08             	mov    0x8(%ebp),%eax
c010058e:	01 d0                	add    %edx,%eax
c0100590:	8b 40 08             	mov    0x8(%eax),%eax
c0100593:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100596:	76 13                	jbe    c01005ab <stab_binsearch+0xb5>
            *region_left = m;
c0100598:	8b 45 0c             	mov    0xc(%ebp),%eax
c010059b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010059e:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005a3:	83 c0 01             	add    $0x1,%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005a9:	eb 43                	jmp    c01005ee <stab_binsearch+0xf8>
        } else if (stabs[m].n_value > addr) {
c01005ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005ae:	89 d0                	mov    %edx,%eax
c01005b0:	01 c0                	add    %eax,%eax
c01005b2:	01 d0                	add    %edx,%eax
c01005b4:	c1 e0 02             	shl    $0x2,%eax
c01005b7:	89 c2                	mov    %eax,%edx
c01005b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005bc:	01 d0                	add    %edx,%eax
c01005be:	8b 40 08             	mov    0x8(%eax),%eax
c01005c1:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005c4:	73 16                	jae    c01005dc <stab_binsearch+0xe6>
            *region_right = m - 1;
c01005c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005c9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01005cf:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005da:	eb 12                	jmp    c01005ee <stab_binsearch+0xf8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005e2:	89 10                	mov    %edx,(%eax)
            l = m;
c01005e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005ea:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005f4:	0f 8e 22 ff ff ff    	jle    c010051c <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c01005fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005fe:	75 0f                	jne    c010060f <stab_binsearch+0x119>
        *region_right = *region_left - 1;
c0100600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100603:	8b 00                	mov    (%eax),%eax
c0100605:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100608:	8b 45 10             	mov    0x10(%ebp),%eax
c010060b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010060d:	eb 3f                	jmp    c010064e <stab_binsearch+0x158>
        l = *region_right;
c010060f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100617:	eb 04                	jmp    c010061d <stab_binsearch+0x127>
c0100619:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	8b 00                	mov    (%eax),%eax
c0100622:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100625:	7e 1f                	jle    c0100646 <stab_binsearch+0x150>
c0100627:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010062a:	89 d0                	mov    %edx,%eax
c010062c:	01 c0                	add    %eax,%eax
c010062e:	01 d0                	add    %edx,%eax
c0100630:	c1 e0 02             	shl    $0x2,%eax
c0100633:	89 c2                	mov    %eax,%edx
c0100635:	8b 45 08             	mov    0x8(%ebp),%eax
c0100638:	01 d0                	add    %edx,%eax
c010063a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010063e:	0f b6 c0             	movzbl %al,%eax
c0100641:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100644:	75 d3                	jne    c0100619 <stab_binsearch+0x123>
        *region_left = l;
c0100646:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100649:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010064c:	89 10                	mov    %edx,(%eax)
}
c010064e:	90                   	nop
c010064f:	c9                   	leave  
c0100650:	c3                   	ret    

c0100651 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100651:	f3 0f 1e fb          	endbr32 
c0100655:	55                   	push   %ebp
c0100656:	89 e5                	mov    %esp,%ebp
c0100658:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010065b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065e:	c7 00 38 5d 10 c0    	movl   $0xc0105d38,(%eax)
    info->eip_line = 0;
c0100664:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010066e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100671:	c7 40 08 38 5d 10 c0 	movl   $0xc0105d38,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100678:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067b:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100682:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100685:	8b 55 08             	mov    0x8(%ebp),%edx
c0100688:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010068b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010068e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100695:	c7 45 f4 60 6f 10 c0 	movl   $0xc0106f60,-0xc(%ebp)
    stab_end = __STAB_END__;
c010069c:	c7 45 f0 9c 38 11 c0 	movl   $0xc011389c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006a3:	c7 45 ec 9d 38 11 c0 	movl   $0xc011389d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006aa:	c7 45 e8 b6 63 11 c0 	movl   $0xc01163b6,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006b7:	76 0d                	jbe    c01006c6 <debuginfo_eip+0x75>
c01006b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006bc:	83 e8 01             	sub    $0x1,%eax
c01006bf:	0f b6 00             	movzbl (%eax),%eax
c01006c2:	84 c0                	test   %al,%al
c01006c4:	74 0a                	je     c01006d0 <debuginfo_eip+0x7f>
        return -1;
c01006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006cb:	e9 85 02 00 00       	jmp    c0100955 <debuginfo_eip+0x304>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006dd:	c1 f8 02             	sar    $0x2,%eax
c01006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006e6:	83 e8 01             	sub    $0x1,%eax
c01006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006ec:	ff 75 08             	pushl  0x8(%ebp)
c01006ef:	6a 64                	push   $0x64
c01006f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006f4:	50                   	push   %eax
c01006f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006f8:	50                   	push   %eax
c01006f9:	ff 75 f4             	pushl  -0xc(%ebp)
c01006fc:	e8 f5 fd ff ff       	call   c01004f6 <stab_binsearch>
c0100701:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100707:	85 c0                	test   %eax,%eax
c0100709:	75 0a                	jne    c0100715 <debuginfo_eip+0xc4>
        return -1;
c010070b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100710:	e9 40 02 00 00       	jmp    c0100955 <debuginfo_eip+0x304>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100718:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010071b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100721:	ff 75 08             	pushl  0x8(%ebp)
c0100724:	6a 24                	push   $0x24
c0100726:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100729:	50                   	push   %eax
c010072a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010072d:	50                   	push   %eax
c010072e:	ff 75 f4             	pushl  -0xc(%ebp)
c0100731:	e8 c0 fd ff ff       	call   c01004f6 <stab_binsearch>
c0100736:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c0100739:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010073c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010073f:	39 c2                	cmp    %eax,%edx
c0100741:	7f 78                	jg     c01007bb <debuginfo_eip+0x16a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 c2                	mov    %eax,%edx
c0100748:	89 d0                	mov    %edx,%eax
c010074a:	01 c0                	add    %eax,%eax
c010074c:	01 d0                	add    %edx,%eax
c010074e:	c1 e0 02             	shl    $0x2,%eax
c0100751:	89 c2                	mov    %eax,%edx
c0100753:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100756:	01 d0                	add    %edx,%eax
c0100758:	8b 10                	mov    (%eax),%edx
c010075a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010075d:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100760:	39 c2                	cmp    %eax,%edx
c0100762:	73 22                	jae    c0100786 <debuginfo_eip+0x135>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100764:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100767:	89 c2                	mov    %eax,%edx
c0100769:	89 d0                	mov    %edx,%eax
c010076b:	01 c0                	add    %eax,%eax
c010076d:	01 d0                	add    %edx,%eax
c010076f:	c1 e0 02             	shl    $0x2,%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100777:	01 d0                	add    %edx,%eax
c0100779:	8b 10                	mov    (%eax),%edx
c010077b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010077e:	01 c2                	add    %eax,%edx
c0100780:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100783:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100786:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	8b 50 08             	mov    0x8(%eax),%edx
c010079e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a1:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a7:	8b 40 10             	mov    0x10(%eax),%eax
c01007aa:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007b9:	eb 15                	jmp    c01007d0 <debuginfo_eip+0x17f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007be:	8b 55 08             	mov    0x8(%ebp),%edx
c01007c1:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 40 08             	mov    0x8(%eax),%eax
c01007d6:	83 ec 08             	sub    $0x8,%esp
c01007d9:	6a 3a                	push   $0x3a
c01007db:	50                   	push   %eax
c01007dc:	e8 09 4b 00 00       	call   c01052ea <strfind>
c01007e1:	83 c4 10             	add    $0x10,%esp
c01007e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01007e7:	8b 52 08             	mov    0x8(%edx),%edx
c01007ea:	29 d0                	sub    %edx,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007f4:	83 ec 0c             	sub    $0xc,%esp
c01007f7:	ff 75 08             	pushl  0x8(%ebp)
c01007fa:	6a 44                	push   $0x44
c01007fc:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007ff:	50                   	push   %eax
c0100800:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100803:	50                   	push   %eax
c0100804:	ff 75 f4             	pushl  -0xc(%ebp)
c0100807:	e8 ea fc ff ff       	call   c01004f6 <stab_binsearch>
c010080c:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c010080f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100812:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100815:	39 c2                	cmp    %eax,%edx
c0100817:	7f 24                	jg     c010083d <debuginfo_eip+0x1ec>
        info->eip_line = stabs[rline].n_desc;
c0100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010081c:	89 c2                	mov    %eax,%edx
c010081e:	89 d0                	mov    %edx,%eax
c0100820:	01 c0                	add    %eax,%eax
c0100822:	01 d0                	add    %edx,%eax
c0100824:	c1 e0 02             	shl    $0x2,%eax
c0100827:	89 c2                	mov    %eax,%edx
c0100829:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082c:	01 d0                	add    %edx,%eax
c010082e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100832:	0f b7 d0             	movzwl %ax,%edx
c0100835:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100838:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010083b:	eb 13                	jmp    c0100850 <debuginfo_eip+0x1ff>
        return -1;
c010083d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100842:	e9 0e 01 00 00       	jmp    c0100955 <debuginfo_eip+0x304>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100847:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084a:	83 e8 01             	sub    $0x1,%eax
c010084d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100850:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100856:	39 c2                	cmp    %eax,%edx
c0100858:	7c 56                	jl     c01008b0 <debuginfo_eip+0x25f>
           && stabs[lline].n_type != N_SOL
c010085a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085d:	89 c2                	mov    %eax,%edx
c010085f:	89 d0                	mov    %edx,%eax
c0100861:	01 c0                	add    %eax,%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	c1 e0 02             	shl    $0x2,%eax
c0100868:	89 c2                	mov    %eax,%edx
c010086a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086d:	01 d0                	add    %edx,%eax
c010086f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100873:	3c 84                	cmp    $0x84,%al
c0100875:	74 39                	je     c01008b0 <debuginfo_eip+0x25f>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010087a:	89 c2                	mov    %eax,%edx
c010087c:	89 d0                	mov    %edx,%eax
c010087e:	01 c0                	add    %eax,%eax
c0100880:	01 d0                	add    %edx,%eax
c0100882:	c1 e0 02             	shl    $0x2,%eax
c0100885:	89 c2                	mov    %eax,%edx
c0100887:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010088a:	01 d0                	add    %edx,%eax
c010088c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100890:	3c 64                	cmp    $0x64,%al
c0100892:	75 b3                	jne    c0100847 <debuginfo_eip+0x1f6>
c0100894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100897:	89 c2                	mov    %eax,%edx
c0100899:	89 d0                	mov    %edx,%eax
c010089b:	01 c0                	add    %eax,%eax
c010089d:	01 d0                	add    %edx,%eax
c010089f:	c1 e0 02             	shl    $0x2,%eax
c01008a2:	89 c2                	mov    %eax,%edx
c01008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a7:	01 d0                	add    %edx,%eax
c01008a9:	8b 40 08             	mov    0x8(%eax),%eax
c01008ac:	85 c0                	test   %eax,%eax
c01008ae:	74 97                	je     c0100847 <debuginfo_eip+0x1f6>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008b6:	39 c2                	cmp    %eax,%edx
c01008b8:	7c 42                	jl     c01008fc <debuginfo_eip+0x2ab>
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	89 c2                	mov    %eax,%edx
c01008bf:	89 d0                	mov    %edx,%eax
c01008c1:	01 c0                	add    %eax,%eax
c01008c3:	01 d0                	add    %edx,%eax
c01008c5:	c1 e0 02             	shl    $0x2,%eax
c01008c8:	89 c2                	mov    %eax,%edx
c01008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cd:	01 d0                	add    %edx,%eax
c01008cf:	8b 10                	mov    (%eax),%edx
c01008d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01008d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01008d7:	39 c2                	cmp    %eax,%edx
c01008d9:	73 21                	jae    c01008fc <debuginfo_eip+0x2ab>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008de:	89 c2                	mov    %eax,%edx
c01008e0:	89 d0                	mov    %edx,%eax
c01008e2:	01 c0                	add    %eax,%eax
c01008e4:	01 d0                	add    %edx,%eax
c01008e6:	c1 e0 02             	shl    $0x2,%eax
c01008e9:	89 c2                	mov    %eax,%edx
c01008eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ee:	01 d0                	add    %edx,%eax
c01008f0:	8b 10                	mov    (%eax),%edx
c01008f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f5:	01 c2                	add    %eax,%edx
c01008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fa:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100902:	39 c2                	cmp    %eax,%edx
c0100904:	7d 4a                	jge    c0100950 <debuginfo_eip+0x2ff>
        for (lline = lfun + 1;
c0100906:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100909:	83 c0 01             	add    $0x1,%eax
c010090c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010090f:	eb 18                	jmp    c0100929 <debuginfo_eip+0x2d8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100911:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100914:	8b 40 14             	mov    0x14(%eax),%eax
c0100917:	8d 50 01             	lea    0x1(%eax),%edx
c010091a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091d:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100920:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100923:	83 c0 01             	add    $0x1,%eax
c0100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010092f:	39 c2                	cmp    %eax,%edx
c0100931:	7d 1d                	jge    c0100950 <debuginfo_eip+0x2ff>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100936:	89 c2                	mov    %eax,%edx
c0100938:	89 d0                	mov    %edx,%eax
c010093a:	01 c0                	add    %eax,%eax
c010093c:	01 d0                	add    %edx,%eax
c010093e:	c1 e0 02             	shl    $0x2,%eax
c0100941:	89 c2                	mov    %eax,%edx
c0100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100946:	01 d0                	add    %edx,%eax
c0100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010094c:	3c a0                	cmp    $0xa0,%al
c010094e:	74 c1                	je     c0100911 <debuginfo_eip+0x2c0>
        }
    }
    return 0;
c0100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100955:	c9                   	leave  
c0100956:	c3                   	ret    

c0100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100957:	f3 0f 1e fb          	endbr32 
c010095b:	55                   	push   %ebp
c010095c:	89 e5                	mov    %esp,%ebp
c010095e:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100961:	83 ec 0c             	sub    $0xc,%esp
c0100964:	68 42 5d 10 c0       	push   $0xc0105d42
c0100969:	e8 2d f9 ff ff       	call   c010029b <cprintf>
c010096e:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100971:	83 ec 08             	sub    $0x8,%esp
c0100974:	68 36 00 10 c0       	push   $0xc0100036
c0100979:	68 5b 5d 10 c0       	push   $0xc0105d5b
c010097e:	e8 18 f9 ff ff       	call   c010029b <cprintf>
c0100983:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100986:	83 ec 08             	sub    $0x8,%esp
c0100989:	68 3f 5c 10 c0       	push   $0xc0105c3f
c010098e:	68 73 5d 10 c0       	push   $0xc0105d73
c0100993:	e8 03 f9 ff ff       	call   c010029b <cprintf>
c0100998:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010099b:	83 ec 08             	sub    $0x8,%esp
c010099e:	68 00 c0 11 c0       	push   $0xc011c000
c01009a3:	68 8b 5d 10 c0       	push   $0xc0105d8b
c01009a8:	e8 ee f8 ff ff       	call   c010029b <cprintf>
c01009ad:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c01009b0:	83 ec 08             	sub    $0x8,%esp
c01009b3:	68 28 cf 11 c0       	push   $0xc011cf28
c01009b8:	68 a3 5d 10 c0       	push   $0xc0105da3
c01009bd:	e8 d9 f8 ff ff       	call   c010029b <cprintf>
c01009c2:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009c5:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c01009ca:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009cf:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009d4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009da:	85 c0                	test   %eax,%eax
c01009dc:	0f 48 c2             	cmovs  %edx,%eax
c01009df:	c1 f8 0a             	sar    $0xa,%eax
c01009e2:	83 ec 08             	sub    $0x8,%esp
c01009e5:	50                   	push   %eax
c01009e6:	68 bc 5d 10 c0       	push   $0xc0105dbc
c01009eb:	e8 ab f8 ff ff       	call   c010029b <cprintf>
c01009f0:	83 c4 10             	add    $0x10,%esp
}
c01009f3:	90                   	nop
c01009f4:	c9                   	leave  
c01009f5:	c3                   	ret    

c01009f6 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009f6:	f3 0f 1e fb          	endbr32 
c01009fa:	55                   	push   %ebp
c01009fb:	89 e5                	mov    %esp,%ebp
c01009fd:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a03:	83 ec 08             	sub    $0x8,%esp
c0100a06:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a09:	50                   	push   %eax
c0100a0a:	ff 75 08             	pushl  0x8(%ebp)
c0100a0d:	e8 3f fc ff ff       	call   c0100651 <debuginfo_eip>
c0100a12:	83 c4 10             	add    $0x10,%esp
c0100a15:	85 c0                	test   %eax,%eax
c0100a17:	74 15                	je     c0100a2e <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a19:	83 ec 08             	sub    $0x8,%esp
c0100a1c:	ff 75 08             	pushl  0x8(%ebp)
c0100a1f:	68 e6 5d 10 c0       	push   $0xc0105de6
c0100a24:	e8 72 f8 ff ff       	call   c010029b <cprintf>
c0100a29:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a2c:	eb 65                	jmp    c0100a93 <print_debuginfo+0x9d>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a35:	eb 1c                	jmp    c0100a53 <print_debuginfo+0x5d>
            fnname[j] = info.eip_fn_name[j];
c0100a37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a3d:	01 d0                	add    %edx,%eax
c0100a3f:	0f b6 00             	movzbl (%eax),%eax
c0100a42:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a4b:	01 ca                	add    %ecx,%edx
c0100a4d:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a56:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a59:	7c dc                	jl     c0100a37 <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a5b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a64:	01 d0                	add    %edx,%eax
c0100a66:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a6f:	89 d1                	mov    %edx,%ecx
c0100a71:	29 c1                	sub    %eax,%ecx
c0100a73:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a79:	83 ec 0c             	sub    $0xc,%esp
c0100a7c:	51                   	push   %ecx
c0100a7d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a83:	51                   	push   %ecx
c0100a84:	52                   	push   %edx
c0100a85:	50                   	push   %eax
c0100a86:	68 02 5e 10 c0       	push   $0xc0105e02
c0100a8b:	e8 0b f8 ff ff       	call   c010029b <cprintf>
c0100a90:	83 c4 20             	add    $0x20,%esp
}
c0100a93:	90                   	nop
c0100a94:	c9                   	leave  
c0100a95:	c3                   	ret    

c0100a96 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a96:	f3 0f 1e fb          	endbr32 
c0100a9a:	55                   	push   %ebp
c0100a9b:	89 e5                	mov    %esp,%ebp
c0100a9d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100aa0:	8b 45 04             	mov    0x4(%ebp),%eax
c0100aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100aa9:	c9                   	leave  
c0100aaa:	c3                   	ret    

c0100aab <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100aab:	f3 0f 1e fb          	endbr32 
c0100aaf:	55                   	push   %ebp
c0100ab0:	89 e5                	mov    %esp,%ebp
c0100ab2:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ab5:	89 e8                	mov    %ebp,%eax
c0100ab7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ac0:	e8 d1 ff ff ff       	call   c0100a96 <read_eip>
c0100ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100ac8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100acf:	e9 8d 00 00 00       	jmp    c0100b61 <print_stackframe+0xb6>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100ad4:	83 ec 04             	sub    $0x4,%esp
c0100ad7:	ff 75 f0             	pushl  -0x10(%ebp)
c0100ada:	ff 75 f4             	pushl  -0xc(%ebp)
c0100add:	68 14 5e 10 c0       	push   $0xc0105e14
c0100ae2:	e8 b4 f7 ff ff       	call   c010029b <cprintf>
c0100ae7:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	83 c0 08             	add    $0x8,%eax
c0100af0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100af3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100afa:	eb 26                	jmp    c0100b22 <print_stackframe+0x77>
            cprintf("0x%08x ", args[j]);
c0100afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100aff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b09:	01 d0                	add    %edx,%eax
c0100b0b:	8b 00                	mov    (%eax),%eax
c0100b0d:	83 ec 08             	sub    $0x8,%esp
c0100b10:	50                   	push   %eax
c0100b11:	68 30 5e 10 c0       	push   $0xc0105e30
c0100b16:	e8 80 f7 ff ff       	call   c010029b <cprintf>
c0100b1b:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c0100b1e:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b22:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b26:	7e d4                	jle    c0100afc <print_stackframe+0x51>
        }
        cprintf("\n");
c0100b28:	83 ec 0c             	sub    $0xc,%esp
c0100b2b:	68 38 5e 10 c0       	push   $0xc0105e38
c0100b30:	e8 66 f7 ff ff       	call   c010029b <cprintf>
c0100b35:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b3b:	83 e8 01             	sub    $0x1,%eax
c0100b3e:	83 ec 0c             	sub    $0xc,%esp
c0100b41:	50                   	push   %eax
c0100b42:	e8 af fe ff ff       	call   c01009f6 <print_debuginfo>
c0100b47:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b4d:	83 c0 04             	add    $0x4,%eax
c0100b50:	8b 00                	mov    (%eax),%eax
c0100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b58:	8b 00                	mov    (%eax),%eax
c0100b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b5d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b65:	74 0a                	je     c0100b71 <print_stackframe+0xc6>
c0100b67:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b6b:	0f 8e 63 ff ff ff    	jle    c0100ad4 <print_stackframe+0x29>
    }
}
c0100b71:	90                   	nop
c0100b72:	c9                   	leave  
c0100b73:	c3                   	ret    

c0100b74 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b74:	f3 0f 1e fb          	endbr32 
c0100b78:	55                   	push   %ebp
c0100b79:	89 e5                	mov    %esp,%ebp
c0100b7b:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b85:	eb 0c                	jmp    c0100b93 <parse+0x1f>
            *buf ++ = '\0';
c0100b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b8a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b8d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b90:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b96:	0f b6 00             	movzbl (%eax),%eax
c0100b99:	84 c0                	test   %al,%al
c0100b9b:	74 1e                	je     c0100bbb <parse+0x47>
c0100b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba0:	0f b6 00             	movzbl (%eax),%eax
c0100ba3:	0f be c0             	movsbl %al,%eax
c0100ba6:	83 ec 08             	sub    $0x8,%esp
c0100ba9:	50                   	push   %eax
c0100baa:	68 bc 5e 10 c0       	push   $0xc0105ebc
c0100baf:	e8 ff 46 00 00       	call   c01052b3 <strchr>
c0100bb4:	83 c4 10             	add    $0x10,%esp
c0100bb7:	85 c0                	test   %eax,%eax
c0100bb9:	75 cc                	jne    c0100b87 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bbe:	0f b6 00             	movzbl (%eax),%eax
c0100bc1:	84 c0                	test   %al,%al
c0100bc3:	74 65                	je     c0100c2a <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bc5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bc9:	75 12                	jne    c0100bdd <parse+0x69>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bcb:	83 ec 08             	sub    $0x8,%esp
c0100bce:	6a 10                	push   $0x10
c0100bd0:	68 c1 5e 10 c0       	push   $0xc0105ec1
c0100bd5:	e8 c1 f6 ff ff       	call   c010029b <cprintf>
c0100bda:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be0:	8d 50 01             	lea    0x1(%eax),%edx
c0100be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100be6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bf0:	01 c2                	add    %eax,%edx
c0100bf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf5:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bf7:	eb 04                	jmp    c0100bfd <parse+0x89>
            buf ++;
c0100bf9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c00:	0f b6 00             	movzbl (%eax),%eax
c0100c03:	84 c0                	test   %al,%al
c0100c05:	74 8c                	je     c0100b93 <parse+0x1f>
c0100c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0a:	0f b6 00             	movzbl (%eax),%eax
c0100c0d:	0f be c0             	movsbl %al,%eax
c0100c10:	83 ec 08             	sub    $0x8,%esp
c0100c13:	50                   	push   %eax
c0100c14:	68 bc 5e 10 c0       	push   $0xc0105ebc
c0100c19:	e8 95 46 00 00       	call   c01052b3 <strchr>
c0100c1e:	83 c4 10             	add    $0x10,%esp
c0100c21:	85 c0                	test   %eax,%eax
c0100c23:	74 d4                	je     c0100bf9 <parse+0x85>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c25:	e9 69 ff ff ff       	jmp    c0100b93 <parse+0x1f>
            break;
c0100c2a:	90                   	nop
        }
    }
    return argc;
c0100c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c2e:	c9                   	leave  
c0100c2f:	c3                   	ret    

c0100c30 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c30:	f3 0f 1e fb          	endbr32 
c0100c34:	55                   	push   %ebp
c0100c35:	89 e5                	mov    %esp,%ebp
c0100c37:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c3a:	83 ec 08             	sub    $0x8,%esp
c0100c3d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c40:	50                   	push   %eax
c0100c41:	ff 75 08             	pushl  0x8(%ebp)
c0100c44:	e8 2b ff ff ff       	call   c0100b74 <parse>
c0100c49:	83 c4 10             	add    $0x10,%esp
c0100c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c53:	75 0a                	jne    c0100c5f <runcmd+0x2f>
        return 0;
c0100c55:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c5a:	e9 83 00 00 00       	jmp    c0100ce2 <runcmd+0xb2>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c66:	eb 59                	jmp    c0100cc1 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c68:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c7c:	8b 00                	mov    (%eax),%eax
c0100c7e:	83 ec 08             	sub    $0x8,%esp
c0100c81:	51                   	push   %ecx
c0100c82:	50                   	push   %eax
c0100c83:	e8 84 45 00 00       	call   c010520c <strcmp>
c0100c88:	83 c4 10             	add    $0x10,%esp
c0100c8b:	85 c0                	test   %eax,%eax
c0100c8d:	75 2e                	jne    c0100cbd <runcmd+0x8d>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c92:	89 d0                	mov    %edx,%eax
c0100c94:	01 c0                	add    %eax,%eax
c0100c96:	01 d0                	add    %edx,%eax
c0100c98:	c1 e0 02             	shl    $0x2,%eax
c0100c9b:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100ca0:	8b 10                	mov    (%eax),%edx
c0100ca2:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100ca5:	83 c0 04             	add    $0x4,%eax
c0100ca8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100cab:	83 e9 01             	sub    $0x1,%ecx
c0100cae:	83 ec 04             	sub    $0x4,%esp
c0100cb1:	ff 75 0c             	pushl  0xc(%ebp)
c0100cb4:	50                   	push   %eax
c0100cb5:	51                   	push   %ecx
c0100cb6:	ff d2                	call   *%edx
c0100cb8:	83 c4 10             	add    $0x10,%esp
c0100cbb:	eb 25                	jmp    c0100ce2 <runcmd+0xb2>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc4:	83 f8 02             	cmp    $0x2,%eax
c0100cc7:	76 9f                	jbe    c0100c68 <runcmd+0x38>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ccc:	83 ec 08             	sub    $0x8,%esp
c0100ccf:	50                   	push   %eax
c0100cd0:	68 df 5e 10 c0       	push   $0xc0105edf
c0100cd5:	e8 c1 f5 ff ff       	call   c010029b <cprintf>
c0100cda:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100cdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce2:	c9                   	leave  
c0100ce3:	c3                   	ret    

c0100ce4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ce4:	f3 0f 1e fb          	endbr32 
c0100ce8:	55                   	push   %ebp
c0100ce9:	89 e5                	mov    %esp,%ebp
c0100ceb:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cee:	83 ec 0c             	sub    $0xc,%esp
c0100cf1:	68 f8 5e 10 c0       	push   $0xc0105ef8
c0100cf6:	e8 a0 f5 ff ff       	call   c010029b <cprintf>
c0100cfb:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100cfe:	83 ec 0c             	sub    $0xc,%esp
c0100d01:	68 20 5f 10 c0       	push   $0xc0105f20
c0100d06:	e8 90 f5 ff ff       	call   c010029b <cprintf>
c0100d0b:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100d0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d12:	74 0e                	je     c0100d22 <kmonitor+0x3e>
        print_trapframe(tf);
c0100d14:	83 ec 0c             	sub    $0xc,%esp
c0100d17:	ff 75 08             	pushl  0x8(%ebp)
c0100d1a:	e8 cf 0d 00 00       	call   c0101aee <print_trapframe>
c0100d1f:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d22:	83 ec 0c             	sub    $0xc,%esp
c0100d25:	68 45 5f 10 c0       	push   $0xc0105f45
c0100d2a:	e8 21 f6 ff ff       	call   c0100350 <readline>
c0100d2f:	83 c4 10             	add    $0x10,%esp
c0100d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d39:	74 e7                	je     c0100d22 <kmonitor+0x3e>
            if (runcmd(buf, tf) < 0) {
c0100d3b:	83 ec 08             	sub    $0x8,%esp
c0100d3e:	ff 75 08             	pushl  0x8(%ebp)
c0100d41:	ff 75 f4             	pushl  -0xc(%ebp)
c0100d44:	e8 e7 fe ff ff       	call   c0100c30 <runcmd>
c0100d49:	83 c4 10             	add    $0x10,%esp
c0100d4c:	85 c0                	test   %eax,%eax
c0100d4e:	78 02                	js     c0100d52 <kmonitor+0x6e>
        if ((buf = readline("K> ")) != NULL) {
c0100d50:	eb d0                	jmp    c0100d22 <kmonitor+0x3e>
                break;
c0100d52:	90                   	nop
            }
        }
    }
}
c0100d53:	90                   	nop
c0100d54:	c9                   	leave  
c0100d55:	c3                   	ret    

c0100d56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d56:	f3 0f 1e fb          	endbr32 
c0100d5a:	55                   	push   %ebp
c0100d5b:	89 e5                	mov    %esp,%ebp
c0100d5d:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d67:	eb 3c                	jmp    c0100da5 <mon_help+0x4f>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d6c:	89 d0                	mov    %edx,%eax
c0100d6e:	01 c0                	add    %eax,%eax
c0100d70:	01 d0                	add    %edx,%eax
c0100d72:	c1 e0 02             	shl    $0x2,%eax
c0100d75:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100d7a:	8b 08                	mov    (%eax),%ecx
c0100d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7f:	89 d0                	mov    %edx,%eax
c0100d81:	01 c0                	add    %eax,%eax
c0100d83:	01 d0                	add    %edx,%eax
c0100d85:	c1 e0 02             	shl    $0x2,%eax
c0100d88:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100d8d:	8b 00                	mov    (%eax),%eax
c0100d8f:	83 ec 04             	sub    $0x4,%esp
c0100d92:	51                   	push   %ecx
c0100d93:	50                   	push   %eax
c0100d94:	68 49 5f 10 c0       	push   $0xc0105f49
c0100d99:	e8 fd f4 ff ff       	call   c010029b <cprintf>
c0100d9e:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100da1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da8:	83 f8 02             	cmp    $0x2,%eax
c0100dab:	76 bc                	jbe    c0100d69 <mon_help+0x13>
    }
    return 0;
c0100dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100db2:	c9                   	leave  
c0100db3:	c3                   	ret    

c0100db4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db4:	f3 0f 1e fb          	endbr32 
c0100db8:	55                   	push   %ebp
c0100db9:	89 e5                	mov    %esp,%ebp
c0100dbb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dbe:	e8 94 fb ff ff       	call   c0100957 <print_kerninfo>
    return 0;
c0100dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc8:	c9                   	leave  
c0100dc9:	c3                   	ret    

c0100dca <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dca:	f3 0f 1e fb          	endbr32 
c0100dce:	55                   	push   %ebp
c0100dcf:	89 e5                	mov    %esp,%ebp
c0100dd1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dd4:	e8 d2 fc ff ff       	call   c0100aab <print_stackframe>
    return 0;
c0100dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dde:	c9                   	leave  
c0100ddf:	c3                   	ret    

c0100de0 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100de0:	f3 0f 1e fb          	endbr32 
c0100de4:	55                   	push   %ebp
c0100de5:	89 e5                	mov    %esp,%ebp
c0100de7:	83 ec 18             	sub    $0x18,%esp
c0100dea:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100df0:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100df4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100df8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dfc:	ee                   	out    %al,(%dx)
}
c0100dfd:	90                   	nop
c0100dfe:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e04:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e08:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e0c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e10:	ee                   	out    %al,(%dx)
}
c0100e11:	90                   	nop
c0100e12:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e18:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e1c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e20:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e24:	ee                   	out    %al,(%dx)
}
c0100e25:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e26:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0100e2d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e30:	83 ec 0c             	sub    $0xc,%esp
c0100e33:	68 52 5f 10 c0       	push   $0xc0105f52
c0100e38:	e8 5e f4 ff ff       	call   c010029b <cprintf>
c0100e3d:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100e40:	83 ec 0c             	sub    $0xc,%esp
c0100e43:	6a 00                	push   $0x0
c0100e45:	e8 a6 09 00 00       	call   c01017f0 <pic_enable>
c0100e4a:	83 c4 10             	add    $0x10,%esp
}
c0100e4d:	90                   	nop
c0100e4e:	c9                   	leave  
c0100e4f:	c3                   	ret    

c0100e50 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e50:	55                   	push   %ebp
c0100e51:	89 e5                	mov    %esp,%ebp
c0100e53:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e56:	9c                   	pushf  
c0100e57:	58                   	pop    %eax
c0100e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e5e:	25 00 02 00 00       	and    $0x200,%eax
c0100e63:	85 c0                	test   %eax,%eax
c0100e65:	74 0c                	je     c0100e73 <__intr_save+0x23>
        intr_disable();
c0100e67:	e8 10 0b 00 00       	call   c010197c <intr_disable>
        return 1;
c0100e6c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e71:	eb 05                	jmp    c0100e78 <__intr_save+0x28>
    }
    return 0;
c0100e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e78:	c9                   	leave  
c0100e79:	c3                   	ret    

c0100e7a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e7a:	55                   	push   %ebp
c0100e7b:	89 e5                	mov    %esp,%ebp
c0100e7d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e84:	74 05                	je     c0100e8b <__intr_restore+0x11>
        intr_enable();
c0100e86:	e8 e5 0a 00 00       	call   c0101970 <intr_enable>
    }
}
c0100e8b:	90                   	nop
c0100e8c:	c9                   	leave  
c0100e8d:	c3                   	ret    

c0100e8e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e8e:	f3 0f 1e fb          	endbr32 
c0100e92:	55                   	push   %ebp
c0100e93:	89 e5                	mov    %esp,%ebp
c0100e95:	83 ec 10             	sub    $0x10,%esp
c0100e98:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e9e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ea2:	89 c2                	mov    %eax,%edx
c0100ea4:	ec                   	in     (%dx),%al
c0100ea5:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ea8:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100eae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100eb2:	89 c2                	mov    %eax,%edx
c0100eb4:	ec                   	in     (%dx),%al
c0100eb5:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100eb8:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ebe:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ec2:	89 c2                	mov    %eax,%edx
c0100ec4:	ec                   	in     (%dx),%al
c0100ec5:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100ec8:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ece:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ed2:	89 c2                	mov    %eax,%edx
c0100ed4:	ec                   	in     (%dx),%al
c0100ed5:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ed8:	90                   	nop
c0100ed9:	c9                   	leave  
c0100eda:	c3                   	ret    

c0100edb <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100edb:	f3 0f 1e fb          	endbr32 
c0100edf:	55                   	push   %ebp
c0100ee0:	89 e5                	mov    %esp,%ebp
c0100ee2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ee5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eef:	0f b7 00             	movzwl (%eax),%eax
c0100ef2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ef9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f01:	0f b7 00             	movzwl (%eax),%eax
c0100f04:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100f08:	74 12                	je     c0100f1c <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f0a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f11:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f18:	b4 03 
c0100f1a:	eb 13                	jmp    c0100f2f <cga_init+0x54>
    } else {
        *cp = was;
c0100f1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f1f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f23:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f26:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f2d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f2f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f36:	0f b7 c0             	movzwl %ax,%eax
c0100f39:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f3d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f41:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f45:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f49:	ee                   	out    %al,(%dx)
}
c0100f4a:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f4b:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f52:	83 c0 01             	add    $0x1,%eax
c0100f55:	0f b7 c0             	movzwl %ax,%eax
c0100f58:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f60:	89 c2                	mov    %eax,%edx
c0100f62:	ec                   	in     (%dx),%al
c0100f63:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f66:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f6a:	0f b6 c0             	movzbl %al,%eax
c0100f6d:	c1 e0 08             	shl    $0x8,%eax
c0100f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f73:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f7a:	0f b7 c0             	movzwl %ax,%eax
c0100f7d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f81:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f85:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f89:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8d:	ee                   	out    %al,(%dx)
}
c0100f8e:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f8f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f96:	83 c0 01             	add    $0x1,%eax
c0100f99:	0f b7 c0             	movzwl %ax,%eax
c0100f9c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fa0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fa4:	89 c2                	mov    %eax,%edx
c0100fa6:	ec                   	in     (%dx),%al
c0100fa7:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100faa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fae:	0f b6 c0             	movzbl %al,%eax
c0100fb1:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb7:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fbf:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100fc5:	90                   	nop
c0100fc6:	c9                   	leave  
c0100fc7:	c3                   	ret    

c0100fc8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fc8:	f3 0f 1e fb          	endbr32 
c0100fcc:	55                   	push   %ebp
c0100fcd:	89 e5                	mov    %esp,%ebp
c0100fcf:	83 ec 38             	sub    $0x38,%esp
c0100fd2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fd8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdc:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100fe0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fe4:	ee                   	out    %al,(%dx)
}
c0100fe5:	90                   	nop
c0100fe6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100fec:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100ff4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100ff8:	ee                   	out    %al,(%dx)
}
c0100ff9:	90                   	nop
c0100ffa:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101000:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101004:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101008:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010100c:	ee                   	out    %al,(%dx)
}
c010100d:	90                   	nop
c010100e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101014:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101018:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010101c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101020:	ee                   	out    %al,(%dx)
}
c0101021:	90                   	nop
c0101022:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101028:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010102c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101030:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101034:	ee                   	out    %al,(%dx)
}
c0101035:	90                   	nop
c0101036:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c010103c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101040:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101044:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101048:	ee                   	out    %al,(%dx)
}
c0101049:	90                   	nop
c010104a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101050:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101054:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101058:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010105c:	ee                   	out    %al,(%dx)
}
c010105d:	90                   	nop
c010105e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101064:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101068:	89 c2                	mov    %eax,%edx
c010106a:	ec                   	in     (%dx),%al
c010106b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010106e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101072:	3c ff                	cmp    $0xff,%al
c0101074:	0f 95 c0             	setne  %al
c0101077:	0f b6 c0             	movzbl %al,%eax
c010107a:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c010107f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101085:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101089:	89 c2                	mov    %eax,%edx
c010108b:	ec                   	in     (%dx),%al
c010108c:	88 45 f1             	mov    %al,-0xf(%ebp)
c010108f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101095:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101099:	89 c2                	mov    %eax,%edx
c010109b:	ec                   	in     (%dx),%al
c010109c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010109f:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01010a4:	85 c0                	test   %eax,%eax
c01010a6:	74 0d                	je     c01010b5 <serial_init+0xed>
        pic_enable(IRQ_COM1);
c01010a8:	83 ec 0c             	sub    $0xc,%esp
c01010ab:	6a 04                	push   $0x4
c01010ad:	e8 3e 07 00 00       	call   c01017f0 <pic_enable>
c01010b2:	83 c4 10             	add    $0x10,%esp
    }
}
c01010b5:	90                   	nop
c01010b6:	c9                   	leave  
c01010b7:	c3                   	ret    

c01010b8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010b8:	f3 0f 1e fb          	endbr32 
c01010bc:	55                   	push   %ebp
c01010bd:	89 e5                	mov    %esp,%ebp
c01010bf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010c9:	eb 09                	jmp    c01010d4 <lpt_putc_sub+0x1c>
        delay();
c01010cb:	e8 be fd ff ff       	call   c0100e8e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01010d4:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010da:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010de:	89 c2                	mov    %eax,%edx
c01010e0:	ec                   	in     (%dx),%al
c01010e1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010e4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010e8:	84 c0                	test   %al,%al
c01010ea:	78 09                	js     c01010f5 <lpt_putc_sub+0x3d>
c01010ec:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010f3:	7e d6                	jle    c01010cb <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c01010f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f8:	0f b6 c0             	movzbl %al,%eax
c01010fb:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101101:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101104:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101108:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010110c:	ee                   	out    %al,(%dx)
}
c010110d:	90                   	nop
c010110e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101114:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101118:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010111c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101120:	ee                   	out    %al,(%dx)
}
c0101121:	90                   	nop
c0101122:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101128:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010112c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101130:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101134:	ee                   	out    %al,(%dx)
}
c0101135:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101136:	90                   	nop
c0101137:	c9                   	leave  
c0101138:	c3                   	ret    

c0101139 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101139:	f3 0f 1e fb          	endbr32 
c010113d:	55                   	push   %ebp
c010113e:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101140:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101144:	74 0d                	je     c0101153 <lpt_putc+0x1a>
        lpt_putc_sub(c);
c0101146:	ff 75 08             	pushl  0x8(%ebp)
c0101149:	e8 6a ff ff ff       	call   c01010b8 <lpt_putc_sub>
c010114e:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101151:	eb 1e                	jmp    c0101171 <lpt_putc+0x38>
        lpt_putc_sub('\b');
c0101153:	6a 08                	push   $0x8
c0101155:	e8 5e ff ff ff       	call   c01010b8 <lpt_putc_sub>
c010115a:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c010115d:	6a 20                	push   $0x20
c010115f:	e8 54 ff ff ff       	call   c01010b8 <lpt_putc_sub>
c0101164:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c0101167:	6a 08                	push   $0x8
c0101169:	e8 4a ff ff ff       	call   c01010b8 <lpt_putc_sub>
c010116e:	83 c4 04             	add    $0x4,%esp
}
c0101171:	90                   	nop
c0101172:	c9                   	leave  
c0101173:	c3                   	ret    

c0101174 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101174:	f3 0f 1e fb          	endbr32 
c0101178:	55                   	push   %ebp
c0101179:	89 e5                	mov    %esp,%ebp
c010117b:	53                   	push   %ebx
c010117c:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010117f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101182:	b0 00                	mov    $0x0,%al
c0101184:	85 c0                	test   %eax,%eax
c0101186:	75 07                	jne    c010118f <cga_putc+0x1b>
        c |= 0x0700;
c0101188:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010118f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101192:	0f b6 c0             	movzbl %al,%eax
c0101195:	83 f8 0d             	cmp    $0xd,%eax
c0101198:	74 6c                	je     c0101206 <cga_putc+0x92>
c010119a:	83 f8 0d             	cmp    $0xd,%eax
c010119d:	0f 8f 9d 00 00 00    	jg     c0101240 <cga_putc+0xcc>
c01011a3:	83 f8 08             	cmp    $0x8,%eax
c01011a6:	74 0a                	je     c01011b2 <cga_putc+0x3e>
c01011a8:	83 f8 0a             	cmp    $0xa,%eax
c01011ab:	74 49                	je     c01011f6 <cga_putc+0x82>
c01011ad:	e9 8e 00 00 00       	jmp    c0101240 <cga_putc+0xcc>
    case '\b':
        if (crt_pos > 0) {
c01011b2:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011b9:	66 85 c0             	test   %ax,%ax
c01011bc:	0f 84 a4 00 00 00    	je     c0101266 <cga_putc+0xf2>
            crt_pos --;
c01011c2:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011c9:	83 e8 01             	sub    $0x1,%eax
c01011cc:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d5:	b0 00                	mov    $0x0,%al
c01011d7:	83 c8 20             	or     $0x20,%eax
c01011da:	89 c1                	mov    %eax,%ecx
c01011dc:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01011e1:	0f b7 15 44 c4 11 c0 	movzwl 0xc011c444,%edx
c01011e8:	0f b7 d2             	movzwl %dx,%edx
c01011eb:	01 d2                	add    %edx,%edx
c01011ed:	01 d0                	add    %edx,%eax
c01011ef:	89 ca                	mov    %ecx,%edx
c01011f1:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c01011f4:	eb 70                	jmp    c0101266 <cga_putc+0xf2>
    case '\n':
        crt_pos += CRT_COLS;
c01011f6:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011fd:	83 c0 50             	add    $0x50,%eax
c0101200:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101206:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c010120d:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101214:	0f b7 c1             	movzwl %cx,%eax
c0101217:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010121d:	c1 e8 10             	shr    $0x10,%eax
c0101220:	89 c2                	mov    %eax,%edx
c0101222:	66 c1 ea 06          	shr    $0x6,%dx
c0101226:	89 d0                	mov    %edx,%eax
c0101228:	c1 e0 02             	shl    $0x2,%eax
c010122b:	01 d0                	add    %edx,%eax
c010122d:	c1 e0 04             	shl    $0x4,%eax
c0101230:	29 c1                	sub    %eax,%ecx
c0101232:	89 ca                	mov    %ecx,%edx
c0101234:	89 d8                	mov    %ebx,%eax
c0101236:	29 d0                	sub    %edx,%eax
c0101238:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c010123e:	eb 27                	jmp    c0101267 <cga_putc+0xf3>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101240:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101246:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010124d:	8d 50 01             	lea    0x1(%eax),%edx
c0101250:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c0101257:	0f b7 c0             	movzwl %ax,%eax
c010125a:	01 c0                	add    %eax,%eax
c010125c:	01 c8                	add    %ecx,%eax
c010125e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101261:	66 89 10             	mov    %dx,(%eax)
        break;
c0101264:	eb 01                	jmp    c0101267 <cga_putc+0xf3>
        break;
c0101266:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101267:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010126e:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101272:	76 59                	jbe    c01012cd <cga_putc+0x159>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101274:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101279:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010127f:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c0101284:	83 ec 04             	sub    $0x4,%esp
c0101287:	68 00 0f 00 00       	push   $0xf00
c010128c:	52                   	push   %edx
c010128d:	50                   	push   %eax
c010128e:	e8 2e 42 00 00       	call   c01054c1 <memmove>
c0101293:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101296:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010129d:	eb 15                	jmp    c01012b4 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
c010129f:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012a7:	01 d2                	add    %edx,%edx
c01012a9:	01 d0                	add    %edx,%eax
c01012ab:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01012b4:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012bb:	7e e2                	jle    c010129f <cga_putc+0x12b>
        }
        crt_pos -= CRT_COLS;
c01012bd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012c4:	83 e8 50             	sub    $0x50,%eax
c01012c7:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012cd:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012d4:	0f b7 c0             	movzwl %ax,%eax
c01012d7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012db:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012df:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012e3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e7:	ee                   	out    %al,(%dx)
}
c01012e8:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012e9:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012f0:	66 c1 e8 08          	shr    $0x8,%ax
c01012f4:	0f b6 c0             	movzbl %al,%eax
c01012f7:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c01012fe:	83 c2 01             	add    $0x1,%edx
c0101301:	0f b7 d2             	movzwl %dx,%edx
c0101304:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101308:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010130f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101313:	ee                   	out    %al,(%dx)
}
c0101314:	90                   	nop
    outb(addr_6845, 15);
c0101315:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c010131c:	0f b7 c0             	movzwl %ax,%eax
c010131f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101323:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101327:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010132b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010132f:	ee                   	out    %al,(%dx)
}
c0101330:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101331:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101338:	0f b6 c0             	movzbl %al,%eax
c010133b:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101342:	83 c2 01             	add    $0x1,%edx
c0101345:	0f b7 d2             	movzwl %dx,%edx
c0101348:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010134c:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101353:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101357:	ee                   	out    %al,(%dx)
}
c0101358:	90                   	nop
}
c0101359:	90                   	nop
c010135a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c010135d:	c9                   	leave  
c010135e:	c3                   	ret    

c010135f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010135f:	f3 0f 1e fb          	endbr32 
c0101363:	55                   	push   %ebp
c0101364:	89 e5                	mov    %esp,%ebp
c0101366:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101370:	eb 09                	jmp    c010137b <serial_putc_sub+0x1c>
        delay();
c0101372:	e8 17 fb ff ff       	call   c0100e8e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101377:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010137b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101381:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101385:	89 c2                	mov    %eax,%edx
c0101387:	ec                   	in     (%dx),%al
c0101388:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010138b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010138f:	0f b6 c0             	movzbl %al,%eax
c0101392:	83 e0 20             	and    $0x20,%eax
c0101395:	85 c0                	test   %eax,%eax
c0101397:	75 09                	jne    c01013a2 <serial_putc_sub+0x43>
c0101399:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013a0:	7e d0                	jle    c0101372 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a5:	0f b6 c0             	movzbl %al,%eax
c01013a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013ae:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013b1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013b5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013b9:	ee                   	out    %al,(%dx)
}
c01013ba:	90                   	nop
}
c01013bb:	90                   	nop
c01013bc:	c9                   	leave  
c01013bd:	c3                   	ret    

c01013be <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013be:	f3 0f 1e fb          	endbr32 
c01013c2:	55                   	push   %ebp
c01013c3:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01013c5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013c9:	74 0d                	je     c01013d8 <serial_putc+0x1a>
        serial_putc_sub(c);
c01013cb:	ff 75 08             	pushl  0x8(%ebp)
c01013ce:	e8 8c ff ff ff       	call   c010135f <serial_putc_sub>
c01013d3:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013d6:	eb 1e                	jmp    c01013f6 <serial_putc+0x38>
        serial_putc_sub('\b');
c01013d8:	6a 08                	push   $0x8
c01013da:	e8 80 ff ff ff       	call   c010135f <serial_putc_sub>
c01013df:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c01013e2:	6a 20                	push   $0x20
c01013e4:	e8 76 ff ff ff       	call   c010135f <serial_putc_sub>
c01013e9:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c01013ec:	6a 08                	push   $0x8
c01013ee:	e8 6c ff ff ff       	call   c010135f <serial_putc_sub>
c01013f3:	83 c4 04             	add    $0x4,%esp
}
c01013f6:	90                   	nop
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013f9:	f3 0f 1e fb          	endbr32 
c01013fd:	55                   	push   %ebp
c01013fe:	89 e5                	mov    %esp,%ebp
c0101400:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101403:	eb 33                	jmp    c0101438 <cons_intr+0x3f>
        if (c != 0) {
c0101405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101409:	74 2d                	je     c0101438 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c010140b:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101410:	8d 50 01             	lea    0x1(%eax),%edx
c0101413:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c0101419:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010141c:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101422:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101427:	3d 00 02 00 00       	cmp    $0x200,%eax
c010142c:	75 0a                	jne    c0101438 <cons_intr+0x3f>
                cons.wpos = 0;
c010142e:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c0101435:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101438:	8b 45 08             	mov    0x8(%ebp),%eax
c010143b:	ff d0                	call   *%eax
c010143d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101440:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101444:	75 bf                	jne    c0101405 <cons_intr+0xc>
            }
        }
    }
}
c0101446:	90                   	nop
c0101447:	90                   	nop
c0101448:	c9                   	leave  
c0101449:	c3                   	ret    

c010144a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010144a:	f3 0f 1e fb          	endbr32 
c010144e:	55                   	push   %ebp
c010144f:	89 e5                	mov    %esp,%ebp
c0101451:	83 ec 10             	sub    $0x10,%esp
c0101454:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010145e:	89 c2                	mov    %eax,%edx
c0101460:	ec                   	in     (%dx),%al
c0101461:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101464:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101468:	0f b6 c0             	movzbl %al,%eax
c010146b:	83 e0 01             	and    $0x1,%eax
c010146e:	85 c0                	test   %eax,%eax
c0101470:	75 07                	jne    c0101479 <serial_proc_data+0x2f>
        return -1;
c0101472:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101477:	eb 2a                	jmp    c01014a3 <serial_proc_data+0x59>
c0101479:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010147f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101483:	89 c2                	mov    %eax,%edx
c0101485:	ec                   	in     (%dx),%al
c0101486:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101489:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010148d:	0f b6 c0             	movzbl %al,%eax
c0101490:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101493:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101497:	75 07                	jne    c01014a0 <serial_proc_data+0x56>
        c = '\b';
c0101499:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014a3:	c9                   	leave  
c01014a4:	c3                   	ret    

c01014a5 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014a5:	f3 0f 1e fb          	endbr32 
c01014a9:	55                   	push   %ebp
c01014aa:	89 e5                	mov    %esp,%ebp
c01014ac:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01014af:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	74 10                	je     c01014c8 <serial_intr+0x23>
        cons_intr(serial_proc_data);
c01014b8:	83 ec 0c             	sub    $0xc,%esp
c01014bb:	68 4a 14 10 c0       	push   $0xc010144a
c01014c0:	e8 34 ff ff ff       	call   c01013f9 <cons_intr>
c01014c5:	83 c4 10             	add    $0x10,%esp
    }
}
c01014c8:	90                   	nop
c01014c9:	c9                   	leave  
c01014ca:	c3                   	ret    

c01014cb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014cb:	f3 0f 1e fb          	endbr32 
c01014cf:	55                   	push   %ebp
c01014d0:	89 e5                	mov    %esp,%ebp
c01014d2:	83 ec 28             	sub    $0x28,%esp
c01014d5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014db:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01014df:	89 c2                	mov    %eax,%edx
c01014e1:	ec                   	in     (%dx),%al
c01014e2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014e9:	0f b6 c0             	movzbl %al,%eax
c01014ec:	83 e0 01             	and    $0x1,%eax
c01014ef:	85 c0                	test   %eax,%eax
c01014f1:	75 0a                	jne    c01014fd <kbd_proc_data+0x32>
        return -1;
c01014f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014f8:	e9 5e 01 00 00       	jmp    c010165b <kbd_proc_data+0x190>
c01014fd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101503:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101507:	89 c2                	mov    %eax,%edx
c0101509:	ec                   	in     (%dx),%al
c010150a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010150d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101511:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101514:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101518:	75 17                	jne    c0101531 <kbd_proc_data+0x66>
        // E0 escape character
        shift |= E0ESC;
c010151a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010151f:	83 c8 40             	or     $0x40,%eax
c0101522:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101527:	b8 00 00 00 00       	mov    $0x0,%eax
c010152c:	e9 2a 01 00 00       	jmp    c010165b <kbd_proc_data+0x190>
    } else if (data & 0x80) {
c0101531:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101535:	84 c0                	test   %al,%al
c0101537:	79 47                	jns    c0101580 <kbd_proc_data+0xb5>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101539:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010153e:	83 e0 40             	and    $0x40,%eax
c0101541:	85 c0                	test   %eax,%eax
c0101543:	75 09                	jne    c010154e <kbd_proc_data+0x83>
c0101545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101549:	83 e0 7f             	and    $0x7f,%eax
c010154c:	eb 04                	jmp    c0101552 <kbd_proc_data+0x87>
c010154e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101552:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101559:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101560:	83 c8 40             	or     $0x40,%eax
c0101563:	0f b6 c0             	movzbl %al,%eax
c0101566:	f7 d0                	not    %eax
c0101568:	89 c2                	mov    %eax,%edx
c010156a:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c010156f:	21 d0                	and    %edx,%eax
c0101571:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101576:	b8 00 00 00 00       	mov    $0x0,%eax
c010157b:	e9 db 00 00 00       	jmp    c010165b <kbd_proc_data+0x190>
    } else if (shift & E0ESC) {
c0101580:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101585:	83 e0 40             	and    $0x40,%eax
c0101588:	85 c0                	test   %eax,%eax
c010158a:	74 11                	je     c010159d <kbd_proc_data+0xd2>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010158c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101590:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101595:	83 e0 bf             	and    $0xffffffbf,%eax
c0101598:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c010159d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a1:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015a8:	0f b6 d0             	movzbl %al,%edx
c01015ab:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b0:	09 d0                	or     %edx,%eax
c01015b2:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c01015b7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015bb:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c01015c2:	0f b6 d0             	movzbl %al,%edx
c01015c5:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015ca:	31 d0                	xor    %edx,%eax
c01015cc:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015d1:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015d6:	83 e0 03             	and    $0x3,%eax
c01015d9:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c01015e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015e4:	01 d0                	add    %edx,%eax
c01015e6:	0f b6 00             	movzbl (%eax),%eax
c01015e9:	0f b6 c0             	movzbl %al,%eax
c01015ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015ef:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015f4:	83 e0 08             	and    $0x8,%eax
c01015f7:	85 c0                	test   %eax,%eax
c01015f9:	74 22                	je     c010161d <kbd_proc_data+0x152>
        if ('a' <= c && c <= 'z')
c01015fb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015ff:	7e 0c                	jle    c010160d <kbd_proc_data+0x142>
c0101601:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101605:	7f 06                	jg     c010160d <kbd_proc_data+0x142>
            c += 'A' - 'a';
c0101607:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010160b:	eb 10                	jmp    c010161d <kbd_proc_data+0x152>
        else if ('A' <= c && c <= 'Z')
c010160d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101611:	7e 0a                	jle    c010161d <kbd_proc_data+0x152>
c0101613:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101617:	7f 04                	jg     c010161d <kbd_proc_data+0x152>
            c += 'a' - 'A';
c0101619:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010161d:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101622:	f7 d0                	not    %eax
c0101624:	83 e0 06             	and    $0x6,%eax
c0101627:	85 c0                	test   %eax,%eax
c0101629:	75 2d                	jne    c0101658 <kbd_proc_data+0x18d>
c010162b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101632:	75 24                	jne    c0101658 <kbd_proc_data+0x18d>
        cprintf("Rebooting!\n");
c0101634:	83 ec 0c             	sub    $0xc,%esp
c0101637:	68 6d 5f 10 c0       	push   $0xc0105f6d
c010163c:	e8 5a ec ff ff       	call   c010029b <cprintf>
c0101641:	83 c4 10             	add    $0x10,%esp
c0101644:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010164a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010164e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101652:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101656:	ee                   	out    %al,(%dx)
}
c0101657:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101658:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010165b:	c9                   	leave  
c010165c:	c3                   	ret    

c010165d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010165d:	f3 0f 1e fb          	endbr32 
c0101661:	55                   	push   %ebp
c0101662:	89 e5                	mov    %esp,%ebp
c0101664:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101667:	83 ec 0c             	sub    $0xc,%esp
c010166a:	68 cb 14 10 c0       	push   $0xc01014cb
c010166f:	e8 85 fd ff ff       	call   c01013f9 <cons_intr>
c0101674:	83 c4 10             	add    $0x10,%esp
}
c0101677:	90                   	nop
c0101678:	c9                   	leave  
c0101679:	c3                   	ret    

c010167a <kbd_init>:

static void
kbd_init(void) {
c010167a:	f3 0f 1e fb          	endbr32 
c010167e:	55                   	push   %ebp
c010167f:	89 e5                	mov    %esp,%ebp
c0101681:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c0101684:	e8 d4 ff ff ff       	call   c010165d <kbd_intr>
    pic_enable(IRQ_KBD);
c0101689:	83 ec 0c             	sub    $0xc,%esp
c010168c:	6a 01                	push   $0x1
c010168e:	e8 5d 01 00 00       	call   c01017f0 <pic_enable>
c0101693:	83 c4 10             	add    $0x10,%esp
}
c0101696:	90                   	nop
c0101697:	c9                   	leave  
c0101698:	c3                   	ret    

c0101699 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101699:	f3 0f 1e fb          	endbr32 
c010169d:	55                   	push   %ebp
c010169e:	89 e5                	mov    %esp,%ebp
c01016a0:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01016a3:	e8 33 f8 ff ff       	call   c0100edb <cga_init>
    serial_init();
c01016a8:	e8 1b f9 ff ff       	call   c0100fc8 <serial_init>
    kbd_init();
c01016ad:	e8 c8 ff ff ff       	call   c010167a <kbd_init>
    if (!serial_exists) {
c01016b2:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01016b7:	85 c0                	test   %eax,%eax
c01016b9:	75 10                	jne    c01016cb <cons_init+0x32>
        cprintf("serial port does not exist!!\n");
c01016bb:	83 ec 0c             	sub    $0xc,%esp
c01016be:	68 79 5f 10 c0       	push   $0xc0105f79
c01016c3:	e8 d3 eb ff ff       	call   c010029b <cprintf>
c01016c8:	83 c4 10             	add    $0x10,%esp
    }
}
c01016cb:	90                   	nop
c01016cc:	c9                   	leave  
c01016cd:	c3                   	ret    

c01016ce <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016ce:	f3 0f 1e fb          	endbr32 
c01016d2:	55                   	push   %ebp
c01016d3:	89 e5                	mov    %esp,%ebp
c01016d5:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016d8:	e8 73 f7 ff ff       	call   c0100e50 <__intr_save>
c01016dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016e0:	83 ec 0c             	sub    $0xc,%esp
c01016e3:	ff 75 08             	pushl  0x8(%ebp)
c01016e6:	e8 4e fa ff ff       	call   c0101139 <lpt_putc>
c01016eb:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01016ee:	83 ec 0c             	sub    $0xc,%esp
c01016f1:	ff 75 08             	pushl  0x8(%ebp)
c01016f4:	e8 7b fa ff ff       	call   c0101174 <cga_putc>
c01016f9:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c01016fc:	83 ec 0c             	sub    $0xc,%esp
c01016ff:	ff 75 08             	pushl  0x8(%ebp)
c0101702:	e8 b7 fc ff ff       	call   c01013be <serial_putc>
c0101707:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010170a:	83 ec 0c             	sub    $0xc,%esp
c010170d:	ff 75 f4             	pushl  -0xc(%ebp)
c0101710:	e8 65 f7 ff ff       	call   c0100e7a <__intr_restore>
c0101715:	83 c4 10             	add    $0x10,%esp
}
c0101718:	90                   	nop
c0101719:	c9                   	leave  
c010171a:	c3                   	ret    

c010171b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010171b:	f3 0f 1e fb          	endbr32 
c010171f:	55                   	push   %ebp
c0101720:	89 e5                	mov    %esp,%ebp
c0101722:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010172c:	e8 1f f7 ff ff       	call   c0100e50 <__intr_save>
c0101731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101734:	e8 6c fd ff ff       	call   c01014a5 <serial_intr>
        kbd_intr();
c0101739:	e8 1f ff ff ff       	call   c010165d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010173e:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c0101744:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101749:	39 c2                	cmp    %eax,%edx
c010174b:	74 31                	je     c010177e <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c010174d:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101752:	8d 50 01             	lea    0x1(%eax),%edx
c0101755:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c010175b:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c0101762:	0f b6 c0             	movzbl %al,%eax
c0101765:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101768:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c010176d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101772:	75 0a                	jne    c010177e <cons_getc+0x63>
                cons.rpos = 0;
c0101774:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c010177b:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010177e:	83 ec 0c             	sub    $0xc,%esp
c0101781:	ff 75 f0             	pushl  -0x10(%ebp)
c0101784:	e8 f1 f6 ff ff       	call   c0100e7a <__intr_restore>
c0101789:	83 c4 10             	add    $0x10,%esp
    return c;
c010178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010178f:	c9                   	leave  
c0101790:	c3                   	ret    

c0101791 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101791:	f3 0f 1e fb          	endbr32 
c0101795:	55                   	push   %ebp
c0101796:	89 e5                	mov    %esp,%ebp
c0101798:	83 ec 14             	sub    $0x14,%esp
c010179b:	8b 45 08             	mov    0x8(%ebp),%eax
c010179e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017a2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017a6:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01017ac:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01017b1:	85 c0                	test   %eax,%eax
c01017b3:	74 38                	je     c01017ed <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017b5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017b9:	0f b6 c0             	movzbl %al,%eax
c01017bc:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017c2:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017c9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017cd:	ee                   	out    %al,(%dx)
}
c01017ce:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017d3:	66 c1 e8 08          	shr    $0x8,%ax
c01017d7:	0f b6 c0             	movzbl %al,%eax
c01017da:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017e0:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017e7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017eb:	ee                   	out    %al,(%dx)
}
c01017ec:	90                   	nop
    }
}
c01017ed:	90                   	nop
c01017ee:	c9                   	leave  
c01017ef:	c3                   	ret    

c01017f0 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017f0:	f3 0f 1e fb          	endbr32 
c01017f4:	55                   	push   %ebp
c01017f5:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01017f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01017fa:	ba 01 00 00 00       	mov    $0x1,%edx
c01017ff:	89 c1                	mov    %eax,%ecx
c0101801:	d3 e2                	shl    %cl,%edx
c0101803:	89 d0                	mov    %edx,%eax
c0101805:	f7 d0                	not    %eax
c0101807:	89 c2                	mov    %eax,%edx
c0101809:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101810:	21 d0                	and    %edx,%eax
c0101812:	0f b7 c0             	movzwl %ax,%eax
c0101815:	50                   	push   %eax
c0101816:	e8 76 ff ff ff       	call   c0101791 <pic_setmask>
c010181b:	83 c4 04             	add    $0x4,%esp
}
c010181e:	90                   	nop
c010181f:	c9                   	leave  
c0101820:	c3                   	ret    

c0101821 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101821:	f3 0f 1e fb          	endbr32 
c0101825:	55                   	push   %ebp
c0101826:	89 e5                	mov    %esp,%ebp
c0101828:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c010182b:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c0101832:	00 00 00 
c0101835:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010183b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010183f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101843:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101847:	ee                   	out    %al,(%dx)
}
c0101848:	90                   	nop
c0101849:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010184f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101853:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101857:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010185b:	ee                   	out    %al,(%dx)
}
c010185c:	90                   	nop
c010185d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101863:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101867:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010186b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010186f:	ee                   	out    %al,(%dx)
}
c0101870:	90                   	nop
c0101871:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101877:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010187b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010187f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101883:	ee                   	out    %al,(%dx)
}
c0101884:	90                   	nop
c0101885:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010188b:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010188f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101893:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101897:	ee                   	out    %al,(%dx)
}
c0101898:	90                   	nop
c0101899:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c010189f:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018a3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018a7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018ab:	ee                   	out    %al,(%dx)
}
c01018ac:	90                   	nop
c01018ad:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018b3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018bb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018bf:	ee                   	out    %al,(%dx)
}
c01018c0:	90                   	nop
c01018c1:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018c7:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018cb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018cf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018d3:	ee                   	out    %al,(%dx)
}
c01018d4:	90                   	nop
c01018d5:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018db:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018df:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018e3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018e7:	ee                   	out    %al,(%dx)
}
c01018e8:	90                   	nop
c01018e9:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018ef:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018f3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018f7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018fb:	ee                   	out    %al,(%dx)
}
c01018fc:	90                   	nop
c01018fd:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101903:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101907:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010190b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010190f:	ee                   	out    %al,(%dx)
}
c0101910:	90                   	nop
c0101911:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101917:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010191b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010191f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101923:	ee                   	out    %al,(%dx)
}
c0101924:	90                   	nop
c0101925:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010192b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010192f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101933:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101937:	ee                   	out    %al,(%dx)
}
c0101938:	90                   	nop
c0101939:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010193f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101943:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101947:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010194b:	ee                   	out    %al,(%dx)
}
c010194c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010194d:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101954:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101958:	74 13                	je     c010196d <pic_init+0x14c>
        pic_setmask(irq_mask);
c010195a:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101961:	0f b7 c0             	movzwl %ax,%eax
c0101964:	50                   	push   %eax
c0101965:	e8 27 fe ff ff       	call   c0101791 <pic_setmask>
c010196a:	83 c4 04             	add    $0x4,%esp
    }
}
c010196d:	90                   	nop
c010196e:	c9                   	leave  
c010196f:	c3                   	ret    

c0101970 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101970:	f3 0f 1e fb          	endbr32 
c0101974:	55                   	push   %ebp
c0101975:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101977:	fb                   	sti    
}
c0101978:	90                   	nop
    sti();
}
c0101979:	90                   	nop
c010197a:	5d                   	pop    %ebp
c010197b:	c3                   	ret    

c010197c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010197c:	f3 0f 1e fb          	endbr32 
c0101980:	55                   	push   %ebp
c0101981:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101983:	fa                   	cli    
}
c0101984:	90                   	nop
    cli();
}
c0101985:	90                   	nop
c0101986:	5d                   	pop    %ebp
c0101987:	c3                   	ret    

c0101988 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101988:	f3 0f 1e fb          	endbr32 
c010198c:	55                   	push   %ebp
c010198d:	89 e5                	mov    %esp,%ebp
c010198f:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101992:	83 ec 08             	sub    $0x8,%esp
c0101995:	6a 64                	push   $0x64
c0101997:	68 a0 5f 10 c0       	push   $0xc0105fa0
c010199c:	e8 fa e8 ff ff       	call   c010029b <cprintf>
c01019a1:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01019a4:	90                   	nop
c01019a5:	c9                   	leave  
c01019a6:	c3                   	ret    

c01019a7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019a7:	f3 0f 1e fb          	endbr32 
c01019ab:	55                   	push   %ebp
c01019ac:	89 e5                	mov    %esp,%ebp
c01019ae:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019b8:	e9 c3 00 00 00       	jmp    c0101a80 <idt_init+0xd9>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01019bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c0:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c01019c7:	89 c2                	mov    %eax,%edx
c01019c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cc:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c01019d3:	c0 
c01019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d7:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c01019de:	c0 08 00 
c01019e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e4:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019eb:	c0 
c01019ec:	83 e2 e0             	and    $0xffffffe0,%edx
c01019ef:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c01019f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f9:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a00:	c0 
c0101a01:	83 e2 1f             	and    $0x1f,%edx
c0101a04:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0e:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a15:	c0 
c0101a16:	83 e2 f0             	and    $0xfffffff0,%edx
c0101a19:	83 ca 0e             	or     $0xe,%edx
c0101a1c:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a26:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a2d:	c0 
c0101a2e:	83 e2 ef             	and    $0xffffffef,%edx
c0101a31:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a3b:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a42:	c0 
c0101a43:	83 e2 9f             	and    $0xffffff9f,%edx
c0101a46:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a50:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a57:	c0 
c0101a58:	83 ca 80             	or     $0xffffff80,%edx
c0101a5b:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a65:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a6c:	c1 e8 10             	shr    $0x10,%eax
c0101a6f:	89 c2                	mov    %eax,%edx
c0101a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a74:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a7b:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101a7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a83:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a88:	0f 86 2f ff ff ff    	jbe    c01019bd <idt_init+0x16>
c0101a8e:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a95:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a98:	0f 01 18             	lidtl  (%eax)
}
c0101a9b:	90                   	nop
    }
    lidt(&idt_pd);
}
c0101a9c:	90                   	nop
c0101a9d:	c9                   	leave  
c0101a9e:	c3                   	ret    

c0101a9f <trapname>:

static const char *
trapname(int trapno) {
c0101a9f:	f3 0f 1e fb          	endbr32 
c0101aa3:	55                   	push   %ebp
c0101aa4:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa9:	83 f8 13             	cmp    $0x13,%eax
c0101aac:	77 0c                	ja     c0101aba <trapname+0x1b>
        return excnames[trapno];
c0101aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab1:	8b 04 85 00 63 10 c0 	mov    -0x3fef9d00(,%eax,4),%eax
c0101ab8:	eb 18                	jmp    c0101ad2 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101aba:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101abe:	7e 0d                	jle    c0101acd <trapname+0x2e>
c0101ac0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ac4:	7f 07                	jg     c0101acd <trapname+0x2e>
        return "Hardware Interrupt";
c0101ac6:	b8 aa 5f 10 c0       	mov    $0xc0105faa,%eax
c0101acb:	eb 05                	jmp    c0101ad2 <trapname+0x33>
    }
    return "(unknown trap)";
c0101acd:	b8 bd 5f 10 c0       	mov    $0xc0105fbd,%eax
}
c0101ad2:	5d                   	pop    %ebp
c0101ad3:	c3                   	ret    

c0101ad4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ad4:	f3 0f 1e fb          	endbr32 
c0101ad8:	55                   	push   %ebp
c0101ad9:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ade:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ae2:	66 83 f8 08          	cmp    $0x8,%ax
c0101ae6:	0f 94 c0             	sete   %al
c0101ae9:	0f b6 c0             	movzbl %al,%eax
}
c0101aec:	5d                   	pop    %ebp
c0101aed:	c3                   	ret    

c0101aee <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101aee:	f3 0f 1e fb          	endbr32 
c0101af2:	55                   	push   %ebp
c0101af3:	89 e5                	mov    %esp,%ebp
c0101af5:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101af8:	83 ec 08             	sub    $0x8,%esp
c0101afb:	ff 75 08             	pushl  0x8(%ebp)
c0101afe:	68 fe 5f 10 c0       	push   $0xc0105ffe
c0101b03:	e8 93 e7 ff ff       	call   c010029b <cprintf>
c0101b08:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0e:	83 ec 0c             	sub    $0xc,%esp
c0101b11:	50                   	push   %eax
c0101b12:	e8 b4 01 00 00       	call   c0101ccb <print_regs>
c0101b17:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b21:	0f b7 c0             	movzwl %ax,%eax
c0101b24:	83 ec 08             	sub    $0x8,%esp
c0101b27:	50                   	push   %eax
c0101b28:	68 0f 60 10 c0       	push   $0xc010600f
c0101b2d:	e8 69 e7 ff ff       	call   c010029b <cprintf>
c0101b32:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b38:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b3c:	0f b7 c0             	movzwl %ax,%eax
c0101b3f:	83 ec 08             	sub    $0x8,%esp
c0101b42:	50                   	push   %eax
c0101b43:	68 22 60 10 c0       	push   $0xc0106022
c0101b48:	e8 4e e7 ff ff       	call   c010029b <cprintf>
c0101b4d:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b53:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b57:	0f b7 c0             	movzwl %ax,%eax
c0101b5a:	83 ec 08             	sub    $0x8,%esp
c0101b5d:	50                   	push   %eax
c0101b5e:	68 35 60 10 c0       	push   $0xc0106035
c0101b63:	e8 33 e7 ff ff       	call   c010029b <cprintf>
c0101b68:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b72:	0f b7 c0             	movzwl %ax,%eax
c0101b75:	83 ec 08             	sub    $0x8,%esp
c0101b78:	50                   	push   %eax
c0101b79:	68 48 60 10 c0       	push   $0xc0106048
c0101b7e:	e8 18 e7 ff ff       	call   c010029b <cprintf>
c0101b83:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b89:	8b 40 30             	mov    0x30(%eax),%eax
c0101b8c:	83 ec 0c             	sub    $0xc,%esp
c0101b8f:	50                   	push   %eax
c0101b90:	e8 0a ff ff ff       	call   c0101a9f <trapname>
c0101b95:	83 c4 10             	add    $0x10,%esp
c0101b98:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b9b:	8b 52 30             	mov    0x30(%edx),%edx
c0101b9e:	83 ec 04             	sub    $0x4,%esp
c0101ba1:	50                   	push   %eax
c0101ba2:	52                   	push   %edx
c0101ba3:	68 5b 60 10 c0       	push   $0xc010605b
c0101ba8:	e8 ee e6 ff ff       	call   c010029b <cprintf>
c0101bad:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb3:	8b 40 34             	mov    0x34(%eax),%eax
c0101bb6:	83 ec 08             	sub    $0x8,%esp
c0101bb9:	50                   	push   %eax
c0101bba:	68 6d 60 10 c0       	push   $0xc010606d
c0101bbf:	e8 d7 e6 ff ff       	call   c010029b <cprintf>
c0101bc4:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bca:	8b 40 38             	mov    0x38(%eax),%eax
c0101bcd:	83 ec 08             	sub    $0x8,%esp
c0101bd0:	50                   	push   %eax
c0101bd1:	68 7c 60 10 c0       	push   $0xc010607c
c0101bd6:	e8 c0 e6 ff ff       	call   c010029b <cprintf>
c0101bdb:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101be5:	0f b7 c0             	movzwl %ax,%eax
c0101be8:	83 ec 08             	sub    $0x8,%esp
c0101beb:	50                   	push   %eax
c0101bec:	68 8b 60 10 c0       	push   $0xc010608b
c0101bf1:	e8 a5 e6 ff ff       	call   c010029b <cprintf>
c0101bf6:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfc:	8b 40 40             	mov    0x40(%eax),%eax
c0101bff:	83 ec 08             	sub    $0x8,%esp
c0101c02:	50                   	push   %eax
c0101c03:	68 9e 60 10 c0       	push   $0xc010609e
c0101c08:	e8 8e e6 ff ff       	call   c010029b <cprintf>
c0101c0d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c17:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c1e:	eb 3f                	jmp    c0101c5f <print_trapframe+0x171>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c23:	8b 50 40             	mov    0x40(%eax),%edx
c0101c26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c29:	21 d0                	and    %edx,%eax
c0101c2b:	85 c0                	test   %eax,%eax
c0101c2d:	74 29                	je     c0101c58 <print_trapframe+0x16a>
c0101c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c32:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c39:	85 c0                	test   %eax,%eax
c0101c3b:	74 1b                	je     c0101c58 <print_trapframe+0x16a>
            cprintf("%s,", IA32flags[i]);
c0101c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c40:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101c47:	83 ec 08             	sub    $0x8,%esp
c0101c4a:	50                   	push   %eax
c0101c4b:	68 ad 60 10 c0       	push   $0xc01060ad
c0101c50:	e8 46 e6 ff ff       	call   c010029b <cprintf>
c0101c55:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c5c:	d1 65 f0             	shll   -0x10(%ebp)
c0101c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c62:	83 f8 17             	cmp    $0x17,%eax
c0101c65:	76 b9                	jbe    c0101c20 <print_trapframe+0x132>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6a:	8b 40 40             	mov    0x40(%eax),%eax
c0101c6d:	c1 e8 0c             	shr    $0xc,%eax
c0101c70:	83 e0 03             	and    $0x3,%eax
c0101c73:	83 ec 08             	sub    $0x8,%esp
c0101c76:	50                   	push   %eax
c0101c77:	68 b1 60 10 c0       	push   $0xc01060b1
c0101c7c:	e8 1a e6 ff ff       	call   c010029b <cprintf>
c0101c81:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101c84:	83 ec 0c             	sub    $0xc,%esp
c0101c87:	ff 75 08             	pushl  0x8(%ebp)
c0101c8a:	e8 45 fe ff ff       	call   c0101ad4 <trap_in_kernel>
c0101c8f:	83 c4 10             	add    $0x10,%esp
c0101c92:	85 c0                	test   %eax,%eax
c0101c94:	75 32                	jne    c0101cc8 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c99:	8b 40 44             	mov    0x44(%eax),%eax
c0101c9c:	83 ec 08             	sub    $0x8,%esp
c0101c9f:	50                   	push   %eax
c0101ca0:	68 ba 60 10 c0       	push   $0xc01060ba
c0101ca5:	e8 f1 e5 ff ff       	call   c010029b <cprintf>
c0101caa:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cb4:	0f b7 c0             	movzwl %ax,%eax
c0101cb7:	83 ec 08             	sub    $0x8,%esp
c0101cba:	50                   	push   %eax
c0101cbb:	68 c9 60 10 c0       	push   $0xc01060c9
c0101cc0:	e8 d6 e5 ff ff       	call   c010029b <cprintf>
c0101cc5:	83 c4 10             	add    $0x10,%esp
    }
}
c0101cc8:	90                   	nop
c0101cc9:	c9                   	leave  
c0101cca:	c3                   	ret    

c0101ccb <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ccb:	f3 0f 1e fb          	endbr32 
c0101ccf:	55                   	push   %ebp
c0101cd0:	89 e5                	mov    %esp,%ebp
c0101cd2:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd8:	8b 00                	mov    (%eax),%eax
c0101cda:	83 ec 08             	sub    $0x8,%esp
c0101cdd:	50                   	push   %eax
c0101cde:	68 dc 60 10 c0       	push   $0xc01060dc
c0101ce3:	e8 b3 e5 ff ff       	call   c010029b <cprintf>
c0101ce8:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cee:	8b 40 04             	mov    0x4(%eax),%eax
c0101cf1:	83 ec 08             	sub    $0x8,%esp
c0101cf4:	50                   	push   %eax
c0101cf5:	68 eb 60 10 c0       	push   $0xc01060eb
c0101cfa:	e8 9c e5 ff ff       	call   c010029b <cprintf>
c0101cff:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d05:	8b 40 08             	mov    0x8(%eax),%eax
c0101d08:	83 ec 08             	sub    $0x8,%esp
c0101d0b:	50                   	push   %eax
c0101d0c:	68 fa 60 10 c0       	push   $0xc01060fa
c0101d11:	e8 85 e5 ff ff       	call   c010029b <cprintf>
c0101d16:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1c:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d1f:	83 ec 08             	sub    $0x8,%esp
c0101d22:	50                   	push   %eax
c0101d23:	68 09 61 10 c0       	push   $0xc0106109
c0101d28:	e8 6e e5 ff ff       	call   c010029b <cprintf>
c0101d2d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d33:	8b 40 10             	mov    0x10(%eax),%eax
c0101d36:	83 ec 08             	sub    $0x8,%esp
c0101d39:	50                   	push   %eax
c0101d3a:	68 18 61 10 c0       	push   $0xc0106118
c0101d3f:	e8 57 e5 ff ff       	call   c010029b <cprintf>
c0101d44:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d4a:	8b 40 14             	mov    0x14(%eax),%eax
c0101d4d:	83 ec 08             	sub    $0x8,%esp
c0101d50:	50                   	push   %eax
c0101d51:	68 27 61 10 c0       	push   $0xc0106127
c0101d56:	e8 40 e5 ff ff       	call   c010029b <cprintf>
c0101d5b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d61:	8b 40 18             	mov    0x18(%eax),%eax
c0101d64:	83 ec 08             	sub    $0x8,%esp
c0101d67:	50                   	push   %eax
c0101d68:	68 36 61 10 c0       	push   $0xc0106136
c0101d6d:	e8 29 e5 ff ff       	call   c010029b <cprintf>
c0101d72:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d78:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d7b:	83 ec 08             	sub    $0x8,%esp
c0101d7e:	50                   	push   %eax
c0101d7f:	68 45 61 10 c0       	push   $0xc0106145
c0101d84:	e8 12 e5 ff ff       	call   c010029b <cprintf>
c0101d89:	83 c4 10             	add    $0x10,%esp
}
c0101d8c:	90                   	nop
c0101d8d:	c9                   	leave  
c0101d8e:	c3                   	ret    

c0101d8f <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d8f:	f3 0f 1e fb          	endbr32 
c0101d93:	55                   	push   %ebp
c0101d94:	89 e5                	mov    %esp,%ebp
c0101d96:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d9c:	8b 40 30             	mov    0x30(%eax),%eax
c0101d9f:	83 f8 79             	cmp    $0x79,%eax
c0101da2:	0f 87 d1 00 00 00    	ja     c0101e79 <trap_dispatch+0xea>
c0101da8:	83 f8 78             	cmp    $0x78,%eax
c0101dab:	0f 83 b1 00 00 00    	jae    c0101e62 <trap_dispatch+0xd3>
c0101db1:	83 f8 2f             	cmp    $0x2f,%eax
c0101db4:	0f 87 bf 00 00 00    	ja     c0101e79 <trap_dispatch+0xea>
c0101dba:	83 f8 2e             	cmp    $0x2e,%eax
c0101dbd:	0f 83 ec 00 00 00    	jae    c0101eaf <trap_dispatch+0x120>
c0101dc3:	83 f8 24             	cmp    $0x24,%eax
c0101dc6:	74 52                	je     c0101e1a <trap_dispatch+0x8b>
c0101dc8:	83 f8 24             	cmp    $0x24,%eax
c0101dcb:	0f 87 a8 00 00 00    	ja     c0101e79 <trap_dispatch+0xea>
c0101dd1:	83 f8 20             	cmp    $0x20,%eax
c0101dd4:	74 0a                	je     c0101de0 <trap_dispatch+0x51>
c0101dd6:	83 f8 21             	cmp    $0x21,%eax
c0101dd9:	74 63                	je     c0101e3e <trap_dispatch+0xaf>
c0101ddb:	e9 99 00 00 00       	jmp    c0101e79 <trap_dispatch+0xea>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101de0:	a1 0c cf 11 c0       	mov    0xc011cf0c,%eax
c0101de5:	83 c0 01             	add    $0x1,%eax
c0101de8:	a3 0c cf 11 c0       	mov    %eax,0xc011cf0c
        if (ticks % TICK_NUM == 0) {
c0101ded:	8b 0d 0c cf 11 c0    	mov    0xc011cf0c,%ecx
c0101df3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101df8:	89 c8                	mov    %ecx,%eax
c0101dfa:	f7 e2                	mul    %edx
c0101dfc:	89 d0                	mov    %edx,%eax
c0101dfe:	c1 e8 05             	shr    $0x5,%eax
c0101e01:	6b c0 64             	imul   $0x64,%eax,%eax
c0101e04:	29 c1                	sub    %eax,%ecx
c0101e06:	89 c8                	mov    %ecx,%eax
c0101e08:	85 c0                	test   %eax,%eax
c0101e0a:	0f 85 a2 00 00 00    	jne    c0101eb2 <trap_dispatch+0x123>
            print_ticks();
c0101e10:	e8 73 fb ff ff       	call   c0101988 <print_ticks>
        }
        break;
c0101e15:	e9 98 00 00 00       	jmp    c0101eb2 <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e1a:	e8 fc f8 ff ff       	call   c010171b <cons_getc>
c0101e1f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e22:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e26:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e2a:	83 ec 04             	sub    $0x4,%esp
c0101e2d:	52                   	push   %edx
c0101e2e:	50                   	push   %eax
c0101e2f:	68 54 61 10 c0       	push   $0xc0106154
c0101e34:	e8 62 e4 ff ff       	call   c010029b <cprintf>
c0101e39:	83 c4 10             	add    $0x10,%esp
        break;
c0101e3c:	eb 75                	jmp    c0101eb3 <trap_dispatch+0x124>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e3e:	e8 d8 f8 ff ff       	call   c010171b <cons_getc>
c0101e43:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e46:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e4a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e4e:	83 ec 04             	sub    $0x4,%esp
c0101e51:	52                   	push   %edx
c0101e52:	50                   	push   %eax
c0101e53:	68 66 61 10 c0       	push   $0xc0106166
c0101e58:	e8 3e e4 ff ff       	call   c010029b <cprintf>
c0101e5d:	83 c4 10             	add    $0x10,%esp
        break;
c0101e60:	eb 51                	jmp    c0101eb3 <trap_dispatch+0x124>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e62:	83 ec 04             	sub    $0x4,%esp
c0101e65:	68 75 61 10 c0       	push   $0xc0106175
c0101e6a:	68 ac 00 00 00       	push   $0xac
c0101e6f:	68 85 61 10 c0       	push   $0xc0106185
c0101e74:	e8 9d e5 ff ff       	call   c0100416 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e79:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e80:	0f b7 c0             	movzwl %ax,%eax
c0101e83:	83 e0 03             	and    $0x3,%eax
c0101e86:	85 c0                	test   %eax,%eax
c0101e88:	75 29                	jne    c0101eb3 <trap_dispatch+0x124>
            print_trapframe(tf);
c0101e8a:	83 ec 0c             	sub    $0xc,%esp
c0101e8d:	ff 75 08             	pushl  0x8(%ebp)
c0101e90:	e8 59 fc ff ff       	call   c0101aee <print_trapframe>
c0101e95:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101e98:	83 ec 04             	sub    $0x4,%esp
c0101e9b:	68 96 61 10 c0       	push   $0xc0106196
c0101ea0:	68 b6 00 00 00       	push   $0xb6
c0101ea5:	68 85 61 10 c0       	push   $0xc0106185
c0101eaa:	e8 67 e5 ff ff       	call   c0100416 <__panic>
        break;
c0101eaf:	90                   	nop
c0101eb0:	eb 01                	jmp    c0101eb3 <trap_dispatch+0x124>
        break;
c0101eb2:	90                   	nop
        }
    }
}
c0101eb3:	90                   	nop
c0101eb4:	c9                   	leave  
c0101eb5:	c3                   	ret    

c0101eb6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101eb6:	f3 0f 1e fb          	endbr32 
c0101eba:	55                   	push   %ebp
c0101ebb:	89 e5                	mov    %esp,%ebp
c0101ebd:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101ec0:	83 ec 0c             	sub    $0xc,%esp
c0101ec3:	ff 75 08             	pushl  0x8(%ebp)
c0101ec6:	e8 c4 fe ff ff       	call   c0101d8f <trap_dispatch>
c0101ecb:	83 c4 10             	add    $0x10,%esp
}
c0101ece:	90                   	nop
c0101ecf:	c9                   	leave  
c0101ed0:	c3                   	ret    

c0101ed1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101ed1:	6a 00                	push   $0x0
  pushl $0
c0101ed3:	6a 00                	push   $0x0
  jmp __alltraps
c0101ed5:	e9 67 0a 00 00       	jmp    c0102941 <__alltraps>

c0101eda <vector1>:
.globl vector1
vector1:
  pushl $0
c0101eda:	6a 00                	push   $0x0
  pushl $1
c0101edc:	6a 01                	push   $0x1
  jmp __alltraps
c0101ede:	e9 5e 0a 00 00       	jmp    c0102941 <__alltraps>

c0101ee3 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ee3:	6a 00                	push   $0x0
  pushl $2
c0101ee5:	6a 02                	push   $0x2
  jmp __alltraps
c0101ee7:	e9 55 0a 00 00       	jmp    c0102941 <__alltraps>

c0101eec <vector3>:
.globl vector3
vector3:
  pushl $0
c0101eec:	6a 00                	push   $0x0
  pushl $3
c0101eee:	6a 03                	push   $0x3
  jmp __alltraps
c0101ef0:	e9 4c 0a 00 00       	jmp    c0102941 <__alltraps>

c0101ef5 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ef5:	6a 00                	push   $0x0
  pushl $4
c0101ef7:	6a 04                	push   $0x4
  jmp __alltraps
c0101ef9:	e9 43 0a 00 00       	jmp    c0102941 <__alltraps>

c0101efe <vector5>:
.globl vector5
vector5:
  pushl $0
c0101efe:	6a 00                	push   $0x0
  pushl $5
c0101f00:	6a 05                	push   $0x5
  jmp __alltraps
c0101f02:	e9 3a 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f07 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f07:	6a 00                	push   $0x0
  pushl $6
c0101f09:	6a 06                	push   $0x6
  jmp __alltraps
c0101f0b:	e9 31 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f10 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $7
c0101f12:	6a 07                	push   $0x7
  jmp __alltraps
c0101f14:	e9 28 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f19 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f19:	6a 08                	push   $0x8
  jmp __alltraps
c0101f1b:	e9 21 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f20 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f20:	6a 09                	push   $0x9
  jmp __alltraps
c0101f22:	e9 1a 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f27 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f27:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f29:	e9 13 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f2e <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f2e:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f30:	e9 0c 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f35 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f35:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f37:	e9 05 0a 00 00       	jmp    c0102941 <__alltraps>

c0101f3c <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f3c:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f3e:	e9 fe 09 00 00       	jmp    c0102941 <__alltraps>

c0101f43 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f43:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f45:	e9 f7 09 00 00       	jmp    c0102941 <__alltraps>

c0101f4a <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f4a:	6a 00                	push   $0x0
  pushl $15
c0101f4c:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f4e:	e9 ee 09 00 00       	jmp    c0102941 <__alltraps>

c0101f53 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f53:	6a 00                	push   $0x0
  pushl $16
c0101f55:	6a 10                	push   $0x10
  jmp __alltraps
c0101f57:	e9 e5 09 00 00       	jmp    c0102941 <__alltraps>

c0101f5c <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f5c:	6a 11                	push   $0x11
  jmp __alltraps
c0101f5e:	e9 de 09 00 00       	jmp    c0102941 <__alltraps>

c0101f63 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $18
c0101f65:	6a 12                	push   $0x12
  jmp __alltraps
c0101f67:	e9 d5 09 00 00       	jmp    c0102941 <__alltraps>

c0101f6c <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $19
c0101f6e:	6a 13                	push   $0x13
  jmp __alltraps
c0101f70:	e9 cc 09 00 00       	jmp    c0102941 <__alltraps>

c0101f75 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $20
c0101f77:	6a 14                	push   $0x14
  jmp __alltraps
c0101f79:	e9 c3 09 00 00       	jmp    c0102941 <__alltraps>

c0101f7e <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $21
c0101f80:	6a 15                	push   $0x15
  jmp __alltraps
c0101f82:	e9 ba 09 00 00       	jmp    c0102941 <__alltraps>

c0101f87 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $22
c0101f89:	6a 16                	push   $0x16
  jmp __alltraps
c0101f8b:	e9 b1 09 00 00       	jmp    c0102941 <__alltraps>

c0101f90 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $23
c0101f92:	6a 17                	push   $0x17
  jmp __alltraps
c0101f94:	e9 a8 09 00 00       	jmp    c0102941 <__alltraps>

c0101f99 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $24
c0101f9b:	6a 18                	push   $0x18
  jmp __alltraps
c0101f9d:	e9 9f 09 00 00       	jmp    c0102941 <__alltraps>

c0101fa2 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $25
c0101fa4:	6a 19                	push   $0x19
  jmp __alltraps
c0101fa6:	e9 96 09 00 00       	jmp    c0102941 <__alltraps>

c0101fab <vector26>:
.globl vector26
vector26:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $26
c0101fad:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101faf:	e9 8d 09 00 00       	jmp    c0102941 <__alltraps>

c0101fb4 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $27
c0101fb6:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101fb8:	e9 84 09 00 00       	jmp    c0102941 <__alltraps>

c0101fbd <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $28
c0101fbf:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fc1:	e9 7b 09 00 00       	jmp    c0102941 <__alltraps>

c0101fc6 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $29
c0101fc8:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fca:	e9 72 09 00 00       	jmp    c0102941 <__alltraps>

c0101fcf <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $30
c0101fd1:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fd3:	e9 69 09 00 00       	jmp    c0102941 <__alltraps>

c0101fd8 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $31
c0101fda:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fdc:	e9 60 09 00 00       	jmp    c0102941 <__alltraps>

c0101fe1 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $32
c0101fe3:	6a 20                	push   $0x20
  jmp __alltraps
c0101fe5:	e9 57 09 00 00       	jmp    c0102941 <__alltraps>

c0101fea <vector33>:
.globl vector33
vector33:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $33
c0101fec:	6a 21                	push   $0x21
  jmp __alltraps
c0101fee:	e9 4e 09 00 00       	jmp    c0102941 <__alltraps>

c0101ff3 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $34
c0101ff5:	6a 22                	push   $0x22
  jmp __alltraps
c0101ff7:	e9 45 09 00 00       	jmp    c0102941 <__alltraps>

c0101ffc <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $35
c0101ffe:	6a 23                	push   $0x23
  jmp __alltraps
c0102000:	e9 3c 09 00 00       	jmp    c0102941 <__alltraps>

c0102005 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $36
c0102007:	6a 24                	push   $0x24
  jmp __alltraps
c0102009:	e9 33 09 00 00       	jmp    c0102941 <__alltraps>

c010200e <vector37>:
.globl vector37
vector37:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $37
c0102010:	6a 25                	push   $0x25
  jmp __alltraps
c0102012:	e9 2a 09 00 00       	jmp    c0102941 <__alltraps>

c0102017 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $38
c0102019:	6a 26                	push   $0x26
  jmp __alltraps
c010201b:	e9 21 09 00 00       	jmp    c0102941 <__alltraps>

c0102020 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $39
c0102022:	6a 27                	push   $0x27
  jmp __alltraps
c0102024:	e9 18 09 00 00       	jmp    c0102941 <__alltraps>

c0102029 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $40
c010202b:	6a 28                	push   $0x28
  jmp __alltraps
c010202d:	e9 0f 09 00 00       	jmp    c0102941 <__alltraps>

c0102032 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $41
c0102034:	6a 29                	push   $0x29
  jmp __alltraps
c0102036:	e9 06 09 00 00       	jmp    c0102941 <__alltraps>

c010203b <vector42>:
.globl vector42
vector42:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $42
c010203d:	6a 2a                	push   $0x2a
  jmp __alltraps
c010203f:	e9 fd 08 00 00       	jmp    c0102941 <__alltraps>

c0102044 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $43
c0102046:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102048:	e9 f4 08 00 00       	jmp    c0102941 <__alltraps>

c010204d <vector44>:
.globl vector44
vector44:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $44
c010204f:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102051:	e9 eb 08 00 00       	jmp    c0102941 <__alltraps>

c0102056 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $45
c0102058:	6a 2d                	push   $0x2d
  jmp __alltraps
c010205a:	e9 e2 08 00 00       	jmp    c0102941 <__alltraps>

c010205f <vector46>:
.globl vector46
vector46:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $46
c0102061:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102063:	e9 d9 08 00 00       	jmp    c0102941 <__alltraps>

c0102068 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $47
c010206a:	6a 2f                	push   $0x2f
  jmp __alltraps
c010206c:	e9 d0 08 00 00       	jmp    c0102941 <__alltraps>

c0102071 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $48
c0102073:	6a 30                	push   $0x30
  jmp __alltraps
c0102075:	e9 c7 08 00 00       	jmp    c0102941 <__alltraps>

c010207a <vector49>:
.globl vector49
vector49:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $49
c010207c:	6a 31                	push   $0x31
  jmp __alltraps
c010207e:	e9 be 08 00 00       	jmp    c0102941 <__alltraps>

c0102083 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $50
c0102085:	6a 32                	push   $0x32
  jmp __alltraps
c0102087:	e9 b5 08 00 00       	jmp    c0102941 <__alltraps>

c010208c <vector51>:
.globl vector51
vector51:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $51
c010208e:	6a 33                	push   $0x33
  jmp __alltraps
c0102090:	e9 ac 08 00 00       	jmp    c0102941 <__alltraps>

c0102095 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $52
c0102097:	6a 34                	push   $0x34
  jmp __alltraps
c0102099:	e9 a3 08 00 00       	jmp    c0102941 <__alltraps>

c010209e <vector53>:
.globl vector53
vector53:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $53
c01020a0:	6a 35                	push   $0x35
  jmp __alltraps
c01020a2:	e9 9a 08 00 00       	jmp    c0102941 <__alltraps>

c01020a7 <vector54>:
.globl vector54
vector54:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $54
c01020a9:	6a 36                	push   $0x36
  jmp __alltraps
c01020ab:	e9 91 08 00 00       	jmp    c0102941 <__alltraps>

c01020b0 <vector55>:
.globl vector55
vector55:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $55
c01020b2:	6a 37                	push   $0x37
  jmp __alltraps
c01020b4:	e9 88 08 00 00       	jmp    c0102941 <__alltraps>

c01020b9 <vector56>:
.globl vector56
vector56:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $56
c01020bb:	6a 38                	push   $0x38
  jmp __alltraps
c01020bd:	e9 7f 08 00 00       	jmp    c0102941 <__alltraps>

c01020c2 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $57
c01020c4:	6a 39                	push   $0x39
  jmp __alltraps
c01020c6:	e9 76 08 00 00       	jmp    c0102941 <__alltraps>

c01020cb <vector58>:
.globl vector58
vector58:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $58
c01020cd:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020cf:	e9 6d 08 00 00       	jmp    c0102941 <__alltraps>

c01020d4 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $59
c01020d6:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020d8:	e9 64 08 00 00       	jmp    c0102941 <__alltraps>

c01020dd <vector60>:
.globl vector60
vector60:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $60
c01020df:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020e1:	e9 5b 08 00 00       	jmp    c0102941 <__alltraps>

c01020e6 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $61
c01020e8:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020ea:	e9 52 08 00 00       	jmp    c0102941 <__alltraps>

c01020ef <vector62>:
.globl vector62
vector62:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $62
c01020f1:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020f3:	e9 49 08 00 00       	jmp    c0102941 <__alltraps>

c01020f8 <vector63>:
.globl vector63
vector63:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $63
c01020fa:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020fc:	e9 40 08 00 00       	jmp    c0102941 <__alltraps>

c0102101 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $64
c0102103:	6a 40                	push   $0x40
  jmp __alltraps
c0102105:	e9 37 08 00 00       	jmp    c0102941 <__alltraps>

c010210a <vector65>:
.globl vector65
vector65:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $65
c010210c:	6a 41                	push   $0x41
  jmp __alltraps
c010210e:	e9 2e 08 00 00       	jmp    c0102941 <__alltraps>

c0102113 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $66
c0102115:	6a 42                	push   $0x42
  jmp __alltraps
c0102117:	e9 25 08 00 00       	jmp    c0102941 <__alltraps>

c010211c <vector67>:
.globl vector67
vector67:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $67
c010211e:	6a 43                	push   $0x43
  jmp __alltraps
c0102120:	e9 1c 08 00 00       	jmp    c0102941 <__alltraps>

c0102125 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $68
c0102127:	6a 44                	push   $0x44
  jmp __alltraps
c0102129:	e9 13 08 00 00       	jmp    c0102941 <__alltraps>

c010212e <vector69>:
.globl vector69
vector69:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $69
c0102130:	6a 45                	push   $0x45
  jmp __alltraps
c0102132:	e9 0a 08 00 00       	jmp    c0102941 <__alltraps>

c0102137 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $70
c0102139:	6a 46                	push   $0x46
  jmp __alltraps
c010213b:	e9 01 08 00 00       	jmp    c0102941 <__alltraps>

c0102140 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $71
c0102142:	6a 47                	push   $0x47
  jmp __alltraps
c0102144:	e9 f8 07 00 00       	jmp    c0102941 <__alltraps>

c0102149 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $72
c010214b:	6a 48                	push   $0x48
  jmp __alltraps
c010214d:	e9 ef 07 00 00       	jmp    c0102941 <__alltraps>

c0102152 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $73
c0102154:	6a 49                	push   $0x49
  jmp __alltraps
c0102156:	e9 e6 07 00 00       	jmp    c0102941 <__alltraps>

c010215b <vector74>:
.globl vector74
vector74:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $74
c010215d:	6a 4a                	push   $0x4a
  jmp __alltraps
c010215f:	e9 dd 07 00 00       	jmp    c0102941 <__alltraps>

c0102164 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $75
c0102166:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102168:	e9 d4 07 00 00       	jmp    c0102941 <__alltraps>

c010216d <vector76>:
.globl vector76
vector76:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $76
c010216f:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102171:	e9 cb 07 00 00       	jmp    c0102941 <__alltraps>

c0102176 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $77
c0102178:	6a 4d                	push   $0x4d
  jmp __alltraps
c010217a:	e9 c2 07 00 00       	jmp    c0102941 <__alltraps>

c010217f <vector78>:
.globl vector78
vector78:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $78
c0102181:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102183:	e9 b9 07 00 00       	jmp    c0102941 <__alltraps>

c0102188 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $79
c010218a:	6a 4f                	push   $0x4f
  jmp __alltraps
c010218c:	e9 b0 07 00 00       	jmp    c0102941 <__alltraps>

c0102191 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $80
c0102193:	6a 50                	push   $0x50
  jmp __alltraps
c0102195:	e9 a7 07 00 00       	jmp    c0102941 <__alltraps>

c010219a <vector81>:
.globl vector81
vector81:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $81
c010219c:	6a 51                	push   $0x51
  jmp __alltraps
c010219e:	e9 9e 07 00 00       	jmp    c0102941 <__alltraps>

c01021a3 <vector82>:
.globl vector82
vector82:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $82
c01021a5:	6a 52                	push   $0x52
  jmp __alltraps
c01021a7:	e9 95 07 00 00       	jmp    c0102941 <__alltraps>

c01021ac <vector83>:
.globl vector83
vector83:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $83
c01021ae:	6a 53                	push   $0x53
  jmp __alltraps
c01021b0:	e9 8c 07 00 00       	jmp    c0102941 <__alltraps>

c01021b5 <vector84>:
.globl vector84
vector84:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $84
c01021b7:	6a 54                	push   $0x54
  jmp __alltraps
c01021b9:	e9 83 07 00 00       	jmp    c0102941 <__alltraps>

c01021be <vector85>:
.globl vector85
vector85:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $85
c01021c0:	6a 55                	push   $0x55
  jmp __alltraps
c01021c2:	e9 7a 07 00 00       	jmp    c0102941 <__alltraps>

c01021c7 <vector86>:
.globl vector86
vector86:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $86
c01021c9:	6a 56                	push   $0x56
  jmp __alltraps
c01021cb:	e9 71 07 00 00       	jmp    c0102941 <__alltraps>

c01021d0 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $87
c01021d2:	6a 57                	push   $0x57
  jmp __alltraps
c01021d4:	e9 68 07 00 00       	jmp    c0102941 <__alltraps>

c01021d9 <vector88>:
.globl vector88
vector88:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $88
c01021db:	6a 58                	push   $0x58
  jmp __alltraps
c01021dd:	e9 5f 07 00 00       	jmp    c0102941 <__alltraps>

c01021e2 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $89
c01021e4:	6a 59                	push   $0x59
  jmp __alltraps
c01021e6:	e9 56 07 00 00       	jmp    c0102941 <__alltraps>

c01021eb <vector90>:
.globl vector90
vector90:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $90
c01021ed:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021ef:	e9 4d 07 00 00       	jmp    c0102941 <__alltraps>

c01021f4 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $91
c01021f6:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021f8:	e9 44 07 00 00       	jmp    c0102941 <__alltraps>

c01021fd <vector92>:
.globl vector92
vector92:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $92
c01021ff:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102201:	e9 3b 07 00 00       	jmp    c0102941 <__alltraps>

c0102206 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $93
c0102208:	6a 5d                	push   $0x5d
  jmp __alltraps
c010220a:	e9 32 07 00 00       	jmp    c0102941 <__alltraps>

c010220f <vector94>:
.globl vector94
vector94:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $94
c0102211:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102213:	e9 29 07 00 00       	jmp    c0102941 <__alltraps>

c0102218 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $95
c010221a:	6a 5f                	push   $0x5f
  jmp __alltraps
c010221c:	e9 20 07 00 00       	jmp    c0102941 <__alltraps>

c0102221 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $96
c0102223:	6a 60                	push   $0x60
  jmp __alltraps
c0102225:	e9 17 07 00 00       	jmp    c0102941 <__alltraps>

c010222a <vector97>:
.globl vector97
vector97:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $97
c010222c:	6a 61                	push   $0x61
  jmp __alltraps
c010222e:	e9 0e 07 00 00       	jmp    c0102941 <__alltraps>

c0102233 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $98
c0102235:	6a 62                	push   $0x62
  jmp __alltraps
c0102237:	e9 05 07 00 00       	jmp    c0102941 <__alltraps>

c010223c <vector99>:
.globl vector99
vector99:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $99
c010223e:	6a 63                	push   $0x63
  jmp __alltraps
c0102240:	e9 fc 06 00 00       	jmp    c0102941 <__alltraps>

c0102245 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $100
c0102247:	6a 64                	push   $0x64
  jmp __alltraps
c0102249:	e9 f3 06 00 00       	jmp    c0102941 <__alltraps>

c010224e <vector101>:
.globl vector101
vector101:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $101
c0102250:	6a 65                	push   $0x65
  jmp __alltraps
c0102252:	e9 ea 06 00 00       	jmp    c0102941 <__alltraps>

c0102257 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $102
c0102259:	6a 66                	push   $0x66
  jmp __alltraps
c010225b:	e9 e1 06 00 00       	jmp    c0102941 <__alltraps>

c0102260 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $103
c0102262:	6a 67                	push   $0x67
  jmp __alltraps
c0102264:	e9 d8 06 00 00       	jmp    c0102941 <__alltraps>

c0102269 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $104
c010226b:	6a 68                	push   $0x68
  jmp __alltraps
c010226d:	e9 cf 06 00 00       	jmp    c0102941 <__alltraps>

c0102272 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $105
c0102274:	6a 69                	push   $0x69
  jmp __alltraps
c0102276:	e9 c6 06 00 00       	jmp    c0102941 <__alltraps>

c010227b <vector106>:
.globl vector106
vector106:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $106
c010227d:	6a 6a                	push   $0x6a
  jmp __alltraps
c010227f:	e9 bd 06 00 00       	jmp    c0102941 <__alltraps>

c0102284 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $107
c0102286:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102288:	e9 b4 06 00 00       	jmp    c0102941 <__alltraps>

c010228d <vector108>:
.globl vector108
vector108:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $108
c010228f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102291:	e9 ab 06 00 00       	jmp    c0102941 <__alltraps>

c0102296 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $109
c0102298:	6a 6d                	push   $0x6d
  jmp __alltraps
c010229a:	e9 a2 06 00 00       	jmp    c0102941 <__alltraps>

c010229f <vector110>:
.globl vector110
vector110:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $110
c01022a1:	6a 6e                	push   $0x6e
  jmp __alltraps
c01022a3:	e9 99 06 00 00       	jmp    c0102941 <__alltraps>

c01022a8 <vector111>:
.globl vector111
vector111:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $111
c01022aa:	6a 6f                	push   $0x6f
  jmp __alltraps
c01022ac:	e9 90 06 00 00       	jmp    c0102941 <__alltraps>

c01022b1 <vector112>:
.globl vector112
vector112:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $112
c01022b3:	6a 70                	push   $0x70
  jmp __alltraps
c01022b5:	e9 87 06 00 00       	jmp    c0102941 <__alltraps>

c01022ba <vector113>:
.globl vector113
vector113:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $113
c01022bc:	6a 71                	push   $0x71
  jmp __alltraps
c01022be:	e9 7e 06 00 00       	jmp    c0102941 <__alltraps>

c01022c3 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $114
c01022c5:	6a 72                	push   $0x72
  jmp __alltraps
c01022c7:	e9 75 06 00 00       	jmp    c0102941 <__alltraps>

c01022cc <vector115>:
.globl vector115
vector115:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $115
c01022ce:	6a 73                	push   $0x73
  jmp __alltraps
c01022d0:	e9 6c 06 00 00       	jmp    c0102941 <__alltraps>

c01022d5 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $116
c01022d7:	6a 74                	push   $0x74
  jmp __alltraps
c01022d9:	e9 63 06 00 00       	jmp    c0102941 <__alltraps>

c01022de <vector117>:
.globl vector117
vector117:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $117
c01022e0:	6a 75                	push   $0x75
  jmp __alltraps
c01022e2:	e9 5a 06 00 00       	jmp    c0102941 <__alltraps>

c01022e7 <vector118>:
.globl vector118
vector118:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $118
c01022e9:	6a 76                	push   $0x76
  jmp __alltraps
c01022eb:	e9 51 06 00 00       	jmp    c0102941 <__alltraps>

c01022f0 <vector119>:
.globl vector119
vector119:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $119
c01022f2:	6a 77                	push   $0x77
  jmp __alltraps
c01022f4:	e9 48 06 00 00       	jmp    c0102941 <__alltraps>

c01022f9 <vector120>:
.globl vector120
vector120:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $120
c01022fb:	6a 78                	push   $0x78
  jmp __alltraps
c01022fd:	e9 3f 06 00 00       	jmp    c0102941 <__alltraps>

c0102302 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $121
c0102304:	6a 79                	push   $0x79
  jmp __alltraps
c0102306:	e9 36 06 00 00       	jmp    c0102941 <__alltraps>

c010230b <vector122>:
.globl vector122
vector122:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $122
c010230d:	6a 7a                	push   $0x7a
  jmp __alltraps
c010230f:	e9 2d 06 00 00       	jmp    c0102941 <__alltraps>

c0102314 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $123
c0102316:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102318:	e9 24 06 00 00       	jmp    c0102941 <__alltraps>

c010231d <vector124>:
.globl vector124
vector124:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $124
c010231f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102321:	e9 1b 06 00 00       	jmp    c0102941 <__alltraps>

c0102326 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $125
c0102328:	6a 7d                	push   $0x7d
  jmp __alltraps
c010232a:	e9 12 06 00 00       	jmp    c0102941 <__alltraps>

c010232f <vector126>:
.globl vector126
vector126:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $126
c0102331:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102333:	e9 09 06 00 00       	jmp    c0102941 <__alltraps>

c0102338 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $127
c010233a:	6a 7f                	push   $0x7f
  jmp __alltraps
c010233c:	e9 00 06 00 00       	jmp    c0102941 <__alltraps>

c0102341 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $128
c0102343:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102348:	e9 f4 05 00 00       	jmp    c0102941 <__alltraps>

c010234d <vector129>:
.globl vector129
vector129:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $129
c010234f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102354:	e9 e8 05 00 00       	jmp    c0102941 <__alltraps>

c0102359 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $130
c010235b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102360:	e9 dc 05 00 00       	jmp    c0102941 <__alltraps>

c0102365 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $131
c0102367:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010236c:	e9 d0 05 00 00       	jmp    c0102941 <__alltraps>

c0102371 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $132
c0102373:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102378:	e9 c4 05 00 00       	jmp    c0102941 <__alltraps>

c010237d <vector133>:
.globl vector133
vector133:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $133
c010237f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102384:	e9 b8 05 00 00       	jmp    c0102941 <__alltraps>

c0102389 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $134
c010238b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102390:	e9 ac 05 00 00       	jmp    c0102941 <__alltraps>

c0102395 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $135
c0102397:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010239c:	e9 a0 05 00 00       	jmp    c0102941 <__alltraps>

c01023a1 <vector136>:
.globl vector136
vector136:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $136
c01023a3:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01023a8:	e9 94 05 00 00       	jmp    c0102941 <__alltraps>

c01023ad <vector137>:
.globl vector137
vector137:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $137
c01023af:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01023b4:	e9 88 05 00 00       	jmp    c0102941 <__alltraps>

c01023b9 <vector138>:
.globl vector138
vector138:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $138
c01023bb:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023c0:	e9 7c 05 00 00       	jmp    c0102941 <__alltraps>

c01023c5 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $139
c01023c7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023cc:	e9 70 05 00 00       	jmp    c0102941 <__alltraps>

c01023d1 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $140
c01023d3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023d8:	e9 64 05 00 00       	jmp    c0102941 <__alltraps>

c01023dd <vector141>:
.globl vector141
vector141:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $141
c01023df:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023e4:	e9 58 05 00 00       	jmp    c0102941 <__alltraps>

c01023e9 <vector142>:
.globl vector142
vector142:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $142
c01023eb:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023f0:	e9 4c 05 00 00       	jmp    c0102941 <__alltraps>

c01023f5 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $143
c01023f7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023fc:	e9 40 05 00 00       	jmp    c0102941 <__alltraps>

c0102401 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $144
c0102403:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102408:	e9 34 05 00 00       	jmp    c0102941 <__alltraps>

c010240d <vector145>:
.globl vector145
vector145:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $145
c010240f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102414:	e9 28 05 00 00       	jmp    c0102941 <__alltraps>

c0102419 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $146
c010241b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102420:	e9 1c 05 00 00       	jmp    c0102941 <__alltraps>

c0102425 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $147
c0102427:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010242c:	e9 10 05 00 00       	jmp    c0102941 <__alltraps>

c0102431 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $148
c0102433:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102438:	e9 04 05 00 00       	jmp    c0102941 <__alltraps>

c010243d <vector149>:
.globl vector149
vector149:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $149
c010243f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102444:	e9 f8 04 00 00       	jmp    c0102941 <__alltraps>

c0102449 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $150
c010244b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102450:	e9 ec 04 00 00       	jmp    c0102941 <__alltraps>

c0102455 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $151
c0102457:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010245c:	e9 e0 04 00 00       	jmp    c0102941 <__alltraps>

c0102461 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $152
c0102463:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102468:	e9 d4 04 00 00       	jmp    c0102941 <__alltraps>

c010246d <vector153>:
.globl vector153
vector153:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $153
c010246f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102474:	e9 c8 04 00 00       	jmp    c0102941 <__alltraps>

c0102479 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $154
c010247b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102480:	e9 bc 04 00 00       	jmp    c0102941 <__alltraps>

c0102485 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $155
c0102487:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010248c:	e9 b0 04 00 00       	jmp    c0102941 <__alltraps>

c0102491 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $156
c0102493:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102498:	e9 a4 04 00 00       	jmp    c0102941 <__alltraps>

c010249d <vector157>:
.globl vector157
vector157:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $157
c010249f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01024a4:	e9 98 04 00 00       	jmp    c0102941 <__alltraps>

c01024a9 <vector158>:
.globl vector158
vector158:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $158
c01024ab:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01024b0:	e9 8c 04 00 00       	jmp    c0102941 <__alltraps>

c01024b5 <vector159>:
.globl vector159
vector159:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $159
c01024b7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01024bc:	e9 80 04 00 00       	jmp    c0102941 <__alltraps>

c01024c1 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $160
c01024c3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024c8:	e9 74 04 00 00       	jmp    c0102941 <__alltraps>

c01024cd <vector161>:
.globl vector161
vector161:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $161
c01024cf:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024d4:	e9 68 04 00 00       	jmp    c0102941 <__alltraps>

c01024d9 <vector162>:
.globl vector162
vector162:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $162
c01024db:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024e0:	e9 5c 04 00 00       	jmp    c0102941 <__alltraps>

c01024e5 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $163
c01024e7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024ec:	e9 50 04 00 00       	jmp    c0102941 <__alltraps>

c01024f1 <vector164>:
.globl vector164
vector164:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $164
c01024f3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024f8:	e9 44 04 00 00       	jmp    c0102941 <__alltraps>

c01024fd <vector165>:
.globl vector165
vector165:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $165
c01024ff:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102504:	e9 38 04 00 00       	jmp    c0102941 <__alltraps>

c0102509 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $166
c010250b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102510:	e9 2c 04 00 00       	jmp    c0102941 <__alltraps>

c0102515 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $167
c0102517:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010251c:	e9 20 04 00 00       	jmp    c0102941 <__alltraps>

c0102521 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $168
c0102523:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102528:	e9 14 04 00 00       	jmp    c0102941 <__alltraps>

c010252d <vector169>:
.globl vector169
vector169:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $169
c010252f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102534:	e9 08 04 00 00       	jmp    c0102941 <__alltraps>

c0102539 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $170
c010253b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102540:	e9 fc 03 00 00       	jmp    c0102941 <__alltraps>

c0102545 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $171
c0102547:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010254c:	e9 f0 03 00 00       	jmp    c0102941 <__alltraps>

c0102551 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $172
c0102553:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102558:	e9 e4 03 00 00       	jmp    c0102941 <__alltraps>

c010255d <vector173>:
.globl vector173
vector173:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $173
c010255f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102564:	e9 d8 03 00 00       	jmp    c0102941 <__alltraps>

c0102569 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $174
c010256b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102570:	e9 cc 03 00 00       	jmp    c0102941 <__alltraps>

c0102575 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $175
c0102577:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010257c:	e9 c0 03 00 00       	jmp    c0102941 <__alltraps>

c0102581 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $176
c0102583:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102588:	e9 b4 03 00 00       	jmp    c0102941 <__alltraps>

c010258d <vector177>:
.globl vector177
vector177:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $177
c010258f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102594:	e9 a8 03 00 00       	jmp    c0102941 <__alltraps>

c0102599 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $178
c010259b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01025a0:	e9 9c 03 00 00       	jmp    c0102941 <__alltraps>

c01025a5 <vector179>:
.globl vector179
vector179:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $179
c01025a7:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01025ac:	e9 90 03 00 00       	jmp    c0102941 <__alltraps>

c01025b1 <vector180>:
.globl vector180
vector180:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $180
c01025b3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01025b8:	e9 84 03 00 00       	jmp    c0102941 <__alltraps>

c01025bd <vector181>:
.globl vector181
vector181:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $181
c01025bf:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025c4:	e9 78 03 00 00       	jmp    c0102941 <__alltraps>

c01025c9 <vector182>:
.globl vector182
vector182:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $182
c01025cb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025d0:	e9 6c 03 00 00       	jmp    c0102941 <__alltraps>

c01025d5 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $183
c01025d7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025dc:	e9 60 03 00 00       	jmp    c0102941 <__alltraps>

c01025e1 <vector184>:
.globl vector184
vector184:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $184
c01025e3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025e8:	e9 54 03 00 00       	jmp    c0102941 <__alltraps>

c01025ed <vector185>:
.globl vector185
vector185:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $185
c01025ef:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025f4:	e9 48 03 00 00       	jmp    c0102941 <__alltraps>

c01025f9 <vector186>:
.globl vector186
vector186:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $186
c01025fb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102600:	e9 3c 03 00 00       	jmp    c0102941 <__alltraps>

c0102605 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $187
c0102607:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010260c:	e9 30 03 00 00       	jmp    c0102941 <__alltraps>

c0102611 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $188
c0102613:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102618:	e9 24 03 00 00       	jmp    c0102941 <__alltraps>

c010261d <vector189>:
.globl vector189
vector189:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $189
c010261f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102624:	e9 18 03 00 00       	jmp    c0102941 <__alltraps>

c0102629 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $190
c010262b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102630:	e9 0c 03 00 00       	jmp    c0102941 <__alltraps>

c0102635 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $191
c0102637:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010263c:	e9 00 03 00 00       	jmp    c0102941 <__alltraps>

c0102641 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $192
c0102643:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102648:	e9 f4 02 00 00       	jmp    c0102941 <__alltraps>

c010264d <vector193>:
.globl vector193
vector193:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $193
c010264f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102654:	e9 e8 02 00 00       	jmp    c0102941 <__alltraps>

c0102659 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $194
c010265b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102660:	e9 dc 02 00 00       	jmp    c0102941 <__alltraps>

c0102665 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $195
c0102667:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010266c:	e9 d0 02 00 00       	jmp    c0102941 <__alltraps>

c0102671 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $196
c0102673:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102678:	e9 c4 02 00 00       	jmp    c0102941 <__alltraps>

c010267d <vector197>:
.globl vector197
vector197:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $197
c010267f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102684:	e9 b8 02 00 00       	jmp    c0102941 <__alltraps>

c0102689 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $198
c010268b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102690:	e9 ac 02 00 00       	jmp    c0102941 <__alltraps>

c0102695 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $199
c0102697:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010269c:	e9 a0 02 00 00       	jmp    c0102941 <__alltraps>

c01026a1 <vector200>:
.globl vector200
vector200:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $200
c01026a3:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01026a8:	e9 94 02 00 00       	jmp    c0102941 <__alltraps>

c01026ad <vector201>:
.globl vector201
vector201:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $201
c01026af:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01026b4:	e9 88 02 00 00       	jmp    c0102941 <__alltraps>

c01026b9 <vector202>:
.globl vector202
vector202:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $202
c01026bb:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026c0:	e9 7c 02 00 00       	jmp    c0102941 <__alltraps>

c01026c5 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $203
c01026c7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026cc:	e9 70 02 00 00       	jmp    c0102941 <__alltraps>

c01026d1 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $204
c01026d3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026d8:	e9 64 02 00 00       	jmp    c0102941 <__alltraps>

c01026dd <vector205>:
.globl vector205
vector205:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $205
c01026df:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026e4:	e9 58 02 00 00       	jmp    c0102941 <__alltraps>

c01026e9 <vector206>:
.globl vector206
vector206:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $206
c01026eb:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026f0:	e9 4c 02 00 00       	jmp    c0102941 <__alltraps>

c01026f5 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $207
c01026f7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026fc:	e9 40 02 00 00       	jmp    c0102941 <__alltraps>

c0102701 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $208
c0102703:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102708:	e9 34 02 00 00       	jmp    c0102941 <__alltraps>

c010270d <vector209>:
.globl vector209
vector209:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $209
c010270f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102714:	e9 28 02 00 00       	jmp    c0102941 <__alltraps>

c0102719 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $210
c010271b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102720:	e9 1c 02 00 00       	jmp    c0102941 <__alltraps>

c0102725 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $211
c0102727:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010272c:	e9 10 02 00 00       	jmp    c0102941 <__alltraps>

c0102731 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $212
c0102733:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102738:	e9 04 02 00 00       	jmp    c0102941 <__alltraps>

c010273d <vector213>:
.globl vector213
vector213:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $213
c010273f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102744:	e9 f8 01 00 00       	jmp    c0102941 <__alltraps>

c0102749 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $214
c010274b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102750:	e9 ec 01 00 00       	jmp    c0102941 <__alltraps>

c0102755 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $215
c0102757:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010275c:	e9 e0 01 00 00       	jmp    c0102941 <__alltraps>

c0102761 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $216
c0102763:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102768:	e9 d4 01 00 00       	jmp    c0102941 <__alltraps>

c010276d <vector217>:
.globl vector217
vector217:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $217
c010276f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102774:	e9 c8 01 00 00       	jmp    c0102941 <__alltraps>

c0102779 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $218
c010277b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102780:	e9 bc 01 00 00       	jmp    c0102941 <__alltraps>

c0102785 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $219
c0102787:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010278c:	e9 b0 01 00 00       	jmp    c0102941 <__alltraps>

c0102791 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $220
c0102793:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102798:	e9 a4 01 00 00       	jmp    c0102941 <__alltraps>

c010279d <vector221>:
.globl vector221
vector221:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $221
c010279f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01027a4:	e9 98 01 00 00       	jmp    c0102941 <__alltraps>

c01027a9 <vector222>:
.globl vector222
vector222:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $222
c01027ab:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01027b0:	e9 8c 01 00 00       	jmp    c0102941 <__alltraps>

c01027b5 <vector223>:
.globl vector223
vector223:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $223
c01027b7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01027bc:	e9 80 01 00 00       	jmp    c0102941 <__alltraps>

c01027c1 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $224
c01027c3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027c8:	e9 74 01 00 00       	jmp    c0102941 <__alltraps>

c01027cd <vector225>:
.globl vector225
vector225:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $225
c01027cf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027d4:	e9 68 01 00 00       	jmp    c0102941 <__alltraps>

c01027d9 <vector226>:
.globl vector226
vector226:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $226
c01027db:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027e0:	e9 5c 01 00 00       	jmp    c0102941 <__alltraps>

c01027e5 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $227
c01027e7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027ec:	e9 50 01 00 00       	jmp    c0102941 <__alltraps>

c01027f1 <vector228>:
.globl vector228
vector228:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $228
c01027f3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027f8:	e9 44 01 00 00       	jmp    c0102941 <__alltraps>

c01027fd <vector229>:
.globl vector229
vector229:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $229
c01027ff:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102804:	e9 38 01 00 00       	jmp    c0102941 <__alltraps>

c0102809 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $230
c010280b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102810:	e9 2c 01 00 00       	jmp    c0102941 <__alltraps>

c0102815 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $231
c0102817:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010281c:	e9 20 01 00 00       	jmp    c0102941 <__alltraps>

c0102821 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $232
c0102823:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102828:	e9 14 01 00 00       	jmp    c0102941 <__alltraps>

c010282d <vector233>:
.globl vector233
vector233:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $233
c010282f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102834:	e9 08 01 00 00       	jmp    c0102941 <__alltraps>

c0102839 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $234
c010283b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102840:	e9 fc 00 00 00       	jmp    c0102941 <__alltraps>

c0102845 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102845:	6a 00                	push   $0x0
  pushl $235
c0102847:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010284c:	e9 f0 00 00 00       	jmp    c0102941 <__alltraps>

c0102851 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $236
c0102853:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102858:	e9 e4 00 00 00       	jmp    c0102941 <__alltraps>

c010285d <vector237>:
.globl vector237
vector237:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $237
c010285f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102864:	e9 d8 00 00 00       	jmp    c0102941 <__alltraps>

c0102869 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102869:	6a 00                	push   $0x0
  pushl $238
c010286b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102870:	e9 cc 00 00 00       	jmp    c0102941 <__alltraps>

c0102875 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $239
c0102877:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010287c:	e9 c0 00 00 00       	jmp    c0102941 <__alltraps>

c0102881 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $240
c0102883:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102888:	e9 b4 00 00 00       	jmp    c0102941 <__alltraps>

c010288d <vector241>:
.globl vector241
vector241:
  pushl $0
c010288d:	6a 00                	push   $0x0
  pushl $241
c010288f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102894:	e9 a8 00 00 00       	jmp    c0102941 <__alltraps>

c0102899 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $242
c010289b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01028a0:	e9 9c 00 00 00       	jmp    c0102941 <__alltraps>

c01028a5 <vector243>:
.globl vector243
vector243:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $243
c01028a7:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01028ac:	e9 90 00 00 00       	jmp    c0102941 <__alltraps>

c01028b1 <vector244>:
.globl vector244
vector244:
  pushl $0
c01028b1:	6a 00                	push   $0x0
  pushl $244
c01028b3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01028b8:	e9 84 00 00 00       	jmp    c0102941 <__alltraps>

c01028bd <vector245>:
.globl vector245
vector245:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $245
c01028bf:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028c4:	e9 78 00 00 00       	jmp    c0102941 <__alltraps>

c01028c9 <vector246>:
.globl vector246
vector246:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $246
c01028cb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028d0:	e9 6c 00 00 00       	jmp    c0102941 <__alltraps>

c01028d5 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028d5:	6a 00                	push   $0x0
  pushl $247
c01028d7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028dc:	e9 60 00 00 00       	jmp    c0102941 <__alltraps>

c01028e1 <vector248>:
.globl vector248
vector248:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $248
c01028e3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028e8:	e9 54 00 00 00       	jmp    c0102941 <__alltraps>

c01028ed <vector249>:
.globl vector249
vector249:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $249
c01028ef:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028f4:	e9 48 00 00 00       	jmp    c0102941 <__alltraps>

c01028f9 <vector250>:
.globl vector250
vector250:
  pushl $0
c01028f9:	6a 00                	push   $0x0
  pushl $250
c01028fb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102900:	e9 3c 00 00 00       	jmp    c0102941 <__alltraps>

c0102905 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $251
c0102907:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010290c:	e9 30 00 00 00       	jmp    c0102941 <__alltraps>

c0102911 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $252
c0102913:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102918:	e9 24 00 00 00       	jmp    c0102941 <__alltraps>

c010291d <vector253>:
.globl vector253
vector253:
  pushl $0
c010291d:	6a 00                	push   $0x0
  pushl $253
c010291f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102924:	e9 18 00 00 00       	jmp    c0102941 <__alltraps>

c0102929 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $254
c010292b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102930:	e9 0c 00 00 00       	jmp    c0102941 <__alltraps>

c0102935 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $255
c0102937:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010293c:	e9 00 00 00 00       	jmp    c0102941 <__alltraps>

c0102941 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102941:	1e                   	push   %ds
    pushl %es
c0102942:	06                   	push   %es
    pushl %fs
c0102943:	0f a0                	push   %fs
    pushl %gs
c0102945:	0f a8                	push   %gs
    pushal
c0102947:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102948:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010294d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010294f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102951:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102952:	e8 5f f5 ff ff       	call   c0101eb6 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102957:	5c                   	pop    %esp

c0102958 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102958:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102959:	0f a9                	pop    %gs
    popl %fs
c010295b:	0f a1                	pop    %fs
    popl %es
c010295d:	07                   	pop    %es
    popl %ds
c010295e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010295f:	83 c4 08             	add    $0x8,%esp
    iret
c0102962:	cf                   	iret   

c0102963 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102963:	55                   	push   %ebp
c0102964:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102966:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c010296b:	8b 55 08             	mov    0x8(%ebp),%edx
c010296e:	29 c2                	sub    %eax,%edx
c0102970:	89 d0                	mov    %edx,%eax
c0102972:	c1 f8 02             	sar    $0x2,%eax
c0102975:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010297b:	5d                   	pop    %ebp
c010297c:	c3                   	ret    

c010297d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010297d:	55                   	push   %ebp
c010297e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0102980:	ff 75 08             	pushl  0x8(%ebp)
c0102983:	e8 db ff ff ff       	call   c0102963 <page2ppn>
c0102988:	83 c4 04             	add    $0x4,%esp
c010298b:	c1 e0 0c             	shl    $0xc,%eax
}
c010298e:	c9                   	leave  
c010298f:	c3                   	ret    

c0102990 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102990:	55                   	push   %ebp
c0102991:	89 e5                	mov    %esp,%ebp
c0102993:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c0102996:	8b 45 08             	mov    0x8(%ebp),%eax
c0102999:	c1 e8 0c             	shr    $0xc,%eax
c010299c:	89 c2                	mov    %eax,%edx
c010299e:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01029a3:	39 c2                	cmp    %eax,%edx
c01029a5:	72 14                	jb     c01029bb <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01029a7:	83 ec 04             	sub    $0x4,%esp
c01029aa:	68 50 63 10 c0       	push   $0xc0106350
c01029af:	6a 5a                	push   $0x5a
c01029b1:	68 6f 63 10 c0       	push   $0xc010636f
c01029b6:	e8 5b da ff ff       	call   c0100416 <__panic>
    }
    return &pages[PPN(pa)];
c01029bb:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c01029c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c4:	c1 e8 0c             	shr    $0xc,%eax
c01029c7:	89 c2                	mov    %eax,%edx
c01029c9:	89 d0                	mov    %edx,%eax
c01029cb:	c1 e0 02             	shl    $0x2,%eax
c01029ce:	01 d0                	add    %edx,%eax
c01029d0:	c1 e0 02             	shl    $0x2,%eax
c01029d3:	01 c8                	add    %ecx,%eax
}
c01029d5:	c9                   	leave  
c01029d6:	c3                   	ret    

c01029d7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01029d7:	55                   	push   %ebp
c01029d8:	89 e5                	mov    %esp,%ebp
c01029da:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c01029dd:	ff 75 08             	pushl  0x8(%ebp)
c01029e0:	e8 98 ff ff ff       	call   c010297d <page2pa>
c01029e5:	83 c4 04             	add    $0x4,%esp
c01029e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ee:	c1 e8 0c             	shr    $0xc,%eax
c01029f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01029f4:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01029f9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01029fc:	72 14                	jb     c0102a12 <page2kva+0x3b>
c01029fe:	ff 75 f4             	pushl  -0xc(%ebp)
c0102a01:	68 80 63 10 c0       	push   $0xc0106380
c0102a06:	6a 61                	push   $0x61
c0102a08:	68 6f 63 10 c0       	push   $0xc010636f
c0102a0d:	e8 04 da ff ff       	call   c0100416 <__panic>
c0102a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a15:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a1a:	c9                   	leave  
c0102a1b:	c3                   	ret    

c0102a1c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a1c:	55                   	push   %ebp
c0102a1d:	89 e5                	mov    %esp,%ebp
c0102a1f:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0102a22:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a25:	83 e0 01             	and    $0x1,%eax
c0102a28:	85 c0                	test   %eax,%eax
c0102a2a:	75 14                	jne    c0102a40 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102a2c:	83 ec 04             	sub    $0x4,%esp
c0102a2f:	68 a4 63 10 c0       	push   $0xc01063a4
c0102a34:	6a 6c                	push   $0x6c
c0102a36:	68 6f 63 10 c0       	push   $0xc010636f
c0102a3b:	e8 d6 d9 ff ff       	call   c0100416 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a48:	83 ec 0c             	sub    $0xc,%esp
c0102a4b:	50                   	push   %eax
c0102a4c:	e8 3f ff ff ff       	call   c0102990 <pa2page>
c0102a51:	83 c4 10             	add    $0x10,%esp
}
c0102a54:	c9                   	leave  
c0102a55:	c3                   	ret    

c0102a56 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102a56:	55                   	push   %ebp
c0102a57:	89 e5                	mov    %esp,%ebp
c0102a59:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102a64:	83 ec 0c             	sub    $0xc,%esp
c0102a67:	50                   	push   %eax
c0102a68:	e8 23 ff ff ff       	call   c0102990 <pa2page>
c0102a6d:	83 c4 10             	add    $0x10,%esp
}
c0102a70:	c9                   	leave  
c0102a71:	c3                   	ret    

c0102a72 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102a72:	55                   	push   %ebp
c0102a73:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a78:	8b 00                	mov    (%eax),%eax
}
c0102a7a:	5d                   	pop    %ebp
c0102a7b:	c3                   	ret    

c0102a7c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102a7c:	55                   	push   %ebp
c0102a7d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a82:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a85:	89 10                	mov    %edx,(%eax)
}
c0102a87:	90                   	nop
c0102a88:	5d                   	pop    %ebp
c0102a89:	c3                   	ret    

c0102a8a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102a8a:	55                   	push   %ebp
c0102a8b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a90:	8b 00                	mov    (%eax),%eax
c0102a92:	8d 50 01             	lea    0x1(%eax),%edx
c0102a95:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a98:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9d:	8b 00                	mov    (%eax),%eax
}
c0102a9f:	5d                   	pop    %ebp
c0102aa0:	c3                   	ret    

c0102aa1 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102aa1:	55                   	push   %ebp
c0102aa2:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa7:	8b 00                	mov    (%eax),%eax
c0102aa9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aaf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102ab1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab4:	8b 00                	mov    (%eax),%eax
}
c0102ab6:	5d                   	pop    %ebp
c0102ab7:	c3                   	ret    

c0102ab8 <__intr_save>:
__intr_save(void) {
c0102ab8:	55                   	push   %ebp
c0102ab9:	89 e5                	mov    %esp,%ebp
c0102abb:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102abe:	9c                   	pushf  
c0102abf:	58                   	pop    %eax
c0102ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102ac6:	25 00 02 00 00       	and    $0x200,%eax
c0102acb:	85 c0                	test   %eax,%eax
c0102acd:	74 0c                	je     c0102adb <__intr_save+0x23>
        intr_disable();
c0102acf:	e8 a8 ee ff ff       	call   c010197c <intr_disable>
        return 1;
c0102ad4:	b8 01 00 00 00       	mov    $0x1,%eax
c0102ad9:	eb 05                	jmp    c0102ae0 <__intr_save+0x28>
    return 0;
c0102adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102ae0:	c9                   	leave  
c0102ae1:	c3                   	ret    

c0102ae2 <__intr_restore>:
__intr_restore(bool flag) {
c0102ae2:	55                   	push   %ebp
c0102ae3:	89 e5                	mov    %esp,%ebp
c0102ae5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aec:	74 05                	je     c0102af3 <__intr_restore+0x11>
        intr_enable();
c0102aee:	e8 7d ee ff ff       	call   c0101970 <intr_enable>
}
c0102af3:	90                   	nop
c0102af4:	c9                   	leave  
c0102af5:	c3                   	ret    

c0102af6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102af6:	55                   	push   %ebp
c0102af7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102afc:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102aff:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b04:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b06:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b0b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b0d:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b12:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b14:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b19:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b1b:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b20:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b22:	ea 29 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102b29
}
c0102b29:	90                   	nop
c0102b2a:	5d                   	pop    %ebp
c0102b2b:	c3                   	ret    

c0102b2c <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102b2c:	f3 0f 1e fb          	endbr32 
c0102b30:	55                   	push   %ebp
c0102b31:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b36:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
}
c0102b3b:	90                   	nop
c0102b3c:	5d                   	pop    %ebp
c0102b3d:	c3                   	ret    

c0102b3e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102b3e:	f3 0f 1e fb          	endbr32 
c0102b42:	55                   	push   %ebp
c0102b43:	89 e5                	mov    %esp,%ebp
c0102b45:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102b48:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102b4d:	50                   	push   %eax
c0102b4e:	e8 d9 ff ff ff       	call   c0102b2c <load_esp0>
c0102b53:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102b56:	66 c7 05 a8 ce 11 c0 	movw   $0x10,0xc011cea8
c0102b5d:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102b5f:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102b66:	68 00 
c0102b68:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b6d:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102b73:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102b78:	c1 e8 10             	shr    $0x10,%eax
c0102b7b:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102b80:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102b87:	83 e0 f0             	and    $0xfffffff0,%eax
c0102b8a:	83 c8 09             	or     $0x9,%eax
c0102b8d:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102b92:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102b99:	83 e0 ef             	and    $0xffffffef,%eax
c0102b9c:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102ba1:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102ba8:	83 e0 9f             	and    $0xffffff9f,%eax
c0102bab:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bb0:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102bb7:	83 c8 80             	or     $0xffffff80,%eax
c0102bba:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102bbf:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bc6:	83 e0 f0             	and    $0xfffffff0,%eax
c0102bc9:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bce:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bd5:	83 e0 ef             	and    $0xffffffef,%eax
c0102bd8:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bdd:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102be4:	83 e0 df             	and    $0xffffffdf,%eax
c0102be7:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bec:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102bf3:	83 c8 40             	or     $0x40,%eax
c0102bf6:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102bfb:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c02:	83 e0 7f             	and    $0x7f,%eax
c0102c05:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c0a:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c0f:	c1 e8 18             	shr    $0x18,%eax
c0102c12:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c17:	68 30 9a 11 c0       	push   $0xc0119a30
c0102c1c:	e8 d5 fe ff ff       	call   c0102af6 <lgdt>
c0102c21:	83 c4 04             	add    $0x4,%esp
c0102c24:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c2a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c2e:	0f 00 d8             	ltr    %ax
}
c0102c31:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102c32:	90                   	nop
c0102c33:	c9                   	leave  
c0102c34:	c3                   	ret    

c0102c35 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102c35:	f3 0f 1e fb          	endbr32 
c0102c39:	55                   	push   %ebp
c0102c3a:	89 e5                	mov    %esp,%ebp
c0102c3c:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102c3f:	c7 05 10 cf 11 c0 48 	movl   $0xc0106d48,0xc011cf10
c0102c46:	6d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102c49:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c4e:	8b 00                	mov    (%eax),%eax
c0102c50:	83 ec 08             	sub    $0x8,%esp
c0102c53:	50                   	push   %eax
c0102c54:	68 d0 63 10 c0       	push   $0xc01063d0
c0102c59:	e8 3d d6 ff ff       	call   c010029b <cprintf>
c0102c5e:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102c61:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c66:	8b 40 04             	mov    0x4(%eax),%eax
c0102c69:	ff d0                	call   *%eax
}
c0102c6b:	90                   	nop
c0102c6c:	c9                   	leave  
c0102c6d:	c3                   	ret    

c0102c6e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102c6e:	f3 0f 1e fb          	endbr32 
c0102c72:	55                   	push   %ebp
c0102c73:	89 e5                	mov    %esp,%ebp
c0102c75:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102c78:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102c7d:	8b 40 08             	mov    0x8(%eax),%eax
c0102c80:	83 ec 08             	sub    $0x8,%esp
c0102c83:	ff 75 0c             	pushl  0xc(%ebp)
c0102c86:	ff 75 08             	pushl  0x8(%ebp)
c0102c89:	ff d0                	call   *%eax
c0102c8b:	83 c4 10             	add    $0x10,%esp
}
c0102c8e:	90                   	nop
c0102c8f:	c9                   	leave  
c0102c90:	c3                   	ret    

c0102c91 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102c91:	f3 0f 1e fb          	endbr32 
c0102c95:	55                   	push   %ebp
c0102c96:	89 e5                	mov    %esp,%ebp
c0102c98:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102c9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102ca2:	e8 11 fe ff ff       	call   c0102ab8 <__intr_save>
c0102ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102caa:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102caf:	8b 40 0c             	mov    0xc(%eax),%eax
c0102cb2:	83 ec 0c             	sub    $0xc,%esp
c0102cb5:	ff 75 08             	pushl  0x8(%ebp)
c0102cb8:	ff d0                	call   *%eax
c0102cba:	83 c4 10             	add    $0x10,%esp
c0102cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102cc0:	83 ec 0c             	sub    $0xc,%esp
c0102cc3:	ff 75 f0             	pushl  -0x10(%ebp)
c0102cc6:	e8 17 fe ff ff       	call   c0102ae2 <__intr_restore>
c0102ccb:	83 c4 10             	add    $0x10,%esp
    return page;
c0102cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102cd1:	c9                   	leave  
c0102cd2:	c3                   	ret    

c0102cd3 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102cd3:	f3 0f 1e fb          	endbr32 
c0102cd7:	55                   	push   %ebp
c0102cd8:	89 e5                	mov    %esp,%ebp
c0102cda:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102cdd:	e8 d6 fd ff ff       	call   c0102ab8 <__intr_save>
c0102ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102ce5:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102cea:	8b 40 10             	mov    0x10(%eax),%eax
c0102ced:	83 ec 08             	sub    $0x8,%esp
c0102cf0:	ff 75 0c             	pushl  0xc(%ebp)
c0102cf3:	ff 75 08             	pushl  0x8(%ebp)
c0102cf6:	ff d0                	call   *%eax
c0102cf8:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102cfb:	83 ec 0c             	sub    $0xc,%esp
c0102cfe:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d01:	e8 dc fd ff ff       	call   c0102ae2 <__intr_restore>
c0102d06:	83 c4 10             	add    $0x10,%esp
}
c0102d09:	90                   	nop
c0102d0a:	c9                   	leave  
c0102d0b:	c3                   	ret    

c0102d0c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d0c:	f3 0f 1e fb          	endbr32 
c0102d10:	55                   	push   %ebp
c0102d11:	89 e5                	mov    %esp,%ebp
c0102d13:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d16:	e8 9d fd ff ff       	call   c0102ab8 <__intr_save>
c0102d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d1e:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d23:	8b 40 14             	mov    0x14(%eax),%eax
c0102d26:	ff d0                	call   *%eax
c0102d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d2b:	83 ec 0c             	sub    $0xc,%esp
c0102d2e:	ff 75 f4             	pushl  -0xc(%ebp)
c0102d31:	e8 ac fd ff ff       	call   c0102ae2 <__intr_restore>
c0102d36:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d3c:	c9                   	leave  
c0102d3d:	c3                   	ret    

c0102d3e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d3e:	f3 0f 1e fb          	endbr32 
c0102d42:	55                   	push   %ebp
c0102d43:	89 e5                	mov    %esp,%ebp
c0102d45:	57                   	push   %edi
c0102d46:	56                   	push   %esi
c0102d47:	53                   	push   %ebx
c0102d48:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d4b:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d52:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102d59:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102d60:	83 ec 0c             	sub    $0xc,%esp
c0102d63:	68 e7 63 10 c0       	push   $0xc01063e7
c0102d68:	e8 2e d5 ff ff       	call   c010029b <cprintf>
c0102d6d:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d70:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d77:	e9 f4 00 00 00       	jmp    c0102e70 <page_init+0x132>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d7c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d82:	89 d0                	mov    %edx,%eax
c0102d84:	c1 e0 02             	shl    $0x2,%eax
c0102d87:	01 d0                	add    %edx,%eax
c0102d89:	c1 e0 02             	shl    $0x2,%eax
c0102d8c:	01 c8                	add    %ecx,%eax
c0102d8e:	8b 50 08             	mov    0x8(%eax),%edx
c0102d91:	8b 40 04             	mov    0x4(%eax),%eax
c0102d94:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102d97:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102d9a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102da0:	89 d0                	mov    %edx,%eax
c0102da2:	c1 e0 02             	shl    $0x2,%eax
c0102da5:	01 d0                	add    %edx,%eax
c0102da7:	c1 e0 02             	shl    $0x2,%eax
c0102daa:	01 c8                	add    %ecx,%eax
c0102dac:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102daf:	8b 58 10             	mov    0x10(%eax),%ebx
c0102db2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102db5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102db8:	01 c8                	add    %ecx,%eax
c0102dba:	11 da                	adc    %ebx,%edx
c0102dbc:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102dbf:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102dc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dc8:	89 d0                	mov    %edx,%eax
c0102dca:	c1 e0 02             	shl    $0x2,%eax
c0102dcd:	01 d0                	add    %edx,%eax
c0102dcf:	c1 e0 02             	shl    $0x2,%eax
c0102dd2:	01 c8                	add    %ecx,%eax
c0102dd4:	83 c0 14             	add    $0x14,%eax
c0102dd7:	8b 00                	mov    (%eax),%eax
c0102dd9:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102ddc:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ddf:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102de2:	83 c0 ff             	add    $0xffffffff,%eax
c0102de5:	83 d2 ff             	adc    $0xffffffff,%edx
c0102de8:	89 c1                	mov    %eax,%ecx
c0102dea:	89 d3                	mov    %edx,%ebx
c0102dec:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102def:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102df2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102df5:	89 d0                	mov    %edx,%eax
c0102df7:	c1 e0 02             	shl    $0x2,%eax
c0102dfa:	01 d0                	add    %edx,%eax
c0102dfc:	c1 e0 02             	shl    $0x2,%eax
c0102dff:	03 45 80             	add    -0x80(%ebp),%eax
c0102e02:	8b 50 10             	mov    0x10(%eax),%edx
c0102e05:	8b 40 0c             	mov    0xc(%eax),%eax
c0102e08:	ff 75 84             	pushl  -0x7c(%ebp)
c0102e0b:	53                   	push   %ebx
c0102e0c:	51                   	push   %ecx
c0102e0d:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e10:	ff 75 a0             	pushl  -0x60(%ebp)
c0102e13:	52                   	push   %edx
c0102e14:	50                   	push   %eax
c0102e15:	68 f4 63 10 c0       	push   $0xc01063f4
c0102e1a:	e8 7c d4 ff ff       	call   c010029b <cprintf>
c0102e1f:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e22:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e25:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e28:	89 d0                	mov    %edx,%eax
c0102e2a:	c1 e0 02             	shl    $0x2,%eax
c0102e2d:	01 d0                	add    %edx,%eax
c0102e2f:	c1 e0 02             	shl    $0x2,%eax
c0102e32:	01 c8                	add    %ecx,%eax
c0102e34:	83 c0 14             	add    $0x14,%eax
c0102e37:	8b 00                	mov    (%eax),%eax
c0102e39:	83 f8 01             	cmp    $0x1,%eax
c0102e3c:	75 2e                	jne    c0102e6c <page_init+0x12e>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102e44:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102e47:	89 d0                	mov    %edx,%eax
c0102e49:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0102e4c:	73 1e                	jae    c0102e6c <page_init+0x12e>
c0102e4e:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0102e53:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e58:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0102e5b:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0102e5e:	72 0c                	jb     c0102e6c <page_init+0x12e>
                maxpa = end;
c0102e60:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e63:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102e69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e6c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e73:	8b 00                	mov    (%eax),%eax
c0102e75:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102e78:	0f 8c fe fe ff ff    	jl     c0102d7c <page_init+0x3e>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102e7e:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102e83:	b8 00 00 00 00       	mov    $0x0,%eax
c0102e88:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0102e8b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0102e8e:	73 0e                	jae    c0102e9e <page_init+0x160>
        maxpa = KMEMSIZE;
c0102e90:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102e97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ea1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ea4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102ea8:	c1 ea 0c             	shr    $0xc,%edx
c0102eab:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102eb0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102eb7:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0102ebc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102ebf:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ec2:	01 d0                	add    %edx,%eax
c0102ec4:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102ec7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102eca:	ba 00 00 00 00       	mov    $0x0,%edx
c0102ecf:	f7 75 c0             	divl   -0x40(%ebp)
c0102ed2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ed5:	29 d0                	sub    %edx,%eax
c0102ed7:	a3 18 cf 11 c0       	mov    %eax,0xc011cf18

    for (i = 0; i < npage; i ++) {
c0102edc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102ee3:	eb 30                	jmp    c0102f15 <page_init+0x1d7>
        SetPageReserved(pages + i);
c0102ee5:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102eeb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eee:	89 d0                	mov    %edx,%eax
c0102ef0:	c1 e0 02             	shl    $0x2,%eax
c0102ef3:	01 d0                	add    %edx,%eax
c0102ef5:	c1 e0 02             	shl    $0x2,%eax
c0102ef8:	01 c8                	add    %ecx,%eax
c0102efa:	83 c0 04             	add    $0x4,%eax
c0102efd:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102f04:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f07:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f0a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102f0d:	0f ab 10             	bts    %edx,(%eax)
}
c0102f10:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0102f11:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f15:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f18:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102f1d:	39 c2                	cmp    %eax,%edx
c0102f1f:	72 c4                	jb     c0102ee5 <page_init+0x1a7>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f21:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0102f27:	89 d0                	mov    %edx,%eax
c0102f29:	c1 e0 02             	shl    $0x2,%eax
c0102f2c:	01 d0                	add    %edx,%eax
c0102f2e:	c1 e0 02             	shl    $0x2,%eax
c0102f31:	89 c2                	mov    %eax,%edx
c0102f33:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102f38:	01 d0                	add    %edx,%eax
c0102f3a:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102f3d:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102f44:	77 17                	ja     c0102f5d <page_init+0x21f>
c0102f46:	ff 75 b8             	pushl  -0x48(%ebp)
c0102f49:	68 24 64 10 c0       	push   $0xc0106424
c0102f4e:	68 dc 00 00 00       	push   $0xdc
c0102f53:	68 48 64 10 c0       	push   $0xc0106448
c0102f58:	e8 b9 d4 ff ff       	call   c0100416 <__panic>
c0102f5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102f60:	05 00 00 00 40       	add    $0x40000000,%eax
c0102f65:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102f68:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f6f:	e9 53 01 00 00       	jmp    c01030c7 <page_init+0x389>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102f74:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f77:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f7a:	89 d0                	mov    %edx,%eax
c0102f7c:	c1 e0 02             	shl    $0x2,%eax
c0102f7f:	01 d0                	add    %edx,%eax
c0102f81:	c1 e0 02             	shl    $0x2,%eax
c0102f84:	01 c8                	add    %ecx,%eax
c0102f86:	8b 50 08             	mov    0x8(%eax),%edx
c0102f89:	8b 40 04             	mov    0x4(%eax),%eax
c0102f8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f8f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f92:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102f95:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f98:	89 d0                	mov    %edx,%eax
c0102f9a:	c1 e0 02             	shl    $0x2,%eax
c0102f9d:	01 d0                	add    %edx,%eax
c0102f9f:	c1 e0 02             	shl    $0x2,%eax
c0102fa2:	01 c8                	add    %ecx,%eax
c0102fa4:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102fa7:	8b 58 10             	mov    0x10(%eax),%ebx
c0102faa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fb0:	01 c8                	add    %ecx,%eax
c0102fb2:	11 da                	adc    %ebx,%edx
c0102fb4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102fb7:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102fba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102fbd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fc0:	89 d0                	mov    %edx,%eax
c0102fc2:	c1 e0 02             	shl    $0x2,%eax
c0102fc5:	01 d0                	add    %edx,%eax
c0102fc7:	c1 e0 02             	shl    $0x2,%eax
c0102fca:	01 c8                	add    %ecx,%eax
c0102fcc:	83 c0 14             	add    $0x14,%eax
c0102fcf:	8b 00                	mov    (%eax),%eax
c0102fd1:	83 f8 01             	cmp    $0x1,%eax
c0102fd4:	0f 85 e9 00 00 00    	jne    c01030c3 <page_init+0x385>
            if (begin < freemem) {
c0102fda:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102fdd:	ba 00 00 00 00       	mov    $0x0,%edx
c0102fe2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0102fe5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0102fe8:	19 d1                	sbb    %edx,%ecx
c0102fea:	73 0d                	jae    c0102ff9 <page_init+0x2bb>
                begin = freemem;
c0102fec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102fef:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ff2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102ff9:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102ffe:	b8 00 00 00 00       	mov    $0x0,%eax
c0103003:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103006:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103009:	73 0e                	jae    c0103019 <page_init+0x2db>
                end = KMEMSIZE;
c010300b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103012:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103019:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010301c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010301f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103022:	89 d0                	mov    %edx,%eax
c0103024:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103027:	0f 83 96 00 00 00    	jae    c01030c3 <page_init+0x385>
                begin = ROUNDUP(begin, PGSIZE);
c010302d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103034:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103037:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010303a:	01 d0                	add    %edx,%eax
c010303c:	83 e8 01             	sub    $0x1,%eax
c010303f:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103042:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103045:	ba 00 00 00 00       	mov    $0x0,%edx
c010304a:	f7 75 b0             	divl   -0x50(%ebp)
c010304d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103050:	29 d0                	sub    %edx,%eax
c0103052:	ba 00 00 00 00       	mov    $0x0,%edx
c0103057:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010305a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010305d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103060:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103063:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103066:	ba 00 00 00 00       	mov    $0x0,%edx
c010306b:	89 c3                	mov    %eax,%ebx
c010306d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103073:	89 de                	mov    %ebx,%esi
c0103075:	89 d0                	mov    %edx,%eax
c0103077:	83 e0 00             	and    $0x0,%eax
c010307a:	89 c7                	mov    %eax,%edi
c010307c:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010307f:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103082:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103085:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103088:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010308b:	89 d0                	mov    %edx,%eax
c010308d:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103090:	73 31                	jae    c01030c3 <page_init+0x385>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103092:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103095:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103098:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010309b:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010309e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01030a2:	c1 ea 0c             	shr    $0xc,%edx
c01030a5:	89 c3                	mov    %eax,%ebx
c01030a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030aa:	83 ec 0c             	sub    $0xc,%esp
c01030ad:	50                   	push   %eax
c01030ae:	e8 dd f8 ff ff       	call   c0102990 <pa2page>
c01030b3:	83 c4 10             	add    $0x10,%esp
c01030b6:	83 ec 08             	sub    $0x8,%esp
c01030b9:	53                   	push   %ebx
c01030ba:	50                   	push   %eax
c01030bb:	e8 ae fb ff ff       	call   c0102c6e <init_memmap>
c01030c0:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c01030c3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01030c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01030ca:	8b 00                	mov    (%eax),%eax
c01030cc:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030cf:	0f 8c 9f fe ff ff    	jl     c0102f74 <page_init+0x236>
                }
            }
        }
    }
}
c01030d5:	90                   	nop
c01030d6:	90                   	nop
c01030d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01030da:	5b                   	pop    %ebx
c01030db:	5e                   	pop    %esi
c01030dc:	5f                   	pop    %edi
c01030dd:	5d                   	pop    %ebp
c01030de:	c3                   	ret    

c01030df <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01030df:	f3 0f 1e fb          	endbr32 
c01030e3:	55                   	push   %ebp
c01030e4:	89 e5                	mov    %esp,%ebp
c01030e6:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01030e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030ec:	33 45 14             	xor    0x14(%ebp),%eax
c01030ef:	25 ff 0f 00 00       	and    $0xfff,%eax
c01030f4:	85 c0                	test   %eax,%eax
c01030f6:	74 19                	je     c0103111 <boot_map_segment+0x32>
c01030f8:	68 56 64 10 c0       	push   $0xc0106456
c01030fd:	68 6d 64 10 c0       	push   $0xc010646d
c0103102:	68 fa 00 00 00       	push   $0xfa
c0103107:	68 48 64 10 c0       	push   $0xc0106448
c010310c:	e8 05 d3 ff ff       	call   c0100416 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103111:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103118:	8b 45 0c             	mov    0xc(%ebp),%eax
c010311b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103120:	89 c2                	mov    %eax,%edx
c0103122:	8b 45 10             	mov    0x10(%ebp),%eax
c0103125:	01 c2                	add    %eax,%edx
c0103127:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010312a:	01 d0                	add    %edx,%eax
c010312c:	83 e8 01             	sub    $0x1,%eax
c010312f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103132:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103135:	ba 00 00 00 00       	mov    $0x0,%edx
c010313a:	f7 75 f0             	divl   -0x10(%ebp)
c010313d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103140:	29 d0                	sub    %edx,%eax
c0103142:	c1 e8 0c             	shr    $0xc,%eax
c0103145:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103148:	8b 45 0c             	mov    0xc(%ebp),%eax
c010314b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103151:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103156:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103159:	8b 45 14             	mov    0x14(%ebp),%eax
c010315c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103167:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010316a:	eb 57                	jmp    c01031c3 <boot_map_segment+0xe4>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010316c:	83 ec 04             	sub    $0x4,%esp
c010316f:	6a 01                	push   $0x1
c0103171:	ff 75 0c             	pushl  0xc(%ebp)
c0103174:	ff 75 08             	pushl  0x8(%ebp)
c0103177:	e8 5c 01 00 00       	call   c01032d8 <get_pte>
c010317c:	83 c4 10             	add    $0x10,%esp
c010317f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103182:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103186:	75 19                	jne    c01031a1 <boot_map_segment+0xc2>
c0103188:	68 82 64 10 c0       	push   $0xc0106482
c010318d:	68 6d 64 10 c0       	push   $0xc010646d
c0103192:	68 00 01 00 00       	push   $0x100
c0103197:	68 48 64 10 c0       	push   $0xc0106448
c010319c:	e8 75 d2 ff ff       	call   c0100416 <__panic>
        *ptep = pa | PTE_P | perm;
c01031a1:	8b 45 14             	mov    0x14(%ebp),%eax
c01031a4:	0b 45 18             	or     0x18(%ebp),%eax
c01031a7:	83 c8 01             	or     $0x1,%eax
c01031aa:	89 c2                	mov    %eax,%edx
c01031ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01031af:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01031b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01031b5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01031bc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01031c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031c7:	75 a3                	jne    c010316c <boot_map_segment+0x8d>
    }
}
c01031c9:	90                   	nop
c01031ca:	90                   	nop
c01031cb:	c9                   	leave  
c01031cc:	c3                   	ret    

c01031cd <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01031cd:	f3 0f 1e fb          	endbr32 
c01031d1:	55                   	push   %ebp
c01031d2:	89 e5                	mov    %esp,%ebp
c01031d4:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01031d7:	83 ec 0c             	sub    $0xc,%esp
c01031da:	6a 01                	push   $0x1
c01031dc:	e8 b0 fa ff ff       	call   c0102c91 <alloc_pages>
c01031e1:	83 c4 10             	add    $0x10,%esp
c01031e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01031e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031eb:	75 17                	jne    c0103204 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01031ed:	83 ec 04             	sub    $0x4,%esp
c01031f0:	68 8f 64 10 c0       	push   $0xc010648f
c01031f5:	68 0c 01 00 00       	push   $0x10c
c01031fa:	68 48 64 10 c0       	push   $0xc0106448
c01031ff:	e8 12 d2 ff ff       	call   c0100416 <__panic>
    }
    return page2kva(p);
c0103204:	83 ec 0c             	sub    $0xc,%esp
c0103207:	ff 75 f4             	pushl  -0xc(%ebp)
c010320a:	e8 c8 f7 ff ff       	call   c01029d7 <page2kva>
c010320f:	83 c4 10             	add    $0x10,%esp
}
c0103212:	c9                   	leave  
c0103213:	c3                   	ret    

c0103214 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103214:	f3 0f 1e fb          	endbr32 
c0103218:	55                   	push   %ebp
c0103219:	89 e5                	mov    %esp,%ebp
c010321b:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010321e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103223:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103226:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010322d:	77 17                	ja     c0103246 <pmm_init+0x32>
c010322f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103232:	68 24 64 10 c0       	push   $0xc0106424
c0103237:	68 16 01 00 00       	push   $0x116
c010323c:	68 48 64 10 c0       	push   $0xc0106448
c0103241:	e8 d0 d1 ff ff       	call   c0100416 <__panic>
c0103246:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103249:	05 00 00 00 40       	add    $0x40000000,%eax
c010324e:	a3 14 cf 11 c0       	mov    %eax,0xc011cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103253:	e8 dd f9 ff ff       	call   c0102c35 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103258:	e8 e1 fa ff ff       	call   c0102d3e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010325d:	e8 a5 03 00 00       	call   c0103607 <check_alloc_page>

    check_pgdir();
c0103262:	e8 c7 03 00 00       	call   c010362e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103267:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010326c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010326f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103276:	77 17                	ja     c010328f <pmm_init+0x7b>
c0103278:	ff 75 f0             	pushl  -0x10(%ebp)
c010327b:	68 24 64 10 c0       	push   $0xc0106424
c0103280:	68 2c 01 00 00       	push   $0x12c
c0103285:	68 48 64 10 c0       	push   $0xc0106448
c010328a:	e8 87 d1 ff ff       	call   c0100416 <__panic>
c010328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103292:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103298:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010329d:	05 ac 0f 00 00       	add    $0xfac,%eax
c01032a2:	83 ca 03             	or     $0x3,%edx
c01032a5:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01032a7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032ac:	83 ec 0c             	sub    $0xc,%esp
c01032af:	6a 02                	push   $0x2
c01032b1:	6a 00                	push   $0x0
c01032b3:	68 00 00 00 38       	push   $0x38000000
c01032b8:	68 00 00 00 c0       	push   $0xc0000000
c01032bd:	50                   	push   %eax
c01032be:	e8 1c fe ff ff       	call   c01030df <boot_map_segment>
c01032c3:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01032c6:	e8 73 f8 ff ff       	call   c0102b3e <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01032cb:	e8 c8 08 00 00       	call   c0103b98 <check_boot_pgdir>

    print_pgdir();
c01032d0:	e8 ca 0c 00 00       	call   c0103f9f <print_pgdir>

}
c01032d5:	90                   	nop
c01032d6:	c9                   	leave  
c01032d7:	c3                   	ret    

c01032d8 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01032d8:	f3 0f 1e fb          	endbr32 
c01032dc:	55                   	push   %ebp
c01032dd:	89 e5                	mov    %esp,%ebp
c01032df:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01032e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01032e5:	c1 e8 16             	shr    $0x16,%eax
c01032e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01032ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01032f2:	01 d0                	add    %edx,%eax
c01032f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032fa:	8b 00                	mov    (%eax),%eax
c01032fc:	83 e0 01             	and    $0x1,%eax
c01032ff:	85 c0                	test   %eax,%eax
c0103301:	0f 85 9f 00 00 00    	jne    c01033a6 <get_pte+0xce>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0103307:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010330b:	74 16                	je     c0103323 <get_pte+0x4b>
c010330d:	83 ec 0c             	sub    $0xc,%esp
c0103310:	6a 01                	push   $0x1
c0103312:	e8 7a f9 ff ff       	call   c0102c91 <alloc_pages>
c0103317:	83 c4 10             	add    $0x10,%esp
c010331a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010331d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103321:	75 0a                	jne    c010332d <get_pte+0x55>
            return NULL;
c0103323:	b8 00 00 00 00       	mov    $0x0,%eax
c0103328:	e9 ca 00 00 00       	jmp    c01033f7 <get_pte+0x11f>
        }
        set_page_ref(page, 1);
c010332d:	83 ec 08             	sub    $0x8,%esp
c0103330:	6a 01                	push   $0x1
c0103332:	ff 75 f0             	pushl  -0x10(%ebp)
c0103335:	e8 42 f7 ff ff       	call   c0102a7c <set_page_ref>
c010333a:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c010333d:	83 ec 0c             	sub    $0xc,%esp
c0103340:	ff 75 f0             	pushl  -0x10(%ebp)
c0103343:	e8 35 f6 ff ff       	call   c010297d <page2pa>
c0103348:	83 c4 10             	add    $0x10,%esp
c010334b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010334e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103351:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103354:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103357:	c1 e8 0c             	shr    $0xc,%eax
c010335a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010335d:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103362:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103365:	72 17                	jb     c010337e <get_pte+0xa6>
c0103367:	ff 75 e8             	pushl  -0x18(%ebp)
c010336a:	68 80 63 10 c0       	push   $0xc0106380
c010336f:	68 72 01 00 00       	push   $0x172
c0103374:	68 48 64 10 c0       	push   $0xc0106448
c0103379:	e8 98 d0 ff ff       	call   c0100416 <__panic>
c010337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103381:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103386:	83 ec 04             	sub    $0x4,%esp
c0103389:	68 00 10 00 00       	push   $0x1000
c010338e:	6a 00                	push   $0x0
c0103390:	50                   	push   %eax
c0103391:	e8 e8 20 00 00       	call   c010547e <memset>
c0103396:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0103399:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010339c:	83 c8 07             	or     $0x7,%eax
c010339f:	89 c2                	mov    %eax,%edx
c01033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a4:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a9:	8b 00                	mov    (%eax),%eax
c01033ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01033b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01033b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033b6:	c1 e8 0c             	shr    $0xc,%eax
c01033b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01033bc:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01033c1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01033c4:	72 17                	jb     c01033dd <get_pte+0x105>
c01033c6:	ff 75 e0             	pushl  -0x20(%ebp)
c01033c9:	68 80 63 10 c0       	push   $0xc0106380
c01033ce:	68 75 01 00 00       	push   $0x175
c01033d3:	68 48 64 10 c0       	push   $0xc0106448
c01033d8:	e8 39 d0 ff ff       	call   c0100416 <__panic>
c01033dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033e0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01033e5:	89 c2                	mov    %eax,%edx
c01033e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ea:	c1 e8 0c             	shr    $0xc,%eax
c01033ed:	25 ff 03 00 00       	and    $0x3ff,%eax
c01033f2:	c1 e0 02             	shl    $0x2,%eax
c01033f5:	01 d0                	add    %edx,%eax
}
c01033f7:	c9                   	leave  
c01033f8:	c3                   	ret    

c01033f9 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01033f9:	f3 0f 1e fb          	endbr32 
c01033fd:	55                   	push   %ebp
c01033fe:	89 e5                	mov    %esp,%ebp
c0103400:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103403:	83 ec 04             	sub    $0x4,%esp
c0103406:	6a 00                	push   $0x0
c0103408:	ff 75 0c             	pushl  0xc(%ebp)
c010340b:	ff 75 08             	pushl  0x8(%ebp)
c010340e:	e8 c5 fe ff ff       	call   c01032d8 <get_pte>
c0103413:	83 c4 10             	add    $0x10,%esp
c0103416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010341d:	74 08                	je     c0103427 <get_page+0x2e>
        *ptep_store = ptep;
c010341f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103422:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103425:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010342b:	74 1f                	je     c010344c <get_page+0x53>
c010342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103430:	8b 00                	mov    (%eax),%eax
c0103432:	83 e0 01             	and    $0x1,%eax
c0103435:	85 c0                	test   %eax,%eax
c0103437:	74 13                	je     c010344c <get_page+0x53>
        return pte2page(*ptep);
c0103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010343c:	8b 00                	mov    (%eax),%eax
c010343e:	83 ec 0c             	sub    $0xc,%esp
c0103441:	50                   	push   %eax
c0103442:	e8 d5 f5 ff ff       	call   c0102a1c <pte2page>
c0103447:	83 c4 10             	add    $0x10,%esp
c010344a:	eb 05                	jmp    c0103451 <get_page+0x58>
    }
    return NULL;
c010344c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103451:	c9                   	leave  
c0103452:	c3                   	ret    

c0103453 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103453:	55                   	push   %ebp
c0103454:	89 e5                	mov    %esp,%ebp
c0103456:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0103459:	8b 45 10             	mov    0x10(%ebp),%eax
c010345c:	8b 00                	mov    (%eax),%eax
c010345e:	83 e0 01             	and    $0x1,%eax
c0103461:	85 c0                	test   %eax,%eax
c0103463:	74 50                	je     c01034b5 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c0103465:	8b 45 10             	mov    0x10(%ebp),%eax
c0103468:	8b 00                	mov    (%eax),%eax
c010346a:	83 ec 0c             	sub    $0xc,%esp
c010346d:	50                   	push   %eax
c010346e:	e8 a9 f5 ff ff       	call   c0102a1c <pte2page>
c0103473:	83 c4 10             	add    $0x10,%esp
c0103476:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0103479:	83 ec 0c             	sub    $0xc,%esp
c010347c:	ff 75 f4             	pushl  -0xc(%ebp)
c010347f:	e8 1d f6 ff ff       	call   c0102aa1 <page_ref_dec>
c0103484:	83 c4 10             	add    $0x10,%esp
c0103487:	85 c0                	test   %eax,%eax
c0103489:	75 10                	jne    c010349b <page_remove_pte+0x48>
            free_page(page);
c010348b:	83 ec 08             	sub    $0x8,%esp
c010348e:	6a 01                	push   $0x1
c0103490:	ff 75 f4             	pushl  -0xc(%ebp)
c0103493:	e8 3b f8 ff ff       	call   c0102cd3 <free_pages>
c0103498:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c010349b:	8b 45 10             	mov    0x10(%ebp),%eax
c010349e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01034a4:	83 ec 08             	sub    $0x8,%esp
c01034a7:	ff 75 0c             	pushl  0xc(%ebp)
c01034aa:	ff 75 08             	pushl  0x8(%ebp)
c01034ad:	e8 00 01 00 00       	call   c01035b2 <tlb_invalidate>
c01034b2:	83 c4 10             	add    $0x10,%esp
    }
}
c01034b5:	90                   	nop
c01034b6:	c9                   	leave  
c01034b7:	c3                   	ret    

c01034b8 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01034b8:	f3 0f 1e fb          	endbr32 
c01034bc:	55                   	push   %ebp
c01034bd:	89 e5                	mov    %esp,%ebp
c01034bf:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01034c2:	83 ec 04             	sub    $0x4,%esp
c01034c5:	6a 00                	push   $0x0
c01034c7:	ff 75 0c             	pushl  0xc(%ebp)
c01034ca:	ff 75 08             	pushl  0x8(%ebp)
c01034cd:	e8 06 fe ff ff       	call   c01032d8 <get_pte>
c01034d2:	83 c4 10             	add    $0x10,%esp
c01034d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01034d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034dc:	74 14                	je     c01034f2 <page_remove+0x3a>
        page_remove_pte(pgdir, la, ptep);
c01034de:	83 ec 04             	sub    $0x4,%esp
c01034e1:	ff 75 f4             	pushl  -0xc(%ebp)
c01034e4:	ff 75 0c             	pushl  0xc(%ebp)
c01034e7:	ff 75 08             	pushl  0x8(%ebp)
c01034ea:	e8 64 ff ff ff       	call   c0103453 <page_remove_pte>
c01034ef:	83 c4 10             	add    $0x10,%esp
    }
}
c01034f2:	90                   	nop
c01034f3:	c9                   	leave  
c01034f4:	c3                   	ret    

c01034f5 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01034f5:	f3 0f 1e fb          	endbr32 
c01034f9:	55                   	push   %ebp
c01034fa:	89 e5                	mov    %esp,%ebp
c01034fc:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01034ff:	83 ec 04             	sub    $0x4,%esp
c0103502:	6a 01                	push   $0x1
c0103504:	ff 75 10             	pushl  0x10(%ebp)
c0103507:	ff 75 08             	pushl  0x8(%ebp)
c010350a:	e8 c9 fd ff ff       	call   c01032d8 <get_pte>
c010350f:	83 c4 10             	add    $0x10,%esp
c0103512:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103519:	75 0a                	jne    c0103525 <page_insert+0x30>
        return -E_NO_MEM;
c010351b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103520:	e9 8b 00 00 00       	jmp    c01035b0 <page_insert+0xbb>
    }
    page_ref_inc(page);
c0103525:	83 ec 0c             	sub    $0xc,%esp
c0103528:	ff 75 0c             	pushl  0xc(%ebp)
c010352b:	e8 5a f5 ff ff       	call   c0102a8a <page_ref_inc>
c0103530:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c0103533:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103536:	8b 00                	mov    (%eax),%eax
c0103538:	83 e0 01             	and    $0x1,%eax
c010353b:	85 c0                	test   %eax,%eax
c010353d:	74 40                	je     c010357f <page_insert+0x8a>
        struct Page *p = pte2page(*ptep);
c010353f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103542:	8b 00                	mov    (%eax),%eax
c0103544:	83 ec 0c             	sub    $0xc,%esp
c0103547:	50                   	push   %eax
c0103548:	e8 cf f4 ff ff       	call   c0102a1c <pte2page>
c010354d:	83 c4 10             	add    $0x10,%esp
c0103550:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103553:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103556:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103559:	75 10                	jne    c010356b <page_insert+0x76>
            page_ref_dec(page);
c010355b:	83 ec 0c             	sub    $0xc,%esp
c010355e:	ff 75 0c             	pushl  0xc(%ebp)
c0103561:	e8 3b f5 ff ff       	call   c0102aa1 <page_ref_dec>
c0103566:	83 c4 10             	add    $0x10,%esp
c0103569:	eb 14                	jmp    c010357f <page_insert+0x8a>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010356b:	83 ec 04             	sub    $0x4,%esp
c010356e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103571:	ff 75 10             	pushl  0x10(%ebp)
c0103574:	ff 75 08             	pushl  0x8(%ebp)
c0103577:	e8 d7 fe ff ff       	call   c0103453 <page_remove_pte>
c010357c:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010357f:	83 ec 0c             	sub    $0xc,%esp
c0103582:	ff 75 0c             	pushl  0xc(%ebp)
c0103585:	e8 f3 f3 ff ff       	call   c010297d <page2pa>
c010358a:	83 c4 10             	add    $0x10,%esp
c010358d:	0b 45 14             	or     0x14(%ebp),%eax
c0103590:	83 c8 01             	or     $0x1,%eax
c0103593:	89 c2                	mov    %eax,%edx
c0103595:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103598:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010359a:	83 ec 08             	sub    $0x8,%esp
c010359d:	ff 75 10             	pushl  0x10(%ebp)
c01035a0:	ff 75 08             	pushl  0x8(%ebp)
c01035a3:	e8 0a 00 00 00       	call   c01035b2 <tlb_invalidate>
c01035a8:	83 c4 10             	add    $0x10,%esp
    return 0;
c01035ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01035b0:	c9                   	leave  
c01035b1:	c3                   	ret    

c01035b2 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01035b2:	f3 0f 1e fb          	endbr32 
c01035b6:	55                   	push   %ebp
c01035b7:	89 e5                	mov    %esp,%ebp
c01035b9:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01035bc:	0f 20 d8             	mov    %cr3,%eax
c01035bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01035c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01035c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01035c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035cb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01035d2:	77 17                	ja     c01035eb <tlb_invalidate+0x39>
c01035d4:	ff 75 f4             	pushl  -0xc(%ebp)
c01035d7:	68 24 64 10 c0       	push   $0xc0106424
c01035dc:	68 d7 01 00 00       	push   $0x1d7
c01035e1:	68 48 64 10 c0       	push   $0xc0106448
c01035e6:	e8 2b ce ff ff       	call   c0100416 <__panic>
c01035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ee:	05 00 00 00 40       	add    $0x40000000,%eax
c01035f3:	39 d0                	cmp    %edx,%eax
c01035f5:	75 0d                	jne    c0103604 <tlb_invalidate+0x52>
        invlpg((void *)la);
c01035f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01035fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103600:	0f 01 38             	invlpg (%eax)
}
c0103603:	90                   	nop
    }
}
c0103604:	90                   	nop
c0103605:	c9                   	leave  
c0103606:	c3                   	ret    

c0103607 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103607:	f3 0f 1e fb          	endbr32 
c010360b:	55                   	push   %ebp
c010360c:	89 e5                	mov    %esp,%ebp
c010360e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0103611:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0103616:	8b 40 18             	mov    0x18(%eax),%eax
c0103619:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010361b:	83 ec 0c             	sub    $0xc,%esp
c010361e:	68 a8 64 10 c0       	push   $0xc01064a8
c0103623:	e8 73 cc ff ff       	call   c010029b <cprintf>
c0103628:	83 c4 10             	add    $0x10,%esp
}
c010362b:	90                   	nop
c010362c:	c9                   	leave  
c010362d:	c3                   	ret    

c010362e <check_pgdir>:

static void
check_pgdir(void) {
c010362e:	f3 0f 1e fb          	endbr32 
c0103632:	55                   	push   %ebp
c0103633:	89 e5                	mov    %esp,%ebp
c0103635:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103638:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c010363d:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103642:	76 19                	jbe    c010365d <check_pgdir+0x2f>
c0103644:	68 c7 64 10 c0       	push   $0xc01064c7
c0103649:	68 6d 64 10 c0       	push   $0xc010646d
c010364e:	68 e4 01 00 00       	push   $0x1e4
c0103653:	68 48 64 10 c0       	push   $0xc0106448
c0103658:	e8 b9 cd ff ff       	call   c0100416 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010365d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103662:	85 c0                	test   %eax,%eax
c0103664:	74 0e                	je     c0103674 <check_pgdir+0x46>
c0103666:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010366b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103670:	85 c0                	test   %eax,%eax
c0103672:	74 19                	je     c010368d <check_pgdir+0x5f>
c0103674:	68 e4 64 10 c0       	push   $0xc01064e4
c0103679:	68 6d 64 10 c0       	push   $0xc010646d
c010367e:	68 e5 01 00 00       	push   $0x1e5
c0103683:	68 48 64 10 c0       	push   $0xc0106448
c0103688:	e8 89 cd ff ff       	call   c0100416 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010368d:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103692:	83 ec 04             	sub    $0x4,%esp
c0103695:	6a 00                	push   $0x0
c0103697:	6a 00                	push   $0x0
c0103699:	50                   	push   %eax
c010369a:	e8 5a fd ff ff       	call   c01033f9 <get_page>
c010369f:	83 c4 10             	add    $0x10,%esp
c01036a2:	85 c0                	test   %eax,%eax
c01036a4:	74 19                	je     c01036bf <check_pgdir+0x91>
c01036a6:	68 1c 65 10 c0       	push   $0xc010651c
c01036ab:	68 6d 64 10 c0       	push   $0xc010646d
c01036b0:	68 e6 01 00 00       	push   $0x1e6
c01036b5:	68 48 64 10 c0       	push   $0xc0106448
c01036ba:	e8 57 cd ff ff       	call   c0100416 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01036bf:	83 ec 0c             	sub    $0xc,%esp
c01036c2:	6a 01                	push   $0x1
c01036c4:	e8 c8 f5 ff ff       	call   c0102c91 <alloc_pages>
c01036c9:	83 c4 10             	add    $0x10,%esp
c01036cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01036cf:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01036d4:	6a 00                	push   $0x0
c01036d6:	6a 00                	push   $0x0
c01036d8:	ff 75 f4             	pushl  -0xc(%ebp)
c01036db:	50                   	push   %eax
c01036dc:	e8 14 fe ff ff       	call   c01034f5 <page_insert>
c01036e1:	83 c4 10             	add    $0x10,%esp
c01036e4:	85 c0                	test   %eax,%eax
c01036e6:	74 19                	je     c0103701 <check_pgdir+0xd3>
c01036e8:	68 44 65 10 c0       	push   $0xc0106544
c01036ed:	68 6d 64 10 c0       	push   $0xc010646d
c01036f2:	68 ea 01 00 00       	push   $0x1ea
c01036f7:	68 48 64 10 c0       	push   $0xc0106448
c01036fc:	e8 15 cd ff ff       	call   c0100416 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103701:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103706:	83 ec 04             	sub    $0x4,%esp
c0103709:	6a 00                	push   $0x0
c010370b:	6a 00                	push   $0x0
c010370d:	50                   	push   %eax
c010370e:	e8 c5 fb ff ff       	call   c01032d8 <get_pte>
c0103713:	83 c4 10             	add    $0x10,%esp
c0103716:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010371d:	75 19                	jne    c0103738 <check_pgdir+0x10a>
c010371f:	68 70 65 10 c0       	push   $0xc0106570
c0103724:	68 6d 64 10 c0       	push   $0xc010646d
c0103729:	68 ed 01 00 00       	push   $0x1ed
c010372e:	68 48 64 10 c0       	push   $0xc0106448
c0103733:	e8 de cc ff ff       	call   c0100416 <__panic>
    assert(pte2page(*ptep) == p1);
c0103738:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010373b:	8b 00                	mov    (%eax),%eax
c010373d:	83 ec 0c             	sub    $0xc,%esp
c0103740:	50                   	push   %eax
c0103741:	e8 d6 f2 ff ff       	call   c0102a1c <pte2page>
c0103746:	83 c4 10             	add    $0x10,%esp
c0103749:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010374c:	74 19                	je     c0103767 <check_pgdir+0x139>
c010374e:	68 9d 65 10 c0       	push   $0xc010659d
c0103753:	68 6d 64 10 c0       	push   $0xc010646d
c0103758:	68 ee 01 00 00       	push   $0x1ee
c010375d:	68 48 64 10 c0       	push   $0xc0106448
c0103762:	e8 af cc ff ff       	call   c0100416 <__panic>
    assert(page_ref(p1) == 1);
c0103767:	83 ec 0c             	sub    $0xc,%esp
c010376a:	ff 75 f4             	pushl  -0xc(%ebp)
c010376d:	e8 00 f3 ff ff       	call   c0102a72 <page_ref>
c0103772:	83 c4 10             	add    $0x10,%esp
c0103775:	83 f8 01             	cmp    $0x1,%eax
c0103778:	74 19                	je     c0103793 <check_pgdir+0x165>
c010377a:	68 b3 65 10 c0       	push   $0xc01065b3
c010377f:	68 6d 64 10 c0       	push   $0xc010646d
c0103784:	68 ef 01 00 00       	push   $0x1ef
c0103789:	68 48 64 10 c0       	push   $0xc0106448
c010378e:	e8 83 cc ff ff       	call   c0100416 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103793:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103798:	8b 00                	mov    (%eax),%eax
c010379a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010379f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037a5:	c1 e8 0c             	shr    $0xc,%eax
c01037a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037ab:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01037b0:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01037b3:	72 17                	jb     c01037cc <check_pgdir+0x19e>
c01037b5:	ff 75 ec             	pushl  -0x14(%ebp)
c01037b8:	68 80 63 10 c0       	push   $0xc0106380
c01037bd:	68 f1 01 00 00       	push   $0x1f1
c01037c2:	68 48 64 10 c0       	push   $0xc0106448
c01037c7:	e8 4a cc ff ff       	call   c0100416 <__panic>
c01037cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037cf:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037d4:	83 c0 04             	add    $0x4,%eax
c01037d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037da:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01037df:	83 ec 04             	sub    $0x4,%esp
c01037e2:	6a 00                	push   $0x0
c01037e4:	68 00 10 00 00       	push   $0x1000
c01037e9:	50                   	push   %eax
c01037ea:	e8 e9 fa ff ff       	call   c01032d8 <get_pte>
c01037ef:	83 c4 10             	add    $0x10,%esp
c01037f2:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01037f5:	74 19                	je     c0103810 <check_pgdir+0x1e2>
c01037f7:	68 c8 65 10 c0       	push   $0xc01065c8
c01037fc:	68 6d 64 10 c0       	push   $0xc010646d
c0103801:	68 f2 01 00 00       	push   $0x1f2
c0103806:	68 48 64 10 c0       	push   $0xc0106448
c010380b:	e8 06 cc ff ff       	call   c0100416 <__panic>

    p2 = alloc_page();
c0103810:	83 ec 0c             	sub    $0xc,%esp
c0103813:	6a 01                	push   $0x1
c0103815:	e8 77 f4 ff ff       	call   c0102c91 <alloc_pages>
c010381a:	83 c4 10             	add    $0x10,%esp
c010381d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103820:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103825:	6a 06                	push   $0x6
c0103827:	68 00 10 00 00       	push   $0x1000
c010382c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010382f:	50                   	push   %eax
c0103830:	e8 c0 fc ff ff       	call   c01034f5 <page_insert>
c0103835:	83 c4 10             	add    $0x10,%esp
c0103838:	85 c0                	test   %eax,%eax
c010383a:	74 19                	je     c0103855 <check_pgdir+0x227>
c010383c:	68 f0 65 10 c0       	push   $0xc01065f0
c0103841:	68 6d 64 10 c0       	push   $0xc010646d
c0103846:	68 f5 01 00 00       	push   $0x1f5
c010384b:	68 48 64 10 c0       	push   $0xc0106448
c0103850:	e8 c1 cb ff ff       	call   c0100416 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103855:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010385a:	83 ec 04             	sub    $0x4,%esp
c010385d:	6a 00                	push   $0x0
c010385f:	68 00 10 00 00       	push   $0x1000
c0103864:	50                   	push   %eax
c0103865:	e8 6e fa ff ff       	call   c01032d8 <get_pte>
c010386a:	83 c4 10             	add    $0x10,%esp
c010386d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103874:	75 19                	jne    c010388f <check_pgdir+0x261>
c0103876:	68 28 66 10 c0       	push   $0xc0106628
c010387b:	68 6d 64 10 c0       	push   $0xc010646d
c0103880:	68 f6 01 00 00       	push   $0x1f6
c0103885:	68 48 64 10 c0       	push   $0xc0106448
c010388a:	e8 87 cb ff ff       	call   c0100416 <__panic>
    assert(*ptep & PTE_U);
c010388f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103892:	8b 00                	mov    (%eax),%eax
c0103894:	83 e0 04             	and    $0x4,%eax
c0103897:	85 c0                	test   %eax,%eax
c0103899:	75 19                	jne    c01038b4 <check_pgdir+0x286>
c010389b:	68 58 66 10 c0       	push   $0xc0106658
c01038a0:	68 6d 64 10 c0       	push   $0xc010646d
c01038a5:	68 f7 01 00 00       	push   $0x1f7
c01038aa:	68 48 64 10 c0       	push   $0xc0106448
c01038af:	e8 62 cb ff ff       	call   c0100416 <__panic>
    assert(*ptep & PTE_W);
c01038b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038b7:	8b 00                	mov    (%eax),%eax
c01038b9:	83 e0 02             	and    $0x2,%eax
c01038bc:	85 c0                	test   %eax,%eax
c01038be:	75 19                	jne    c01038d9 <check_pgdir+0x2ab>
c01038c0:	68 66 66 10 c0       	push   $0xc0106666
c01038c5:	68 6d 64 10 c0       	push   $0xc010646d
c01038ca:	68 f8 01 00 00       	push   $0x1f8
c01038cf:	68 48 64 10 c0       	push   $0xc0106448
c01038d4:	e8 3d cb ff ff       	call   c0100416 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01038d9:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01038de:	8b 00                	mov    (%eax),%eax
c01038e0:	83 e0 04             	and    $0x4,%eax
c01038e3:	85 c0                	test   %eax,%eax
c01038e5:	75 19                	jne    c0103900 <check_pgdir+0x2d2>
c01038e7:	68 74 66 10 c0       	push   $0xc0106674
c01038ec:	68 6d 64 10 c0       	push   $0xc010646d
c01038f1:	68 f9 01 00 00       	push   $0x1f9
c01038f6:	68 48 64 10 c0       	push   $0xc0106448
c01038fb:	e8 16 cb ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 1);
c0103900:	83 ec 0c             	sub    $0xc,%esp
c0103903:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103906:	e8 67 f1 ff ff       	call   c0102a72 <page_ref>
c010390b:	83 c4 10             	add    $0x10,%esp
c010390e:	83 f8 01             	cmp    $0x1,%eax
c0103911:	74 19                	je     c010392c <check_pgdir+0x2fe>
c0103913:	68 8a 66 10 c0       	push   $0xc010668a
c0103918:	68 6d 64 10 c0       	push   $0xc010646d
c010391d:	68 fa 01 00 00       	push   $0x1fa
c0103922:	68 48 64 10 c0       	push   $0xc0106448
c0103927:	e8 ea ca ff ff       	call   c0100416 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010392c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103931:	6a 00                	push   $0x0
c0103933:	68 00 10 00 00       	push   $0x1000
c0103938:	ff 75 f4             	pushl  -0xc(%ebp)
c010393b:	50                   	push   %eax
c010393c:	e8 b4 fb ff ff       	call   c01034f5 <page_insert>
c0103941:	83 c4 10             	add    $0x10,%esp
c0103944:	85 c0                	test   %eax,%eax
c0103946:	74 19                	je     c0103961 <check_pgdir+0x333>
c0103948:	68 9c 66 10 c0       	push   $0xc010669c
c010394d:	68 6d 64 10 c0       	push   $0xc010646d
c0103952:	68 fc 01 00 00       	push   $0x1fc
c0103957:	68 48 64 10 c0       	push   $0xc0106448
c010395c:	e8 b5 ca ff ff       	call   c0100416 <__panic>
    assert(page_ref(p1) == 2);
c0103961:	83 ec 0c             	sub    $0xc,%esp
c0103964:	ff 75 f4             	pushl  -0xc(%ebp)
c0103967:	e8 06 f1 ff ff       	call   c0102a72 <page_ref>
c010396c:	83 c4 10             	add    $0x10,%esp
c010396f:	83 f8 02             	cmp    $0x2,%eax
c0103972:	74 19                	je     c010398d <check_pgdir+0x35f>
c0103974:	68 c8 66 10 c0       	push   $0xc01066c8
c0103979:	68 6d 64 10 c0       	push   $0xc010646d
c010397e:	68 fd 01 00 00       	push   $0x1fd
c0103983:	68 48 64 10 c0       	push   $0xc0106448
c0103988:	e8 89 ca ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 0);
c010398d:	83 ec 0c             	sub    $0xc,%esp
c0103990:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103993:	e8 da f0 ff ff       	call   c0102a72 <page_ref>
c0103998:	83 c4 10             	add    $0x10,%esp
c010399b:	85 c0                	test   %eax,%eax
c010399d:	74 19                	je     c01039b8 <check_pgdir+0x38a>
c010399f:	68 da 66 10 c0       	push   $0xc01066da
c01039a4:	68 6d 64 10 c0       	push   $0xc010646d
c01039a9:	68 fe 01 00 00       	push   $0x1fe
c01039ae:	68 48 64 10 c0       	push   $0xc0106448
c01039b3:	e8 5e ca ff ff       	call   c0100416 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01039b8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01039bd:	83 ec 04             	sub    $0x4,%esp
c01039c0:	6a 00                	push   $0x0
c01039c2:	68 00 10 00 00       	push   $0x1000
c01039c7:	50                   	push   %eax
c01039c8:	e8 0b f9 ff ff       	call   c01032d8 <get_pte>
c01039cd:	83 c4 10             	add    $0x10,%esp
c01039d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039d7:	75 19                	jne    c01039f2 <check_pgdir+0x3c4>
c01039d9:	68 28 66 10 c0       	push   $0xc0106628
c01039de:	68 6d 64 10 c0       	push   $0xc010646d
c01039e3:	68 ff 01 00 00       	push   $0x1ff
c01039e8:	68 48 64 10 c0       	push   $0xc0106448
c01039ed:	e8 24 ca ff ff       	call   c0100416 <__panic>
    assert(pte2page(*ptep) == p1);
c01039f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039f5:	8b 00                	mov    (%eax),%eax
c01039f7:	83 ec 0c             	sub    $0xc,%esp
c01039fa:	50                   	push   %eax
c01039fb:	e8 1c f0 ff ff       	call   c0102a1c <pte2page>
c0103a00:	83 c4 10             	add    $0x10,%esp
c0103a03:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a06:	74 19                	je     c0103a21 <check_pgdir+0x3f3>
c0103a08:	68 9d 65 10 c0       	push   $0xc010659d
c0103a0d:	68 6d 64 10 c0       	push   $0xc010646d
c0103a12:	68 00 02 00 00       	push   $0x200
c0103a17:	68 48 64 10 c0       	push   $0xc0106448
c0103a1c:	e8 f5 c9 ff ff       	call   c0100416 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a24:	8b 00                	mov    (%eax),%eax
c0103a26:	83 e0 04             	and    $0x4,%eax
c0103a29:	85 c0                	test   %eax,%eax
c0103a2b:	74 19                	je     c0103a46 <check_pgdir+0x418>
c0103a2d:	68 ec 66 10 c0       	push   $0xc01066ec
c0103a32:	68 6d 64 10 c0       	push   $0xc010646d
c0103a37:	68 01 02 00 00       	push   $0x201
c0103a3c:	68 48 64 10 c0       	push   $0xc0106448
c0103a41:	e8 d0 c9 ff ff       	call   c0100416 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103a46:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a4b:	83 ec 08             	sub    $0x8,%esp
c0103a4e:	6a 00                	push   $0x0
c0103a50:	50                   	push   %eax
c0103a51:	e8 62 fa ff ff       	call   c01034b8 <page_remove>
c0103a56:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0103a59:	83 ec 0c             	sub    $0xc,%esp
c0103a5c:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a5f:	e8 0e f0 ff ff       	call   c0102a72 <page_ref>
c0103a64:	83 c4 10             	add    $0x10,%esp
c0103a67:	83 f8 01             	cmp    $0x1,%eax
c0103a6a:	74 19                	je     c0103a85 <check_pgdir+0x457>
c0103a6c:	68 b3 65 10 c0       	push   $0xc01065b3
c0103a71:	68 6d 64 10 c0       	push   $0xc010646d
c0103a76:	68 04 02 00 00       	push   $0x204
c0103a7b:	68 48 64 10 c0       	push   $0xc0106448
c0103a80:	e8 91 c9 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 0);
c0103a85:	83 ec 0c             	sub    $0xc,%esp
c0103a88:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a8b:	e8 e2 ef ff ff       	call   c0102a72 <page_ref>
c0103a90:	83 c4 10             	add    $0x10,%esp
c0103a93:	85 c0                	test   %eax,%eax
c0103a95:	74 19                	je     c0103ab0 <check_pgdir+0x482>
c0103a97:	68 da 66 10 c0       	push   $0xc01066da
c0103a9c:	68 6d 64 10 c0       	push   $0xc010646d
c0103aa1:	68 05 02 00 00       	push   $0x205
c0103aa6:	68 48 64 10 c0       	push   $0xc0106448
c0103aab:	e8 66 c9 ff ff       	call   c0100416 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103ab0:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ab5:	83 ec 08             	sub    $0x8,%esp
c0103ab8:	68 00 10 00 00       	push   $0x1000
c0103abd:	50                   	push   %eax
c0103abe:	e8 f5 f9 ff ff       	call   c01034b8 <page_remove>
c0103ac3:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103ac6:	83 ec 0c             	sub    $0xc,%esp
c0103ac9:	ff 75 f4             	pushl  -0xc(%ebp)
c0103acc:	e8 a1 ef ff ff       	call   c0102a72 <page_ref>
c0103ad1:	83 c4 10             	add    $0x10,%esp
c0103ad4:	85 c0                	test   %eax,%eax
c0103ad6:	74 19                	je     c0103af1 <check_pgdir+0x4c3>
c0103ad8:	68 01 67 10 c0       	push   $0xc0106701
c0103add:	68 6d 64 10 c0       	push   $0xc010646d
c0103ae2:	68 08 02 00 00       	push   $0x208
c0103ae7:	68 48 64 10 c0       	push   $0xc0106448
c0103aec:	e8 25 c9 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p2) == 0);
c0103af1:	83 ec 0c             	sub    $0xc,%esp
c0103af4:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103af7:	e8 76 ef ff ff       	call   c0102a72 <page_ref>
c0103afc:	83 c4 10             	add    $0x10,%esp
c0103aff:	85 c0                	test   %eax,%eax
c0103b01:	74 19                	je     c0103b1c <check_pgdir+0x4ee>
c0103b03:	68 da 66 10 c0       	push   $0xc01066da
c0103b08:	68 6d 64 10 c0       	push   $0xc010646d
c0103b0d:	68 09 02 00 00       	push   $0x209
c0103b12:	68 48 64 10 c0       	push   $0xc0106448
c0103b17:	e8 fa c8 ff ff       	call   c0100416 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103b1c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b21:	8b 00                	mov    (%eax),%eax
c0103b23:	83 ec 0c             	sub    $0xc,%esp
c0103b26:	50                   	push   %eax
c0103b27:	e8 2a ef ff ff       	call   c0102a56 <pde2page>
c0103b2c:	83 c4 10             	add    $0x10,%esp
c0103b2f:	83 ec 0c             	sub    $0xc,%esp
c0103b32:	50                   	push   %eax
c0103b33:	e8 3a ef ff ff       	call   c0102a72 <page_ref>
c0103b38:	83 c4 10             	add    $0x10,%esp
c0103b3b:	83 f8 01             	cmp    $0x1,%eax
c0103b3e:	74 19                	je     c0103b59 <check_pgdir+0x52b>
c0103b40:	68 14 67 10 c0       	push   $0xc0106714
c0103b45:	68 6d 64 10 c0       	push   $0xc010646d
c0103b4a:	68 0b 02 00 00       	push   $0x20b
c0103b4f:	68 48 64 10 c0       	push   $0xc0106448
c0103b54:	e8 bd c8 ff ff       	call   c0100416 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103b59:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b5e:	8b 00                	mov    (%eax),%eax
c0103b60:	83 ec 0c             	sub    $0xc,%esp
c0103b63:	50                   	push   %eax
c0103b64:	e8 ed ee ff ff       	call   c0102a56 <pde2page>
c0103b69:	83 c4 10             	add    $0x10,%esp
c0103b6c:	83 ec 08             	sub    $0x8,%esp
c0103b6f:	6a 01                	push   $0x1
c0103b71:	50                   	push   %eax
c0103b72:	e8 5c f1 ff ff       	call   c0102cd3 <free_pages>
c0103b77:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103b7a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103b85:	83 ec 0c             	sub    $0xc,%esp
c0103b88:	68 3b 67 10 c0       	push   $0xc010673b
c0103b8d:	e8 09 c7 ff ff       	call   c010029b <cprintf>
c0103b92:	83 c4 10             	add    $0x10,%esp
}
c0103b95:	90                   	nop
c0103b96:	c9                   	leave  
c0103b97:	c3                   	ret    

c0103b98 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103b98:	f3 0f 1e fb          	endbr32 
c0103b9c:	55                   	push   %ebp
c0103b9d:	89 e5                	mov    %esp,%ebp
c0103b9f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103ba2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ba9:	e9 a3 00 00 00       	jmp    c0103c51 <check_boot_pgdir+0xb9>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bb7:	c1 e8 0c             	shr    $0xc,%eax
c0103bba:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103bbd:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103bc2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103bc5:	72 17                	jb     c0103bde <check_boot_pgdir+0x46>
c0103bc7:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103bca:	68 80 63 10 c0       	push   $0xc0106380
c0103bcf:	68 17 02 00 00       	push   $0x217
c0103bd4:	68 48 64 10 c0       	push   $0xc0106448
c0103bd9:	e8 38 c8 ff ff       	call   c0100416 <__panic>
c0103bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103be1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103be6:	89 c2                	mov    %eax,%edx
c0103be8:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103bed:	83 ec 04             	sub    $0x4,%esp
c0103bf0:	6a 00                	push   $0x0
c0103bf2:	52                   	push   %edx
c0103bf3:	50                   	push   %eax
c0103bf4:	e8 df f6 ff ff       	call   c01032d8 <get_pte>
c0103bf9:	83 c4 10             	add    $0x10,%esp
c0103bfc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103bff:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103c03:	75 19                	jne    c0103c1e <check_boot_pgdir+0x86>
c0103c05:	68 58 67 10 c0       	push   $0xc0106758
c0103c0a:	68 6d 64 10 c0       	push   $0xc010646d
c0103c0f:	68 17 02 00 00       	push   $0x217
c0103c14:	68 48 64 10 c0       	push   $0xc0106448
c0103c19:	e8 f8 c7 ff ff       	call   c0100416 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103c1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103c21:	8b 00                	mov    (%eax),%eax
c0103c23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c28:	89 c2                	mov    %eax,%edx
c0103c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c2d:	39 c2                	cmp    %eax,%edx
c0103c2f:	74 19                	je     c0103c4a <check_boot_pgdir+0xb2>
c0103c31:	68 95 67 10 c0       	push   $0xc0106795
c0103c36:	68 6d 64 10 c0       	push   $0xc010646d
c0103c3b:	68 18 02 00 00       	push   $0x218
c0103c40:	68 48 64 10 c0       	push   $0xc0106448
c0103c45:	e8 cc c7 ff ff       	call   c0100416 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103c4a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103c54:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103c59:	39 c2                	cmp    %eax,%edx
c0103c5b:	0f 82 4d ff ff ff    	jb     c0103bae <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103c61:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c66:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103c6b:	8b 00                	mov    (%eax),%eax
c0103c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c72:	89 c2                	mov    %eax,%edx
c0103c74:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c7c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103c83:	77 17                	ja     c0103c9c <check_boot_pgdir+0x104>
c0103c85:	ff 75 f0             	pushl  -0x10(%ebp)
c0103c88:	68 24 64 10 c0       	push   $0xc0106424
c0103c8d:	68 1b 02 00 00       	push   $0x21b
c0103c92:	68 48 64 10 c0       	push   $0xc0106448
c0103c97:	e8 7a c7 ff ff       	call   c0100416 <__panic>
c0103c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c9f:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ca4:	39 d0                	cmp    %edx,%eax
c0103ca6:	74 19                	je     c0103cc1 <check_boot_pgdir+0x129>
c0103ca8:	68 ac 67 10 c0       	push   $0xc01067ac
c0103cad:	68 6d 64 10 c0       	push   $0xc010646d
c0103cb2:	68 1b 02 00 00       	push   $0x21b
c0103cb7:	68 48 64 10 c0       	push   $0xc0106448
c0103cbc:	e8 55 c7 ff ff       	call   c0100416 <__panic>

    assert(boot_pgdir[0] == 0);
c0103cc1:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103cc6:	8b 00                	mov    (%eax),%eax
c0103cc8:	85 c0                	test   %eax,%eax
c0103cca:	74 19                	je     c0103ce5 <check_boot_pgdir+0x14d>
c0103ccc:	68 e0 67 10 c0       	push   $0xc01067e0
c0103cd1:	68 6d 64 10 c0       	push   $0xc010646d
c0103cd6:	68 1d 02 00 00       	push   $0x21d
c0103cdb:	68 48 64 10 c0       	push   $0xc0106448
c0103ce0:	e8 31 c7 ff ff       	call   c0100416 <__panic>

    struct Page *p;
    p = alloc_page();
c0103ce5:	83 ec 0c             	sub    $0xc,%esp
c0103ce8:	6a 01                	push   $0x1
c0103cea:	e8 a2 ef ff ff       	call   c0102c91 <alloc_pages>
c0103cef:	83 c4 10             	add    $0x10,%esp
c0103cf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103cf5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103cfa:	6a 02                	push   $0x2
c0103cfc:	68 00 01 00 00       	push   $0x100
c0103d01:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d04:	50                   	push   %eax
c0103d05:	e8 eb f7 ff ff       	call   c01034f5 <page_insert>
c0103d0a:	83 c4 10             	add    $0x10,%esp
c0103d0d:	85 c0                	test   %eax,%eax
c0103d0f:	74 19                	je     c0103d2a <check_boot_pgdir+0x192>
c0103d11:	68 f4 67 10 c0       	push   $0xc01067f4
c0103d16:	68 6d 64 10 c0       	push   $0xc010646d
c0103d1b:	68 21 02 00 00       	push   $0x221
c0103d20:	68 48 64 10 c0       	push   $0xc0106448
c0103d25:	e8 ec c6 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p) == 1);
c0103d2a:	83 ec 0c             	sub    $0xc,%esp
c0103d2d:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d30:	e8 3d ed ff ff       	call   c0102a72 <page_ref>
c0103d35:	83 c4 10             	add    $0x10,%esp
c0103d38:	83 f8 01             	cmp    $0x1,%eax
c0103d3b:	74 19                	je     c0103d56 <check_boot_pgdir+0x1be>
c0103d3d:	68 22 68 10 c0       	push   $0xc0106822
c0103d42:	68 6d 64 10 c0       	push   $0xc010646d
c0103d47:	68 22 02 00 00       	push   $0x222
c0103d4c:	68 48 64 10 c0       	push   $0xc0106448
c0103d51:	e8 c0 c6 ff ff       	call   c0100416 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103d56:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d5b:	6a 02                	push   $0x2
c0103d5d:	68 00 11 00 00       	push   $0x1100
c0103d62:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d65:	50                   	push   %eax
c0103d66:	e8 8a f7 ff ff       	call   c01034f5 <page_insert>
c0103d6b:	83 c4 10             	add    $0x10,%esp
c0103d6e:	85 c0                	test   %eax,%eax
c0103d70:	74 19                	je     c0103d8b <check_boot_pgdir+0x1f3>
c0103d72:	68 34 68 10 c0       	push   $0xc0106834
c0103d77:	68 6d 64 10 c0       	push   $0xc010646d
c0103d7c:	68 23 02 00 00       	push   $0x223
c0103d81:	68 48 64 10 c0       	push   $0xc0106448
c0103d86:	e8 8b c6 ff ff       	call   c0100416 <__panic>
    assert(page_ref(p) == 2);
c0103d8b:	83 ec 0c             	sub    $0xc,%esp
c0103d8e:	ff 75 ec             	pushl  -0x14(%ebp)
c0103d91:	e8 dc ec ff ff       	call   c0102a72 <page_ref>
c0103d96:	83 c4 10             	add    $0x10,%esp
c0103d99:	83 f8 02             	cmp    $0x2,%eax
c0103d9c:	74 19                	je     c0103db7 <check_boot_pgdir+0x21f>
c0103d9e:	68 6b 68 10 c0       	push   $0xc010686b
c0103da3:	68 6d 64 10 c0       	push   $0xc010646d
c0103da8:	68 24 02 00 00       	push   $0x224
c0103dad:	68 48 64 10 c0       	push   $0xc0106448
c0103db2:	e8 5f c6 ff ff       	call   c0100416 <__panic>

    const char *str = "ucore: Hello world!!";
c0103db7:	c7 45 e8 7c 68 10 c0 	movl   $0xc010687c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103dbe:	83 ec 08             	sub    $0x8,%esp
c0103dc1:	ff 75 e8             	pushl  -0x18(%ebp)
c0103dc4:	68 00 01 00 00       	push   $0x100
c0103dc9:	e8 bd 13 00 00       	call   c010518b <strcpy>
c0103dce:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103dd1:	83 ec 08             	sub    $0x8,%esp
c0103dd4:	68 00 11 00 00       	push   $0x1100
c0103dd9:	68 00 01 00 00       	push   $0x100
c0103dde:	e8 29 14 00 00       	call   c010520c <strcmp>
c0103de3:	83 c4 10             	add    $0x10,%esp
c0103de6:	85 c0                	test   %eax,%eax
c0103de8:	74 19                	je     c0103e03 <check_boot_pgdir+0x26b>
c0103dea:	68 94 68 10 c0       	push   $0xc0106894
c0103def:	68 6d 64 10 c0       	push   $0xc010646d
c0103df4:	68 28 02 00 00       	push   $0x228
c0103df9:	68 48 64 10 c0       	push   $0xc0106448
c0103dfe:	e8 13 c6 ff ff       	call   c0100416 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103e03:	83 ec 0c             	sub    $0xc,%esp
c0103e06:	ff 75 ec             	pushl  -0x14(%ebp)
c0103e09:	e8 c9 eb ff ff       	call   c01029d7 <page2kva>
c0103e0e:	83 c4 10             	add    $0x10,%esp
c0103e11:	05 00 01 00 00       	add    $0x100,%eax
c0103e16:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103e19:	83 ec 0c             	sub    $0xc,%esp
c0103e1c:	68 00 01 00 00       	push   $0x100
c0103e21:	e8 05 13 00 00       	call   c010512b <strlen>
c0103e26:	83 c4 10             	add    $0x10,%esp
c0103e29:	85 c0                	test   %eax,%eax
c0103e2b:	74 19                	je     c0103e46 <check_boot_pgdir+0x2ae>
c0103e2d:	68 cc 68 10 c0       	push   $0xc01068cc
c0103e32:	68 6d 64 10 c0       	push   $0xc010646d
c0103e37:	68 2b 02 00 00       	push   $0x22b
c0103e3c:	68 48 64 10 c0       	push   $0xc0106448
c0103e41:	e8 d0 c5 ff ff       	call   c0100416 <__panic>

    free_page(p);
c0103e46:	83 ec 08             	sub    $0x8,%esp
c0103e49:	6a 01                	push   $0x1
c0103e4b:	ff 75 ec             	pushl  -0x14(%ebp)
c0103e4e:	e8 80 ee ff ff       	call   c0102cd3 <free_pages>
c0103e53:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103e56:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e5b:	8b 00                	mov    (%eax),%eax
c0103e5d:	83 ec 0c             	sub    $0xc,%esp
c0103e60:	50                   	push   %eax
c0103e61:	e8 f0 eb ff ff       	call   c0102a56 <pde2page>
c0103e66:	83 c4 10             	add    $0x10,%esp
c0103e69:	83 ec 08             	sub    $0x8,%esp
c0103e6c:	6a 01                	push   $0x1
c0103e6e:	50                   	push   %eax
c0103e6f:	e8 5f ee ff ff       	call   c0102cd3 <free_pages>
c0103e74:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103e77:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103e82:	83 ec 0c             	sub    $0xc,%esp
c0103e85:	68 f0 68 10 c0       	push   $0xc01068f0
c0103e8a:	e8 0c c4 ff ff       	call   c010029b <cprintf>
c0103e8f:	83 c4 10             	add    $0x10,%esp
}
c0103e92:	90                   	nop
c0103e93:	c9                   	leave  
c0103e94:	c3                   	ret    

c0103e95 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103e95:	f3 0f 1e fb          	endbr32 
c0103e99:	55                   	push   %ebp
c0103e9a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103e9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e9f:	83 e0 04             	and    $0x4,%eax
c0103ea2:	85 c0                	test   %eax,%eax
c0103ea4:	74 07                	je     c0103ead <perm2str+0x18>
c0103ea6:	b8 75 00 00 00       	mov    $0x75,%eax
c0103eab:	eb 05                	jmp    c0103eb2 <perm2str+0x1d>
c0103ead:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103eb2:	a2 08 cf 11 c0       	mov    %al,0xc011cf08
    str[1] = 'r';
c0103eb7:	c6 05 09 cf 11 c0 72 	movb   $0x72,0xc011cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103ebe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ec1:	83 e0 02             	and    $0x2,%eax
c0103ec4:	85 c0                	test   %eax,%eax
c0103ec6:	74 07                	je     c0103ecf <perm2str+0x3a>
c0103ec8:	b8 77 00 00 00       	mov    $0x77,%eax
c0103ecd:	eb 05                	jmp    c0103ed4 <perm2str+0x3f>
c0103ecf:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103ed4:	a2 0a cf 11 c0       	mov    %al,0xc011cf0a
    str[3] = '\0';
c0103ed9:	c6 05 0b cf 11 c0 00 	movb   $0x0,0xc011cf0b
    return str;
c0103ee0:	b8 08 cf 11 c0       	mov    $0xc011cf08,%eax
}
c0103ee5:	5d                   	pop    %ebp
c0103ee6:	c3                   	ret    

c0103ee7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103ee7:	f3 0f 1e fb          	endbr32 
c0103eeb:	55                   	push   %ebp
c0103eec:	89 e5                	mov    %esp,%ebp
c0103eee:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103ef1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ef4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ef7:	72 0e                	jb     c0103f07 <get_pgtable_items+0x20>
        return 0;
c0103ef9:	b8 00 00 00 00       	mov    $0x0,%eax
c0103efe:	e9 9a 00 00 00       	jmp    c0103f9d <get_pgtable_items+0xb6>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103f03:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0103f07:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f0d:	73 18                	jae    c0103f27 <get_pgtable_items+0x40>
c0103f0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f19:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f1c:	01 d0                	add    %edx,%eax
c0103f1e:	8b 00                	mov    (%eax),%eax
c0103f20:	83 e0 01             	and    $0x1,%eax
c0103f23:	85 c0                	test   %eax,%eax
c0103f25:	74 dc                	je     c0103f03 <get_pgtable_items+0x1c>
    }
    if (start < right) {
c0103f27:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f2d:	73 69                	jae    c0103f98 <get_pgtable_items+0xb1>
        if (left_store != NULL) {
c0103f2f:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103f33:	74 08                	je     c0103f3d <get_pgtable_items+0x56>
            *left_store = start;
c0103f35:	8b 45 18             	mov    0x18(%ebp),%eax
c0103f38:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f3b:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103f3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f40:	8d 50 01             	lea    0x1(%eax),%edx
c0103f43:	89 55 10             	mov    %edx,0x10(%ebp)
c0103f46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f4d:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f50:	01 d0                	add    %edx,%eax
c0103f52:	8b 00                	mov    (%eax),%eax
c0103f54:	83 e0 07             	and    $0x7,%eax
c0103f57:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f5a:	eb 04                	jmp    c0103f60 <get_pgtable_items+0x79>
            start ++;
c0103f5c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103f60:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f63:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103f66:	73 1d                	jae    c0103f85 <get_pgtable_items+0x9e>
c0103f68:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103f72:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f75:	01 d0                	add    %edx,%eax
c0103f77:	8b 00                	mov    (%eax),%eax
c0103f79:	83 e0 07             	and    $0x7,%eax
c0103f7c:	89 c2                	mov    %eax,%edx
c0103f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f81:	39 c2                	cmp    %eax,%edx
c0103f83:	74 d7                	je     c0103f5c <get_pgtable_items+0x75>
        }
        if (right_store != NULL) {
c0103f85:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103f89:	74 08                	je     c0103f93 <get_pgtable_items+0xac>
            *right_store = start;
c0103f8b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103f8e:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f91:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f96:	eb 05                	jmp    c0103f9d <get_pgtable_items+0xb6>
    }
    return 0;
c0103f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f9d:	c9                   	leave  
c0103f9e:	c3                   	ret    

c0103f9f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103f9f:	f3 0f 1e fb          	endbr32 
c0103fa3:	55                   	push   %ebp
c0103fa4:	89 e5                	mov    %esp,%ebp
c0103fa6:	57                   	push   %edi
c0103fa7:	56                   	push   %esi
c0103fa8:	53                   	push   %ebx
c0103fa9:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103fac:	83 ec 0c             	sub    $0xc,%esp
c0103faf:	68 10 69 10 c0       	push   $0xc0106910
c0103fb4:	e8 e2 c2 ff ff       	call   c010029b <cprintf>
c0103fb9:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103fbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103fc3:	e9 e1 00 00 00       	jmp    c01040a9 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fcb:	83 ec 0c             	sub    $0xc,%esp
c0103fce:	50                   	push   %eax
c0103fcf:	e8 c1 fe ff ff       	call   c0103e95 <perm2str>
c0103fd4:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103fd7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0103fda:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103fdd:	29 d1                	sub    %edx,%ecx
c0103fdf:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103fe1:	89 d6                	mov    %edx,%esi
c0103fe3:	c1 e6 16             	shl    $0x16,%esi
c0103fe6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fe9:	89 d3                	mov    %edx,%ebx
c0103feb:	c1 e3 16             	shl    $0x16,%ebx
c0103fee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ff1:	89 d1                	mov    %edx,%ecx
c0103ff3:	c1 e1 16             	shl    $0x16,%ecx
c0103ff6:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0103ff9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ffc:	29 d7                	sub    %edx,%edi
c0103ffe:	89 fa                	mov    %edi,%edx
c0104000:	83 ec 08             	sub    $0x8,%esp
c0104003:	50                   	push   %eax
c0104004:	56                   	push   %esi
c0104005:	53                   	push   %ebx
c0104006:	51                   	push   %ecx
c0104007:	52                   	push   %edx
c0104008:	68 41 69 10 c0       	push   $0xc0106941
c010400d:	e8 89 c2 ff ff       	call   c010029b <cprintf>
c0104012:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104015:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104018:	c1 e0 0a             	shl    $0xa,%eax
c010401b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010401e:	eb 4d                	jmp    c010406d <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104023:	83 ec 0c             	sub    $0xc,%esp
c0104026:	50                   	push   %eax
c0104027:	e8 69 fe ff ff       	call   c0103e95 <perm2str>
c010402c:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010402f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104032:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104035:	29 d1                	sub    %edx,%ecx
c0104037:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104039:	89 d6                	mov    %edx,%esi
c010403b:	c1 e6 0c             	shl    $0xc,%esi
c010403e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104041:	89 d3                	mov    %edx,%ebx
c0104043:	c1 e3 0c             	shl    $0xc,%ebx
c0104046:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104049:	89 d1                	mov    %edx,%ecx
c010404b:	c1 e1 0c             	shl    $0xc,%ecx
c010404e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104051:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104054:	29 d7                	sub    %edx,%edi
c0104056:	89 fa                	mov    %edi,%edx
c0104058:	83 ec 08             	sub    $0x8,%esp
c010405b:	50                   	push   %eax
c010405c:	56                   	push   %esi
c010405d:	53                   	push   %ebx
c010405e:	51                   	push   %ecx
c010405f:	52                   	push   %edx
c0104060:	68 60 69 10 c0       	push   $0xc0106960
c0104065:	e8 31 c2 ff ff       	call   c010029b <cprintf>
c010406a:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010406d:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104072:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104075:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104078:	89 d3                	mov    %edx,%ebx
c010407a:	c1 e3 0a             	shl    $0xa,%ebx
c010407d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104080:	89 d1                	mov    %edx,%ecx
c0104082:	c1 e1 0a             	shl    $0xa,%ecx
c0104085:	83 ec 08             	sub    $0x8,%esp
c0104088:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010408b:	52                   	push   %edx
c010408c:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010408f:	52                   	push   %edx
c0104090:	56                   	push   %esi
c0104091:	50                   	push   %eax
c0104092:	53                   	push   %ebx
c0104093:	51                   	push   %ecx
c0104094:	e8 4e fe ff ff       	call   c0103ee7 <get_pgtable_items>
c0104099:	83 c4 20             	add    $0x20,%esp
c010409c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010409f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040a3:	0f 85 77 ff ff ff    	jne    c0104020 <print_pgdir+0x81>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01040a9:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01040ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040b1:	83 ec 08             	sub    $0x8,%esp
c01040b4:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01040b7:	52                   	push   %edx
c01040b8:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01040bb:	52                   	push   %edx
c01040bc:	51                   	push   %ecx
c01040bd:	50                   	push   %eax
c01040be:	68 00 04 00 00       	push   $0x400
c01040c3:	6a 00                	push   $0x0
c01040c5:	e8 1d fe ff ff       	call   c0103ee7 <get_pgtable_items>
c01040ca:	83 c4 20             	add    $0x20,%esp
c01040cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040d4:	0f 85 ee fe ff ff    	jne    c0103fc8 <print_pgdir+0x29>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01040da:	83 ec 0c             	sub    $0xc,%esp
c01040dd:	68 84 69 10 c0       	push   $0xc0106984
c01040e2:	e8 b4 c1 ff ff       	call   c010029b <cprintf>
c01040e7:	83 c4 10             	add    $0x10,%esp
}
c01040ea:	90                   	nop
c01040eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
c01040ee:	5b                   	pop    %ebx
c01040ef:	5e                   	pop    %esi
c01040f0:	5f                   	pop    %edi
c01040f1:	5d                   	pop    %ebp
c01040f2:	c3                   	ret    

c01040f3 <page2ppn>:
page2ppn(struct Page *page) {
c01040f3:	55                   	push   %ebp
c01040f4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01040f6:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c01040fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01040fe:	29 c2                	sub    %eax,%edx
c0104100:	89 d0                	mov    %edx,%eax
c0104102:	c1 f8 02             	sar    $0x2,%eax
c0104105:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010410b:	5d                   	pop    %ebp
c010410c:	c3                   	ret    

c010410d <page2pa>:
page2pa(struct Page *page) {
c010410d:	55                   	push   %ebp
c010410e:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c0104110:	ff 75 08             	pushl  0x8(%ebp)
c0104113:	e8 db ff ff ff       	call   c01040f3 <page2ppn>
c0104118:	83 c4 04             	add    $0x4,%esp
c010411b:	c1 e0 0c             	shl    $0xc,%eax
}
c010411e:	c9                   	leave  
c010411f:	c3                   	ret    

c0104120 <page_ref>:
page_ref(struct Page *page) {
c0104120:	55                   	push   %ebp
c0104121:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104123:	8b 45 08             	mov    0x8(%ebp),%eax
c0104126:	8b 00                	mov    (%eax),%eax
}
c0104128:	5d                   	pop    %ebp
c0104129:	c3                   	ret    

c010412a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010412a:	55                   	push   %ebp
c010412b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010412d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104130:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104133:	89 10                	mov    %edx,(%eax)
}
c0104135:	90                   	nop
c0104136:	5d                   	pop    %ebp
c0104137:	c3                   	ret    

c0104138 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104138:	f3 0f 1e fb          	endbr32 
c010413c:	55                   	push   %ebp
c010413d:	89 e5                	mov    %esp,%ebp
c010413f:	83 ec 10             	sub    $0x10,%esp
c0104142:	c7 45 fc 1c cf 11 c0 	movl   $0xc011cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104149:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010414c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010414f:	89 50 04             	mov    %edx,0x4(%eax)
c0104152:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104155:	8b 50 04             	mov    0x4(%eax),%edx
c0104158:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010415b:	89 10                	mov    %edx,(%eax)
}
c010415d:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c010415e:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104165:	00 00 00 
}
c0104168:	90                   	nop
c0104169:	c9                   	leave  
c010416a:	c3                   	ret    

c010416b <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010416b:	f3 0f 1e fb          	endbr32 
c010416f:	55                   	push   %ebp
c0104170:	89 e5                	mov    %esp,%ebp
c0104172:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c0104175:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104179:	75 16                	jne    c0104191 <default_init_memmap+0x26>
c010417b:	68 b8 69 10 c0       	push   $0xc01069b8
c0104180:	68 be 69 10 c0       	push   $0xc01069be
c0104185:	6a 6d                	push   $0x6d
c0104187:	68 d3 69 10 c0       	push   $0xc01069d3
c010418c:	e8 85 c2 ff ff       	call   c0100416 <__panic>
    struct Page *p = base;
c0104191:	8b 45 08             	mov    0x8(%ebp),%eax
c0104194:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104197:	eb 6c                	jmp    c0104205 <default_init_memmap+0x9a>
        assert(PageReserved(p));
c0104199:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010419c:	83 c0 04             	add    $0x4,%eax
c010419f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01041a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01041af:	0f a3 10             	bt     %edx,(%eax)
c01041b2:	19 c0                	sbb    %eax,%eax
c01041b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01041b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01041bb:	0f 95 c0             	setne  %al
c01041be:	0f b6 c0             	movzbl %al,%eax
c01041c1:	85 c0                	test   %eax,%eax
c01041c3:	75 16                	jne    c01041db <default_init_memmap+0x70>
c01041c5:	68 e9 69 10 c0       	push   $0xc01069e9
c01041ca:	68 be 69 10 c0       	push   $0xc01069be
c01041cf:	6a 70                	push   $0x70
c01041d1:	68 d3 69 10 c0       	push   $0xc01069d3
c01041d6:	e8 3b c2 ff ff       	call   c0100416 <__panic>
        p->flags = p->property = 0;
c01041db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01041e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041e8:	8b 50 08             	mov    0x8(%eax),%edx
c01041eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041ee:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01041f1:	83 ec 08             	sub    $0x8,%esp
c01041f4:	6a 00                	push   $0x0
c01041f6:	ff 75 f4             	pushl  -0xc(%ebp)
c01041f9:	e8 2c ff ff ff       	call   c010412a <set_page_ref>
c01041fe:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0104201:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104205:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104208:	89 d0                	mov    %edx,%eax
c010420a:	c1 e0 02             	shl    $0x2,%eax
c010420d:	01 d0                	add    %edx,%eax
c010420f:	c1 e0 02             	shl    $0x2,%eax
c0104212:	89 c2                	mov    %eax,%edx
c0104214:	8b 45 08             	mov    0x8(%ebp),%eax
c0104217:	01 d0                	add    %edx,%eax
c0104219:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010421c:	0f 85 77 ff ff ff    	jne    c0104199 <default_init_memmap+0x2e>
    }
    base->property = n;
c0104222:	8b 45 08             	mov    0x8(%ebp),%eax
c0104225:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104228:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010422b:	8b 45 08             	mov    0x8(%ebp),%eax
c010422e:	83 c0 04             	add    $0x4,%eax
c0104231:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104238:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010423b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010423e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104241:	0f ab 10             	bts    %edx,(%eax)
}
c0104244:	90                   	nop
    nr_free += n;
c0104245:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c010424b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010424e:	01 d0                	add    %edx,%eax
c0104250:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    list_add_before(&free_list, &(base->page_link));
c0104255:	8b 45 08             	mov    0x8(%ebp),%eax
c0104258:	83 c0 0c             	add    $0xc,%eax
c010425b:	c7 45 e4 1c cf 11 c0 	movl   $0xc011cf1c,-0x1c(%ebp)
c0104262:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0104265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104268:	8b 00                	mov    (%eax),%eax
c010426a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010426d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104270:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104276:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104279:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010427c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010427f:	89 10                	mov    %edx,(%eax)
c0104281:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104284:	8b 10                	mov    (%eax),%edx
c0104286:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104289:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010428c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010428f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104292:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104295:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104298:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010429b:	89 10                	mov    %edx,(%eax)
}
c010429d:	90                   	nop
}
c010429e:	90                   	nop
}
c010429f:	90                   	nop
c01042a0:	c9                   	leave  
c01042a1:	c3                   	ret    

c01042a2 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01042a2:	f3 0f 1e fb          	endbr32 
c01042a6:	55                   	push   %ebp
c01042a7:	89 e5                	mov    %esp,%ebp
c01042a9:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01042ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01042b0:	75 16                	jne    c01042c8 <default_alloc_pages+0x26>
c01042b2:	68 b8 69 10 c0       	push   $0xc01069b8
c01042b7:	68 be 69 10 c0       	push   $0xc01069be
c01042bc:	6a 7c                	push   $0x7c
c01042be:	68 d3 69 10 c0       	push   $0xc01069d3
c01042c3:	e8 4e c1 ff ff       	call   c0100416 <__panic>
    if (n > nr_free) {
c01042c8:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01042cd:	39 45 08             	cmp    %eax,0x8(%ebp)
c01042d0:	76 0a                	jbe    c01042dc <default_alloc_pages+0x3a>
        return NULL;
c01042d2:	b8 00 00 00 00       	mov    $0x0,%eax
c01042d7:	e9 43 01 00 00       	jmp    c010441f <default_alloc_pages+0x17d>
    }
    struct Page *page = NULL;
c01042dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01042e3:	c7 45 f0 1c cf 11 c0 	movl   $0xc011cf1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c01042ea:	eb 1c                	jmp    c0104308 <default_alloc_pages+0x66>
        struct Page *p = le2page(le, page_link);
c01042ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042ef:	83 e8 0c             	sub    $0xc,%eax
c01042f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01042f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042f8:	8b 40 08             	mov    0x8(%eax),%eax
c01042fb:	39 45 08             	cmp    %eax,0x8(%ebp)
c01042fe:	77 08                	ja     c0104308 <default_alloc_pages+0x66>
            page = p;
c0104300:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104303:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0104306:	eb 18                	jmp    c0104320 <default_alloc_pages+0x7e>
c0104308:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010430b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c010430e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104311:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104314:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104317:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c010431e:	75 cc                	jne    c01042ec <default_alloc_pages+0x4a>
        }
    }
    if (page != NULL) {
c0104320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104324:	0f 84 f2 00 00 00    	je     c010441c <default_alloc_pages+0x17a>
        if (page->property > n) {
c010432a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010432d:	8b 40 08             	mov    0x8(%eax),%eax
c0104330:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104333:	0f 83 8f 00 00 00    	jae    c01043c8 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c0104339:	8b 55 08             	mov    0x8(%ebp),%edx
c010433c:	89 d0                	mov    %edx,%eax
c010433e:	c1 e0 02             	shl    $0x2,%eax
c0104341:	01 d0                	add    %edx,%eax
c0104343:	c1 e0 02             	shl    $0x2,%eax
c0104346:	89 c2                	mov    %eax,%edx
c0104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434b:	01 d0                	add    %edx,%eax
c010434d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104353:	8b 40 08             	mov    0x8(%eax),%eax
c0104356:	2b 45 08             	sub    0x8(%ebp),%eax
c0104359:	89 c2                	mov    %eax,%edx
c010435b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010435e:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104361:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104364:	83 c0 04             	add    $0x4,%eax
c0104367:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010436e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104371:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104374:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104377:	0f ab 10             	bts    %edx,(%eax)
}
c010437a:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c010437b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010437e:	83 c0 0c             	add    $0xc,%eax
c0104381:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104384:	83 c2 0c             	add    $0xc,%edx
c0104387:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010438a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c010438d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104390:	8b 40 04             	mov    0x4(%eax),%eax
c0104393:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104396:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104399:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010439c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010439f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c01043a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043a8:	89 10                	mov    %edx,(%eax)
c01043aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043ad:	8b 10                	mov    (%eax),%edx
c01043af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043b2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01043b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01043bb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01043be:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043c4:	89 10                	mov    %edx,(%eax)
}
c01043c6:	90                   	nop
}
c01043c7:	90                   	nop
        }
        list_del(&(page->page_link));
c01043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043cb:	83 c0 0c             	add    $0xc,%eax
c01043ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01043d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01043d4:	8b 40 04             	mov    0x4(%eax),%eax
c01043d7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01043da:	8b 12                	mov    (%edx),%edx
c01043dc:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01043df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01043e2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01043e5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01043e8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01043eb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01043ee:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01043f1:	89 10                	mov    %edx,(%eax)
}
c01043f3:	90                   	nop
}
c01043f4:	90                   	nop
        nr_free -= n;
c01043f5:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01043fa:	2b 45 08             	sub    0x8(%ebp),%eax
c01043fd:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
        ClearPageProperty(page);
c0104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104405:	83 c0 04             	add    $0x4,%eax
c0104408:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010440f:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104412:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104415:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104418:	0f b3 10             	btr    %edx,(%eax)
}
c010441b:	90                   	nop
    }
    return page;
c010441c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010441f:	c9                   	leave  
c0104420:	c3                   	ret    

c0104421 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104421:	f3 0f 1e fb          	endbr32 
c0104425:	55                   	push   %ebp
c0104426:	89 e5                	mov    %esp,%ebp
c0104428:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c010442e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104432:	75 19                	jne    c010444d <default_free_pages+0x2c>
c0104434:	68 b8 69 10 c0       	push   $0xc01069b8
c0104439:	68 be 69 10 c0       	push   $0xc01069be
c010443e:	68 9a 00 00 00       	push   $0x9a
c0104443:	68 d3 69 10 c0       	push   $0xc01069d3
c0104448:	e8 c9 bf ff ff       	call   c0100416 <__panic>
    struct Page *p = base;
c010444d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104450:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104453:	e9 8f 00 00 00       	jmp    c01044e7 <default_free_pages+0xc6>
        assert(!PageReserved(p) && !PageProperty(p));
c0104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445b:	83 c0 04             	add    $0x4,%eax
c010445e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104465:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104468:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010446b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010446e:	0f a3 10             	bt     %edx,(%eax)
c0104471:	19 c0                	sbb    %eax,%eax
c0104473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104476:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010447a:	0f 95 c0             	setne  %al
c010447d:	0f b6 c0             	movzbl %al,%eax
c0104480:	85 c0                	test   %eax,%eax
c0104482:	75 2c                	jne    c01044b0 <default_free_pages+0x8f>
c0104484:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104487:	83 c0 04             	add    $0x4,%eax
c010448a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104491:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104494:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104497:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010449a:	0f a3 10             	bt     %edx,(%eax)
c010449d:	19 c0                	sbb    %eax,%eax
c010449f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01044a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01044a6:	0f 95 c0             	setne  %al
c01044a9:	0f b6 c0             	movzbl %al,%eax
c01044ac:	85 c0                	test   %eax,%eax
c01044ae:	74 19                	je     c01044c9 <default_free_pages+0xa8>
c01044b0:	68 fc 69 10 c0       	push   $0xc01069fc
c01044b5:	68 be 69 10 c0       	push   $0xc01069be
c01044ba:	68 9d 00 00 00       	push   $0x9d
c01044bf:	68 d3 69 10 c0       	push   $0xc01069d3
c01044c4:	e8 4d bf ff ff       	call   c0100416 <__panic>
        p->flags = 0;
c01044c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01044d3:	83 ec 08             	sub    $0x8,%esp
c01044d6:	6a 00                	push   $0x0
c01044d8:	ff 75 f4             	pushl  -0xc(%ebp)
c01044db:	e8 4a fc ff ff       	call   c010412a <set_page_ref>
c01044e0:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c01044e3:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01044e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044ea:	89 d0                	mov    %edx,%eax
c01044ec:	c1 e0 02             	shl    $0x2,%eax
c01044ef:	01 d0                	add    %edx,%eax
c01044f1:	c1 e0 02             	shl    $0x2,%eax
c01044f4:	89 c2                	mov    %eax,%edx
c01044f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f9:	01 d0                	add    %edx,%eax
c01044fb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01044fe:	0f 85 54 ff ff ff    	jne    c0104458 <default_free_pages+0x37>
    }
    base->property = n;
c0104504:	8b 45 08             	mov    0x8(%ebp),%eax
c0104507:	8b 55 0c             	mov    0xc(%ebp),%edx
c010450a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010450d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104510:	83 c0 04             	add    $0x4,%eax
c0104513:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010451a:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010451d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104520:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104523:	0f ab 10             	bts    %edx,(%eax)
}
c0104526:	90                   	nop
c0104527:	c7 45 d4 1c cf 11 c0 	movl   $0xc011cf1c,-0x2c(%ebp)
    return listelm->next;
c010452e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104531:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104534:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104537:	e9 0e 01 00 00       	jmp    c010464a <default_free_pages+0x229>
        p = le2page(le, page_link);
c010453c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010453f:	83 e8 0c             	sub    $0xc,%eax
c0104542:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104545:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104548:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010454b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010454e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104551:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0104554:	8b 45 08             	mov    0x8(%ebp),%eax
c0104557:	8b 50 08             	mov    0x8(%eax),%edx
c010455a:	89 d0                	mov    %edx,%eax
c010455c:	c1 e0 02             	shl    $0x2,%eax
c010455f:	01 d0                	add    %edx,%eax
c0104561:	c1 e0 02             	shl    $0x2,%eax
c0104564:	89 c2                	mov    %eax,%edx
c0104566:	8b 45 08             	mov    0x8(%ebp),%eax
c0104569:	01 d0                	add    %edx,%eax
c010456b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010456e:	75 5d                	jne    c01045cd <default_free_pages+0x1ac>
            base->property += p->property;
c0104570:	8b 45 08             	mov    0x8(%ebp),%eax
c0104573:	8b 50 08             	mov    0x8(%eax),%edx
c0104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104579:	8b 40 08             	mov    0x8(%eax),%eax
c010457c:	01 c2                	add    %eax,%edx
c010457e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104581:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104587:	83 c0 04             	add    $0x4,%eax
c010458a:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0104591:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104594:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104597:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010459a:	0f b3 10             	btr    %edx,(%eax)
}
c010459d:	90                   	nop
            list_del(&(p->page_link));
c010459e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a1:	83 c0 0c             	add    $0xc,%eax
c01045a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01045a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01045aa:	8b 40 04             	mov    0x4(%eax),%eax
c01045ad:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01045b0:	8b 12                	mov    (%edx),%edx
c01045b2:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01045b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c01045b8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01045bb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01045be:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01045c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01045c4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01045c7:	89 10                	mov    %edx,(%eax)
}
c01045c9:	90                   	nop
}
c01045ca:	90                   	nop
c01045cb:	eb 7d                	jmp    c010464a <default_free_pages+0x229>
        }
        else if (p + p->property == base) {
c01045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d0:	8b 50 08             	mov    0x8(%eax),%edx
c01045d3:	89 d0                	mov    %edx,%eax
c01045d5:	c1 e0 02             	shl    $0x2,%eax
c01045d8:	01 d0                	add    %edx,%eax
c01045da:	c1 e0 02             	shl    $0x2,%eax
c01045dd:	89 c2                	mov    %eax,%edx
c01045df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e2:	01 d0                	add    %edx,%eax
c01045e4:	39 45 08             	cmp    %eax,0x8(%ebp)
c01045e7:	75 61                	jne    c010464a <default_free_pages+0x229>
            p->property += base->property;
c01045e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ec:	8b 50 08             	mov    0x8(%eax),%edx
c01045ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01045f2:	8b 40 08             	mov    0x8(%eax),%eax
c01045f5:	01 c2                	add    %eax,%edx
c01045f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045fa:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01045fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104600:	83 c0 04             	add    $0x4,%eax
c0104603:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c010460a:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010460d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104610:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104613:	0f b3 10             	btr    %edx,(%eax)
}
c0104616:	90                   	nop
            base = p;
c0104617:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461a:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010461d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104620:	83 c0 0c             	add    $0xc,%eax
c0104623:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104626:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104629:	8b 40 04             	mov    0x4(%eax),%eax
c010462c:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010462f:	8b 12                	mov    (%edx),%edx
c0104631:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104634:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104637:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010463a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010463d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104640:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104643:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104646:	89 10                	mov    %edx,(%eax)
}
c0104648:	90                   	nop
}
c0104649:	90                   	nop
    while (le != &free_list) {
c010464a:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c0104651:	0f 85 e5 fe ff ff    	jne    c010453c <default_free_pages+0x11b>
        }
    }
    nr_free += n;
c0104657:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c010465d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104660:	01 d0                	add    %edx,%eax
c0104662:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
c0104667:	c7 45 9c 1c cf 11 c0 	movl   $0xc011cf1c,-0x64(%ebp)
    return listelm->next;
c010466e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104671:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0104674:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104677:	eb 69                	jmp    c01046e2 <default_free_pages+0x2c1>
        p = le2page(le, page_link);
c0104679:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010467c:	83 e8 0c             	sub    $0xc,%eax
c010467f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0104682:	8b 45 08             	mov    0x8(%ebp),%eax
c0104685:	8b 50 08             	mov    0x8(%eax),%edx
c0104688:	89 d0                	mov    %edx,%eax
c010468a:	c1 e0 02             	shl    $0x2,%eax
c010468d:	01 d0                	add    %edx,%eax
c010468f:	c1 e0 02             	shl    $0x2,%eax
c0104692:	89 c2                	mov    %eax,%edx
c0104694:	8b 45 08             	mov    0x8(%ebp),%eax
c0104697:	01 d0                	add    %edx,%eax
c0104699:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010469c:	72 35                	jb     c01046d3 <default_free_pages+0x2b2>
            assert(base + base->property != p);
c010469e:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a1:	8b 50 08             	mov    0x8(%eax),%edx
c01046a4:	89 d0                	mov    %edx,%eax
c01046a6:	c1 e0 02             	shl    $0x2,%eax
c01046a9:	01 d0                	add    %edx,%eax
c01046ab:	c1 e0 02             	shl    $0x2,%eax
c01046ae:	89 c2                	mov    %eax,%edx
c01046b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b3:	01 d0                	add    %edx,%eax
c01046b5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046b8:	75 33                	jne    c01046ed <default_free_pages+0x2cc>
c01046ba:	68 21 6a 10 c0       	push   $0xc0106a21
c01046bf:	68 be 69 10 c0       	push   $0xc01069be
c01046c4:	68 b9 00 00 00       	push   $0xb9
c01046c9:	68 d3 69 10 c0       	push   $0xc01069d3
c01046ce:	e8 43 bd ff ff       	call   c0100416 <__panic>
c01046d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d6:	89 45 98             	mov    %eax,-0x68(%ebp)
c01046d9:	8b 45 98             	mov    -0x68(%ebp),%eax
c01046dc:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01046df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01046e2:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01046e9:	75 8e                	jne    c0104679 <default_free_pages+0x258>
c01046eb:	eb 01                	jmp    c01046ee <default_free_pages+0x2cd>
            break;
c01046ed:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c01046ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01046f1:	8d 50 0c             	lea    0xc(%eax),%edx
c01046f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f7:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01046fa:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01046fd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104700:	8b 00                	mov    (%eax),%eax
c0104702:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104705:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0104708:	89 45 88             	mov    %eax,-0x78(%ebp)
c010470b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010470e:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0104711:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104714:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0104717:	89 10                	mov    %edx,(%eax)
c0104719:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010471c:	8b 10                	mov    (%eax),%edx
c010471e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104721:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104724:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104727:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010472a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010472d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104730:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104733:	89 10                	mov    %edx,(%eax)
}
c0104735:	90                   	nop
}
c0104736:	90                   	nop
}
c0104737:	90                   	nop
c0104738:	c9                   	leave  
c0104739:	c3                   	ret    

c010473a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010473a:	f3 0f 1e fb          	endbr32 
c010473e:	55                   	push   %ebp
c010473f:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104741:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
}
c0104746:	5d                   	pop    %ebp
c0104747:	c3                   	ret    

c0104748 <basic_check>:

static void
basic_check(void) {
c0104748:	f3 0f 1e fb          	endbr32 
c010474c:	55                   	push   %ebp
c010474d:	89 e5                	mov    %esp,%ebp
c010474f:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104752:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010475c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010475f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104762:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104765:	83 ec 0c             	sub    $0xc,%esp
c0104768:	6a 01                	push   $0x1
c010476a:	e8 22 e5 ff ff       	call   c0102c91 <alloc_pages>
c010476f:	83 c4 10             	add    $0x10,%esp
c0104772:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104775:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104779:	75 19                	jne    c0104794 <basic_check+0x4c>
c010477b:	68 3c 6a 10 c0       	push   $0xc0106a3c
c0104780:	68 be 69 10 c0       	push   $0xc01069be
c0104785:	68 ca 00 00 00       	push   $0xca
c010478a:	68 d3 69 10 c0       	push   $0xc01069d3
c010478f:	e8 82 bc ff ff       	call   c0100416 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104794:	83 ec 0c             	sub    $0xc,%esp
c0104797:	6a 01                	push   $0x1
c0104799:	e8 f3 e4 ff ff       	call   c0102c91 <alloc_pages>
c010479e:	83 c4 10             	add    $0x10,%esp
c01047a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01047a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047a8:	75 19                	jne    c01047c3 <basic_check+0x7b>
c01047aa:	68 58 6a 10 c0       	push   $0xc0106a58
c01047af:	68 be 69 10 c0       	push   $0xc01069be
c01047b4:	68 cb 00 00 00       	push   $0xcb
c01047b9:	68 d3 69 10 c0       	push   $0xc01069d3
c01047be:	e8 53 bc ff ff       	call   c0100416 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01047c3:	83 ec 0c             	sub    $0xc,%esp
c01047c6:	6a 01                	push   $0x1
c01047c8:	e8 c4 e4 ff ff       	call   c0102c91 <alloc_pages>
c01047cd:	83 c4 10             	add    $0x10,%esp
c01047d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047d7:	75 19                	jne    c01047f2 <basic_check+0xaa>
c01047d9:	68 74 6a 10 c0       	push   $0xc0106a74
c01047de:	68 be 69 10 c0       	push   $0xc01069be
c01047e3:	68 cc 00 00 00       	push   $0xcc
c01047e8:	68 d3 69 10 c0       	push   $0xc01069d3
c01047ed:	e8 24 bc ff ff       	call   c0100416 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01047f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047f8:	74 10                	je     c010480a <basic_check+0xc2>
c01047fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104800:	74 08                	je     c010480a <basic_check+0xc2>
c0104802:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104805:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104808:	75 19                	jne    c0104823 <basic_check+0xdb>
c010480a:	68 90 6a 10 c0       	push   $0xc0106a90
c010480f:	68 be 69 10 c0       	push   $0xc01069be
c0104814:	68 ce 00 00 00       	push   $0xce
c0104819:	68 d3 69 10 c0       	push   $0xc01069d3
c010481e:	e8 f3 bb ff ff       	call   c0100416 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104823:	83 ec 0c             	sub    $0xc,%esp
c0104826:	ff 75 ec             	pushl  -0x14(%ebp)
c0104829:	e8 f2 f8 ff ff       	call   c0104120 <page_ref>
c010482e:	83 c4 10             	add    $0x10,%esp
c0104831:	85 c0                	test   %eax,%eax
c0104833:	75 24                	jne    c0104859 <basic_check+0x111>
c0104835:	83 ec 0c             	sub    $0xc,%esp
c0104838:	ff 75 f0             	pushl  -0x10(%ebp)
c010483b:	e8 e0 f8 ff ff       	call   c0104120 <page_ref>
c0104840:	83 c4 10             	add    $0x10,%esp
c0104843:	85 c0                	test   %eax,%eax
c0104845:	75 12                	jne    c0104859 <basic_check+0x111>
c0104847:	83 ec 0c             	sub    $0xc,%esp
c010484a:	ff 75 f4             	pushl  -0xc(%ebp)
c010484d:	e8 ce f8 ff ff       	call   c0104120 <page_ref>
c0104852:	83 c4 10             	add    $0x10,%esp
c0104855:	85 c0                	test   %eax,%eax
c0104857:	74 19                	je     c0104872 <basic_check+0x12a>
c0104859:	68 b4 6a 10 c0       	push   $0xc0106ab4
c010485e:	68 be 69 10 c0       	push   $0xc01069be
c0104863:	68 cf 00 00 00       	push   $0xcf
c0104868:	68 d3 69 10 c0       	push   $0xc01069d3
c010486d:	e8 a4 bb ff ff       	call   c0100416 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104872:	83 ec 0c             	sub    $0xc,%esp
c0104875:	ff 75 ec             	pushl  -0x14(%ebp)
c0104878:	e8 90 f8 ff ff       	call   c010410d <page2pa>
c010487d:	83 c4 10             	add    $0x10,%esp
c0104880:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104886:	c1 e2 0c             	shl    $0xc,%edx
c0104889:	39 d0                	cmp    %edx,%eax
c010488b:	72 19                	jb     c01048a6 <basic_check+0x15e>
c010488d:	68 f0 6a 10 c0       	push   $0xc0106af0
c0104892:	68 be 69 10 c0       	push   $0xc01069be
c0104897:	68 d1 00 00 00       	push   $0xd1
c010489c:	68 d3 69 10 c0       	push   $0xc01069d3
c01048a1:	e8 70 bb ff ff       	call   c0100416 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01048a6:	83 ec 0c             	sub    $0xc,%esp
c01048a9:	ff 75 f0             	pushl  -0x10(%ebp)
c01048ac:	e8 5c f8 ff ff       	call   c010410d <page2pa>
c01048b1:	83 c4 10             	add    $0x10,%esp
c01048b4:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c01048ba:	c1 e2 0c             	shl    $0xc,%edx
c01048bd:	39 d0                	cmp    %edx,%eax
c01048bf:	72 19                	jb     c01048da <basic_check+0x192>
c01048c1:	68 0d 6b 10 c0       	push   $0xc0106b0d
c01048c6:	68 be 69 10 c0       	push   $0xc01069be
c01048cb:	68 d2 00 00 00       	push   $0xd2
c01048d0:	68 d3 69 10 c0       	push   $0xc01069d3
c01048d5:	e8 3c bb ff ff       	call   c0100416 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01048da:	83 ec 0c             	sub    $0xc,%esp
c01048dd:	ff 75 f4             	pushl  -0xc(%ebp)
c01048e0:	e8 28 f8 ff ff       	call   c010410d <page2pa>
c01048e5:	83 c4 10             	add    $0x10,%esp
c01048e8:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c01048ee:	c1 e2 0c             	shl    $0xc,%edx
c01048f1:	39 d0                	cmp    %edx,%eax
c01048f3:	72 19                	jb     c010490e <basic_check+0x1c6>
c01048f5:	68 2a 6b 10 c0       	push   $0xc0106b2a
c01048fa:	68 be 69 10 c0       	push   $0xc01069be
c01048ff:	68 d3 00 00 00       	push   $0xd3
c0104904:	68 d3 69 10 c0       	push   $0xc01069d3
c0104909:	e8 08 bb ff ff       	call   c0100416 <__panic>

    list_entry_t free_list_store = free_list;
c010490e:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104913:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104919:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010491c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010491f:	c7 45 dc 1c cf 11 c0 	movl   $0xc011cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104926:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104929:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010492c:	89 50 04             	mov    %edx,0x4(%eax)
c010492f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104932:	8b 50 04             	mov    0x4(%eax),%edx
c0104935:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104938:	89 10                	mov    %edx,(%eax)
}
c010493a:	90                   	nop
c010493b:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
    return list->next == list;
c0104942:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104945:	8b 40 04             	mov    0x4(%eax),%eax
c0104948:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010494b:	0f 94 c0             	sete   %al
c010494e:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104951:	85 c0                	test   %eax,%eax
c0104953:	75 19                	jne    c010496e <basic_check+0x226>
c0104955:	68 47 6b 10 c0       	push   $0xc0106b47
c010495a:	68 be 69 10 c0       	push   $0xc01069be
c010495f:	68 d7 00 00 00       	push   $0xd7
c0104964:	68 d3 69 10 c0       	push   $0xc01069d3
c0104969:	e8 a8 ba ff ff       	call   c0100416 <__panic>

    unsigned int nr_free_store = nr_free;
c010496e:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104973:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104976:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c010497d:	00 00 00 

    assert(alloc_page() == NULL);
c0104980:	83 ec 0c             	sub    $0xc,%esp
c0104983:	6a 01                	push   $0x1
c0104985:	e8 07 e3 ff ff       	call   c0102c91 <alloc_pages>
c010498a:	83 c4 10             	add    $0x10,%esp
c010498d:	85 c0                	test   %eax,%eax
c010498f:	74 19                	je     c01049aa <basic_check+0x262>
c0104991:	68 5e 6b 10 c0       	push   $0xc0106b5e
c0104996:	68 be 69 10 c0       	push   $0xc01069be
c010499b:	68 dc 00 00 00       	push   $0xdc
c01049a0:	68 d3 69 10 c0       	push   $0xc01069d3
c01049a5:	e8 6c ba ff ff       	call   c0100416 <__panic>

    free_page(p0);
c01049aa:	83 ec 08             	sub    $0x8,%esp
c01049ad:	6a 01                	push   $0x1
c01049af:	ff 75 ec             	pushl  -0x14(%ebp)
c01049b2:	e8 1c e3 ff ff       	call   c0102cd3 <free_pages>
c01049b7:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c01049ba:	83 ec 08             	sub    $0x8,%esp
c01049bd:	6a 01                	push   $0x1
c01049bf:	ff 75 f0             	pushl  -0x10(%ebp)
c01049c2:	e8 0c e3 ff ff       	call   c0102cd3 <free_pages>
c01049c7:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c01049ca:	83 ec 08             	sub    $0x8,%esp
c01049cd:	6a 01                	push   $0x1
c01049cf:	ff 75 f4             	pushl  -0xc(%ebp)
c01049d2:	e8 fc e2 ff ff       	call   c0102cd3 <free_pages>
c01049d7:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c01049da:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01049df:	83 f8 03             	cmp    $0x3,%eax
c01049e2:	74 19                	je     c01049fd <basic_check+0x2b5>
c01049e4:	68 73 6b 10 c0       	push   $0xc0106b73
c01049e9:	68 be 69 10 c0       	push   $0xc01069be
c01049ee:	68 e1 00 00 00       	push   $0xe1
c01049f3:	68 d3 69 10 c0       	push   $0xc01069d3
c01049f8:	e8 19 ba ff ff       	call   c0100416 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01049fd:	83 ec 0c             	sub    $0xc,%esp
c0104a00:	6a 01                	push   $0x1
c0104a02:	e8 8a e2 ff ff       	call   c0102c91 <alloc_pages>
c0104a07:	83 c4 10             	add    $0x10,%esp
c0104a0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a11:	75 19                	jne    c0104a2c <basic_check+0x2e4>
c0104a13:	68 3c 6a 10 c0       	push   $0xc0106a3c
c0104a18:	68 be 69 10 c0       	push   $0xc01069be
c0104a1d:	68 e3 00 00 00       	push   $0xe3
c0104a22:	68 d3 69 10 c0       	push   $0xc01069d3
c0104a27:	e8 ea b9 ff ff       	call   c0100416 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a2c:	83 ec 0c             	sub    $0xc,%esp
c0104a2f:	6a 01                	push   $0x1
c0104a31:	e8 5b e2 ff ff       	call   c0102c91 <alloc_pages>
c0104a36:	83 c4 10             	add    $0x10,%esp
c0104a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a40:	75 19                	jne    c0104a5b <basic_check+0x313>
c0104a42:	68 58 6a 10 c0       	push   $0xc0106a58
c0104a47:	68 be 69 10 c0       	push   $0xc01069be
c0104a4c:	68 e4 00 00 00       	push   $0xe4
c0104a51:	68 d3 69 10 c0       	push   $0xc01069d3
c0104a56:	e8 bb b9 ff ff       	call   c0100416 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104a5b:	83 ec 0c             	sub    $0xc,%esp
c0104a5e:	6a 01                	push   $0x1
c0104a60:	e8 2c e2 ff ff       	call   c0102c91 <alloc_pages>
c0104a65:	83 c4 10             	add    $0x10,%esp
c0104a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a6f:	75 19                	jne    c0104a8a <basic_check+0x342>
c0104a71:	68 74 6a 10 c0       	push   $0xc0106a74
c0104a76:	68 be 69 10 c0       	push   $0xc01069be
c0104a7b:	68 e5 00 00 00       	push   $0xe5
c0104a80:	68 d3 69 10 c0       	push   $0xc01069d3
c0104a85:	e8 8c b9 ff ff       	call   c0100416 <__panic>

    assert(alloc_page() == NULL);
c0104a8a:	83 ec 0c             	sub    $0xc,%esp
c0104a8d:	6a 01                	push   $0x1
c0104a8f:	e8 fd e1 ff ff       	call   c0102c91 <alloc_pages>
c0104a94:	83 c4 10             	add    $0x10,%esp
c0104a97:	85 c0                	test   %eax,%eax
c0104a99:	74 19                	je     c0104ab4 <basic_check+0x36c>
c0104a9b:	68 5e 6b 10 c0       	push   $0xc0106b5e
c0104aa0:	68 be 69 10 c0       	push   $0xc01069be
c0104aa5:	68 e7 00 00 00       	push   $0xe7
c0104aaa:	68 d3 69 10 c0       	push   $0xc01069d3
c0104aaf:	e8 62 b9 ff ff       	call   c0100416 <__panic>

    free_page(p0);
c0104ab4:	83 ec 08             	sub    $0x8,%esp
c0104ab7:	6a 01                	push   $0x1
c0104ab9:	ff 75 ec             	pushl  -0x14(%ebp)
c0104abc:	e8 12 e2 ff ff       	call   c0102cd3 <free_pages>
c0104ac1:	83 c4 10             	add    $0x10,%esp
c0104ac4:	c7 45 d8 1c cf 11 c0 	movl   $0xc011cf1c,-0x28(%ebp)
c0104acb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ace:	8b 40 04             	mov    0x4(%eax),%eax
c0104ad1:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104ad4:	0f 94 c0             	sete   %al
c0104ad7:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104ada:	85 c0                	test   %eax,%eax
c0104adc:	74 19                	je     c0104af7 <basic_check+0x3af>
c0104ade:	68 80 6b 10 c0       	push   $0xc0106b80
c0104ae3:	68 be 69 10 c0       	push   $0xc01069be
c0104ae8:	68 ea 00 00 00       	push   $0xea
c0104aed:	68 d3 69 10 c0       	push   $0xc01069d3
c0104af2:	e8 1f b9 ff ff       	call   c0100416 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104af7:	83 ec 0c             	sub    $0xc,%esp
c0104afa:	6a 01                	push   $0x1
c0104afc:	e8 90 e1 ff ff       	call   c0102c91 <alloc_pages>
c0104b01:	83 c4 10             	add    $0x10,%esp
c0104b04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b0a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104b0d:	74 19                	je     c0104b28 <basic_check+0x3e0>
c0104b0f:	68 98 6b 10 c0       	push   $0xc0106b98
c0104b14:	68 be 69 10 c0       	push   $0xc01069be
c0104b19:	68 ed 00 00 00       	push   $0xed
c0104b1e:	68 d3 69 10 c0       	push   $0xc01069d3
c0104b23:	e8 ee b8 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0104b28:	83 ec 0c             	sub    $0xc,%esp
c0104b2b:	6a 01                	push   $0x1
c0104b2d:	e8 5f e1 ff ff       	call   c0102c91 <alloc_pages>
c0104b32:	83 c4 10             	add    $0x10,%esp
c0104b35:	85 c0                	test   %eax,%eax
c0104b37:	74 19                	je     c0104b52 <basic_check+0x40a>
c0104b39:	68 5e 6b 10 c0       	push   $0xc0106b5e
c0104b3e:	68 be 69 10 c0       	push   $0xc01069be
c0104b43:	68 ee 00 00 00       	push   $0xee
c0104b48:	68 d3 69 10 c0       	push   $0xc01069d3
c0104b4d:	e8 c4 b8 ff ff       	call   c0100416 <__panic>

    assert(nr_free == 0);
c0104b52:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104b57:	85 c0                	test   %eax,%eax
c0104b59:	74 19                	je     c0104b74 <basic_check+0x42c>
c0104b5b:	68 b1 6b 10 c0       	push   $0xc0106bb1
c0104b60:	68 be 69 10 c0       	push   $0xc01069be
c0104b65:	68 f0 00 00 00       	push   $0xf0
c0104b6a:	68 d3 69 10 c0       	push   $0xc01069d3
c0104b6f:	e8 a2 b8 ff ff       	call   c0100416 <__panic>
    free_list = free_list_store;
c0104b74:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b7a:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0104b7f:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    nr_free = nr_free_store;
c0104b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b88:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_page(p);
c0104b8d:	83 ec 08             	sub    $0x8,%esp
c0104b90:	6a 01                	push   $0x1
c0104b92:	ff 75 e4             	pushl  -0x1c(%ebp)
c0104b95:	e8 39 e1 ff ff       	call   c0102cd3 <free_pages>
c0104b9a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104b9d:	83 ec 08             	sub    $0x8,%esp
c0104ba0:	6a 01                	push   $0x1
c0104ba2:	ff 75 f0             	pushl  -0x10(%ebp)
c0104ba5:	e8 29 e1 ff ff       	call   c0102cd3 <free_pages>
c0104baa:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104bad:	83 ec 08             	sub    $0x8,%esp
c0104bb0:	6a 01                	push   $0x1
c0104bb2:	ff 75 f4             	pushl  -0xc(%ebp)
c0104bb5:	e8 19 e1 ff ff       	call   c0102cd3 <free_pages>
c0104bba:	83 c4 10             	add    $0x10,%esp
}
c0104bbd:	90                   	nop
c0104bbe:	c9                   	leave  
c0104bbf:	c3                   	ret    

c0104bc0 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104bc0:	f3 0f 1e fb          	endbr32 
c0104bc4:	55                   	push   %ebp
c0104bc5:	89 e5                	mov    %esp,%ebp
c0104bc7:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104bcd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104bd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104bdb:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104be2:	eb 60                	jmp    c0104c44 <default_check+0x84>
        struct Page *p = le2page(le, page_link);
c0104be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104be7:	83 e8 0c             	sub    $0xc,%eax
c0104bea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104bed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104bf0:	83 c0 04             	add    $0x4,%eax
c0104bf3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104bfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104bfd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104c00:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104c03:	0f a3 10             	bt     %edx,(%eax)
c0104c06:	19 c0                	sbb    %eax,%eax
c0104c08:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104c0b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104c0f:	0f 95 c0             	setne  %al
c0104c12:	0f b6 c0             	movzbl %al,%eax
c0104c15:	85 c0                	test   %eax,%eax
c0104c17:	75 19                	jne    c0104c32 <default_check+0x72>
c0104c19:	68 be 6b 10 c0       	push   $0xc0106bbe
c0104c1e:	68 be 69 10 c0       	push   $0xc01069be
c0104c23:	68 01 01 00 00       	push   $0x101
c0104c28:	68 d3 69 10 c0       	push   $0xc01069d3
c0104c2d:	e8 e4 b7 ff ff       	call   c0100416 <__panic>
        count ++, total += p->property;
c0104c32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104c36:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c39:	8b 50 08             	mov    0x8(%eax),%edx
c0104c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c3f:	01 d0                	add    %edx,%eax
c0104c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c47:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104c4a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c4d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104c50:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c53:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c0104c5a:	75 88                	jne    c0104be4 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c0104c5c:	e8 ab e0 ff ff       	call   c0102d0c <nr_free_pages>
c0104c61:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c64:	39 d0                	cmp    %edx,%eax
c0104c66:	74 19                	je     c0104c81 <default_check+0xc1>
c0104c68:	68 ce 6b 10 c0       	push   $0xc0106bce
c0104c6d:	68 be 69 10 c0       	push   $0xc01069be
c0104c72:	68 04 01 00 00       	push   $0x104
c0104c77:	68 d3 69 10 c0       	push   $0xc01069d3
c0104c7c:	e8 95 b7 ff ff       	call   c0100416 <__panic>

    basic_check();
c0104c81:	e8 c2 fa ff ff       	call   c0104748 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104c86:	83 ec 0c             	sub    $0xc,%esp
c0104c89:	6a 05                	push   $0x5
c0104c8b:	e8 01 e0 ff ff       	call   c0102c91 <alloc_pages>
c0104c90:	83 c4 10             	add    $0x10,%esp
c0104c93:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104c96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104c9a:	75 19                	jne    c0104cb5 <default_check+0xf5>
c0104c9c:	68 e7 6b 10 c0       	push   $0xc0106be7
c0104ca1:	68 be 69 10 c0       	push   $0xc01069be
c0104ca6:	68 09 01 00 00       	push   $0x109
c0104cab:	68 d3 69 10 c0       	push   $0xc01069d3
c0104cb0:	e8 61 b7 ff ff       	call   c0100416 <__panic>
    assert(!PageProperty(p0));
c0104cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cb8:	83 c0 04             	add    $0x4,%eax
c0104cbb:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104cc2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104cc5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104cc8:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104ccb:	0f a3 10             	bt     %edx,(%eax)
c0104cce:	19 c0                	sbb    %eax,%eax
c0104cd0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104cd3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104cd7:	0f 95 c0             	setne  %al
c0104cda:	0f b6 c0             	movzbl %al,%eax
c0104cdd:	85 c0                	test   %eax,%eax
c0104cdf:	74 19                	je     c0104cfa <default_check+0x13a>
c0104ce1:	68 f2 6b 10 c0       	push   $0xc0106bf2
c0104ce6:	68 be 69 10 c0       	push   $0xc01069be
c0104ceb:	68 0a 01 00 00       	push   $0x10a
c0104cf0:	68 d3 69 10 c0       	push   $0xc01069d3
c0104cf5:	e8 1c b7 ff ff       	call   c0100416 <__panic>

    list_entry_t free_list_store = free_list;
c0104cfa:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104cff:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104d05:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104d08:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104d0b:	c7 45 b0 1c cf 11 c0 	movl   $0xc011cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104d12:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d15:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104d18:	89 50 04             	mov    %edx,0x4(%eax)
c0104d1b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d1e:	8b 50 04             	mov    0x4(%eax),%edx
c0104d21:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104d24:	89 10                	mov    %edx,(%eax)
}
c0104d26:	90                   	nop
c0104d27:	c7 45 b4 1c cf 11 c0 	movl   $0xc011cf1c,-0x4c(%ebp)
    return list->next == list;
c0104d2e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104d31:	8b 40 04             	mov    0x4(%eax),%eax
c0104d34:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104d37:	0f 94 c0             	sete   %al
c0104d3a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104d3d:	85 c0                	test   %eax,%eax
c0104d3f:	75 19                	jne    c0104d5a <default_check+0x19a>
c0104d41:	68 47 6b 10 c0       	push   $0xc0106b47
c0104d46:	68 be 69 10 c0       	push   $0xc01069be
c0104d4b:	68 0e 01 00 00       	push   $0x10e
c0104d50:	68 d3 69 10 c0       	push   $0xc01069d3
c0104d55:	e8 bc b6 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0104d5a:	83 ec 0c             	sub    $0xc,%esp
c0104d5d:	6a 01                	push   $0x1
c0104d5f:	e8 2d df ff ff       	call   c0102c91 <alloc_pages>
c0104d64:	83 c4 10             	add    $0x10,%esp
c0104d67:	85 c0                	test   %eax,%eax
c0104d69:	74 19                	je     c0104d84 <default_check+0x1c4>
c0104d6b:	68 5e 6b 10 c0       	push   $0xc0106b5e
c0104d70:	68 be 69 10 c0       	push   $0xc01069be
c0104d75:	68 0f 01 00 00       	push   $0x10f
c0104d7a:	68 d3 69 10 c0       	push   $0xc01069d3
c0104d7f:	e8 92 b6 ff ff       	call   c0100416 <__panic>

    unsigned int nr_free_store = nr_free;
c0104d84:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104d8c:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104d93:	00 00 00 

    free_pages(p0 + 2, 3);
c0104d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d99:	83 c0 28             	add    $0x28,%eax
c0104d9c:	83 ec 08             	sub    $0x8,%esp
c0104d9f:	6a 03                	push   $0x3
c0104da1:	50                   	push   %eax
c0104da2:	e8 2c df ff ff       	call   c0102cd3 <free_pages>
c0104da7:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104daa:	83 ec 0c             	sub    $0xc,%esp
c0104dad:	6a 04                	push   $0x4
c0104daf:	e8 dd de ff ff       	call   c0102c91 <alloc_pages>
c0104db4:	83 c4 10             	add    $0x10,%esp
c0104db7:	85 c0                	test   %eax,%eax
c0104db9:	74 19                	je     c0104dd4 <default_check+0x214>
c0104dbb:	68 04 6c 10 c0       	push   $0xc0106c04
c0104dc0:	68 be 69 10 c0       	push   $0xc01069be
c0104dc5:	68 15 01 00 00       	push   $0x115
c0104dca:	68 d3 69 10 c0       	push   $0xc01069d3
c0104dcf:	e8 42 b6 ff ff       	call   c0100416 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dd7:	83 c0 28             	add    $0x28,%eax
c0104dda:	83 c0 04             	add    $0x4,%eax
c0104ddd:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104de4:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104de7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104dea:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104ded:	0f a3 10             	bt     %edx,(%eax)
c0104df0:	19 c0                	sbb    %eax,%eax
c0104df2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104df5:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104df9:	0f 95 c0             	setne  %al
c0104dfc:	0f b6 c0             	movzbl %al,%eax
c0104dff:	85 c0                	test   %eax,%eax
c0104e01:	74 0e                	je     c0104e11 <default_check+0x251>
c0104e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e06:	83 c0 28             	add    $0x28,%eax
c0104e09:	8b 40 08             	mov    0x8(%eax),%eax
c0104e0c:	83 f8 03             	cmp    $0x3,%eax
c0104e0f:	74 19                	je     c0104e2a <default_check+0x26a>
c0104e11:	68 1c 6c 10 c0       	push   $0xc0106c1c
c0104e16:	68 be 69 10 c0       	push   $0xc01069be
c0104e1b:	68 16 01 00 00       	push   $0x116
c0104e20:	68 d3 69 10 c0       	push   $0xc01069d3
c0104e25:	e8 ec b5 ff ff       	call   c0100416 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104e2a:	83 ec 0c             	sub    $0xc,%esp
c0104e2d:	6a 03                	push   $0x3
c0104e2f:	e8 5d de ff ff       	call   c0102c91 <alloc_pages>
c0104e34:	83 c4 10             	add    $0x10,%esp
c0104e37:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104e3e:	75 19                	jne    c0104e59 <default_check+0x299>
c0104e40:	68 48 6c 10 c0       	push   $0xc0106c48
c0104e45:	68 be 69 10 c0       	push   $0xc01069be
c0104e4a:	68 17 01 00 00       	push   $0x117
c0104e4f:	68 d3 69 10 c0       	push   $0xc01069d3
c0104e54:	e8 bd b5 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0104e59:	83 ec 0c             	sub    $0xc,%esp
c0104e5c:	6a 01                	push   $0x1
c0104e5e:	e8 2e de ff ff       	call   c0102c91 <alloc_pages>
c0104e63:	83 c4 10             	add    $0x10,%esp
c0104e66:	85 c0                	test   %eax,%eax
c0104e68:	74 19                	je     c0104e83 <default_check+0x2c3>
c0104e6a:	68 5e 6b 10 c0       	push   $0xc0106b5e
c0104e6f:	68 be 69 10 c0       	push   $0xc01069be
c0104e74:	68 18 01 00 00       	push   $0x118
c0104e79:	68 d3 69 10 c0       	push   $0xc01069d3
c0104e7e:	e8 93 b5 ff ff       	call   c0100416 <__panic>
    assert(p0 + 2 == p1);
c0104e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e86:	83 c0 28             	add    $0x28,%eax
c0104e89:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104e8c:	74 19                	je     c0104ea7 <default_check+0x2e7>
c0104e8e:	68 66 6c 10 c0       	push   $0xc0106c66
c0104e93:	68 be 69 10 c0       	push   $0xc01069be
c0104e98:	68 19 01 00 00       	push   $0x119
c0104e9d:	68 d3 69 10 c0       	push   $0xc01069d3
c0104ea2:	e8 6f b5 ff ff       	call   c0100416 <__panic>

    p2 = p0 + 1;
c0104ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eaa:	83 c0 14             	add    $0x14,%eax
c0104ead:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c0104eb0:	83 ec 08             	sub    $0x8,%esp
c0104eb3:	6a 01                	push   $0x1
c0104eb5:	ff 75 e8             	pushl  -0x18(%ebp)
c0104eb8:	e8 16 de ff ff       	call   c0102cd3 <free_pages>
c0104ebd:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104ec0:	83 ec 08             	sub    $0x8,%esp
c0104ec3:	6a 03                	push   $0x3
c0104ec5:	ff 75 e0             	pushl  -0x20(%ebp)
c0104ec8:	e8 06 de ff ff       	call   c0102cd3 <free_pages>
c0104ecd:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ed3:	83 c0 04             	add    $0x4,%eax
c0104ed6:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104edd:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ee0:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104ee3:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104ee6:	0f a3 10             	bt     %edx,(%eax)
c0104ee9:	19 c0                	sbb    %eax,%eax
c0104eeb:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104eee:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104ef2:	0f 95 c0             	setne  %al
c0104ef5:	0f b6 c0             	movzbl %al,%eax
c0104ef8:	85 c0                	test   %eax,%eax
c0104efa:	74 0b                	je     c0104f07 <default_check+0x347>
c0104efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eff:	8b 40 08             	mov    0x8(%eax),%eax
c0104f02:	83 f8 01             	cmp    $0x1,%eax
c0104f05:	74 19                	je     c0104f20 <default_check+0x360>
c0104f07:	68 74 6c 10 c0       	push   $0xc0106c74
c0104f0c:	68 be 69 10 c0       	push   $0xc01069be
c0104f11:	68 1e 01 00 00       	push   $0x11e
c0104f16:	68 d3 69 10 c0       	push   $0xc01069d3
c0104f1b:	e8 f6 b4 ff ff       	call   c0100416 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f23:	83 c0 04             	add    $0x4,%eax
c0104f26:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104f2d:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f30:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104f33:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104f36:	0f a3 10             	bt     %edx,(%eax)
c0104f39:	19 c0                	sbb    %eax,%eax
c0104f3b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104f3e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104f42:	0f 95 c0             	setne  %al
c0104f45:	0f b6 c0             	movzbl %al,%eax
c0104f48:	85 c0                	test   %eax,%eax
c0104f4a:	74 0b                	je     c0104f57 <default_check+0x397>
c0104f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f4f:	8b 40 08             	mov    0x8(%eax),%eax
c0104f52:	83 f8 03             	cmp    $0x3,%eax
c0104f55:	74 19                	je     c0104f70 <default_check+0x3b0>
c0104f57:	68 9c 6c 10 c0       	push   $0xc0106c9c
c0104f5c:	68 be 69 10 c0       	push   $0xc01069be
c0104f61:	68 1f 01 00 00       	push   $0x11f
c0104f66:	68 d3 69 10 c0       	push   $0xc01069d3
c0104f6b:	e8 a6 b4 ff ff       	call   c0100416 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104f70:	83 ec 0c             	sub    $0xc,%esp
c0104f73:	6a 01                	push   $0x1
c0104f75:	e8 17 dd ff ff       	call   c0102c91 <alloc_pages>
c0104f7a:	83 c4 10             	add    $0x10,%esp
c0104f7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f83:	83 e8 14             	sub    $0x14,%eax
c0104f86:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104f89:	74 19                	je     c0104fa4 <default_check+0x3e4>
c0104f8b:	68 c2 6c 10 c0       	push   $0xc0106cc2
c0104f90:	68 be 69 10 c0       	push   $0xc01069be
c0104f95:	68 21 01 00 00       	push   $0x121
c0104f9a:	68 d3 69 10 c0       	push   $0xc01069d3
c0104f9f:	e8 72 b4 ff ff       	call   c0100416 <__panic>
    free_page(p0);
c0104fa4:	83 ec 08             	sub    $0x8,%esp
c0104fa7:	6a 01                	push   $0x1
c0104fa9:	ff 75 e8             	pushl  -0x18(%ebp)
c0104fac:	e8 22 dd ff ff       	call   c0102cd3 <free_pages>
c0104fb1:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104fb4:	83 ec 0c             	sub    $0xc,%esp
c0104fb7:	6a 02                	push   $0x2
c0104fb9:	e8 d3 dc ff ff       	call   c0102c91 <alloc_pages>
c0104fbe:	83 c4 10             	add    $0x10,%esp
c0104fc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104fc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104fc7:	83 c0 14             	add    $0x14,%eax
c0104fca:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104fcd:	74 19                	je     c0104fe8 <default_check+0x428>
c0104fcf:	68 e0 6c 10 c0       	push   $0xc0106ce0
c0104fd4:	68 be 69 10 c0       	push   $0xc01069be
c0104fd9:	68 23 01 00 00       	push   $0x123
c0104fde:	68 d3 69 10 c0       	push   $0xc01069d3
c0104fe3:	e8 2e b4 ff ff       	call   c0100416 <__panic>

    free_pages(p0, 2);
c0104fe8:	83 ec 08             	sub    $0x8,%esp
c0104feb:	6a 02                	push   $0x2
c0104fed:	ff 75 e8             	pushl  -0x18(%ebp)
c0104ff0:	e8 de dc ff ff       	call   c0102cd3 <free_pages>
c0104ff5:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104ff8:	83 ec 08             	sub    $0x8,%esp
c0104ffb:	6a 01                	push   $0x1
c0104ffd:	ff 75 dc             	pushl  -0x24(%ebp)
c0105000:	e8 ce dc ff ff       	call   c0102cd3 <free_pages>
c0105005:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0105008:	83 ec 0c             	sub    $0xc,%esp
c010500b:	6a 05                	push   $0x5
c010500d:	e8 7f dc ff ff       	call   c0102c91 <alloc_pages>
c0105012:	83 c4 10             	add    $0x10,%esp
c0105015:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105018:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010501c:	75 19                	jne    c0105037 <default_check+0x477>
c010501e:	68 00 6d 10 c0       	push   $0xc0106d00
c0105023:	68 be 69 10 c0       	push   $0xc01069be
c0105028:	68 28 01 00 00       	push   $0x128
c010502d:	68 d3 69 10 c0       	push   $0xc01069d3
c0105032:	e8 df b3 ff ff       	call   c0100416 <__panic>
    assert(alloc_page() == NULL);
c0105037:	83 ec 0c             	sub    $0xc,%esp
c010503a:	6a 01                	push   $0x1
c010503c:	e8 50 dc ff ff       	call   c0102c91 <alloc_pages>
c0105041:	83 c4 10             	add    $0x10,%esp
c0105044:	85 c0                	test   %eax,%eax
c0105046:	74 19                	je     c0105061 <default_check+0x4a1>
c0105048:	68 5e 6b 10 c0       	push   $0xc0106b5e
c010504d:	68 be 69 10 c0       	push   $0xc01069be
c0105052:	68 29 01 00 00       	push   $0x129
c0105057:	68 d3 69 10 c0       	push   $0xc01069d3
c010505c:	e8 b5 b3 ff ff       	call   c0100416 <__panic>

    assert(nr_free == 0);
c0105061:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0105066:	85 c0                	test   %eax,%eax
c0105068:	74 19                	je     c0105083 <default_check+0x4c3>
c010506a:	68 b1 6b 10 c0       	push   $0xc0106bb1
c010506f:	68 be 69 10 c0       	push   $0xc01069be
c0105074:	68 2b 01 00 00       	push   $0x12b
c0105079:	68 d3 69 10 c0       	push   $0xc01069d3
c010507e:	e8 93 b3 ff ff       	call   c0100416 <__panic>
    nr_free = nr_free_store;
c0105083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105086:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_list = free_list_store;
c010508b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010508e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105091:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0105096:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    free_pages(p0, 5);
c010509c:	83 ec 08             	sub    $0x8,%esp
c010509f:	6a 05                	push   $0x5
c01050a1:	ff 75 e8             	pushl  -0x18(%ebp)
c01050a4:	e8 2a dc ff ff       	call   c0102cd3 <free_pages>
c01050a9:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c01050ac:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01050b3:	eb 1d                	jmp    c01050d2 <default_check+0x512>
        struct Page *p = le2page(le, page_link);
c01050b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050b8:	83 e8 0c             	sub    $0xc,%eax
c01050bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c01050be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01050c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01050c8:	8b 40 08             	mov    0x8(%eax),%eax
c01050cb:	29 c2                	sub    %eax,%edx
c01050cd:	89 d0                	mov    %edx,%eax
c01050cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050d5:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01050d8:	8b 45 88             	mov    -0x78(%ebp),%eax
c01050db:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01050de:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050e1:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c01050e8:	75 cb                	jne    c01050b5 <default_check+0x4f5>
    }
    assert(count == 0);
c01050ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050ee:	74 19                	je     c0105109 <default_check+0x549>
c01050f0:	68 1e 6d 10 c0       	push   $0xc0106d1e
c01050f5:	68 be 69 10 c0       	push   $0xc01069be
c01050fa:	68 36 01 00 00       	push   $0x136
c01050ff:	68 d3 69 10 c0       	push   $0xc01069d3
c0105104:	e8 0d b3 ff ff       	call   c0100416 <__panic>
    assert(total == 0);
c0105109:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010510d:	74 19                	je     c0105128 <default_check+0x568>
c010510f:	68 29 6d 10 c0       	push   $0xc0106d29
c0105114:	68 be 69 10 c0       	push   $0xc01069be
c0105119:	68 37 01 00 00       	push   $0x137
c010511e:	68 d3 69 10 c0       	push   $0xc01069d3
c0105123:	e8 ee b2 ff ff       	call   c0100416 <__panic>
}
c0105128:	90                   	nop
c0105129:	c9                   	leave  
c010512a:	c3                   	ret    

c010512b <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010512b:	f3 0f 1e fb          	endbr32 
c010512f:	55                   	push   %ebp
c0105130:	89 e5                	mov    %esp,%ebp
c0105132:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010513c:	eb 04                	jmp    c0105142 <strlen+0x17>
        cnt ++;
c010513e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105142:	8b 45 08             	mov    0x8(%ebp),%eax
c0105145:	8d 50 01             	lea    0x1(%eax),%edx
c0105148:	89 55 08             	mov    %edx,0x8(%ebp)
c010514b:	0f b6 00             	movzbl (%eax),%eax
c010514e:	84 c0                	test   %al,%al
c0105150:	75 ec                	jne    c010513e <strlen+0x13>
    }
    return cnt;
c0105152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105155:	c9                   	leave  
c0105156:	c3                   	ret    

c0105157 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105157:	f3 0f 1e fb          	endbr32 
c010515b:	55                   	push   %ebp
c010515c:	89 e5                	mov    %esp,%ebp
c010515e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105168:	eb 04                	jmp    c010516e <strnlen+0x17>
        cnt ++;
c010516a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010516e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105171:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105174:	73 10                	jae    c0105186 <strnlen+0x2f>
c0105176:	8b 45 08             	mov    0x8(%ebp),%eax
c0105179:	8d 50 01             	lea    0x1(%eax),%edx
c010517c:	89 55 08             	mov    %edx,0x8(%ebp)
c010517f:	0f b6 00             	movzbl (%eax),%eax
c0105182:	84 c0                	test   %al,%al
c0105184:	75 e4                	jne    c010516a <strnlen+0x13>
    }
    return cnt;
c0105186:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105189:	c9                   	leave  
c010518a:	c3                   	ret    

c010518b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010518b:	f3 0f 1e fb          	endbr32 
c010518f:	55                   	push   %ebp
c0105190:	89 e5                	mov    %esp,%ebp
c0105192:	57                   	push   %edi
c0105193:	56                   	push   %esi
c0105194:	83 ec 20             	sub    $0x20,%esp
c0105197:	8b 45 08             	mov    0x8(%ebp),%eax
c010519a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010519d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01051a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01051a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051a9:	89 d1                	mov    %edx,%ecx
c01051ab:	89 c2                	mov    %eax,%edx
c01051ad:	89 ce                	mov    %ecx,%esi
c01051af:	89 d7                	mov    %edx,%edi
c01051b1:	ac                   	lods   %ds:(%esi),%al
c01051b2:	aa                   	stos   %al,%es:(%edi)
c01051b3:	84 c0                	test   %al,%al
c01051b5:	75 fa                	jne    c01051b1 <strcpy+0x26>
c01051b7:	89 fa                	mov    %edi,%edx
c01051b9:	89 f1                	mov    %esi,%ecx
c01051bb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01051be:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01051c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01051c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01051c7:	83 c4 20             	add    $0x20,%esp
c01051ca:	5e                   	pop    %esi
c01051cb:	5f                   	pop    %edi
c01051cc:	5d                   	pop    %ebp
c01051cd:	c3                   	ret    

c01051ce <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01051ce:	f3 0f 1e fb          	endbr32 
c01051d2:	55                   	push   %ebp
c01051d3:	89 e5                	mov    %esp,%ebp
c01051d5:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01051d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01051db:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01051de:	eb 21                	jmp    c0105201 <strncpy+0x33>
        if ((*p = *src) != '\0') {
c01051e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051e3:	0f b6 10             	movzbl (%eax),%edx
c01051e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051e9:	88 10                	mov    %dl,(%eax)
c01051eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051ee:	0f b6 00             	movzbl (%eax),%eax
c01051f1:	84 c0                	test   %al,%al
c01051f3:	74 04                	je     c01051f9 <strncpy+0x2b>
            src ++;
c01051f5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01051f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01051fd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105201:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105205:	75 d9                	jne    c01051e0 <strncpy+0x12>
    }
    return dst;
c0105207:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010520a:	c9                   	leave  
c010520b:	c3                   	ret    

c010520c <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010520c:	f3 0f 1e fb          	endbr32 
c0105210:	55                   	push   %ebp
c0105211:	89 e5                	mov    %esp,%ebp
c0105213:	57                   	push   %edi
c0105214:	56                   	push   %esi
c0105215:	83 ec 20             	sub    $0x20,%esp
c0105218:	8b 45 08             	mov    0x8(%ebp),%eax
c010521b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010521e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105221:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105224:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105227:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010522a:	89 d1                	mov    %edx,%ecx
c010522c:	89 c2                	mov    %eax,%edx
c010522e:	89 ce                	mov    %ecx,%esi
c0105230:	89 d7                	mov    %edx,%edi
c0105232:	ac                   	lods   %ds:(%esi),%al
c0105233:	ae                   	scas   %es:(%edi),%al
c0105234:	75 08                	jne    c010523e <strcmp+0x32>
c0105236:	84 c0                	test   %al,%al
c0105238:	75 f8                	jne    c0105232 <strcmp+0x26>
c010523a:	31 c0                	xor    %eax,%eax
c010523c:	eb 04                	jmp    c0105242 <strcmp+0x36>
c010523e:	19 c0                	sbb    %eax,%eax
c0105240:	0c 01                	or     $0x1,%al
c0105242:	89 fa                	mov    %edi,%edx
c0105244:	89 f1                	mov    %esi,%ecx
c0105246:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105249:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010524c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c010524f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105252:	83 c4 20             	add    $0x20,%esp
c0105255:	5e                   	pop    %esi
c0105256:	5f                   	pop    %edi
c0105257:	5d                   	pop    %ebp
c0105258:	c3                   	ret    

c0105259 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105259:	f3 0f 1e fb          	endbr32 
c010525d:	55                   	push   %ebp
c010525e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105260:	eb 0c                	jmp    c010526e <strncmp+0x15>
        n --, s1 ++, s2 ++;
c0105262:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105266:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010526a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010526e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105272:	74 1a                	je     c010528e <strncmp+0x35>
c0105274:	8b 45 08             	mov    0x8(%ebp),%eax
c0105277:	0f b6 00             	movzbl (%eax),%eax
c010527a:	84 c0                	test   %al,%al
c010527c:	74 10                	je     c010528e <strncmp+0x35>
c010527e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105281:	0f b6 10             	movzbl (%eax),%edx
c0105284:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105287:	0f b6 00             	movzbl (%eax),%eax
c010528a:	38 c2                	cmp    %al,%dl
c010528c:	74 d4                	je     c0105262 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010528e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105292:	74 18                	je     c01052ac <strncmp+0x53>
c0105294:	8b 45 08             	mov    0x8(%ebp),%eax
c0105297:	0f b6 00             	movzbl (%eax),%eax
c010529a:	0f b6 d0             	movzbl %al,%edx
c010529d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a0:	0f b6 00             	movzbl (%eax),%eax
c01052a3:	0f b6 c0             	movzbl %al,%eax
c01052a6:	29 c2                	sub    %eax,%edx
c01052a8:	89 d0                	mov    %edx,%eax
c01052aa:	eb 05                	jmp    c01052b1 <strncmp+0x58>
c01052ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052b1:	5d                   	pop    %ebp
c01052b2:	c3                   	ret    

c01052b3 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01052b3:	f3 0f 1e fb          	endbr32 
c01052b7:	55                   	push   %ebp
c01052b8:	89 e5                	mov    %esp,%ebp
c01052ba:	83 ec 04             	sub    $0x4,%esp
c01052bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052c0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052c3:	eb 14                	jmp    c01052d9 <strchr+0x26>
        if (*s == c) {
c01052c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c8:	0f b6 00             	movzbl (%eax),%eax
c01052cb:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01052ce:	75 05                	jne    c01052d5 <strchr+0x22>
            return (char *)s;
c01052d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d3:	eb 13                	jmp    c01052e8 <strchr+0x35>
        }
        s ++;
c01052d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01052d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052dc:	0f b6 00             	movzbl (%eax),%eax
c01052df:	84 c0                	test   %al,%al
c01052e1:	75 e2                	jne    c01052c5 <strchr+0x12>
    }
    return NULL;
c01052e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052e8:	c9                   	leave  
c01052e9:	c3                   	ret    

c01052ea <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01052ea:	f3 0f 1e fb          	endbr32 
c01052ee:	55                   	push   %ebp
c01052ef:	89 e5                	mov    %esp,%ebp
c01052f1:	83 ec 04             	sub    $0x4,%esp
c01052f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052f7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052fa:	eb 0f                	jmp    c010530b <strfind+0x21>
        if (*s == c) {
c01052fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ff:	0f b6 00             	movzbl (%eax),%eax
c0105302:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105305:	74 10                	je     c0105317 <strfind+0x2d>
            break;
        }
        s ++;
c0105307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010530b:	8b 45 08             	mov    0x8(%ebp),%eax
c010530e:	0f b6 00             	movzbl (%eax),%eax
c0105311:	84 c0                	test   %al,%al
c0105313:	75 e7                	jne    c01052fc <strfind+0x12>
c0105315:	eb 01                	jmp    c0105318 <strfind+0x2e>
            break;
c0105317:	90                   	nop
    }
    return (char *)s;
c0105318:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010531b:	c9                   	leave  
c010531c:	c3                   	ret    

c010531d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010531d:	f3 0f 1e fb          	endbr32 
c0105321:	55                   	push   %ebp
c0105322:	89 e5                	mov    %esp,%ebp
c0105324:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105327:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010532e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105335:	eb 04                	jmp    c010533b <strtol+0x1e>
        s ++;
c0105337:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c010533b:	8b 45 08             	mov    0x8(%ebp),%eax
c010533e:	0f b6 00             	movzbl (%eax),%eax
c0105341:	3c 20                	cmp    $0x20,%al
c0105343:	74 f2                	je     c0105337 <strtol+0x1a>
c0105345:	8b 45 08             	mov    0x8(%ebp),%eax
c0105348:	0f b6 00             	movzbl (%eax),%eax
c010534b:	3c 09                	cmp    $0x9,%al
c010534d:	74 e8                	je     c0105337 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c010534f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105352:	0f b6 00             	movzbl (%eax),%eax
c0105355:	3c 2b                	cmp    $0x2b,%al
c0105357:	75 06                	jne    c010535f <strtol+0x42>
        s ++;
c0105359:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010535d:	eb 15                	jmp    c0105374 <strtol+0x57>
    }
    else if (*s == '-') {
c010535f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105362:	0f b6 00             	movzbl (%eax),%eax
c0105365:	3c 2d                	cmp    $0x2d,%al
c0105367:	75 0b                	jne    c0105374 <strtol+0x57>
        s ++, neg = 1;
c0105369:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010536d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105374:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105378:	74 06                	je     c0105380 <strtol+0x63>
c010537a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010537e:	75 24                	jne    c01053a4 <strtol+0x87>
c0105380:	8b 45 08             	mov    0x8(%ebp),%eax
c0105383:	0f b6 00             	movzbl (%eax),%eax
c0105386:	3c 30                	cmp    $0x30,%al
c0105388:	75 1a                	jne    c01053a4 <strtol+0x87>
c010538a:	8b 45 08             	mov    0x8(%ebp),%eax
c010538d:	83 c0 01             	add    $0x1,%eax
c0105390:	0f b6 00             	movzbl (%eax),%eax
c0105393:	3c 78                	cmp    $0x78,%al
c0105395:	75 0d                	jne    c01053a4 <strtol+0x87>
        s += 2, base = 16;
c0105397:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010539b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01053a2:	eb 2a                	jmp    c01053ce <strtol+0xb1>
    }
    else if (base == 0 && s[0] == '0') {
c01053a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053a8:	75 17                	jne    c01053c1 <strtol+0xa4>
c01053aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ad:	0f b6 00             	movzbl (%eax),%eax
c01053b0:	3c 30                	cmp    $0x30,%al
c01053b2:	75 0d                	jne    c01053c1 <strtol+0xa4>
        s ++, base = 8;
c01053b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01053b8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01053bf:	eb 0d                	jmp    c01053ce <strtol+0xb1>
    }
    else if (base == 0) {
c01053c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01053c5:	75 07                	jne    c01053ce <strtol+0xb1>
        base = 10;
c01053c7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01053ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d1:	0f b6 00             	movzbl (%eax),%eax
c01053d4:	3c 2f                	cmp    $0x2f,%al
c01053d6:	7e 1b                	jle    c01053f3 <strtol+0xd6>
c01053d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053db:	0f b6 00             	movzbl (%eax),%eax
c01053de:	3c 39                	cmp    $0x39,%al
c01053e0:	7f 11                	jg     c01053f3 <strtol+0xd6>
            dig = *s - '0';
c01053e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e5:	0f b6 00             	movzbl (%eax),%eax
c01053e8:	0f be c0             	movsbl %al,%eax
c01053eb:	83 e8 30             	sub    $0x30,%eax
c01053ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053f1:	eb 48                	jmp    c010543b <strtol+0x11e>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01053f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f6:	0f b6 00             	movzbl (%eax),%eax
c01053f9:	3c 60                	cmp    $0x60,%al
c01053fb:	7e 1b                	jle    c0105418 <strtol+0xfb>
c01053fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105400:	0f b6 00             	movzbl (%eax),%eax
c0105403:	3c 7a                	cmp    $0x7a,%al
c0105405:	7f 11                	jg     c0105418 <strtol+0xfb>
            dig = *s - 'a' + 10;
c0105407:	8b 45 08             	mov    0x8(%ebp),%eax
c010540a:	0f b6 00             	movzbl (%eax),%eax
c010540d:	0f be c0             	movsbl %al,%eax
c0105410:	83 e8 57             	sub    $0x57,%eax
c0105413:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105416:	eb 23                	jmp    c010543b <strtol+0x11e>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105418:	8b 45 08             	mov    0x8(%ebp),%eax
c010541b:	0f b6 00             	movzbl (%eax),%eax
c010541e:	3c 40                	cmp    $0x40,%al
c0105420:	7e 3c                	jle    c010545e <strtol+0x141>
c0105422:	8b 45 08             	mov    0x8(%ebp),%eax
c0105425:	0f b6 00             	movzbl (%eax),%eax
c0105428:	3c 5a                	cmp    $0x5a,%al
c010542a:	7f 32                	jg     c010545e <strtol+0x141>
            dig = *s - 'A' + 10;
c010542c:	8b 45 08             	mov    0x8(%ebp),%eax
c010542f:	0f b6 00             	movzbl (%eax),%eax
c0105432:	0f be c0             	movsbl %al,%eax
c0105435:	83 e8 37             	sub    $0x37,%eax
c0105438:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010543b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010543e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105441:	7d 1a                	jge    c010545d <strtol+0x140>
            break;
        }
        s ++, val = (val * base) + dig;
c0105443:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105447:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010544a:	0f af 45 10          	imul   0x10(%ebp),%eax
c010544e:	89 c2                	mov    %eax,%edx
c0105450:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105453:	01 d0                	add    %edx,%eax
c0105455:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105458:	e9 71 ff ff ff       	jmp    c01053ce <strtol+0xb1>
            break;
c010545d:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c010545e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105462:	74 08                	je     c010546c <strtol+0x14f>
        *endptr = (char *) s;
c0105464:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105467:	8b 55 08             	mov    0x8(%ebp),%edx
c010546a:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010546c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105470:	74 07                	je     c0105479 <strtol+0x15c>
c0105472:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105475:	f7 d8                	neg    %eax
c0105477:	eb 03                	jmp    c010547c <strtol+0x15f>
c0105479:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010547c:	c9                   	leave  
c010547d:	c3                   	ret    

c010547e <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010547e:	f3 0f 1e fb          	endbr32 
c0105482:	55                   	push   %ebp
c0105483:	89 e5                	mov    %esp,%ebp
c0105485:	57                   	push   %edi
c0105486:	83 ec 24             	sub    $0x24,%esp
c0105489:	8b 45 0c             	mov    0xc(%ebp),%eax
c010548c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010548f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105493:	8b 55 08             	mov    0x8(%ebp),%edx
c0105496:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105499:	88 45 f7             	mov    %al,-0x9(%ebp)
c010549c:	8b 45 10             	mov    0x10(%ebp),%eax
c010549f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01054a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01054a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01054a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01054ac:	89 d7                	mov    %edx,%edi
c01054ae:	f3 aa                	rep stos %al,%es:(%edi)
c01054b0:	89 fa                	mov    %edi,%edx
c01054b2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01054b5:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01054b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01054bb:	83 c4 24             	add    $0x24,%esp
c01054be:	5f                   	pop    %edi
c01054bf:	5d                   	pop    %ebp
c01054c0:	c3                   	ret    

c01054c1 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01054c1:	f3 0f 1e fb          	endbr32 
c01054c5:	55                   	push   %ebp
c01054c6:	89 e5                	mov    %esp,%ebp
c01054c8:	57                   	push   %edi
c01054c9:	56                   	push   %esi
c01054ca:	53                   	push   %ebx
c01054cb:	83 ec 30             	sub    $0x30,%esp
c01054ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01054d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054da:	8b 45 10             	mov    0x10(%ebp),%eax
c01054dd:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01054e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01054e6:	73 42                	jae    c010552a <memmove+0x69>
c01054e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01054fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054fd:	c1 e8 02             	shr    $0x2,%eax
c0105500:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105502:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105505:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105508:	89 d7                	mov    %edx,%edi
c010550a:	89 c6                	mov    %eax,%esi
c010550c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010550e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105511:	83 e1 03             	and    $0x3,%ecx
c0105514:	74 02                	je     c0105518 <memmove+0x57>
c0105516:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105518:	89 f0                	mov    %esi,%eax
c010551a:	89 fa                	mov    %edi,%edx
c010551c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010551f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105522:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105528:	eb 36                	jmp    c0105560 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010552a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010552d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105530:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105533:	01 c2                	add    %eax,%edx
c0105535:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105538:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010553b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010553e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105541:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105544:	89 c1                	mov    %eax,%ecx
c0105546:	89 d8                	mov    %ebx,%eax
c0105548:	89 d6                	mov    %edx,%esi
c010554a:	89 c7                	mov    %eax,%edi
c010554c:	fd                   	std    
c010554d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010554f:	fc                   	cld    
c0105550:	89 f8                	mov    %edi,%eax
c0105552:	89 f2                	mov    %esi,%edx
c0105554:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105557:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010555a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010555d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105560:	83 c4 30             	add    $0x30,%esp
c0105563:	5b                   	pop    %ebx
c0105564:	5e                   	pop    %esi
c0105565:	5f                   	pop    %edi
c0105566:	5d                   	pop    %ebp
c0105567:	c3                   	ret    

c0105568 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105568:	f3 0f 1e fb          	endbr32 
c010556c:	55                   	push   %ebp
c010556d:	89 e5                	mov    %esp,%ebp
c010556f:	57                   	push   %edi
c0105570:	56                   	push   %esi
c0105571:	83 ec 20             	sub    $0x20,%esp
c0105574:	8b 45 08             	mov    0x8(%ebp),%eax
c0105577:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010557a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010557d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105580:	8b 45 10             	mov    0x10(%ebp),%eax
c0105583:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105586:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105589:	c1 e8 02             	shr    $0x2,%eax
c010558c:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010558e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105594:	89 d7                	mov    %edx,%edi
c0105596:	89 c6                	mov    %eax,%esi
c0105598:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010559a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010559d:	83 e1 03             	and    $0x3,%ecx
c01055a0:	74 02                	je     c01055a4 <memcpy+0x3c>
c01055a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01055a4:	89 f0                	mov    %esi,%eax
c01055a6:	89 fa                	mov    %edi,%edx
c01055a8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01055ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01055ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01055b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01055b4:	83 c4 20             	add    $0x20,%esp
c01055b7:	5e                   	pop    %esi
c01055b8:	5f                   	pop    %edi
c01055b9:	5d                   	pop    %ebp
c01055ba:	c3                   	ret    

c01055bb <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01055bb:	f3 0f 1e fb          	endbr32 
c01055bf:	55                   	push   %ebp
c01055c0:	89 e5                	mov    %esp,%ebp
c01055c2:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01055c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01055cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01055d1:	eb 30                	jmp    c0105603 <memcmp+0x48>
        if (*s1 != *s2) {
c01055d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055d6:	0f b6 10             	movzbl (%eax),%edx
c01055d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055dc:	0f b6 00             	movzbl (%eax),%eax
c01055df:	38 c2                	cmp    %al,%dl
c01055e1:	74 18                	je     c01055fb <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01055e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055e6:	0f b6 00             	movzbl (%eax),%eax
c01055e9:	0f b6 d0             	movzbl %al,%edx
c01055ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01055ef:	0f b6 00             	movzbl (%eax),%eax
c01055f2:	0f b6 c0             	movzbl %al,%eax
c01055f5:	29 c2                	sub    %eax,%edx
c01055f7:	89 d0                	mov    %edx,%eax
c01055f9:	eb 1a                	jmp    c0105615 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c01055fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01055ff:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105603:	8b 45 10             	mov    0x10(%ebp),%eax
c0105606:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105609:	89 55 10             	mov    %edx,0x10(%ebp)
c010560c:	85 c0                	test   %eax,%eax
c010560e:	75 c3                	jne    c01055d3 <memcmp+0x18>
    }
    return 0;
c0105610:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105615:	c9                   	leave  
c0105616:	c3                   	ret    

c0105617 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105617:	f3 0f 1e fb          	endbr32 
c010561b:	55                   	push   %ebp
c010561c:	89 e5                	mov    %esp,%ebp
c010561e:	83 ec 38             	sub    $0x38,%esp
c0105621:	8b 45 10             	mov    0x10(%ebp),%eax
c0105624:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105627:	8b 45 14             	mov    0x14(%ebp),%eax
c010562a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010562d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105630:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105633:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105636:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105639:	8b 45 18             	mov    0x18(%ebp),%eax
c010563c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010563f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105642:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105645:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105648:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010564b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010564e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105651:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105655:	74 1c                	je     c0105673 <printnum+0x5c>
c0105657:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010565a:	ba 00 00 00 00       	mov    $0x0,%edx
c010565f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105662:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105665:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105668:	ba 00 00 00 00       	mov    $0x0,%edx
c010566d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105670:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105673:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105676:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105679:	f7 75 e4             	divl   -0x1c(%ebp)
c010567c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010567f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105682:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105685:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105688:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010568b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010568e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105691:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105694:	8b 45 18             	mov    0x18(%ebp),%eax
c0105697:	ba 00 00 00 00       	mov    $0x0,%edx
c010569c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010569f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01056a2:	19 d1                	sbb    %edx,%ecx
c01056a4:	72 37                	jb     c01056dd <printnum+0xc6>
        printnum(putch, putdat, result, base, width - 1, padc);
c01056a6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01056a9:	83 e8 01             	sub    $0x1,%eax
c01056ac:	83 ec 04             	sub    $0x4,%esp
c01056af:	ff 75 20             	pushl  0x20(%ebp)
c01056b2:	50                   	push   %eax
c01056b3:	ff 75 18             	pushl  0x18(%ebp)
c01056b6:	ff 75 ec             	pushl  -0x14(%ebp)
c01056b9:	ff 75 e8             	pushl  -0x18(%ebp)
c01056bc:	ff 75 0c             	pushl  0xc(%ebp)
c01056bf:	ff 75 08             	pushl  0x8(%ebp)
c01056c2:	e8 50 ff ff ff       	call   c0105617 <printnum>
c01056c7:	83 c4 20             	add    $0x20,%esp
c01056ca:	eb 1b                	jmp    c01056e7 <printnum+0xd0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056cc:	83 ec 08             	sub    $0x8,%esp
c01056cf:	ff 75 0c             	pushl  0xc(%ebp)
c01056d2:	ff 75 20             	pushl  0x20(%ebp)
c01056d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d8:	ff d0                	call   *%eax
c01056da:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c01056dd:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01056e1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056e5:	7f e5                	jg     c01056cc <printnum+0xb5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056ea:	05 e4 6d 10 c0       	add    $0xc0106de4,%eax
c01056ef:	0f b6 00             	movzbl (%eax),%eax
c01056f2:	0f be c0             	movsbl %al,%eax
c01056f5:	83 ec 08             	sub    $0x8,%esp
c01056f8:	ff 75 0c             	pushl  0xc(%ebp)
c01056fb:	50                   	push   %eax
c01056fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ff:	ff d0                	call   *%eax
c0105701:	83 c4 10             	add    $0x10,%esp
}
c0105704:	90                   	nop
c0105705:	c9                   	leave  
c0105706:	c3                   	ret    

c0105707 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105707:	f3 0f 1e fb          	endbr32 
c010570b:	55                   	push   %ebp
c010570c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010570e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105712:	7e 14                	jle    c0105728 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0105714:	8b 45 08             	mov    0x8(%ebp),%eax
c0105717:	8b 00                	mov    (%eax),%eax
c0105719:	8d 48 08             	lea    0x8(%eax),%ecx
c010571c:	8b 55 08             	mov    0x8(%ebp),%edx
c010571f:	89 0a                	mov    %ecx,(%edx)
c0105721:	8b 50 04             	mov    0x4(%eax),%edx
c0105724:	8b 00                	mov    (%eax),%eax
c0105726:	eb 30                	jmp    c0105758 <getuint+0x51>
    }
    else if (lflag) {
c0105728:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010572c:	74 16                	je     c0105744 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c010572e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105731:	8b 00                	mov    (%eax),%eax
c0105733:	8d 48 04             	lea    0x4(%eax),%ecx
c0105736:	8b 55 08             	mov    0x8(%ebp),%edx
c0105739:	89 0a                	mov    %ecx,(%edx)
c010573b:	8b 00                	mov    (%eax),%eax
c010573d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105742:	eb 14                	jmp    c0105758 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105744:	8b 45 08             	mov    0x8(%ebp),%eax
c0105747:	8b 00                	mov    (%eax),%eax
c0105749:	8d 48 04             	lea    0x4(%eax),%ecx
c010574c:	8b 55 08             	mov    0x8(%ebp),%edx
c010574f:	89 0a                	mov    %ecx,(%edx)
c0105751:	8b 00                	mov    (%eax),%eax
c0105753:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105758:	5d                   	pop    %ebp
c0105759:	c3                   	ret    

c010575a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010575a:	f3 0f 1e fb          	endbr32 
c010575e:	55                   	push   %ebp
c010575f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105761:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105765:	7e 14                	jle    c010577b <getint+0x21>
        return va_arg(*ap, long long);
c0105767:	8b 45 08             	mov    0x8(%ebp),%eax
c010576a:	8b 00                	mov    (%eax),%eax
c010576c:	8d 48 08             	lea    0x8(%eax),%ecx
c010576f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105772:	89 0a                	mov    %ecx,(%edx)
c0105774:	8b 50 04             	mov    0x4(%eax),%edx
c0105777:	8b 00                	mov    (%eax),%eax
c0105779:	eb 28                	jmp    c01057a3 <getint+0x49>
    }
    else if (lflag) {
c010577b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010577f:	74 12                	je     c0105793 <getint+0x39>
        return va_arg(*ap, long);
c0105781:	8b 45 08             	mov    0x8(%ebp),%eax
c0105784:	8b 00                	mov    (%eax),%eax
c0105786:	8d 48 04             	lea    0x4(%eax),%ecx
c0105789:	8b 55 08             	mov    0x8(%ebp),%edx
c010578c:	89 0a                	mov    %ecx,(%edx)
c010578e:	8b 00                	mov    (%eax),%eax
c0105790:	99                   	cltd   
c0105791:	eb 10                	jmp    c01057a3 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0105793:	8b 45 08             	mov    0x8(%ebp),%eax
c0105796:	8b 00                	mov    (%eax),%eax
c0105798:	8d 48 04             	lea    0x4(%eax),%ecx
c010579b:	8b 55 08             	mov    0x8(%ebp),%edx
c010579e:	89 0a                	mov    %ecx,(%edx)
c01057a0:	8b 00                	mov    (%eax),%eax
c01057a2:	99                   	cltd   
    }
}
c01057a3:	5d                   	pop    %ebp
c01057a4:	c3                   	ret    

c01057a5 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01057a5:	f3 0f 1e fb          	endbr32 
c01057a9:	55                   	push   %ebp
c01057aa:	89 e5                	mov    %esp,%ebp
c01057ac:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01057af:	8d 45 14             	lea    0x14(%ebp),%eax
c01057b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01057b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057b8:	50                   	push   %eax
c01057b9:	ff 75 10             	pushl  0x10(%ebp)
c01057bc:	ff 75 0c             	pushl  0xc(%ebp)
c01057bf:	ff 75 08             	pushl  0x8(%ebp)
c01057c2:	e8 06 00 00 00       	call   c01057cd <vprintfmt>
c01057c7:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c01057ca:	90                   	nop
c01057cb:	c9                   	leave  
c01057cc:	c3                   	ret    

c01057cd <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057cd:	f3 0f 1e fb          	endbr32 
c01057d1:	55                   	push   %ebp
c01057d2:	89 e5                	mov    %esp,%ebp
c01057d4:	56                   	push   %esi
c01057d5:	53                   	push   %ebx
c01057d6:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057d9:	eb 17                	jmp    c01057f2 <vprintfmt+0x25>
            if (ch == '\0') {
c01057db:	85 db                	test   %ebx,%ebx
c01057dd:	0f 84 8f 03 00 00    	je     c0105b72 <vprintfmt+0x3a5>
                return;
            }
            putch(ch, putdat);
c01057e3:	83 ec 08             	sub    $0x8,%esp
c01057e6:	ff 75 0c             	pushl  0xc(%ebp)
c01057e9:	53                   	push   %ebx
c01057ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ed:	ff d0                	call   *%eax
c01057ef:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f5:	8d 50 01             	lea    0x1(%eax),%edx
c01057f8:	89 55 10             	mov    %edx,0x10(%ebp)
c01057fb:	0f b6 00             	movzbl (%eax),%eax
c01057fe:	0f b6 d8             	movzbl %al,%ebx
c0105801:	83 fb 25             	cmp    $0x25,%ebx
c0105804:	75 d5                	jne    c01057db <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105806:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010580a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105811:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105814:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105817:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010581e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105821:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105824:	8b 45 10             	mov    0x10(%ebp),%eax
c0105827:	8d 50 01             	lea    0x1(%eax),%edx
c010582a:	89 55 10             	mov    %edx,0x10(%ebp)
c010582d:	0f b6 00             	movzbl (%eax),%eax
c0105830:	0f b6 d8             	movzbl %al,%ebx
c0105833:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105836:	83 f8 55             	cmp    $0x55,%eax
c0105839:	0f 87 06 03 00 00    	ja     c0105b45 <vprintfmt+0x378>
c010583f:	8b 04 85 08 6e 10 c0 	mov    -0x3fef91f8(,%eax,4),%eax
c0105846:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105849:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010584d:	eb d5                	jmp    c0105824 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010584f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105853:	eb cf                	jmp    c0105824 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105855:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010585c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010585f:	89 d0                	mov    %edx,%eax
c0105861:	c1 e0 02             	shl    $0x2,%eax
c0105864:	01 d0                	add    %edx,%eax
c0105866:	01 c0                	add    %eax,%eax
c0105868:	01 d8                	add    %ebx,%eax
c010586a:	83 e8 30             	sub    $0x30,%eax
c010586d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105870:	8b 45 10             	mov    0x10(%ebp),%eax
c0105873:	0f b6 00             	movzbl (%eax),%eax
c0105876:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105879:	83 fb 2f             	cmp    $0x2f,%ebx
c010587c:	7e 39                	jle    c01058b7 <vprintfmt+0xea>
c010587e:	83 fb 39             	cmp    $0x39,%ebx
c0105881:	7f 34                	jg     c01058b7 <vprintfmt+0xea>
            for (precision = 0; ; ++ fmt) {
c0105883:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105887:	eb d3                	jmp    c010585c <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105889:	8b 45 14             	mov    0x14(%ebp),%eax
c010588c:	8d 50 04             	lea    0x4(%eax),%edx
c010588f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105892:	8b 00                	mov    (%eax),%eax
c0105894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105897:	eb 1f                	jmp    c01058b8 <vprintfmt+0xeb>

        case '.':
            if (width < 0)
c0105899:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010589d:	79 85                	jns    c0105824 <vprintfmt+0x57>
                width = 0;
c010589f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01058a6:	e9 79 ff ff ff       	jmp    c0105824 <vprintfmt+0x57>

        case '#':
            altflag = 1;
c01058ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01058b2:	e9 6d ff ff ff       	jmp    c0105824 <vprintfmt+0x57>
            goto process_precision;
c01058b7:	90                   	nop

        process_precision:
            if (width < 0)
c01058b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058bc:	0f 89 62 ff ff ff    	jns    c0105824 <vprintfmt+0x57>
                width = precision, precision = -1;
c01058c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058cf:	e9 50 ff ff ff       	jmp    c0105824 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058d4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01058d8:	e9 47 ff ff ff       	jmp    c0105824 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01058e0:	8d 50 04             	lea    0x4(%eax),%edx
c01058e3:	89 55 14             	mov    %edx,0x14(%ebp)
c01058e6:	8b 00                	mov    (%eax),%eax
c01058e8:	83 ec 08             	sub    $0x8,%esp
c01058eb:	ff 75 0c             	pushl  0xc(%ebp)
c01058ee:	50                   	push   %eax
c01058ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f2:	ff d0                	call   *%eax
c01058f4:	83 c4 10             	add    $0x10,%esp
            break;
c01058f7:	e9 71 02 00 00       	jmp    c0105b6d <vprintfmt+0x3a0>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01058ff:	8d 50 04             	lea    0x4(%eax),%edx
c0105902:	89 55 14             	mov    %edx,0x14(%ebp)
c0105905:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105907:	85 db                	test   %ebx,%ebx
c0105909:	79 02                	jns    c010590d <vprintfmt+0x140>
                err = -err;
c010590b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010590d:	83 fb 06             	cmp    $0x6,%ebx
c0105910:	7f 0b                	jg     c010591d <vprintfmt+0x150>
c0105912:	8b 34 9d c8 6d 10 c0 	mov    -0x3fef9238(,%ebx,4),%esi
c0105919:	85 f6                	test   %esi,%esi
c010591b:	75 19                	jne    c0105936 <vprintfmt+0x169>
                printfmt(putch, putdat, "error %d", err);
c010591d:	53                   	push   %ebx
c010591e:	68 f5 6d 10 c0       	push   $0xc0106df5
c0105923:	ff 75 0c             	pushl  0xc(%ebp)
c0105926:	ff 75 08             	pushl  0x8(%ebp)
c0105929:	e8 77 fe ff ff       	call   c01057a5 <printfmt>
c010592e:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105931:	e9 37 02 00 00       	jmp    c0105b6d <vprintfmt+0x3a0>
                printfmt(putch, putdat, "%s", p);
c0105936:	56                   	push   %esi
c0105937:	68 fe 6d 10 c0       	push   $0xc0106dfe
c010593c:	ff 75 0c             	pushl  0xc(%ebp)
c010593f:	ff 75 08             	pushl  0x8(%ebp)
c0105942:	e8 5e fe ff ff       	call   c01057a5 <printfmt>
c0105947:	83 c4 10             	add    $0x10,%esp
            break;
c010594a:	e9 1e 02 00 00       	jmp    c0105b6d <vprintfmt+0x3a0>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010594f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105952:	8d 50 04             	lea    0x4(%eax),%edx
c0105955:	89 55 14             	mov    %edx,0x14(%ebp)
c0105958:	8b 30                	mov    (%eax),%esi
c010595a:	85 f6                	test   %esi,%esi
c010595c:	75 05                	jne    c0105963 <vprintfmt+0x196>
                p = "(null)";
c010595e:	be 01 6e 10 c0       	mov    $0xc0106e01,%esi
            }
            if (width > 0 && padc != '-') {
c0105963:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105967:	7e 76                	jle    c01059df <vprintfmt+0x212>
c0105969:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010596d:	74 70                	je     c01059df <vprintfmt+0x212>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010596f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105972:	83 ec 08             	sub    $0x8,%esp
c0105975:	50                   	push   %eax
c0105976:	56                   	push   %esi
c0105977:	e8 db f7 ff ff       	call   c0105157 <strnlen>
c010597c:	83 c4 10             	add    $0x10,%esp
c010597f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105982:	29 c2                	sub    %eax,%edx
c0105984:	89 d0                	mov    %edx,%eax
c0105986:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105989:	eb 17                	jmp    c01059a2 <vprintfmt+0x1d5>
                    putch(padc, putdat);
c010598b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010598f:	83 ec 08             	sub    $0x8,%esp
c0105992:	ff 75 0c             	pushl  0xc(%ebp)
c0105995:	50                   	push   %eax
c0105996:	8b 45 08             	mov    0x8(%ebp),%eax
c0105999:	ff d0                	call   *%eax
c010599b:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c010599e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059a6:	7f e3                	jg     c010598b <vprintfmt+0x1be>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059a8:	eb 35                	jmp    c01059df <vprintfmt+0x212>
                if (altflag && (ch < ' ' || ch > '~')) {
c01059aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01059ae:	74 1c                	je     c01059cc <vprintfmt+0x1ff>
c01059b0:	83 fb 1f             	cmp    $0x1f,%ebx
c01059b3:	7e 05                	jle    c01059ba <vprintfmt+0x1ed>
c01059b5:	83 fb 7e             	cmp    $0x7e,%ebx
c01059b8:	7e 12                	jle    c01059cc <vprintfmt+0x1ff>
                    putch('?', putdat);
c01059ba:	83 ec 08             	sub    $0x8,%esp
c01059bd:	ff 75 0c             	pushl  0xc(%ebp)
c01059c0:	6a 3f                	push   $0x3f
c01059c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c5:	ff d0                	call   *%eax
c01059c7:	83 c4 10             	add    $0x10,%esp
c01059ca:	eb 0f                	jmp    c01059db <vprintfmt+0x20e>
                }
                else {
                    putch(ch, putdat);
c01059cc:	83 ec 08             	sub    $0x8,%esp
c01059cf:	ff 75 0c             	pushl  0xc(%ebp)
c01059d2:	53                   	push   %ebx
c01059d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d6:	ff d0                	call   *%eax
c01059d8:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059df:	89 f0                	mov    %esi,%eax
c01059e1:	8d 70 01             	lea    0x1(%eax),%esi
c01059e4:	0f b6 00             	movzbl (%eax),%eax
c01059e7:	0f be d8             	movsbl %al,%ebx
c01059ea:	85 db                	test   %ebx,%ebx
c01059ec:	74 26                	je     c0105a14 <vprintfmt+0x247>
c01059ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059f2:	78 b6                	js     c01059aa <vprintfmt+0x1dd>
c01059f4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01059f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059fc:	79 ac                	jns    c01059aa <vprintfmt+0x1dd>
                }
            }
            for (; width > 0; width --) {
c01059fe:	eb 14                	jmp    c0105a14 <vprintfmt+0x247>
                putch(' ', putdat);
c0105a00:	83 ec 08             	sub    $0x8,%esp
c0105a03:	ff 75 0c             	pushl  0xc(%ebp)
c0105a06:	6a 20                	push   $0x20
c0105a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0b:	ff d0                	call   *%eax
c0105a0d:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c0105a10:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a18:	7f e6                	jg     c0105a00 <vprintfmt+0x233>
            }
            break;
c0105a1a:	e9 4e 01 00 00       	jmp    c0105b6d <vprintfmt+0x3a0>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a1f:	83 ec 08             	sub    $0x8,%esp
c0105a22:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a25:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a28:	50                   	push   %eax
c0105a29:	e8 2c fd ff ff       	call   c010575a <getint>
c0105a2e:	83 c4 10             	add    $0x10,%esp
c0105a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a34:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a3d:	85 d2                	test   %edx,%edx
c0105a3f:	79 23                	jns    c0105a64 <vprintfmt+0x297>
                putch('-', putdat);
c0105a41:	83 ec 08             	sub    $0x8,%esp
c0105a44:	ff 75 0c             	pushl  0xc(%ebp)
c0105a47:	6a 2d                	push   $0x2d
c0105a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4c:	ff d0                	call   *%eax
c0105a4e:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a57:	f7 d8                	neg    %eax
c0105a59:	83 d2 00             	adc    $0x0,%edx
c0105a5c:	f7 da                	neg    %edx
c0105a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a64:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a6b:	e9 9f 00 00 00       	jmp    c0105b0f <vprintfmt+0x342>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a70:	83 ec 08             	sub    $0x8,%esp
c0105a73:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a76:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a79:	50                   	push   %eax
c0105a7a:	e8 88 fc ff ff       	call   c0105707 <getuint>
c0105a7f:	83 c4 10             	add    $0x10,%esp
c0105a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a85:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a88:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a8f:	eb 7e                	jmp    c0105b0f <vprintfmt+0x342>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a91:	83 ec 08             	sub    $0x8,%esp
c0105a94:	ff 75 e0             	pushl  -0x20(%ebp)
c0105a97:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a9a:	50                   	push   %eax
c0105a9b:	e8 67 fc ff ff       	call   c0105707 <getuint>
c0105aa0:	83 c4 10             	add    $0x10,%esp
c0105aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105aa9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105ab0:	eb 5d                	jmp    c0105b0f <vprintfmt+0x342>

        // pointer
        case 'p':
            putch('0', putdat);
c0105ab2:	83 ec 08             	sub    $0x8,%esp
c0105ab5:	ff 75 0c             	pushl  0xc(%ebp)
c0105ab8:	6a 30                	push   $0x30
c0105aba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abd:	ff d0                	call   *%eax
c0105abf:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c0105ac2:	83 ec 08             	sub    $0x8,%esp
c0105ac5:	ff 75 0c             	pushl  0xc(%ebp)
c0105ac8:	6a 78                	push   $0x78
c0105aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acd:	ff d0                	call   *%eax
c0105acf:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105ad2:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ad5:	8d 50 04             	lea    0x4(%eax),%edx
c0105ad8:	89 55 14             	mov    %edx,0x14(%ebp)
c0105adb:	8b 00                	mov    (%eax),%eax
c0105add:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ae0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ae7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105aee:	eb 1f                	jmp    c0105b0f <vprintfmt+0x342>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105af0:	83 ec 08             	sub    $0x8,%esp
c0105af3:	ff 75 e0             	pushl  -0x20(%ebp)
c0105af6:	8d 45 14             	lea    0x14(%ebp),%eax
c0105af9:	50                   	push   %eax
c0105afa:	e8 08 fc ff ff       	call   c0105707 <getuint>
c0105aff:	83 c4 10             	add    $0x10,%esp
c0105b02:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b05:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b16:	83 ec 04             	sub    $0x4,%esp
c0105b19:	52                   	push   %edx
c0105b1a:	ff 75 e8             	pushl  -0x18(%ebp)
c0105b1d:	50                   	push   %eax
c0105b1e:	ff 75 f4             	pushl  -0xc(%ebp)
c0105b21:	ff 75 f0             	pushl  -0x10(%ebp)
c0105b24:	ff 75 0c             	pushl  0xc(%ebp)
c0105b27:	ff 75 08             	pushl  0x8(%ebp)
c0105b2a:	e8 e8 fa ff ff       	call   c0105617 <printnum>
c0105b2f:	83 c4 20             	add    $0x20,%esp
            break;
c0105b32:	eb 39                	jmp    c0105b6d <vprintfmt+0x3a0>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b34:	83 ec 08             	sub    $0x8,%esp
c0105b37:	ff 75 0c             	pushl  0xc(%ebp)
c0105b3a:	53                   	push   %ebx
c0105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3e:	ff d0                	call   *%eax
c0105b40:	83 c4 10             	add    $0x10,%esp
            break;
c0105b43:	eb 28                	jmp    c0105b6d <vprintfmt+0x3a0>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b45:	83 ec 08             	sub    $0x8,%esp
c0105b48:	ff 75 0c             	pushl  0xc(%ebp)
c0105b4b:	6a 25                	push   $0x25
c0105b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b50:	ff d0                	call   *%eax
c0105b52:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b59:	eb 04                	jmp    c0105b5f <vprintfmt+0x392>
c0105b5b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b62:	83 e8 01             	sub    $0x1,%eax
c0105b65:	0f b6 00             	movzbl (%eax),%eax
c0105b68:	3c 25                	cmp    $0x25,%al
c0105b6a:	75 ef                	jne    c0105b5b <vprintfmt+0x38e>
                /* do nothing */;
            break;
c0105b6c:	90                   	nop
    while (1) {
c0105b6d:	e9 67 fc ff ff       	jmp    c01057d9 <vprintfmt+0xc>
                return;
c0105b72:	90                   	nop
        }
    }
}
c0105b73:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105b76:	5b                   	pop    %ebx
c0105b77:	5e                   	pop    %esi
c0105b78:	5d                   	pop    %ebp
c0105b79:	c3                   	ret    

c0105b7a <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b7a:	f3 0f 1e fb          	endbr32 
c0105b7e:	55                   	push   %ebp
c0105b7f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b84:	8b 40 08             	mov    0x8(%eax),%eax
c0105b87:	8d 50 01             	lea    0x1(%eax),%edx
c0105b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b93:	8b 10                	mov    (%eax),%edx
c0105b95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b98:	8b 40 04             	mov    0x4(%eax),%eax
c0105b9b:	39 c2                	cmp    %eax,%edx
c0105b9d:	73 12                	jae    c0105bb1 <sprintputch+0x37>
        *b->buf ++ = ch;
c0105b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba2:	8b 00                	mov    (%eax),%eax
c0105ba4:	8d 48 01             	lea    0x1(%eax),%ecx
c0105ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105baa:	89 0a                	mov    %ecx,(%edx)
c0105bac:	8b 55 08             	mov    0x8(%ebp),%edx
c0105baf:	88 10                	mov    %dl,(%eax)
    }
}
c0105bb1:	90                   	nop
c0105bb2:	5d                   	pop    %ebp
c0105bb3:	c3                   	ret    

c0105bb4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bb4:	f3 0f 1e fb          	endbr32 
c0105bb8:	55                   	push   %ebp
c0105bb9:	89 e5                	mov    %esp,%ebp
c0105bbb:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bbe:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bc7:	50                   	push   %eax
c0105bc8:	ff 75 10             	pushl  0x10(%ebp)
c0105bcb:	ff 75 0c             	pushl  0xc(%ebp)
c0105bce:	ff 75 08             	pushl  0x8(%ebp)
c0105bd1:	e8 0b 00 00 00       	call   c0105be1 <vsnprintf>
c0105bd6:	83 c4 10             	add    $0x10,%esp
c0105bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bdf:	c9                   	leave  
c0105be0:	c3                   	ret    

c0105be1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105be1:	f3 0f 1e fb          	endbr32 
c0105be5:	55                   	push   %ebp
c0105be6:	89 e5                	mov    %esp,%ebp
c0105be8:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfa:	01 d0                	add    %edx,%eax
c0105bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c0a:	74 0a                	je     c0105c16 <vsnprintf+0x35>
c0105c0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c12:	39 c2                	cmp    %eax,%edx
c0105c14:	76 07                	jbe    c0105c1d <vsnprintf+0x3c>
        return -E_INVAL;
c0105c16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c1b:	eb 20                	jmp    c0105c3d <vsnprintf+0x5c>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c1d:	ff 75 14             	pushl  0x14(%ebp)
c0105c20:	ff 75 10             	pushl  0x10(%ebp)
c0105c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c26:	50                   	push   %eax
c0105c27:	68 7a 5b 10 c0       	push   $0xc0105b7a
c0105c2c:	e8 9c fb ff ff       	call   c01057cd <vprintfmt>
c0105c31:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c37:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c3d:	c9                   	leave  
c0105c3e:	c3                   	ret    


bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 d0 11 40       	mov    $0x4011d000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 d0 11 00       	mov    %eax,0x11d000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 c0 11 00       	mov    $0x11c000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 20 00 12 00       	mov    $0x120020,%eax
  100045:	2d 36 ca 11 00       	sub    $0x11ca36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 ca 11 00 	movl   $0x11ca36,(%esp)
  10005d:	e8 63 6b 00 00       	call   106bc5 <memset>

    cons_init();                // init the console
  100062:	e8 4b 16 00 00       	call   1016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 00 74 10 00 	movl   $0x107400,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 1c 74 10 00 	movl   $0x10741c,(%esp)
  10007c:	e8 44 02 00 00       	call   1002c5 <cprintf>

    print_kerninfo();
  100081:	e8 02 09 00 00       	call   100988 <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 3d 36 00 00       	call   1036cd <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 98 17 00 00       	call   10182d <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 3d 19 00 00       	call   1019d7 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 5a 0d 00 00       	call   100df9 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 d5 18 00 00       	call   101979 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	f3 0f 1e fb          	endbr32 
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b7:	00 
  1000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bf:	00 
  1000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c7:	e8 17 0d 00 00       	call   100de3 <mon_backtrace>
}
  1000cc:	90                   	nop
  1000cd:	c9                   	leave  
  1000ce:	c3                   	ret    

001000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cf:	f3 0f 1e fb          	endbr32 
  1000d3:	55                   	push   %ebp
  1000d4:	89 e5                	mov    %esp,%ebp
  1000d6:	53                   	push   %ebx
  1000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f2:	89 04 24             	mov    %eax,(%esp)
  1000f5:	e8 ac ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000fa:	90                   	nop
  1000fb:	83 c4 14             	add    $0x14,%esp
  1000fe:	5b                   	pop    %ebx
  1000ff:	5d                   	pop    %ebp
  100100:	c3                   	ret    

00100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100101:	f3 0f 1e fb          	endbr32 
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010b:	8b 45 10             	mov    0x10(%ebp),%eax
  10010e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100112:	8b 45 08             	mov    0x8(%ebp),%eax
  100115:	89 04 24             	mov    %eax,(%esp)
  100118:	e8 b2 ff ff ff       	call   1000cf <grade_backtrace1>
}
  10011d:	90                   	nop
  10011e:	c9                   	leave  
  10011f:	c3                   	ret    

00100120 <grade_backtrace>:

void
grade_backtrace(void) {
  100120:	f3 0f 1e fb          	endbr32 
  100124:	55                   	push   %ebp
  100125:	89 e5                	mov    %esp,%ebp
  100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100136:	ff 
  100137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100142:	e8 ba ff ff ff       	call   100101 <grade_backtrace0>
}
  100147:	90                   	nop
  100148:	c9                   	leave  
  100149:	c3                   	ret    

0010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014a:	f3 0f 1e fb          	endbr32 
  10014e:	55                   	push   %ebp
  10014f:	89 e5                	mov    %esp,%ebp
  100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100164:	83 e0 03             	and    $0x3,%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 f0 11 00       	mov    0x11f000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 21 74 10 00 	movl   $0x107421,(%esp)
  10017d:	e8 43 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 f0 11 00       	mov    0x11f000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 2f 74 10 00 	movl   $0x10742f,(%esp)
  10019c:	e8 24 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 f0 11 00       	mov    0x11f000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 3d 74 10 00 	movl   $0x10743d,(%esp)
  1001bb:	e8 05 01 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 f0 11 00       	mov    0x11f000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 4b 74 10 00 	movl   $0x10744b,(%esp)
  1001da:	e8 e6 00 00 00       	call   1002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 f0 11 00       	mov    0x11f000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 59 74 10 00 	movl   $0x107459,(%esp)
  1001f9:	e8 c7 00 00 00       	call   1002c5 <cprintf>
    round ++;
  1001fe:	a1 00 f0 11 00       	mov    0x11f000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 f0 11 00       	mov    %eax,0x11f000
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020c:	f3 0f 1e fb          	endbr32 
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
  100213:	83 ec 08             	sub    $0x8,%esp
  100216:	cd 78                	int    $0x78
  100218:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
        "movl %%ebp, %%esp\n"
		:
		:"i" (T_SWITCH_TOU)
	);
}
  10021a:	90                   	nop
  10021b:	5d                   	pop    %ebp
  10021c:	c3                   	ret    

0010021d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  10021d:	f3 0f 1e fb          	endbr32 
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    __asm__ __volatile__(
  100224:	cd 79                	int    $0x79
  100226:	89 ec                	mov    %ebp,%esp
    	"int %0 \n"
    	"movl %%ebp,%%esp \n" 
    	:
    	:"i"(T_SWITCH_TOK)
    );
}
  100228:	90                   	nop
  100229:	5d                   	pop    %ebp
  10022a:	c3                   	ret    

0010022b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10022b:	f3 0f 1e fb          	endbr32 
  10022f:	55                   	push   %ebp
  100230:	89 e5                	mov    %esp,%ebp
  100232:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100235:	e8 10 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023a:	c7 04 24 68 74 10 00 	movl   $0x107468,(%esp)
  100241:	e8 7f 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_user();
  100246:	e8 c1 ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  10024b:	e8 fa fe ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100250:	c7 04 24 88 74 10 00 	movl   $0x107488,(%esp)
  100257:	e8 69 00 00 00       	call   1002c5 <cprintf>
    lab1_switch_to_kernel();
  10025c:	e8 bc ff ff ff       	call   10021d <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100261:	e8 e4 fe ff ff       	call   10014a <lab1_print_cur_status>
}
  100266:	90                   	nop
  100267:	c9                   	leave  
  100268:	c3                   	ret    

00100269 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100269:	f3 0f 1e fb          	endbr32 
  10026d:	55                   	push   %ebp
  10026e:	89 e5                	mov    %esp,%ebp
  100270:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100273:	8b 45 08             	mov    0x8(%ebp),%eax
  100276:	89 04 24             	mov    %eax,(%esp)
  100279:	e8 65 14 00 00       	call   1016e3 <cons_putc>
    (*cnt) ++;
  10027e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100281:	8b 00                	mov    (%eax),%eax
  100283:	8d 50 01             	lea    0x1(%eax),%edx
  100286:	8b 45 0c             	mov    0xc(%ebp),%eax
  100289:	89 10                	mov    %edx,(%eax)
}
  10028b:	90                   	nop
  10028c:	c9                   	leave  
  10028d:	c3                   	ret    

0010028e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10028e:	f3 0f 1e fb          	endbr32 
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10029f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b4:	c7 04 24 69 02 10 00 	movl   $0x100269,(%esp)
  1002bb:	e8 71 6c 00 00       	call   106f31 <vprintfmt>
    return cnt;
  1002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c3:	c9                   	leave  
  1002c4:	c3                   	ret    

001002c5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002c5:	f3 0f 1e fb          	endbr32 
  1002c9:	55                   	push   %ebp
  1002ca:	89 e5                	mov    %esp,%ebp
  1002cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002df:	89 04 24             	mov    %eax,(%esp)
  1002e2:	e8 a7 ff ff ff       	call   10028e <vcprintf>
  1002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002ef:	f3 0f 1e fb          	endbr32 
  1002f3:	55                   	push   %ebp
  1002f4:	89 e5                	mov    %esp,%ebp
  1002f6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fc:	89 04 24             	mov    %eax,(%esp)
  1002ff:	e8 df 13 00 00       	call   1016e3 <cons_putc>
}
  100304:	90                   	nop
  100305:	c9                   	leave  
  100306:	c3                   	ret    

00100307 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100307:	f3 0f 1e fb          	endbr32 
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100311:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100318:	eb 13                	jmp    10032d <cputs+0x26>
        cputch(c, &cnt);
  10031a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10031e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100321:	89 54 24 04          	mov    %edx,0x4(%esp)
  100325:	89 04 24             	mov    %eax,(%esp)
  100328:	e8 3c ff ff ff       	call   100269 <cputch>
    while ((c = *str ++) != '\0') {
  10032d:	8b 45 08             	mov    0x8(%ebp),%eax
  100330:	8d 50 01             	lea    0x1(%eax),%edx
  100333:	89 55 08             	mov    %edx,0x8(%ebp)
  100336:	0f b6 00             	movzbl (%eax),%eax
  100339:	88 45 f7             	mov    %al,-0x9(%ebp)
  10033c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100340:	75 d8                	jne    10031a <cputs+0x13>
    }
    cputch('\n', &cnt);
  100342:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100345:	89 44 24 04          	mov    %eax,0x4(%esp)
  100349:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100350:	e8 14 ff ff ff       	call   100269 <cputch>
    return cnt;
  100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100358:	c9                   	leave  
  100359:	c3                   	ret    

0010035a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10035a:	f3 0f 1e fb          	endbr32 
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100364:	90                   	nop
  100365:	e8 ba 13 00 00       	call   101724 <cons_getc>
  10036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100371:	74 f2                	je     100365 <getchar+0xb>
        /* do nothing */;
    return c;
  100373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100376:	c9                   	leave  
  100377:	c3                   	ret    

00100378 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100378:	f3 0f 1e fb          	endbr32 
  10037c:	55                   	push   %ebp
  10037d:	89 e5                	mov    %esp,%ebp
  10037f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100386:	74 13                	je     10039b <readline+0x23>
        cprintf("%s", prompt);
  100388:	8b 45 08             	mov    0x8(%ebp),%eax
  10038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10038f:	c7 04 24 a7 74 10 00 	movl   $0x1074a7,(%esp)
  100396:	e8 2a ff ff ff       	call   1002c5 <cprintf>
    }
    int i = 0, c;
  10039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003a2:	e8 b3 ff ff ff       	call   10035a <getchar>
  1003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003ae:	79 07                	jns    1003b7 <readline+0x3f>
            return NULL;
  1003b0:	b8 00 00 00 00       	mov    $0x0,%eax
  1003b5:	eb 78                	jmp    10042f <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003b7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003bb:	7e 28                	jle    1003e5 <readline+0x6d>
  1003bd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003c4:	7f 1f                	jg     1003e5 <readline+0x6d>
            cputchar(c);
  1003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c9:	89 04 24             	mov    %eax,(%esp)
  1003cc:	e8 1e ff ff ff       	call   1002ef <cputchar>
            buf[i ++] = c;
  1003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d4:	8d 50 01             	lea    0x1(%eax),%edx
  1003d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003dd:	88 90 20 f0 11 00    	mov    %dl,0x11f020(%eax)
  1003e3:	eb 45                	jmp    10042a <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003e5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003e9:	75 16                	jne    100401 <readline+0x89>
  1003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ef:	7e 10                	jle    100401 <readline+0x89>
            cputchar(c);
  1003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f4:	89 04 24             	mov    %eax,(%esp)
  1003f7:	e8 f3 fe ff ff       	call   1002ef <cputchar>
            i --;
  1003fc:	ff 4d f4             	decl   -0xc(%ebp)
  1003ff:	eb 29                	jmp    10042a <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100401:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100405:	74 06                	je     10040d <readline+0x95>
  100407:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10040b:	75 95                	jne    1003a2 <readline+0x2a>
            cputchar(c);
  10040d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100410:	89 04 24             	mov    %eax,(%esp)
  100413:	e8 d7 fe ff ff       	call   1002ef <cputchar>
            buf[i] = '\0';
  100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10041b:	05 20 f0 11 00       	add    $0x11f020,%eax
  100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100423:	b8 20 f0 11 00       	mov    $0x11f020,%eax
  100428:	eb 05                	jmp    10042f <readline+0xb7>
        c = getchar();
  10042a:	e9 73 ff ff ff       	jmp    1003a2 <readline+0x2a>
        }
    }
}
  10042f:	c9                   	leave  
  100430:	c3                   	ret    

00100431 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100431:	f3 0f 1e fb          	endbr32 
  100435:	55                   	push   %ebp
  100436:	89 e5                	mov    %esp,%ebp
  100438:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10043b:	a1 20 f4 11 00       	mov    0x11f420,%eax
  100440:	85 c0                	test   %eax,%eax
  100442:	75 5b                	jne    10049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100444:	c7 05 20 f4 11 00 01 	movl   $0x1,0x11f420
  10044b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10044e:	8d 45 14             	lea    0x14(%ebp),%eax
  100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100454:	8b 45 0c             	mov    0xc(%ebp),%eax
  100457:	89 44 24 08          	mov    %eax,0x8(%esp)
  10045b:	8b 45 08             	mov    0x8(%ebp),%eax
  10045e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100462:	c7 04 24 aa 74 10 00 	movl   $0x1074aa,(%esp)
  100469:	e8 57 fe ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  10046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100471:	89 44 24 04          	mov    %eax,0x4(%esp)
  100475:	8b 45 10             	mov    0x10(%ebp),%eax
  100478:	89 04 24             	mov    %eax,(%esp)
  10047b:	e8 0e fe ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  100480:	c7 04 24 c6 74 10 00 	movl   $0x1074c6,(%esp)
  100487:	e8 39 fe ff ff       	call   1002c5 <cprintf>
    
    cprintf("stack trackback:\n");
  10048c:	c7 04 24 c8 74 10 00 	movl   $0x1074c8,(%esp)
  100493:	e8 2d fe ff ff       	call   1002c5 <cprintf>
    print_stackframe();
  100498:	e8 3d 06 00 00       	call   100ada <print_stackframe>
  10049d:	eb 01                	jmp    1004a0 <__panic+0x6f>
        goto panic_dead;
  10049f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004a0:	e8 e0 14 00 00       	call   101985 <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004ac:	e8 59 08 00 00       	call   100d0a <kmonitor>
  1004b1:	eb f2                	jmp    1004a5 <__panic+0x74>

001004b3 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004b3:	f3 0f 1e fb          	endbr32 
  1004b7:	55                   	push   %ebp
  1004b8:	89 e5                	mov    %esp,%ebp
  1004ba:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004bd:	8d 45 14             	lea    0x14(%ebp),%eax
  1004c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d1:	c7 04 24 da 74 10 00 	movl   $0x1074da,(%esp)
  1004d8:	e8 e8 fd ff ff       	call   1002c5 <cprintf>
    vcprintf(fmt, ap);
  1004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e4:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e7:	89 04 24             	mov    %eax,(%esp)
  1004ea:	e8 9f fd ff ff       	call   10028e <vcprintf>
    cprintf("\n");
  1004ef:	c7 04 24 c6 74 10 00 	movl   $0x1074c6,(%esp)
  1004f6:	e8 ca fd ff ff       	call   1002c5 <cprintf>
    va_end(ap);
}
  1004fb:	90                   	nop
  1004fc:	c9                   	leave  
  1004fd:	c3                   	ret    

001004fe <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004fe:	f3 0f 1e fb          	endbr32 
  100502:	55                   	push   %ebp
  100503:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100505:	a1 20 f4 11 00       	mov    0x11f420,%eax
}
  10050a:	5d                   	pop    %ebp
  10050b:	c3                   	ret    

0010050c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10050c:	f3 0f 1e fb          	endbr32 
  100510:	55                   	push   %ebp
  100511:	89 e5                	mov    %esp,%ebp
  100513:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100516:	8b 45 0c             	mov    0xc(%ebp),%eax
  100519:	8b 00                	mov    (%eax),%eax
  10051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10051e:	8b 45 10             	mov    0x10(%ebp),%eax
  100521:	8b 00                	mov    (%eax),%eax
  100523:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10052d:	e9 ca 00 00 00       	jmp    1005fc <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100532:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	89 c2                	mov    %eax,%edx
  10053c:	c1 ea 1f             	shr    $0x1f,%edx
  10053f:	01 d0                	add    %edx,%eax
  100541:	d1 f8                	sar    %eax
  100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100549:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10054c:	eb 03                	jmp    100551 <stab_binsearch+0x45>
            m --;
  10054e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100557:	7c 1f                	jl     100578 <stab_binsearch+0x6c>
  100559:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055c:	89 d0                	mov    %edx,%eax
  10055e:	01 c0                	add    %eax,%eax
  100560:	01 d0                	add    %edx,%eax
  100562:	c1 e0 02             	shl    $0x2,%eax
  100565:	89 c2                	mov    %eax,%edx
  100567:	8b 45 08             	mov    0x8(%ebp),%eax
  10056a:	01 d0                	add    %edx,%eax
  10056c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100570:	0f b6 c0             	movzbl %al,%eax
  100573:	39 45 14             	cmp    %eax,0x14(%ebp)
  100576:	75 d6                	jne    10054e <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10057e:	7d 09                	jge    100589 <stab_binsearch+0x7d>
            l = true_m + 1;
  100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100583:	40                   	inc    %eax
  100584:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100587:	eb 73                	jmp    1005fc <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	01 c0                	add    %eax,%eax
  100597:	01 d0                	add    %edx,%eax
  100599:	c1 e0 02             	shl    $0x2,%eax
  10059c:	89 c2                	mov    %eax,%edx
  10059e:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a1:	01 d0                	add    %edx,%eax
  1005a3:	8b 40 08             	mov    0x8(%eax),%eax
  1005a6:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a9:	76 11                	jbe    1005bc <stab_binsearch+0xb0>
            *region_left = m;
  1005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005b6:	40                   	inc    %eax
  1005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005ba:	eb 40                	jmp    1005fc <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bf:	89 d0                	mov    %edx,%eax
  1005c1:	01 c0                	add    %eax,%eax
  1005c3:	01 d0                	add    %edx,%eax
  1005c5:	c1 e0 02             	shl    $0x2,%eax
  1005c8:	89 c2                	mov    %eax,%edx
  1005ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1005cd:	01 d0                	add    %edx,%eax
  1005cf:	8b 40 08             	mov    0x8(%eax),%eax
  1005d2:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005d5:	73 14                	jae    1005eb <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005da:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005e5:	48                   	dec    %eax
  1005e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005e9:	eb 11                	jmp    1005fc <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005f1:	89 10                	mov    %edx,(%eax)
            l = m;
  1005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100602:	0f 8e 2a ff ff ff    	jle    100532 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  100608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10060c:	75 0f                	jne    10061d <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  10060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100611:	8b 00                	mov    (%eax),%eax
  100613:	8d 50 ff             	lea    -0x1(%eax),%edx
  100616:	8b 45 10             	mov    0x10(%ebp),%eax
  100619:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10061b:	eb 3e                	jmp    10065b <stab_binsearch+0x14f>
        l = *region_right;
  10061d:	8b 45 10             	mov    0x10(%ebp),%eax
  100620:	8b 00                	mov    (%eax),%eax
  100622:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100625:	eb 03                	jmp    10062a <stab_binsearch+0x11e>
  100627:	ff 4d fc             	decl   -0x4(%ebp)
  10062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062d:	8b 00                	mov    (%eax),%eax
  10062f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100632:	7e 1f                	jle    100653 <stab_binsearch+0x147>
  100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100637:	89 d0                	mov    %edx,%eax
  100639:	01 c0                	add    %eax,%eax
  10063b:	01 d0                	add    %edx,%eax
  10063d:	c1 e0 02             	shl    $0x2,%eax
  100640:	89 c2                	mov    %eax,%edx
  100642:	8b 45 08             	mov    0x8(%ebp),%eax
  100645:	01 d0                	add    %edx,%eax
  100647:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10064b:	0f b6 c0             	movzbl %al,%eax
  10064e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100651:	75 d4                	jne    100627 <stab_binsearch+0x11b>
        *region_left = l;
  100653:	8b 45 0c             	mov    0xc(%ebp),%eax
  100656:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100659:	89 10                	mov    %edx,(%eax)
}
  10065b:	90                   	nop
  10065c:	c9                   	leave  
  10065d:	c3                   	ret    

0010065e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10065e:	f3 0f 1e fb          	endbr32 
  100662:	55                   	push   %ebp
  100663:	89 e5                	mov    %esp,%ebp
  100665:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100668:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066b:	c7 00 f8 74 10 00    	movl   $0x1074f8,(%eax)
    info->eip_line = 0;
  100671:	8b 45 0c             	mov    0xc(%ebp),%eax
  100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10067b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067e:	c7 40 08 f8 74 10 00 	movl   $0x1074f8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10068f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100692:	8b 55 08             	mov    0x8(%ebp),%edx
  100695:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006a2:	c7 45 f4 c0 8b 10 00 	movl   $0x108bc0,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006a9:	c7 45 f0 18 72 11 00 	movl   $0x117218,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b0:	c7 45 ec 19 72 11 00 	movl   $0x117219,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006b7:	c7 45 e8 dd 9f 11 00 	movl   $0x119fdd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006c4:	76 0b                	jbe    1006d1 <debuginfo_eip+0x73>
  1006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c9:	48                   	dec    %eax
  1006ca:	0f b6 00             	movzbl (%eax),%eax
  1006cd:	84 c0                	test   %al,%al
  1006cf:	74 0a                	je     1006db <debuginfo_eip+0x7d>
        return -1;
  1006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d6:	e9 ab 02 00 00       	jmp    100986 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006e8:	c1 f8 02             	sar    $0x2,%eax
  1006eb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006f1:	48                   	dec    %eax
  1006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006fc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100703:	00 
  100704:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100707:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10070e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	89 04 24             	mov    %eax,(%esp)
  100718:	e8 ef fd ff ff       	call   10050c <stab_binsearch>
    if (lfile == 0)
  10071d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100720:	85 c0                	test   %eax,%eax
  100722:	75 0a                	jne    10072e <debuginfo_eip+0xd0>
        return -1;
  100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100729:	e9 58 02 00 00       	jmp    100986 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10072e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100731:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100737:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10073a:	8b 45 08             	mov    0x8(%ebp),%eax
  10073d:	89 44 24 10          	mov    %eax,0x10(%esp)
  100741:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100748:	00 
  100749:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10074c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100750:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100753:	89 44 24 04          	mov    %eax,0x4(%esp)
  100757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075a:	89 04 24             	mov    %eax,(%esp)
  10075d:	e8 aa fd ff ff       	call   10050c <stab_binsearch>

    if (lfun <= rfun) {
  100762:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100765:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100768:	39 c2                	cmp    %eax,%edx
  10076a:	7f 78                	jg     1007e4 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10076c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	89 d0                	mov    %edx,%eax
  100773:	01 c0                	add    %eax,%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	c1 e0 02             	shl    $0x2,%eax
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077f:	01 d0                	add    %edx,%eax
  100781:	8b 10                	mov    (%eax),%edx
  100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100789:	39 c2                	cmp    %eax,%edx
  10078b:	73 22                	jae    1007af <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	89 d0                	mov    %edx,%eax
  100794:	01 c0                	add    %eax,%eax
  100796:	01 d0                	add    %edx,%eax
  100798:	c1 e0 02             	shl    $0x2,%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a0:	01 d0                	add    %edx,%eax
  1007a2:	8b 10                	mov    (%eax),%edx
  1007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007a7:	01 c2                	add    %eax,%edx
  1007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ac:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	8b 50 08             	mov    0x8(%eax),%edx
  1007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ca:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d0:	8b 40 10             	mov    0x10(%eax),%eax
  1007d3:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007e2:	eb 15                	jmp    1007f9 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e7:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ea:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007fc:	8b 40 08             	mov    0x8(%eax),%eax
  1007ff:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100806:	00 
  100807:	89 04 24             	mov    %eax,(%esp)
  10080a:	e8 2a 62 00 00       	call   106a39 <strfind>
  10080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100812:	8b 52 08             	mov    0x8(%edx),%edx
  100815:	29 d0                	sub    %edx,%eax
  100817:	89 c2                	mov    %eax,%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10081f:	8b 45 08             	mov    0x8(%ebp),%eax
  100822:	89 44 24 10          	mov    %eax,0x10(%esp)
  100826:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10082d:	00 
  10082e:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100831:	89 44 24 08          	mov    %eax,0x8(%esp)
  100835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100838:	89 44 24 04          	mov    %eax,0x4(%esp)
  10083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083f:	89 04 24             	mov    %eax,(%esp)
  100842:	e8 c5 fc ff ff       	call   10050c <stab_binsearch>
    if (lline <= rline) {
  100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10084d:	39 c2                	cmp    %eax,%edx
  10084f:	7f 23                	jg     100874 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100851:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	89 d0                	mov    %edx,%eax
  100858:	01 c0                	add    %eax,%eax
  10085a:	01 d0                	add    %edx,%eax
  10085c:	c1 e0 02             	shl    $0x2,%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100872:	eb 11                	jmp    100885 <debuginfo_eip+0x227>
        return -1;
  100874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100879:	e9 08 01 00 00       	jmp    100986 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10087e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100881:	48                   	dec    %eax
  100882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088b:	39 c2                	cmp    %eax,%edx
  10088d:	7c 56                	jl     1008e5 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100892:	89 c2                	mov    %eax,%edx
  100894:	89 d0                	mov    %edx,%eax
  100896:	01 c0                	add    %eax,%eax
  100898:	01 d0                	add    %edx,%eax
  10089a:	c1 e0 02             	shl    $0x2,%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a2:	01 d0                	add    %edx,%eax
  1008a4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008a8:	3c 84                	cmp    $0x84,%al
  1008aa:	74 39                	je     1008e5 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	89 d0                	mov    %edx,%eax
  1008b3:	01 c0                	add    %eax,%eax
  1008b5:	01 d0                	add    %edx,%eax
  1008b7:	c1 e0 02             	shl    $0x2,%eax
  1008ba:	89 c2                	mov    %eax,%edx
  1008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008bf:	01 d0                	add    %edx,%eax
  1008c1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008c5:	3c 64                	cmp    $0x64,%al
  1008c7:	75 b5                	jne    10087e <debuginfo_eip+0x220>
  1008c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	89 d0                	mov    %edx,%eax
  1008d0:	01 c0                	add    %eax,%eax
  1008d2:	01 d0                	add    %edx,%eax
  1008d4:	c1 e0 02             	shl    $0x2,%eax
  1008d7:	89 c2                	mov    %eax,%edx
  1008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008dc:	01 d0                	add    %edx,%eax
  1008de:	8b 40 08             	mov    0x8(%eax),%eax
  1008e1:	85 c0                	test   %eax,%eax
  1008e3:	74 99                	je     10087e <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008eb:	39 c2                	cmp    %eax,%edx
  1008ed:	7c 42                	jl     100931 <debuginfo_eip+0x2d3>
  1008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	01 c0                	add    %eax,%eax
  1008f8:	01 d0                	add    %edx,%eax
  1008fa:	c1 e0 02             	shl    $0x2,%eax
  1008fd:	89 c2                	mov    %eax,%edx
  1008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100902:	01 d0                	add    %edx,%eax
  100904:	8b 10                	mov    (%eax),%edx
  100906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100909:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10090c:	39 c2                	cmp    %eax,%edx
  10090e:	73 21                	jae    100931 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	89 d0                	mov    %edx,%eax
  100917:	01 c0                	add    %eax,%eax
  100919:	01 d0                	add    %edx,%eax
  10091b:	c1 e0 02             	shl    $0x2,%eax
  10091e:	89 c2                	mov    %eax,%edx
  100920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100923:	01 d0                	add    %edx,%eax
  100925:	8b 10                	mov    (%eax),%edx
  100927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10092a:	01 c2                	add    %eax,%edx
  10092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10092f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100931:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100934:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100937:	39 c2                	cmp    %eax,%edx
  100939:	7d 46                	jge    100981 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10093e:	40                   	inc    %eax
  10093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100942:	eb 16                	jmp    10095a <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100944:	8b 45 0c             	mov    0xc(%ebp),%eax
  100947:	8b 40 14             	mov    0x14(%eax),%eax
  10094a:	8d 50 01             	lea    0x1(%eax),%edx
  10094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100950:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100956:	40                   	inc    %eax
  100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10095d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100960:	39 c2                	cmp    %eax,%edx
  100962:	7d 1d                	jge    100981 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	89 d0                	mov    %edx,%eax
  10096b:	01 c0                	add    %eax,%eax
  10096d:	01 d0                	add    %edx,%eax
  10096f:	c1 e0 02             	shl    $0x2,%eax
  100972:	89 c2                	mov    %eax,%edx
  100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100977:	01 d0                	add    %edx,%eax
  100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10097d:	3c a0                	cmp    $0xa0,%al
  10097f:	74 c3                	je     100944 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100986:	c9                   	leave  
  100987:	c3                   	ret    

00100988 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100988:	f3 0f 1e fb          	endbr32 
  10098c:	55                   	push   %ebp
  10098d:	89 e5                	mov    %esp,%ebp
  10098f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100992:	c7 04 24 02 75 10 00 	movl   $0x107502,(%esp)
  100999:	e8 27 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10099e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009a5:	00 
  1009a6:	c7 04 24 1b 75 10 00 	movl   $0x10751b,(%esp)
  1009ad:	e8 13 f9 ff ff       	call   1002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b2:	c7 44 24 04 e9 73 10 	movl   $0x1073e9,0x4(%esp)
  1009b9:	00 
  1009ba:	c7 04 24 33 75 10 00 	movl   $0x107533,(%esp)
  1009c1:	e8 ff f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009c6:	c7 44 24 04 36 ca 11 	movl   $0x11ca36,0x4(%esp)
  1009cd:	00 
  1009ce:	c7 04 24 4b 75 10 00 	movl   $0x10754b,(%esp)
  1009d5:	e8 eb f8 ff ff       	call   1002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009da:	c7 44 24 04 20 00 12 	movl   $0x120020,0x4(%esp)
  1009e1:	00 
  1009e2:	c7 04 24 63 75 10 00 	movl   $0x107563,(%esp)
  1009e9:	e8 d7 f8 ff ff       	call   1002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009ee:	b8 20 00 12 00       	mov    $0x120020,%eax
  1009f3:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a03:	85 c0                	test   %eax,%eax
  100a05:	0f 48 c2             	cmovs  %edx,%eax
  100a08:	c1 f8 0a             	sar    $0xa,%eax
  100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0f:	c7 04 24 7c 75 10 00 	movl   $0x10757c,(%esp)
  100a16:	e8 aa f8 ff ff       	call   1002c5 <cprintf>
}
  100a1b:	90                   	nop
  100a1c:	c9                   	leave  
  100a1d:	c3                   	ret    

00100a1e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a1e:	f3 0f 1e fb          	endbr32 
  100a22:	55                   	push   %ebp
  100a23:	89 e5                	mov    %esp,%ebp
  100a25:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a2b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a32:	8b 45 08             	mov    0x8(%ebp),%eax
  100a35:	89 04 24             	mov    %eax,(%esp)
  100a38:	e8 21 fc ff ff       	call   10065e <debuginfo_eip>
  100a3d:	85 c0                	test   %eax,%eax
  100a3f:	74 15                	je     100a56 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a41:	8b 45 08             	mov    0x8(%ebp),%eax
  100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a48:	c7 04 24 a6 75 10 00 	movl   $0x1075a6,(%esp)
  100a4f:	e8 71 f8 ff ff       	call   1002c5 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a54:	eb 6c                	jmp    100ac2 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a5d:	eb 1b                	jmp    100a7a <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	01 d0                	add    %edx,%eax
  100a67:	0f b6 10             	movzbl (%eax),%edx
  100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a73:	01 c8                	add    %ecx,%eax
  100a75:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a77:	ff 45 f4             	incl   -0xc(%ebp)
  100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a80:	7c dd                	jl     100a5f <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a82:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8b:	01 d0                	add    %edx,%eax
  100a8d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a93:	8b 55 08             	mov    0x8(%ebp),%edx
  100a96:	89 d1                	mov    %edx,%ecx
  100a98:	29 c1                	sub    %eax,%ecx
  100a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aa0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100aa4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100aaa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100aae:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 c2 75 10 00 	movl   $0x1075c2,(%esp)
  100abd:	e8 03 f8 ff ff       	call   1002c5 <cprintf>
}
  100ac2:	90                   	nop
  100ac3:	c9                   	leave  
  100ac4:	c3                   	ret    

00100ac5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100ac5:	f3 0f 1e fb          	endbr32 
  100ac9:	55                   	push   %ebp
  100aca:	89 e5                	mov    %esp,%ebp
  100acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100acf:	8b 45 04             	mov    0x4(%ebp),%eax
  100ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100ad8:	c9                   	leave  
  100ad9:	c3                   	ret    

00100ada <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100ada:	f3 0f 1e fb          	endbr32 
  100ade:	55                   	push   %ebp
  100adf:	89 e5                	mov    %esp,%ebp
  100ae1:	53                   	push   %ebx
  100ae2:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ae5:	89 e8                	mov    %ebp,%eax
  100ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
  100aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
  100af0:	e8 d0 ff ff ff       	call   100ac5 <read_eip>
  100af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;   //这里有个细节问题，就是不能for int i，这里面的C标准似乎不允许
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
  100af8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aff:	eb 7e                	jmp    100b7f <print_stackframe+0xa5>
	{
		cprintf("ebp:0x%08x eip:0x%08x\n",ebp,eip);
  100b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0f:	c7 04 24 d4 75 10 00 	movl   $0x1075d4,(%esp)
  100b16:	e8 aa f7 ff ff       	call   1002c5 <cprintf>
		uint32_t *args=(uint32_t *)ebp+2;
  100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b1e:	83 c0 08             	add    $0x8,%eax
  100b21:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("arg :0x%08x 0x%08x 0x%08x 0x%08x\n",*(args+0),*(args+1),*(args+2),*(args+3));//依次打印调用函数的参数1 2 3 4
  100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b27:	83 c0 0c             	add    $0xc,%eax
  100b2a:	8b 18                	mov    (%eax),%ebx
  100b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b2f:	83 c0 08             	add    $0x8,%eax
  100b32:	8b 08                	mov    (%eax),%ecx
  100b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b37:	83 c0 04             	add    $0x4,%eax
  100b3a:	8b 10                	mov    (%eax),%edx
  100b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b3f:	8b 00                	mov    (%eax),%eax
  100b41:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b45:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b49:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b51:	c7 04 24 ec 75 10 00 	movl   $0x1075ec,(%esp)
  100b58:	e8 68 f7 ff ff       	call   1002c5 <cprintf>
 
 
    //因为使用的是栈数据结构，因此可以直接根据ebp就能读取到各个栈帧的地址和值，ebp+4处为返回地址，
    //ebp+8处为第一个参数值（最后一个入栈的参数值，对应32位系统），ebp-4处为第一个局部变量，ebp处为上一层 ebp 值。

		print_debuginfo(eip-1);
  100b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b60:	48                   	dec    %eax
  100b61:	89 04 24             	mov    %eax,(%esp)
  100b64:	e8 b5 fe ff ff       	call   100a1e <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
  100b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6c:	83 c0 04             	add    $0x4,%eax
  100b6f:	8b 00                	mov    (%eax),%eax
  100b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
  100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b77:	8b 00                	mov    (%eax),%eax
  100b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
  100b7c:	ff 45 ec             	incl   -0x14(%ebp)
  100b7f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b83:	7f 0a                	jg     100b8f <print_stackframe+0xb5>
  100b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b89:	0f 85 72 ff ff ff    	jne    100b01 <print_stackframe+0x27>
    }
}
  100b8f:	90                   	nop
  100b90:	83 c4 44             	add    $0x44,%esp
  100b93:	5b                   	pop    %ebx
  100b94:	5d                   	pop    %ebp
  100b95:	c3                   	ret    

00100b96 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b96:	f3 0f 1e fb          	endbr32 
  100b9a:	55                   	push   %ebp
  100b9b:	89 e5                	mov    %esp,%ebp
  100b9d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba7:	eb 0c                	jmp    100bb5 <parse+0x1f>
            *buf ++ = '\0';
  100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bac:	8d 50 01             	lea    0x1(%eax),%edx
  100baf:	89 55 08             	mov    %edx,0x8(%ebp)
  100bb2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb8:	0f b6 00             	movzbl (%eax),%eax
  100bbb:	84 c0                	test   %al,%al
  100bbd:	74 1d                	je     100bdc <parse+0x46>
  100bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc2:	0f b6 00             	movzbl (%eax),%eax
  100bc5:	0f be c0             	movsbl %al,%eax
  100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcc:	c7 04 24 90 76 10 00 	movl   $0x107690,(%esp)
  100bd3:	e8 2b 5e 00 00       	call   106a03 <strchr>
  100bd8:	85 c0                	test   %eax,%eax
  100bda:	75 cd                	jne    100ba9 <parse+0x13>
        }
        if (*buf == '\0') {
  100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdf:	0f b6 00             	movzbl (%eax),%eax
  100be2:	84 c0                	test   %al,%al
  100be4:	74 65                	je     100c4b <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100be6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bea:	75 14                	jne    100c00 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bf3:	00 
  100bf4:	c7 04 24 95 76 10 00 	movl   $0x107695,(%esp)
  100bfb:	e8 c5 f6 ff ff       	call   1002c5 <cprintf>
        }
        argv[argc ++] = buf;
  100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c03:	8d 50 01             	lea    0x1(%eax),%edx
  100c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c13:	01 c2                	add    %eax,%edx
  100c15:	8b 45 08             	mov    0x8(%ebp),%eax
  100c18:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1a:	eb 03                	jmp    100c1f <parse+0x89>
            buf ++;
  100c1c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c22:	0f b6 00             	movzbl (%eax),%eax
  100c25:	84 c0                	test   %al,%al
  100c27:	74 8c                	je     100bb5 <parse+0x1f>
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	0f b6 00             	movzbl (%eax),%eax
  100c2f:	0f be c0             	movsbl %al,%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	c7 04 24 90 76 10 00 	movl   $0x107690,(%esp)
  100c3d:	e8 c1 5d 00 00       	call   106a03 <strchr>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	74 d6                	je     100c1c <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c46:	e9 6a ff ff ff       	jmp    100bb5 <parse+0x1f>
            break;
  100c4b:	90                   	nop
        }
    }
    return argc;
  100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

00100c51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c51:	f3 0f 1e fb          	endbr32 
  100c55:	55                   	push   %ebp
  100c56:	89 e5                	mov    %esp,%ebp
  100c58:	53                   	push   %ebx
  100c59:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c63:	8b 45 08             	mov    0x8(%ebp),%eax
  100c66:	89 04 24             	mov    %eax,(%esp)
  100c69:	e8 28 ff ff ff       	call   100b96 <parse>
  100c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c75:	75 0a                	jne    100c81 <runcmd+0x30>
        return 0;
  100c77:	b8 00 00 00 00       	mov    $0x0,%eax
  100c7c:	e9 83 00 00 00       	jmp    100d04 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c88:	eb 5a                	jmp    100ce4 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c8a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c90:	89 d0                	mov    %edx,%eax
  100c92:	01 c0                	add    %eax,%eax
  100c94:	01 d0                	add    %edx,%eax
  100c96:	c1 e0 02             	shl    $0x2,%eax
  100c99:	05 00 c0 11 00       	add    $0x11c000,%eax
  100c9e:	8b 00                	mov    (%eax),%eax
  100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca4:	89 04 24             	mov    %eax,(%esp)
  100ca7:	e8 b3 5c 00 00       	call   10695f <strcmp>
  100cac:	85 c0                	test   %eax,%eax
  100cae:	75 31                	jne    100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cb3:	89 d0                	mov    %edx,%eax
  100cb5:	01 c0                	add    %eax,%eax
  100cb7:	01 d0                	add    %edx,%eax
  100cb9:	c1 e0 02             	shl    $0x2,%eax
  100cbc:	05 08 c0 11 00       	add    $0x11c008,%eax
  100cc1:	8b 10                	mov    (%eax),%edx
  100cc3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cc6:	83 c0 04             	add    $0x4,%eax
  100cc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ccc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cd2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cda:	89 1c 24             	mov    %ebx,(%esp)
  100cdd:	ff d2                	call   *%edx
  100cdf:	eb 23                	jmp    100d04 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce1:	ff 45 f4             	incl   -0xc(%ebp)
  100ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce7:	83 f8 02             	cmp    $0x2,%eax
  100cea:	76 9e                	jbe    100c8a <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf3:	c7 04 24 b3 76 10 00 	movl   $0x1076b3,(%esp)
  100cfa:	e8 c6 f5 ff ff       	call   1002c5 <cprintf>
    return 0;
  100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d04:	83 c4 64             	add    $0x64,%esp
  100d07:	5b                   	pop    %ebx
  100d08:	5d                   	pop    %ebp
  100d09:	c3                   	ret    

00100d0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d0a:	f3 0f 1e fb          	endbr32 
  100d0e:	55                   	push   %ebp
  100d0f:	89 e5                	mov    %esp,%ebp
  100d11:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d14:	c7 04 24 cc 76 10 00 	movl   $0x1076cc,(%esp)
  100d1b:	e8 a5 f5 ff ff       	call   1002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d20:	c7 04 24 f4 76 10 00 	movl   $0x1076f4,(%esp)
  100d27:	e8 99 f5 ff ff       	call   1002c5 <cprintf>

    if (tf != NULL) {
  100d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d30:	74 0b                	je     100d3d <kmonitor+0x33>
        print_trapframe(tf);
  100d32:	8b 45 08             	mov    0x8(%ebp),%eax
  100d35:	89 04 24             	mov    %eax,(%esp)
  100d38:	e8 db 0e 00 00       	call   101c18 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d3d:	c7 04 24 19 77 10 00 	movl   $0x107719,(%esp)
  100d44:	e8 2f f6 ff ff       	call   100378 <readline>
  100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d50:	74 eb                	je     100d3d <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d52:	8b 45 08             	mov    0x8(%ebp),%eax
  100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5c:	89 04 24             	mov    %eax,(%esp)
  100d5f:	e8 ed fe ff ff       	call   100c51 <runcmd>
  100d64:	85 c0                	test   %eax,%eax
  100d66:	78 02                	js     100d6a <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d68:	eb d3                	jmp    100d3d <kmonitor+0x33>
                break;
  100d6a:	90                   	nop
            }
        }
    }
}
  100d6b:	90                   	nop
  100d6c:	c9                   	leave  
  100d6d:	c3                   	ret    

00100d6e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d6e:	f3 0f 1e fb          	endbr32 
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
  100d75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d7f:	eb 3d                	jmp    100dbe <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d84:	89 d0                	mov    %edx,%eax
  100d86:	01 c0                	add    %eax,%eax
  100d88:	01 d0                	add    %edx,%eax
  100d8a:	c1 e0 02             	shl    $0x2,%eax
  100d8d:	05 04 c0 11 00       	add    $0x11c004,%eax
  100d92:	8b 08                	mov    (%eax),%ecx
  100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d97:	89 d0                	mov    %edx,%eax
  100d99:	01 c0                	add    %eax,%eax
  100d9b:	01 d0                	add    %edx,%eax
  100d9d:	c1 e0 02             	shl    $0x2,%eax
  100da0:	05 00 c0 11 00       	add    $0x11c000,%eax
  100da5:	8b 00                	mov    (%eax),%eax
  100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100daf:	c7 04 24 1d 77 10 00 	movl   $0x10771d,(%esp)
  100db6:	e8 0a f5 ff ff       	call   1002c5 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100dbb:	ff 45 f4             	incl   -0xc(%ebp)
  100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dc1:	83 f8 02             	cmp    $0x2,%eax
  100dc4:	76 bb                	jbe    100d81 <mon_help+0x13>
    }
    return 0;
  100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dcb:	c9                   	leave  
  100dcc:	c3                   	ret    

00100dcd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dcd:	f3 0f 1e fb          	endbr32 
  100dd1:	55                   	push   %ebp
  100dd2:	89 e5                	mov    %esp,%ebp
  100dd4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dd7:	e8 ac fb ff ff       	call   100988 <print_kerninfo>
    return 0;
  100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de1:	c9                   	leave  
  100de2:	c3                   	ret    

00100de3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100de3:	f3 0f 1e fb          	endbr32 
  100de7:	55                   	push   %ebp
  100de8:	89 e5                	mov    %esp,%ebp
  100dea:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ded:	e8 e8 fc ff ff       	call   100ada <print_stackframe>
    return 0;
  100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df7:	c9                   	leave  
  100df8:	c3                   	ret    

00100df9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100df9:	f3 0f 1e fb          	endbr32 
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 28             	sub    $0x28,%esp
  100e03:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e09:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e15:	ee                   	out    %al,(%dx)
}
  100e16:	90                   	nop
  100e17:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e1d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e29:	ee                   	out    %al,(%dx)
}
  100e2a:	90                   	nop
  100e2b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e31:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e35:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e39:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e3d:	ee                   	out    %al,(%dx)
}
  100e3e:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e3f:	c7 05 10 ff 11 00 00 	movl   $0x0,0x11ff10
  100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e49:	c7 04 24 26 77 10 00 	movl   $0x107726,(%esp)
  100e50:	e8 70 f4 ff ff       	call   1002c5 <cprintf>
    pic_enable(IRQ_TIMER);
  100e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e5c:	e8 95 09 00 00       	call   1017f6 <pic_enable>
}
  100e61:	90                   	nop
  100e62:	c9                   	leave  
  100e63:	c3                   	ret    

00100e64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e64:	55                   	push   %ebp
  100e65:	89 e5                	mov    %esp,%ebp
  100e67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e6a:	9c                   	pushf  
  100e6b:	58                   	pop    %eax
  100e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e72:	25 00 02 00 00       	and    $0x200,%eax
  100e77:	85 c0                	test   %eax,%eax
  100e79:	74 0c                	je     100e87 <__intr_save+0x23>
        intr_disable();
  100e7b:	e8 05 0b 00 00       	call   101985 <intr_disable>
        return 1;
  100e80:	b8 01 00 00 00       	mov    $0x1,%eax
  100e85:	eb 05                	jmp    100e8c <__intr_save+0x28>
    }
    return 0;
  100e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e8c:	c9                   	leave  
  100e8d:	c3                   	ret    

00100e8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e8e:	55                   	push   %ebp
  100e8f:	89 e5                	mov    %esp,%ebp
  100e91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e98:	74 05                	je     100e9f <__intr_restore+0x11>
        intr_enable();
  100e9a:	e8 da 0a 00 00       	call   101979 <intr_enable>
    }
}
  100e9f:	90                   	nop
  100ea0:	c9                   	leave  
  100ea1:	c3                   	ret    

00100ea2 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ea2:	f3 0f 1e fb          	endbr32 
  100ea6:	55                   	push   %ebp
  100ea7:	89 e5                	mov    %esp,%ebp
  100ea9:	83 ec 10             	sub    $0x10,%esp
  100eac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb6:	89 c2                	mov    %eax,%edx
  100eb8:	ec                   	in     (%dx),%al
  100eb9:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ebc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ecc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ed2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ed6:	89 c2                	mov    %eax,%edx
  100ed8:	ec                   	in     (%dx),%al
  100ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100edc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ee2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ee6:	89 c2                	mov    %eax,%edx
  100ee8:	ec                   	in     (%dx),%al
  100ee9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100eec:	90                   	nop
  100eed:	c9                   	leave  
  100eee:	c3                   	ret    

00100eef <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100eef:	f3 0f 1e fb          	endbr32 
  100ef3:	55                   	push   %ebp
  100ef4:	89 e5                	mov    %esp,%ebp
  100ef6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ef9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f03:	0f b7 00             	movzwl (%eax),%eax
  100f06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f15:	0f b7 00             	movzwl (%eax),%eax
  100f18:	0f b7 c0             	movzwl %ax,%eax
  100f1b:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f20:	74 12                	je     100f34 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f22:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f29:	66 c7 05 46 f4 11 00 	movw   $0x3b4,0x11f446
  100f30:	b4 03 
  100f32:	eb 13                	jmp    100f47 <cga_init+0x58>
    } else {
        *cp = was;
  100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f3e:	66 c7 05 46 f4 11 00 	movw   $0x3d4,0x11f446
  100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f47:	0f b7 05 46 f4 11 00 	movzwl 0x11f446,%eax
  100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
}
  100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f60:	0f b7 05 46 f4 11 00 	movzwl 0x11f446,%eax
  100f67:	40                   	inc    %eax
  100f68:	0f b7 c0             	movzwl %ax,%eax
  100f6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f73:	89 c2                	mov    %eax,%edx
  100f75:	ec                   	in     (%dx),%al
  100f76:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f79:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f7d:	0f b6 c0             	movzbl %al,%eax
  100f80:	c1 e0 08             	shl    $0x8,%eax
  100f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f86:	0f b7 05 46 f4 11 00 	movzwl 0x11f446,%eax
  100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f9d:	ee                   	out    %al,(%dx)
}
  100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f9f:	0f b7 05 46 f4 11 00 	movzwl 0x11f446,%eax
  100fa6:	40                   	inc    %eax
  100fa7:	0f b7 c0             	movzwl %ax,%eax
  100faa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fb2:	89 c2                	mov    %eax,%edx
  100fb4:	ec                   	in     (%dx),%al
  100fb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fbc:	0f b6 c0             	movzbl %al,%eax
  100fbf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fc5:	a3 40 f4 11 00       	mov    %eax,0x11f440
    crt_pos = pos;
  100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fcd:	0f b7 c0             	movzwl %ax,%eax
  100fd0:	66 a3 44 f4 11 00    	mov    %ax,0x11f444
}
  100fd6:	90                   	nop
  100fd7:	c9                   	leave  
  100fd8:	c3                   	ret    

00100fd9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd9:	f3 0f 1e fb          	endbr32 
  100fdd:	55                   	push   %ebp
  100fde:	89 e5                	mov    %esp,%ebp
  100fe0:	83 ec 48             	sub    $0x48,%esp
  100fe3:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fe9:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fed:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ff1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ff5:	ee                   	out    %al,(%dx)
}
  100ff6:	90                   	nop
  100ff7:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ffd:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101001:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101005:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101009:	ee                   	out    %al,(%dx)
}
  10100a:	90                   	nop
  10100b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101011:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101019:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10101d:	ee                   	out    %al,(%dx)
}
  10101e:	90                   	nop
  10101f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101025:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101029:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10102d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
}
  101032:	90                   	nop
  101033:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101039:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10103d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101041:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101045:	ee                   	out    %al,(%dx)
}
  101046:	90                   	nop
  101047:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  10104d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101051:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101055:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101059:	ee                   	out    %al,(%dx)
}
  10105a:	90                   	nop
  10105b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101061:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101069:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10106d:	ee                   	out    %al,(%dx)
}
  10106e:	90                   	nop
  10106f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101075:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101079:	89 c2                	mov    %eax,%edx
  10107b:	ec                   	in     (%dx),%al
  10107c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10107f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101083:	3c ff                	cmp    $0xff,%al
  101085:	0f 95 c0             	setne  %al
  101088:	0f b6 c0             	movzbl %al,%eax
  10108b:	a3 48 f4 11 00       	mov    %eax,0x11f448
  101090:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101096:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10109a:	89 c2                	mov    %eax,%edx
  10109c:	ec                   	in     (%dx),%al
  10109d:	88 45 f1             	mov    %al,-0xf(%ebp)
  1010a0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1010a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010aa:	89 c2                	mov    %eax,%edx
  1010ac:	ec                   	in     (%dx),%al
  1010ad:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010b0:	a1 48 f4 11 00       	mov    0x11f448,%eax
  1010b5:	85 c0                	test   %eax,%eax
  1010b7:	74 0c                	je     1010c5 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010c0:	e8 31 07 00 00       	call   1017f6 <pic_enable>
    }
}
  1010c5:	90                   	nop
  1010c6:	c9                   	leave  
  1010c7:	c3                   	ret    

001010c8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010c8:	f3 0f 1e fb          	endbr32 
  1010cc:	55                   	push   %ebp
  1010cd:	89 e5                	mov    %esp,%ebp
  1010cf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d9:	eb 08                	jmp    1010e3 <lpt_putc_sub+0x1b>
        delay();
  1010db:	e8 c2 fd ff ff       	call   100ea2 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010e0:	ff 45 fc             	incl   -0x4(%ebp)
  1010e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010ed:	89 c2                	mov    %eax,%edx
  1010ef:	ec                   	in     (%dx),%al
  1010f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010f7:	84 c0                	test   %al,%al
  1010f9:	78 09                	js     101104 <lpt_putc_sub+0x3c>
  1010fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101102:	7e d7                	jle    1010db <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	0f b6 c0             	movzbl %al,%eax
  10110a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101110:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101113:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101117:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10111b:	ee                   	out    %al,(%dx)
}
  10111c:	90                   	nop
  10111d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101123:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101127:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10112b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10112f:	ee                   	out    %al,(%dx)
}
  101130:	90                   	nop
  101131:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101137:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10113b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10113f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101143:	ee                   	out    %al,(%dx)
}
  101144:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101145:	90                   	nop
  101146:	c9                   	leave  
  101147:	c3                   	ret    

00101148 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101148:	f3 0f 1e fb          	endbr32 
  10114c:	55                   	push   %ebp
  10114d:	89 e5                	mov    %esp,%ebp
  10114f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101152:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101156:	74 0d                	je     101165 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101158:	8b 45 08             	mov    0x8(%ebp),%eax
  10115b:	89 04 24             	mov    %eax,(%esp)
  10115e:	e8 65 ff ff ff       	call   1010c8 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101163:	eb 24                	jmp    101189 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10116c:	e8 57 ff ff ff       	call   1010c8 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101171:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101178:	e8 4b ff ff ff       	call   1010c8 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10117d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101184:	e8 3f ff ff ff       	call   1010c8 <lpt_putc_sub>
}
  101189:	90                   	nop
  10118a:	c9                   	leave  
  10118b:	c3                   	ret    

0010118c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10118c:	f3 0f 1e fb          	endbr32 
  101190:	55                   	push   %ebp
  101191:	89 e5                	mov    %esp,%ebp
  101193:	53                   	push   %ebx
  101194:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101197:	8b 45 08             	mov    0x8(%ebp),%eax
  10119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10119f:	85 c0                	test   %eax,%eax
  1011a1:	75 07                	jne    1011aa <cga_putc+0x1e>
        c |= 0x0700;
  1011a3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ad:	0f b6 c0             	movzbl %al,%eax
  1011b0:	83 f8 0d             	cmp    $0xd,%eax
  1011b3:	74 72                	je     101227 <cga_putc+0x9b>
  1011b5:	83 f8 0d             	cmp    $0xd,%eax
  1011b8:	0f 8f a3 00 00 00    	jg     101261 <cga_putc+0xd5>
  1011be:	83 f8 08             	cmp    $0x8,%eax
  1011c1:	74 0a                	je     1011cd <cga_putc+0x41>
  1011c3:	83 f8 0a             	cmp    $0xa,%eax
  1011c6:	74 4c                	je     101214 <cga_putc+0x88>
  1011c8:	e9 94 00 00 00       	jmp    101261 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011cd:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  1011d4:	85 c0                	test   %eax,%eax
  1011d6:	0f 84 af 00 00 00    	je     10128b <cga_putc+0xff>
            crt_pos --;
  1011dc:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  1011e3:	48                   	dec    %eax
  1011e4:	0f b7 c0             	movzwl %ax,%eax
  1011e7:	66 a3 44 f4 11 00    	mov    %ax,0x11f444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1011f0:	98                   	cwtl   
  1011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011f6:	98                   	cwtl   
  1011f7:	83 c8 20             	or     $0x20,%eax
  1011fa:	98                   	cwtl   
  1011fb:	8b 15 40 f4 11 00    	mov    0x11f440,%edx
  101201:	0f b7 0d 44 f4 11 00 	movzwl 0x11f444,%ecx
  101208:	01 c9                	add    %ecx,%ecx
  10120a:	01 ca                	add    %ecx,%edx
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101212:	eb 77                	jmp    10128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101214:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  10121b:	83 c0 50             	add    $0x50,%eax
  10121e:	0f b7 c0             	movzwl %ax,%eax
  101221:	66 a3 44 f4 11 00    	mov    %ax,0x11f444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101227:	0f b7 1d 44 f4 11 00 	movzwl 0x11f444,%ebx
  10122e:	0f b7 0d 44 f4 11 00 	movzwl 0x11f444,%ecx
  101235:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10123a:	89 c8                	mov    %ecx,%eax
  10123c:	f7 e2                	mul    %edx
  10123e:	c1 ea 06             	shr    $0x6,%edx
  101241:	89 d0                	mov    %edx,%eax
  101243:	c1 e0 02             	shl    $0x2,%eax
  101246:	01 d0                	add    %edx,%eax
  101248:	c1 e0 04             	shl    $0x4,%eax
  10124b:	29 c1                	sub    %eax,%ecx
  10124d:	89 c8                	mov    %ecx,%eax
  10124f:	0f b7 c0             	movzwl %ax,%eax
  101252:	29 c3                	sub    %eax,%ebx
  101254:	89 d8                	mov    %ebx,%eax
  101256:	0f b7 c0             	movzwl %ax,%eax
  101259:	66 a3 44 f4 11 00    	mov    %ax,0x11f444
        break;
  10125f:	eb 2b                	jmp    10128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101261:	8b 0d 40 f4 11 00    	mov    0x11f440,%ecx
  101267:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  10126e:	8d 50 01             	lea    0x1(%eax),%edx
  101271:	0f b7 d2             	movzwl %dx,%edx
  101274:	66 89 15 44 f4 11 00 	mov    %dx,0x11f444
  10127b:	01 c0                	add    %eax,%eax
  10127d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101280:	8b 45 08             	mov    0x8(%ebp),%eax
  101283:	0f b7 c0             	movzwl %ax,%eax
  101286:	66 89 02             	mov    %ax,(%edx)
        break;
  101289:	eb 01                	jmp    10128c <cga_putc+0x100>
        break;
  10128b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10128c:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101298:	76 5d                	jbe    1012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10129a:	a1 40 f4 11 00       	mov    0x11f440,%eax
  10129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1012a5:	a1 40 f4 11 00       	mov    0x11f440,%eax
  1012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012b1:	00 
  1012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012b6:	89 04 24             	mov    %eax,(%esp)
  1012b9:	e8 4a 59 00 00       	call   106c08 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012c5:	eb 14                	jmp    1012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012c7:	a1 40 f4 11 00       	mov    0x11f440,%eax
  1012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012cf:	01 d2                	add    %edx,%edx
  1012d1:	01 d0                	add    %edx,%eax
  1012d3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012d8:	ff 45 f4             	incl   -0xc(%ebp)
  1012db:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012e2:	7e e3                	jle    1012c7 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012e4:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  1012eb:	83 e8 50             	sub    $0x50,%eax
  1012ee:	0f b7 c0             	movzwl %ax,%eax
  1012f1:	66 a3 44 f4 11 00    	mov    %ax,0x11f444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012f7:	0f b7 05 46 f4 11 00 	movzwl 0x11f446,%eax
  1012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10130e:	ee                   	out    %al,(%dx)
}
  10130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101310:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  101317:	c1 e8 08             	shr    $0x8,%eax
  10131a:	0f b7 c0             	movzwl %ax,%eax
  10131d:	0f b6 c0             	movzbl %al,%eax
  101320:	0f b7 15 46 f4 11 00 	movzwl 0x11f446,%edx
  101327:	42                   	inc    %edx
  101328:	0f b7 d2             	movzwl %dx,%edx
  10132b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10132f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101332:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101336:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10133a:	ee                   	out    %al,(%dx)
}
  10133b:	90                   	nop
    outb(addr_6845, 15);
  10133c:	0f b7 05 46 f4 11 00 	movzwl 0x11f446,%eax
  101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101353:	ee                   	out    %al,(%dx)
}
  101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101355:	0f b7 05 44 f4 11 00 	movzwl 0x11f444,%eax
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	0f b7 15 46 f4 11 00 	movzwl 0x11f446,%edx
  101366:	42                   	inc    %edx
  101367:	0f b7 d2             	movzwl %dx,%edx
  10136a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10136e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101371:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101375:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101379:	ee                   	out    %al,(%dx)
}
  10137a:	90                   	nop
}
  10137b:	90                   	nop
  10137c:	83 c4 34             	add    $0x34,%esp
  10137f:	5b                   	pop    %ebx
  101380:	5d                   	pop    %ebp
  101381:	c3                   	ret    

00101382 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101382:	f3 0f 1e fb          	endbr32 
  101386:	55                   	push   %ebp
  101387:	89 e5                	mov    %esp,%ebp
  101389:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101393:	eb 08                	jmp    10139d <serial_putc_sub+0x1b>
        delay();
  101395:	e8 08 fb ff ff       	call   100ea2 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10139a:	ff 45 fc             	incl   -0x4(%ebp)
  10139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a7:	89 c2                	mov    %eax,%edx
  1013a9:	ec                   	in     (%dx),%al
  1013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013b1:	0f b6 c0             	movzbl %al,%eax
  1013b4:	83 e0 20             	and    $0x20,%eax
  1013b7:	85 c0                	test   %eax,%eax
  1013b9:	75 09                	jne    1013c4 <serial_putc_sub+0x42>
  1013bb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013c2:	7e d1                	jle    101395 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013db:	ee                   	out    %al,(%dx)
}
  1013dc:	90                   	nop
}
  1013dd:	90                   	nop
  1013de:	c9                   	leave  
  1013df:	c3                   	ret    

001013e0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013e0:	f3 0f 1e fb          	endbr32 
  1013e4:	55                   	push   %ebp
  1013e5:	89 e5                	mov    %esp,%ebp
  1013e7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013ea:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013ee:	74 0d                	je     1013fd <serial_putc+0x1d>
        serial_putc_sub(c);
  1013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1013f3:	89 04 24             	mov    %eax,(%esp)
  1013f6:	e8 87 ff ff ff       	call   101382 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013fb:	eb 24                	jmp    101421 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101404:	e8 79 ff ff ff       	call   101382 <serial_putc_sub>
        serial_putc_sub(' ');
  101409:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101410:	e8 6d ff ff ff       	call   101382 <serial_putc_sub>
        serial_putc_sub('\b');
  101415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10141c:	e8 61 ff ff ff       	call   101382 <serial_putc_sub>
}
  101421:	90                   	nop
  101422:	c9                   	leave  
  101423:	c3                   	ret    

00101424 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101424:	f3 0f 1e fb          	endbr32 
  101428:	55                   	push   %ebp
  101429:	89 e5                	mov    %esp,%ebp
  10142b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10142e:	eb 33                	jmp    101463 <cons_intr+0x3f>
        if (c != 0) {
  101430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101434:	74 2d                	je     101463 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  101436:	a1 64 f6 11 00       	mov    0x11f664,%eax
  10143b:	8d 50 01             	lea    0x1(%eax),%edx
  10143e:	89 15 64 f6 11 00    	mov    %edx,0x11f664
  101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101447:	88 90 60 f4 11 00    	mov    %dl,0x11f460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10144d:	a1 64 f6 11 00       	mov    0x11f664,%eax
  101452:	3d 00 02 00 00       	cmp    $0x200,%eax
  101457:	75 0a                	jne    101463 <cons_intr+0x3f>
                cons.wpos = 0;
  101459:	c7 05 64 f6 11 00 00 	movl   $0x0,0x11f664
  101460:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101463:	8b 45 08             	mov    0x8(%ebp),%eax
  101466:	ff d0                	call   *%eax
  101468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10146b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10146f:	75 bf                	jne    101430 <cons_intr+0xc>
            }
        }
    }
}
  101471:	90                   	nop
  101472:	90                   	nop
  101473:	c9                   	leave  
  101474:	c3                   	ret    

00101475 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101475:	f3 0f 1e fb          	endbr32 
  101479:	55                   	push   %ebp
  10147a:	89 e5                	mov    %esp,%ebp
  10147c:	83 ec 10             	sub    $0x10,%esp
  10147f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101485:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101489:	89 c2                	mov    %eax,%edx
  10148b:	ec                   	in     (%dx),%al
  10148c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10148f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101493:	0f b6 c0             	movzbl %al,%eax
  101496:	83 e0 01             	and    $0x1,%eax
  101499:	85 c0                	test   %eax,%eax
  10149b:	75 07                	jne    1014a4 <serial_proc_data+0x2f>
        return -1;
  10149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a2:	eb 2a                	jmp    1014ce <serial_proc_data+0x59>
  1014a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014ae:	89 c2                	mov    %eax,%edx
  1014b0:	ec                   	in     (%dx),%al
  1014b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014b8:	0f b6 c0             	movzbl %al,%eax
  1014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014c2:	75 07                	jne    1014cb <serial_proc_data+0x56>
        c = '\b';
  1014c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014ce:	c9                   	leave  
  1014cf:	c3                   	ret    

001014d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014d0:	f3 0f 1e fb          	endbr32 
  1014d4:	55                   	push   %ebp
  1014d5:	89 e5                	mov    %esp,%ebp
  1014d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014da:	a1 48 f4 11 00       	mov    0x11f448,%eax
  1014df:	85 c0                	test   %eax,%eax
  1014e1:	74 0c                	je     1014ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014e3:	c7 04 24 75 14 10 00 	movl   $0x101475,(%esp)
  1014ea:	e8 35 ff ff ff       	call   101424 <cons_intr>
    }
}
  1014ef:	90                   	nop
  1014f0:	c9                   	leave  
  1014f1:	c3                   	ret    

001014f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014f2:	f3 0f 1e fb          	endbr32 
  1014f6:	55                   	push   %ebp
  1014f7:	89 e5                	mov    %esp,%ebp
  1014f9:	83 ec 38             	sub    $0x38,%esp
  1014fc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101505:	89 c2                	mov    %eax,%edx
  101507:	ec                   	in     (%dx),%al
  101508:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10150b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10150f:	0f b6 c0             	movzbl %al,%eax
  101512:	83 e0 01             	and    $0x1,%eax
  101515:	85 c0                	test   %eax,%eax
  101517:	75 0a                	jne    101523 <kbd_proc_data+0x31>
        return -1;
  101519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10151e:	e9 56 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
  101523:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10152c:	89 c2                	mov    %eax,%edx
  10152e:	ec                   	in     (%dx),%al
  10152f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101532:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101536:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101539:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10153d:	75 17                	jne    101556 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  10153f:	a1 68 f6 11 00       	mov    0x11f668,%eax
  101544:	83 c8 40             	or     $0x40,%eax
  101547:	a3 68 f6 11 00       	mov    %eax,0x11f668
        return 0;
  10154c:	b8 00 00 00 00       	mov    $0x0,%eax
  101551:	e9 23 01 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155a:	84 c0                	test   %al,%al
  10155c:	79 45                	jns    1015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10155e:	a1 68 f6 11 00       	mov    0x11f668,%eax
  101563:	83 e0 40             	and    $0x40,%eax
  101566:	85 c0                	test   %eax,%eax
  101568:	75 08                	jne    101572 <kbd_proc_data+0x80>
  10156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156e:	24 7f                	and    $0x7f,%al
  101570:	eb 04                	jmp    101576 <kbd_proc_data+0x84>
  101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101576:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101579:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157d:	0f b6 80 40 c0 11 00 	movzbl 0x11c040(%eax),%eax
  101584:	0c 40                	or     $0x40,%al
  101586:	0f b6 c0             	movzbl %al,%eax
  101589:	f7 d0                	not    %eax
  10158b:	89 c2                	mov    %eax,%edx
  10158d:	a1 68 f6 11 00       	mov    0x11f668,%eax
  101592:	21 d0                	and    %edx,%eax
  101594:	a3 68 f6 11 00       	mov    %eax,0x11f668
        return 0;
  101599:	b8 00 00 00 00       	mov    $0x0,%eax
  10159e:	e9 d6 00 00 00       	jmp    101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1015a3:	a1 68 f6 11 00       	mov    0x11f668,%eax
  1015a8:	83 e0 40             	and    $0x40,%eax
  1015ab:	85 c0                	test   %eax,%eax
  1015ad:	74 11                	je     1015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015b3:	a1 68 f6 11 00       	mov    0x11f668,%eax
  1015b8:	83 e0 bf             	and    $0xffffffbf,%eax
  1015bb:	a3 68 f6 11 00       	mov    %eax,0x11f668
    }

    shift |= shiftcode[data];
  1015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015c4:	0f b6 80 40 c0 11 00 	movzbl 0x11c040(%eax),%eax
  1015cb:	0f b6 d0             	movzbl %al,%edx
  1015ce:	a1 68 f6 11 00       	mov    0x11f668,%eax
  1015d3:	09 d0                	or     %edx,%eax
  1015d5:	a3 68 f6 11 00       	mov    %eax,0x11f668
    shift ^= togglecode[data];
  1015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015de:	0f b6 80 40 c1 11 00 	movzbl 0x11c140(%eax),%eax
  1015e5:	0f b6 d0             	movzbl %al,%edx
  1015e8:	a1 68 f6 11 00       	mov    0x11f668,%eax
  1015ed:	31 d0                	xor    %edx,%eax
  1015ef:	a3 68 f6 11 00       	mov    %eax,0x11f668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015f4:	a1 68 f6 11 00       	mov    0x11f668,%eax
  1015f9:	83 e0 03             	and    $0x3,%eax
  1015fc:	8b 14 85 40 c5 11 00 	mov    0x11c540(,%eax,4),%edx
  101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101607:	01 d0                	add    %edx,%eax
  101609:	0f b6 00             	movzbl (%eax),%eax
  10160c:	0f b6 c0             	movzbl %al,%eax
  10160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101612:	a1 68 f6 11 00       	mov    0x11f668,%eax
  101617:	83 e0 08             	and    $0x8,%eax
  10161a:	85 c0                	test   %eax,%eax
  10161c:	74 22                	je     101640 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10161e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101622:	7e 0c                	jle    101630 <kbd_proc_data+0x13e>
  101624:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101628:	7f 06                	jg     101630 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10162a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10162e:	eb 10                	jmp    101640 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101630:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101634:	7e 0a                	jle    101640 <kbd_proc_data+0x14e>
  101636:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10163a:	7f 04                	jg     101640 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10163c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101640:	a1 68 f6 11 00       	mov    0x11f668,%eax
  101645:	f7 d0                	not    %eax
  101647:	83 e0 06             	and    $0x6,%eax
  10164a:	85 c0                	test   %eax,%eax
  10164c:	75 28                	jne    101676 <kbd_proc_data+0x184>
  10164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101655:	75 1f                	jne    101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101657:	c7 04 24 41 77 10 00 	movl   $0x107741,(%esp)
  10165e:	e8 62 ec ff ff       	call   1002c5 <cprintf>
  101663:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101669:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10166d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101671:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101674:	ee                   	out    %al,(%dx)
}
  101675:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101679:	c9                   	leave  
  10167a:	c3                   	ret    

0010167b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10167b:	f3 0f 1e fb          	endbr32 
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101685:	c7 04 24 f2 14 10 00 	movl   $0x1014f2,(%esp)
  10168c:	e8 93 fd ff ff       	call   101424 <cons_intr>
}
  101691:	90                   	nop
  101692:	c9                   	leave  
  101693:	c3                   	ret    

00101694 <kbd_init>:

static void
kbd_init(void) {
  101694:	f3 0f 1e fb          	endbr32 
  101698:	55                   	push   %ebp
  101699:	89 e5                	mov    %esp,%ebp
  10169b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10169e:	e8 d8 ff ff ff       	call   10167b <kbd_intr>
    pic_enable(IRQ_KBD);
  1016a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016aa:	e8 47 01 00 00       	call   1017f6 <pic_enable>
}
  1016af:	90                   	nop
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016b2:	f3 0f 1e fb          	endbr32 
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016bc:	e8 2e f8 ff ff       	call   100eef <cga_init>
    serial_init();
  1016c1:	e8 13 f9 ff ff       	call   100fd9 <serial_init>
    kbd_init();
  1016c6:	e8 c9 ff ff ff       	call   101694 <kbd_init>
    if (!serial_exists) {
  1016cb:	a1 48 f4 11 00       	mov    0x11f448,%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	75 0c                	jne    1016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016d4:	c7 04 24 4d 77 10 00 	movl   $0x10774d,(%esp)
  1016db:	e8 e5 eb ff ff       	call   1002c5 <cprintf>
    }
}
  1016e0:	90                   	nop
  1016e1:	c9                   	leave  
  1016e2:	c3                   	ret    

001016e3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016e3:	f3 0f 1e fb          	endbr32 
  1016e7:	55                   	push   %ebp
  1016e8:	89 e5                	mov    %esp,%ebp
  1016ea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016ed:	e8 72 f7 ff ff       	call   100e64 <__intr_save>
  1016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f8:	89 04 24             	mov    %eax,(%esp)
  1016fb:	e8 48 fa ff ff       	call   101148 <lpt_putc>
        cga_putc(c);
  101700:	8b 45 08             	mov    0x8(%ebp),%eax
  101703:	89 04 24             	mov    %eax,(%esp)
  101706:	e8 81 fa ff ff       	call   10118c <cga_putc>
        serial_putc(c);
  10170b:	8b 45 08             	mov    0x8(%ebp),%eax
  10170e:	89 04 24             	mov    %eax,(%esp)
  101711:	e8 ca fc ff ff       	call   1013e0 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101719:	89 04 24             	mov    %eax,(%esp)
  10171c:	e8 6d f7 ff ff       	call   100e8e <__intr_restore>
}
  101721:	90                   	nop
  101722:	c9                   	leave  
  101723:	c3                   	ret    

00101724 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101724:	f3 0f 1e fb          	endbr32 
  101728:	55                   	push   %ebp
  101729:	89 e5                	mov    %esp,%ebp
  10172b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101735:	e8 2a f7 ff ff       	call   100e64 <__intr_save>
  10173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10173d:	e8 8e fd ff ff       	call   1014d0 <serial_intr>
        kbd_intr();
  101742:	e8 34 ff ff ff       	call   10167b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101747:	8b 15 60 f6 11 00    	mov    0x11f660,%edx
  10174d:	a1 64 f6 11 00       	mov    0x11f664,%eax
  101752:	39 c2                	cmp    %eax,%edx
  101754:	74 31                	je     101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  101756:	a1 60 f6 11 00       	mov    0x11f660,%eax
  10175b:	8d 50 01             	lea    0x1(%eax),%edx
  10175e:	89 15 60 f6 11 00    	mov    %edx,0x11f660
  101764:	0f b6 80 60 f4 11 00 	movzbl 0x11f460(%eax),%eax
  10176b:	0f b6 c0             	movzbl %al,%eax
  10176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101771:	a1 60 f6 11 00       	mov    0x11f660,%eax
  101776:	3d 00 02 00 00       	cmp    $0x200,%eax
  10177b:	75 0a                	jne    101787 <cons_getc+0x63>
                cons.rpos = 0;
  10177d:	c7 05 60 f6 11 00 00 	movl   $0x0,0x11f660
  101784:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10178a:	89 04 24             	mov    %eax,(%esp)
  10178d:	e8 fc f6 ff ff       	call   100e8e <__intr_restore>
    return c;
  101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101795:	c9                   	leave  
  101796:	c3                   	ret    

00101797 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101797:	f3 0f 1e fb          	endbr32 
  10179b:	55                   	push   %ebp
  10179c:	89 e5                	mov    %esp,%ebp
  10179e:	83 ec 14             	sub    $0x14,%esp
  1017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017ab:	66 a3 50 c5 11 00    	mov    %ax,0x11c550
    if (did_init) {
  1017b1:	a1 6c f6 11 00       	mov    0x11f66c,%eax
  1017b6:	85 c0                	test   %eax,%eax
  1017b8:	74 39                	je     1017f3 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017bd:	0f b6 c0             	movzbl %al,%eax
  1017c0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017d1:	ee                   	out    %al,(%dx)
}
  1017d2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017d7:	c1 e8 08             	shr    $0x8,%eax
  1017da:	0f b7 c0             	movzwl %ax,%eax
  1017dd:	0f b6 c0             	movzbl %al,%eax
  1017e0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017e6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017ed:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017f1:	ee                   	out    %al,(%dx)
}
  1017f2:	90                   	nop
    }
}
  1017f3:	90                   	nop
  1017f4:	c9                   	leave  
  1017f5:	c3                   	ret    

001017f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017f6:	f3 0f 1e fb          	endbr32 
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101800:	8b 45 08             	mov    0x8(%ebp),%eax
  101803:	ba 01 00 00 00       	mov    $0x1,%edx
  101808:	88 c1                	mov    %al,%cl
  10180a:	d3 e2                	shl    %cl,%edx
  10180c:	89 d0                	mov    %edx,%eax
  10180e:	98                   	cwtl   
  10180f:	f7 d0                	not    %eax
  101811:	0f bf d0             	movswl %ax,%edx
  101814:	0f b7 05 50 c5 11 00 	movzwl 0x11c550,%eax
  10181b:	98                   	cwtl   
  10181c:	21 d0                	and    %edx,%eax
  10181e:	98                   	cwtl   
  10181f:	0f b7 c0             	movzwl %ax,%eax
  101822:	89 04 24             	mov    %eax,(%esp)
  101825:	e8 6d ff ff ff       	call   101797 <pic_setmask>
}
  10182a:	90                   	nop
  10182b:	c9                   	leave  
  10182c:	c3                   	ret    

0010182d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10182d:	f3 0f 1e fb          	endbr32 
  101831:	55                   	push   %ebp
  101832:	89 e5                	mov    %esp,%ebp
  101834:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101837:	c7 05 6c f6 11 00 01 	movl   $0x1,0x11f66c
  10183e:	00 00 00 
  101841:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101847:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
}
  101854:	90                   	nop
  101855:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10185b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10185f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101863:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101867:	ee                   	out    %al,(%dx)
}
  101868:	90                   	nop
  101869:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10186f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101873:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101877:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10187b:	ee                   	out    %al,(%dx)
}
  10187c:	90                   	nop
  10187d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101883:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101887:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10188b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10188f:	ee                   	out    %al,(%dx)
}
  101890:	90                   	nop
  101891:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101897:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10189f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1018a3:	ee                   	out    %al,(%dx)
}
  1018a4:	90                   	nop
  1018a5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018ab:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018b3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018b7:	ee                   	out    %al,(%dx)
}
  1018b8:	90                   	nop
  1018b9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018bf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018c7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018cb:	ee                   	out    %al,(%dx)
}
  1018cc:	90                   	nop
  1018cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018df:	ee                   	out    %al,(%dx)
}
  1018e0:	90                   	nop
  1018e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018f3:	ee                   	out    %al,(%dx)
}
  1018f4:	90                   	nop
  1018f5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018fb:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101903:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101907:	ee                   	out    %al,(%dx)
}
  101908:	90                   	nop
  101909:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10190f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101913:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101917:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10191b:	ee                   	out    %al,(%dx)
}
  10191c:	90                   	nop
  10191d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101923:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101927:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10192b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10192f:	ee                   	out    %al,(%dx)
}
  101930:	90                   	nop
  101931:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101937:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10193b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10193f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101943:	ee                   	out    %al,(%dx)
}
  101944:	90                   	nop
  101945:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10194b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10194f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101953:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101957:	ee                   	out    %al,(%dx)
}
  101958:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101959:	0f b7 05 50 c5 11 00 	movzwl 0x11c550,%eax
  101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101965:	74 0f                	je     101976 <pic_init+0x149>
        pic_setmask(irq_mask);
  101967:	0f b7 05 50 c5 11 00 	movzwl 0x11c550,%eax
  10196e:	89 04 24             	mov    %eax,(%esp)
  101971:	e8 21 fe ff ff       	call   101797 <pic_setmask>
    }
}
  101976:	90                   	nop
  101977:	c9                   	leave  
  101978:	c3                   	ret    

00101979 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101979:	f3 0f 1e fb          	endbr32 
  10197d:	55                   	push   %ebp
  10197e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101980:	fb                   	sti    
}
  101981:	90                   	nop
    sti();
}
  101982:	90                   	nop
  101983:	5d                   	pop    %ebp
  101984:	c3                   	ret    

00101985 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101985:	f3 0f 1e fb          	endbr32 
  101989:	55                   	push   %ebp
  10198a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10198c:	fa                   	cli    
}
  10198d:	90                   	nop
    cli();
}
  10198e:	90                   	nop
  10198f:	5d                   	pop    %ebp
  101990:	c3                   	ret    

00101991 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101991:	f3 0f 1e fb          	endbr32 
  101995:	55                   	push   %ebp
  101996:	89 e5                	mov    %esp,%ebp
  101998:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10199b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1019a2:	00 
  1019a3:	c7 04 24 80 77 10 00 	movl   $0x107780,(%esp)
  1019aa:	e8 16 e9 ff ff       	call   1002c5 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1019af:	c7 04 24 8a 77 10 00 	movl   $0x10778a,(%esp)
  1019b6:	e8 0a e9 ff ff       	call   1002c5 <cprintf>
    panic("EOT: kernel seems ok.");
  1019bb:	c7 44 24 08 98 77 10 	movl   $0x107798,0x8(%esp)
  1019c2:	00 
  1019c3:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1019ca:	00 
  1019cb:	c7 04 24 ae 77 10 00 	movl   $0x1077ae,(%esp)
  1019d2:	e8 5a ea ff ff       	call   100431 <__panic>

001019d7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019d7:	f3 0f 1e fb          	endbr32 
  1019db:	55                   	push   %ebp
  1019dc:	89 e5                	mov    %esp,%ebp
  1019de:	83 ec 10             	sub    $0x10,%esp
      */
    extern uintptr_t __vectors[];

    //all gate DPL=0, so use DPL_KERNEL 
    int i;
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  1019e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019e8:	e9 c4 00 00 00       	jmp    101ab1 <idt_init+0xda>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  1019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f0:	8b 04 85 e0 c5 11 00 	mov    0x11c5e0(,%eax,4),%eax
  1019f7:	0f b7 d0             	movzwl %ax,%edx
  1019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fd:	66 89 14 c5 80 f6 11 	mov    %dx,0x11f680(,%eax,8)
  101a04:	00 
  101a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a08:	66 c7 04 c5 82 f6 11 	movw   $0x8,0x11f682(,%eax,8)
  101a0f:	00 08 00 
  101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a15:	0f b6 14 c5 84 f6 11 	movzbl 0x11f684(,%eax,8),%edx
  101a1c:	00 
  101a1d:	80 e2 e0             	and    $0xe0,%dl
  101a20:	88 14 c5 84 f6 11 00 	mov    %dl,0x11f684(,%eax,8)
  101a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2a:	0f b6 14 c5 84 f6 11 	movzbl 0x11f684(,%eax,8),%edx
  101a31:	00 
  101a32:	80 e2 1f             	and    $0x1f,%dl
  101a35:	88 14 c5 84 f6 11 00 	mov    %dl,0x11f684(,%eax,8)
  101a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a3f:	0f b6 14 c5 85 f6 11 	movzbl 0x11f685(,%eax,8),%edx
  101a46:	00 
  101a47:	80 e2 f0             	and    $0xf0,%dl
  101a4a:	80 ca 0e             	or     $0xe,%dl
  101a4d:	88 14 c5 85 f6 11 00 	mov    %dl,0x11f685(,%eax,8)
  101a54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a57:	0f b6 14 c5 85 f6 11 	movzbl 0x11f685(,%eax,8),%edx
  101a5e:	00 
  101a5f:	80 e2 ef             	and    $0xef,%dl
  101a62:	88 14 c5 85 f6 11 00 	mov    %dl,0x11f685(,%eax,8)
  101a69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a6c:	0f b6 14 c5 85 f6 11 	movzbl 0x11f685(,%eax,8),%edx
  101a73:	00 
  101a74:	80 e2 9f             	and    $0x9f,%dl
  101a77:	88 14 c5 85 f6 11 00 	mov    %dl,0x11f685(,%eax,8)
  101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a81:	0f b6 14 c5 85 f6 11 	movzbl 0x11f685(,%eax,8),%edx
  101a88:	00 
  101a89:	80 ca 80             	or     $0x80,%dl
  101a8c:	88 14 c5 85 f6 11 00 	mov    %dl,0x11f685(,%eax,8)
  101a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a96:	8b 04 85 e0 c5 11 00 	mov    0x11c5e0(,%eax,4),%eax
  101a9d:	c1 e8 10             	shr    $0x10,%eax
  101aa0:	0f b7 d0             	movzwl %ax,%edx
  101aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aa6:	66 89 14 c5 86 f6 11 	mov    %dx,0x11f686(,%eax,8)
  101aad:	00 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
  101aae:	ff 45 fc             	incl   -0x4(%ebp)
  101ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ab4:	3d ff 00 00 00       	cmp    $0xff,%eax
  101ab9:	0f 86 2e ff ff ff    	jbe    1019ed <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
  101abf:	a1 e0 c7 11 00       	mov    0x11c7e0,%eax
  101ac4:	0f b7 c0             	movzwl %ax,%eax
  101ac7:	66 a3 80 fa 11 00    	mov    %ax,0x11fa80
  101acd:	66 c7 05 82 fa 11 00 	movw   $0x8,0x11fa82
  101ad4:	08 00 
  101ad6:	0f b6 05 84 fa 11 00 	movzbl 0x11fa84,%eax
  101add:	24 e0                	and    $0xe0,%al
  101adf:	a2 84 fa 11 00       	mov    %al,0x11fa84
  101ae4:	0f b6 05 84 fa 11 00 	movzbl 0x11fa84,%eax
  101aeb:	24 1f                	and    $0x1f,%al
  101aed:	a2 84 fa 11 00       	mov    %al,0x11fa84
  101af2:	0f b6 05 85 fa 11 00 	movzbl 0x11fa85,%eax
  101af9:	0c 0f                	or     $0xf,%al
  101afb:	a2 85 fa 11 00       	mov    %al,0x11fa85
  101b00:	0f b6 05 85 fa 11 00 	movzbl 0x11fa85,%eax
  101b07:	24 ef                	and    $0xef,%al
  101b09:	a2 85 fa 11 00       	mov    %al,0x11fa85
  101b0e:	0f b6 05 85 fa 11 00 	movzbl 0x11fa85,%eax
  101b15:	0c 60                	or     $0x60,%al
  101b17:	a2 85 fa 11 00       	mov    %al,0x11fa85
  101b1c:	0f b6 05 85 fa 11 00 	movzbl 0x11fa85,%eax
  101b23:	0c 80                	or     $0x80,%al
  101b25:	a2 85 fa 11 00       	mov    %al,0x11fa85
  101b2a:	a1 e0 c7 11 00       	mov    0x11c7e0,%eax
  101b2f:	c1 e8 10             	shr    $0x10,%eax
  101b32:	0f b7 c0             	movzwl %ax,%eax
  101b35:	66 a3 86 fa 11 00    	mov    %ax,0x11fa86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
  101b3b:	a1 c4 c7 11 00       	mov    0x11c7c4,%eax
  101b40:	0f b7 c0             	movzwl %ax,%eax
  101b43:	66 a3 48 fa 11 00    	mov    %ax,0x11fa48
  101b49:	66 c7 05 4a fa 11 00 	movw   $0x8,0x11fa4a
  101b50:	08 00 
  101b52:	0f b6 05 4c fa 11 00 	movzbl 0x11fa4c,%eax
  101b59:	24 e0                	and    $0xe0,%al
  101b5b:	a2 4c fa 11 00       	mov    %al,0x11fa4c
  101b60:	0f b6 05 4c fa 11 00 	movzbl 0x11fa4c,%eax
  101b67:	24 1f                	and    $0x1f,%al
  101b69:	a2 4c fa 11 00       	mov    %al,0x11fa4c
  101b6e:	0f b6 05 4d fa 11 00 	movzbl 0x11fa4d,%eax
  101b75:	24 f0                	and    $0xf0,%al
  101b77:	0c 0e                	or     $0xe,%al
  101b79:	a2 4d fa 11 00       	mov    %al,0x11fa4d
  101b7e:	0f b6 05 4d fa 11 00 	movzbl 0x11fa4d,%eax
  101b85:	24 ef                	and    $0xef,%al
  101b87:	a2 4d fa 11 00       	mov    %al,0x11fa4d
  101b8c:	0f b6 05 4d fa 11 00 	movzbl 0x11fa4d,%eax
  101b93:	0c 60                	or     $0x60,%al
  101b95:	a2 4d fa 11 00       	mov    %al,0x11fa4d
  101b9a:	0f b6 05 4d fa 11 00 	movzbl 0x11fa4d,%eax
  101ba1:	0c 80                	or     $0x80,%al
  101ba3:	a2 4d fa 11 00       	mov    %al,0x11fa4d
  101ba8:	a1 c4 c7 11 00       	mov    0x11c7c4,%eax
  101bad:	c1 e8 10             	shr    $0x10,%eax
  101bb0:	0f b7 c0             	movzwl %ax,%eax
  101bb3:	66 a3 4e fa 11 00    	mov    %ax,0x11fa4e
  101bb9:	c7 45 f8 60 c5 11 00 	movl   $0x11c560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101bc3:	0f 01 18             	lidtl  (%eax)
}
  101bc6:	90                   	nop
    
    //建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    lidt(&idt_pd);
}
  101bc7:	90                   	nop
  101bc8:	c9                   	leave  
  101bc9:	c3                   	ret    

00101bca <trapname>:

static const char *
trapname(int trapno) {
  101bca:	f3 0f 1e fb          	endbr32 
  101bce:	55                   	push   %ebp
  101bcf:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	83 f8 13             	cmp    $0x13,%eax
  101bd7:	77 0c                	ja     101be5 <trapname+0x1b>
        return excnames[trapno];
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 04 85 20 7b 10 00 	mov    0x107b20(,%eax,4),%eax
  101be3:	eb 18                	jmp    101bfd <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101be5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101be9:	7e 0d                	jle    101bf8 <trapname+0x2e>
  101beb:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101bef:	7f 07                	jg     101bf8 <trapname+0x2e>
        return "Hardware Interrupt";
  101bf1:	b8 bf 77 10 00       	mov    $0x1077bf,%eax
  101bf6:	eb 05                	jmp    101bfd <trapname+0x33>
    }
    return "(unknown trap)";
  101bf8:	b8 d2 77 10 00       	mov    $0x1077d2,%eax
}
  101bfd:	5d                   	pop    %ebp
  101bfe:	c3                   	ret    

00101bff <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101bff:	f3 0f 1e fb          	endbr32 
  101c03:	55                   	push   %ebp
  101c04:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c0d:	83 f8 08             	cmp    $0x8,%eax
  101c10:	0f 94 c0             	sete   %al
  101c13:	0f b6 c0             	movzbl %al,%eax
}
  101c16:	5d                   	pop    %ebp
  101c17:	c3                   	ret    

00101c18 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101c18:	f3 0f 1e fb          	endbr32 
  101c1c:	55                   	push   %ebp
  101c1d:	89 e5                	mov    %esp,%ebp
  101c1f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 13 78 10 00 	movl   $0x107813,(%esp)
  101c30:	e8 90 e6 ff ff       	call   1002c5 <cprintf>
    print_regs(&tf->tf_regs);
  101c35:	8b 45 08             	mov    0x8(%ebp),%eax
  101c38:	89 04 24             	mov    %eax,(%esp)
  101c3b:	e8 8d 01 00 00       	call   101dcd <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 24 78 10 00 	movl   $0x107824,(%esp)
  101c52:	e8 6e e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c62:	c7 04 24 37 78 10 00 	movl   $0x107837,(%esp)
  101c69:	e8 57 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c71:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c79:	c7 04 24 4a 78 10 00 	movl   $0x10784a,(%esp)
  101c80:	e8 40 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c90:	c7 04 24 5d 78 10 00 	movl   $0x10785d,(%esp)
  101c97:	e8 29 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9f:	8b 40 30             	mov    0x30(%eax),%eax
  101ca2:	89 04 24             	mov    %eax,(%esp)
  101ca5:	e8 20 ff ff ff       	call   101bca <trapname>
  101caa:	8b 55 08             	mov    0x8(%ebp),%edx
  101cad:	8b 52 30             	mov    0x30(%edx),%edx
  101cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  101cb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  101cb8:	c7 04 24 70 78 10 00 	movl   $0x107870,(%esp)
  101cbf:	e8 01 e6 ff ff       	call   1002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc7:	8b 40 34             	mov    0x34(%eax),%eax
  101cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cce:	c7 04 24 82 78 10 00 	movl   $0x107882,(%esp)
  101cd5:	e8 eb e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101cda:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdd:	8b 40 38             	mov    0x38(%eax),%eax
  101ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce4:	c7 04 24 91 78 10 00 	movl   $0x107891,(%esp)
  101ceb:	e8 d5 e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfb:	c7 04 24 a0 78 10 00 	movl   $0x1078a0,(%esp)
  101d02:	e8 be e5 ff ff       	call   1002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101d07:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0a:	8b 40 40             	mov    0x40(%eax),%eax
  101d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d11:	c7 04 24 b3 78 10 00 	movl   $0x1078b3,(%esp)
  101d18:	e8 a8 e5 ff ff       	call   1002c5 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101d24:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101d2b:	eb 3d                	jmp    101d6a <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d30:	8b 50 40             	mov    0x40(%eax),%edx
  101d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d36:	21 d0                	and    %edx,%eax
  101d38:	85 c0                	test   %eax,%eax
  101d3a:	74 28                	je     101d64 <print_trapframe+0x14c>
  101d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d3f:	8b 04 85 80 c5 11 00 	mov    0x11c580(,%eax,4),%eax
  101d46:	85 c0                	test   %eax,%eax
  101d48:	74 1a                	je     101d64 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d4d:	8b 04 85 80 c5 11 00 	mov    0x11c580(,%eax,4),%eax
  101d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d58:	c7 04 24 c2 78 10 00 	movl   $0x1078c2,(%esp)
  101d5f:	e8 61 e5 ff ff       	call   1002c5 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d64:	ff 45 f4             	incl   -0xc(%ebp)
  101d67:	d1 65 f0             	shll   -0x10(%ebp)
  101d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d6d:	83 f8 17             	cmp    $0x17,%eax
  101d70:	76 bb                	jbe    101d2d <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	8b 40 40             	mov    0x40(%eax),%eax
  101d78:	c1 e8 0c             	shr    $0xc,%eax
  101d7b:	83 e0 03             	and    $0x3,%eax
  101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d82:	c7 04 24 c6 78 10 00 	movl   $0x1078c6,(%esp)
  101d89:	e8 37 e5 ff ff       	call   1002c5 <cprintf>

    if (!trap_in_kernel(tf)) {
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	89 04 24             	mov    %eax,(%esp)
  101d94:	e8 66 fe ff ff       	call   101bff <trap_in_kernel>
  101d99:	85 c0                	test   %eax,%eax
  101d9b:	75 2d                	jne    101dca <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101da0:	8b 40 44             	mov    0x44(%eax),%eax
  101da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da7:	c7 04 24 cf 78 10 00 	movl   $0x1078cf,(%esp)
  101dae:	e8 12 e5 ff ff       	call   1002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101db3:	8b 45 08             	mov    0x8(%ebp),%eax
  101db6:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dbe:	c7 04 24 de 78 10 00 	movl   $0x1078de,(%esp)
  101dc5:	e8 fb e4 ff ff       	call   1002c5 <cprintf>
    }
}
  101dca:	90                   	nop
  101dcb:	c9                   	leave  
  101dcc:	c3                   	ret    

00101dcd <print_regs>:

void
print_regs(struct pushregs *regs) {
  101dcd:	f3 0f 1e fb          	endbr32 
  101dd1:	55                   	push   %ebp
  101dd2:	89 e5                	mov    %esp,%ebp
  101dd4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	8b 00                	mov    (%eax),%eax
  101ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de0:	c7 04 24 f1 78 10 00 	movl   $0x1078f1,(%esp)
  101de7:	e8 d9 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101dec:	8b 45 08             	mov    0x8(%ebp),%eax
  101def:	8b 40 04             	mov    0x4(%eax),%eax
  101df2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df6:	c7 04 24 00 79 10 00 	movl   $0x107900,(%esp)
  101dfd:	e8 c3 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101e02:	8b 45 08             	mov    0x8(%ebp),%eax
  101e05:	8b 40 08             	mov    0x8(%eax),%eax
  101e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e0c:	c7 04 24 0f 79 10 00 	movl   $0x10790f,(%esp)
  101e13:	e8 ad e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101e18:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  101e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e22:	c7 04 24 1e 79 10 00 	movl   $0x10791e,(%esp)
  101e29:	e8 97 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e31:	8b 40 10             	mov    0x10(%eax),%eax
  101e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e38:	c7 04 24 2d 79 10 00 	movl   $0x10792d,(%esp)
  101e3f:	e8 81 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e44:	8b 45 08             	mov    0x8(%ebp),%eax
  101e47:	8b 40 14             	mov    0x14(%eax),%eax
  101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e4e:	c7 04 24 3c 79 10 00 	movl   $0x10793c,(%esp)
  101e55:	e8 6b e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5d:	8b 40 18             	mov    0x18(%eax),%eax
  101e60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e64:	c7 04 24 4b 79 10 00 	movl   $0x10794b,(%esp)
  101e6b:	e8 55 e4 ff ff       	call   1002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e70:	8b 45 08             	mov    0x8(%ebp),%eax
  101e73:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e7a:	c7 04 24 5a 79 10 00 	movl   $0x10795a,(%esp)
  101e81:	e8 3f e4 ff ff       	call   1002c5 <cprintf>
}
  101e86:	90                   	nop
  101e87:	c9                   	leave  
  101e88:	c3                   	ret    

00101e89 <trap_dispatch>:
}


/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e89:	f3 0f 1e fb          	endbr32 
  101e8d:	55                   	push   %ebp
  101e8e:	89 e5                	mov    %esp,%ebp
  101e90:	57                   	push   %edi
  101e91:	56                   	push   %esi
  101e92:	53                   	push   %ebx
  101e93:	83 ec 3c             	sub    $0x3c,%esp
    char c;

    switch (tf->tf_trapno) {
  101e96:	8b 45 08             	mov    0x8(%ebp),%eax
  101e99:	8b 40 30             	mov    0x30(%eax),%eax
  101e9c:	83 f8 79             	cmp    $0x79,%eax
  101e9f:	0f 84 ac 03 00 00    	je     102251 <trap_dispatch+0x3c8>
  101ea5:	83 f8 79             	cmp    $0x79,%eax
  101ea8:	0f 87 31 04 00 00    	ja     1022df <trap_dispatch+0x456>
  101eae:	83 f8 78             	cmp    $0x78,%eax
  101eb1:	0f 84 af 02 00 00    	je     102166 <trap_dispatch+0x2dd>
  101eb7:	83 f8 78             	cmp    $0x78,%eax
  101eba:	0f 87 1f 04 00 00    	ja     1022df <trap_dispatch+0x456>
  101ec0:	83 f8 2f             	cmp    $0x2f,%eax
  101ec3:	0f 87 16 04 00 00    	ja     1022df <trap_dispatch+0x456>
  101ec9:	83 f8 2e             	cmp    $0x2e,%eax
  101ecc:	0f 83 42 04 00 00    	jae    102314 <trap_dispatch+0x48b>
  101ed2:	83 f8 24             	cmp    $0x24,%eax
  101ed5:	74 5e                	je     101f35 <trap_dispatch+0xac>
  101ed7:	83 f8 24             	cmp    $0x24,%eax
  101eda:	0f 87 ff 03 00 00    	ja     1022df <trap_dispatch+0x456>
  101ee0:	83 f8 20             	cmp    $0x20,%eax
  101ee3:	74 0a                	je     101eef <trap_dispatch+0x66>
  101ee5:	83 f8 21             	cmp    $0x21,%eax
  101ee8:	74 74                	je     101f5e <trap_dispatch+0xd5>
  101eea:	e9 f0 03 00 00       	jmp    1022df <trap_dispatch+0x456>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101eef:	a1 10 ff 11 00       	mov    0x11ff10,%eax
  101ef4:	40                   	inc    %eax
  101ef5:	a3 10 ff 11 00       	mov    %eax,0x11ff10
        if(ticks%100==0){
  101efa:	8b 0d 10 ff 11 00    	mov    0x11ff10,%ecx
  101f00:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101f05:	89 c8                	mov    %ecx,%eax
  101f07:	f7 e2                	mul    %edx
  101f09:	c1 ea 05             	shr    $0x5,%edx
  101f0c:	89 d0                	mov    %edx,%eax
  101f0e:	c1 e0 02             	shl    $0x2,%eax
  101f11:	01 d0                	add    %edx,%eax
  101f13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101f1a:	01 d0                	add    %edx,%eax
  101f1c:	c1 e0 02             	shl    $0x2,%eax
  101f1f:	29 c1                	sub    %eax,%ecx
  101f21:	89 ca                	mov    %ecx,%edx
  101f23:	85 d2                	test   %edx,%edx
  101f25:	0f 85 ec 03 00 00    	jne    102317 <trap_dispatch+0x48e>
            print_ticks();
  101f2b:	e8 61 fa ff ff       	call   101991 <print_ticks>
        }
        break;
  101f30:	e9 e2 03 00 00       	jmp    102317 <trap_dispatch+0x48e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101f35:	e8 ea f7 ff ff       	call   101724 <cons_getc>
  101f3a:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101f3d:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101f41:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101f45:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f4d:	c7 04 24 69 79 10 00 	movl   $0x107969,(%esp)
  101f54:	e8 6c e3 ff ff       	call   1002c5 <cprintf>
        break;
  101f59:	e9 bd 03 00 00       	jmp    10231b <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101f5e:	e8 c1 f7 ff ff       	call   101724 <cons_getc>
  101f63:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101f66:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101f6a:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101f6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f76:	c7 04 24 7b 79 10 00 	movl   $0x10797b,(%esp)
  101f7d:	e8 43 e3 ff ff       	call   1002c5 <cprintf>
        if (c == '0'&&!trap_in_kernel(tf)) {
  101f82:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101f86:	0f 85 bb 00 00 00    	jne    102047 <trap_dispatch+0x1be>
  101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8f:	89 04 24             	mov    %eax,(%esp)
  101f92:	e8 68 fc ff ff       	call   101bff <trap_in_kernel>
  101f97:	85 c0                	test   %eax,%eax
  101f99:	0f 85 a8 00 00 00    	jne    102047 <trap_dispatch+0x1be>
  101f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  101fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fa8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fac:	83 f8 08             	cmp    $0x8,%eax
  101faf:	74 79                	je     10202a <trap_dispatch+0x1a1>
        tf->tf_cs = KERNEL_CS;
  101fb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fb4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
  101fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fbd:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  101fc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fc6:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fd4:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fdb:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  101fdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fe2:	8b 40 40             	mov    0x40(%eax),%eax
  101fe5:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101fea:	89 c2                	mov    %eax,%edx
  101fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101fef:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ff2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101ff5:	8b 40 44             	mov    0x44(%eax),%eax
  101ff8:	83 e8 44             	sub    $0x44,%eax
  101ffb:	a3 6c ff 11 00       	mov    %eax,0x11ff6c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  102000:	a1 6c ff 11 00       	mov    0x11ff6c,%eax
  102005:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  10200c:	00 
  10200d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102010:	89 54 24 04          	mov    %edx,0x4(%esp)
  102014:	89 04 24             	mov    %eax,(%esp)
  102017:	e8 ec 4b 00 00       	call   106c08 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  10201c:	8b 15 6c ff 11 00    	mov    0x11ff6c,%edx
  102022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102025:	83 e8 04             	sub    $0x4,%eax
  102028:	89 10                	mov    %edx,(%eax)
}
  10202a:	90                   	nop
        //切换为内核态
        switch_to_kernel(tf);
        cprintf("user to kernel\n");
  10202b:	c7 04 24 8a 79 10 00 	movl   $0x10798a,(%esp)
  102032:	e8 8e e2 ff ff       	call   1002c5 <cprintf>
        print_trapframe(tf);
  102037:	8b 45 08             	mov    0x8(%ebp),%eax
  10203a:	89 04 24             	mov    %eax,(%esp)
  10203d:	e8 d6 fb ff ff       	call   101c18 <print_trapframe>
        //切换为用户态
        switch_to_user(tf);
        cprintf("kernel to user\n");
        print_trapframe(tf);
        }
        break;
  102042:	e9 d3 02 00 00       	jmp    10231a <trap_dispatch+0x491>
        } else if (c == '3'&&(trap_in_kernel(tf))) {
  102047:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  10204b:	0f 85 c9 02 00 00    	jne    10231a <trap_dispatch+0x491>
  102051:	8b 45 08             	mov    0x8(%ebp),%eax
  102054:	89 04 24             	mov    %eax,(%esp)
  102057:	e8 a3 fb ff ff       	call   101bff <trap_in_kernel>
  10205c:	85 c0                	test   %eax,%eax
  10205e:	0f 84 b6 02 00 00    	je     10231a <trap_dispatch+0x491>
  102064:	8b 45 08             	mov    0x8(%ebp),%eax
  102067:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (tf->tf_cs != USER_CS) {
  10206a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10206d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102071:	83 f8 1b             	cmp    $0x1b,%eax
  102074:	0f 84 cf 00 00 00    	je     102149 <trap_dispatch+0x2c0>
        switchk2u = *tf;
  10207a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10207d:	b8 20 ff 11 00       	mov    $0x11ff20,%eax
  102082:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  102087:	89 c1                	mov    %eax,%ecx
  102089:	83 e1 01             	and    $0x1,%ecx
  10208c:	85 c9                	test   %ecx,%ecx
  10208e:	74 0c                	je     10209c <trap_dispatch+0x213>
  102090:	0f b6 0a             	movzbl (%edx),%ecx
  102093:	88 08                	mov    %cl,(%eax)
  102095:	8d 40 01             	lea    0x1(%eax),%eax
  102098:	8d 52 01             	lea    0x1(%edx),%edx
  10209b:	4b                   	dec    %ebx
  10209c:	89 c1                	mov    %eax,%ecx
  10209e:	83 e1 02             	and    $0x2,%ecx
  1020a1:	85 c9                	test   %ecx,%ecx
  1020a3:	74 0f                	je     1020b4 <trap_dispatch+0x22b>
  1020a5:	0f b7 0a             	movzwl (%edx),%ecx
  1020a8:	66 89 08             	mov    %cx,(%eax)
  1020ab:	8d 40 02             	lea    0x2(%eax),%eax
  1020ae:	8d 52 02             	lea    0x2(%edx),%edx
  1020b1:	83 eb 02             	sub    $0x2,%ebx
  1020b4:	89 df                	mov    %ebx,%edi
  1020b6:	83 e7 fc             	and    $0xfffffffc,%edi
  1020b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  1020be:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  1020c1:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  1020c4:	83 c1 04             	add    $0x4,%ecx
  1020c7:	39 f9                	cmp    %edi,%ecx
  1020c9:	72 f3                	jb     1020be <trap_dispatch+0x235>
  1020cb:	01 c8                	add    %ecx,%eax
  1020cd:	01 ca                	add    %ecx,%edx
  1020cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  1020d4:	89 de                	mov    %ebx,%esi
  1020d6:	83 e6 02             	and    $0x2,%esi
  1020d9:	85 f6                	test   %esi,%esi
  1020db:	74 0b                	je     1020e8 <trap_dispatch+0x25f>
  1020dd:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  1020e1:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  1020e5:	83 c1 02             	add    $0x2,%ecx
  1020e8:	83 e3 01             	and    $0x1,%ebx
  1020eb:	85 db                	test   %ebx,%ebx
  1020ed:	74 07                	je     1020f6 <trap_dispatch+0x26d>
  1020ef:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  1020f3:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  1020f6:	66 c7 05 5c ff 11 00 	movw   $0x1b,0x11ff5c
  1020fd:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  1020ff:	66 c7 05 68 ff 11 00 	movw   $0x23,0x11ff68
  102106:	23 00 
  102108:	0f b7 05 68 ff 11 00 	movzwl 0x11ff68,%eax
  10210f:	66 a3 48 ff 11 00    	mov    %ax,0x11ff48
  102115:	0f b7 05 48 ff 11 00 	movzwl 0x11ff48,%eax
  10211c:	66 a3 4c ff 11 00    	mov    %ax,0x11ff4c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  102122:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102125:	83 c0 4c             	add    $0x4c,%eax
  102128:	a3 64 ff 11 00       	mov    %eax,0x11ff64
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  10212d:	a1 60 ff 11 00       	mov    0x11ff60,%eax
  102132:	0d 00 30 00 00       	or     $0x3000,%eax
  102137:	a3 60 ff 11 00       	mov    %eax,0x11ff60
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  10213c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10213f:	83 e8 04             	sub    $0x4,%eax
  102142:	ba 20 ff 11 00       	mov    $0x11ff20,%edx
  102147:	89 10                	mov    %edx,(%eax)
}
  102149:	90                   	nop
        cprintf("kernel to user\n");
  10214a:	c7 04 24 9a 79 10 00 	movl   $0x10799a,(%esp)
  102151:	e8 6f e1 ff ff       	call   1002c5 <cprintf>
        print_trapframe(tf);
  102156:	8b 45 08             	mov    0x8(%ebp),%eax
  102159:	89 04 24             	mov    %eax,(%esp)
  10215c:	e8 b7 fa ff ff       	call   101c18 <print_trapframe>
        break;
  102161:	e9 b4 01 00 00       	jmp    10231a <trap_dispatch+0x491>
  102166:	8b 45 08             	mov    0x8(%ebp),%eax
  102169:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (tf->tf_cs != USER_CS) {
  10216c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10216f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102173:	83 f8 1b             	cmp    $0x1b,%eax
  102176:	0f 84 cf 00 00 00    	je     10224b <trap_dispatch+0x3c2>
        switchk2u = *tf;
  10217c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10217f:	b8 20 ff 11 00       	mov    $0x11ff20,%eax
  102184:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  102189:	89 c1                	mov    %eax,%ecx
  10218b:	83 e1 01             	and    $0x1,%ecx
  10218e:	85 c9                	test   %ecx,%ecx
  102190:	74 0c                	je     10219e <trap_dispatch+0x315>
  102192:	0f b6 0a             	movzbl (%edx),%ecx
  102195:	88 08                	mov    %cl,(%eax)
  102197:	8d 40 01             	lea    0x1(%eax),%eax
  10219a:	8d 52 01             	lea    0x1(%edx),%edx
  10219d:	4b                   	dec    %ebx
  10219e:	89 c1                	mov    %eax,%ecx
  1021a0:	83 e1 02             	and    $0x2,%ecx
  1021a3:	85 c9                	test   %ecx,%ecx
  1021a5:	74 0f                	je     1021b6 <trap_dispatch+0x32d>
  1021a7:	0f b7 0a             	movzwl (%edx),%ecx
  1021aa:	66 89 08             	mov    %cx,(%eax)
  1021ad:	8d 40 02             	lea    0x2(%eax),%eax
  1021b0:	8d 52 02             	lea    0x2(%edx),%edx
  1021b3:	83 eb 02             	sub    $0x2,%ebx
  1021b6:	89 df                	mov    %ebx,%edi
  1021b8:	83 e7 fc             	and    $0xfffffffc,%edi
  1021bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  1021c0:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  1021c3:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  1021c6:	83 c1 04             	add    $0x4,%ecx
  1021c9:	39 f9                	cmp    %edi,%ecx
  1021cb:	72 f3                	jb     1021c0 <trap_dispatch+0x337>
  1021cd:	01 c8                	add    %ecx,%eax
  1021cf:	01 ca                	add    %ecx,%edx
  1021d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  1021d6:	89 de                	mov    %ebx,%esi
  1021d8:	83 e6 02             	and    $0x2,%esi
  1021db:	85 f6                	test   %esi,%esi
  1021dd:	74 0b                	je     1021ea <trap_dispatch+0x361>
  1021df:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  1021e3:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  1021e7:	83 c1 02             	add    $0x2,%ecx
  1021ea:	83 e3 01             	and    $0x1,%ebx
  1021ed:	85 db                	test   %ebx,%ebx
  1021ef:	74 07                	je     1021f8 <trap_dispatch+0x36f>
  1021f1:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  1021f5:	88 14 08             	mov    %dl,(%eax,%ecx,1)
        switchk2u.tf_cs = USER_CS;
  1021f8:	66 c7 05 5c ff 11 00 	movw   $0x1b,0x11ff5c
  1021ff:	1b 00 
        switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  102201:	66 c7 05 68 ff 11 00 	movw   $0x23,0x11ff68
  102208:	23 00 
  10220a:	0f b7 05 68 ff 11 00 	movzwl 0x11ff68,%eax
  102211:	66 a3 48 ff 11 00    	mov    %ax,0x11ff48
  102217:	0f b7 05 48 ff 11 00 	movzwl 0x11ff48,%eax
  10221e:	66 a3 4c ff 11 00    	mov    %ax,0x11ff4c
        switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe);
  102224:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102227:	83 c0 4c             	add    $0x4c,%eax
  10222a:	a3 64 ff 11 00       	mov    %eax,0x11ff64
        switchk2u.tf_eflags |= FL_IOPL_MASK;
  10222f:	a1 60 ff 11 00       	mov    0x11ff60,%eax
  102234:	0d 00 30 00 00       	or     $0x3000,%eax
  102239:	a3 60 ff 11 00       	mov    %eax,0x11ff60
        *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  10223e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102241:	83 e8 04             	sub    $0x4,%eax
  102244:	ba 20 ff 11 00       	mov    $0x11ff20,%edx
  102249:	89 10                	mov    %edx,(%eax)
}
  10224b:	90                   	nop
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        switch_to_user(tf);
        break;
  10224c:	e9 ca 00 00 00       	jmp    10231b <trap_dispatch+0x492>
  102251:	8b 45 08             	mov    0x8(%ebp),%eax
  102254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (tf->tf_cs != KERNEL_CS) {
  102257:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10225a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10225e:	83 f8 08             	cmp    $0x8,%eax
  102261:	74 79                	je     1022dc <trap_dispatch+0x453>
        tf->tf_cs = KERNEL_CS;
  102263:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102266:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = tf->tf_es =tf->tf_ss = KERNEL_DS;
  10226c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10226f:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
  102275:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102278:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  10227c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10227f:	66 89 50 28          	mov    %dx,0x28(%eax)
  102283:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102286:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10228a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10228d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
  102291:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102294:	8b 40 40             	mov    0x40(%eax),%eax
  102297:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  10229c:	89 c2                	mov    %eax,%edx
  10229e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1022a1:	89 50 40             	mov    %edx,0x40(%eax)
        switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  1022a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1022a7:	8b 40 44             	mov    0x44(%eax),%eax
  1022aa:	83 e8 44             	sub    $0x44,%eax
  1022ad:	a3 6c ff 11 00       	mov    %eax,0x11ff6c
        memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  1022b2:	a1 6c ff 11 00       	mov    0x11ff6c,%eax
  1022b7:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1022be:	00 
  1022bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1022c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1022c6:	89 04 24             	mov    %eax,(%esp)
  1022c9:	e8 3a 49 00 00       	call   106c08 <memmove>
        *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  1022ce:	8b 15 6c ff 11 00    	mov    0x11ff6c,%edx
  1022d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1022d7:	83 e8 04             	sub    $0x4,%eax
  1022da:	89 10                	mov    %edx,(%eax)
}
  1022dc:	90                   	nop
    case T_SWITCH_TOK:
        switch_to_kernel(tf);
        break;
  1022dd:	eb 3c                	jmp    10231b <trap_dispatch+0x492>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1022df:	8b 45 08             	mov    0x8(%ebp),%eax
  1022e2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1022e6:	83 e0 03             	and    $0x3,%eax
  1022e9:	85 c0                	test   %eax,%eax
  1022eb:	75 2e                	jne    10231b <trap_dispatch+0x492>
            print_trapframe(tf);
  1022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1022f0:	89 04 24             	mov    %eax,(%esp)
  1022f3:	e8 20 f9 ff ff       	call   101c18 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1022f8:	c7 44 24 08 aa 79 10 	movl   $0x1079aa,0x8(%esp)
  1022ff:	00 
  102300:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  102307:	00 
  102308:	c7 04 24 ae 77 10 00 	movl   $0x1077ae,(%esp)
  10230f:	e8 1d e1 ff ff       	call   100431 <__panic>
        break;
  102314:	90                   	nop
  102315:	eb 04                	jmp    10231b <trap_dispatch+0x492>
        break;
  102317:	90                   	nop
  102318:	eb 01                	jmp    10231b <trap_dispatch+0x492>
        break;
  10231a:	90                   	nop
        }
    }
}
  10231b:	90                   	nop
  10231c:	83 c4 3c             	add    $0x3c,%esp
  10231f:	5b                   	pop    %ebx
  102320:	5e                   	pop    %esi
  102321:	5f                   	pop    %edi
  102322:	5d                   	pop    %ebp
  102323:	c3                   	ret    

00102324 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  102324:	f3 0f 1e fb          	endbr32 
  102328:	55                   	push   %ebp
  102329:	89 e5                	mov    %esp,%ebp
  10232b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  10232e:	8b 45 08             	mov    0x8(%ebp),%eax
  102331:	89 04 24             	mov    %eax,(%esp)
  102334:	e8 50 fb ff ff       	call   101e89 <trap_dispatch>
}
  102339:	90                   	nop
  10233a:	c9                   	leave  
  10233b:	c3                   	ret    

0010233c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $0
  10233e:	6a 00                	push   $0x0
  jmp __alltraps
  102340:	e9 69 0a 00 00       	jmp    102dae <__alltraps>

00102345 <vector1>:
.globl vector1
vector1:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $1
  102347:	6a 01                	push   $0x1
  jmp __alltraps
  102349:	e9 60 0a 00 00       	jmp    102dae <__alltraps>

0010234e <vector2>:
.globl vector2
vector2:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $2
  102350:	6a 02                	push   $0x2
  jmp __alltraps
  102352:	e9 57 0a 00 00       	jmp    102dae <__alltraps>

00102357 <vector3>:
.globl vector3
vector3:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $3
  102359:	6a 03                	push   $0x3
  jmp __alltraps
  10235b:	e9 4e 0a 00 00       	jmp    102dae <__alltraps>

00102360 <vector4>:
.globl vector4
vector4:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $4
  102362:	6a 04                	push   $0x4
  jmp __alltraps
  102364:	e9 45 0a 00 00       	jmp    102dae <__alltraps>

00102369 <vector5>:
.globl vector5
vector5:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $5
  10236b:	6a 05                	push   $0x5
  jmp __alltraps
  10236d:	e9 3c 0a 00 00       	jmp    102dae <__alltraps>

00102372 <vector6>:
.globl vector6
vector6:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $6
  102374:	6a 06                	push   $0x6
  jmp __alltraps
  102376:	e9 33 0a 00 00       	jmp    102dae <__alltraps>

0010237b <vector7>:
.globl vector7
vector7:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $7
  10237d:	6a 07                	push   $0x7
  jmp __alltraps
  10237f:	e9 2a 0a 00 00       	jmp    102dae <__alltraps>

00102384 <vector8>:
.globl vector8
vector8:
  pushl $8
  102384:	6a 08                	push   $0x8
  jmp __alltraps
  102386:	e9 23 0a 00 00       	jmp    102dae <__alltraps>

0010238b <vector9>:
.globl vector9
vector9:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $9
  10238d:	6a 09                	push   $0x9
  jmp __alltraps
  10238f:	e9 1a 0a 00 00       	jmp    102dae <__alltraps>

00102394 <vector10>:
.globl vector10
vector10:
  pushl $10
  102394:	6a 0a                	push   $0xa
  jmp __alltraps
  102396:	e9 13 0a 00 00       	jmp    102dae <__alltraps>

0010239b <vector11>:
.globl vector11
vector11:
  pushl $11
  10239b:	6a 0b                	push   $0xb
  jmp __alltraps
  10239d:	e9 0c 0a 00 00       	jmp    102dae <__alltraps>

001023a2 <vector12>:
.globl vector12
vector12:
  pushl $12
  1023a2:	6a 0c                	push   $0xc
  jmp __alltraps
  1023a4:	e9 05 0a 00 00       	jmp    102dae <__alltraps>

001023a9 <vector13>:
.globl vector13
vector13:
  pushl $13
  1023a9:	6a 0d                	push   $0xd
  jmp __alltraps
  1023ab:	e9 fe 09 00 00       	jmp    102dae <__alltraps>

001023b0 <vector14>:
.globl vector14
vector14:
  pushl $14
  1023b0:	6a 0e                	push   $0xe
  jmp __alltraps
  1023b2:	e9 f7 09 00 00       	jmp    102dae <__alltraps>

001023b7 <vector15>:
.globl vector15
vector15:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $15
  1023b9:	6a 0f                	push   $0xf
  jmp __alltraps
  1023bb:	e9 ee 09 00 00       	jmp    102dae <__alltraps>

001023c0 <vector16>:
.globl vector16
vector16:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $16
  1023c2:	6a 10                	push   $0x10
  jmp __alltraps
  1023c4:	e9 e5 09 00 00       	jmp    102dae <__alltraps>

001023c9 <vector17>:
.globl vector17
vector17:
  pushl $17
  1023c9:	6a 11                	push   $0x11
  jmp __alltraps
  1023cb:	e9 de 09 00 00       	jmp    102dae <__alltraps>

001023d0 <vector18>:
.globl vector18
vector18:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $18
  1023d2:	6a 12                	push   $0x12
  jmp __alltraps
  1023d4:	e9 d5 09 00 00       	jmp    102dae <__alltraps>

001023d9 <vector19>:
.globl vector19
vector19:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $19
  1023db:	6a 13                	push   $0x13
  jmp __alltraps
  1023dd:	e9 cc 09 00 00       	jmp    102dae <__alltraps>

001023e2 <vector20>:
.globl vector20
vector20:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $20
  1023e4:	6a 14                	push   $0x14
  jmp __alltraps
  1023e6:	e9 c3 09 00 00       	jmp    102dae <__alltraps>

001023eb <vector21>:
.globl vector21
vector21:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $21
  1023ed:	6a 15                	push   $0x15
  jmp __alltraps
  1023ef:	e9 ba 09 00 00       	jmp    102dae <__alltraps>

001023f4 <vector22>:
.globl vector22
vector22:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $22
  1023f6:	6a 16                	push   $0x16
  jmp __alltraps
  1023f8:	e9 b1 09 00 00       	jmp    102dae <__alltraps>

001023fd <vector23>:
.globl vector23
vector23:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $23
  1023ff:	6a 17                	push   $0x17
  jmp __alltraps
  102401:	e9 a8 09 00 00       	jmp    102dae <__alltraps>

00102406 <vector24>:
.globl vector24
vector24:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $24
  102408:	6a 18                	push   $0x18
  jmp __alltraps
  10240a:	e9 9f 09 00 00       	jmp    102dae <__alltraps>

0010240f <vector25>:
.globl vector25
vector25:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $25
  102411:	6a 19                	push   $0x19
  jmp __alltraps
  102413:	e9 96 09 00 00       	jmp    102dae <__alltraps>

00102418 <vector26>:
.globl vector26
vector26:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $26
  10241a:	6a 1a                	push   $0x1a
  jmp __alltraps
  10241c:	e9 8d 09 00 00       	jmp    102dae <__alltraps>

00102421 <vector27>:
.globl vector27
vector27:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $27
  102423:	6a 1b                	push   $0x1b
  jmp __alltraps
  102425:	e9 84 09 00 00       	jmp    102dae <__alltraps>

0010242a <vector28>:
.globl vector28
vector28:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $28
  10242c:	6a 1c                	push   $0x1c
  jmp __alltraps
  10242e:	e9 7b 09 00 00       	jmp    102dae <__alltraps>

00102433 <vector29>:
.globl vector29
vector29:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $29
  102435:	6a 1d                	push   $0x1d
  jmp __alltraps
  102437:	e9 72 09 00 00       	jmp    102dae <__alltraps>

0010243c <vector30>:
.globl vector30
vector30:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $30
  10243e:	6a 1e                	push   $0x1e
  jmp __alltraps
  102440:	e9 69 09 00 00       	jmp    102dae <__alltraps>

00102445 <vector31>:
.globl vector31
vector31:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $31
  102447:	6a 1f                	push   $0x1f
  jmp __alltraps
  102449:	e9 60 09 00 00       	jmp    102dae <__alltraps>

0010244e <vector32>:
.globl vector32
vector32:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $32
  102450:	6a 20                	push   $0x20
  jmp __alltraps
  102452:	e9 57 09 00 00       	jmp    102dae <__alltraps>

00102457 <vector33>:
.globl vector33
vector33:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $33
  102459:	6a 21                	push   $0x21
  jmp __alltraps
  10245b:	e9 4e 09 00 00       	jmp    102dae <__alltraps>

00102460 <vector34>:
.globl vector34
vector34:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $34
  102462:	6a 22                	push   $0x22
  jmp __alltraps
  102464:	e9 45 09 00 00       	jmp    102dae <__alltraps>

00102469 <vector35>:
.globl vector35
vector35:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $35
  10246b:	6a 23                	push   $0x23
  jmp __alltraps
  10246d:	e9 3c 09 00 00       	jmp    102dae <__alltraps>

00102472 <vector36>:
.globl vector36
vector36:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $36
  102474:	6a 24                	push   $0x24
  jmp __alltraps
  102476:	e9 33 09 00 00       	jmp    102dae <__alltraps>

0010247b <vector37>:
.globl vector37
vector37:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $37
  10247d:	6a 25                	push   $0x25
  jmp __alltraps
  10247f:	e9 2a 09 00 00       	jmp    102dae <__alltraps>

00102484 <vector38>:
.globl vector38
vector38:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $38
  102486:	6a 26                	push   $0x26
  jmp __alltraps
  102488:	e9 21 09 00 00       	jmp    102dae <__alltraps>

0010248d <vector39>:
.globl vector39
vector39:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $39
  10248f:	6a 27                	push   $0x27
  jmp __alltraps
  102491:	e9 18 09 00 00       	jmp    102dae <__alltraps>

00102496 <vector40>:
.globl vector40
vector40:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $40
  102498:	6a 28                	push   $0x28
  jmp __alltraps
  10249a:	e9 0f 09 00 00       	jmp    102dae <__alltraps>

0010249f <vector41>:
.globl vector41
vector41:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $41
  1024a1:	6a 29                	push   $0x29
  jmp __alltraps
  1024a3:	e9 06 09 00 00       	jmp    102dae <__alltraps>

001024a8 <vector42>:
.globl vector42
vector42:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $42
  1024aa:	6a 2a                	push   $0x2a
  jmp __alltraps
  1024ac:	e9 fd 08 00 00       	jmp    102dae <__alltraps>

001024b1 <vector43>:
.globl vector43
vector43:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $43
  1024b3:	6a 2b                	push   $0x2b
  jmp __alltraps
  1024b5:	e9 f4 08 00 00       	jmp    102dae <__alltraps>

001024ba <vector44>:
.globl vector44
vector44:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $44
  1024bc:	6a 2c                	push   $0x2c
  jmp __alltraps
  1024be:	e9 eb 08 00 00       	jmp    102dae <__alltraps>

001024c3 <vector45>:
.globl vector45
vector45:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $45
  1024c5:	6a 2d                	push   $0x2d
  jmp __alltraps
  1024c7:	e9 e2 08 00 00       	jmp    102dae <__alltraps>

001024cc <vector46>:
.globl vector46
vector46:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $46
  1024ce:	6a 2e                	push   $0x2e
  jmp __alltraps
  1024d0:	e9 d9 08 00 00       	jmp    102dae <__alltraps>

001024d5 <vector47>:
.globl vector47
vector47:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $47
  1024d7:	6a 2f                	push   $0x2f
  jmp __alltraps
  1024d9:	e9 d0 08 00 00       	jmp    102dae <__alltraps>

001024de <vector48>:
.globl vector48
vector48:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $48
  1024e0:	6a 30                	push   $0x30
  jmp __alltraps
  1024e2:	e9 c7 08 00 00       	jmp    102dae <__alltraps>

001024e7 <vector49>:
.globl vector49
vector49:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $49
  1024e9:	6a 31                	push   $0x31
  jmp __alltraps
  1024eb:	e9 be 08 00 00       	jmp    102dae <__alltraps>

001024f0 <vector50>:
.globl vector50
vector50:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $50
  1024f2:	6a 32                	push   $0x32
  jmp __alltraps
  1024f4:	e9 b5 08 00 00       	jmp    102dae <__alltraps>

001024f9 <vector51>:
.globl vector51
vector51:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $51
  1024fb:	6a 33                	push   $0x33
  jmp __alltraps
  1024fd:	e9 ac 08 00 00       	jmp    102dae <__alltraps>

00102502 <vector52>:
.globl vector52
vector52:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $52
  102504:	6a 34                	push   $0x34
  jmp __alltraps
  102506:	e9 a3 08 00 00       	jmp    102dae <__alltraps>

0010250b <vector53>:
.globl vector53
vector53:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $53
  10250d:	6a 35                	push   $0x35
  jmp __alltraps
  10250f:	e9 9a 08 00 00       	jmp    102dae <__alltraps>

00102514 <vector54>:
.globl vector54
vector54:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $54
  102516:	6a 36                	push   $0x36
  jmp __alltraps
  102518:	e9 91 08 00 00       	jmp    102dae <__alltraps>

0010251d <vector55>:
.globl vector55
vector55:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $55
  10251f:	6a 37                	push   $0x37
  jmp __alltraps
  102521:	e9 88 08 00 00       	jmp    102dae <__alltraps>

00102526 <vector56>:
.globl vector56
vector56:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $56
  102528:	6a 38                	push   $0x38
  jmp __alltraps
  10252a:	e9 7f 08 00 00       	jmp    102dae <__alltraps>

0010252f <vector57>:
.globl vector57
vector57:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $57
  102531:	6a 39                	push   $0x39
  jmp __alltraps
  102533:	e9 76 08 00 00       	jmp    102dae <__alltraps>

00102538 <vector58>:
.globl vector58
vector58:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $58
  10253a:	6a 3a                	push   $0x3a
  jmp __alltraps
  10253c:	e9 6d 08 00 00       	jmp    102dae <__alltraps>

00102541 <vector59>:
.globl vector59
vector59:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $59
  102543:	6a 3b                	push   $0x3b
  jmp __alltraps
  102545:	e9 64 08 00 00       	jmp    102dae <__alltraps>

0010254a <vector60>:
.globl vector60
vector60:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $60
  10254c:	6a 3c                	push   $0x3c
  jmp __alltraps
  10254e:	e9 5b 08 00 00       	jmp    102dae <__alltraps>

00102553 <vector61>:
.globl vector61
vector61:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $61
  102555:	6a 3d                	push   $0x3d
  jmp __alltraps
  102557:	e9 52 08 00 00       	jmp    102dae <__alltraps>

0010255c <vector62>:
.globl vector62
vector62:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $62
  10255e:	6a 3e                	push   $0x3e
  jmp __alltraps
  102560:	e9 49 08 00 00       	jmp    102dae <__alltraps>

00102565 <vector63>:
.globl vector63
vector63:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $63
  102567:	6a 3f                	push   $0x3f
  jmp __alltraps
  102569:	e9 40 08 00 00       	jmp    102dae <__alltraps>

0010256e <vector64>:
.globl vector64
vector64:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $64
  102570:	6a 40                	push   $0x40
  jmp __alltraps
  102572:	e9 37 08 00 00       	jmp    102dae <__alltraps>

00102577 <vector65>:
.globl vector65
vector65:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $65
  102579:	6a 41                	push   $0x41
  jmp __alltraps
  10257b:	e9 2e 08 00 00       	jmp    102dae <__alltraps>

00102580 <vector66>:
.globl vector66
vector66:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $66
  102582:	6a 42                	push   $0x42
  jmp __alltraps
  102584:	e9 25 08 00 00       	jmp    102dae <__alltraps>

00102589 <vector67>:
.globl vector67
vector67:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $67
  10258b:	6a 43                	push   $0x43
  jmp __alltraps
  10258d:	e9 1c 08 00 00       	jmp    102dae <__alltraps>

00102592 <vector68>:
.globl vector68
vector68:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $68
  102594:	6a 44                	push   $0x44
  jmp __alltraps
  102596:	e9 13 08 00 00       	jmp    102dae <__alltraps>

0010259b <vector69>:
.globl vector69
vector69:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $69
  10259d:	6a 45                	push   $0x45
  jmp __alltraps
  10259f:	e9 0a 08 00 00       	jmp    102dae <__alltraps>

001025a4 <vector70>:
.globl vector70
vector70:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $70
  1025a6:	6a 46                	push   $0x46
  jmp __alltraps
  1025a8:	e9 01 08 00 00       	jmp    102dae <__alltraps>

001025ad <vector71>:
.globl vector71
vector71:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $71
  1025af:	6a 47                	push   $0x47
  jmp __alltraps
  1025b1:	e9 f8 07 00 00       	jmp    102dae <__alltraps>

001025b6 <vector72>:
.globl vector72
vector72:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $72
  1025b8:	6a 48                	push   $0x48
  jmp __alltraps
  1025ba:	e9 ef 07 00 00       	jmp    102dae <__alltraps>

001025bf <vector73>:
.globl vector73
vector73:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $73
  1025c1:	6a 49                	push   $0x49
  jmp __alltraps
  1025c3:	e9 e6 07 00 00       	jmp    102dae <__alltraps>

001025c8 <vector74>:
.globl vector74
vector74:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $74
  1025ca:	6a 4a                	push   $0x4a
  jmp __alltraps
  1025cc:	e9 dd 07 00 00       	jmp    102dae <__alltraps>

001025d1 <vector75>:
.globl vector75
vector75:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $75
  1025d3:	6a 4b                	push   $0x4b
  jmp __alltraps
  1025d5:	e9 d4 07 00 00       	jmp    102dae <__alltraps>

001025da <vector76>:
.globl vector76
vector76:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $76
  1025dc:	6a 4c                	push   $0x4c
  jmp __alltraps
  1025de:	e9 cb 07 00 00       	jmp    102dae <__alltraps>

001025e3 <vector77>:
.globl vector77
vector77:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $77
  1025e5:	6a 4d                	push   $0x4d
  jmp __alltraps
  1025e7:	e9 c2 07 00 00       	jmp    102dae <__alltraps>

001025ec <vector78>:
.globl vector78
vector78:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $78
  1025ee:	6a 4e                	push   $0x4e
  jmp __alltraps
  1025f0:	e9 b9 07 00 00       	jmp    102dae <__alltraps>

001025f5 <vector79>:
.globl vector79
vector79:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $79
  1025f7:	6a 4f                	push   $0x4f
  jmp __alltraps
  1025f9:	e9 b0 07 00 00       	jmp    102dae <__alltraps>

001025fe <vector80>:
.globl vector80
vector80:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $80
  102600:	6a 50                	push   $0x50
  jmp __alltraps
  102602:	e9 a7 07 00 00       	jmp    102dae <__alltraps>

00102607 <vector81>:
.globl vector81
vector81:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $81
  102609:	6a 51                	push   $0x51
  jmp __alltraps
  10260b:	e9 9e 07 00 00       	jmp    102dae <__alltraps>

00102610 <vector82>:
.globl vector82
vector82:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $82
  102612:	6a 52                	push   $0x52
  jmp __alltraps
  102614:	e9 95 07 00 00       	jmp    102dae <__alltraps>

00102619 <vector83>:
.globl vector83
vector83:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $83
  10261b:	6a 53                	push   $0x53
  jmp __alltraps
  10261d:	e9 8c 07 00 00       	jmp    102dae <__alltraps>

00102622 <vector84>:
.globl vector84
vector84:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $84
  102624:	6a 54                	push   $0x54
  jmp __alltraps
  102626:	e9 83 07 00 00       	jmp    102dae <__alltraps>

0010262b <vector85>:
.globl vector85
vector85:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $85
  10262d:	6a 55                	push   $0x55
  jmp __alltraps
  10262f:	e9 7a 07 00 00       	jmp    102dae <__alltraps>

00102634 <vector86>:
.globl vector86
vector86:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $86
  102636:	6a 56                	push   $0x56
  jmp __alltraps
  102638:	e9 71 07 00 00       	jmp    102dae <__alltraps>

0010263d <vector87>:
.globl vector87
vector87:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $87
  10263f:	6a 57                	push   $0x57
  jmp __alltraps
  102641:	e9 68 07 00 00       	jmp    102dae <__alltraps>

00102646 <vector88>:
.globl vector88
vector88:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $88
  102648:	6a 58                	push   $0x58
  jmp __alltraps
  10264a:	e9 5f 07 00 00       	jmp    102dae <__alltraps>

0010264f <vector89>:
.globl vector89
vector89:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $89
  102651:	6a 59                	push   $0x59
  jmp __alltraps
  102653:	e9 56 07 00 00       	jmp    102dae <__alltraps>

00102658 <vector90>:
.globl vector90
vector90:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $90
  10265a:	6a 5a                	push   $0x5a
  jmp __alltraps
  10265c:	e9 4d 07 00 00       	jmp    102dae <__alltraps>

00102661 <vector91>:
.globl vector91
vector91:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $91
  102663:	6a 5b                	push   $0x5b
  jmp __alltraps
  102665:	e9 44 07 00 00       	jmp    102dae <__alltraps>

0010266a <vector92>:
.globl vector92
vector92:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $92
  10266c:	6a 5c                	push   $0x5c
  jmp __alltraps
  10266e:	e9 3b 07 00 00       	jmp    102dae <__alltraps>

00102673 <vector93>:
.globl vector93
vector93:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $93
  102675:	6a 5d                	push   $0x5d
  jmp __alltraps
  102677:	e9 32 07 00 00       	jmp    102dae <__alltraps>

0010267c <vector94>:
.globl vector94
vector94:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $94
  10267e:	6a 5e                	push   $0x5e
  jmp __alltraps
  102680:	e9 29 07 00 00       	jmp    102dae <__alltraps>

00102685 <vector95>:
.globl vector95
vector95:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $95
  102687:	6a 5f                	push   $0x5f
  jmp __alltraps
  102689:	e9 20 07 00 00       	jmp    102dae <__alltraps>

0010268e <vector96>:
.globl vector96
vector96:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $96
  102690:	6a 60                	push   $0x60
  jmp __alltraps
  102692:	e9 17 07 00 00       	jmp    102dae <__alltraps>

00102697 <vector97>:
.globl vector97
vector97:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $97
  102699:	6a 61                	push   $0x61
  jmp __alltraps
  10269b:	e9 0e 07 00 00       	jmp    102dae <__alltraps>

001026a0 <vector98>:
.globl vector98
vector98:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $98
  1026a2:	6a 62                	push   $0x62
  jmp __alltraps
  1026a4:	e9 05 07 00 00       	jmp    102dae <__alltraps>

001026a9 <vector99>:
.globl vector99
vector99:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $99
  1026ab:	6a 63                	push   $0x63
  jmp __alltraps
  1026ad:	e9 fc 06 00 00       	jmp    102dae <__alltraps>

001026b2 <vector100>:
.globl vector100
vector100:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $100
  1026b4:	6a 64                	push   $0x64
  jmp __alltraps
  1026b6:	e9 f3 06 00 00       	jmp    102dae <__alltraps>

001026bb <vector101>:
.globl vector101
vector101:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $101
  1026bd:	6a 65                	push   $0x65
  jmp __alltraps
  1026bf:	e9 ea 06 00 00       	jmp    102dae <__alltraps>

001026c4 <vector102>:
.globl vector102
vector102:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $102
  1026c6:	6a 66                	push   $0x66
  jmp __alltraps
  1026c8:	e9 e1 06 00 00       	jmp    102dae <__alltraps>

001026cd <vector103>:
.globl vector103
vector103:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $103
  1026cf:	6a 67                	push   $0x67
  jmp __alltraps
  1026d1:	e9 d8 06 00 00       	jmp    102dae <__alltraps>

001026d6 <vector104>:
.globl vector104
vector104:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $104
  1026d8:	6a 68                	push   $0x68
  jmp __alltraps
  1026da:	e9 cf 06 00 00       	jmp    102dae <__alltraps>

001026df <vector105>:
.globl vector105
vector105:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $105
  1026e1:	6a 69                	push   $0x69
  jmp __alltraps
  1026e3:	e9 c6 06 00 00       	jmp    102dae <__alltraps>

001026e8 <vector106>:
.globl vector106
vector106:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $106
  1026ea:	6a 6a                	push   $0x6a
  jmp __alltraps
  1026ec:	e9 bd 06 00 00       	jmp    102dae <__alltraps>

001026f1 <vector107>:
.globl vector107
vector107:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $107
  1026f3:	6a 6b                	push   $0x6b
  jmp __alltraps
  1026f5:	e9 b4 06 00 00       	jmp    102dae <__alltraps>

001026fa <vector108>:
.globl vector108
vector108:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $108
  1026fc:	6a 6c                	push   $0x6c
  jmp __alltraps
  1026fe:	e9 ab 06 00 00       	jmp    102dae <__alltraps>

00102703 <vector109>:
.globl vector109
vector109:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $109
  102705:	6a 6d                	push   $0x6d
  jmp __alltraps
  102707:	e9 a2 06 00 00       	jmp    102dae <__alltraps>

0010270c <vector110>:
.globl vector110
vector110:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $110
  10270e:	6a 6e                	push   $0x6e
  jmp __alltraps
  102710:	e9 99 06 00 00       	jmp    102dae <__alltraps>

00102715 <vector111>:
.globl vector111
vector111:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $111
  102717:	6a 6f                	push   $0x6f
  jmp __alltraps
  102719:	e9 90 06 00 00       	jmp    102dae <__alltraps>

0010271e <vector112>:
.globl vector112
vector112:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $112
  102720:	6a 70                	push   $0x70
  jmp __alltraps
  102722:	e9 87 06 00 00       	jmp    102dae <__alltraps>

00102727 <vector113>:
.globl vector113
vector113:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $113
  102729:	6a 71                	push   $0x71
  jmp __alltraps
  10272b:	e9 7e 06 00 00       	jmp    102dae <__alltraps>

00102730 <vector114>:
.globl vector114
vector114:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $114
  102732:	6a 72                	push   $0x72
  jmp __alltraps
  102734:	e9 75 06 00 00       	jmp    102dae <__alltraps>

00102739 <vector115>:
.globl vector115
vector115:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $115
  10273b:	6a 73                	push   $0x73
  jmp __alltraps
  10273d:	e9 6c 06 00 00       	jmp    102dae <__alltraps>

00102742 <vector116>:
.globl vector116
vector116:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $116
  102744:	6a 74                	push   $0x74
  jmp __alltraps
  102746:	e9 63 06 00 00       	jmp    102dae <__alltraps>

0010274b <vector117>:
.globl vector117
vector117:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $117
  10274d:	6a 75                	push   $0x75
  jmp __alltraps
  10274f:	e9 5a 06 00 00       	jmp    102dae <__alltraps>

00102754 <vector118>:
.globl vector118
vector118:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $118
  102756:	6a 76                	push   $0x76
  jmp __alltraps
  102758:	e9 51 06 00 00       	jmp    102dae <__alltraps>

0010275d <vector119>:
.globl vector119
vector119:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $119
  10275f:	6a 77                	push   $0x77
  jmp __alltraps
  102761:	e9 48 06 00 00       	jmp    102dae <__alltraps>

00102766 <vector120>:
.globl vector120
vector120:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $120
  102768:	6a 78                	push   $0x78
  jmp __alltraps
  10276a:	e9 3f 06 00 00       	jmp    102dae <__alltraps>

0010276f <vector121>:
.globl vector121
vector121:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $121
  102771:	6a 79                	push   $0x79
  jmp __alltraps
  102773:	e9 36 06 00 00       	jmp    102dae <__alltraps>

00102778 <vector122>:
.globl vector122
vector122:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $122
  10277a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10277c:	e9 2d 06 00 00       	jmp    102dae <__alltraps>

00102781 <vector123>:
.globl vector123
vector123:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $123
  102783:	6a 7b                	push   $0x7b
  jmp __alltraps
  102785:	e9 24 06 00 00       	jmp    102dae <__alltraps>

0010278a <vector124>:
.globl vector124
vector124:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $124
  10278c:	6a 7c                	push   $0x7c
  jmp __alltraps
  10278e:	e9 1b 06 00 00       	jmp    102dae <__alltraps>

00102793 <vector125>:
.globl vector125
vector125:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $125
  102795:	6a 7d                	push   $0x7d
  jmp __alltraps
  102797:	e9 12 06 00 00       	jmp    102dae <__alltraps>

0010279c <vector126>:
.globl vector126
vector126:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $126
  10279e:	6a 7e                	push   $0x7e
  jmp __alltraps
  1027a0:	e9 09 06 00 00       	jmp    102dae <__alltraps>

001027a5 <vector127>:
.globl vector127
vector127:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $127
  1027a7:	6a 7f                	push   $0x7f
  jmp __alltraps
  1027a9:	e9 00 06 00 00       	jmp    102dae <__alltraps>

001027ae <vector128>:
.globl vector128
vector128:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $128
  1027b0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1027b5:	e9 f4 05 00 00       	jmp    102dae <__alltraps>

001027ba <vector129>:
.globl vector129
vector129:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $129
  1027bc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1027c1:	e9 e8 05 00 00       	jmp    102dae <__alltraps>

001027c6 <vector130>:
.globl vector130
vector130:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $130
  1027c8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1027cd:	e9 dc 05 00 00       	jmp    102dae <__alltraps>

001027d2 <vector131>:
.globl vector131
vector131:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $131
  1027d4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1027d9:	e9 d0 05 00 00       	jmp    102dae <__alltraps>

001027de <vector132>:
.globl vector132
vector132:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $132
  1027e0:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1027e5:	e9 c4 05 00 00       	jmp    102dae <__alltraps>

001027ea <vector133>:
.globl vector133
vector133:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $133
  1027ec:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1027f1:	e9 b8 05 00 00       	jmp    102dae <__alltraps>

001027f6 <vector134>:
.globl vector134
vector134:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $134
  1027f8:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1027fd:	e9 ac 05 00 00       	jmp    102dae <__alltraps>

00102802 <vector135>:
.globl vector135
vector135:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $135
  102804:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102809:	e9 a0 05 00 00       	jmp    102dae <__alltraps>

0010280e <vector136>:
.globl vector136
vector136:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $136
  102810:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102815:	e9 94 05 00 00       	jmp    102dae <__alltraps>

0010281a <vector137>:
.globl vector137
vector137:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $137
  10281c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102821:	e9 88 05 00 00       	jmp    102dae <__alltraps>

00102826 <vector138>:
.globl vector138
vector138:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $138
  102828:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10282d:	e9 7c 05 00 00       	jmp    102dae <__alltraps>

00102832 <vector139>:
.globl vector139
vector139:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $139
  102834:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102839:	e9 70 05 00 00       	jmp    102dae <__alltraps>

0010283e <vector140>:
.globl vector140
vector140:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $140
  102840:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102845:	e9 64 05 00 00       	jmp    102dae <__alltraps>

0010284a <vector141>:
.globl vector141
vector141:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $141
  10284c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102851:	e9 58 05 00 00       	jmp    102dae <__alltraps>

00102856 <vector142>:
.globl vector142
vector142:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $142
  102858:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10285d:	e9 4c 05 00 00       	jmp    102dae <__alltraps>

00102862 <vector143>:
.globl vector143
vector143:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $143
  102864:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102869:	e9 40 05 00 00       	jmp    102dae <__alltraps>

0010286e <vector144>:
.globl vector144
vector144:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $144
  102870:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102875:	e9 34 05 00 00       	jmp    102dae <__alltraps>

0010287a <vector145>:
.globl vector145
vector145:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $145
  10287c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102881:	e9 28 05 00 00       	jmp    102dae <__alltraps>

00102886 <vector146>:
.globl vector146
vector146:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $146
  102888:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10288d:	e9 1c 05 00 00       	jmp    102dae <__alltraps>

00102892 <vector147>:
.globl vector147
vector147:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $147
  102894:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102899:	e9 10 05 00 00       	jmp    102dae <__alltraps>

0010289e <vector148>:
.globl vector148
vector148:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $148
  1028a0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1028a5:	e9 04 05 00 00       	jmp    102dae <__alltraps>

001028aa <vector149>:
.globl vector149
vector149:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $149
  1028ac:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1028b1:	e9 f8 04 00 00       	jmp    102dae <__alltraps>

001028b6 <vector150>:
.globl vector150
vector150:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $150
  1028b8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1028bd:	e9 ec 04 00 00       	jmp    102dae <__alltraps>

001028c2 <vector151>:
.globl vector151
vector151:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $151
  1028c4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1028c9:	e9 e0 04 00 00       	jmp    102dae <__alltraps>

001028ce <vector152>:
.globl vector152
vector152:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $152
  1028d0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1028d5:	e9 d4 04 00 00       	jmp    102dae <__alltraps>

001028da <vector153>:
.globl vector153
vector153:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $153
  1028dc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1028e1:	e9 c8 04 00 00       	jmp    102dae <__alltraps>

001028e6 <vector154>:
.globl vector154
vector154:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $154
  1028e8:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1028ed:	e9 bc 04 00 00       	jmp    102dae <__alltraps>

001028f2 <vector155>:
.globl vector155
vector155:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $155
  1028f4:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1028f9:	e9 b0 04 00 00       	jmp    102dae <__alltraps>

001028fe <vector156>:
.globl vector156
vector156:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $156
  102900:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102905:	e9 a4 04 00 00       	jmp    102dae <__alltraps>

0010290a <vector157>:
.globl vector157
vector157:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $157
  10290c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102911:	e9 98 04 00 00       	jmp    102dae <__alltraps>

00102916 <vector158>:
.globl vector158
vector158:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $158
  102918:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10291d:	e9 8c 04 00 00       	jmp    102dae <__alltraps>

00102922 <vector159>:
.globl vector159
vector159:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $159
  102924:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102929:	e9 80 04 00 00       	jmp    102dae <__alltraps>

0010292e <vector160>:
.globl vector160
vector160:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $160
  102930:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102935:	e9 74 04 00 00       	jmp    102dae <__alltraps>

0010293a <vector161>:
.globl vector161
vector161:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $161
  10293c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102941:	e9 68 04 00 00       	jmp    102dae <__alltraps>

00102946 <vector162>:
.globl vector162
vector162:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $162
  102948:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10294d:	e9 5c 04 00 00       	jmp    102dae <__alltraps>

00102952 <vector163>:
.globl vector163
vector163:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $163
  102954:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102959:	e9 50 04 00 00       	jmp    102dae <__alltraps>

0010295e <vector164>:
.globl vector164
vector164:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $164
  102960:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102965:	e9 44 04 00 00       	jmp    102dae <__alltraps>

0010296a <vector165>:
.globl vector165
vector165:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $165
  10296c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102971:	e9 38 04 00 00       	jmp    102dae <__alltraps>

00102976 <vector166>:
.globl vector166
vector166:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $166
  102978:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10297d:	e9 2c 04 00 00       	jmp    102dae <__alltraps>

00102982 <vector167>:
.globl vector167
vector167:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $167
  102984:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102989:	e9 20 04 00 00       	jmp    102dae <__alltraps>

0010298e <vector168>:
.globl vector168
vector168:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $168
  102990:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102995:	e9 14 04 00 00       	jmp    102dae <__alltraps>

0010299a <vector169>:
.globl vector169
vector169:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $169
  10299c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1029a1:	e9 08 04 00 00       	jmp    102dae <__alltraps>

001029a6 <vector170>:
.globl vector170
vector170:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $170
  1029a8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1029ad:	e9 fc 03 00 00       	jmp    102dae <__alltraps>

001029b2 <vector171>:
.globl vector171
vector171:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $171
  1029b4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1029b9:	e9 f0 03 00 00       	jmp    102dae <__alltraps>

001029be <vector172>:
.globl vector172
vector172:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $172
  1029c0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1029c5:	e9 e4 03 00 00       	jmp    102dae <__alltraps>

001029ca <vector173>:
.globl vector173
vector173:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $173
  1029cc:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1029d1:	e9 d8 03 00 00       	jmp    102dae <__alltraps>

001029d6 <vector174>:
.globl vector174
vector174:
  pushl $0
  1029d6:	6a 00                	push   $0x0
  pushl $174
  1029d8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1029dd:	e9 cc 03 00 00       	jmp    102dae <__alltraps>

001029e2 <vector175>:
.globl vector175
vector175:
  pushl $0
  1029e2:	6a 00                	push   $0x0
  pushl $175
  1029e4:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1029e9:	e9 c0 03 00 00       	jmp    102dae <__alltraps>

001029ee <vector176>:
.globl vector176
vector176:
  pushl $0
  1029ee:	6a 00                	push   $0x0
  pushl $176
  1029f0:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1029f5:	e9 b4 03 00 00       	jmp    102dae <__alltraps>

001029fa <vector177>:
.globl vector177
vector177:
  pushl $0
  1029fa:	6a 00                	push   $0x0
  pushl $177
  1029fc:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102a01:	e9 a8 03 00 00       	jmp    102dae <__alltraps>

00102a06 <vector178>:
.globl vector178
vector178:
  pushl $0
  102a06:	6a 00                	push   $0x0
  pushl $178
  102a08:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102a0d:	e9 9c 03 00 00       	jmp    102dae <__alltraps>

00102a12 <vector179>:
.globl vector179
vector179:
  pushl $0
  102a12:	6a 00                	push   $0x0
  pushl $179
  102a14:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102a19:	e9 90 03 00 00       	jmp    102dae <__alltraps>

00102a1e <vector180>:
.globl vector180
vector180:
  pushl $0
  102a1e:	6a 00                	push   $0x0
  pushl $180
  102a20:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102a25:	e9 84 03 00 00       	jmp    102dae <__alltraps>

00102a2a <vector181>:
.globl vector181
vector181:
  pushl $0
  102a2a:	6a 00                	push   $0x0
  pushl $181
  102a2c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102a31:	e9 78 03 00 00       	jmp    102dae <__alltraps>

00102a36 <vector182>:
.globl vector182
vector182:
  pushl $0
  102a36:	6a 00                	push   $0x0
  pushl $182
  102a38:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102a3d:	e9 6c 03 00 00       	jmp    102dae <__alltraps>

00102a42 <vector183>:
.globl vector183
vector183:
  pushl $0
  102a42:	6a 00                	push   $0x0
  pushl $183
  102a44:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102a49:	e9 60 03 00 00       	jmp    102dae <__alltraps>

00102a4e <vector184>:
.globl vector184
vector184:
  pushl $0
  102a4e:	6a 00                	push   $0x0
  pushl $184
  102a50:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102a55:	e9 54 03 00 00       	jmp    102dae <__alltraps>

00102a5a <vector185>:
.globl vector185
vector185:
  pushl $0
  102a5a:	6a 00                	push   $0x0
  pushl $185
  102a5c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102a61:	e9 48 03 00 00       	jmp    102dae <__alltraps>

00102a66 <vector186>:
.globl vector186
vector186:
  pushl $0
  102a66:	6a 00                	push   $0x0
  pushl $186
  102a68:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102a6d:	e9 3c 03 00 00       	jmp    102dae <__alltraps>

00102a72 <vector187>:
.globl vector187
vector187:
  pushl $0
  102a72:	6a 00                	push   $0x0
  pushl $187
  102a74:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102a79:	e9 30 03 00 00       	jmp    102dae <__alltraps>

00102a7e <vector188>:
.globl vector188
vector188:
  pushl $0
  102a7e:	6a 00                	push   $0x0
  pushl $188
  102a80:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102a85:	e9 24 03 00 00       	jmp    102dae <__alltraps>

00102a8a <vector189>:
.globl vector189
vector189:
  pushl $0
  102a8a:	6a 00                	push   $0x0
  pushl $189
  102a8c:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102a91:	e9 18 03 00 00       	jmp    102dae <__alltraps>

00102a96 <vector190>:
.globl vector190
vector190:
  pushl $0
  102a96:	6a 00                	push   $0x0
  pushl $190
  102a98:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102a9d:	e9 0c 03 00 00       	jmp    102dae <__alltraps>

00102aa2 <vector191>:
.globl vector191
vector191:
  pushl $0
  102aa2:	6a 00                	push   $0x0
  pushl $191
  102aa4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102aa9:	e9 00 03 00 00       	jmp    102dae <__alltraps>

00102aae <vector192>:
.globl vector192
vector192:
  pushl $0
  102aae:	6a 00                	push   $0x0
  pushl $192
  102ab0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102ab5:	e9 f4 02 00 00       	jmp    102dae <__alltraps>

00102aba <vector193>:
.globl vector193
vector193:
  pushl $0
  102aba:	6a 00                	push   $0x0
  pushl $193
  102abc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102ac1:	e9 e8 02 00 00       	jmp    102dae <__alltraps>

00102ac6 <vector194>:
.globl vector194
vector194:
  pushl $0
  102ac6:	6a 00                	push   $0x0
  pushl $194
  102ac8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102acd:	e9 dc 02 00 00       	jmp    102dae <__alltraps>

00102ad2 <vector195>:
.globl vector195
vector195:
  pushl $0
  102ad2:	6a 00                	push   $0x0
  pushl $195
  102ad4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102ad9:	e9 d0 02 00 00       	jmp    102dae <__alltraps>

00102ade <vector196>:
.globl vector196
vector196:
  pushl $0
  102ade:	6a 00                	push   $0x0
  pushl $196
  102ae0:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102ae5:	e9 c4 02 00 00       	jmp    102dae <__alltraps>

00102aea <vector197>:
.globl vector197
vector197:
  pushl $0
  102aea:	6a 00                	push   $0x0
  pushl $197
  102aec:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102af1:	e9 b8 02 00 00       	jmp    102dae <__alltraps>

00102af6 <vector198>:
.globl vector198
vector198:
  pushl $0
  102af6:	6a 00                	push   $0x0
  pushl $198
  102af8:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102afd:	e9 ac 02 00 00       	jmp    102dae <__alltraps>

00102b02 <vector199>:
.globl vector199
vector199:
  pushl $0
  102b02:	6a 00                	push   $0x0
  pushl $199
  102b04:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102b09:	e9 a0 02 00 00       	jmp    102dae <__alltraps>

00102b0e <vector200>:
.globl vector200
vector200:
  pushl $0
  102b0e:	6a 00                	push   $0x0
  pushl $200
  102b10:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102b15:	e9 94 02 00 00       	jmp    102dae <__alltraps>

00102b1a <vector201>:
.globl vector201
vector201:
  pushl $0
  102b1a:	6a 00                	push   $0x0
  pushl $201
  102b1c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102b21:	e9 88 02 00 00       	jmp    102dae <__alltraps>

00102b26 <vector202>:
.globl vector202
vector202:
  pushl $0
  102b26:	6a 00                	push   $0x0
  pushl $202
  102b28:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102b2d:	e9 7c 02 00 00       	jmp    102dae <__alltraps>

00102b32 <vector203>:
.globl vector203
vector203:
  pushl $0
  102b32:	6a 00                	push   $0x0
  pushl $203
  102b34:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102b39:	e9 70 02 00 00       	jmp    102dae <__alltraps>

00102b3e <vector204>:
.globl vector204
vector204:
  pushl $0
  102b3e:	6a 00                	push   $0x0
  pushl $204
  102b40:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102b45:	e9 64 02 00 00       	jmp    102dae <__alltraps>

00102b4a <vector205>:
.globl vector205
vector205:
  pushl $0
  102b4a:	6a 00                	push   $0x0
  pushl $205
  102b4c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102b51:	e9 58 02 00 00       	jmp    102dae <__alltraps>

00102b56 <vector206>:
.globl vector206
vector206:
  pushl $0
  102b56:	6a 00                	push   $0x0
  pushl $206
  102b58:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102b5d:	e9 4c 02 00 00       	jmp    102dae <__alltraps>

00102b62 <vector207>:
.globl vector207
vector207:
  pushl $0
  102b62:	6a 00                	push   $0x0
  pushl $207
  102b64:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102b69:	e9 40 02 00 00       	jmp    102dae <__alltraps>

00102b6e <vector208>:
.globl vector208
vector208:
  pushl $0
  102b6e:	6a 00                	push   $0x0
  pushl $208
  102b70:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102b75:	e9 34 02 00 00       	jmp    102dae <__alltraps>

00102b7a <vector209>:
.globl vector209
vector209:
  pushl $0
  102b7a:	6a 00                	push   $0x0
  pushl $209
  102b7c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102b81:	e9 28 02 00 00       	jmp    102dae <__alltraps>

00102b86 <vector210>:
.globl vector210
vector210:
  pushl $0
  102b86:	6a 00                	push   $0x0
  pushl $210
  102b88:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102b8d:	e9 1c 02 00 00       	jmp    102dae <__alltraps>

00102b92 <vector211>:
.globl vector211
vector211:
  pushl $0
  102b92:	6a 00                	push   $0x0
  pushl $211
  102b94:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102b99:	e9 10 02 00 00       	jmp    102dae <__alltraps>

00102b9e <vector212>:
.globl vector212
vector212:
  pushl $0
  102b9e:	6a 00                	push   $0x0
  pushl $212
  102ba0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102ba5:	e9 04 02 00 00       	jmp    102dae <__alltraps>

00102baa <vector213>:
.globl vector213
vector213:
  pushl $0
  102baa:	6a 00                	push   $0x0
  pushl $213
  102bac:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102bb1:	e9 f8 01 00 00       	jmp    102dae <__alltraps>

00102bb6 <vector214>:
.globl vector214
vector214:
  pushl $0
  102bb6:	6a 00                	push   $0x0
  pushl $214
  102bb8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102bbd:	e9 ec 01 00 00       	jmp    102dae <__alltraps>

00102bc2 <vector215>:
.globl vector215
vector215:
  pushl $0
  102bc2:	6a 00                	push   $0x0
  pushl $215
  102bc4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102bc9:	e9 e0 01 00 00       	jmp    102dae <__alltraps>

00102bce <vector216>:
.globl vector216
vector216:
  pushl $0
  102bce:	6a 00                	push   $0x0
  pushl $216
  102bd0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102bd5:	e9 d4 01 00 00       	jmp    102dae <__alltraps>

00102bda <vector217>:
.globl vector217
vector217:
  pushl $0
  102bda:	6a 00                	push   $0x0
  pushl $217
  102bdc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102be1:	e9 c8 01 00 00       	jmp    102dae <__alltraps>

00102be6 <vector218>:
.globl vector218
vector218:
  pushl $0
  102be6:	6a 00                	push   $0x0
  pushl $218
  102be8:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102bed:	e9 bc 01 00 00       	jmp    102dae <__alltraps>

00102bf2 <vector219>:
.globl vector219
vector219:
  pushl $0
  102bf2:	6a 00                	push   $0x0
  pushl $219
  102bf4:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102bf9:	e9 b0 01 00 00       	jmp    102dae <__alltraps>

00102bfe <vector220>:
.globl vector220
vector220:
  pushl $0
  102bfe:	6a 00                	push   $0x0
  pushl $220
  102c00:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102c05:	e9 a4 01 00 00       	jmp    102dae <__alltraps>

00102c0a <vector221>:
.globl vector221
vector221:
  pushl $0
  102c0a:	6a 00                	push   $0x0
  pushl $221
  102c0c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102c11:	e9 98 01 00 00       	jmp    102dae <__alltraps>

00102c16 <vector222>:
.globl vector222
vector222:
  pushl $0
  102c16:	6a 00                	push   $0x0
  pushl $222
  102c18:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102c1d:	e9 8c 01 00 00       	jmp    102dae <__alltraps>

00102c22 <vector223>:
.globl vector223
vector223:
  pushl $0
  102c22:	6a 00                	push   $0x0
  pushl $223
  102c24:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102c29:	e9 80 01 00 00       	jmp    102dae <__alltraps>

00102c2e <vector224>:
.globl vector224
vector224:
  pushl $0
  102c2e:	6a 00                	push   $0x0
  pushl $224
  102c30:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102c35:	e9 74 01 00 00       	jmp    102dae <__alltraps>

00102c3a <vector225>:
.globl vector225
vector225:
  pushl $0
  102c3a:	6a 00                	push   $0x0
  pushl $225
  102c3c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102c41:	e9 68 01 00 00       	jmp    102dae <__alltraps>

00102c46 <vector226>:
.globl vector226
vector226:
  pushl $0
  102c46:	6a 00                	push   $0x0
  pushl $226
  102c48:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102c4d:	e9 5c 01 00 00       	jmp    102dae <__alltraps>

00102c52 <vector227>:
.globl vector227
vector227:
  pushl $0
  102c52:	6a 00                	push   $0x0
  pushl $227
  102c54:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102c59:	e9 50 01 00 00       	jmp    102dae <__alltraps>

00102c5e <vector228>:
.globl vector228
vector228:
  pushl $0
  102c5e:	6a 00                	push   $0x0
  pushl $228
  102c60:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102c65:	e9 44 01 00 00       	jmp    102dae <__alltraps>

00102c6a <vector229>:
.globl vector229
vector229:
  pushl $0
  102c6a:	6a 00                	push   $0x0
  pushl $229
  102c6c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102c71:	e9 38 01 00 00       	jmp    102dae <__alltraps>

00102c76 <vector230>:
.globl vector230
vector230:
  pushl $0
  102c76:	6a 00                	push   $0x0
  pushl $230
  102c78:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102c7d:	e9 2c 01 00 00       	jmp    102dae <__alltraps>

00102c82 <vector231>:
.globl vector231
vector231:
  pushl $0
  102c82:	6a 00                	push   $0x0
  pushl $231
  102c84:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102c89:	e9 20 01 00 00       	jmp    102dae <__alltraps>

00102c8e <vector232>:
.globl vector232
vector232:
  pushl $0
  102c8e:	6a 00                	push   $0x0
  pushl $232
  102c90:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102c95:	e9 14 01 00 00       	jmp    102dae <__alltraps>

00102c9a <vector233>:
.globl vector233
vector233:
  pushl $0
  102c9a:	6a 00                	push   $0x0
  pushl $233
  102c9c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102ca1:	e9 08 01 00 00       	jmp    102dae <__alltraps>

00102ca6 <vector234>:
.globl vector234
vector234:
  pushl $0
  102ca6:	6a 00                	push   $0x0
  pushl $234
  102ca8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102cad:	e9 fc 00 00 00       	jmp    102dae <__alltraps>

00102cb2 <vector235>:
.globl vector235
vector235:
  pushl $0
  102cb2:	6a 00                	push   $0x0
  pushl $235
  102cb4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102cb9:	e9 f0 00 00 00       	jmp    102dae <__alltraps>

00102cbe <vector236>:
.globl vector236
vector236:
  pushl $0
  102cbe:	6a 00                	push   $0x0
  pushl $236
  102cc0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102cc5:	e9 e4 00 00 00       	jmp    102dae <__alltraps>

00102cca <vector237>:
.globl vector237
vector237:
  pushl $0
  102cca:	6a 00                	push   $0x0
  pushl $237
  102ccc:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102cd1:	e9 d8 00 00 00       	jmp    102dae <__alltraps>

00102cd6 <vector238>:
.globl vector238
vector238:
  pushl $0
  102cd6:	6a 00                	push   $0x0
  pushl $238
  102cd8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102cdd:	e9 cc 00 00 00       	jmp    102dae <__alltraps>

00102ce2 <vector239>:
.globl vector239
vector239:
  pushl $0
  102ce2:	6a 00                	push   $0x0
  pushl $239
  102ce4:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102ce9:	e9 c0 00 00 00       	jmp    102dae <__alltraps>

00102cee <vector240>:
.globl vector240
vector240:
  pushl $0
  102cee:	6a 00                	push   $0x0
  pushl $240
  102cf0:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102cf5:	e9 b4 00 00 00       	jmp    102dae <__alltraps>

00102cfa <vector241>:
.globl vector241
vector241:
  pushl $0
  102cfa:	6a 00                	push   $0x0
  pushl $241
  102cfc:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102d01:	e9 a8 00 00 00       	jmp    102dae <__alltraps>

00102d06 <vector242>:
.globl vector242
vector242:
  pushl $0
  102d06:	6a 00                	push   $0x0
  pushl $242
  102d08:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102d0d:	e9 9c 00 00 00       	jmp    102dae <__alltraps>

00102d12 <vector243>:
.globl vector243
vector243:
  pushl $0
  102d12:	6a 00                	push   $0x0
  pushl $243
  102d14:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102d19:	e9 90 00 00 00       	jmp    102dae <__alltraps>

00102d1e <vector244>:
.globl vector244
vector244:
  pushl $0
  102d1e:	6a 00                	push   $0x0
  pushl $244
  102d20:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102d25:	e9 84 00 00 00       	jmp    102dae <__alltraps>

00102d2a <vector245>:
.globl vector245
vector245:
  pushl $0
  102d2a:	6a 00                	push   $0x0
  pushl $245
  102d2c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102d31:	e9 78 00 00 00       	jmp    102dae <__alltraps>

00102d36 <vector246>:
.globl vector246
vector246:
  pushl $0
  102d36:	6a 00                	push   $0x0
  pushl $246
  102d38:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102d3d:	e9 6c 00 00 00       	jmp    102dae <__alltraps>

00102d42 <vector247>:
.globl vector247
vector247:
  pushl $0
  102d42:	6a 00                	push   $0x0
  pushl $247
  102d44:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102d49:	e9 60 00 00 00       	jmp    102dae <__alltraps>

00102d4e <vector248>:
.globl vector248
vector248:
  pushl $0
  102d4e:	6a 00                	push   $0x0
  pushl $248
  102d50:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102d55:	e9 54 00 00 00       	jmp    102dae <__alltraps>

00102d5a <vector249>:
.globl vector249
vector249:
  pushl $0
  102d5a:	6a 00                	push   $0x0
  pushl $249
  102d5c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102d61:	e9 48 00 00 00       	jmp    102dae <__alltraps>

00102d66 <vector250>:
.globl vector250
vector250:
  pushl $0
  102d66:	6a 00                	push   $0x0
  pushl $250
  102d68:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102d6d:	e9 3c 00 00 00       	jmp    102dae <__alltraps>

00102d72 <vector251>:
.globl vector251
vector251:
  pushl $0
  102d72:	6a 00                	push   $0x0
  pushl $251
  102d74:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102d79:	e9 30 00 00 00       	jmp    102dae <__alltraps>

00102d7e <vector252>:
.globl vector252
vector252:
  pushl $0
  102d7e:	6a 00                	push   $0x0
  pushl $252
  102d80:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102d85:	e9 24 00 00 00       	jmp    102dae <__alltraps>

00102d8a <vector253>:
.globl vector253
vector253:
  pushl $0
  102d8a:	6a 00                	push   $0x0
  pushl $253
  102d8c:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102d91:	e9 18 00 00 00       	jmp    102dae <__alltraps>

00102d96 <vector254>:
.globl vector254
vector254:
  pushl $0
  102d96:	6a 00                	push   $0x0
  pushl $254
  102d98:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102d9d:	e9 0c 00 00 00       	jmp    102dae <__alltraps>

00102da2 <vector255>:
.globl vector255
vector255:
  pushl $0
  102da2:	6a 00                	push   $0x0
  pushl $255
  102da4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102da9:	e9 00 00 00 00       	jmp    102dae <__alltraps>

00102dae <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102dae:	1e                   	push   %ds
    pushl %es
  102daf:	06                   	push   %es
    pushl %fs
  102db0:	0f a0                	push   %fs
    pushl %gs
  102db2:	0f a8                	push   %gs
    pushal
  102db4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102db5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102dba:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102dbc:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102dbe:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102dbf:	e8 60 f5 ff ff       	call   102324 <trap>

    # pop the pushed stack pointer
    popl %esp
  102dc4:	5c                   	pop    %esp

00102dc5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102dc5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102dc6:	0f a9                	pop    %gs
    popl %fs
  102dc8:	0f a1                	pop    %fs
    popl %es
  102dca:	07                   	pop    %es
    popl %ds
  102dcb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102dcc:	83 c4 08             	add    $0x8,%esp
    iret
  102dcf:	cf                   	iret   

00102dd0 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102dd0:	55                   	push   %ebp
  102dd1:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102dd3:	a1 78 ff 11 00       	mov    0x11ff78,%eax
  102dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  102ddb:	29 c2                	sub    %eax,%edx
  102ddd:	89 d0                	mov    %edx,%eax
  102ddf:	c1 f8 02             	sar    $0x2,%eax
  102de2:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102de8:	5d                   	pop    %ebp
  102de9:	c3                   	ret    

00102dea <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102dea:	55                   	push   %ebp
  102deb:	89 e5                	mov    %esp,%ebp
  102ded:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102df0:	8b 45 08             	mov    0x8(%ebp),%eax
  102df3:	89 04 24             	mov    %eax,(%esp)
  102df6:	e8 d5 ff ff ff       	call   102dd0 <page2ppn>
  102dfb:	c1 e0 0c             	shl    $0xc,%eax
}
  102dfe:	c9                   	leave  
  102dff:	c3                   	ret    

00102e00 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102e00:	55                   	push   %ebp
  102e01:	89 e5                	mov    %esp,%ebp
  102e03:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102e06:	8b 45 08             	mov    0x8(%ebp),%eax
  102e09:	c1 e8 0c             	shr    $0xc,%eax
  102e0c:	89 c2                	mov    %eax,%edx
  102e0e:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  102e13:	39 c2                	cmp    %eax,%edx
  102e15:	72 1c                	jb     102e33 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102e17:	c7 44 24 08 70 7b 10 	movl   $0x107b70,0x8(%esp)
  102e1e:	00 
  102e1f:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102e26:	00 
  102e27:	c7 04 24 8f 7b 10 00 	movl   $0x107b8f,(%esp)
  102e2e:	e8 fe d5 ff ff       	call   100431 <__panic>
    }
    return &pages[PPN(pa)];
  102e33:	8b 0d 78 ff 11 00    	mov    0x11ff78,%ecx
  102e39:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3c:	c1 e8 0c             	shr    $0xc,%eax
  102e3f:	89 c2                	mov    %eax,%edx
  102e41:	89 d0                	mov    %edx,%eax
  102e43:	c1 e0 02             	shl    $0x2,%eax
  102e46:	01 d0                	add    %edx,%eax
  102e48:	c1 e0 02             	shl    $0x2,%eax
  102e4b:	01 c8                	add    %ecx,%eax
}
  102e4d:	c9                   	leave  
  102e4e:	c3                   	ret    

00102e4f <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102e4f:	55                   	push   %ebp
  102e50:	89 e5                	mov    %esp,%ebp
  102e52:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102e55:	8b 45 08             	mov    0x8(%ebp),%eax
  102e58:	89 04 24             	mov    %eax,(%esp)
  102e5b:	e8 8a ff ff ff       	call   102dea <page2pa>
  102e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e66:	c1 e8 0c             	shr    $0xc,%eax
  102e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e6c:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  102e71:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102e74:	72 23                	jb     102e99 <page2kva+0x4a>
  102e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e7d:	c7 44 24 08 a0 7b 10 	movl   $0x107ba0,0x8(%esp)
  102e84:	00 
  102e85:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102e8c:	00 
  102e8d:	c7 04 24 8f 7b 10 00 	movl   $0x107b8f,(%esp)
  102e94:	e8 98 d5 ff ff       	call   100431 <__panic>
  102e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e9c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102ea1:	c9                   	leave  
  102ea2:	c3                   	ret    

00102ea3 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102ea3:	55                   	push   %ebp
  102ea4:	89 e5                	mov    %esp,%ebp
  102ea6:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eac:	83 e0 01             	and    $0x1,%eax
  102eaf:	85 c0                	test   %eax,%eax
  102eb1:	75 1c                	jne    102ecf <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102eb3:	c7 44 24 08 c4 7b 10 	movl   $0x107bc4,0x8(%esp)
  102eba:	00 
  102ebb:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102ec2:	00 
  102ec3:	c7 04 24 8f 7b 10 00 	movl   $0x107b8f,(%esp)
  102eca:	e8 62 d5 ff ff       	call   100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102ed7:	89 04 24             	mov    %eax,(%esp)
  102eda:	e8 21 ff ff ff       	call   102e00 <pa2page>
}
  102edf:	c9                   	leave  
  102ee0:	c3                   	ret    

00102ee1 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102ee1:	55                   	push   %ebp
  102ee2:	89 e5                	mov    %esp,%ebp
  102ee4:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102eef:	89 04 24             	mov    %eax,(%esp)
  102ef2:	e8 09 ff ff ff       	call   102e00 <pa2page>
}
  102ef7:	c9                   	leave  
  102ef8:	c3                   	ret    

00102ef9 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102ef9:	55                   	push   %ebp
  102efa:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102efc:	8b 45 08             	mov    0x8(%ebp),%eax
  102eff:	8b 00                	mov    (%eax),%eax
}
  102f01:	5d                   	pop    %ebp
  102f02:	c3                   	ret    

00102f03 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102f03:	55                   	push   %ebp
  102f04:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102f06:	8b 45 08             	mov    0x8(%ebp),%eax
  102f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f0c:	89 10                	mov    %edx,(%eax)
}
  102f0e:	90                   	nop
  102f0f:	5d                   	pop    %ebp
  102f10:	c3                   	ret    

00102f11 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102f11:	55                   	push   %ebp
  102f12:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102f14:	8b 45 08             	mov    0x8(%ebp),%eax
  102f17:	8b 00                	mov    (%eax),%eax
  102f19:	8d 50 01             	lea    0x1(%eax),%edx
  102f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102f21:	8b 45 08             	mov    0x8(%ebp),%eax
  102f24:	8b 00                	mov    (%eax),%eax
}
  102f26:	5d                   	pop    %ebp
  102f27:	c3                   	ret    

00102f28 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102f28:	55                   	push   %ebp
  102f29:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2e:	8b 00                	mov    (%eax),%eax
  102f30:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f33:	8b 45 08             	mov    0x8(%ebp),%eax
  102f36:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102f38:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3b:	8b 00                	mov    (%eax),%eax
}
  102f3d:	5d                   	pop    %ebp
  102f3e:	c3                   	ret    

00102f3f <__intr_save>:
__intr_save(void) {
  102f3f:	55                   	push   %ebp
  102f40:	89 e5                	mov    %esp,%ebp
  102f42:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102f45:	9c                   	pushf  
  102f46:	58                   	pop    %eax
  102f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102f4d:	25 00 02 00 00       	and    $0x200,%eax
  102f52:	85 c0                	test   %eax,%eax
  102f54:	74 0c                	je     102f62 <__intr_save+0x23>
        intr_disable();
  102f56:	e8 2a ea ff ff       	call   101985 <intr_disable>
        return 1;
  102f5b:	b8 01 00 00 00       	mov    $0x1,%eax
  102f60:	eb 05                	jmp    102f67 <__intr_save+0x28>
    return 0;
  102f62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f67:	c9                   	leave  
  102f68:	c3                   	ret    

00102f69 <__intr_restore>:
__intr_restore(bool flag) {
  102f69:	55                   	push   %ebp
  102f6a:	89 e5                	mov    %esp,%ebp
  102f6c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f73:	74 05                	je     102f7a <__intr_restore+0x11>
        intr_enable();
  102f75:	e8 ff e9 ff ff       	call   101979 <intr_enable>
}
  102f7a:	90                   	nop
  102f7b:	c9                   	leave  
  102f7c:	c3                   	ret    

00102f7d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102f7d:	55                   	push   %ebp
  102f7e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102f80:	8b 45 08             	mov    0x8(%ebp),%eax
  102f83:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102f86:	b8 23 00 00 00       	mov    $0x23,%eax
  102f8b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102f8d:	b8 23 00 00 00       	mov    $0x23,%eax
  102f92:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102f94:	b8 10 00 00 00       	mov    $0x10,%eax
  102f99:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102f9b:	b8 10 00 00 00       	mov    $0x10,%eax
  102fa0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102fa2:	b8 10 00 00 00       	mov    $0x10,%eax
  102fa7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102fa9:	ea b0 2f 10 00 08 00 	ljmp   $0x8,$0x102fb0
}
  102fb0:	90                   	nop
  102fb1:	5d                   	pop    %ebp
  102fb2:	c3                   	ret    

00102fb3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102fb3:	f3 0f 1e fb          	endbr32 
  102fb7:	55                   	push   %ebp
  102fb8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102fba:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbd:	a3 a4 fe 11 00       	mov    %eax,0x11fea4
}
  102fc2:	90                   	nop
  102fc3:	5d                   	pop    %ebp
  102fc4:	c3                   	ret    

00102fc5 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102fc5:	f3 0f 1e fb          	endbr32 
  102fc9:	55                   	push   %ebp
  102fca:	89 e5                	mov    %esp,%ebp
  102fcc:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102fcf:	b8 00 c0 11 00       	mov    $0x11c000,%eax
  102fd4:	89 04 24             	mov    %eax,(%esp)
  102fd7:	e8 d7 ff ff ff       	call   102fb3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102fdc:	66 c7 05 a8 fe 11 00 	movw   $0x10,0x11fea8
  102fe3:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102fe5:	66 c7 05 28 ca 11 00 	movw   $0x68,0x11ca28
  102fec:	68 00 
  102fee:	b8 a0 fe 11 00       	mov    $0x11fea0,%eax
  102ff3:	0f b7 c0             	movzwl %ax,%eax
  102ff6:	66 a3 2a ca 11 00    	mov    %ax,0x11ca2a
  102ffc:	b8 a0 fe 11 00       	mov    $0x11fea0,%eax
  103001:	c1 e8 10             	shr    $0x10,%eax
  103004:	a2 2c ca 11 00       	mov    %al,0x11ca2c
  103009:	0f b6 05 2d ca 11 00 	movzbl 0x11ca2d,%eax
  103010:	24 f0                	and    $0xf0,%al
  103012:	0c 09                	or     $0x9,%al
  103014:	a2 2d ca 11 00       	mov    %al,0x11ca2d
  103019:	0f b6 05 2d ca 11 00 	movzbl 0x11ca2d,%eax
  103020:	24 ef                	and    $0xef,%al
  103022:	a2 2d ca 11 00       	mov    %al,0x11ca2d
  103027:	0f b6 05 2d ca 11 00 	movzbl 0x11ca2d,%eax
  10302e:	24 9f                	and    $0x9f,%al
  103030:	a2 2d ca 11 00       	mov    %al,0x11ca2d
  103035:	0f b6 05 2d ca 11 00 	movzbl 0x11ca2d,%eax
  10303c:	0c 80                	or     $0x80,%al
  10303e:	a2 2d ca 11 00       	mov    %al,0x11ca2d
  103043:	0f b6 05 2e ca 11 00 	movzbl 0x11ca2e,%eax
  10304a:	24 f0                	and    $0xf0,%al
  10304c:	a2 2e ca 11 00       	mov    %al,0x11ca2e
  103051:	0f b6 05 2e ca 11 00 	movzbl 0x11ca2e,%eax
  103058:	24 ef                	and    $0xef,%al
  10305a:	a2 2e ca 11 00       	mov    %al,0x11ca2e
  10305f:	0f b6 05 2e ca 11 00 	movzbl 0x11ca2e,%eax
  103066:	24 df                	and    $0xdf,%al
  103068:	a2 2e ca 11 00       	mov    %al,0x11ca2e
  10306d:	0f b6 05 2e ca 11 00 	movzbl 0x11ca2e,%eax
  103074:	0c 40                	or     $0x40,%al
  103076:	a2 2e ca 11 00       	mov    %al,0x11ca2e
  10307b:	0f b6 05 2e ca 11 00 	movzbl 0x11ca2e,%eax
  103082:	24 7f                	and    $0x7f,%al
  103084:	a2 2e ca 11 00       	mov    %al,0x11ca2e
  103089:	b8 a0 fe 11 00       	mov    $0x11fea0,%eax
  10308e:	c1 e8 18             	shr    $0x18,%eax
  103091:	a2 2f ca 11 00       	mov    %al,0x11ca2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103096:	c7 04 24 30 ca 11 00 	movl   $0x11ca30,(%esp)
  10309d:	e8 db fe ff ff       	call   102f7d <lgdt>
  1030a2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  1030a8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1030ac:	0f 00 d8             	ltr    %ax
}
  1030af:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  1030b0:	90                   	nop
  1030b1:	c9                   	leave  
  1030b2:	c3                   	ret    

001030b3 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  1030b3:	f3 0f 1e fb          	endbr32 
  1030b7:	55                   	push   %ebp
  1030b8:	89 e5                	mov    %esp,%ebp
  1030ba:	83 ec 18             	sub    $0x18,%esp
    //pmm_manager = &default_pmm_manager;
    pmm_manager= &buddy_pmm_manager;
  1030bd:	c7 05 70 ff 11 00 a8 	movl   $0x1089a8,0x11ff70
  1030c4:	89 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  1030c7:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  1030cc:	8b 00                	mov    (%eax),%eax
  1030ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030d2:	c7 04 24 f0 7b 10 00 	movl   $0x107bf0,(%esp)
  1030d9:	e8 e7 d1 ff ff       	call   1002c5 <cprintf>
    pmm_manager->init();
  1030de:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  1030e3:	8b 40 04             	mov    0x4(%eax),%eax
  1030e6:	ff d0                	call   *%eax
}
  1030e8:	90                   	nop
  1030e9:	c9                   	leave  
  1030ea:	c3                   	ret    

001030eb <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  1030eb:	f3 0f 1e fb          	endbr32 
  1030ef:	55                   	push   %ebp
  1030f0:	89 e5                	mov    %esp,%ebp
  1030f2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  1030f5:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  1030fa:	8b 40 08             	mov    0x8(%eax),%eax
  1030fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  103100:	89 54 24 04          	mov    %edx,0x4(%esp)
  103104:	8b 55 08             	mov    0x8(%ebp),%edx
  103107:	89 14 24             	mov    %edx,(%esp)
  10310a:	ff d0                	call   *%eax
}
  10310c:	90                   	nop
  10310d:	c9                   	leave  
  10310e:	c3                   	ret    

0010310f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  10310f:	f3 0f 1e fb          	endbr32 
  103113:	55                   	push   %ebp
  103114:	89 e5                	mov    %esp,%ebp
  103116:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103119:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103120:	e8 1a fe ff ff       	call   102f3f <__intr_save>
  103125:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103128:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  10312d:	8b 40 0c             	mov    0xc(%eax),%eax
  103130:	8b 55 08             	mov    0x8(%ebp),%edx
  103133:	89 14 24             	mov    %edx,(%esp)
  103136:	ff d0                	call   *%eax
  103138:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  10313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313e:	89 04 24             	mov    %eax,(%esp)
  103141:	e8 23 fe ff ff       	call   102f69 <__intr_restore>
    return page;
  103146:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103149:	c9                   	leave  
  10314a:	c3                   	ret    

0010314b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  10314b:	f3 0f 1e fb          	endbr32 
  10314f:	55                   	push   %ebp
  103150:	89 e5                	mov    %esp,%ebp
  103152:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103155:	e8 e5 fd ff ff       	call   102f3f <__intr_save>
  10315a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  10315d:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  103162:	8b 40 10             	mov    0x10(%eax),%eax
  103165:	8b 55 0c             	mov    0xc(%ebp),%edx
  103168:	89 54 24 04          	mov    %edx,0x4(%esp)
  10316c:	8b 55 08             	mov    0x8(%ebp),%edx
  10316f:	89 14 24             	mov    %edx,(%esp)
  103172:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103177:	89 04 24             	mov    %eax,(%esp)
  10317a:	e8 ea fd ff ff       	call   102f69 <__intr_restore>
}
  10317f:	90                   	nop
  103180:	c9                   	leave  
  103181:	c3                   	ret    

00103182 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103182:	f3 0f 1e fb          	endbr32 
  103186:	55                   	push   %ebp
  103187:	89 e5                	mov    %esp,%ebp
  103189:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  10318c:	e8 ae fd ff ff       	call   102f3f <__intr_save>
  103191:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103194:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  103199:	8b 40 14             	mov    0x14(%eax),%eax
  10319c:	ff d0                	call   *%eax
  10319e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  1031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031a4:	89 04 24             	mov    %eax,(%esp)
  1031a7:	e8 bd fd ff ff       	call   102f69 <__intr_restore>
    return ret;
  1031ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1031af:	c9                   	leave  
  1031b0:	c3                   	ret    

001031b1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  1031b1:	f3 0f 1e fb          	endbr32 
  1031b5:	55                   	push   %ebp
  1031b6:	89 e5                	mov    %esp,%ebp
  1031b8:	57                   	push   %edi
  1031b9:	56                   	push   %esi
  1031ba:	53                   	push   %ebx
  1031bb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  1031c1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  1031c8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1031cf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  1031d6:	c7 04 24 07 7c 10 00 	movl   $0x107c07,(%esp)
  1031dd:	e8 e3 d0 ff ff       	call   1002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1031e2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1031e9:	e9 1a 01 00 00       	jmp    103308 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1031ee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1031f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031f4:	89 d0                	mov    %edx,%eax
  1031f6:	c1 e0 02             	shl    $0x2,%eax
  1031f9:	01 d0                	add    %edx,%eax
  1031fb:	c1 e0 02             	shl    $0x2,%eax
  1031fe:	01 c8                	add    %ecx,%eax
  103200:	8b 50 08             	mov    0x8(%eax),%edx
  103203:	8b 40 04             	mov    0x4(%eax),%eax
  103206:	89 45 a0             	mov    %eax,-0x60(%ebp)
  103209:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  10320c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10320f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103212:	89 d0                	mov    %edx,%eax
  103214:	c1 e0 02             	shl    $0x2,%eax
  103217:	01 d0                	add    %edx,%eax
  103219:	c1 e0 02             	shl    $0x2,%eax
  10321c:	01 c8                	add    %ecx,%eax
  10321e:	8b 48 0c             	mov    0xc(%eax),%ecx
  103221:	8b 58 10             	mov    0x10(%eax),%ebx
  103224:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103227:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10322a:	01 c8                	add    %ecx,%eax
  10322c:	11 da                	adc    %ebx,%edx
  10322e:	89 45 98             	mov    %eax,-0x68(%ebp)
  103231:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103234:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103237:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10323a:	89 d0                	mov    %edx,%eax
  10323c:	c1 e0 02             	shl    $0x2,%eax
  10323f:	01 d0                	add    %edx,%eax
  103241:	c1 e0 02             	shl    $0x2,%eax
  103244:	01 c8                	add    %ecx,%eax
  103246:	83 c0 14             	add    $0x14,%eax
  103249:	8b 00                	mov    (%eax),%eax
  10324b:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10324e:	8b 45 98             	mov    -0x68(%ebp),%eax
  103251:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103254:	83 c0 ff             	add    $0xffffffff,%eax
  103257:	83 d2 ff             	adc    $0xffffffff,%edx
  10325a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  103260:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  103266:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103269:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10326c:	89 d0                	mov    %edx,%eax
  10326e:	c1 e0 02             	shl    $0x2,%eax
  103271:	01 d0                	add    %edx,%eax
  103273:	c1 e0 02             	shl    $0x2,%eax
  103276:	01 c8                	add    %ecx,%eax
  103278:	8b 48 0c             	mov    0xc(%eax),%ecx
  10327b:	8b 58 10             	mov    0x10(%eax),%ebx
  10327e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103281:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  103285:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  10328b:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  103291:	89 44 24 14          	mov    %eax,0x14(%esp)
  103295:	89 54 24 18          	mov    %edx,0x18(%esp)
  103299:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10329c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10329f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032a3:	89 54 24 10          	mov    %edx,0x10(%esp)
  1032a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1032ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1032af:	c7 04 24 14 7c 10 00 	movl   $0x107c14,(%esp)
  1032b6:	e8 0a d0 ff ff       	call   1002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1032bb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1032be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1032c1:	89 d0                	mov    %edx,%eax
  1032c3:	c1 e0 02             	shl    $0x2,%eax
  1032c6:	01 d0                	add    %edx,%eax
  1032c8:	c1 e0 02             	shl    $0x2,%eax
  1032cb:	01 c8                	add    %ecx,%eax
  1032cd:	83 c0 14             	add    $0x14,%eax
  1032d0:	8b 00                	mov    (%eax),%eax
  1032d2:	83 f8 01             	cmp    $0x1,%eax
  1032d5:	75 2e                	jne    103305 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  1032d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032dd:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1032e0:	89 d0                	mov    %edx,%eax
  1032e2:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  1032e5:	73 1e                	jae    103305 <page_init+0x154>
  1032e7:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1032ec:	b8 00 00 00 00       	mov    $0x0,%eax
  1032f1:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  1032f4:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  1032f7:	72 0c                	jb     103305 <page_init+0x154>
                maxpa = end;
  1032f9:	8b 45 98             	mov    -0x68(%ebp),%eax
  1032fc:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1032ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  103305:	ff 45 dc             	incl   -0x24(%ebp)
  103308:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10330b:	8b 00                	mov    (%eax),%eax
  10330d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103310:	0f 8c d8 fe ff ff    	jl     1031ee <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103316:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10331b:	b8 00 00 00 00       	mov    $0x0,%eax
  103320:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  103323:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  103326:	73 0e                	jae    103336 <page_init+0x185>
        maxpa = KMEMSIZE;
  103328:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10332f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103339:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10333c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103340:	c1 ea 0c             	shr    $0xc,%edx
  103343:	a3 80 fe 11 00       	mov    %eax,0x11fe80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103348:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  10334f:	b8 20 00 12 00       	mov    $0x120020,%eax
  103354:	8d 50 ff             	lea    -0x1(%eax),%edx
  103357:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10335a:	01 d0                	add    %edx,%eax
  10335c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10335f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103362:	ba 00 00 00 00       	mov    $0x0,%edx
  103367:	f7 75 c0             	divl   -0x40(%ebp)
  10336a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10336d:	29 d0                	sub    %edx,%eax
  10336f:	a3 78 ff 11 00       	mov    %eax,0x11ff78

    for (i = 0; i < npage; i ++) {
  103374:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10337b:	eb 2f                	jmp    1033ac <page_init+0x1fb>
        SetPageReserved(pages + i);
  10337d:	8b 0d 78 ff 11 00    	mov    0x11ff78,%ecx
  103383:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103386:	89 d0                	mov    %edx,%eax
  103388:	c1 e0 02             	shl    $0x2,%eax
  10338b:	01 d0                	add    %edx,%eax
  10338d:	c1 e0 02             	shl    $0x2,%eax
  103390:	01 c8                	add    %ecx,%eax
  103392:	83 c0 04             	add    $0x4,%eax
  103395:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  10339c:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10339f:	8b 45 90             	mov    -0x70(%ebp),%eax
  1033a2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1033a5:	0f ab 10             	bts    %edx,(%eax)
}
  1033a8:	90                   	nop
    for (i = 0; i < npage; i ++) {
  1033a9:	ff 45 dc             	incl   -0x24(%ebp)
  1033ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1033af:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  1033b4:	39 c2                	cmp    %eax,%edx
  1033b6:	72 c5                	jb     10337d <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1033b8:	8b 15 80 fe 11 00    	mov    0x11fe80,%edx
  1033be:	89 d0                	mov    %edx,%eax
  1033c0:	c1 e0 02             	shl    $0x2,%eax
  1033c3:	01 d0                	add    %edx,%eax
  1033c5:	c1 e0 02             	shl    $0x2,%eax
  1033c8:	89 c2                	mov    %eax,%edx
  1033ca:	a1 78 ff 11 00       	mov    0x11ff78,%eax
  1033cf:	01 d0                	add    %edx,%eax
  1033d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1033d4:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1033db:	77 23                	ja     103400 <page_init+0x24f>
  1033dd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1033e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033e4:	c7 44 24 08 44 7c 10 	movl   $0x107c44,0x8(%esp)
  1033eb:	00 
  1033ec:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1033f3:	00 
  1033f4:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1033fb:	e8 31 d0 ff ff       	call   100431 <__panic>
  103400:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103403:	05 00 00 00 40       	add    $0x40000000,%eax
  103408:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10340b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103412:	e9 4b 01 00 00       	jmp    103562 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103417:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10341a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10341d:	89 d0                	mov    %edx,%eax
  10341f:	c1 e0 02             	shl    $0x2,%eax
  103422:	01 d0                	add    %edx,%eax
  103424:	c1 e0 02             	shl    $0x2,%eax
  103427:	01 c8                	add    %ecx,%eax
  103429:	8b 50 08             	mov    0x8(%eax),%edx
  10342c:	8b 40 04             	mov    0x4(%eax),%eax
  10342f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103432:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103435:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103438:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10343b:	89 d0                	mov    %edx,%eax
  10343d:	c1 e0 02             	shl    $0x2,%eax
  103440:	01 d0                	add    %edx,%eax
  103442:	c1 e0 02             	shl    $0x2,%eax
  103445:	01 c8                	add    %ecx,%eax
  103447:	8b 48 0c             	mov    0xc(%eax),%ecx
  10344a:	8b 58 10             	mov    0x10(%eax),%ebx
  10344d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103450:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103453:	01 c8                	add    %ecx,%eax
  103455:	11 da                	adc    %ebx,%edx
  103457:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10345a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10345d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103460:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103463:	89 d0                	mov    %edx,%eax
  103465:	c1 e0 02             	shl    $0x2,%eax
  103468:	01 d0                	add    %edx,%eax
  10346a:	c1 e0 02             	shl    $0x2,%eax
  10346d:	01 c8                	add    %ecx,%eax
  10346f:	83 c0 14             	add    $0x14,%eax
  103472:	8b 00                	mov    (%eax),%eax
  103474:	83 f8 01             	cmp    $0x1,%eax
  103477:	0f 85 e2 00 00 00    	jne    10355f <page_init+0x3ae>
            if (begin < freemem) {
  10347d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103480:	ba 00 00 00 00       	mov    $0x0,%edx
  103485:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103488:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10348b:	19 d1                	sbb    %edx,%ecx
  10348d:	73 0d                	jae    10349c <page_init+0x2eb>
                begin = freemem;
  10348f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103492:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103495:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10349c:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1034a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1034a6:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1034a9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1034ac:	73 0e                	jae    1034bc <page_init+0x30b>
                end = KMEMSIZE;
  1034ae:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1034b5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1034bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1034bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1034c2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1034c5:	89 d0                	mov    %edx,%eax
  1034c7:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1034ca:	0f 83 8f 00 00 00    	jae    10355f <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  1034d0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1034d7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1034da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034dd:	01 d0                	add    %edx,%eax
  1034df:	48                   	dec    %eax
  1034e0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1034e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1034e6:	ba 00 00 00 00       	mov    $0x0,%edx
  1034eb:	f7 75 b0             	divl   -0x50(%ebp)
  1034ee:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1034f1:	29 d0                	sub    %edx,%eax
  1034f3:	ba 00 00 00 00       	mov    $0x0,%edx
  1034f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1034fb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1034fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103501:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103504:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103507:	ba 00 00 00 00       	mov    $0x0,%edx
  10350c:	89 c3                	mov    %eax,%ebx
  10350e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  103514:	89 de                	mov    %ebx,%esi
  103516:	89 d0                	mov    %edx,%eax
  103518:	83 e0 00             	and    $0x0,%eax
  10351b:	89 c7                	mov    %eax,%edi
  10351d:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103520:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  103523:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103526:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103529:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10352c:	89 d0                	mov    %edx,%eax
  10352e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103531:	73 2c                	jae    10355f <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103536:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103539:	2b 45 d0             	sub    -0x30(%ebp),%eax
  10353c:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10353f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103543:	c1 ea 0c             	shr    $0xc,%edx
  103546:	89 c3                	mov    %eax,%ebx
  103548:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10354b:	89 04 24             	mov    %eax,(%esp)
  10354e:	e8 ad f8 ff ff       	call   102e00 <pa2page>
  103553:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103557:	89 04 24             	mov    %eax,(%esp)
  10355a:	e8 8c fb ff ff       	call   1030eb <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10355f:	ff 45 dc             	incl   -0x24(%ebp)
  103562:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103565:	8b 00                	mov    (%eax),%eax
  103567:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10356a:	0f 8c a7 fe ff ff    	jl     103417 <page_init+0x266>
                }
            }
        }
    }
}
  103570:	90                   	nop
  103571:	90                   	nop
  103572:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103578:	5b                   	pop    %ebx
  103579:	5e                   	pop    %esi
  10357a:	5f                   	pop    %edi
  10357b:	5d                   	pop    %ebp
  10357c:	c3                   	ret    

0010357d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10357d:	f3 0f 1e fb          	endbr32 
  103581:	55                   	push   %ebp
  103582:	89 e5                	mov    %esp,%ebp
  103584:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10358a:	33 45 14             	xor    0x14(%ebp),%eax
  10358d:	25 ff 0f 00 00       	and    $0xfff,%eax
  103592:	85 c0                	test   %eax,%eax
  103594:	74 24                	je     1035ba <boot_map_segment+0x3d>
  103596:	c7 44 24 0c 76 7c 10 	movl   $0x107c76,0xc(%esp)
  10359d:	00 
  10359e:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1035a5:	00 
  1035a6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  1035ad:	00 
  1035ae:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1035b5:	e8 77 ce ff ff       	call   100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1035ba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1035c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035c4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1035c9:	89 c2                	mov    %eax,%edx
  1035cb:	8b 45 10             	mov    0x10(%ebp),%eax
  1035ce:	01 c2                	add    %eax,%edx
  1035d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035d3:	01 d0                	add    %edx,%eax
  1035d5:	48                   	dec    %eax
  1035d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1035e1:	f7 75 f0             	divl   -0x10(%ebp)
  1035e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035e7:	29 d0                	sub    %edx,%eax
  1035e9:	c1 e8 0c             	shr    $0xc,%eax
  1035ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1035ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1035fd:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103600:	8b 45 14             	mov    0x14(%ebp),%eax
  103603:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103609:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10360e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103611:	eb 68                	jmp    10367b <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103613:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10361a:	00 
  10361b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103622:	8b 45 08             	mov    0x8(%ebp),%eax
  103625:	89 04 24             	mov    %eax,(%esp)
  103628:	e8 8a 01 00 00       	call   1037b7 <get_pte>
  10362d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103630:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103634:	75 24                	jne    10365a <boot_map_segment+0xdd>
  103636:	c7 44 24 0c a2 7c 10 	movl   $0x107ca2,0xc(%esp)
  10363d:	00 
  10363e:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103645:	00 
  103646:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10364d:	00 
  10364e:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103655:	e8 d7 cd ff ff       	call   100431 <__panic>
        *ptep = pa | PTE_P | perm;
  10365a:	8b 45 14             	mov    0x14(%ebp),%eax
  10365d:	0b 45 18             	or     0x18(%ebp),%eax
  103660:	83 c8 01             	or     $0x1,%eax
  103663:	89 c2                	mov    %eax,%edx
  103665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103668:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10366a:	ff 4d f4             	decl   -0xc(%ebp)
  10366d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103674:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10367b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10367f:	75 92                	jne    103613 <boot_map_segment+0x96>
    }
}
  103681:	90                   	nop
  103682:	90                   	nop
  103683:	c9                   	leave  
  103684:	c3                   	ret    

00103685 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103685:	f3 0f 1e fb          	endbr32 
  103689:	55                   	push   %ebp
  10368a:	89 e5                	mov    %esp,%ebp
  10368c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10368f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103696:	e8 74 fa ff ff       	call   10310f <alloc_pages>
  10369b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10369e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036a2:	75 1c                	jne    1036c0 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  1036a4:	c7 44 24 08 af 7c 10 	movl   $0x107caf,0x8(%esp)
  1036ab:	00 
  1036ac:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1036b3:	00 
  1036b4:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1036bb:	e8 71 cd ff ff       	call   100431 <__panic>
    }
    return page2kva(p);
  1036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c3:	89 04 24             	mov    %eax,(%esp)
  1036c6:	e8 84 f7 ff ff       	call   102e4f <page2kva>
}
  1036cb:	c9                   	leave  
  1036cc:	c3                   	ret    

001036cd <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1036cd:	f3 0f 1e fb          	endbr32 
  1036d1:	55                   	push   %ebp
  1036d2:	89 e5                	mov    %esp,%ebp
  1036d4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1036d7:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  1036dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036df:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1036e6:	77 23                	ja     10370b <pmm_init+0x3e>
  1036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ef:	c7 44 24 08 44 7c 10 	movl   $0x107c44,0x8(%esp)
  1036f6:	00 
  1036f7:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1036fe:	00 
  1036ff:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103706:	e8 26 cd ff ff       	call   100431 <__panic>
  10370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10370e:	05 00 00 00 40       	add    $0x40000000,%eax
  103713:	a3 74 ff 11 00       	mov    %eax,0x11ff74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103718:	e8 96 f9 ff ff       	call   1030b3 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10371d:	e8 8f fa ff ff       	call   1031b1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103722:	e8 f3 03 00 00       	call   103b1a <check_alloc_page>

    check_pgdir();
  103727:	e8 11 04 00 00       	call   103b3d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10372c:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103734:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10373b:	77 23                	ja     103760 <pmm_init+0x93>
  10373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103740:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103744:	c7 44 24 08 44 7c 10 	movl   $0x107c44,0x8(%esp)
  10374b:	00 
  10374c:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  103753:	00 
  103754:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10375b:	e8 d1 cc ff ff       	call   100431 <__panic>
  103760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103763:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103769:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  10376e:	05 ac 0f 00 00       	add    $0xfac,%eax
  103773:	83 ca 03             	or     $0x3,%edx
  103776:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103778:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  10377d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103784:	00 
  103785:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10378c:	00 
  10378d:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103794:	38 
  103795:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10379c:	c0 
  10379d:	89 04 24             	mov    %eax,(%esp)
  1037a0:	e8 d8 fd ff ff       	call   10357d <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1037a5:	e8 1b f8 ff ff       	call   102fc5 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1037aa:	e8 2e 0a 00 00       	call   1041dd <check_boot_pgdir>

    print_pgdir();
  1037af:	e8 b3 0e 00 00       	call   104667 <print_pgdir>

}
  1037b4:	90                   	nop
  1037b5:	c9                   	leave  
  1037b6:	c3                   	ret    

001037b7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1037b7:	f3 0f 1e fb          	endbr32 
  1037bb:	55                   	push   %ebp
  1037bc:	89 e5                	mov    %esp,%ebp
  1037be:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */

    pde_t *pdep = &pgdir[PDX(la)];//获取页表
  1037c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037c4:	c1 e8 16             	shr    $0x16,%eax
  1037c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d1:	01 d0                	add    %edx,%eax
  1037d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {//如果页表不存在，尝试新建一个页表
  1037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037d9:	8b 00                	mov    (%eax),%eax
  1037db:	83 e0 01             	and    $0x1,%eax
  1037de:	85 c0                	test   %eax,%eax
  1037e0:	0f 85 af 00 00 00    	jne    103895 <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {//如果不需要创建或者分配失败，返回null
  1037e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1037ea:	74 15                	je     103801 <get_pte+0x4a>
  1037ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037f3:	e8 17 f9 ff ff       	call   10310f <alloc_pages>
  1037f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037ff:	75 0a                	jne    10380b <get_pte+0x54>
            return NULL;
  103801:	b8 00 00 00 00       	mov    $0x0,%eax
  103806:	e9 e7 00 00 00       	jmp    1038f2 <get_pte+0x13b>
        }
        set_page_ref(page, 1);//第一次创建，只有一个引用
  10380b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103812:	00 
  103813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103816:	89 04 24             	mov    %eax,(%esp)
  103819:	e8 e5 f6 ff ff       	call   102f03 <set_page_ref>
        uintptr_t pa = page2pa(page);//转换成物理地址
  10381e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103821:	89 04 24             	mov    %eax,(%esp)
  103824:	e8 c1 f5 ff ff       	call   102dea <page2pa>
  103829:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);//将对应物理地址置零
  10382c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10382f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103832:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103835:	c1 e8 0c             	shr    $0xc,%eax
  103838:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10383b:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  103840:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103843:	72 23                	jb     103868 <get_pte+0xb1>
  103845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103848:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10384c:	c7 44 24 08 a0 7b 10 	movl   $0x107ba0,0x8(%esp)
  103853:	00 
  103854:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
  10385b:	00 
  10385c:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103863:	e8 c9 cb ff ff       	call   100431 <__panic>
  103868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10386b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103870:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103877:	00 
  103878:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10387f:	00 
  103880:	89 04 24             	mov    %eax,(%esp)
  103883:	e8 3d 33 00 00       	call   106bc5 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;//设置控制位
  103888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10388b:	83 c8 07             	or     $0x7,%eax
  10388e:	89 c2                	mov    %eax,%edx
  103890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103893:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  103895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103898:	8b 00                	mov    (%eax),%eax
  10389a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10389f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1038a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038a5:	c1 e8 0c             	shr    $0xc,%eax
  1038a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1038ab:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  1038b0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1038b3:	72 23                	jb     1038d8 <get_pte+0x121>
  1038b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038bc:	c7 44 24 08 a0 7b 10 	movl   $0x107ba0,0x8(%esp)
  1038c3:	00 
  1038c4:	c7 44 24 04 6c 01 00 	movl   $0x16c,0x4(%esp)
  1038cb:	00 
  1038cc:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1038d3:	e8 59 cb ff ff       	call   100431 <__panic>
  1038d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038db:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1038e0:	89 c2                	mov    %eax,%edx
  1038e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038e5:	c1 e8 0c             	shr    $0xc,%eax
  1038e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  1038ed:	c1 e0 02             	shl    $0x2,%eax
  1038f0:	01 d0                	add    %edx,%eax
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1038f2:	c9                   	leave  
  1038f3:	c3                   	ret    

001038f4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1038f4:	f3 0f 1e fb          	endbr32 
  1038f8:	55                   	push   %ebp
  1038f9:	89 e5                	mov    %esp,%ebp
  1038fb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1038fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103905:	00 
  103906:	8b 45 0c             	mov    0xc(%ebp),%eax
  103909:	89 44 24 04          	mov    %eax,0x4(%esp)
  10390d:	8b 45 08             	mov    0x8(%ebp),%eax
  103910:	89 04 24             	mov    %eax,(%esp)
  103913:	e8 9f fe ff ff       	call   1037b7 <get_pte>
  103918:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10391b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10391f:	74 08                	je     103929 <get_page+0x35>
        *ptep_store = ptep;
  103921:	8b 45 10             	mov    0x10(%ebp),%eax
  103924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103927:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10392d:	74 1b                	je     10394a <get_page+0x56>
  10392f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103932:	8b 00                	mov    (%eax),%eax
  103934:	83 e0 01             	and    $0x1,%eax
  103937:	85 c0                	test   %eax,%eax
  103939:	74 0f                	je     10394a <get_page+0x56>
        return pte2page(*ptep);
  10393b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10393e:	8b 00                	mov    (%eax),%eax
  103940:	89 04 24             	mov    %eax,(%esp)
  103943:	e8 5b f5 ff ff       	call   102ea3 <pte2page>
  103948:	eb 05                	jmp    10394f <get_page+0x5b>
    }
    return NULL;
  10394a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10394f:	c9                   	leave  
  103950:	c3                   	ret    

00103951 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103951:	55                   	push   %ebp
  103952:	89 e5                	mov    %esp,%ebp
  103954:	83 ec 28             	sub    $0x28,%esp
                                  //(3) decrease page reference
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    } */
    if (*ptep & PTE_P) {
  103957:	8b 45 10             	mov    0x10(%ebp),%eax
  10395a:	8b 00                	mov    (%eax),%eax
  10395c:	83 e0 01             	and    $0x1,%eax
  10395f:	85 c0                	test   %eax,%eax
  103961:	74 4d                	je     1039b0 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  103963:	8b 45 10             	mov    0x10(%ebp),%eax
  103966:	8b 00                	mov    (%eax),%eax
  103968:	89 04 24             	mov    %eax,(%esp)
  10396b:	e8 33 f5 ff ff       	call   102ea3 <pte2page>
  103970:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  103973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103976:	89 04 24             	mov    %eax,(%esp)
  103979:	e8 aa f5 ff ff       	call   102f28 <page_ref_dec>
  10397e:	85 c0                	test   %eax,%eax
  103980:	75 13                	jne    103995 <page_remove_pte+0x44>
            free_page(page);
  103982:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103989:	00 
  10398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10398d:	89 04 24             	mov    %eax,(%esp)
  103990:	e8 b6 f7 ff ff       	call   10314b <free_pages>
        }
        *ptep = 0;
  103995:	8b 45 10             	mov    0x10(%ebp),%eax
  103998:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  10399e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1039a8:	89 04 24             	mov    %eax,(%esp)
  1039ab:	e8 09 01 00 00       	call   103ab9 <tlb_invalidate>
    }
}
  1039b0:	90                   	nop
  1039b1:	c9                   	leave  
  1039b2:	c3                   	ret    

001039b3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1039b3:	f3 0f 1e fb          	endbr32 
  1039b7:	55                   	push   %ebp
  1039b8:	89 e5                	mov    %esp,%ebp
  1039ba:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1039bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039c4:	00 
  1039c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cf:	89 04 24             	mov    %eax,(%esp)
  1039d2:	e8 e0 fd ff ff       	call   1037b7 <get_pte>
  1039d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1039da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039de:	74 19                	je     1039f9 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  1039e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1039e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1039ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f1:	89 04 24             	mov    %eax,(%esp)
  1039f4:	e8 58 ff ff ff       	call   103951 <page_remove_pte>
    }
}
  1039f9:	90                   	nop
  1039fa:	c9                   	leave  
  1039fb:	c3                   	ret    

001039fc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1039fc:	f3 0f 1e fb          	endbr32 
  103a00:	55                   	push   %ebp
  103a01:	89 e5                	mov    %esp,%ebp
  103a03:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103a06:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103a0d:	00 
  103a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  103a11:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a15:	8b 45 08             	mov    0x8(%ebp),%eax
  103a18:	89 04 24             	mov    %eax,(%esp)
  103a1b:	e8 97 fd ff ff       	call   1037b7 <get_pte>
  103a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a27:	75 0a                	jne    103a33 <page_insert+0x37>
        return -E_NO_MEM;
  103a29:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103a2e:	e9 84 00 00 00       	jmp    103ab7 <page_insert+0xbb>
    }
    page_ref_inc(page);
  103a33:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a36:	89 04 24             	mov    %eax,(%esp)
  103a39:	e8 d3 f4 ff ff       	call   102f11 <page_ref_inc>
    if (*ptep & PTE_P) {
  103a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a41:	8b 00                	mov    (%eax),%eax
  103a43:	83 e0 01             	and    $0x1,%eax
  103a46:	85 c0                	test   %eax,%eax
  103a48:	74 3e                	je     103a88 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  103a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a4d:	8b 00                	mov    (%eax),%eax
  103a4f:	89 04 24             	mov    %eax,(%esp)
  103a52:	e8 4c f4 ff ff       	call   102ea3 <pte2page>
  103a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103a60:	75 0d                	jne    103a6f <page_insert+0x73>
            page_ref_dec(page);
  103a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a65:	89 04 24             	mov    %eax,(%esp)
  103a68:	e8 bb f4 ff ff       	call   102f28 <page_ref_dec>
  103a6d:	eb 19                	jmp    103a88 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a72:	89 44 24 08          	mov    %eax,0x8(%esp)
  103a76:	8b 45 10             	mov    0x10(%ebp),%eax
  103a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a80:	89 04 24             	mov    %eax,(%esp)
  103a83:	e8 c9 fe ff ff       	call   103951 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a8b:	89 04 24             	mov    %eax,(%esp)
  103a8e:	e8 57 f3 ff ff       	call   102dea <page2pa>
  103a93:	0b 45 14             	or     0x14(%ebp),%eax
  103a96:	83 c8 01             	or     $0x1,%eax
  103a99:	89 c2                	mov    %eax,%edx
  103a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a9e:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  103aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  103aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aaa:	89 04 24             	mov    %eax,(%esp)
  103aad:	e8 07 00 00 00       	call   103ab9 <tlb_invalidate>
    return 0;
  103ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103ab7:	c9                   	leave  
  103ab8:	c3                   	ret    

00103ab9 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103ab9:	f3 0f 1e fb          	endbr32 
  103abd:	55                   	push   %ebp
  103abe:	89 e5                	mov    %esp,%ebp
  103ac0:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103ac3:	0f 20 d8             	mov    %cr3,%eax
  103ac6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103ac9:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103acc:	8b 45 08             	mov    0x8(%ebp),%eax
  103acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103ad2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103ad9:	77 23                	ja     103afe <tlb_invalidate+0x45>
  103adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ade:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ae2:	c7 44 24 08 44 7c 10 	movl   $0x107c44,0x8(%esp)
  103ae9:	00 
  103aea:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  103af1:	00 
  103af2:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103af9:	e8 33 c9 ff ff       	call   100431 <__panic>
  103afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b01:	05 00 00 00 40       	add    $0x40000000,%eax
  103b06:	39 d0                	cmp    %edx,%eax
  103b08:	75 0d                	jne    103b17 <tlb_invalidate+0x5e>
        invlpg((void *)la);
  103b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b13:	0f 01 38             	invlpg (%eax)
}
  103b16:	90                   	nop
    }
}
  103b17:	90                   	nop
  103b18:	c9                   	leave  
  103b19:	c3                   	ret    

00103b1a <check_alloc_page>:

static void
check_alloc_page(void) {
  103b1a:	f3 0f 1e fb          	endbr32 
  103b1e:	55                   	push   %ebp
  103b1f:	89 e5                	mov    %esp,%ebp
  103b21:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103b24:	a1 70 ff 11 00       	mov    0x11ff70,%eax
  103b29:	8b 40 18             	mov    0x18(%eax),%eax
  103b2c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103b2e:	c7 04 24 c8 7c 10 00 	movl   $0x107cc8,(%esp)
  103b35:	e8 8b c7 ff ff       	call   1002c5 <cprintf>
}
  103b3a:	90                   	nop
  103b3b:	c9                   	leave  
  103b3c:	c3                   	ret    

00103b3d <check_pgdir>:

static void
check_pgdir(void) {
  103b3d:	f3 0f 1e fb          	endbr32 
  103b41:	55                   	push   %ebp
  103b42:	89 e5                	mov    %esp,%ebp
  103b44:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103b47:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  103b4c:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103b51:	76 24                	jbe    103b77 <check_pgdir+0x3a>
  103b53:	c7 44 24 0c e7 7c 10 	movl   $0x107ce7,0xc(%esp)
  103b5a:	00 
  103b5b:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103b62:	00 
  103b63:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103b6a:	00 
  103b6b:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103b72:	e8 ba c8 ff ff       	call   100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103b77:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103b7c:	85 c0                	test   %eax,%eax
  103b7e:	74 0e                	je     103b8e <check_pgdir+0x51>
  103b80:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103b85:	25 ff 0f 00 00       	and    $0xfff,%eax
  103b8a:	85 c0                	test   %eax,%eax
  103b8c:	74 24                	je     103bb2 <check_pgdir+0x75>
  103b8e:	c7 44 24 0c 04 7d 10 	movl   $0x107d04,0xc(%esp)
  103b95:	00 
  103b96:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103b9d:	00 
  103b9e:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  103ba5:	00 
  103ba6:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103bad:	e8 7f c8 ff ff       	call   100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103bb2:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103bb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103bbe:	00 
  103bbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103bc6:	00 
  103bc7:	89 04 24             	mov    %eax,(%esp)
  103bca:	e8 25 fd ff ff       	call   1038f4 <get_page>
  103bcf:	85 c0                	test   %eax,%eax
  103bd1:	74 24                	je     103bf7 <check_pgdir+0xba>
  103bd3:	c7 44 24 0c 3c 7d 10 	movl   $0x107d3c,0xc(%esp)
  103bda:	00 
  103bdb:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103be2:	00 
  103be3:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  103bea:	00 
  103beb:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103bf2:	e8 3a c8 ff ff       	call   100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103bf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103bfe:	e8 0c f5 ff ff       	call   10310f <alloc_pages>
  103c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103c06:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103c0b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103c12:	00 
  103c13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c1a:	00 
  103c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103c1e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c22:	89 04 24             	mov    %eax,(%esp)
  103c25:	e8 d2 fd ff ff       	call   1039fc <page_insert>
  103c2a:	85 c0                	test   %eax,%eax
  103c2c:	74 24                	je     103c52 <check_pgdir+0x115>
  103c2e:	c7 44 24 0c 64 7d 10 	movl   $0x107d64,0xc(%esp)
  103c35:	00 
  103c36:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103c3d:	00 
  103c3e:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  103c45:	00 
  103c46:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103c4d:	e8 df c7 ff ff       	call   100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103c52:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103c57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c5e:	00 
  103c5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c66:	00 
  103c67:	89 04 24             	mov    %eax,(%esp)
  103c6a:	e8 48 fb ff ff       	call   1037b7 <get_pte>
  103c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c76:	75 24                	jne    103c9c <check_pgdir+0x15f>
  103c78:	c7 44 24 0c 90 7d 10 	movl   $0x107d90,0xc(%esp)
  103c7f:	00 
  103c80:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103c87:	00 
  103c88:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103c8f:	00 
  103c90:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103c97:	e8 95 c7 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  103c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c9f:	8b 00                	mov    (%eax),%eax
  103ca1:	89 04 24             	mov    %eax,(%esp)
  103ca4:	e8 fa f1 ff ff       	call   102ea3 <pte2page>
  103ca9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103cac:	74 24                	je     103cd2 <check_pgdir+0x195>
  103cae:	c7 44 24 0c bd 7d 10 	movl   $0x107dbd,0xc(%esp)
  103cb5:	00 
  103cb6:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103cbd:	00 
  103cbe:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103cc5:	00 
  103cc6:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103ccd:	e8 5f c7 ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 1);
  103cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cd5:	89 04 24             	mov    %eax,(%esp)
  103cd8:	e8 1c f2 ff ff       	call   102ef9 <page_ref>
  103cdd:	83 f8 01             	cmp    $0x1,%eax
  103ce0:	74 24                	je     103d06 <check_pgdir+0x1c9>
  103ce2:	c7 44 24 0c d3 7d 10 	movl   $0x107dd3,0xc(%esp)
  103ce9:	00 
  103cea:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103cf1:	00 
  103cf2:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103cf9:	00 
  103cfa:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103d01:	e8 2b c7 ff ff       	call   100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103d06:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103d0b:	8b 00                	mov    (%eax),%eax
  103d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d18:	c1 e8 0c             	shr    $0xc,%eax
  103d1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103d1e:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  103d23:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103d26:	72 23                	jb     103d4b <check_pgdir+0x20e>
  103d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d2f:	c7 44 24 08 a0 7b 10 	movl   $0x107ba0,0x8(%esp)
  103d36:	00 
  103d37:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103d3e:	00 
  103d3f:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103d46:	e8 e6 c6 ff ff       	call   100431 <__panic>
  103d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d4e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103d53:	83 c0 04             	add    $0x4,%eax
  103d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103d59:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103d5e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103d65:	00 
  103d66:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d6d:	00 
  103d6e:	89 04 24             	mov    %eax,(%esp)
  103d71:	e8 41 fa ff ff       	call   1037b7 <get_pte>
  103d76:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103d79:	74 24                	je     103d9f <check_pgdir+0x262>
  103d7b:	c7 44 24 0c e8 7d 10 	movl   $0x107de8,0xc(%esp)
  103d82:	00 
  103d83:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103d8a:	00 
  103d8b:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  103d92:	00 
  103d93:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103d9a:	e8 92 c6 ff ff       	call   100431 <__panic>

    p2 = alloc_page();
  103d9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103da6:	e8 64 f3 ff ff       	call   10310f <alloc_pages>
  103dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103dae:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103db3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103dba:	00 
  103dbb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103dc2:	00 
  103dc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103dc6:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dca:	89 04 24             	mov    %eax,(%esp)
  103dcd:	e8 2a fc ff ff       	call   1039fc <page_insert>
  103dd2:	85 c0                	test   %eax,%eax
  103dd4:	74 24                	je     103dfa <check_pgdir+0x2bd>
  103dd6:	c7 44 24 0c 10 7e 10 	movl   $0x107e10,0xc(%esp)
  103ddd:	00 
  103dde:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103de5:	00 
  103de6:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103ded:	00 
  103dee:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103df5:	e8 37 c6 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103dfa:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103dff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e06:	00 
  103e07:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103e0e:	00 
  103e0f:	89 04 24             	mov    %eax,(%esp)
  103e12:	e8 a0 f9 ff ff       	call   1037b7 <get_pte>
  103e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103e1e:	75 24                	jne    103e44 <check_pgdir+0x307>
  103e20:	c7 44 24 0c 48 7e 10 	movl   $0x107e48,0xc(%esp)
  103e27:	00 
  103e28:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103e2f:	00 
  103e30:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103e37:	00 
  103e38:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103e3f:	e8 ed c5 ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_U);
  103e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e47:	8b 00                	mov    (%eax),%eax
  103e49:	83 e0 04             	and    $0x4,%eax
  103e4c:	85 c0                	test   %eax,%eax
  103e4e:	75 24                	jne    103e74 <check_pgdir+0x337>
  103e50:	c7 44 24 0c 78 7e 10 	movl   $0x107e78,0xc(%esp)
  103e57:	00 
  103e58:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103e5f:	00 
  103e60:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103e67:	00 
  103e68:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103e6f:	e8 bd c5 ff ff       	call   100431 <__panic>
    assert(*ptep & PTE_W);
  103e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e77:	8b 00                	mov    (%eax),%eax
  103e79:	83 e0 02             	and    $0x2,%eax
  103e7c:	85 c0                	test   %eax,%eax
  103e7e:	75 24                	jne    103ea4 <check_pgdir+0x367>
  103e80:	c7 44 24 0c 86 7e 10 	movl   $0x107e86,0xc(%esp)
  103e87:	00 
  103e88:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103e8f:	00 
  103e90:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103e97:	00 
  103e98:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103e9f:	e8 8d c5 ff ff       	call   100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103ea4:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103ea9:	8b 00                	mov    (%eax),%eax
  103eab:	83 e0 04             	and    $0x4,%eax
  103eae:	85 c0                	test   %eax,%eax
  103eb0:	75 24                	jne    103ed6 <check_pgdir+0x399>
  103eb2:	c7 44 24 0c 94 7e 10 	movl   $0x107e94,0xc(%esp)
  103eb9:	00 
  103eba:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103ec1:	00 
  103ec2:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103ec9:	00 
  103eca:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103ed1:	e8 5b c5 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 1);
  103ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ed9:	89 04 24             	mov    %eax,(%esp)
  103edc:	e8 18 f0 ff ff       	call   102ef9 <page_ref>
  103ee1:	83 f8 01             	cmp    $0x1,%eax
  103ee4:	74 24                	je     103f0a <check_pgdir+0x3cd>
  103ee6:	c7 44 24 0c aa 7e 10 	movl   $0x107eaa,0xc(%esp)
  103eed:	00 
  103eee:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103ef5:	00 
  103ef6:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103efd:	00 
  103efe:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103f05:	e8 27 c5 ff ff       	call   100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103f0a:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103f0f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103f16:	00 
  103f17:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103f1e:	00 
  103f1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103f22:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f26:	89 04 24             	mov    %eax,(%esp)
  103f29:	e8 ce fa ff ff       	call   1039fc <page_insert>
  103f2e:	85 c0                	test   %eax,%eax
  103f30:	74 24                	je     103f56 <check_pgdir+0x419>
  103f32:	c7 44 24 0c bc 7e 10 	movl   $0x107ebc,0xc(%esp)
  103f39:	00 
  103f3a:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103f41:	00 
  103f42:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103f49:	00 
  103f4a:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103f51:	e8 db c4 ff ff       	call   100431 <__panic>
    assert(page_ref(p1) == 2);
  103f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f59:	89 04 24             	mov    %eax,(%esp)
  103f5c:	e8 98 ef ff ff       	call   102ef9 <page_ref>
  103f61:	83 f8 02             	cmp    $0x2,%eax
  103f64:	74 24                	je     103f8a <check_pgdir+0x44d>
  103f66:	c7 44 24 0c e8 7e 10 	movl   $0x107ee8,0xc(%esp)
  103f6d:	00 
  103f6e:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103f75:	00 
  103f76:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103f7d:	00 
  103f7e:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103f85:	e8 a7 c4 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  103f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f8d:	89 04 24             	mov    %eax,(%esp)
  103f90:	e8 64 ef ff ff       	call   102ef9 <page_ref>
  103f95:	85 c0                	test   %eax,%eax
  103f97:	74 24                	je     103fbd <check_pgdir+0x480>
  103f99:	c7 44 24 0c fa 7e 10 	movl   $0x107efa,0xc(%esp)
  103fa0:	00 
  103fa1:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103fa8:	00 
  103fa9:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103fb0:	00 
  103fb1:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  103fb8:	e8 74 c4 ff ff       	call   100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103fbd:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  103fc2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103fc9:	00 
  103fca:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103fd1:	00 
  103fd2:	89 04 24             	mov    %eax,(%esp)
  103fd5:	e8 dd f7 ff ff       	call   1037b7 <get_pte>
  103fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103fdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103fe1:	75 24                	jne    104007 <check_pgdir+0x4ca>
  103fe3:	c7 44 24 0c 48 7e 10 	movl   $0x107e48,0xc(%esp)
  103fea:	00 
  103feb:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  103ff2:	00 
  103ff3:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103ffa:	00 
  103ffb:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  104002:	e8 2a c4 ff ff       	call   100431 <__panic>
    assert(pte2page(*ptep) == p1);
  104007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10400a:	8b 00                	mov    (%eax),%eax
  10400c:	89 04 24             	mov    %eax,(%esp)
  10400f:	e8 8f ee ff ff       	call   102ea3 <pte2page>
  104014:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104017:	74 24                	je     10403d <check_pgdir+0x500>
  104019:	c7 44 24 0c bd 7d 10 	movl   $0x107dbd,0xc(%esp)
  104020:	00 
  104021:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  104028:	00 
  104029:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104030:	00 
  104031:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  104038:	e8 f4 c3 ff ff       	call   100431 <__panic>
    assert((*ptep & PTE_U) == 0);
  10403d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104040:	8b 00                	mov    (%eax),%eax
  104042:	83 e0 04             	and    $0x4,%eax
  104045:	85 c0                	test   %eax,%eax
  104047:	74 24                	je     10406d <check_pgdir+0x530>
  104049:	c7 44 24 0c 0c 7f 10 	movl   $0x107f0c,0xc(%esp)
  104050:	00 
  104051:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  104058:	00 
  104059:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104060:	00 
  104061:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  104068:	e8 c4 c3 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, 0x0);
  10406d:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104072:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104079:	00 
  10407a:	89 04 24             	mov    %eax,(%esp)
  10407d:	e8 31 f9 ff ff       	call   1039b3 <page_remove>
    assert(page_ref(p1) == 1);
  104082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104085:	89 04 24             	mov    %eax,(%esp)
  104088:	e8 6c ee ff ff       	call   102ef9 <page_ref>
  10408d:	83 f8 01             	cmp    $0x1,%eax
  104090:	74 24                	je     1040b6 <check_pgdir+0x579>
  104092:	c7 44 24 0c d3 7d 10 	movl   $0x107dd3,0xc(%esp)
  104099:	00 
  10409a:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1040a1:	00 
  1040a2:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  1040a9:	00 
  1040aa:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1040b1:	e8 7b c3 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  1040b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040b9:	89 04 24             	mov    %eax,(%esp)
  1040bc:	e8 38 ee ff ff       	call   102ef9 <page_ref>
  1040c1:	85 c0                	test   %eax,%eax
  1040c3:	74 24                	je     1040e9 <check_pgdir+0x5ac>
  1040c5:	c7 44 24 0c fa 7e 10 	movl   $0x107efa,0xc(%esp)
  1040cc:	00 
  1040cd:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1040d4:	00 
  1040d5:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  1040dc:	00 
  1040dd:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1040e4:	e8 48 c3 ff ff       	call   100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1040e9:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  1040ee:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1040f5:	00 
  1040f6:	89 04 24             	mov    %eax,(%esp)
  1040f9:	e8 b5 f8 ff ff       	call   1039b3 <page_remove>
    assert(page_ref(p1) == 0);
  1040fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104101:	89 04 24             	mov    %eax,(%esp)
  104104:	e8 f0 ed ff ff       	call   102ef9 <page_ref>
  104109:	85 c0                	test   %eax,%eax
  10410b:	74 24                	je     104131 <check_pgdir+0x5f4>
  10410d:	c7 44 24 0c 21 7f 10 	movl   $0x107f21,0xc(%esp)
  104114:	00 
  104115:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10411c:	00 
  10411d:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104124:	00 
  104125:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10412c:	e8 00 c3 ff ff       	call   100431 <__panic>
    assert(page_ref(p2) == 0);
  104131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104134:	89 04 24             	mov    %eax,(%esp)
  104137:	e8 bd ed ff ff       	call   102ef9 <page_ref>
  10413c:	85 c0                	test   %eax,%eax
  10413e:	74 24                	je     104164 <check_pgdir+0x627>
  104140:	c7 44 24 0c fa 7e 10 	movl   $0x107efa,0xc(%esp)
  104147:	00 
  104148:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10414f:	00 
  104150:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104157:	00 
  104158:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10415f:	e8 cd c2 ff ff       	call   100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104164:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104169:	8b 00                	mov    (%eax),%eax
  10416b:	89 04 24             	mov    %eax,(%esp)
  10416e:	e8 6e ed ff ff       	call   102ee1 <pde2page>
  104173:	89 04 24             	mov    %eax,(%esp)
  104176:	e8 7e ed ff ff       	call   102ef9 <page_ref>
  10417b:	83 f8 01             	cmp    $0x1,%eax
  10417e:	74 24                	je     1041a4 <check_pgdir+0x667>
  104180:	c7 44 24 0c 34 7f 10 	movl   $0x107f34,0xc(%esp)
  104187:	00 
  104188:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10418f:	00 
  104190:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104197:	00 
  104198:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10419f:	e8 8d c2 ff ff       	call   100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  1041a4:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  1041a9:	8b 00                	mov    (%eax),%eax
  1041ab:	89 04 24             	mov    %eax,(%esp)
  1041ae:	e8 2e ed ff ff       	call   102ee1 <pde2page>
  1041b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1041ba:	00 
  1041bb:	89 04 24             	mov    %eax,(%esp)
  1041be:	e8 88 ef ff ff       	call   10314b <free_pages>
    boot_pgdir[0] = 0;
  1041c3:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  1041c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1041ce:	c7 04 24 5b 7f 10 00 	movl   $0x107f5b,(%esp)
  1041d5:	e8 eb c0 ff ff       	call   1002c5 <cprintf>
}
  1041da:	90                   	nop
  1041db:	c9                   	leave  
  1041dc:	c3                   	ret    

001041dd <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1041dd:	f3 0f 1e fb          	endbr32 
  1041e1:	55                   	push   %ebp
  1041e2:	89 e5                	mov    %esp,%ebp
  1041e4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1041e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1041ee:	e9 ca 00 00 00       	jmp    1042bd <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1041f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041fc:	c1 e8 0c             	shr    $0xc,%eax
  1041ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104202:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  104207:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10420a:	72 23                	jb     10422f <check_boot_pgdir+0x52>
  10420c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10420f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104213:	c7 44 24 08 a0 7b 10 	movl   $0x107ba0,0x8(%esp)
  10421a:	00 
  10421b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104222:	00 
  104223:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10422a:	e8 02 c2 ff ff       	call   100431 <__panic>
  10422f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104232:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104237:	89 c2                	mov    %eax,%edx
  104239:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  10423e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104245:	00 
  104246:	89 54 24 04          	mov    %edx,0x4(%esp)
  10424a:	89 04 24             	mov    %eax,(%esp)
  10424d:	e8 65 f5 ff ff       	call   1037b7 <get_pte>
  104252:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104255:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104259:	75 24                	jne    10427f <check_boot_pgdir+0xa2>
  10425b:	c7 44 24 0c 78 7f 10 	movl   $0x107f78,0xc(%esp)
  104262:	00 
  104263:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10426a:	00 
  10426b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104272:	00 
  104273:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10427a:	e8 b2 c1 ff ff       	call   100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10427f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104282:	8b 00                	mov    (%eax),%eax
  104284:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104289:	89 c2                	mov    %eax,%edx
  10428b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10428e:	39 c2                	cmp    %eax,%edx
  104290:	74 24                	je     1042b6 <check_boot_pgdir+0xd9>
  104292:	c7 44 24 0c b5 7f 10 	movl   $0x107fb5,0xc(%esp)
  104299:	00 
  10429a:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1042a1:	00 
  1042a2:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  1042a9:	00 
  1042aa:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1042b1:	e8 7b c1 ff ff       	call   100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1042b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1042bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1042c0:	a1 80 fe 11 00       	mov    0x11fe80,%eax
  1042c5:	39 c2                	cmp    %eax,%edx
  1042c7:	0f 82 26 ff ff ff    	jb     1041f3 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1042cd:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  1042d2:	05 ac 0f 00 00       	add    $0xfac,%eax
  1042d7:	8b 00                	mov    (%eax),%eax
  1042d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042de:	89 c2                	mov    %eax,%edx
  1042e0:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  1042e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042e8:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1042ef:	77 23                	ja     104314 <check_boot_pgdir+0x137>
  1042f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1042f8:	c7 44 24 08 44 7c 10 	movl   $0x107c44,0x8(%esp)
  1042ff:	00 
  104300:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104307:	00 
  104308:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10430f:	e8 1d c1 ff ff       	call   100431 <__panic>
  104314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104317:	05 00 00 00 40       	add    $0x40000000,%eax
  10431c:	39 d0                	cmp    %edx,%eax
  10431e:	74 24                	je     104344 <check_boot_pgdir+0x167>
  104320:	c7 44 24 0c cc 7f 10 	movl   $0x107fcc,0xc(%esp)
  104327:	00 
  104328:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10432f:	00 
  104330:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104337:	00 
  104338:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10433f:	e8 ed c0 ff ff       	call   100431 <__panic>

    assert(boot_pgdir[0] == 0);
  104344:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104349:	8b 00                	mov    (%eax),%eax
  10434b:	85 c0                	test   %eax,%eax
  10434d:	74 24                	je     104373 <check_boot_pgdir+0x196>
  10434f:	c7 44 24 0c 00 80 10 	movl   $0x108000,0xc(%esp)
  104356:	00 
  104357:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10435e:	00 
  10435f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104366:	00 
  104367:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10436e:	e8 be c0 ff ff       	call   100431 <__panic>

    struct Page *p;
    p = alloc_page();
  104373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10437a:	e8 90 ed ff ff       	call   10310f <alloc_pages>
  10437f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104382:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104387:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10438e:	00 
  10438f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104396:	00 
  104397:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10439a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10439e:	89 04 24             	mov    %eax,(%esp)
  1043a1:	e8 56 f6 ff ff       	call   1039fc <page_insert>
  1043a6:	85 c0                	test   %eax,%eax
  1043a8:	74 24                	je     1043ce <check_boot_pgdir+0x1f1>
  1043aa:	c7 44 24 0c 14 80 10 	movl   $0x108014,0xc(%esp)
  1043b1:	00 
  1043b2:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1043b9:	00 
  1043ba:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  1043c1:	00 
  1043c2:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1043c9:	e8 63 c0 ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 1);
  1043ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043d1:	89 04 24             	mov    %eax,(%esp)
  1043d4:	e8 20 eb ff ff       	call   102ef9 <page_ref>
  1043d9:	83 f8 01             	cmp    $0x1,%eax
  1043dc:	74 24                	je     104402 <check_boot_pgdir+0x225>
  1043de:	c7 44 24 0c 42 80 10 	movl   $0x108042,0xc(%esp)
  1043e5:	00 
  1043e6:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1043ed:	00 
  1043ee:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  1043f5:	00 
  1043f6:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1043fd:	e8 2f c0 ff ff       	call   100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104402:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104407:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10440e:	00 
  10440f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104416:	00 
  104417:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10441a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10441e:	89 04 24             	mov    %eax,(%esp)
  104421:	e8 d6 f5 ff ff       	call   1039fc <page_insert>
  104426:	85 c0                	test   %eax,%eax
  104428:	74 24                	je     10444e <check_boot_pgdir+0x271>
  10442a:	c7 44 24 0c 54 80 10 	movl   $0x108054,0xc(%esp)
  104431:	00 
  104432:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  104439:	00 
  10443a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104441:	00 
  104442:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  104449:	e8 e3 bf ff ff       	call   100431 <__panic>
    assert(page_ref(p) == 2);
  10444e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104451:	89 04 24             	mov    %eax,(%esp)
  104454:	e8 a0 ea ff ff       	call   102ef9 <page_ref>
  104459:	83 f8 02             	cmp    $0x2,%eax
  10445c:	74 24                	je     104482 <check_boot_pgdir+0x2a5>
  10445e:	c7 44 24 0c 8b 80 10 	movl   $0x10808b,0xc(%esp)
  104465:	00 
  104466:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10446d:	00 
  10446e:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104475:	00 
  104476:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10447d:	e8 af bf ff ff       	call   100431 <__panic>

    const char *str = "ucore: Hello world!!";
  104482:	c7 45 e8 9c 80 10 00 	movl   $0x10809c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10448c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104490:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104497:	e8 45 24 00 00       	call   1068e1 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10449c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1044a3:	00 
  1044a4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1044ab:	e8 af 24 00 00       	call   10695f <strcmp>
  1044b0:	85 c0                	test   %eax,%eax
  1044b2:	74 24                	je     1044d8 <check_boot_pgdir+0x2fb>
  1044b4:	c7 44 24 0c b4 80 10 	movl   $0x1080b4,0xc(%esp)
  1044bb:	00 
  1044bc:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  1044c3:	00 
  1044c4:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  1044cb:	00 
  1044cc:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  1044d3:	e8 59 bf ff ff       	call   100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1044d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044db:	89 04 24             	mov    %eax,(%esp)
  1044de:	e8 6c e9 ff ff       	call   102e4f <page2kva>
  1044e3:	05 00 01 00 00       	add    $0x100,%eax
  1044e8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1044eb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1044f2:	e8 8c 23 00 00       	call   106883 <strlen>
  1044f7:	85 c0                	test   %eax,%eax
  1044f9:	74 24                	je     10451f <check_boot_pgdir+0x342>
  1044fb:	c7 44 24 0c ec 80 10 	movl   $0x1080ec,0xc(%esp)
  104502:	00 
  104503:	c7 44 24 08 8d 7c 10 	movl   $0x107c8d,0x8(%esp)
  10450a:	00 
  10450b:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104512:	00 
  104513:	c7 04 24 68 7c 10 00 	movl   $0x107c68,(%esp)
  10451a:	e8 12 bf ff ff       	call   100431 <__panic>

    free_page(p);
  10451f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104526:	00 
  104527:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10452a:	89 04 24             	mov    %eax,(%esp)
  10452d:	e8 19 ec ff ff       	call   10314b <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104532:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104537:	8b 00                	mov    (%eax),%eax
  104539:	89 04 24             	mov    %eax,(%esp)
  10453c:	e8 a0 e9 ff ff       	call   102ee1 <pde2page>
  104541:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104548:	00 
  104549:	89 04 24             	mov    %eax,(%esp)
  10454c:	e8 fa eb ff ff       	call   10314b <free_pages>
    boot_pgdir[0] = 0;
  104551:	a1 e0 c9 11 00       	mov    0x11c9e0,%eax
  104556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10455c:	c7 04 24 10 81 10 00 	movl   $0x108110,(%esp)
  104563:	e8 5d bd ff ff       	call   1002c5 <cprintf>
}
  104568:	90                   	nop
  104569:	c9                   	leave  
  10456a:	c3                   	ret    

0010456b <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10456b:	f3 0f 1e fb          	endbr32 
  10456f:	55                   	push   %ebp
  104570:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104572:	8b 45 08             	mov    0x8(%ebp),%eax
  104575:	83 e0 04             	and    $0x4,%eax
  104578:	85 c0                	test   %eax,%eax
  10457a:	74 04                	je     104580 <perm2str+0x15>
  10457c:	b0 75                	mov    $0x75,%al
  10457e:	eb 02                	jmp    104582 <perm2str+0x17>
  104580:	b0 2d                	mov    $0x2d,%al
  104582:	a2 08 ff 11 00       	mov    %al,0x11ff08
    str[1] = 'r';
  104587:	c6 05 09 ff 11 00 72 	movb   $0x72,0x11ff09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10458e:	8b 45 08             	mov    0x8(%ebp),%eax
  104591:	83 e0 02             	and    $0x2,%eax
  104594:	85 c0                	test   %eax,%eax
  104596:	74 04                	je     10459c <perm2str+0x31>
  104598:	b0 77                	mov    $0x77,%al
  10459a:	eb 02                	jmp    10459e <perm2str+0x33>
  10459c:	b0 2d                	mov    $0x2d,%al
  10459e:	a2 0a ff 11 00       	mov    %al,0x11ff0a
    str[3] = '\0';
  1045a3:	c6 05 0b ff 11 00 00 	movb   $0x0,0x11ff0b
    return str;
  1045aa:	b8 08 ff 11 00       	mov    $0x11ff08,%eax
}
  1045af:	5d                   	pop    %ebp
  1045b0:	c3                   	ret    

001045b1 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1045b1:	f3 0f 1e fb          	endbr32 
  1045b5:	55                   	push   %ebp
  1045b6:	89 e5                	mov    %esp,%ebp
  1045b8:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1045bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045c1:	72 0d                	jb     1045d0 <get_pgtable_items+0x1f>
        return 0;
  1045c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1045c8:	e9 98 00 00 00       	jmp    104665 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1045cd:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1045d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1045d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045d6:	73 18                	jae    1045f0 <get_pgtable_items+0x3f>
  1045d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1045db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1045e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1045e5:	01 d0                	add    %edx,%eax
  1045e7:	8b 00                	mov    (%eax),%eax
  1045e9:	83 e0 01             	and    $0x1,%eax
  1045ec:	85 c0                	test   %eax,%eax
  1045ee:	74 dd                	je     1045cd <get_pgtable_items+0x1c>
    }
    if (start < right) {
  1045f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1045f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045f6:	73 68                	jae    104660 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1045f8:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1045fc:	74 08                	je     104606 <get_pgtable_items+0x55>
            *left_store = start;
  1045fe:	8b 45 18             	mov    0x18(%ebp),%eax
  104601:	8b 55 10             	mov    0x10(%ebp),%edx
  104604:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104606:	8b 45 10             	mov    0x10(%ebp),%eax
  104609:	8d 50 01             	lea    0x1(%eax),%edx
  10460c:	89 55 10             	mov    %edx,0x10(%ebp)
  10460f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104616:	8b 45 14             	mov    0x14(%ebp),%eax
  104619:	01 d0                	add    %edx,%eax
  10461b:	8b 00                	mov    (%eax),%eax
  10461d:	83 e0 07             	and    $0x7,%eax
  104620:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104623:	eb 03                	jmp    104628 <get_pgtable_items+0x77>
            start ++;
  104625:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104628:	8b 45 10             	mov    0x10(%ebp),%eax
  10462b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10462e:	73 1d                	jae    10464d <get_pgtable_items+0x9c>
  104630:	8b 45 10             	mov    0x10(%ebp),%eax
  104633:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10463a:	8b 45 14             	mov    0x14(%ebp),%eax
  10463d:	01 d0                	add    %edx,%eax
  10463f:	8b 00                	mov    (%eax),%eax
  104641:	83 e0 07             	and    $0x7,%eax
  104644:	89 c2                	mov    %eax,%edx
  104646:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104649:	39 c2                	cmp    %eax,%edx
  10464b:	74 d8                	je     104625 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  10464d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104651:	74 08                	je     10465b <get_pgtable_items+0xaa>
            *right_store = start;
  104653:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104656:	8b 55 10             	mov    0x10(%ebp),%edx
  104659:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10465b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10465e:	eb 05                	jmp    104665 <get_pgtable_items+0xb4>
    }
    return 0;
  104660:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104665:	c9                   	leave  
  104666:	c3                   	ret    

00104667 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104667:	f3 0f 1e fb          	endbr32 
  10466b:	55                   	push   %ebp
  10466c:	89 e5                	mov    %esp,%ebp
  10466e:	57                   	push   %edi
  10466f:	56                   	push   %esi
  104670:	53                   	push   %ebx
  104671:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104674:	c7 04 24 30 81 10 00 	movl   $0x108130,(%esp)
  10467b:	e8 45 bc ff ff       	call   1002c5 <cprintf>
    size_t left, right = 0, perm;
  104680:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104687:	e9 fa 00 00 00       	jmp    104786 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10468c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10468f:	89 04 24             	mov    %eax,(%esp)
  104692:	e8 d4 fe ff ff       	call   10456b <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104697:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10469a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10469d:	29 d1                	sub    %edx,%ecx
  10469f:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1046a1:	89 d6                	mov    %edx,%esi
  1046a3:	c1 e6 16             	shl    $0x16,%esi
  1046a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1046a9:	89 d3                	mov    %edx,%ebx
  1046ab:	c1 e3 16             	shl    $0x16,%ebx
  1046ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1046b1:	89 d1                	mov    %edx,%ecx
  1046b3:	c1 e1 16             	shl    $0x16,%ecx
  1046b6:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1046b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1046bc:	29 d7                	sub    %edx,%edi
  1046be:	89 fa                	mov    %edi,%edx
  1046c0:	89 44 24 14          	mov    %eax,0x14(%esp)
  1046c4:	89 74 24 10          	mov    %esi,0x10(%esp)
  1046c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1046cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1046d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046d4:	c7 04 24 61 81 10 00 	movl   $0x108161,(%esp)
  1046db:	e8 e5 bb ff ff       	call   1002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1046e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046e3:	c1 e0 0a             	shl    $0xa,%eax
  1046e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1046e9:	eb 54                	jmp    10473f <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1046eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046ee:	89 04 24             	mov    %eax,(%esp)
  1046f1:	e8 75 fe ff ff       	call   10456b <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1046f6:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1046f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1046fc:	29 d1                	sub    %edx,%ecx
  1046fe:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104700:	89 d6                	mov    %edx,%esi
  104702:	c1 e6 0c             	shl    $0xc,%esi
  104705:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104708:	89 d3                	mov    %edx,%ebx
  10470a:	c1 e3 0c             	shl    $0xc,%ebx
  10470d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104710:	89 d1                	mov    %edx,%ecx
  104712:	c1 e1 0c             	shl    $0xc,%ecx
  104715:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104718:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10471b:	29 d7                	sub    %edx,%edi
  10471d:	89 fa                	mov    %edi,%edx
  10471f:	89 44 24 14          	mov    %eax,0x14(%esp)
  104723:	89 74 24 10          	mov    %esi,0x10(%esp)
  104727:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10472b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10472f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104733:	c7 04 24 80 81 10 00 	movl   $0x108180,(%esp)
  10473a:	e8 86 bb ff ff       	call   1002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10473f:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104747:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10474a:	89 d3                	mov    %edx,%ebx
  10474c:	c1 e3 0a             	shl    $0xa,%ebx
  10474f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104752:	89 d1                	mov    %edx,%ecx
  104754:	c1 e1 0a             	shl    $0xa,%ecx
  104757:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10475a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10475e:	8d 55 d8             	lea    -0x28(%ebp),%edx
  104761:	89 54 24 10          	mov    %edx,0x10(%esp)
  104765:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104769:	89 44 24 08          	mov    %eax,0x8(%esp)
  10476d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104771:	89 0c 24             	mov    %ecx,(%esp)
  104774:	e8 38 fe ff ff       	call   1045b1 <get_pgtable_items>
  104779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10477c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104780:	0f 85 65 ff ff ff    	jne    1046eb <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104786:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10478b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10478e:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104791:	89 54 24 14          	mov    %edx,0x14(%esp)
  104795:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104798:	89 54 24 10          	mov    %edx,0x10(%esp)
  10479c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1047a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047a4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1047ab:	00 
  1047ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1047b3:	e8 f9 fd ff ff       	call   1045b1 <get_pgtable_items>
  1047b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1047bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1047bf:	0f 85 c7 fe ff ff    	jne    10468c <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1047c5:	c7 04 24 a4 81 10 00 	movl   $0x1081a4,(%esp)
  1047cc:	e8 f4 ba ff ff       	call   1002c5 <cprintf>
}
  1047d1:	90                   	nop
  1047d2:	83 c4 4c             	add    $0x4c,%esp
  1047d5:	5b                   	pop    %ebx
  1047d6:	5e                   	pop    %esi
  1047d7:	5f                   	pop    %edi
  1047d8:	5d                   	pop    %ebp
  1047d9:	c3                   	ret    

001047da <page2ppn>:
page2ppn(struct Page *page) {
  1047da:	55                   	push   %ebp
  1047db:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1047dd:	a1 78 ff 11 00       	mov    0x11ff78,%eax
  1047e2:	8b 55 08             	mov    0x8(%ebp),%edx
  1047e5:	29 c2                	sub    %eax,%edx
  1047e7:	89 d0                	mov    %edx,%eax
  1047e9:	c1 f8 02             	sar    $0x2,%eax
  1047ec:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1047f2:	5d                   	pop    %ebp
  1047f3:	c3                   	ret    

001047f4 <page2pa>:
page2pa(struct Page *page) {
  1047f4:	55                   	push   %ebp
  1047f5:	89 e5                	mov    %esp,%ebp
  1047f7:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1047fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1047fd:	89 04 24             	mov    %eax,(%esp)
  104800:	e8 d5 ff ff ff       	call   1047da <page2ppn>
  104805:	c1 e0 0c             	shl    $0xc,%eax
}
  104808:	c9                   	leave  
  104809:	c3                   	ret    

0010480a <page_ref>:
page_ref(struct Page *page) {
  10480a:	55                   	push   %ebp
  10480b:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10480d:	8b 45 08             	mov    0x8(%ebp),%eax
  104810:	8b 00                	mov    (%eax),%eax
}
  104812:	5d                   	pop    %ebp
  104813:	c3                   	ret    

00104814 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104814:	55                   	push   %ebp
  104815:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104817:	8b 45 08             	mov    0x8(%ebp),%eax
  10481a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10481d:	89 10                	mov    %edx,(%eax)
}
  10481f:	90                   	nop
  104820:	5d                   	pop    %ebp
  104821:	c3                   	ret    

00104822 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104822:	f3 0f 1e fb          	endbr32 
  104826:	55                   	push   %ebp
  104827:	89 e5                	mov    %esp,%ebp
  104829:	83 ec 10             	sub    $0x10,%esp
  10482c:	c7 45 fc 7c ff 11 00 	movl   $0x11ff7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104833:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104836:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104839:	89 50 04             	mov    %edx,0x4(%eax)
  10483c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10483f:	8b 50 04             	mov    0x4(%eax),%edx
  104842:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104845:	89 10                	mov    %edx,(%eax)
}
  104847:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  104848:	c7 05 84 ff 11 00 00 	movl   $0x0,0x11ff84
  10484f:	00 00 00 
}
  104852:	90                   	nop
  104853:	c9                   	leave  
  104854:	c3                   	ret    

00104855 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104855:	f3 0f 1e fb          	endbr32 
  104859:	55                   	push   %ebp
  10485a:	89 e5                	mov    %esp,%ebp
  10485c:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10485f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104863:	75 24                	jne    104889 <default_init_memmap+0x34>
  104865:	c7 44 24 0c d8 81 10 	movl   $0x1081d8,0xc(%esp)
  10486c:	00 
  10486d:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104874:	00 
  104875:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  10487c:	00 
  10487d:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104884:	e8 a8 bb ff ff       	call   100431 <__panic>
    struct Page *p = base;
  104889:	8b 45 08             	mov    0x8(%ebp),%eax
  10488c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10488f:	eb 7d                	jmp    10490e <default_init_memmap+0xb9>
        assert(PageReserved(p));
  104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104894:	83 c0 04             	add    $0x4,%eax
  104897:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10489e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1048a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1048a7:	0f a3 10             	bt     %edx,(%eax)
  1048aa:	19 c0                	sbb    %eax,%eax
  1048ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1048af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1048b3:	0f 95 c0             	setne  %al
  1048b6:	0f b6 c0             	movzbl %al,%eax
  1048b9:	85 c0                	test   %eax,%eax
  1048bb:	75 24                	jne    1048e1 <default_init_memmap+0x8c>
  1048bd:	c7 44 24 0c 09 82 10 	movl   $0x108209,0xc(%esp)
  1048c4:	00 
  1048c5:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1048cc:	00 
  1048cd:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1048d4:	00 
  1048d5:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1048dc:	e8 50 bb ff ff       	call   100431 <__panic>
        p->flags = p->property = 0;
  1048e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1048eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ee:	8b 50 08             	mov    0x8(%eax),%edx
  1048f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048f4:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1048f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048fe:	00 
  1048ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104902:	89 04 24             	mov    %eax,(%esp)
  104905:	e8 0a ff ff ff       	call   104814 <set_page_ref>
    for (; p != base + n; p ++) {
  10490a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10490e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104911:	89 d0                	mov    %edx,%eax
  104913:	c1 e0 02             	shl    $0x2,%eax
  104916:	01 d0                	add    %edx,%eax
  104918:	c1 e0 02             	shl    $0x2,%eax
  10491b:	89 c2                	mov    %eax,%edx
  10491d:	8b 45 08             	mov    0x8(%ebp),%eax
  104920:	01 d0                	add    %edx,%eax
  104922:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104925:	0f 85 66 ff ff ff    	jne    104891 <default_init_memmap+0x3c>
    }
    base->property = n;
  10492b:	8b 45 08             	mov    0x8(%ebp),%eax
  10492e:	8b 55 0c             	mov    0xc(%ebp),%edx
  104931:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104934:	8b 45 08             	mov    0x8(%ebp),%eax
  104937:	83 c0 04             	add    $0x4,%eax
  10493a:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104941:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104944:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104947:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10494a:	0f ab 10             	bts    %edx,(%eax)
}
  10494d:	90                   	nop
    nr_free += n;
  10494e:	8b 15 84 ff 11 00    	mov    0x11ff84,%edx
  104954:	8b 45 0c             	mov    0xc(%ebp),%eax
  104957:	01 d0                	add    %edx,%eax
  104959:	a3 84 ff 11 00       	mov    %eax,0x11ff84
    list_add(&free_list, &(base->page_link));
  10495e:	8b 45 08             	mov    0x8(%ebp),%eax
  104961:	83 c0 0c             	add    $0xc,%eax
  104964:	c7 45 e4 7c ff 11 00 	movl   $0x11ff7c,-0x1c(%ebp)
  10496b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10496e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104971:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104974:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104977:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10497a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10497d:	8b 40 04             	mov    0x4(%eax),%eax
  104980:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104983:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104986:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104989:	89 55 d0             	mov    %edx,-0x30(%ebp)
  10498c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10498f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104992:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104995:	89 10                	mov    %edx,(%eax)
  104997:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10499a:	8b 10                	mov    (%eax),%edx
  10499c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10499f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1049a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1049a5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1049a8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1049ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1049ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1049b1:	89 10                	mov    %edx,(%eax)
}
  1049b3:	90                   	nop
}
  1049b4:	90                   	nop
}
  1049b5:	90                   	nop
}
  1049b6:	90                   	nop
  1049b7:	c9                   	leave  
  1049b8:	c3                   	ret    

001049b9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1049b9:	f3 0f 1e fb          	endbr32 
  1049bd:	55                   	push   %ebp
  1049be:	89 e5                	mov    %esp,%ebp
  1049c0:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1049c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1049c7:	75 24                	jne    1049ed <default_alloc_pages+0x34>
  1049c9:	c7 44 24 0c d8 81 10 	movl   $0x1081d8,0xc(%esp)
  1049d0:	00 
  1049d1:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1049d8:	00 
  1049d9:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1049e0:	00 
  1049e1:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1049e8:	e8 44 ba ff ff       	call   100431 <__panic>
    if (n > nr_free) {
  1049ed:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  1049f2:	39 45 08             	cmp    %eax,0x8(%ebp)
  1049f5:	76 0a                	jbe    104a01 <default_alloc_pages+0x48>
        return NULL;
  1049f7:	b8 00 00 00 00       	mov    $0x0,%eax
  1049fc:	e9 4e 01 00 00       	jmp    104b4f <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
  104a01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104a08:	c7 45 f0 7c ff 11 00 	movl   $0x11ff7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104a0f:	eb 1c                	jmp    104a2d <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  104a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a14:	83 e8 0c             	sub    $0xc,%eax
  104a17:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  104a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a1d:	8b 40 08             	mov    0x8(%eax),%eax
  104a20:	39 45 08             	cmp    %eax,0x8(%ebp)
  104a23:	77 08                	ja     104a2d <default_alloc_pages+0x74>
            page = p;
  104a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
            //SetPageReserved(page);
            break;
  104a2b:	eb 18                	jmp    104a45 <default_alloc_pages+0x8c>
  104a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a36:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a3c:	81 7d f0 7c ff 11 00 	cmpl   $0x11ff7c,-0x10(%ebp)
  104a43:	75 cc                	jne    104a11 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  104a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a49:	0f 84 fd 00 00 00    	je     104b4c <default_alloc_pages+0x193>
        //list_del(&(page->page_link));
        if (page->property > n) {
  104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a52:	8b 40 08             	mov    0x8(%eax),%eax
  104a55:	39 45 08             	cmp    %eax,0x8(%ebp)
  104a58:	0f 83 9a 00 00 00    	jae    104af8 <default_alloc_pages+0x13f>
            struct Page *p = page + n;
  104a5e:	8b 55 08             	mov    0x8(%ebp),%edx
  104a61:	89 d0                	mov    %edx,%eax
  104a63:	c1 e0 02             	shl    $0x2,%eax
  104a66:	01 d0                	add    %edx,%eax
  104a68:	c1 e0 02             	shl    $0x2,%eax
  104a6b:	89 c2                	mov    %eax,%edx
  104a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a70:	01 d0                	add    %edx,%eax
  104a72:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a78:	8b 40 08             	mov    0x8(%eax),%eax
  104a7b:	2b 45 08             	sub    0x8(%ebp),%eax
  104a7e:	89 c2                	mov    %eax,%edx
  104a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a83:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  104a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a89:	83 c0 04             	add    $0x4,%eax
  104a8c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104a93:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a96:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104a99:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104a9c:	0f ab 10             	bts    %edx,(%eax)
}
  104a9f:	90                   	nop
            //ClearPageReserved(p);
            list_add(&free_list, &(p->page_link));
  104aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104aa3:	83 c0 0c             	add    $0xc,%eax
  104aa6:	c7 45 e0 7c ff 11 00 	movl   $0x11ff7c,-0x20(%ebp)
  104aad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ab3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104ab6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ab9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  104abc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104abf:	8b 40 04             	mov    0x4(%eax),%eax
  104ac2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ac5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104ac8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104acb:	89 55 cc             	mov    %edx,-0x34(%ebp)
  104ace:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  104ad1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104ad4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104ad7:	89 10                	mov    %edx,(%eax)
  104ad9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104adc:	8b 10                	mov    (%eax),%edx
  104ade:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104ae1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104ae4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ae7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104aea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104aed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104af0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104af3:	89 10                	mov    %edx,(%eax)
}
  104af5:	90                   	nop
}
  104af6:	90                   	nop
}
  104af7:	90                   	nop
    }
        list_del(&(page->page_link));
  104af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104afb:	83 c0 0c             	add    $0xc,%eax
  104afe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104b01:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104b04:	8b 40 04             	mov    0x4(%eax),%eax
  104b07:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104b0a:	8b 12                	mov    (%edx),%edx
  104b0c:	89 55 b0             	mov    %edx,-0x50(%ebp)
  104b0f:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104b12:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104b15:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104b18:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104b1b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104b1e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104b21:	89 10                	mov    %edx,(%eax)
}
  104b23:	90                   	nop
}
  104b24:	90                   	nop
        nr_free -= n;
  104b25:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  104b2a:	2b 45 08             	sub    0x8(%ebp),%eax
  104b2d:	a3 84 ff 11 00       	mov    %eax,0x11ff84
        ClearPageProperty(page);
  104b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b35:	83 c0 04             	add    $0x4,%eax
  104b38:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104b3f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104b42:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104b45:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b48:	0f b3 10             	btr    %edx,(%eax)
}
  104b4b:	90                   	nop
    }
    return page;
  104b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104b4f:	c9                   	leave  
  104b50:	c3                   	ret    

00104b51 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104b51:	f3 0f 1e fb          	endbr32 
  104b55:	55                   	push   %ebp
  104b56:	89 e5                	mov    %esp,%ebp
  104b58:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104b5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104b62:	75 24                	jne    104b88 <default_free_pages+0x37>
  104b64:	c7 44 24 0c d8 81 10 	movl   $0x1081d8,0xc(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104b73:	00 
  104b74:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  104b7b:	00 
  104b7c:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104b83:	e8 a9 b8 ff ff       	call   100431 <__panic>
    struct Page *p = base;
  104b88:	8b 45 08             	mov    0x8(%ebp),%eax
  104b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104b8e:	e9 9d 00 00 00       	jmp    104c30 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b96:	83 c0 04             	add    $0x4,%eax
  104b99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104ba0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ba6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104ba9:	0f a3 10             	bt     %edx,(%eax)
  104bac:	19 c0                	sbb    %eax,%eax
  104bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104bb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104bb5:	0f 95 c0             	setne  %al
  104bb8:	0f b6 c0             	movzbl %al,%eax
  104bbb:	85 c0                	test   %eax,%eax
  104bbd:	75 2c                	jne    104beb <default_free_pages+0x9a>
  104bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bc2:	83 c0 04             	add    $0x4,%eax
  104bc5:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104bcc:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104bcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104bd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104bd5:	0f a3 10             	bt     %edx,(%eax)
  104bd8:	19 c0                	sbb    %eax,%eax
  104bda:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  104bdd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104be1:	0f 95 c0             	setne  %al
  104be4:	0f b6 c0             	movzbl %al,%eax
  104be7:	85 c0                	test   %eax,%eax
  104be9:	74 24                	je     104c0f <default_free_pages+0xbe>
  104beb:	c7 44 24 0c 1c 82 10 	movl   $0x10821c,0xc(%esp)
  104bf2:	00 
  104bf3:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104bfa:	00 
  104bfb:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  104c02:	00 
  104c03:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104c0a:	e8 22 b8 ff ff       	call   100431 <__panic>
        p->flags = 0;
  104c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104c19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c20:	00 
  104c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c24:	89 04 24             	mov    %eax,(%esp)
  104c27:	e8 e8 fb ff ff       	call   104814 <set_page_ref>
    for (; p != base + n; p ++) {
  104c2c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  104c33:	89 d0                	mov    %edx,%eax
  104c35:	c1 e0 02             	shl    $0x2,%eax
  104c38:	01 d0                	add    %edx,%eax
  104c3a:	c1 e0 02             	shl    $0x2,%eax
  104c3d:	89 c2                	mov    %eax,%edx
  104c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  104c42:	01 d0                	add    %edx,%eax
  104c44:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104c47:	0f 85 46 ff ff ff    	jne    104b93 <default_free_pages+0x42>
    }
    base->property = n;
  104c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  104c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  104c53:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104c56:	8b 45 08             	mov    0x8(%ebp),%eax
  104c59:	83 c0 04             	add    $0x4,%eax
  104c5c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104c63:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104c66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104c69:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104c6c:	0f ab 10             	bts    %edx,(%eax)
}
  104c6f:	90                   	nop
  104c70:	c7 45 d4 7c ff 11 00 	movl   $0x11ff7c,-0x2c(%ebp)
    return listelm->next;
  104c77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104c7a:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104c80:	e9 0e 01 00 00       	jmp    104d93 <default_free_pages+0x242>
        p = le2page(le, page_link);
  104c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c88:	83 e8 0c             	sub    $0xc,%eax
  104c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c91:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104c94:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104c97:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  104ca0:	8b 50 08             	mov    0x8(%eax),%edx
  104ca3:	89 d0                	mov    %edx,%eax
  104ca5:	c1 e0 02             	shl    $0x2,%eax
  104ca8:	01 d0                	add    %edx,%eax
  104caa:	c1 e0 02             	shl    $0x2,%eax
  104cad:	89 c2                	mov    %eax,%edx
  104caf:	8b 45 08             	mov    0x8(%ebp),%eax
  104cb2:	01 d0                	add    %edx,%eax
  104cb4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104cb7:	75 5d                	jne    104d16 <default_free_pages+0x1c5>
            base->property += p->property;
  104cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  104cbc:	8b 50 08             	mov    0x8(%eax),%edx
  104cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cc2:	8b 40 08             	mov    0x8(%eax),%eax
  104cc5:	01 c2                	add    %eax,%edx
  104cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  104cca:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cd0:	83 c0 04             	add    $0x4,%eax
  104cd3:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104cda:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104cdd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104ce0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104ce3:	0f b3 10             	btr    %edx,(%eax)
}
  104ce6:	90                   	nop
            list_del(&(p->page_link));
  104ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cea:	83 c0 0c             	add    $0xc,%eax
  104ced:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104cf0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104cf3:	8b 40 04             	mov    0x4(%eax),%eax
  104cf6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104cf9:	8b 12                	mov    (%edx),%edx
  104cfb:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104cfe:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104d01:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104d04:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104d07:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104d0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104d0d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104d10:	89 10                	mov    %edx,(%eax)
}
  104d12:	90                   	nop
}
  104d13:	90                   	nop
  104d14:	eb 7d                	jmp    104d93 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  104d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d19:	8b 50 08             	mov    0x8(%eax),%edx
  104d1c:	89 d0                	mov    %edx,%eax
  104d1e:	c1 e0 02             	shl    $0x2,%eax
  104d21:	01 d0                	add    %edx,%eax
  104d23:	c1 e0 02             	shl    $0x2,%eax
  104d26:	89 c2                	mov    %eax,%edx
  104d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d2b:	01 d0                	add    %edx,%eax
  104d2d:	39 45 08             	cmp    %eax,0x8(%ebp)
  104d30:	75 61                	jne    104d93 <default_free_pages+0x242>
            p->property += base->property;
  104d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d35:	8b 50 08             	mov    0x8(%eax),%edx
  104d38:	8b 45 08             	mov    0x8(%ebp),%eax
  104d3b:	8b 40 08             	mov    0x8(%eax),%eax
  104d3e:	01 c2                	add    %eax,%edx
  104d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d43:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104d46:	8b 45 08             	mov    0x8(%ebp),%eax
  104d49:	83 c0 04             	add    $0x4,%eax
  104d4c:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104d53:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104d56:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104d59:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104d5c:	0f b3 10             	btr    %edx,(%eax)
}
  104d5f:	90                   	nop
            base = p;
  104d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d63:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d69:	83 c0 0c             	add    $0xc,%eax
  104d6c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104d6f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104d72:	8b 40 04             	mov    0x4(%eax),%eax
  104d75:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104d78:	8b 12                	mov    (%edx),%edx
  104d7a:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104d7d:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104d80:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104d83:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104d86:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104d89:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104d8c:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104d8f:	89 10                	mov    %edx,(%eax)
}
  104d91:	90                   	nop
}
  104d92:	90                   	nop
    while (le != &free_list) {
  104d93:	81 7d f0 7c ff 11 00 	cmpl   $0x11ff7c,-0x10(%ebp)
  104d9a:	0f 85 e5 fe ff ff    	jne    104c85 <default_free_pages+0x134>
        }
    }
    nr_free += n;
  104da0:	8b 15 84 ff 11 00    	mov    0x11ff84,%edx
  104da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  104da9:	01 d0                	add    %edx,%eax
  104dab:	a3 84 ff 11 00       	mov    %eax,0x11ff84
  104db0:	c7 45 9c 7c ff 11 00 	movl   $0x11ff7c,-0x64(%ebp)
    return listelm->next;
  104db7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104dba:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  104dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104dc0:	eb 74                	jmp    104e36 <default_free_pages+0x2e5>
        p = le2page(le, page_link);
  104dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dc5:	83 e8 0c             	sub    $0xc,%eax
  104dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  104dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  104dce:	8b 50 08             	mov    0x8(%eax),%edx
  104dd1:	89 d0                	mov    %edx,%eax
  104dd3:	c1 e0 02             	shl    $0x2,%eax
  104dd6:	01 d0                	add    %edx,%eax
  104dd8:	c1 e0 02             	shl    $0x2,%eax
  104ddb:	89 c2                	mov    %eax,%edx
  104ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  104de0:	01 d0                	add    %edx,%eax
  104de2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104de5:	72 40                	jb     104e27 <default_free_pages+0x2d6>
            assert(base + base->property != p);
  104de7:	8b 45 08             	mov    0x8(%ebp),%eax
  104dea:	8b 50 08             	mov    0x8(%eax),%edx
  104ded:	89 d0                	mov    %edx,%eax
  104def:	c1 e0 02             	shl    $0x2,%eax
  104df2:	01 d0                	add    %edx,%eax
  104df4:	c1 e0 02             	shl    $0x2,%eax
  104df7:	89 c2                	mov    %eax,%edx
  104df9:	8b 45 08             	mov    0x8(%ebp),%eax
  104dfc:	01 d0                	add    %edx,%eax
  104dfe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104e01:	75 3e                	jne    104e41 <default_free_pages+0x2f0>
  104e03:	c7 44 24 0c 41 82 10 	movl   $0x108241,0xc(%esp)
  104e0a:	00 
  104e0b:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104e12:	00 
  104e13:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  104e1a:	00 
  104e1b:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104e22:	e8 0a b6 ff ff       	call   100431 <__panic>
  104e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e2a:	89 45 98             	mov    %eax,-0x68(%ebp)
  104e2d:	8b 45 98             	mov    -0x68(%ebp),%eax
  104e30:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104e36:	81 7d f0 7c ff 11 00 	cmpl   $0x11ff7c,-0x10(%ebp)
  104e3d:	75 83                	jne    104dc2 <default_free_pages+0x271>
  104e3f:	eb 01                	jmp    104e42 <default_free_pages+0x2f1>
            break;
  104e41:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  104e42:	8b 45 08             	mov    0x8(%ebp),%eax
  104e45:	8d 50 0c             	lea    0xc(%eax),%edx
  104e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e4b:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104e4e:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104e51:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104e54:	8b 00                	mov    (%eax),%eax
  104e56:	8b 55 90             	mov    -0x70(%ebp),%edx
  104e59:	89 55 8c             	mov    %edx,-0x74(%ebp)
  104e5c:	89 45 88             	mov    %eax,-0x78(%ebp)
  104e5f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104e62:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  104e65:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104e68:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104e6b:	89 10                	mov    %edx,(%eax)
  104e6d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104e70:	8b 10                	mov    (%eax),%edx
  104e72:	8b 45 88             	mov    -0x78(%ebp),%eax
  104e75:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104e78:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104e7b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104e7e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104e81:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104e84:	8b 55 88             	mov    -0x78(%ebp),%edx
  104e87:	89 10                	mov    %edx,(%eax)
}
  104e89:	90                   	nop
}
  104e8a:	90                   	nop
}
  104e8b:	90                   	nop
  104e8c:	c9                   	leave  
  104e8d:	c3                   	ret    

00104e8e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104e8e:	f3 0f 1e fb          	endbr32 
  104e92:	55                   	push   %ebp
  104e93:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104e95:	a1 84 ff 11 00       	mov    0x11ff84,%eax
}
  104e9a:	5d                   	pop    %ebp
  104e9b:	c3                   	ret    

00104e9c <basic_check>:

static void
basic_check(void) {
  104e9c:	f3 0f 1e fb          	endbr32 
  104ea0:	55                   	push   %ebp
  104ea1:	89 e5                	mov    %esp,%ebp
  104ea3:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104ea6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104eb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ec0:	e8 4a e2 ff ff       	call   10310f <alloc_pages>
  104ec5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104ec8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104ecc:	75 24                	jne    104ef2 <basic_check+0x56>
  104ece:	c7 44 24 0c 5c 82 10 	movl   $0x10825c,0xc(%esp)
  104ed5:	00 
  104ed6:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104edd:	00 
  104ede:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104ee5:	00 
  104ee6:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104eed:	e8 3f b5 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104ef2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ef9:	e8 11 e2 ff ff       	call   10310f <alloc_pages>
  104efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104f05:	75 24                	jne    104f2b <basic_check+0x8f>
  104f07:	c7 44 24 0c 78 82 10 	movl   $0x108278,0xc(%esp)
  104f0e:	00 
  104f0f:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104f16:	00 
  104f17:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104f1e:	00 
  104f1f:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104f26:	e8 06 b5 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104f2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f32:	e8 d8 e1 ff ff       	call   10310f <alloc_pages>
  104f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104f3e:	75 24                	jne    104f64 <basic_check+0xc8>
  104f40:	c7 44 24 0c 94 82 10 	movl   $0x108294,0xc(%esp)
  104f47:	00 
  104f48:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104f4f:	00 
  104f50:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  104f57:	00 
  104f58:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104f5f:	e8 cd b4 ff ff       	call   100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f67:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104f6a:	74 10                	je     104f7c <basic_check+0xe0>
  104f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f6f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f72:	74 08                	je     104f7c <basic_check+0xe0>
  104f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f77:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f7a:	75 24                	jne    104fa0 <basic_check+0x104>
  104f7c:	c7 44 24 0c b0 82 10 	movl   $0x1082b0,0xc(%esp)
  104f83:	00 
  104f84:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104f8b:	00 
  104f8c:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104f93:	00 
  104f94:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104f9b:	e8 91 b4 ff ff       	call   100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fa3:	89 04 24             	mov    %eax,(%esp)
  104fa6:	e8 5f f8 ff ff       	call   10480a <page_ref>
  104fab:	85 c0                	test   %eax,%eax
  104fad:	75 1e                	jne    104fcd <basic_check+0x131>
  104faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fb2:	89 04 24             	mov    %eax,(%esp)
  104fb5:	e8 50 f8 ff ff       	call   10480a <page_ref>
  104fba:	85 c0                	test   %eax,%eax
  104fbc:	75 0f                	jne    104fcd <basic_check+0x131>
  104fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fc1:	89 04 24             	mov    %eax,(%esp)
  104fc4:	e8 41 f8 ff ff       	call   10480a <page_ref>
  104fc9:	85 c0                	test   %eax,%eax
  104fcb:	74 24                	je     104ff1 <basic_check+0x155>
  104fcd:	c7 44 24 0c d4 82 10 	movl   $0x1082d4,0xc(%esp)
  104fd4:	00 
  104fd5:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  104fdc:	00 
  104fdd:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104fe4:	00 
  104fe5:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  104fec:	e8 40 b4 ff ff       	call   100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ff4:	89 04 24             	mov    %eax,(%esp)
  104ff7:	e8 f8 f7 ff ff       	call   1047f4 <page2pa>
  104ffc:	8b 15 80 fe 11 00    	mov    0x11fe80,%edx
  105002:	c1 e2 0c             	shl    $0xc,%edx
  105005:	39 d0                	cmp    %edx,%eax
  105007:	72 24                	jb     10502d <basic_check+0x191>
  105009:	c7 44 24 0c 10 83 10 	movl   $0x108310,0xc(%esp)
  105010:	00 
  105011:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105018:	00 
  105019:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  105020:	00 
  105021:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105028:	e8 04 b4 ff ff       	call   100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10502d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105030:	89 04 24             	mov    %eax,(%esp)
  105033:	e8 bc f7 ff ff       	call   1047f4 <page2pa>
  105038:	8b 15 80 fe 11 00    	mov    0x11fe80,%edx
  10503e:	c1 e2 0c             	shl    $0xc,%edx
  105041:	39 d0                	cmp    %edx,%eax
  105043:	72 24                	jb     105069 <basic_check+0x1cd>
  105045:	c7 44 24 0c 2d 83 10 	movl   $0x10832d,0xc(%esp)
  10504c:	00 
  10504d:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105054:	00 
  105055:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  10505c:	00 
  10505d:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105064:	e8 c8 b3 ff ff       	call   100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  105069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10506c:	89 04 24             	mov    %eax,(%esp)
  10506f:	e8 80 f7 ff ff       	call   1047f4 <page2pa>
  105074:	8b 15 80 fe 11 00    	mov    0x11fe80,%edx
  10507a:	c1 e2 0c             	shl    $0xc,%edx
  10507d:	39 d0                	cmp    %edx,%eax
  10507f:	72 24                	jb     1050a5 <basic_check+0x209>
  105081:	c7 44 24 0c 4a 83 10 	movl   $0x10834a,0xc(%esp)
  105088:	00 
  105089:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105090:	00 
  105091:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  105098:	00 
  105099:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1050a0:	e8 8c b3 ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  1050a5:	a1 7c ff 11 00       	mov    0x11ff7c,%eax
  1050aa:	8b 15 80 ff 11 00    	mov    0x11ff80,%edx
  1050b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1050b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1050b6:	c7 45 dc 7c ff 11 00 	movl   $0x11ff7c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  1050bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1050c3:	89 50 04             	mov    %edx,0x4(%eax)
  1050c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050c9:	8b 50 04             	mov    0x4(%eax),%edx
  1050cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050cf:	89 10                	mov    %edx,(%eax)
}
  1050d1:	90                   	nop
  1050d2:	c7 45 e0 7c ff 11 00 	movl   $0x11ff7c,-0x20(%ebp)
    return list->next == list;
  1050d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050dc:	8b 40 04             	mov    0x4(%eax),%eax
  1050df:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1050e2:	0f 94 c0             	sete   %al
  1050e5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1050e8:	85 c0                	test   %eax,%eax
  1050ea:	75 24                	jne    105110 <basic_check+0x274>
  1050ec:	c7 44 24 0c 67 83 10 	movl   $0x108367,0xc(%esp)
  1050f3:	00 
  1050f4:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1050fb:	00 
  1050fc:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  105103:	00 
  105104:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10510b:	e8 21 b3 ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  105110:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  105115:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  105118:	c7 05 84 ff 11 00 00 	movl   $0x0,0x11ff84
  10511f:	00 00 00 

    assert(alloc_page() == NULL);
  105122:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105129:	e8 e1 df ff ff       	call   10310f <alloc_pages>
  10512e:	85 c0                	test   %eax,%eax
  105130:	74 24                	je     105156 <basic_check+0x2ba>
  105132:	c7 44 24 0c 7e 83 10 	movl   $0x10837e,0xc(%esp)
  105139:	00 
  10513a:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105141:	00 
  105142:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  105149:	00 
  10514a:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105151:	e8 db b2 ff ff       	call   100431 <__panic>

    free_page(p0);
  105156:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10515d:	00 
  10515e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105161:	89 04 24             	mov    %eax,(%esp)
  105164:	e8 e2 df ff ff       	call   10314b <free_pages>
    free_page(p1);
  105169:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105170:	00 
  105171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105174:	89 04 24             	mov    %eax,(%esp)
  105177:	e8 cf df ff ff       	call   10314b <free_pages>
    free_page(p2);
  10517c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105183:	00 
  105184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105187:	89 04 24             	mov    %eax,(%esp)
  10518a:	e8 bc df ff ff       	call   10314b <free_pages>
    assert(nr_free == 3);
  10518f:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  105194:	83 f8 03             	cmp    $0x3,%eax
  105197:	74 24                	je     1051bd <basic_check+0x321>
  105199:	c7 44 24 0c 93 83 10 	movl   $0x108393,0xc(%esp)
  1051a0:	00 
  1051a1:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1051a8:	00 
  1051a9:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1051b0:	00 
  1051b1:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1051b8:	e8 74 b2 ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1051bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051c4:	e8 46 df ff ff       	call   10310f <alloc_pages>
  1051c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1051cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1051d0:	75 24                	jne    1051f6 <basic_check+0x35a>
  1051d2:	c7 44 24 0c 5c 82 10 	movl   $0x10825c,0xc(%esp)
  1051d9:	00 
  1051da:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1051e1:	00 
  1051e2:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1051e9:	00 
  1051ea:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1051f1:	e8 3b b2 ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1051f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051fd:	e8 0d df ff ff       	call   10310f <alloc_pages>
  105202:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105205:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105209:	75 24                	jne    10522f <basic_check+0x393>
  10520b:	c7 44 24 0c 78 82 10 	movl   $0x108278,0xc(%esp)
  105212:	00 
  105213:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10521a:	00 
  10521b:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  105222:	00 
  105223:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10522a:	e8 02 b2 ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10522f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105236:	e8 d4 de ff ff       	call   10310f <alloc_pages>
  10523b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10523e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105242:	75 24                	jne    105268 <basic_check+0x3cc>
  105244:	c7 44 24 0c 94 82 10 	movl   $0x108294,0xc(%esp)
  10524b:	00 
  10524c:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105253:	00 
  105254:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10525b:	00 
  10525c:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105263:	e8 c9 b1 ff ff       	call   100431 <__panic>

    assert(alloc_page() == NULL);
  105268:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10526f:	e8 9b de ff ff       	call   10310f <alloc_pages>
  105274:	85 c0                	test   %eax,%eax
  105276:	74 24                	je     10529c <basic_check+0x400>
  105278:	c7 44 24 0c 7e 83 10 	movl   $0x10837e,0xc(%esp)
  10527f:	00 
  105280:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105287:	00 
  105288:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  10528f:	00 
  105290:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105297:	e8 95 b1 ff ff       	call   100431 <__panic>

    free_page(p0);
  10529c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052a3:	00 
  1052a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052a7:	89 04 24             	mov    %eax,(%esp)
  1052aa:	e8 9c de ff ff       	call   10314b <free_pages>
  1052af:	c7 45 d8 7c ff 11 00 	movl   $0x11ff7c,-0x28(%ebp)
  1052b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1052b9:	8b 40 04             	mov    0x4(%eax),%eax
  1052bc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1052bf:	0f 94 c0             	sete   %al
  1052c2:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1052c5:	85 c0                	test   %eax,%eax
  1052c7:	74 24                	je     1052ed <basic_check+0x451>
  1052c9:	c7 44 24 0c a0 83 10 	movl   $0x1083a0,0xc(%esp)
  1052d0:	00 
  1052d1:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1052d8:	00 
  1052d9:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  1052e0:	00 
  1052e1:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1052e8:	e8 44 b1 ff ff       	call   100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1052ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1052f4:	e8 16 de ff ff       	call   10310f <alloc_pages>
  1052f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105302:	74 24                	je     105328 <basic_check+0x48c>
  105304:	c7 44 24 0c b8 83 10 	movl   $0x1083b8,0xc(%esp)
  10530b:	00 
  10530c:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105313:	00 
  105314:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10531b:	00 
  10531c:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105323:	e8 09 b1 ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105328:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10532f:	e8 db dd ff ff       	call   10310f <alloc_pages>
  105334:	85 c0                	test   %eax,%eax
  105336:	74 24                	je     10535c <basic_check+0x4c0>
  105338:	c7 44 24 0c 7e 83 10 	movl   $0x10837e,0xc(%esp)
  10533f:	00 
  105340:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105347:	00 
  105348:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  10534f:	00 
  105350:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105357:	e8 d5 b0 ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  10535c:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  105361:	85 c0                	test   %eax,%eax
  105363:	74 24                	je     105389 <basic_check+0x4ed>
  105365:	c7 44 24 0c d1 83 10 	movl   $0x1083d1,0xc(%esp)
  10536c:	00 
  10536d:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105374:	00 
  105375:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  10537c:	00 
  10537d:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105384:	e8 a8 b0 ff ff       	call   100431 <__panic>
    free_list = free_list_store;
  105389:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10538c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10538f:	a3 7c ff 11 00       	mov    %eax,0x11ff7c
  105394:	89 15 80 ff 11 00    	mov    %edx,0x11ff80
    nr_free = nr_free_store;
  10539a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10539d:	a3 84 ff 11 00       	mov    %eax,0x11ff84

    free_page(p);
  1053a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053a9:	00 
  1053aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053ad:	89 04 24             	mov    %eax,(%esp)
  1053b0:	e8 96 dd ff ff       	call   10314b <free_pages>
    free_page(p1);
  1053b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053bc:	00 
  1053bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053c0:	89 04 24             	mov    %eax,(%esp)
  1053c3:	e8 83 dd ff ff       	call   10314b <free_pages>
    free_page(p2);
  1053c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053cf:	00 
  1053d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053d3:	89 04 24             	mov    %eax,(%esp)
  1053d6:	e8 70 dd ff ff       	call   10314b <free_pages>
}
  1053db:	90                   	nop
  1053dc:	c9                   	leave  
  1053dd:	c3                   	ret    

001053de <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1053de:	f3 0f 1e fb          	endbr32 
  1053e2:	55                   	push   %ebp
  1053e3:	89 e5                	mov    %esp,%ebp
  1053e5:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1053eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1053f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1053f9:	c7 45 ec 7c ff 11 00 	movl   $0x11ff7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105400:	eb 6a                	jmp    10546c <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  105402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105405:	83 e8 0c             	sub    $0xc,%eax
  105408:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  10540b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10540e:	83 c0 04             	add    $0x4,%eax
  105411:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105418:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10541b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10541e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105421:	0f a3 10             	bt     %edx,(%eax)
  105424:	19 c0                	sbb    %eax,%eax
  105426:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  105429:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10542d:	0f 95 c0             	setne  %al
  105430:	0f b6 c0             	movzbl %al,%eax
  105433:	85 c0                	test   %eax,%eax
  105435:	75 24                	jne    10545b <default_check+0x7d>
  105437:	c7 44 24 0c de 83 10 	movl   $0x1083de,0xc(%esp)
  10543e:	00 
  10543f:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105446:	00 
  105447:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  10544e:	00 
  10544f:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105456:	e8 d6 af ff ff       	call   100431 <__panic>
        count ++, total += p->property;
  10545b:	ff 45 f4             	incl   -0xc(%ebp)
  10545e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105461:	8b 50 08             	mov    0x8(%eax),%edx
  105464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105467:	01 d0                	add    %edx,%eax
  105469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10546c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10546f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  105472:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105475:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105478:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10547b:	81 7d ec 7c ff 11 00 	cmpl   $0x11ff7c,-0x14(%ebp)
  105482:	0f 85 7a ff ff ff    	jne    105402 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  105488:	e8 f5 dc ff ff       	call   103182 <nr_free_pages>
  10548d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105490:	39 d0                	cmp    %edx,%eax
  105492:	74 24                	je     1054b8 <default_check+0xda>
  105494:	c7 44 24 0c ee 83 10 	movl   $0x1083ee,0xc(%esp)
  10549b:	00 
  10549c:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1054a3:	00 
  1054a4:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  1054ab:	00 
  1054ac:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1054b3:	e8 79 af ff ff       	call   100431 <__panic>

    basic_check();
  1054b8:	e8 df f9 ff ff       	call   104e9c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1054bd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1054c4:	e8 46 dc ff ff       	call   10310f <alloc_pages>
  1054c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  1054cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1054d0:	75 24                	jne    1054f6 <default_check+0x118>
  1054d2:	c7 44 24 0c 07 84 10 	movl   $0x108407,0xc(%esp)
  1054d9:	00 
  1054da:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1054e1:	00 
  1054e2:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1054e9:	00 
  1054ea:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1054f1:	e8 3b af ff ff       	call   100431 <__panic>
    assert(!PageProperty(p0));
  1054f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054f9:	83 c0 04             	add    $0x4,%eax
  1054fc:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105503:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105506:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105509:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10550c:	0f a3 10             	bt     %edx,(%eax)
  10550f:	19 c0                	sbb    %eax,%eax
  105511:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105514:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105518:	0f 95 c0             	setne  %al
  10551b:	0f b6 c0             	movzbl %al,%eax
  10551e:	85 c0                	test   %eax,%eax
  105520:	74 24                	je     105546 <default_check+0x168>
  105522:	c7 44 24 0c 12 84 10 	movl   $0x108412,0xc(%esp)
  105529:	00 
  10552a:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105531:	00 
  105532:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  105539:	00 
  10553a:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105541:	e8 eb ae ff ff       	call   100431 <__panic>

    list_entry_t free_list_store = free_list;
  105546:	a1 7c ff 11 00       	mov    0x11ff7c,%eax
  10554b:	8b 15 80 ff 11 00    	mov    0x11ff80,%edx
  105551:	89 45 80             	mov    %eax,-0x80(%ebp)
  105554:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105557:	c7 45 b0 7c ff 11 00 	movl   $0x11ff7c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  10555e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105561:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105564:	89 50 04             	mov    %edx,0x4(%eax)
  105567:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10556a:	8b 50 04             	mov    0x4(%eax),%edx
  10556d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105570:	89 10                	mov    %edx,(%eax)
}
  105572:	90                   	nop
  105573:	c7 45 b4 7c ff 11 00 	movl   $0x11ff7c,-0x4c(%ebp)
    return list->next == list;
  10557a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10557d:	8b 40 04             	mov    0x4(%eax),%eax
  105580:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105583:	0f 94 c0             	sete   %al
  105586:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  105589:	85 c0                	test   %eax,%eax
  10558b:	75 24                	jne    1055b1 <default_check+0x1d3>
  10558d:	c7 44 24 0c 67 83 10 	movl   $0x108367,0xc(%esp)
  105594:	00 
  105595:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10559c:	00 
  10559d:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1055a4:	00 
  1055a5:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1055ac:	e8 80 ae ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  1055b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055b8:	e8 52 db ff ff       	call   10310f <alloc_pages>
  1055bd:	85 c0                	test   %eax,%eax
  1055bf:	74 24                	je     1055e5 <default_check+0x207>
  1055c1:	c7 44 24 0c 7e 83 10 	movl   $0x10837e,0xc(%esp)
  1055c8:	00 
  1055c9:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1055d0:	00 
  1055d1:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1055d8:	00 
  1055d9:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1055e0:	e8 4c ae ff ff       	call   100431 <__panic>

    unsigned int nr_free_store = nr_free;
  1055e5:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  1055ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1055ed:	c7 05 84 ff 11 00 00 	movl   $0x0,0x11ff84
  1055f4:	00 00 00 

    free_pages(p0 + 2, 3);
  1055f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055fa:	83 c0 28             	add    $0x28,%eax
  1055fd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105604:	00 
  105605:	89 04 24             	mov    %eax,(%esp)
  105608:	e8 3e db ff ff       	call   10314b <free_pages>
    assert(alloc_pages(4) == NULL);
  10560d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105614:	e8 f6 da ff ff       	call   10310f <alloc_pages>
  105619:	85 c0                	test   %eax,%eax
  10561b:	74 24                	je     105641 <default_check+0x263>
  10561d:	c7 44 24 0c 24 84 10 	movl   $0x108424,0xc(%esp)
  105624:	00 
  105625:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10562c:	00 
  10562d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  105634:	00 
  105635:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10563c:	e8 f0 ad ff ff       	call   100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105641:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105644:	83 c0 28             	add    $0x28,%eax
  105647:	83 c0 04             	add    $0x4,%eax
  10564a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105651:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105654:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105657:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10565a:	0f a3 10             	bt     %edx,(%eax)
  10565d:	19 c0                	sbb    %eax,%eax
  10565f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105662:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105666:	0f 95 c0             	setne  %al
  105669:	0f b6 c0             	movzbl %al,%eax
  10566c:	85 c0                	test   %eax,%eax
  10566e:	74 0e                	je     10567e <default_check+0x2a0>
  105670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105673:	83 c0 28             	add    $0x28,%eax
  105676:	8b 40 08             	mov    0x8(%eax),%eax
  105679:	83 f8 03             	cmp    $0x3,%eax
  10567c:	74 24                	je     1056a2 <default_check+0x2c4>
  10567e:	c7 44 24 0c 3c 84 10 	movl   $0x10843c,0xc(%esp)
  105685:	00 
  105686:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10568d:	00 
  10568e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105695:	00 
  105696:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10569d:	e8 8f ad ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1056a2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1056a9:	e8 61 da ff ff       	call   10310f <alloc_pages>
  1056ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1056b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1056b5:	75 24                	jne    1056db <default_check+0x2fd>
  1056b7:	c7 44 24 0c 68 84 10 	movl   $0x108468,0xc(%esp)
  1056be:	00 
  1056bf:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1056c6:	00 
  1056c7:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1056ce:	00 
  1056cf:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1056d6:	e8 56 ad ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  1056db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056e2:	e8 28 da ff ff       	call   10310f <alloc_pages>
  1056e7:	85 c0                	test   %eax,%eax
  1056e9:	74 24                	je     10570f <default_check+0x331>
  1056eb:	c7 44 24 0c 7e 83 10 	movl   $0x10837e,0xc(%esp)
  1056f2:	00 
  1056f3:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1056fa:	00 
  1056fb:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  105702:	00 
  105703:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10570a:	e8 22 ad ff ff       	call   100431 <__panic>
    assert(p0 + 2 == p1);
  10570f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105712:	83 c0 28             	add    $0x28,%eax
  105715:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105718:	74 24                	je     10573e <default_check+0x360>
  10571a:	c7 44 24 0c 86 84 10 	movl   $0x108486,0xc(%esp)
  105721:	00 
  105722:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105729:	00 
  10572a:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  105731:	00 
  105732:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105739:	e8 f3 ac ff ff       	call   100431 <__panic>

    p2 = p0 + 1;
  10573e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105741:	83 c0 14             	add    $0x14,%eax
  105744:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  105747:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10574e:	00 
  10574f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105752:	89 04 24             	mov    %eax,(%esp)
  105755:	e8 f1 d9 ff ff       	call   10314b <free_pages>
    free_pages(p1, 3);
  10575a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105761:	00 
  105762:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105765:	89 04 24             	mov    %eax,(%esp)
  105768:	e8 de d9 ff ff       	call   10314b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10576d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105770:	83 c0 04             	add    $0x4,%eax
  105773:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10577a:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10577d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105780:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105783:	0f a3 10             	bt     %edx,(%eax)
  105786:	19 c0                	sbb    %eax,%eax
  105788:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10578b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10578f:	0f 95 c0             	setne  %al
  105792:	0f b6 c0             	movzbl %al,%eax
  105795:	85 c0                	test   %eax,%eax
  105797:	74 0b                	je     1057a4 <default_check+0x3c6>
  105799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10579c:	8b 40 08             	mov    0x8(%eax),%eax
  10579f:	83 f8 01             	cmp    $0x1,%eax
  1057a2:	74 24                	je     1057c8 <default_check+0x3ea>
  1057a4:	c7 44 24 0c 94 84 10 	movl   $0x108494,0xc(%esp)
  1057ab:	00 
  1057ac:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1057b3:	00 
  1057b4:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1057bb:	00 
  1057bc:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1057c3:	e8 69 ac ff ff       	call   100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1057c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057cb:	83 c0 04             	add    $0x4,%eax
  1057ce:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1057d5:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1057d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  1057db:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1057de:	0f a3 10             	bt     %edx,(%eax)
  1057e1:	19 c0                	sbb    %eax,%eax
  1057e3:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1057e6:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1057ea:	0f 95 c0             	setne  %al
  1057ed:	0f b6 c0             	movzbl %al,%eax
  1057f0:	85 c0                	test   %eax,%eax
  1057f2:	74 0b                	je     1057ff <default_check+0x421>
  1057f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057f7:	8b 40 08             	mov    0x8(%eax),%eax
  1057fa:	83 f8 03             	cmp    $0x3,%eax
  1057fd:	74 24                	je     105823 <default_check+0x445>
  1057ff:	c7 44 24 0c bc 84 10 	movl   $0x1084bc,0xc(%esp)
  105806:	00 
  105807:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10580e:	00 
  10580f:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  105816:	00 
  105817:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10581e:	e8 0e ac ff ff       	call   100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105823:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10582a:	e8 e0 d8 ff ff       	call   10310f <alloc_pages>
  10582f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105832:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105835:	83 e8 14             	sub    $0x14,%eax
  105838:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10583b:	74 24                	je     105861 <default_check+0x483>
  10583d:	c7 44 24 0c e2 84 10 	movl   $0x1084e2,0xc(%esp)
  105844:	00 
  105845:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10584c:	00 
  10584d:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  105854:	00 
  105855:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10585c:	e8 d0 ab ff ff       	call   100431 <__panic>
    free_page(p0);
  105861:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105868:	00 
  105869:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10586c:	89 04 24             	mov    %eax,(%esp)
  10586f:	e8 d7 d8 ff ff       	call   10314b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105874:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10587b:	e8 8f d8 ff ff       	call   10310f <alloc_pages>
  105880:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105883:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105886:	83 c0 14             	add    $0x14,%eax
  105889:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10588c:	74 24                	je     1058b2 <default_check+0x4d4>
  10588e:	c7 44 24 0c 00 85 10 	movl   $0x108500,0xc(%esp)
  105895:	00 
  105896:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10589d:	00 
  10589e:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1058a5:	00 
  1058a6:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1058ad:	e8 7f ab ff ff       	call   100431 <__panic>

    free_pages(p0, 2);
  1058b2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1058b9:	00 
  1058ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058bd:	89 04 24             	mov    %eax,(%esp)
  1058c0:	e8 86 d8 ff ff       	call   10314b <free_pages>
    free_page(p2);
  1058c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1058cc:	00 
  1058cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1058d0:	89 04 24             	mov    %eax,(%esp)
  1058d3:	e8 73 d8 ff ff       	call   10314b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1058d8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1058df:	e8 2b d8 ff ff       	call   10310f <alloc_pages>
  1058e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058eb:	75 24                	jne    105911 <default_check+0x533>
  1058ed:	c7 44 24 0c 20 85 10 	movl   $0x108520,0xc(%esp)
  1058f4:	00 
  1058f5:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1058fc:	00 
  1058fd:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  105904:	00 
  105905:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10590c:	e8 20 ab ff ff       	call   100431 <__panic>
    assert(alloc_page() == NULL);
  105911:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105918:	e8 f2 d7 ff ff       	call   10310f <alloc_pages>
  10591d:	85 c0                	test   %eax,%eax
  10591f:	74 24                	je     105945 <default_check+0x567>
  105921:	c7 44 24 0c 7e 83 10 	movl   $0x10837e,0xc(%esp)
  105928:	00 
  105929:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105930:	00 
  105931:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  105938:	00 
  105939:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105940:	e8 ec aa ff ff       	call   100431 <__panic>

    assert(nr_free == 0);
  105945:	a1 84 ff 11 00       	mov    0x11ff84,%eax
  10594a:	85 c0                	test   %eax,%eax
  10594c:	74 24                	je     105972 <default_check+0x594>
  10594e:	c7 44 24 0c d1 83 10 	movl   $0x1083d1,0xc(%esp)
  105955:	00 
  105956:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  10595d:	00 
  10595e:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  105965:	00 
  105966:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  10596d:	e8 bf aa ff ff       	call   100431 <__panic>
    nr_free = nr_free_store;
  105972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105975:	a3 84 ff 11 00       	mov    %eax,0x11ff84

    free_list = free_list_store;
  10597a:	8b 45 80             	mov    -0x80(%ebp),%eax
  10597d:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105980:	a3 7c ff 11 00       	mov    %eax,0x11ff7c
  105985:	89 15 80 ff 11 00    	mov    %edx,0x11ff80
    free_pages(p0, 5);
  10598b:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105992:	00 
  105993:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105996:	89 04 24             	mov    %eax,(%esp)
  105999:	e8 ad d7 ff ff       	call   10314b <free_pages>

    le = &free_list;
  10599e:	c7 45 ec 7c ff 11 00 	movl   $0x11ff7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1059a5:	eb 5a                	jmp    105a01 <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
  1059a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059aa:	8b 40 04             	mov    0x4(%eax),%eax
  1059ad:	8b 00                	mov    (%eax),%eax
  1059af:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1059b2:	75 0d                	jne    1059c1 <default_check+0x5e3>
  1059b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059b7:	8b 00                	mov    (%eax),%eax
  1059b9:	8b 40 04             	mov    0x4(%eax),%eax
  1059bc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1059bf:	74 24                	je     1059e5 <default_check+0x607>
  1059c1:	c7 44 24 0c 40 85 10 	movl   $0x108540,0xc(%esp)
  1059c8:	00 
  1059c9:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  1059d0:	00 
  1059d1:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1059d8:	00 
  1059d9:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  1059e0:	e8 4c aa ff ff       	call   100431 <__panic>
        struct Page *p = le2page(le, page_link);
  1059e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059e8:	83 e8 0c             	sub    $0xc,%eax
  1059eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  1059ee:	ff 4d f4             	decl   -0xc(%ebp)
  1059f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1059f7:	8b 40 08             	mov    0x8(%eax),%eax
  1059fa:	29 c2                	sub    %eax,%edx
  1059fc:	89 d0                	mov    %edx,%eax
  1059fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a04:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105a07:	8b 45 88             	mov    -0x78(%ebp),%eax
  105a0a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105a0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a10:	81 7d ec 7c ff 11 00 	cmpl   $0x11ff7c,-0x14(%ebp)
  105a17:	75 8e                	jne    1059a7 <default_check+0x5c9>
    }
    assert(count == 0);
  105a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105a1d:	74 24                	je     105a43 <default_check+0x665>
  105a1f:	c7 44 24 0c 6d 85 10 	movl   $0x10856d,0xc(%esp)
  105a26:	00 
  105a27:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105a2e:	00 
  105a2f:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  105a36:	00 
  105a37:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105a3e:	e8 ee a9 ff ff       	call   100431 <__panic>
    assert(total == 0);
  105a43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a47:	74 24                	je     105a6d <default_check+0x68f>
  105a49:	c7 44 24 0c 78 85 10 	movl   $0x108578,0xc(%esp)
  105a50:	00 
  105a51:	c7 44 24 08 de 81 10 	movl   $0x1081de,0x8(%esp)
  105a58:	00 
  105a59:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  105a60:	00 
  105a61:	c7 04 24 f3 81 10 00 	movl   $0x1081f3,(%esp)
  105a68:	e8 c4 a9 ff ff       	call   100431 <__panic>
}
  105a6d:	90                   	nop
  105a6e:	c9                   	leave  
  105a6f:	c3                   	ret    

00105a70 <page2ppn>:
page2ppn(struct Page *page) {
  105a70:	55                   	push   %ebp
  105a71:	89 e5                	mov    %esp,%ebp
    return page - pages;
  105a73:	a1 78 ff 11 00       	mov    0x11ff78,%eax
  105a78:	8b 55 08             	mov    0x8(%ebp),%edx
  105a7b:	29 c2                	sub    %eax,%edx
  105a7d:	89 d0                	mov    %edx,%eax
  105a7f:	c1 f8 02             	sar    $0x2,%eax
  105a82:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  105a88:	5d                   	pop    %ebp
  105a89:	c3                   	ret    

00105a8a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  105a8a:	55                   	push   %ebp
  105a8b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  105a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a93:	89 10                	mov    %edx,(%eax)
}
  105a95:	90                   	nop
  105a96:	5d                   	pop    %ebp
  105a97:	c3                   	ret    

00105a98 <IS_POWER_OF_2>:
#define nr_free (buddy_s.nr_free) //剩余的空闲块

// 第一个能被分配的物理页页号（用于buddy system中寻找伙伴块）
ppn_t first_ppn = 0;

static int IS_POWER_OF_2(size_t n) {
  105a98:	f3 0f 1e fb          	endbr32 
  105a9c:	55                   	push   %ebp
  105a9d:	89 e5                	mov    %esp,%ebp
    if (n & (n - 1)) { 
  105a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa2:	48                   	dec    %eax
  105aa3:	23 45 08             	and    0x8(%ebp),%eax
  105aa6:	85 c0                	test   %eax,%eax
  105aa8:	74 07                	je     105ab1 <IS_POWER_OF_2+0x19>
        return 0;
  105aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  105aaf:	eb 05                	jmp    105ab6 <IS_POWER_OF_2+0x1e>
    }
    else {
        return 1;
  105ab1:	b8 01 00 00 00       	mov    $0x1,%eax
    }
}
  105ab6:	5d                   	pop    %ebp
  105ab7:	c3                   	ret    

00105ab8 <getOrderOf2>:

static unsigned int getOrderOf2(size_t n) {
  105ab8:	f3 0f 1e fb          	endbr32 
  105abc:	55                   	push   %ebp
  105abd:	89 e5                	mov    %esp,%ebp
  105abf:	83 ec 10             	sub    $0x10,%esp
    unsigned int order = 0;
  105ac2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (n >> 1) {
  105ac9:	eb 06                	jmp    105ad1 <getOrderOf2+0x19>
        n >>= 1;
  105acb:	d1 6d 08             	shrl   0x8(%ebp)
        order ++;
  105ace:	ff 45 fc             	incl   -0x4(%ebp)
    while (n >> 1) {
  105ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad4:	d1 e8                	shr    %eax
  105ad6:	85 c0                	test   %eax,%eax
  105ad8:	75 f1                	jne    105acb <getOrderOf2+0x13>
    }
    return order;
  105ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105add:	c9                   	leave  
  105ade:	c3                   	ret    

00105adf <ROUNDDOWN2>:

static size_t ROUNDDOWN2(size_t n) {
  105adf:	f3 0f 1e fb          	endbr32 
  105ae3:	55                   	push   %ebp
  105ae4:	89 e5                	mov    %esp,%ebp
  105ae6:	83 ec 14             	sub    $0x14,%esp
    size_t res = 1;
  105ae9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    if (!IS_POWER_OF_2(n)) {
  105af0:	8b 45 08             	mov    0x8(%ebp),%eax
  105af3:	89 04 24             	mov    %eax,(%esp)
  105af6:	e8 9d ff ff ff       	call   105a98 <IS_POWER_OF_2>
  105afb:	85 c0                	test   %eax,%eax
  105afd:	75 15                	jne    105b14 <ROUNDDOWN2+0x35>
        while (n) {
  105aff:	eb 06                	jmp    105b07 <ROUNDDOWN2+0x28>
            n = n >> 1;
  105b01:	d1 6d 08             	shrl   0x8(%ebp)
            res = res << 1;
  105b04:	d1 65 fc             	shll   -0x4(%ebp)
        while (n) {
  105b07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b0b:	75 f4                	jne    105b01 <ROUNDDOWN2+0x22>
        }
        return res>>1; 
  105b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b10:	d1 e8                	shr    %eax
  105b12:	eb 03                	jmp    105b17 <ROUNDDOWN2+0x38>
    }
    else {
        return n;
  105b14:	8b 45 08             	mov    0x8(%ebp),%eax
    }
}
  105b17:	c9                   	leave  
  105b18:	c3                   	ret    

00105b19 <ROUNDUP2>:

static size_t ROUNDUP2(size_t n) {
  105b19:	f3 0f 1e fb          	endbr32 
  105b1d:	55                   	push   %ebp
  105b1e:	89 e5                	mov    %esp,%ebp
  105b20:	83 ec 14             	sub    $0x14,%esp
    size_t res = 1;
  105b23:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    if (!IS_POWER_OF_2(n)) {
  105b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2d:	89 04 24             	mov    %eax,(%esp)
  105b30:	e8 63 ff ff ff       	call   105a98 <IS_POWER_OF_2>
  105b35:	85 c0                	test   %eax,%eax
  105b37:	75 13                	jne    105b4c <ROUNDUP2+0x33>
        while (n) {
  105b39:	eb 06                	jmp    105b41 <ROUNDUP2+0x28>
            n = n >> 1;
  105b3b:	d1 6d 08             	shrl   0x8(%ebp)
            res = res << 1;
  105b3e:	d1 65 fc             	shll   -0x4(%ebp)
        while (n) {
  105b41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b45:	75 f4                	jne    105b3b <ROUNDUP2+0x22>
        }
        return res; 
  105b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b4a:	eb 03                	jmp    105b4f <ROUNDUP2+0x36>
    }
    else {
        return n;
  105b4c:	8b 45 08             	mov    0x8(%ebp),%eax
    }
}
  105b4f:	c9                   	leave  
  105b50:	c3                   	ret    

00105b51 <show_buddy_array>:

//在测试的时候使用，打印buddy array
static void
show_buddy_array(void) {
  105b51:	f3 0f 1e fb          	endbr32 
  105b55:	55                   	push   %ebp
  105b56:	89 e5                	mov    %esp,%ebp
  105b58:	83 ec 28             	sub    $0x28,%esp
    cprintf("[!]BS: Printing buddy array:\n");
  105b5b:	c7 04 24 b4 85 10 00 	movl   $0x1085b4,(%esp)
  105b62:	e8 5e a7 ff ff       	call   1002c5 <cprintf>
    for (int i = 0;i < max_order + 1;i ++) {
  105b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105b6e:	e9 81 00 00 00       	jmp    105bf4 <show_buddy_array+0xa3>
        cprintf("%d layer: ", i);
  105b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b7a:	c7 04 24 d2 85 10 00 	movl   $0x1085d2,(%esp)
  105b81:	e8 3f a7 ff ff       	call   1002c5 <cprintf>
        list_entry_t *le = &(buddy_array[i]);
  105b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b89:	c1 e0 03             	shl    $0x3,%eax
  105b8c:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  105b91:	83 c0 04             	add    $0x4,%eax
  105b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != &(buddy_array[i])) {
  105b97:	eb 2a                	jmp    105bc3 <show_buddy_array+0x72>
            struct Page *p = le2page(le, page_link);
  105b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b9c:	83 e8 0c             	sub    $0xc,%eax
  105b9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
            cprintf("%d ", 1 << (p->property));
  105ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ba5:	8b 40 08             	mov    0x8(%eax),%eax
  105ba8:	ba 01 00 00 00       	mov    $0x1,%edx
  105bad:	88 c1                	mov    %al,%cl
  105baf:	d3 e2                	shl    %cl,%edx
  105bb1:	89 d0                	mov    %edx,%eax
  105bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bb7:	c7 04 24 dd 85 10 00 	movl   $0x1085dd,(%esp)
  105bbe:	e8 02 a7 ff ff       	call   1002c5 <cprintf>
  105bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105bcc:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != &(buddy_array[i])) {
  105bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bd5:	c1 e0 03             	shl    $0x3,%eax
  105bd8:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  105bdd:	83 c0 04             	add    $0x4,%eax
  105be0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  105be3:	75 b4                	jne    105b99 <show_buddy_array+0x48>
        }
        cprintf("\n");
  105be5:	c7 04 24 e1 85 10 00 	movl   $0x1085e1,(%esp)
  105bec:	e8 d4 a6 ff ff       	call   1002c5 <cprintf>
    for (int i = 0;i < max_order + 1;i ++) {
  105bf1:	ff 45 f4             	incl   -0xc(%ebp)
  105bf4:	a1 a0 ff 11 00       	mov    0x11ffa0,%eax
  105bf9:	8d 50 01             	lea    0x1(%eax),%edx
  105bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bff:	39 c2                	cmp    %eax,%edx
  105c01:	0f 87 6c ff ff ff    	ja     105b73 <show_buddy_array+0x22>
    }
    cprintf("---------------------------\n");
  105c07:	c7 04 24 e3 85 10 00 	movl   $0x1085e3,(%esp)
  105c0e:	e8 b2 a6 ff ff       	call   1002c5 <cprintf>
    return;
  105c13:	90                   	nop
}
  105c14:	c9                   	leave  
  105c15:	c3                   	ret    

00105c16 <buddy_init>:

/*
 *  初始化buddy结构体
 */
buddy_init(void) {
  105c16:	f3 0f 1e fb          	endbr32 
  105c1a:	55                   	push   %ebp
  105c1b:	89 e5                	mov    %esp,%ebp
  105c1d:	83 ec 28             	sub    $0x28,%esp
    for (int i = 0;i < MAX_BUDDY_ORDER+1;i ++){
  105c20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  105c27:	eb 26                	jmp    105c4f <buddy_init+0x39>
        list_init(buddy_array + i); 
  105c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c2c:	c1 e0 03             	shl    $0x3,%eax
  105c2f:	05 a4 ff 11 00       	add    $0x11ffa4,%eax
  105c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
  105c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105c3d:	89 50 04             	mov    %edx,0x4(%eax)
  105c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c43:	8b 50 04             	mov    0x4(%eax),%edx
  105c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c49:	89 10                	mov    %edx,(%eax)
}
  105c4b:	90                   	nop
    for (int i = 0;i < MAX_BUDDY_ORDER+1;i ++){
  105c4c:	ff 45 f4             	incl   -0xc(%ebp)
  105c4f:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
  105c53:	7e d4                	jle    105c29 <buddy_init+0x13>
    }
    max_order = 0;
  105c55:	c7 05 a0 ff 11 00 00 	movl   $0x0,0x11ffa0
  105c5c:	00 00 00 
    nr_free = 0;
  105c5f:	c7 05 1c 00 12 00 00 	movl   $0x0,0x12001c
  105c66:	00 00 00 
    cprintf("buddy system init success\n");
  105c69:	c7 04 24 00 86 10 00 	movl   $0x108600,(%esp)
  105c70:	e8 50 a6 ff ff       	call   1002c5 <cprintf>
    return;
  105c75:	90                   	nop
  105c76:	90                   	nop
}
  105c77:	c9                   	leave  
  105c78:	c3                   	ret    

00105c79 <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  105c79:	f3 0f 1e fb          	endbr32 
  105c7d:	55                   	push   %ebp
  105c7e:	89 e5                	mov    %esp,%ebp
  105c80:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  105c83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c87:	75 24                	jne    105cad <buddy_init_memmap+0x34>
  105c89:	c7 44 24 0c 1b 86 10 	movl   $0x10861b,0xc(%esp)
  105c90:	00 
  105c91:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  105c98:	00 
  105c99:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  105ca0:	00 
  105ca1:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  105ca8:	e8 84 a7 ff ff       	call   100431 <__panic>
    size_t pnum;
    unsigned int order;
    pnum = ROUNDDOWN2(n);       // 将页数向下取整为2的幂
  105cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb0:	89 04 24             	mov    %eax,(%esp)
  105cb3:	e8 27 fe ff ff       	call   105adf <ROUNDDOWN2>
  105cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    //for debug
    //pnum = 8;
    order = getOrderOf2(pnum);   // 求出页数对应的2的幂
  105cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cbe:	89 04 24             	mov    %eax,(%esp)
  105cc1:	e8 f2 fd ff ff       	call   105ab8 <getOrderOf2>
  105cc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cprintf("[!]BS: AVA Page num after rounding down to powers of 2: %d = 2^%d\n", pnum, order);
  105cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ccc:	89 44 24 08          	mov    %eax,0x8(%esp)
  105cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cd7:	c7 04 24 4c 86 10 00 	movl   $0x10864c,(%esp)
  105cde:	e8 e2 a5 ff ff       	call   1002c5 <cprintf>

    struct Page *p = base;
  105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // 初始化pages数组中范围内的每个Page
    for (; p != base + pnum; p ++) {
  105ce9:	eb 7b                	jmp    105d66 <buddy_init_memmap+0xed>
        assert(PageReserved(p));
  105ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cee:	83 c0 04             	add    $0x4,%eax
  105cf1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  105cf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105cfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105d01:	0f a3 10             	bt     %edx,(%eax)
  105d04:	19 c0                	sbb    %eax,%eax
  105d06:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  105d09:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105d0d:	0f 95 c0             	setne  %al
  105d10:	0f b6 c0             	movzbl %al,%eax
  105d13:	85 c0                	test   %eax,%eax
  105d15:	75 24                	jne    105d3b <buddy_init_memmap+0xc2>
  105d17:	c7 44 24 0c 8f 86 10 	movl   $0x10868f,0xc(%esp)
  105d1e:	00 
  105d1f:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  105d26:	00 
  105d27:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  105d2e:	00 
  105d2f:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  105d36:	e8 f6 a6 ff ff       	call   100431 <__panic>
        p->flags = 0;
  105d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        p->property = -1;   // 全部初始化为非头页
  105d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d48:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
        set_page_ref(p, 0);
  105d4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105d56:	00 
  105d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d5a:	89 04 24             	mov    %eax,(%esp)
  105d5d:	e8 28 fd ff ff       	call   105a8a <set_page_ref>
    for (; p != base + pnum; p ++) {
  105d62:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  105d66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105d69:	89 d0                	mov    %edx,%eax
  105d6b:	c1 e0 02             	shl    $0x2,%eax
  105d6e:	01 d0                	add    %edx,%eax
  105d70:	c1 e0 02             	shl    $0x2,%eax
  105d73:	89 c2                	mov    %eax,%edx
  105d75:	8b 45 08             	mov    0x8(%ebp),%eax
  105d78:	01 d0                	add    %edx,%eax
  105d7a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  105d7d:	0f 85 68 ff ff ff    	jne    105ceb <buddy_init_memmap+0x72>
    }

    max_order = order>max_order?order:max_order;
  105d83:	a1 a0 ff 11 00       	mov    0x11ffa0,%eax
  105d88:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105d8b:	0f 43 45 ec          	cmovae -0x14(%ebp),%eax
  105d8f:	a3 a0 ff 11 00       	mov    %eax,0x11ffa0
    nr_free += pnum;
  105d94:	8b 15 1c 00 12 00    	mov    0x12001c,%edx
  105d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d9d:	01 d0                	add    %edx,%eax
  105d9f:	a3 1c 00 12 00       	mov    %eax,0x12001c

    cprintf("max_order is :%d,nr_free is :%d\n",max_order,nr_free);
  105da4:	8b 15 1c 00 12 00    	mov    0x12001c,%edx
  105daa:	a1 a0 ff 11 00       	mov    0x11ffa0,%eax
  105daf:	89 54 24 08          	mov    %edx,0x8(%esp)
  105db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105db7:	c7 04 24 a0 86 10 00 	movl   $0x1086a0,(%esp)
  105dbe:	e8 02 a5 ff ff       	call   1002c5 <cprintf>
    list_add(&(buddy_array[order]), &(base->page_link)); // 将第一页base插入数组的最后一个链表，作为初始化的最大块——16384,的头页
  105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc6:	83 c0 0c             	add    $0xc,%eax
  105dc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105dcc:	c1 e2 03             	shl    $0x3,%edx
  105dcf:	81 c2 a0 ff 11 00    	add    $0x11ffa0,%edx
  105dd5:	83 c2 04             	add    $0x4,%edx
  105dd8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105ddb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105de1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  105de4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105de7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    __list_add(elm, listelm, listelm->next);
  105dea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105ded:	8b 40 04             	mov    0x4(%eax),%eax
  105df0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105df3:	89 55 cc             	mov    %edx,-0x34(%ebp)
  105df6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105df9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105dfc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next->prev = elm;
  105dff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105e02:	8b 55 cc             	mov    -0x34(%ebp),%edx
  105e05:	89 10                	mov    %edx,(%eax)
  105e07:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105e0a:	8b 10                	mov    (%eax),%edx
  105e0c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105e0f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105e12:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105e15:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105e18:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105e1b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105e1e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  105e21:	89 10                	mov    %edx,(%eax)
}
  105e23:	90                   	nop
}
  105e24:	90                   	nop
}
  105e25:	90                   	nop
    base->property = order;                       // 将第一页base的property设为最大块的2幂
  105e26:	8b 45 08             	mov    0x8(%ebp),%eax
  105e29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e2c:	89 50 08             	mov    %edx,0x8(%eax)

    cprintf("buddy mem init success\n");
  105e2f:	c7 04 24 c1 86 10 00 	movl   $0x1086c1,(%esp)
  105e36:	e8 8a a4 ff ff       	call   1002c5 <cprintf>
    return;
  105e3b:	90                   	nop
}   
  105e3c:	c9                   	leave  
  105e3d:	c3                   	ret    

00105e3e <buddy_split>:
 *  buddy_split：分裂指定阶的物理块
 *  参数：
 *  n： 指定的阶
 *  默认分裂数组中第n条链表的第一块
 */
static void buddy_split(size_t n) {
  105e3e:	f3 0f 1e fb          	endbr32 
  105e42:	55                   	push   %ebp
  105e43:	89 e5                	mov    %esp,%ebp
  105e45:	83 ec 78             	sub    $0x78,%esp
    assert(n > 0 && n <= max_order);
  105e48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105e4c:	74 0a                	je     105e58 <buddy_split+0x1a>
  105e4e:	a1 a0 ff 11 00       	mov    0x11ffa0,%eax
  105e53:	39 45 08             	cmp    %eax,0x8(%ebp)
  105e56:	76 24                	jbe    105e7c <buddy_split+0x3e>
  105e58:	c7 44 24 0c d9 86 10 	movl   $0x1086d9,0xc(%esp)
  105e5f:	00 
  105e60:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  105e67:	00 
  105e68:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  105e6f:	00 
  105e70:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  105e77:	e8 b5 a5 ff ff       	call   100431 <__panic>
    assert(!list_empty(&(buddy_array[n])));
  105e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e7f:	c1 e0 03             	shl    $0x3,%eax
  105e82:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  105e87:	83 c0 04             	add    $0x4,%eax
  105e8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return list->next == list;
  105e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e90:	8b 40 04             	mov    0x4(%eax),%eax
  105e93:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105e96:	0f 94 c0             	sete   %al
  105e99:	0f b6 c0             	movzbl %al,%eax
  105e9c:	85 c0                	test   %eax,%eax
  105e9e:	74 24                	je     105ec4 <buddy_split+0x86>
  105ea0:	c7 44 24 0c f4 86 10 	movl   $0x1086f4,0xc(%esp)
  105ea7:	00 
  105ea8:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  105eaf:	00 
  105eb0:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  105eb7:	00 
  105eb8:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  105ebf:	e8 6d a5 ff ff       	call   100431 <__panic>
    cprintf("[!]BS: SPLITTING!\n");
  105ec4:	c7 04 24 13 87 10 00 	movl   $0x108713,(%esp)
  105ecb:	e8 f5 a3 ff ff       	call   1002c5 <cprintf>
    struct Page *page_left;
    struct Page *page_right;

    page_left = le2page(list_next(&(buddy_array[n])), page_link);
  105ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed3:	c1 e0 03             	shl    $0x3,%eax
  105ed6:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  105edb:	83 c0 04             	add    $0x4,%eax
  105ede:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
  105ee1:	8b 45 a0             	mov    -0x60(%ebp),%eax
  105ee4:	8b 40 04             	mov    0x4(%eax),%eax
  105ee7:	83 e8 0c             	sub    $0xc,%eax
  105eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_right = page_left + (1 << (n - 1));
  105eed:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef0:	48                   	dec    %eax
  105ef1:	ba 14 00 00 00       	mov    $0x14,%edx
  105ef6:	88 c1                	mov    %al,%cl
  105ef8:	d3 e2                	shl    %cl,%edx
  105efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105efd:	01 d0                	add    %edx,%eax
  105eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    page_left->property = n - 1;
  105f02:	8b 45 08             	mov    0x8(%ebp),%eax
  105f05:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f0b:	89 50 08             	mov    %edx,0x8(%eax)
    page_right->property = n - 1;
  105f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f17:	89 50 08             	mov    %edx,0x8(%eax)

    list_del(list_next(&(buddy_array[n])));
  105f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1d:	c1 e0 03             	shl    $0x3,%eax
  105f20:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  105f25:	83 c0 04             	add    $0x4,%eax
  105f28:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  105f2b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  105f2e:	8b 40 04             	mov    0x4(%eax),%eax
  105f31:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  105f34:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105f37:	8b 40 04             	mov    0x4(%eax),%eax
  105f3a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105f3d:	8b 12                	mov    (%edx),%edx
  105f3f:	89 55 ac             	mov    %edx,-0x54(%ebp)
  105f42:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  105f45:	8b 45 ac             	mov    -0x54(%ebp),%eax
  105f48:	8b 55 a8             	mov    -0x58(%ebp),%edx
  105f4b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  105f4e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105f51:	8b 55 ac             	mov    -0x54(%ebp),%edx
  105f54:	89 10                	mov    %edx,(%eax)
}
  105f56:	90                   	nop
}
  105f57:	90                   	nop
    list_add(&(buddy_array[n-1]), &(page_left->page_link));
  105f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f5b:	83 c0 0c             	add    $0xc,%eax
  105f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  105f61:	4a                   	dec    %edx
  105f62:	c1 e2 03             	shl    $0x3,%edx
  105f65:	81 c2 a0 ff 11 00    	add    $0x11ffa0,%edx
  105f6b:	83 c2 04             	add    $0x4,%edx
  105f6e:	89 55 cc             	mov    %edx,-0x34(%ebp)
  105f71:	89 45 c8             	mov    %eax,-0x38(%ebp)
  105f74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105f77:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  105f7a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105f7d:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_add(elm, listelm, listelm->next);
  105f80:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105f83:	8b 40 04             	mov    0x4(%eax),%eax
  105f86:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105f89:	89 55 bc             	mov    %edx,-0x44(%ebp)
  105f8c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105f8f:	89 55 b8             	mov    %edx,-0x48(%ebp)
  105f92:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next->prev = elm;
  105f95:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105f98:	8b 55 bc             	mov    -0x44(%ebp),%edx
  105f9b:	89 10                	mov    %edx,(%eax)
  105f9d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105fa0:	8b 10                	mov    (%eax),%edx
  105fa2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  105fa5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  105fa8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105fab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  105fae:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  105fb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105fb4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  105fb7:	89 10                	mov    %edx,(%eax)
}
  105fb9:	90                   	nop
}
  105fba:	90                   	nop
}
  105fbb:	90                   	nop
    list_add(&(page_left->page_link), &(page_right->page_link));
  105fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fbf:	83 c0 0c             	add    $0xc,%eax
  105fc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fc5:	83 c2 0c             	add    $0xc,%edx
  105fc8:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105fd1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  105fda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105fdd:	8b 40 04             	mov    0x4(%eax),%eax
  105fe0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105fe3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  105fe6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105fe9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105fec:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  105fef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105ff2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105ff5:	89 10                	mov    %edx,(%eax)
  105ff7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105ffa:	8b 10                	mov    (%eax),%edx
  105ffc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105fff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  106002:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106005:	8b 55 d0             	mov    -0x30(%ebp),%edx
  106008:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10600b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10600e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106011:	89 10                	mov    %edx,(%eax)
}
  106013:	90                   	nop
}
  106014:	90                   	nop
}
  106015:	90                   	nop

    return;
  106016:	90                   	nop
}
  106017:	c9                   	leave  
  106018:	c3                   	ret    

00106019 <buddy_alloc_pages>:
 *  buddy_alloc_pages：分配指定大小的物理块
 *  参数：
 *  n： 指定物理块的大小（页）
 */
static struct Page *
buddy_alloc_pages(size_t n) {
  106019:	f3 0f 1e fb          	endbr32 
  10601d:	55                   	push   %ebp
  10601e:	89 e5                	mov    %esp,%ebp
  106020:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  106023:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  106027:	75 24                	jne    10604d <buddy_alloc_pages+0x34>
  106029:	c7 44 24 0c 1b 86 10 	movl   $0x10861b,0xc(%esp)
  106030:	00 
  106031:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  106038:	00 
  106039:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  106040:	00 
  106041:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  106048:	e8 e4 a3 ff ff       	call   100431 <__panic>
    if (n > nr_free) {
  10604d:	a1 1c 00 12 00       	mov    0x12001c,%eax
  106052:	39 45 08             	cmp    %eax,0x8(%ebp)
  106055:	76 0a                	jbe    106061 <buddy_alloc_pages+0x48>
        return NULL;
  106057:	b8 00 00 00 00       	mov    $0x0,%eax
  10605c:	e9 a6 01 00 00       	jmp    106207 <buddy_alloc_pages+0x1ee>
    }

    struct Page *page = NULL;
  106061:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    size_t pnum = ROUNDUP2(n);  
  106068:	8b 45 08             	mov    0x8(%ebp),%eax
  10606b:	89 04 24             	mov    %eax,(%esp)
  10606e:	e8 a6 fa ff ff       	call   105b19 <ROUNDUP2>
  106073:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t order = getOrderOf2(pnum);
  106076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106079:	89 04 24             	mov    %eax,(%esp)
  10607c:	e8 37 fa ff ff       	call   105ab8 <getOrderOf2>
  106081:	89 45 e8             	mov    %eax,-0x18(%ebp)
    cprintf("[!]BS: Allocating %d-->%d = 2^%d pages ...\n", n, pnum, order);
  106084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10608b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10608e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106092:	8b 45 08             	mov    0x8(%ebp),%eax
  106095:	89 44 24 04          	mov    %eax,0x4(%esp)
  106099:	c7 04 24 28 87 10 00 	movl   $0x108728,(%esp)
  1060a0:	e8 20 a2 ff ff       	call   1002c5 <cprintf>
    cprintf("[!]BS: Buddy array before ALLOC:\n");
  1060a5:	c7 04 24 54 87 10 00 	movl   $0x108754,(%esp)
  1060ac:	e8 14 a2 ff ff       	call   1002c5 <cprintf>
    show_buddy_array();
  1060b1:	e8 9b fa ff ff       	call   105b51 <show_buddy_array>

// 若order对应的链表中含有空闲块，则直接分配
find:
    if (!list_empty(&(buddy_array[order]))) {
  1060b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060b9:	c1 e0 03             	shl    $0x3,%eax
  1060bc:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  1060c1:	83 c0 04             	add    $0x4,%eax
  1060c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return list->next == list;
  1060c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060ca:	8b 40 04             	mov    0x4(%eax),%eax
  1060cd:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1060d0:	0f 94 c0             	sete   %al
  1060d3:	0f b6 c0             	movzbl %al,%eax
  1060d6:	85 c0                	test   %eax,%eax
  1060d8:	0f 85 97 00 00 00    	jne    106175 <buddy_alloc_pages+0x15c>
        page = le2page(list_next(&(buddy_array[order])), page_link);
  1060de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060e1:	c1 e0 03             	shl    $0x3,%eax
  1060e4:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  1060e9:	83 c0 04             	add    $0x4,%eax
  1060ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return listelm->next;
  1060ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1060f2:	8b 40 04             	mov    0x4(%eax),%eax
  1060f5:	83 e8 0c             	sub    $0xc,%eax
  1060f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        list_del(list_next(&(buddy_array[order])));
  1060fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1060fe:	c1 e0 03             	shl    $0x3,%eax
  106101:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  106106:	83 c0 04             	add    $0x4,%eax
  106109:	89 45 cc             	mov    %eax,-0x34(%ebp)
  10610c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10610f:	8b 40 04             	mov    0x4(%eax),%eax
  106112:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_del(listelm->prev, listelm->next);
  106115:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106118:	8b 40 04             	mov    0x4(%eax),%eax
  10611b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10611e:	8b 12                	mov    (%edx),%edx
  106120:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106123:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next;
  106126:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  106129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10612c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10612f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106132:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106135:	89 10                	mov    %edx,(%eax)
}
  106137:	90                   	nop
}
  106138:	90                   	nop
        SetPageProperty(page); // 将分配块的头页设置为已被占用
  106139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10613c:	83 c0 04             	add    $0x4,%eax
  10613f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  106146:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  106149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10614c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10614f:	0f ab 10             	bts    %edx,(%eax)
}
  106152:	90                   	nop
        cprintf("[!]BS: Buddy array after ALLOC NO.%d page:\n", page2ppn(page));
  106153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106156:	89 04 24             	mov    %eax,(%esp)
  106159:	e8 12 f9 ff ff       	call   105a70 <page2ppn>
  10615e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106162:	c7 04 24 78 87 10 00 	movl   $0x108778,(%esp)
  106169:	e8 57 a1 ff ff       	call   1002c5 <cprintf>
        show_buddy_array();
  10616e:	e8 de f9 ff ff       	call   105b51 <show_buddy_array>
        goto done; 
  106173:	eb 61                	jmp    1061d6 <buddy_alloc_pages+0x1bd>
    }

//buddy_array[order] is empty,go to top array to split
    for (int i = order + 1;i < max_order + 1;i ++) {
  106175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106178:	40                   	inc    %eax
  106179:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10617c:	eb 48                	jmp    1061c6 <buddy_alloc_pages+0x1ad>
        if (!list_empty(&(buddy_array[i]))) {
  10617e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106181:	c1 e0 03             	shl    $0x3,%eax
  106184:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  106189:	83 c0 04             	add    $0x4,%eax
  10618c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return list->next == list;
  10618f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  106192:	8b 40 04             	mov    0x4(%eax),%eax
  106195:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
  106198:	0f 94 c0             	sete   %al
  10619b:	0f b6 c0             	movzbl %al,%eax
  10619e:	85 c0                	test   %eax,%eax
  1061a0:	75 21                	jne    1061c3 <buddy_alloc_pages+0x1aa>
            buddy_split(i);
  1061a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061a5:	89 04 24             	mov    %eax,(%esp)
  1061a8:	e8 91 fc ff ff       	call   105e3e <buddy_split>
            cprintf("[!]BS: Buddy array after SPLITT:\n");
  1061ad:	c7 04 24 a4 87 10 00 	movl   $0x1087a4,(%esp)
  1061b4:	e8 0c a1 ff ff       	call   1002c5 <cprintf>
            show_buddy_array();
  1061b9:	e8 93 f9 ff ff       	call   105b51 <show_buddy_array>
            goto find;
  1061be:	e9 f3 fe ff ff       	jmp    1060b6 <buddy_alloc_pages+0x9d>
    for (int i = order + 1;i < max_order + 1;i ++) {
  1061c3:	ff 45 f0             	incl   -0x10(%ebp)
  1061c6:	a1 a0 ff 11 00       	mov    0x11ffa0,%eax
  1061cb:	8d 50 01             	lea    0x1(%eax),%edx
  1061ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061d1:	39 c2                	cmp    %eax,%edx
  1061d3:	77 a9                	ja     10617e <buddy_alloc_pages+0x165>
        }
    }

done:
  1061d5:	90                   	nop
    nr_free -= pnum;
  1061d6:	a1 1c 00 12 00       	mov    0x12001c,%eax
  1061db:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1061de:	a3 1c 00 12 00       	mov    %eax,0x12001c
    cprintf("[!]BS: nr_free: %d\n", nr_free);
  1061e3:	a1 1c 00 12 00       	mov    0x12001c,%eax
  1061e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061ec:	c7 04 24 c6 87 10 00 	movl   $0x1087c6,(%esp)
  1061f3:	e8 cd a0 ff ff       	call   1002c5 <cprintf>
    cprintf("---------------------------\n");
  1061f8:	c7 04 24 e3 85 10 00 	movl   $0x1085e3,(%esp)
  1061ff:	e8 c1 a0 ff ff       	call   1002c5 <cprintf>
    return page;
  106204:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106207:	c9                   	leave  
  106208:	c3                   	ret    

00106209 <buddy_get_buddy>:

/*
 *  获取以page页为头页的块的伙伴块
 */
static struct Page*
buddy_get_buddy(struct Page *page) {
  106209:	f3 0f 1e fb          	endbr32 
  10620d:	55                   	push   %ebp
  10620e:	89 e5                	mov    %esp,%ebp
  106210:	53                   	push   %ebx
  106211:	83 ec 24             	sub    $0x24,%esp
    unsigned int order = page->property;
  106214:	8b 45 08             	mov    0x8(%ebp),%eax
  106217:	8b 40 08             	mov    0x8(%eax),%eax
  10621a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    unsigned int buddy_ppn = first_ppn + ((1 << order) ^ (page2ppn(page) - first_ppn)); // first_ppn是在ppm.c中新声明的全局变量，表示第一个可分配物理内存页的下标
  10621d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106220:	ba 01 00 00 00       	mov    $0x1,%edx
  106225:	88 c1                	mov    %al,%cl
  106227:	d3 e2                	shl    %cl,%edx
  106229:	89 d0                	mov    %edx,%eax
  10622b:	89 c3                	mov    %eax,%ebx
  10622d:	8b 45 08             	mov    0x8(%ebp),%eax
  106230:	89 04 24             	mov    %eax,(%esp)
  106233:	e8 38 f8 ff ff       	call   105a70 <page2ppn>
  106238:	8b 15 0c ff 11 00    	mov    0x11ff0c,%edx
  10623e:	29 d0                	sub    %edx,%eax
  106240:	31 c3                	xor    %eax,%ebx
  106242:	89 da                	mov    %ebx,%edx
  106244:	a1 0c ff 11 00       	mov    0x11ff0c,%eax
  106249:	01 d0                	add    %edx,%eax
  10624b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cprintf("[!]BS: Page NO.%d 's buddy page on order %d is: %d\n", page2ppn(page), order, buddy_ppn);
  10624e:	8b 45 08             	mov    0x8(%ebp),%eax
  106251:	89 04 24             	mov    %eax,(%esp)
  106254:	e8 17 f8 ff ff       	call   105a70 <page2ppn>
  106259:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10625c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106260:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106263:	89 54 24 08          	mov    %edx,0x8(%esp)
  106267:	89 44 24 04          	mov    %eax,0x4(%esp)
  10626b:	c7 04 24 dc 87 10 00 	movl   $0x1087dc,(%esp)
  106272:	e8 4e a0 ff ff       	call   1002c5 <cprintf>
    if (buddy_ppn > page2ppn(page)) {
  106277:	8b 45 08             	mov    0x8(%ebp),%eax
  10627a:	89 04 24             	mov    %eax,(%esp)
  10627d:	e8 ee f7 ff ff       	call   105a70 <page2ppn>
  106282:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  106285:	76 23                	jbe    1062aa <buddy_get_buddy+0xa1>
        return page + (buddy_ppn - page2ppn(page));
  106287:	8b 45 08             	mov    0x8(%ebp),%eax
  10628a:	89 04 24             	mov    %eax,(%esp)
  10628d:	e8 de f7 ff ff       	call   105a70 <page2ppn>
  106292:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106295:	29 c2                	sub    %eax,%edx
  106297:	89 d0                	mov    %edx,%eax
  106299:	c1 e0 02             	shl    $0x2,%eax
  10629c:	01 d0                	add    %edx,%eax
  10629e:	c1 e0 02             	shl    $0x2,%eax
  1062a1:	89 c2                	mov    %eax,%edx
  1062a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1062a6:	01 d0                	add    %edx,%eax
  1062a8:	eb 23                	jmp    1062cd <buddy_get_buddy+0xc4>
    }
    else {
        return page - (page2ppn(page) - buddy_ppn);
  1062aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1062ad:	89 04 24             	mov    %eax,(%esp)
  1062b0:	e8 bb f7 ff ff       	call   105a70 <page2ppn>
  1062b5:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1062b8:	89 c2                	mov    %eax,%edx
  1062ba:	89 d0                	mov    %edx,%eax
  1062bc:	c1 e0 02             	shl    $0x2,%eax
  1062bf:	01 d0                	add    %edx,%eax
  1062c1:	c1 e0 02             	shl    $0x2,%eax
  1062c4:	f7 d8                	neg    %eax
  1062c6:	89 c2                	mov    %eax,%edx
  1062c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1062cb:	01 d0                	add    %edx,%eax
    }
 
}
  1062cd:	83 c4 24             	add    $0x24,%esp
  1062d0:	5b                   	pop    %ebx
  1062d1:	5d                   	pop    %ebp
  1062d2:	c3                   	ret    

001062d3 <buddy_free_pages>:
 *  参数：
 *  base：所释放物理块的头页
 *  n： 所释放物理块的的大小（页）
 */
static void
buddy_free_pages(struct Page *base, size_t n) {
  1062d3:	f3 0f 1e fb          	endbr32 
  1062d7:	55                   	push   %ebp
  1062d8:	89 e5                	mov    %esp,%ebp
  1062da:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  1062e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1062e4:	75 24                	jne    10630a <buddy_free_pages+0x37>
  1062e6:	c7 44 24 0c 1b 86 10 	movl   $0x10861b,0xc(%esp)
  1062ed:	00 
  1062ee:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  1062f5:	00 
  1062f6:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1062fd:	00 
  1062fe:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  106305:	e8 27 a1 ff ff       	call   100431 <__panic>
    unsigned int pnum = 1 << (base->property);
  10630a:	8b 45 08             	mov    0x8(%ebp),%eax
  10630d:	8b 40 08             	mov    0x8(%eax),%eax
  106310:	ba 01 00 00 00       	mov    $0x1,%edx
  106315:	88 c1                	mov    %al,%cl
  106317:	d3 e2                	shl    %cl,%edx
  106319:	89 d0                	mov    %edx,%eax
  10631b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(ROUNDUP2(n) == pnum);
  10631e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106321:	89 04 24             	mov    %eax,(%esp)
  106324:	e8 f0 f7 ff ff       	call   105b19 <ROUNDUP2>
  106329:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10632c:	74 24                	je     106352 <buddy_free_pages+0x7f>
  10632e:	c7 44 24 0c 10 88 10 	movl   $0x108810,0xc(%esp)
  106335:	00 
  106336:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  10633d:	00 
  10633e:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  106345:	00 
  106346:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  10634d:	e8 df a0 ff ff       	call   100431 <__panic>
    cprintf("[!]BS: Freeing NO.%d page leading %d pages block: \n", page2ppn(base), pnum);
  106352:	8b 45 08             	mov    0x8(%ebp),%eax
  106355:	89 04 24             	mov    %eax,(%esp)
  106358:	e8 13 f7 ff ff       	call   105a70 <page2ppn>
  10635d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106360:	89 54 24 08          	mov    %edx,0x8(%esp)
  106364:	89 44 24 04          	mov    %eax,0x4(%esp)
  106368:	c7 04 24 24 88 10 00 	movl   $0x108824,(%esp)
  10636f:	e8 51 9f ff ff       	call   1002c5 <cprintf>
    
    struct Page* left_block = base;
  106374:	8b 45 08             	mov    0x8(%ebp),%eax
  106377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page *buddy = NULL;
  10637a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    struct Page* tmp = NULL;
  106381:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    list_add(&(buddy_array[left_block->property]), &(left_block->page_link)); // 将当前块先插入对应链表中
  106388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10638b:	8d 50 0c             	lea    0xc(%eax),%edx
  10638e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106391:	8b 40 08             	mov    0x8(%eax),%eax
  106394:	c1 e0 03             	shl    $0x3,%eax
  106397:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  10639c:	83 c0 04             	add    $0x4,%eax
  10639f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1063a2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1063a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1063ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1063ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_add(elm, listelm, listelm->next);
  1063b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1063b4:	8b 40 04             	mov    0x4(%eax),%eax
  1063b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1063ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1063bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1063c0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1063c3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    prev->next = next->prev = elm;
  1063c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1063c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1063cc:	89 10                	mov    %edx,(%eax)
  1063ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1063d1:	8b 10                	mov    (%eax),%edx
  1063d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1063d6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1063d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1063dc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1063df:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1063e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1063e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1063e8:	89 10                	mov    %edx,(%eax)
}
  1063ea:	90                   	nop
}
  1063eb:	90                   	nop
}
  1063ec:	90                   	nop
    cprintf("[!]BS: add to list\n");
  1063ed:	c7 04 24 58 88 10 00 	movl   $0x108858,(%esp)
  1063f4:	e8 cc 9e ff ff       	call   1002c5 <cprintf>
    show_buddy_array();
  1063f9:	e8 53 f7 ff ff       	call   105b51 <show_buddy_array>

    buddy = buddy_get_buddy(left_block);
  1063fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106401:	89 04 24             	mov    %eax,(%esp)
  106404:	e8 00 fe ff ff       	call   106209 <buddy_get_buddy>
  106409:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (!PageProperty(buddy) && left_block->property < max_order) {
  10640c:	e9 2b 01 00 00       	jmp    10653c <buddy_free_pages+0x269>
        cprintf("[!]BS: Buddy free, MERGING!\n");
  106411:	c7 04 24 6c 88 10 00 	movl   $0x10886c,(%esp)
  106418:	e8 a8 9e ff ff       	call   1002c5 <cprintf>

        //make sure that free the buddy,so left_block must be at lower address
        if (left_block > buddy) {
  10641d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106420:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  106423:	76 36                	jbe    10645b <buddy_free_pages+0x188>
            left_block->property = -1;
  106425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106428:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
            ClearPageProperty(left_block);
  10642f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106432:	83 c0 04             	add    $0x4,%eax
  106435:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  10643c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10643f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  106442:	8b 55 c8             	mov    -0x38(%ebp),%edx
  106445:	0f b3 10             	btr    %edx,(%eax)
}
  106448:	90                   	nop
            tmp = left_block;
  106449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10644c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            left_block = buddy;
  10644f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106452:	89 45 f4             	mov    %eax,-0xc(%ebp)
            buddy = tmp;
  106455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106458:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }

        list_del(&(left_block->page_link));    
  10645b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10645e:	83 c0 0c             	add    $0xc,%eax
  106461:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_del(listelm->prev, listelm->next);
  106464:	8b 45 98             	mov    -0x68(%ebp),%eax
  106467:	8b 40 04             	mov    0x4(%eax),%eax
  10646a:	8b 55 98             	mov    -0x68(%ebp),%edx
  10646d:	8b 12                	mov    (%edx),%edx
  10646f:	89 55 94             	mov    %edx,-0x6c(%ebp)
  106472:	89 45 90             	mov    %eax,-0x70(%ebp)
    prev->next = next;
  106475:	8b 45 94             	mov    -0x6c(%ebp),%eax
  106478:	8b 55 90             	mov    -0x70(%ebp),%edx
  10647b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10647e:	8b 45 90             	mov    -0x70(%ebp),%eax
  106481:	8b 55 94             	mov    -0x6c(%ebp),%edx
  106484:	89 10                	mov    %edx,(%eax)
}
  106486:	90                   	nop
}
  106487:	90                   	nop
        list_del(&(buddy->page_link));
  106488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10648b:	83 c0 0c             	add    $0xc,%eax
  10648e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    __list_del(listelm->prev, listelm->next);
  106491:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  106494:	8b 40 04             	mov    0x4(%eax),%eax
  106497:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10649a:	8b 12                	mov    (%edx),%edx
  10649c:	89 55 a0             	mov    %edx,-0x60(%ebp)
  10649f:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next;
  1064a2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1064a5:	8b 55 9c             	mov    -0x64(%ebp),%edx
  1064a8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1064ab:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1064ae:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1064b1:	89 10                	mov    %edx,(%eax)
}
  1064b3:	90                   	nop
}
  1064b4:	90                   	nop
        left_block->property += 1;
  1064b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064b8:	8b 40 08             	mov    0x8(%eax),%eax
  1064bb:	8d 50 01             	lea    0x1(%eax),%edx
  1064be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064c1:	89 50 08             	mov    %edx,0x8(%eax)
        list_add(&(buddy_array[left_block->property]), &(left_block->page_link)); // 头插入相应链表
  1064c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064c7:	8d 50 0c             	lea    0xc(%eax),%edx
  1064ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064cd:	8b 40 08             	mov    0x8(%eax),%eax
  1064d0:	c1 e0 03             	shl    $0x3,%eax
  1064d3:	05 a0 ff 11 00       	add    $0x11ffa0,%eax
  1064d8:	83 c0 04             	add    $0x4,%eax
  1064db:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1064de:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1064e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1064e4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1064e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1064ea:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_add(elm, listelm, listelm->next);
  1064ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1064f0:	8b 40 04             	mov    0x4(%eax),%eax
  1064f3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1064f6:	89 55 b0             	mov    %edx,-0x50(%ebp)
  1064f9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1064fc:	89 55 ac             	mov    %edx,-0x54(%ebp)
  1064ff:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next->prev = elm;
  106502:	8b 45 a8             	mov    -0x58(%ebp),%eax
  106505:	8b 55 b0             	mov    -0x50(%ebp),%edx
  106508:	89 10                	mov    %edx,(%eax)
  10650a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10650d:	8b 10                	mov    (%eax),%edx
  10650f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  106512:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  106515:	8b 45 b0             	mov    -0x50(%ebp),%eax
  106518:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10651b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10651e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  106521:	8b 55 ac             	mov    -0x54(%ebp),%edx
  106524:	89 10                	mov    %edx,(%eax)
}
  106526:	90                   	nop
}
  106527:	90                   	nop
}
  106528:	90                   	nop
        show_buddy_array();
  106529:	e8 23 f6 ff ff       	call   105b51 <show_buddy_array>
        buddy = buddy_get_buddy(left_block);
  10652e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106531:	89 04 24             	mov    %eax,(%esp)
  106534:	e8 d0 fc ff ff       	call   106209 <buddy_get_buddy>
  106539:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (!PageProperty(buddy) && left_block->property < max_order) {
  10653c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10653f:	83 c0 04             	add    $0x4,%eax
  106542:	c7 45 8c 01 00 00 00 	movl   $0x1,-0x74(%ebp)
  106549:	89 45 88             	mov    %eax,-0x78(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10654c:	8b 45 88             	mov    -0x78(%ebp),%eax
  10654f:	8b 55 8c             	mov    -0x74(%ebp),%edx
  106552:	0f a3 10             	bt     %edx,(%eax)
  106555:	19 c0                	sbb    %eax,%eax
  106557:	89 45 84             	mov    %eax,-0x7c(%ebp)
    return oldbit != 0;
  10655a:	83 7d 84 00          	cmpl   $0x0,-0x7c(%ebp)
  10655e:	0f 95 c0             	setne  %al
  106561:	0f b6 c0             	movzbl %al,%eax
  106564:	85 c0                	test   %eax,%eax
  106566:	75 13                	jne    10657b <buddy_free_pages+0x2a8>
  106568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10656b:	8b 50 08             	mov    0x8(%eax),%edx
  10656e:	a1 a0 ff 11 00       	mov    0x11ffa0,%eax
  106573:	39 c2                	cmp    %eax,%edx
  106575:	0f 82 96 fe ff ff    	jb     106411 <buddy_free_pages+0x13e>
    }
    cprintf("[!]BS: Buddy array after FREE:\n");
  10657b:	c7 04 24 8c 88 10 00 	movl   $0x10888c,(%esp)
  106582:	e8 3e 9d ff ff       	call   1002c5 <cprintf>
    ClearPageProperty(left_block); // 将回收块的头页设置为空闲
  106587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10658a:	83 c0 04             	add    $0x4,%eax
  10658d:	c7 45 80 01 00 00 00 	movl   $0x1,-0x80(%ebp)
  106594:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10659a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1065a0:	8b 55 80             	mov    -0x80(%ebp),%edx
  1065a3:	0f b3 10             	btr    %edx,(%eax)
}
  1065a6:	90                   	nop
    nr_free += pnum;
  1065a7:	8b 15 1c 00 12 00    	mov    0x12001c,%edx
  1065ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1065b0:	01 d0                	add    %edx,%eax
  1065b2:	a3 1c 00 12 00       	mov    %eax,0x12001c
    show_buddy_array();
  1065b7:	e8 95 f5 ff ff       	call   105b51 <show_buddy_array>
    cprintf("[!]BS: nr_free: %d\n", nr_free);
  1065bc:	a1 1c 00 12 00       	mov    0x12001c,%eax
  1065c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065c5:	c7 04 24 c6 87 10 00 	movl   $0x1087c6,(%esp)
  1065cc:	e8 f4 9c ff ff       	call   1002c5 <cprintf>
    
    return;
  1065d1:	90                   	nop
}
  1065d2:	c9                   	leave  
  1065d3:	c3                   	ret    

001065d4 <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  1065d4:	f3 0f 1e fb          	endbr32 
  1065d8:	55                   	push   %ebp
  1065d9:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1065db:	a1 1c 00 12 00       	mov    0x12001c,%eax
}//返回还剩多少页可以分
  1065e0:	5d                   	pop    %ebp
  1065e1:	c3                   	ret    

001065e2 <basic_check>:


static void
basic_check(void) {
  1065e2:	f3 0f 1e fb          	endbr32 
  1065e6:	55                   	push   %ebp
  1065e7:	89 e5                	mov    %esp,%ebp
  1065e9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1065ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1065f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1065f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1065fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1065ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106606:	e8 04 cb ff ff       	call   10310f <alloc_pages>
  10660b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10660e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  106612:	75 24                	jne    106638 <basic_check+0x56>
  106614:	c7 44 24 0c ac 88 10 	movl   $0x1088ac,0xc(%esp)
  10661b:	00 
  10661c:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  106623:	00 
  106624:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10662b:	00 
  10662c:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  106633:	e8 f9 9d ff ff       	call   100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
  106638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10663f:	e8 cb ca ff ff       	call   10310f <alloc_pages>
  106644:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106647:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10664b:	75 24                	jne    106671 <basic_check+0x8f>
  10664d:	c7 44 24 0c c8 88 10 	movl   $0x1088c8,0xc(%esp)
  106654:	00 
  106655:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  10665c:	00 
  10665d:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  106664:	00 
  106665:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  10666c:	e8 c0 9d ff ff       	call   100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
  106671:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106678:	e8 92 ca ff ff       	call   10310f <alloc_pages>
  10667d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  106684:	75 24                	jne    1066aa <basic_check+0xc8>
  106686:	c7 44 24 0c e4 88 10 	movl   $0x1088e4,0xc(%esp)
  10668d:	00 
  10668e:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  106695:	00 
  106696:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  10669d:	00 
  10669e:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  1066a5:	e8 87 9d ff ff       	call   100431 <__panic>
    free_page(p0);
  1066aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1066b1:	00 
  1066b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1066b5:	89 04 24             	mov    %eax,(%esp)
  1066b8:	e8 8e ca ff ff       	call   10314b <free_pages>
    free_page(p1);
  1066bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1066c4:	00 
  1066c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1066c8:	89 04 24             	mov    %eax,(%esp)
  1066cb:	e8 7b ca ff ff       	call   10314b <free_pages>
    free_page(p2);
  1066d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1066d7:	00 
  1066d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1066db:	89 04 24             	mov    %eax,(%esp)
  1066de:	e8 68 ca ff ff       	call   10314b <free_pages>
    show_buddy_array();
  1066e3:	e8 69 f4 ff ff       	call   105b51 <show_buddy_array>

    assert((p0 = alloc_pages(4)) != NULL);
  1066e8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1066ef:	e8 1b ca ff ff       	call   10310f <alloc_pages>
  1066f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1066f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1066fb:	75 24                	jne    106721 <basic_check+0x13f>
  1066fd:	c7 44 24 0c 00 89 10 	movl   $0x108900,0xc(%esp)
  106704:	00 
  106705:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  10670c:	00 
  10670d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  106714:	00 
  106715:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  10671c:	e8 10 9d ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(2)) != NULL);
  106721:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  106728:	e8 e2 c9 ff ff       	call   10310f <alloc_pages>
  10672d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106730:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106734:	75 24                	jne    10675a <basic_check+0x178>
  106736:	c7 44 24 0c 1e 89 10 	movl   $0x10891e,0xc(%esp)
  10673d:	00 
  10673e:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  106745:	00 
  106746:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  10674d:	00 
  10674e:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  106755:	e8 d7 9c ff ff       	call   100431 <__panic>
    assert((p2 = alloc_pages(1)) != NULL);
  10675a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106761:	e8 a9 c9 ff ff       	call   10310f <alloc_pages>
  106766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10676d:	75 24                	jne    106793 <basic_check+0x1b1>
  10676f:	c7 44 24 0c 3c 89 10 	movl   $0x10893c,0xc(%esp)
  106776:	00 
  106777:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  10677e:	00 
  10677f:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  106786:	00 
  106787:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  10678e:	e8 9e 9c ff ff       	call   100431 <__panic>
    free_pages(p0, 4);
  106793:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  10679a:	00 
  10679b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10679e:	89 04 24             	mov    %eax,(%esp)
  1067a1:	e8 a5 c9 ff ff       	call   10314b <free_pages>
    free_pages(p1, 2);
  1067a6:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1067ad:	00 
  1067ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1067b1:	89 04 24             	mov    %eax,(%esp)
  1067b4:	e8 92 c9 ff ff       	call   10314b <free_pages>
    free_pages(p2, 1);
  1067b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1067c0:	00 
  1067c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1067c4:	89 04 24             	mov    %eax,(%esp)
  1067c7:	e8 7f c9 ff ff       	call   10314b <free_pages>
    show_buddy_array();
  1067cc:	e8 80 f3 ff ff       	call   105b51 <show_buddy_array>

    assert((p0 = alloc_pages(3)) != NULL);
  1067d1:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1067d8:	e8 32 c9 ff ff       	call   10310f <alloc_pages>
  1067dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1067e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1067e4:	75 24                	jne    10680a <basic_check+0x228>
  1067e6:	c7 44 24 0c 5a 89 10 	movl   $0x10895a,0xc(%esp)
  1067ed:	00 
  1067ee:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  1067f5:	00 
  1067f6:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  1067fd:	00 
  1067fe:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  106805:	e8 27 9c ff ff       	call   100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10680a:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  106811:	e8 f9 c8 ff ff       	call   10310f <alloc_pages>
  106816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106819:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10681d:	75 24                	jne    106843 <basic_check+0x261>
  10681f:	c7 44 24 0c 78 89 10 	movl   $0x108978,0xc(%esp)
  106826:	00 
  106827:	c7 44 24 08 21 86 10 	movl   $0x108621,0x8(%esp)
  10682e:	00 
  10682f:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  106836:	00 
  106837:	c7 04 24 36 86 10 00 	movl   $0x108636,(%esp)
  10683e:	e8 ee 9b ff ff       	call   100431 <__panic>
    free_pages(p0, 3);
  106843:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10684a:	00 
  10684b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10684e:	89 04 24             	mov    %eax,(%esp)
  106851:	e8 f5 c8 ff ff       	call   10314b <free_pages>
    free_pages(p1, 3);
  106856:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10685d:	00 
  10685e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106861:	89 04 24             	mov    %eax,(%esp)
  106864:	e8 e2 c8 ff ff       	call   10314b <free_pages>

    show_buddy_array();
  106869:	e8 e3 f2 ff ff       	call   105b51 <show_buddy_array>
}
  10686e:	90                   	nop
  10686f:	c9                   	leave  
  106870:	c3                   	ret    

00106871 <buddy_check>:
static void
buddy_check(void) {
  106871:	f3 0f 1e fb          	endbr32 
  106875:	55                   	push   %ebp
  106876:	89 e5                	mov    %esp,%ebp
  106878:	83 ec 08             	sub    $0x8,%esp
    basic_check();
  10687b:	e8 62 fd ff ff       	call   1065e2 <basic_check>
}   
  106880:	90                   	nop
  106881:	c9                   	leave  
  106882:	c3                   	ret    

00106883 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  106883:	f3 0f 1e fb          	endbr32 
  106887:	55                   	push   %ebp
  106888:	89 e5                	mov    %esp,%ebp
  10688a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10688d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  106894:	eb 03                	jmp    106899 <strlen+0x16>
        cnt ++;
  106896:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  106899:	8b 45 08             	mov    0x8(%ebp),%eax
  10689c:	8d 50 01             	lea    0x1(%eax),%edx
  10689f:	89 55 08             	mov    %edx,0x8(%ebp)
  1068a2:	0f b6 00             	movzbl (%eax),%eax
  1068a5:	84 c0                	test   %al,%al
  1068a7:	75 ed                	jne    106896 <strlen+0x13>
    }
    return cnt;
  1068a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1068ac:	c9                   	leave  
  1068ad:	c3                   	ret    

001068ae <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1068ae:	f3 0f 1e fb          	endbr32 
  1068b2:	55                   	push   %ebp
  1068b3:	89 e5                	mov    %esp,%ebp
  1068b5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1068b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1068bf:	eb 03                	jmp    1068c4 <strnlen+0x16>
        cnt ++;
  1068c1:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1068c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1068c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1068ca:	73 10                	jae    1068dc <strnlen+0x2e>
  1068cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1068cf:	8d 50 01             	lea    0x1(%eax),%edx
  1068d2:	89 55 08             	mov    %edx,0x8(%ebp)
  1068d5:	0f b6 00             	movzbl (%eax),%eax
  1068d8:	84 c0                	test   %al,%al
  1068da:	75 e5                	jne    1068c1 <strnlen+0x13>
    }
    return cnt;
  1068dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1068df:	c9                   	leave  
  1068e0:	c3                   	ret    

001068e1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1068e1:	f3 0f 1e fb          	endbr32 
  1068e5:	55                   	push   %ebp
  1068e6:	89 e5                	mov    %esp,%ebp
  1068e8:	57                   	push   %edi
  1068e9:	56                   	push   %esi
  1068ea:	83 ec 20             	sub    $0x20,%esp
  1068ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1068f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1068f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1068f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1068f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1068fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1068ff:	89 d1                	mov    %edx,%ecx
  106901:	89 c2                	mov    %eax,%edx
  106903:	89 ce                	mov    %ecx,%esi
  106905:	89 d7                	mov    %edx,%edi
  106907:	ac                   	lods   %ds:(%esi),%al
  106908:	aa                   	stos   %al,%es:(%edi)
  106909:	84 c0                	test   %al,%al
  10690b:	75 fa                	jne    106907 <strcpy+0x26>
  10690d:	89 fa                	mov    %edi,%edx
  10690f:	89 f1                	mov    %esi,%ecx
  106911:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106914:	89 55 e8             	mov    %edx,-0x18(%ebp)
  106917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10691a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10691d:	83 c4 20             	add    $0x20,%esp
  106920:	5e                   	pop    %esi
  106921:	5f                   	pop    %edi
  106922:	5d                   	pop    %ebp
  106923:	c3                   	ret    

00106924 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  106924:	f3 0f 1e fb          	endbr32 
  106928:	55                   	push   %ebp
  106929:	89 e5                	mov    %esp,%ebp
  10692b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10692e:	8b 45 08             	mov    0x8(%ebp),%eax
  106931:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  106934:	eb 1e                	jmp    106954 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  106936:	8b 45 0c             	mov    0xc(%ebp),%eax
  106939:	0f b6 10             	movzbl (%eax),%edx
  10693c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10693f:	88 10                	mov    %dl,(%eax)
  106941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106944:	0f b6 00             	movzbl (%eax),%eax
  106947:	84 c0                	test   %al,%al
  106949:	74 03                	je     10694e <strncpy+0x2a>
            src ++;
  10694b:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10694e:	ff 45 fc             	incl   -0x4(%ebp)
  106951:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  106954:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106958:	75 dc                	jne    106936 <strncpy+0x12>
    }
    return dst;
  10695a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10695d:	c9                   	leave  
  10695e:	c3                   	ret    

0010695f <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10695f:	f3 0f 1e fb          	endbr32 
  106963:	55                   	push   %ebp
  106964:	89 e5                	mov    %esp,%ebp
  106966:	57                   	push   %edi
  106967:	56                   	push   %esi
  106968:	83 ec 20             	sub    $0x20,%esp
  10696b:	8b 45 08             	mov    0x8(%ebp),%eax
  10696e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106971:	8b 45 0c             	mov    0xc(%ebp),%eax
  106974:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  106977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10697a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10697d:	89 d1                	mov    %edx,%ecx
  10697f:	89 c2                	mov    %eax,%edx
  106981:	89 ce                	mov    %ecx,%esi
  106983:	89 d7                	mov    %edx,%edi
  106985:	ac                   	lods   %ds:(%esi),%al
  106986:	ae                   	scas   %es:(%edi),%al
  106987:	75 08                	jne    106991 <strcmp+0x32>
  106989:	84 c0                	test   %al,%al
  10698b:	75 f8                	jne    106985 <strcmp+0x26>
  10698d:	31 c0                	xor    %eax,%eax
  10698f:	eb 04                	jmp    106995 <strcmp+0x36>
  106991:	19 c0                	sbb    %eax,%eax
  106993:	0c 01                	or     $0x1,%al
  106995:	89 fa                	mov    %edi,%edx
  106997:	89 f1                	mov    %esi,%ecx
  106999:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10699c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10699f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1069a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1069a5:	83 c4 20             	add    $0x20,%esp
  1069a8:	5e                   	pop    %esi
  1069a9:	5f                   	pop    %edi
  1069aa:	5d                   	pop    %ebp
  1069ab:	c3                   	ret    

001069ac <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1069ac:	f3 0f 1e fb          	endbr32 
  1069b0:	55                   	push   %ebp
  1069b1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1069b3:	eb 09                	jmp    1069be <strncmp+0x12>
        n --, s1 ++, s2 ++;
  1069b5:	ff 4d 10             	decl   0x10(%ebp)
  1069b8:	ff 45 08             	incl   0x8(%ebp)
  1069bb:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1069be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1069c2:	74 1a                	je     1069de <strncmp+0x32>
  1069c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1069c7:	0f b6 00             	movzbl (%eax),%eax
  1069ca:	84 c0                	test   %al,%al
  1069cc:	74 10                	je     1069de <strncmp+0x32>
  1069ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1069d1:	0f b6 10             	movzbl (%eax),%edx
  1069d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069d7:	0f b6 00             	movzbl (%eax),%eax
  1069da:	38 c2                	cmp    %al,%dl
  1069dc:	74 d7                	je     1069b5 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1069de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1069e2:	74 18                	je     1069fc <strncmp+0x50>
  1069e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1069e7:	0f b6 00             	movzbl (%eax),%eax
  1069ea:	0f b6 d0             	movzbl %al,%edx
  1069ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1069f0:	0f b6 00             	movzbl (%eax),%eax
  1069f3:	0f b6 c0             	movzbl %al,%eax
  1069f6:	29 c2                	sub    %eax,%edx
  1069f8:	89 d0                	mov    %edx,%eax
  1069fa:	eb 05                	jmp    106a01 <strncmp+0x55>
  1069fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106a01:	5d                   	pop    %ebp
  106a02:	c3                   	ret    

00106a03 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  106a03:	f3 0f 1e fb          	endbr32 
  106a07:	55                   	push   %ebp
  106a08:	89 e5                	mov    %esp,%ebp
  106a0a:	83 ec 04             	sub    $0x4,%esp
  106a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a10:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106a13:	eb 13                	jmp    106a28 <strchr+0x25>
        if (*s == c) {
  106a15:	8b 45 08             	mov    0x8(%ebp),%eax
  106a18:	0f b6 00             	movzbl (%eax),%eax
  106a1b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106a1e:	75 05                	jne    106a25 <strchr+0x22>
            return (char *)s;
  106a20:	8b 45 08             	mov    0x8(%ebp),%eax
  106a23:	eb 12                	jmp    106a37 <strchr+0x34>
        }
        s ++;
  106a25:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106a28:	8b 45 08             	mov    0x8(%ebp),%eax
  106a2b:	0f b6 00             	movzbl (%eax),%eax
  106a2e:	84 c0                	test   %al,%al
  106a30:	75 e3                	jne    106a15 <strchr+0x12>
    }
    return NULL;
  106a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106a37:	c9                   	leave  
  106a38:	c3                   	ret    

00106a39 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  106a39:	f3 0f 1e fb          	endbr32 
  106a3d:	55                   	push   %ebp
  106a3e:	89 e5                	mov    %esp,%ebp
  106a40:	83 ec 04             	sub    $0x4,%esp
  106a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  106a46:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  106a49:	eb 0e                	jmp    106a59 <strfind+0x20>
        if (*s == c) {
  106a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  106a4e:	0f b6 00             	movzbl (%eax),%eax
  106a51:	38 45 fc             	cmp    %al,-0x4(%ebp)
  106a54:	74 0f                	je     106a65 <strfind+0x2c>
            break;
        }
        s ++;
  106a56:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  106a59:	8b 45 08             	mov    0x8(%ebp),%eax
  106a5c:	0f b6 00             	movzbl (%eax),%eax
  106a5f:	84 c0                	test   %al,%al
  106a61:	75 e8                	jne    106a4b <strfind+0x12>
  106a63:	eb 01                	jmp    106a66 <strfind+0x2d>
            break;
  106a65:	90                   	nop
    }
    return (char *)s;
  106a66:	8b 45 08             	mov    0x8(%ebp),%eax
}
  106a69:	c9                   	leave  
  106a6a:	c3                   	ret    

00106a6b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  106a6b:	f3 0f 1e fb          	endbr32 
  106a6f:	55                   	push   %ebp
  106a70:	89 e5                	mov    %esp,%ebp
  106a72:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  106a75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  106a7c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  106a83:	eb 03                	jmp    106a88 <strtol+0x1d>
        s ++;
  106a85:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  106a88:	8b 45 08             	mov    0x8(%ebp),%eax
  106a8b:	0f b6 00             	movzbl (%eax),%eax
  106a8e:	3c 20                	cmp    $0x20,%al
  106a90:	74 f3                	je     106a85 <strtol+0x1a>
  106a92:	8b 45 08             	mov    0x8(%ebp),%eax
  106a95:	0f b6 00             	movzbl (%eax),%eax
  106a98:	3c 09                	cmp    $0x9,%al
  106a9a:	74 e9                	je     106a85 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  106a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  106a9f:	0f b6 00             	movzbl (%eax),%eax
  106aa2:	3c 2b                	cmp    $0x2b,%al
  106aa4:	75 05                	jne    106aab <strtol+0x40>
        s ++;
  106aa6:	ff 45 08             	incl   0x8(%ebp)
  106aa9:	eb 14                	jmp    106abf <strtol+0x54>
    }
    else if (*s == '-') {
  106aab:	8b 45 08             	mov    0x8(%ebp),%eax
  106aae:	0f b6 00             	movzbl (%eax),%eax
  106ab1:	3c 2d                	cmp    $0x2d,%al
  106ab3:	75 0a                	jne    106abf <strtol+0x54>
        s ++, neg = 1;
  106ab5:	ff 45 08             	incl   0x8(%ebp)
  106ab8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  106abf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106ac3:	74 06                	je     106acb <strtol+0x60>
  106ac5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  106ac9:	75 22                	jne    106aed <strtol+0x82>
  106acb:	8b 45 08             	mov    0x8(%ebp),%eax
  106ace:	0f b6 00             	movzbl (%eax),%eax
  106ad1:	3c 30                	cmp    $0x30,%al
  106ad3:	75 18                	jne    106aed <strtol+0x82>
  106ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  106ad8:	40                   	inc    %eax
  106ad9:	0f b6 00             	movzbl (%eax),%eax
  106adc:	3c 78                	cmp    $0x78,%al
  106ade:	75 0d                	jne    106aed <strtol+0x82>
        s += 2, base = 16;
  106ae0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  106ae4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  106aeb:	eb 29                	jmp    106b16 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  106aed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106af1:	75 16                	jne    106b09 <strtol+0x9e>
  106af3:	8b 45 08             	mov    0x8(%ebp),%eax
  106af6:	0f b6 00             	movzbl (%eax),%eax
  106af9:	3c 30                	cmp    $0x30,%al
  106afb:	75 0c                	jne    106b09 <strtol+0x9e>
        s ++, base = 8;
  106afd:	ff 45 08             	incl   0x8(%ebp)
  106b00:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  106b07:	eb 0d                	jmp    106b16 <strtol+0xab>
    }
    else if (base == 0) {
  106b09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106b0d:	75 07                	jne    106b16 <strtol+0xab>
        base = 10;
  106b0f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  106b16:	8b 45 08             	mov    0x8(%ebp),%eax
  106b19:	0f b6 00             	movzbl (%eax),%eax
  106b1c:	3c 2f                	cmp    $0x2f,%al
  106b1e:	7e 1b                	jle    106b3b <strtol+0xd0>
  106b20:	8b 45 08             	mov    0x8(%ebp),%eax
  106b23:	0f b6 00             	movzbl (%eax),%eax
  106b26:	3c 39                	cmp    $0x39,%al
  106b28:	7f 11                	jg     106b3b <strtol+0xd0>
            dig = *s - '0';
  106b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  106b2d:	0f b6 00             	movzbl (%eax),%eax
  106b30:	0f be c0             	movsbl %al,%eax
  106b33:	83 e8 30             	sub    $0x30,%eax
  106b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b39:	eb 48                	jmp    106b83 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  106b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  106b3e:	0f b6 00             	movzbl (%eax),%eax
  106b41:	3c 60                	cmp    $0x60,%al
  106b43:	7e 1b                	jle    106b60 <strtol+0xf5>
  106b45:	8b 45 08             	mov    0x8(%ebp),%eax
  106b48:	0f b6 00             	movzbl (%eax),%eax
  106b4b:	3c 7a                	cmp    $0x7a,%al
  106b4d:	7f 11                	jg     106b60 <strtol+0xf5>
            dig = *s - 'a' + 10;
  106b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  106b52:	0f b6 00             	movzbl (%eax),%eax
  106b55:	0f be c0             	movsbl %al,%eax
  106b58:	83 e8 57             	sub    $0x57,%eax
  106b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106b5e:	eb 23                	jmp    106b83 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106b60:	8b 45 08             	mov    0x8(%ebp),%eax
  106b63:	0f b6 00             	movzbl (%eax),%eax
  106b66:	3c 40                	cmp    $0x40,%al
  106b68:	7e 3b                	jle    106ba5 <strtol+0x13a>
  106b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  106b6d:	0f b6 00             	movzbl (%eax),%eax
  106b70:	3c 5a                	cmp    $0x5a,%al
  106b72:	7f 31                	jg     106ba5 <strtol+0x13a>
            dig = *s - 'A' + 10;
  106b74:	8b 45 08             	mov    0x8(%ebp),%eax
  106b77:	0f b6 00             	movzbl (%eax),%eax
  106b7a:	0f be c0             	movsbl %al,%eax
  106b7d:	83 e8 37             	sub    $0x37,%eax
  106b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b86:	3b 45 10             	cmp    0x10(%ebp),%eax
  106b89:	7d 19                	jge    106ba4 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  106b8b:	ff 45 08             	incl   0x8(%ebp)
  106b8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106b91:	0f af 45 10          	imul   0x10(%ebp),%eax
  106b95:	89 c2                	mov    %eax,%edx
  106b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106b9a:	01 d0                	add    %edx,%eax
  106b9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  106b9f:	e9 72 ff ff ff       	jmp    106b16 <strtol+0xab>
            break;
  106ba4:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  106ba5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106ba9:	74 08                	je     106bb3 <strtol+0x148>
        *endptr = (char *) s;
  106bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bae:	8b 55 08             	mov    0x8(%ebp),%edx
  106bb1:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106bb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106bb7:	74 07                	je     106bc0 <strtol+0x155>
  106bb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106bbc:	f7 d8                	neg    %eax
  106bbe:	eb 03                	jmp    106bc3 <strtol+0x158>
  106bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106bc3:	c9                   	leave  
  106bc4:	c3                   	ret    

00106bc5 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106bc5:	f3 0f 1e fb          	endbr32 
  106bc9:	55                   	push   %ebp
  106bca:	89 e5                	mov    %esp,%ebp
  106bcc:	57                   	push   %edi
  106bcd:	83 ec 24             	sub    $0x24,%esp
  106bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  106bd3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106bd6:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  106bda:	8b 45 08             	mov    0x8(%ebp),%eax
  106bdd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  106be0:	88 55 f7             	mov    %dl,-0x9(%ebp)
  106be3:	8b 45 10             	mov    0x10(%ebp),%eax
  106be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  106be9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  106bec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  106bf0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  106bf3:	89 d7                	mov    %edx,%edi
  106bf5:	f3 aa                	rep stos %al,%es:(%edi)
  106bf7:	89 fa                	mov    %edi,%edx
  106bf9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  106bfc:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  106bff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  106c02:	83 c4 24             	add    $0x24,%esp
  106c05:	5f                   	pop    %edi
  106c06:	5d                   	pop    %ebp
  106c07:	c3                   	ret    

00106c08 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106c08:	f3 0f 1e fb          	endbr32 
  106c0c:	55                   	push   %ebp
  106c0d:	89 e5                	mov    %esp,%ebp
  106c0f:	57                   	push   %edi
  106c10:	56                   	push   %esi
  106c11:	53                   	push   %ebx
  106c12:	83 ec 30             	sub    $0x30,%esp
  106c15:	8b 45 08             	mov    0x8(%ebp),%eax
  106c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  106c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106c21:	8b 45 10             	mov    0x10(%ebp),%eax
  106c24:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  106c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c2a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106c2d:	73 42                	jae    106c71 <memmove+0x69>
  106c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106c41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106c44:	c1 e8 02             	shr    $0x2,%eax
  106c47:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106c49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106c4f:	89 d7                	mov    %edx,%edi
  106c51:	89 c6                	mov    %eax,%esi
  106c53:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106c55:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106c58:	83 e1 03             	and    $0x3,%ecx
  106c5b:	74 02                	je     106c5f <memmove+0x57>
  106c5d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c5f:	89 f0                	mov    %esi,%eax
  106c61:	89 fa                	mov    %edi,%edx
  106c63:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106c66:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106c69:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  106c6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  106c6f:	eb 36                	jmp    106ca7 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c74:	8d 50 ff             	lea    -0x1(%eax),%edx
  106c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106c7a:	01 c2                	add    %eax,%edx
  106c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c7f:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106c85:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  106c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106c8b:	89 c1                	mov    %eax,%ecx
  106c8d:	89 d8                	mov    %ebx,%eax
  106c8f:	89 d6                	mov    %edx,%esi
  106c91:	89 c7                	mov    %eax,%edi
  106c93:	fd                   	std    
  106c94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106c96:	fc                   	cld    
  106c97:	89 f8                	mov    %edi,%eax
  106c99:	89 f2                	mov    %esi,%edx
  106c9b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106c9e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  106ca1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  106ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106ca7:	83 c4 30             	add    $0x30,%esp
  106caa:	5b                   	pop    %ebx
  106cab:	5e                   	pop    %esi
  106cac:	5f                   	pop    %edi
  106cad:	5d                   	pop    %ebp
  106cae:	c3                   	ret    

00106caf <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106caf:	f3 0f 1e fb          	endbr32 
  106cb3:	55                   	push   %ebp
  106cb4:	89 e5                	mov    %esp,%ebp
  106cb6:	57                   	push   %edi
  106cb7:	56                   	push   %esi
  106cb8:	83 ec 20             	sub    $0x20,%esp
  106cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  106cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  106cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  106cca:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106cd0:	c1 e8 02             	shr    $0x2,%eax
  106cd3:	89 c1                	mov    %eax,%ecx
    asm volatile (
  106cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106cdb:	89 d7                	mov    %edx,%edi
  106cdd:	89 c6                	mov    %eax,%esi
  106cdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106ce1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  106ce4:	83 e1 03             	and    $0x3,%ecx
  106ce7:	74 02                	je     106ceb <memcpy+0x3c>
  106ce9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106ceb:	89 f0                	mov    %esi,%eax
  106ced:	89 fa                	mov    %edi,%edx
  106cef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  106cf2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106cf5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  106cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  106cfb:	83 c4 20             	add    $0x20,%esp
  106cfe:	5e                   	pop    %esi
  106cff:	5f                   	pop    %edi
  106d00:	5d                   	pop    %ebp
  106d01:	c3                   	ret    

00106d02 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106d02:	f3 0f 1e fb          	endbr32 
  106d06:	55                   	push   %ebp
  106d07:	89 e5                	mov    %esp,%ebp
  106d09:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  106d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  106d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  106d15:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106d18:	eb 2e                	jmp    106d48 <memcmp+0x46>
        if (*s1 != *s2) {
  106d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d1d:	0f b6 10             	movzbl (%eax),%edx
  106d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106d23:	0f b6 00             	movzbl (%eax),%eax
  106d26:	38 c2                	cmp    %al,%dl
  106d28:	74 18                	je     106d42 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106d2d:	0f b6 00             	movzbl (%eax),%eax
  106d30:	0f b6 d0             	movzbl %al,%edx
  106d33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106d36:	0f b6 00             	movzbl (%eax),%eax
  106d39:	0f b6 c0             	movzbl %al,%eax
  106d3c:	29 c2                	sub    %eax,%edx
  106d3e:	89 d0                	mov    %edx,%eax
  106d40:	eb 18                	jmp    106d5a <memcmp+0x58>
        }
        s1 ++, s2 ++;
  106d42:	ff 45 fc             	incl   -0x4(%ebp)
  106d45:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  106d48:	8b 45 10             	mov    0x10(%ebp),%eax
  106d4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  106d4e:	89 55 10             	mov    %edx,0x10(%ebp)
  106d51:	85 c0                	test   %eax,%eax
  106d53:	75 c5                	jne    106d1a <memcmp+0x18>
    }
    return 0;
  106d55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106d5a:	c9                   	leave  
  106d5b:	c3                   	ret    

00106d5c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  106d5c:	f3 0f 1e fb          	endbr32 
  106d60:	55                   	push   %ebp
  106d61:	89 e5                	mov    %esp,%ebp
  106d63:	83 ec 58             	sub    $0x58,%esp
  106d66:	8b 45 10             	mov    0x10(%ebp),%eax
  106d69:	89 45 d0             	mov    %eax,-0x30(%ebp)
  106d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  106d6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  106d72:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106d75:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  106d78:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106d7b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  106d7e:	8b 45 18             	mov    0x18(%ebp),%eax
  106d81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106d87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106d8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106d8d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  106d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106d96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  106d9a:	74 1c                	je     106db8 <printnum+0x5c>
  106d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  106da4:	f7 75 e4             	divl   -0x1c(%ebp)
  106da7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  106daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106dad:	ba 00 00 00 00       	mov    $0x0,%edx
  106db2:	f7 75 e4             	divl   -0x1c(%ebp)
  106db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106dbe:	f7 75 e4             	divl   -0x1c(%ebp)
  106dc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106dc4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  106dc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106dca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106dcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106dd0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106dd6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  106dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  106ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  106de1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  106de4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  106de7:	19 d1                	sbb    %edx,%ecx
  106de9:	72 4c                	jb     106e37 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  106deb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  106dee:	8d 50 ff             	lea    -0x1(%eax),%edx
  106df1:	8b 45 20             	mov    0x20(%ebp),%eax
  106df4:	89 44 24 18          	mov    %eax,0x18(%esp)
  106df8:	89 54 24 14          	mov    %edx,0x14(%esp)
  106dfc:	8b 45 18             	mov    0x18(%ebp),%eax
  106dff:	89 44 24 10          	mov    %eax,0x10(%esp)
  106e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106e06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106e09:	89 44 24 08          	mov    %eax,0x8(%esp)
  106e0d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e18:	8b 45 08             	mov    0x8(%ebp),%eax
  106e1b:	89 04 24             	mov    %eax,(%esp)
  106e1e:	e8 39 ff ff ff       	call   106d5c <printnum>
  106e23:	eb 1b                	jmp    106e40 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  106e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  106e28:	89 44 24 04          	mov    %eax,0x4(%esp)
  106e2c:	8b 45 20             	mov    0x20(%ebp),%eax
  106e2f:	89 04 24             	mov    %eax,(%esp)
  106e32:	8b 45 08             	mov    0x8(%ebp),%eax
  106e35:	ff d0                	call   *%eax
        while (-- width > 0)
  106e37:	ff 4d 1c             	decl   0x1c(%ebp)
  106e3a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  106e3e:	7f e5                	jg     106e25 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  106e40:	8b 45 d8             	mov    -0x28(%ebp),%eax
  106e43:	05 44 8a 10 00       	add    $0x108a44,%eax
  106e48:	0f b6 00             	movzbl (%eax),%eax
  106e4b:	0f be c0             	movsbl %al,%eax
  106e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  106e51:	89 54 24 04          	mov    %edx,0x4(%esp)
  106e55:	89 04 24             	mov    %eax,(%esp)
  106e58:	8b 45 08             	mov    0x8(%ebp),%eax
  106e5b:	ff d0                	call   *%eax
}
  106e5d:	90                   	nop
  106e5e:	c9                   	leave  
  106e5f:	c3                   	ret    

00106e60 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  106e60:	f3 0f 1e fb          	endbr32 
  106e64:	55                   	push   %ebp
  106e65:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106e67:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106e6b:	7e 14                	jle    106e81 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  106e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  106e70:	8b 00                	mov    (%eax),%eax
  106e72:	8d 48 08             	lea    0x8(%eax),%ecx
  106e75:	8b 55 08             	mov    0x8(%ebp),%edx
  106e78:	89 0a                	mov    %ecx,(%edx)
  106e7a:	8b 50 04             	mov    0x4(%eax),%edx
  106e7d:	8b 00                	mov    (%eax),%eax
  106e7f:	eb 30                	jmp    106eb1 <getuint+0x51>
    }
    else if (lflag) {
  106e81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106e85:	74 16                	je     106e9d <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  106e87:	8b 45 08             	mov    0x8(%ebp),%eax
  106e8a:	8b 00                	mov    (%eax),%eax
  106e8c:	8d 48 04             	lea    0x4(%eax),%ecx
  106e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  106e92:	89 0a                	mov    %ecx,(%edx)
  106e94:	8b 00                	mov    (%eax),%eax
  106e96:	ba 00 00 00 00       	mov    $0x0,%edx
  106e9b:	eb 14                	jmp    106eb1 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  106e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  106ea0:	8b 00                	mov    (%eax),%eax
  106ea2:	8d 48 04             	lea    0x4(%eax),%ecx
  106ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  106ea8:	89 0a                	mov    %ecx,(%edx)
  106eaa:	8b 00                	mov    (%eax),%eax
  106eac:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  106eb1:	5d                   	pop    %ebp
  106eb2:	c3                   	ret    

00106eb3 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  106eb3:	f3 0f 1e fb          	endbr32 
  106eb7:	55                   	push   %ebp
  106eb8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  106eba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  106ebe:	7e 14                	jle    106ed4 <getint+0x21>
        return va_arg(*ap, long long);
  106ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  106ec3:	8b 00                	mov    (%eax),%eax
  106ec5:	8d 48 08             	lea    0x8(%eax),%ecx
  106ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  106ecb:	89 0a                	mov    %ecx,(%edx)
  106ecd:	8b 50 04             	mov    0x4(%eax),%edx
  106ed0:	8b 00                	mov    (%eax),%eax
  106ed2:	eb 28                	jmp    106efc <getint+0x49>
    }
    else if (lflag) {
  106ed4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106ed8:	74 12                	je     106eec <getint+0x39>
        return va_arg(*ap, long);
  106eda:	8b 45 08             	mov    0x8(%ebp),%eax
  106edd:	8b 00                	mov    (%eax),%eax
  106edf:	8d 48 04             	lea    0x4(%eax),%ecx
  106ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  106ee5:	89 0a                	mov    %ecx,(%edx)
  106ee7:	8b 00                	mov    (%eax),%eax
  106ee9:	99                   	cltd   
  106eea:	eb 10                	jmp    106efc <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  106eec:	8b 45 08             	mov    0x8(%ebp),%eax
  106eef:	8b 00                	mov    (%eax),%eax
  106ef1:	8d 48 04             	lea    0x4(%eax),%ecx
  106ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  106ef7:	89 0a                	mov    %ecx,(%edx)
  106ef9:	8b 00                	mov    (%eax),%eax
  106efb:	99                   	cltd   
    }
}
  106efc:	5d                   	pop    %ebp
  106efd:	c3                   	ret    

00106efe <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  106efe:	f3 0f 1e fb          	endbr32 
  106f02:	55                   	push   %ebp
  106f03:	89 e5                	mov    %esp,%ebp
  106f05:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  106f08:	8d 45 14             	lea    0x14(%ebp),%eax
  106f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  106f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106f11:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106f15:	8b 45 10             	mov    0x10(%ebp),%eax
  106f18:	89 44 24 08          	mov    %eax,0x8(%esp)
  106f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106f23:	8b 45 08             	mov    0x8(%ebp),%eax
  106f26:	89 04 24             	mov    %eax,(%esp)
  106f29:	e8 03 00 00 00       	call   106f31 <vprintfmt>
    va_end(ap);
}
  106f2e:	90                   	nop
  106f2f:	c9                   	leave  
  106f30:	c3                   	ret    

00106f31 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  106f31:	f3 0f 1e fb          	endbr32 
  106f35:	55                   	push   %ebp
  106f36:	89 e5                	mov    %esp,%ebp
  106f38:	56                   	push   %esi
  106f39:	53                   	push   %ebx
  106f3a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106f3d:	eb 17                	jmp    106f56 <vprintfmt+0x25>
            if (ch == '\0') {
  106f3f:	85 db                	test   %ebx,%ebx
  106f41:	0f 84 c0 03 00 00    	je     107307 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  106f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  106f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  106f4e:	89 1c 24             	mov    %ebx,(%esp)
  106f51:	8b 45 08             	mov    0x8(%ebp),%eax
  106f54:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  106f56:	8b 45 10             	mov    0x10(%ebp),%eax
  106f59:	8d 50 01             	lea    0x1(%eax),%edx
  106f5c:	89 55 10             	mov    %edx,0x10(%ebp)
  106f5f:	0f b6 00             	movzbl (%eax),%eax
  106f62:	0f b6 d8             	movzbl %al,%ebx
  106f65:	83 fb 25             	cmp    $0x25,%ebx
  106f68:	75 d5                	jne    106f3f <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  106f6a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  106f6e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  106f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f78:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  106f7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  106f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106f85:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  106f88:	8b 45 10             	mov    0x10(%ebp),%eax
  106f8b:	8d 50 01             	lea    0x1(%eax),%edx
  106f8e:	89 55 10             	mov    %edx,0x10(%ebp)
  106f91:	0f b6 00             	movzbl (%eax),%eax
  106f94:	0f b6 d8             	movzbl %al,%ebx
  106f97:	8d 43 dd             	lea    -0x23(%ebx),%eax
  106f9a:	83 f8 55             	cmp    $0x55,%eax
  106f9d:	0f 87 38 03 00 00    	ja     1072db <vprintfmt+0x3aa>
  106fa3:	8b 04 85 68 8a 10 00 	mov    0x108a68(,%eax,4),%eax
  106faa:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  106fad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  106fb1:	eb d5                	jmp    106f88 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  106fb3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  106fb7:	eb cf                	jmp    106f88 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  106fb9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  106fc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106fc3:	89 d0                	mov    %edx,%eax
  106fc5:	c1 e0 02             	shl    $0x2,%eax
  106fc8:	01 d0                	add    %edx,%eax
  106fca:	01 c0                	add    %eax,%eax
  106fcc:	01 d8                	add    %ebx,%eax
  106fce:	83 e8 30             	sub    $0x30,%eax
  106fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  106fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  106fd7:	0f b6 00             	movzbl (%eax),%eax
  106fda:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  106fdd:	83 fb 2f             	cmp    $0x2f,%ebx
  106fe0:	7e 38                	jle    10701a <vprintfmt+0xe9>
  106fe2:	83 fb 39             	cmp    $0x39,%ebx
  106fe5:	7f 33                	jg     10701a <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  106fe7:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  106fea:	eb d4                	jmp    106fc0 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  106fec:	8b 45 14             	mov    0x14(%ebp),%eax
  106fef:	8d 50 04             	lea    0x4(%eax),%edx
  106ff2:	89 55 14             	mov    %edx,0x14(%ebp)
  106ff5:	8b 00                	mov    (%eax),%eax
  106ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  106ffa:	eb 1f                	jmp    10701b <vprintfmt+0xea>

        case '.':
            if (width < 0)
  106ffc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  107000:	79 86                	jns    106f88 <vprintfmt+0x57>
                width = 0;
  107002:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  107009:	e9 7a ff ff ff       	jmp    106f88 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  10700e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  107015:	e9 6e ff ff ff       	jmp    106f88 <vprintfmt+0x57>
            goto process_precision;
  10701a:	90                   	nop

        process_precision:
            if (width < 0)
  10701b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10701f:	0f 89 63 ff ff ff    	jns    106f88 <vprintfmt+0x57>
                width = precision, precision = -1;
  107025:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107028:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10702b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  107032:	e9 51 ff ff ff       	jmp    106f88 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  107037:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10703a:	e9 49 ff ff ff       	jmp    106f88 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10703f:	8b 45 14             	mov    0x14(%ebp),%eax
  107042:	8d 50 04             	lea    0x4(%eax),%edx
  107045:	89 55 14             	mov    %edx,0x14(%ebp)
  107048:	8b 00                	mov    (%eax),%eax
  10704a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10704d:	89 54 24 04          	mov    %edx,0x4(%esp)
  107051:	89 04 24             	mov    %eax,(%esp)
  107054:	8b 45 08             	mov    0x8(%ebp),%eax
  107057:	ff d0                	call   *%eax
            break;
  107059:	e9 a4 02 00 00       	jmp    107302 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10705e:	8b 45 14             	mov    0x14(%ebp),%eax
  107061:	8d 50 04             	lea    0x4(%eax),%edx
  107064:	89 55 14             	mov    %edx,0x14(%ebp)
  107067:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  107069:	85 db                	test   %ebx,%ebx
  10706b:	79 02                	jns    10706f <vprintfmt+0x13e>
                err = -err;
  10706d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10706f:	83 fb 06             	cmp    $0x6,%ebx
  107072:	7f 0b                	jg     10707f <vprintfmt+0x14e>
  107074:	8b 34 9d 28 8a 10 00 	mov    0x108a28(,%ebx,4),%esi
  10707b:	85 f6                	test   %esi,%esi
  10707d:	75 23                	jne    1070a2 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  10707f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  107083:	c7 44 24 08 55 8a 10 	movl   $0x108a55,0x8(%esp)
  10708a:	00 
  10708b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10708e:	89 44 24 04          	mov    %eax,0x4(%esp)
  107092:	8b 45 08             	mov    0x8(%ebp),%eax
  107095:	89 04 24             	mov    %eax,(%esp)
  107098:	e8 61 fe ff ff       	call   106efe <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10709d:	e9 60 02 00 00       	jmp    107302 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  1070a2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1070a6:	c7 44 24 08 5e 8a 10 	movl   $0x108a5e,0x8(%esp)
  1070ad:	00 
  1070ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1070b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1070b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1070b8:	89 04 24             	mov    %eax,(%esp)
  1070bb:	e8 3e fe ff ff       	call   106efe <printfmt>
            break;
  1070c0:	e9 3d 02 00 00       	jmp    107302 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1070c5:	8b 45 14             	mov    0x14(%ebp),%eax
  1070c8:	8d 50 04             	lea    0x4(%eax),%edx
  1070cb:	89 55 14             	mov    %edx,0x14(%ebp)
  1070ce:	8b 30                	mov    (%eax),%esi
  1070d0:	85 f6                	test   %esi,%esi
  1070d2:	75 05                	jne    1070d9 <vprintfmt+0x1a8>
                p = "(null)";
  1070d4:	be 61 8a 10 00       	mov    $0x108a61,%esi
            }
            if (width > 0 && padc != '-') {
  1070d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1070dd:	7e 76                	jle    107155 <vprintfmt+0x224>
  1070df:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1070e3:	74 70                	je     107155 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1070e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1070e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1070ec:	89 34 24             	mov    %esi,(%esp)
  1070ef:	e8 ba f7 ff ff       	call   1068ae <strnlen>
  1070f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1070f7:	29 c2                	sub    %eax,%edx
  1070f9:	89 d0                	mov    %edx,%eax
  1070fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1070fe:	eb 16                	jmp    107116 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  107100:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  107104:	8b 55 0c             	mov    0xc(%ebp),%edx
  107107:	89 54 24 04          	mov    %edx,0x4(%esp)
  10710b:	89 04 24             	mov    %eax,(%esp)
  10710e:	8b 45 08             	mov    0x8(%ebp),%eax
  107111:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  107113:	ff 4d e8             	decl   -0x18(%ebp)
  107116:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10711a:	7f e4                	jg     107100 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10711c:	eb 37                	jmp    107155 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  10711e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  107122:	74 1f                	je     107143 <vprintfmt+0x212>
  107124:	83 fb 1f             	cmp    $0x1f,%ebx
  107127:	7e 05                	jle    10712e <vprintfmt+0x1fd>
  107129:	83 fb 7e             	cmp    $0x7e,%ebx
  10712c:	7e 15                	jle    107143 <vprintfmt+0x212>
                    putch('?', putdat);
  10712e:	8b 45 0c             	mov    0xc(%ebp),%eax
  107131:	89 44 24 04          	mov    %eax,0x4(%esp)
  107135:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10713c:	8b 45 08             	mov    0x8(%ebp),%eax
  10713f:	ff d0                	call   *%eax
  107141:	eb 0f                	jmp    107152 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  107143:	8b 45 0c             	mov    0xc(%ebp),%eax
  107146:	89 44 24 04          	mov    %eax,0x4(%esp)
  10714a:	89 1c 24             	mov    %ebx,(%esp)
  10714d:	8b 45 08             	mov    0x8(%ebp),%eax
  107150:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  107152:	ff 4d e8             	decl   -0x18(%ebp)
  107155:	89 f0                	mov    %esi,%eax
  107157:	8d 70 01             	lea    0x1(%eax),%esi
  10715a:	0f b6 00             	movzbl (%eax),%eax
  10715d:	0f be d8             	movsbl %al,%ebx
  107160:	85 db                	test   %ebx,%ebx
  107162:	74 27                	je     10718b <vprintfmt+0x25a>
  107164:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  107168:	78 b4                	js     10711e <vprintfmt+0x1ed>
  10716a:	ff 4d e4             	decl   -0x1c(%ebp)
  10716d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  107171:	79 ab                	jns    10711e <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  107173:	eb 16                	jmp    10718b <vprintfmt+0x25a>
                putch(' ', putdat);
  107175:	8b 45 0c             	mov    0xc(%ebp),%eax
  107178:	89 44 24 04          	mov    %eax,0x4(%esp)
  10717c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  107183:	8b 45 08             	mov    0x8(%ebp),%eax
  107186:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  107188:	ff 4d e8             	decl   -0x18(%ebp)
  10718b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10718f:	7f e4                	jg     107175 <vprintfmt+0x244>
            }
            break;
  107191:	e9 6c 01 00 00       	jmp    107302 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  107196:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107199:	89 44 24 04          	mov    %eax,0x4(%esp)
  10719d:	8d 45 14             	lea    0x14(%ebp),%eax
  1071a0:	89 04 24             	mov    %eax,(%esp)
  1071a3:	e8 0b fd ff ff       	call   106eb3 <getint>
  1071a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1071ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1071ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1071b4:	85 d2                	test   %edx,%edx
  1071b6:	79 26                	jns    1071de <vprintfmt+0x2ad>
                putch('-', putdat);
  1071b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1071bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1071bf:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1071c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1071c9:	ff d0                	call   *%eax
                num = -(long long)num;
  1071cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1071ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1071d1:	f7 d8                	neg    %eax
  1071d3:	83 d2 00             	adc    $0x0,%edx
  1071d6:	f7 da                	neg    %edx
  1071d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1071db:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1071de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1071e5:	e9 a8 00 00 00       	jmp    107292 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1071ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1071ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1071f1:	8d 45 14             	lea    0x14(%ebp),%eax
  1071f4:	89 04 24             	mov    %eax,(%esp)
  1071f7:	e8 64 fc ff ff       	call   106e60 <getuint>
  1071fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1071ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  107202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  107209:	e9 84 00 00 00       	jmp    107292 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10720e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107211:	89 44 24 04          	mov    %eax,0x4(%esp)
  107215:	8d 45 14             	lea    0x14(%ebp),%eax
  107218:	89 04 24             	mov    %eax,(%esp)
  10721b:	e8 40 fc ff ff       	call   106e60 <getuint>
  107220:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107223:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  107226:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10722d:	eb 63                	jmp    107292 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  10722f:	8b 45 0c             	mov    0xc(%ebp),%eax
  107232:	89 44 24 04          	mov    %eax,0x4(%esp)
  107236:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10723d:	8b 45 08             	mov    0x8(%ebp),%eax
  107240:	ff d0                	call   *%eax
            putch('x', putdat);
  107242:	8b 45 0c             	mov    0xc(%ebp),%eax
  107245:	89 44 24 04          	mov    %eax,0x4(%esp)
  107249:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  107250:	8b 45 08             	mov    0x8(%ebp),%eax
  107253:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  107255:	8b 45 14             	mov    0x14(%ebp),%eax
  107258:	8d 50 04             	lea    0x4(%eax),%edx
  10725b:	89 55 14             	mov    %edx,0x14(%ebp)
  10725e:	8b 00                	mov    (%eax),%eax
  107260:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10726a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  107271:	eb 1f                	jmp    107292 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  107273:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107276:	89 44 24 04          	mov    %eax,0x4(%esp)
  10727a:	8d 45 14             	lea    0x14(%ebp),%eax
  10727d:	89 04 24             	mov    %eax,(%esp)
  107280:	e8 db fb ff ff       	call   106e60 <getuint>
  107285:	89 45 f0             	mov    %eax,-0x10(%ebp)
  107288:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10728b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  107292:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  107296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  107299:	89 54 24 18          	mov    %edx,0x18(%esp)
  10729d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1072a0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1072a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  1072a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1072ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1072ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  1072b2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1072b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1072b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1072bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1072c0:	89 04 24             	mov    %eax,(%esp)
  1072c3:	e8 94 fa ff ff       	call   106d5c <printnum>
            break;
  1072c8:	eb 38                	jmp    107302 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1072ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1072cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1072d1:	89 1c 24             	mov    %ebx,(%esp)
  1072d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1072d7:	ff d0                	call   *%eax
            break;
  1072d9:	eb 27                	jmp    107302 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1072db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1072de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1072e2:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1072e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1072ec:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1072ee:	ff 4d 10             	decl   0x10(%ebp)
  1072f1:	eb 03                	jmp    1072f6 <vprintfmt+0x3c5>
  1072f3:	ff 4d 10             	decl   0x10(%ebp)
  1072f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1072f9:	48                   	dec    %eax
  1072fa:	0f b6 00             	movzbl (%eax),%eax
  1072fd:	3c 25                	cmp    $0x25,%al
  1072ff:	75 f2                	jne    1072f3 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  107301:	90                   	nop
    while (1) {
  107302:	e9 36 fc ff ff       	jmp    106f3d <vprintfmt+0xc>
                return;
  107307:	90                   	nop
        }
    }
}
  107308:	83 c4 40             	add    $0x40,%esp
  10730b:	5b                   	pop    %ebx
  10730c:	5e                   	pop    %esi
  10730d:	5d                   	pop    %ebp
  10730e:	c3                   	ret    

0010730f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10730f:	f3 0f 1e fb          	endbr32 
  107313:	55                   	push   %ebp
  107314:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  107316:	8b 45 0c             	mov    0xc(%ebp),%eax
  107319:	8b 40 08             	mov    0x8(%eax),%eax
  10731c:	8d 50 01             	lea    0x1(%eax),%edx
  10731f:	8b 45 0c             	mov    0xc(%ebp),%eax
  107322:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  107325:	8b 45 0c             	mov    0xc(%ebp),%eax
  107328:	8b 10                	mov    (%eax),%edx
  10732a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10732d:	8b 40 04             	mov    0x4(%eax),%eax
  107330:	39 c2                	cmp    %eax,%edx
  107332:	73 12                	jae    107346 <sprintputch+0x37>
        *b->buf ++ = ch;
  107334:	8b 45 0c             	mov    0xc(%ebp),%eax
  107337:	8b 00                	mov    (%eax),%eax
  107339:	8d 48 01             	lea    0x1(%eax),%ecx
  10733c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10733f:	89 0a                	mov    %ecx,(%edx)
  107341:	8b 55 08             	mov    0x8(%ebp),%edx
  107344:	88 10                	mov    %dl,(%eax)
    }
}
  107346:	90                   	nop
  107347:	5d                   	pop    %ebp
  107348:	c3                   	ret    

00107349 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  107349:	f3 0f 1e fb          	endbr32 
  10734d:	55                   	push   %ebp
  10734e:	89 e5                	mov    %esp,%ebp
  107350:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  107353:	8d 45 14             	lea    0x14(%ebp),%eax
  107356:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  107359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10735c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  107360:	8b 45 10             	mov    0x10(%ebp),%eax
  107363:	89 44 24 08          	mov    %eax,0x8(%esp)
  107367:	8b 45 0c             	mov    0xc(%ebp),%eax
  10736a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10736e:	8b 45 08             	mov    0x8(%ebp),%eax
  107371:	89 04 24             	mov    %eax,(%esp)
  107374:	e8 08 00 00 00       	call   107381 <vsnprintf>
  107379:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10737c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10737f:	c9                   	leave  
  107380:	c3                   	ret    

00107381 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  107381:	f3 0f 1e fb          	endbr32 
  107385:	55                   	push   %ebp
  107386:	89 e5                	mov    %esp,%ebp
  107388:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10738b:	8b 45 08             	mov    0x8(%ebp),%eax
  10738e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  107391:	8b 45 0c             	mov    0xc(%ebp),%eax
  107394:	8d 50 ff             	lea    -0x1(%eax),%edx
  107397:	8b 45 08             	mov    0x8(%ebp),%eax
  10739a:	01 d0                	add    %edx,%eax
  10739c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10739f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1073a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1073aa:	74 0a                	je     1073b6 <vsnprintf+0x35>
  1073ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1073af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1073b2:	39 c2                	cmp    %eax,%edx
  1073b4:	76 07                	jbe    1073bd <vsnprintf+0x3c>
        return -E_INVAL;
  1073b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1073bb:	eb 2a                	jmp    1073e7 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1073bd:	8b 45 14             	mov    0x14(%ebp),%eax
  1073c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1073c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1073c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1073cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1073ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1073d2:	c7 04 24 0f 73 10 00 	movl   $0x10730f,(%esp)
  1073d9:	e8 53 fb ff ff       	call   106f31 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1073de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1073e1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1073e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1073e7:	c9                   	leave  
  1073e8:	c3                   	ret    

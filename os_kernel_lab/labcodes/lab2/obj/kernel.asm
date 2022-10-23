
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
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	f3 0f 1e fb          	endbr32 
c010003a:	55                   	push   %ebp
c010003b:	89 e5                	mov    %esp,%ebp
c010003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100040:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0100045:	2d 00 c0 11 c0       	sub    $0xc011c000,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 c0 11 c0 	movl   $0xc011c000,(%esp)
c010005d:	e8 e1 57 00 00       	call   c0105843 <memset>

    cons_init();                // init the console
c0100062:	e8 4b 16 00 00       	call   c01016b2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 80 60 10 c0 	movl   $0xc0106080,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 9c 60 10 c0 	movl   $0xc010609c,(%esp)
c010007c:	e8 44 02 00 00       	call   c01002c5 <cprintf>

    print_kerninfo();
c0100081:	e8 02 09 00 00       	call   c0100988 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 5d 32 00 00       	call   c01032ed <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 98 17 00 00       	call   c010182d <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 18 19 00 00       	call   c01019b2 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 5a 0d 00 00       	call   c0100df9 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 d5 18 00 00       	call   c0101979 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	f3 0f 1e fb          	endbr32 
c01000aa:	55                   	push   %ebp
c01000ab:	89 e5                	mov    %esp,%ebp
c01000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b7:	00 
c01000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bf:	00 
c01000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c7:	e8 17 0d 00 00       	call   c0100de3 <mon_backtrace>
}
c01000cc:	90                   	nop
c01000cd:	c9                   	leave  
c01000ce:	c3                   	ret    

c01000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cf:	f3 0f 1e fb          	endbr32 
c01000d3:	55                   	push   %ebp
c01000d4:	89 e5                	mov    %esp,%ebp
c01000d6:	53                   	push   %ebx
c01000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f2:	89 04 24             	mov    %eax,(%esp)
c01000f5:	e8 ac ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000fa:	90                   	nop
c01000fb:	83 c4 14             	add    $0x14,%esp
c01000fe:	5b                   	pop    %ebx
c01000ff:	5d                   	pop    %ebp
c0100100:	c3                   	ret    

c0100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100101:	f3 0f 1e fb          	endbr32 
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010b:	8b 45 10             	mov    0x10(%ebp),%eax
c010010e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100112:	8b 45 08             	mov    0x8(%ebp),%eax
c0100115:	89 04 24             	mov    %eax,(%esp)
c0100118:	e8 b2 ff ff ff       	call   c01000cf <grade_backtrace1>
}
c010011d:	90                   	nop
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	f3 0f 1e fb          	endbr32 
c0100124:	55                   	push   %ebp
c0100125:	89 e5                	mov    %esp,%ebp
c0100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010012a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100136:	ff 
c0100137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100142:	e8 ba ff ff ff       	call   c0100101 <grade_backtrace0>
}
c0100147:	90                   	nop
c0100148:	c9                   	leave  
c0100149:	c3                   	ret    

c010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010014a:	f3 0f 1e fb          	endbr32 
c010014e:	55                   	push   %ebp
c010014f:	89 e5                	mov    %esp,%ebp
c0100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100164:	83 e0 03             	and    $0x3,%eax
c0100167:	89 c2                	mov    %eax,%edx
c0100169:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010016e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100176:	c7 04 24 a1 60 10 c0 	movl   $0xc01060a1,(%esp)
c010017d:	e8 43 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100186:	89 c2                	mov    %eax,%edx
c0100188:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 af 60 10 c0 	movl   $0xc01060af,(%esp)
c010019c:	e8 24 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a5:	89 c2                	mov    %eax,%edx
c01001a7:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b4:	c7 04 24 bd 60 10 c0 	movl   $0xc01060bd,(%esp)
c01001bb:	e8 05 01 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c4:	89 c2                	mov    %eax,%edx
c01001c6:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d3:	c7 04 24 cb 60 10 c0 	movl   $0xc01060cb,(%esp)
c01001da:	e8 e6 00 00 00       	call   c01002c5 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e3:	89 c2                	mov    %eax,%edx
c01001e5:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c01001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f2:	c7 04 24 d9 60 10 c0 	movl   $0xc01060d9,(%esp)
c01001f9:	e8 c7 00 00 00       	call   c01002c5 <cprintf>
    round ++;
c01001fe:	a1 00 c0 11 c0       	mov    0xc011c000,%eax
c0100203:	40                   	inc    %eax
c0100204:	a3 00 c0 11 c0       	mov    %eax,0xc011c000
}
c0100209:	90                   	nop
c010020a:	c9                   	leave  
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020c:	f3 0f 1e fb          	endbr32 
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	__asm__ __volatile__ (
c0100213:	83 ec 08             	sub    $0x8,%esp
c0100216:	cd 78                	int    $0x78
c0100218:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
        "movl %%ebp, %%esp\n"
		:
		:"i" (T_SWITCH_TOU)
	);
}
c010021a:	90                   	nop
c010021b:	5d                   	pop    %ebp
c010021c:	c3                   	ret    

c010021d <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010021d:	f3 0f 1e fb          	endbr32 
c0100221:	55                   	push   %ebp
c0100222:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    __asm__ __volatile__(
c0100224:	cd 79                	int    $0x79
c0100226:	89 ec                	mov    %ebp,%esp
    	"int %0 \n"
    	"movl %%ebp,%%esp \n" 
    	:
    	:"i"(T_SWITCH_TOK)
    );
}
c0100228:	90                   	nop
c0100229:	5d                   	pop    %ebp
c010022a:	c3                   	ret    

c010022b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010022b:	f3 0f 1e fb          	endbr32 
c010022f:	55                   	push   %ebp
c0100230:	89 e5                	mov    %esp,%ebp
c0100232:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100235:	e8 10 ff ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010023a:	c7 04 24 e8 60 10 c0 	movl   $0xc01060e8,(%esp)
c0100241:	e8 7f 00 00 00       	call   c01002c5 <cprintf>
    lab1_switch_to_user();
c0100246:	e8 c1 ff ff ff       	call   c010020c <lab1_switch_to_user>
    lab1_print_cur_status();
c010024b:	e8 fa fe ff ff       	call   c010014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100250:	c7 04 24 08 61 10 c0 	movl   $0xc0106108,(%esp)
c0100257:	e8 69 00 00 00       	call   c01002c5 <cprintf>
    lab1_switch_to_kernel();
c010025c:	e8 bc ff ff ff       	call   c010021d <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100261:	e8 e4 fe ff ff       	call   c010014a <lab1_print_cur_status>
}
c0100266:	90                   	nop
c0100267:	c9                   	leave  
c0100268:	c3                   	ret    

c0100269 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100269:	f3 0f 1e fb          	endbr32 
c010026d:	55                   	push   %ebp
c010026e:	89 e5                	mov    %esp,%ebp
c0100270:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100273:	8b 45 08             	mov    0x8(%ebp),%eax
c0100276:	89 04 24             	mov    %eax,(%esp)
c0100279:	e8 65 14 00 00       	call   c01016e3 <cons_putc>
    (*cnt) ++;
c010027e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100281:	8b 00                	mov    (%eax),%eax
c0100283:	8d 50 01             	lea    0x1(%eax),%edx
c0100286:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100289:	89 10                	mov    %edx,(%eax)
}
c010028b:	90                   	nop
c010028c:	c9                   	leave  
c010028d:	c3                   	ret    

c010028e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010028e:	f3 0f 1e fb          	endbr32 
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010029f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01002a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01002ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b4:	c7 04 24 69 02 10 c0 	movl   $0xc0100269,(%esp)
c01002bb:	e8 ef 58 00 00       	call   c0105baf <vprintfmt>
    return cnt;
c01002c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c3:	c9                   	leave  
c01002c4:	c3                   	ret    

c01002c5 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002c5:	f3 0f 1e fb          	endbr32 
c01002c9:	55                   	push   %ebp
c01002ca:	89 e5                	mov    %esp,%ebp
c01002cc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 a7 ff ff ff       	call   c010028e <vcprintf>
c01002e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002ed:	c9                   	leave  
c01002ee:	c3                   	ret    

c01002ef <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002ef:	f3 0f 1e fb          	endbr32 
c01002f3:	55                   	push   %ebp
c01002f4:	89 e5                	mov    %esp,%ebp
c01002f6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fc:	89 04 24             	mov    %eax,(%esp)
c01002ff:	e8 df 13 00 00       	call   c01016e3 <cons_putc>
}
c0100304:	90                   	nop
c0100305:	c9                   	leave  
c0100306:	c3                   	ret    

c0100307 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100307:	f3 0f 1e fb          	endbr32 
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100311:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100318:	eb 13                	jmp    c010032d <cputs+0x26>
        cputch(c, &cnt);
c010031a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010031e:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100321:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100325:	89 04 24             	mov    %eax,(%esp)
c0100328:	e8 3c ff ff ff       	call   c0100269 <cputch>
    while ((c = *str ++) != '\0') {
c010032d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100330:	8d 50 01             	lea    0x1(%eax),%edx
c0100333:	89 55 08             	mov    %edx,0x8(%ebp)
c0100336:	0f b6 00             	movzbl (%eax),%eax
c0100339:	88 45 f7             	mov    %al,-0x9(%ebp)
c010033c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100340:	75 d8                	jne    c010031a <cputs+0x13>
    }
    cputch('\n', &cnt);
c0100342:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100345:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100349:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100350:	e8 14 ff ff ff       	call   c0100269 <cputch>
    return cnt;
c0100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100358:	c9                   	leave  
c0100359:	c3                   	ret    

c010035a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010035a:	f3 0f 1e fb          	endbr32 
c010035e:	55                   	push   %ebp
c010035f:	89 e5                	mov    %esp,%ebp
c0100361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100364:	90                   	nop
c0100365:	e8 ba 13 00 00       	call   c0101724 <cons_getc>
c010036a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100371:	74 f2                	je     c0100365 <getchar+0xb>
        /* do nothing */;
    return c;
c0100373:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100376:	c9                   	leave  
c0100377:	c3                   	ret    

c0100378 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100378:	f3 0f 1e fb          	endbr32 
c010037c:	55                   	push   %ebp
c010037d:	89 e5                	mov    %esp,%ebp
c010037f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100386:	74 13                	je     c010039b <readline+0x23>
        cprintf("%s", prompt);
c0100388:	8b 45 08             	mov    0x8(%ebp),%eax
c010038b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010038f:	c7 04 24 27 61 10 c0 	movl   $0xc0106127,(%esp)
c0100396:	e8 2a ff ff ff       	call   c01002c5 <cprintf>
    }
    int i = 0, c;
c010039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c01003a2:	e8 b3 ff ff ff       	call   c010035a <getchar>
c01003a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c01003aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01003ae:	79 07                	jns    c01003b7 <readline+0x3f>
            return NULL;
c01003b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01003b5:	eb 78                	jmp    c010042f <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c01003b7:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c01003bb:	7e 28                	jle    c01003e5 <readline+0x6d>
c01003bd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c01003c4:	7f 1f                	jg     c01003e5 <readline+0x6d>
            cputchar(c);
c01003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c9:	89 04 24             	mov    %eax,(%esp)
c01003cc:	e8 1e ff ff ff       	call   c01002ef <cputchar>
            buf[i ++] = c;
c01003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d4:	8d 50 01             	lea    0x1(%eax),%edx
c01003d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003dd:	88 90 20 c0 11 c0    	mov    %dl,-0x3fee3fe0(%eax)
c01003e3:	eb 45                	jmp    c010042a <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01003e5:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003e9:	75 16                	jne    c0100401 <readline+0x89>
c01003eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ef:	7e 10                	jle    c0100401 <readline+0x89>
            cputchar(c);
c01003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003f4:	89 04 24             	mov    %eax,(%esp)
c01003f7:	e8 f3 fe ff ff       	call   c01002ef <cputchar>
            i --;
c01003fc:	ff 4d f4             	decl   -0xc(%ebp)
c01003ff:	eb 29                	jmp    c010042a <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c0100401:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c0100405:	74 06                	je     c010040d <readline+0x95>
c0100407:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c010040b:	75 95                	jne    c01003a2 <readline+0x2a>
            cputchar(c);
c010040d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100410:	89 04 24             	mov    %eax,(%esp)
c0100413:	e8 d7 fe ff ff       	call   c01002ef <cputchar>
            buf[i] = '\0';
c0100418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010041b:	05 20 c0 11 c0       	add    $0xc011c020,%eax
c0100420:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c0100423:	b8 20 c0 11 c0       	mov    $0xc011c020,%eax
c0100428:	eb 05                	jmp    c010042f <readline+0xb7>
        c = getchar();
c010042a:	e9 73 ff ff ff       	jmp    c01003a2 <readline+0x2a>
        }
    }
}
c010042f:	c9                   	leave  
c0100430:	c3                   	ret    

c0100431 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100431:	f3 0f 1e fb          	endbr32 
c0100435:	55                   	push   %ebp
c0100436:	89 e5                	mov    %esp,%ebp
c0100438:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c010043b:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
c0100440:	85 c0                	test   %eax,%eax
c0100442:	75 5b                	jne    c010049f <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100444:	c7 05 20 c4 11 c0 01 	movl   $0x1,0xc011c420
c010044b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010044e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100454:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100457:	89 44 24 08          	mov    %eax,0x8(%esp)
c010045b:	8b 45 08             	mov    0x8(%ebp),%eax
c010045e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100462:	c7 04 24 2a 61 10 c0 	movl   $0xc010612a,(%esp)
c0100469:	e8 57 fe ff ff       	call   c01002c5 <cprintf>
    vcprintf(fmt, ap);
c010046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100475:	8b 45 10             	mov    0x10(%ebp),%eax
c0100478:	89 04 24             	mov    %eax,(%esp)
c010047b:	e8 0e fe ff ff       	call   c010028e <vcprintf>
    cprintf("\n");
c0100480:	c7 04 24 46 61 10 c0 	movl   $0xc0106146,(%esp)
c0100487:	e8 39 fe ff ff       	call   c01002c5 <cprintf>
    
    cprintf("stack trackback:\n");
c010048c:	c7 04 24 48 61 10 c0 	movl   $0xc0106148,(%esp)
c0100493:	e8 2d fe ff ff       	call   c01002c5 <cprintf>
    print_stackframe();
c0100498:	e8 3d 06 00 00       	call   c0100ada <print_stackframe>
c010049d:	eb 01                	jmp    c01004a0 <__panic+0x6f>
        goto panic_dead;
c010049f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c01004a0:	e8 e0 14 00 00       	call   c0101985 <intr_disable>
    while (1) {
        kmonitor(NULL);
c01004a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01004ac:	e8 59 08 00 00       	call   c0100d0a <kmonitor>
c01004b1:	eb f2                	jmp    c01004a5 <__panic+0x74>

c01004b3 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c01004b3:	f3 0f 1e fb          	endbr32 
c01004b7:	55                   	push   %ebp
c01004b8:	89 e5                	mov    %esp,%ebp
c01004ba:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c01004bd:	8d 45 14             	lea    0x14(%ebp),%eax
c01004c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c01004c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01004ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004d1:	c7 04 24 5a 61 10 c0 	movl   $0xc010615a,(%esp)
c01004d8:	e8 e8 fd ff ff       	call   c01002c5 <cprintf>
    vcprintf(fmt, ap);
c01004dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e7:	89 04 24             	mov    %eax,(%esp)
c01004ea:	e8 9f fd ff ff       	call   c010028e <vcprintf>
    cprintf("\n");
c01004ef:	c7 04 24 46 61 10 c0 	movl   $0xc0106146,(%esp)
c01004f6:	e8 ca fd ff ff       	call   c01002c5 <cprintf>
    va_end(ap);
}
c01004fb:	90                   	nop
c01004fc:	c9                   	leave  
c01004fd:	c3                   	ret    

c01004fe <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004fe:	f3 0f 1e fb          	endbr32 
c0100502:	55                   	push   %ebp
c0100503:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100505:	a1 20 c4 11 c0       	mov    0xc011c420,%eax
}
c010050a:	5d                   	pop    %ebp
c010050b:	c3                   	ret    

c010050c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010050c:	f3 0f 1e fb          	endbr32 
c0100510:	55                   	push   %ebp
c0100511:	89 e5                	mov    %esp,%ebp
c0100513:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100516:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100519:	8b 00                	mov    (%eax),%eax
c010051b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010051e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100521:	8b 00                	mov    (%eax),%eax
c0100523:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010052d:	e9 ca 00 00 00       	jmp    c01005fc <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
c0100532:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100535:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100538:	01 d0                	add    %edx,%eax
c010053a:	89 c2                	mov    %eax,%edx
c010053c:	c1 ea 1f             	shr    $0x1f,%edx
c010053f:	01 d0                	add    %edx,%eax
c0100541:	d1 f8                	sar    %eax
c0100543:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100546:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100549:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010054c:	eb 03                	jmp    c0100551 <stab_binsearch+0x45>
            m --;
c010054e:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100554:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100557:	7c 1f                	jl     c0100578 <stab_binsearch+0x6c>
c0100559:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010055c:	89 d0                	mov    %edx,%eax
c010055e:	01 c0                	add    %eax,%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	c1 e0 02             	shl    $0x2,%eax
c0100565:	89 c2                	mov    %eax,%edx
c0100567:	8b 45 08             	mov    0x8(%ebp),%eax
c010056a:	01 d0                	add    %edx,%eax
c010056c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100570:	0f b6 c0             	movzbl %al,%eax
c0100573:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100576:	75 d6                	jne    c010054e <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
c0100578:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010057e:	7d 09                	jge    c0100589 <stab_binsearch+0x7d>
            l = true_m + 1;
c0100580:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100583:	40                   	inc    %eax
c0100584:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100587:	eb 73                	jmp    c01005fc <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
c0100589:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100593:	89 d0                	mov    %edx,%eax
c0100595:	01 c0                	add    %eax,%eax
c0100597:	01 d0                	add    %edx,%eax
c0100599:	c1 e0 02             	shl    $0x2,%eax
c010059c:	89 c2                	mov    %eax,%edx
c010059e:	8b 45 08             	mov    0x8(%ebp),%eax
c01005a1:	01 d0                	add    %edx,%eax
c01005a3:	8b 40 08             	mov    0x8(%eax),%eax
c01005a6:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005a9:	76 11                	jbe    c01005bc <stab_binsearch+0xb0>
            *region_left = m;
c01005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b1:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01005b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01005b6:	40                   	inc    %eax
c01005b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01005ba:	eb 40                	jmp    c01005fc <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
c01005bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005bf:	89 d0                	mov    %edx,%eax
c01005c1:	01 c0                	add    %eax,%eax
c01005c3:	01 d0                	add    %edx,%eax
c01005c5:	c1 e0 02             	shl    $0x2,%eax
c01005c8:	89 c2                	mov    %eax,%edx
c01005ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01005cd:	01 d0                	add    %edx,%eax
c01005cf:	8b 40 08             	mov    0x8(%eax),%eax
c01005d2:	39 45 18             	cmp    %eax,0x18(%ebp)
c01005d5:	73 14                	jae    c01005eb <stab_binsearch+0xdf>
            *region_right = m - 1;
c01005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005da:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e0:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005e5:	48                   	dec    %eax
c01005e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005e9:	eb 11                	jmp    c01005fc <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005f1:	89 10                	mov    %edx,(%eax)
            l = m;
c01005f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005f9:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100602:	0f 8e 2a ff ff ff    	jle    c0100532 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
c0100608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010060c:	75 0f                	jne    c010061d <stab_binsearch+0x111>
        *region_right = *region_left - 1;
c010060e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100611:	8b 00                	mov    (%eax),%eax
c0100613:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100616:	8b 45 10             	mov    0x10(%ebp),%eax
c0100619:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010061b:	eb 3e                	jmp    c010065b <stab_binsearch+0x14f>
        l = *region_right;
c010061d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100620:	8b 00                	mov    (%eax),%eax
c0100622:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100625:	eb 03                	jmp    c010062a <stab_binsearch+0x11e>
c0100627:	ff 4d fc             	decl   -0x4(%ebp)
c010062a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062d:	8b 00                	mov    (%eax),%eax
c010062f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100632:	7e 1f                	jle    c0100653 <stab_binsearch+0x147>
c0100634:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100637:	89 d0                	mov    %edx,%eax
c0100639:	01 c0                	add    %eax,%eax
c010063b:	01 d0                	add    %edx,%eax
c010063d:	c1 e0 02             	shl    $0x2,%eax
c0100640:	89 c2                	mov    %eax,%edx
c0100642:	8b 45 08             	mov    0x8(%ebp),%eax
c0100645:	01 d0                	add    %edx,%eax
c0100647:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010064b:	0f b6 c0             	movzbl %al,%eax
c010064e:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100651:	75 d4                	jne    c0100627 <stab_binsearch+0x11b>
        *region_left = l;
c0100653:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100656:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100659:	89 10                	mov    %edx,(%eax)
}
c010065b:	90                   	nop
c010065c:	c9                   	leave  
c010065d:	c3                   	ret    

c010065e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010065e:	f3 0f 1e fb          	endbr32 
c0100662:	55                   	push   %ebp
c0100663:	89 e5                	mov    %esp,%ebp
c0100665:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100668:	8b 45 0c             	mov    0xc(%ebp),%eax
c010066b:	c7 00 78 61 10 c0    	movl   $0xc0106178,(%eax)
    info->eip_line = 0;
c0100671:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100674:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010067b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067e:	c7 40 08 78 61 10 c0 	movl   $0xc0106178,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100685:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100688:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010068f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100692:	8b 55 08             	mov    0x8(%ebp),%edx
c0100695:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c01006a2:	c7 45 f4 f0 73 10 c0 	movl   $0xc01073f0,-0xc(%ebp)
    stab_end = __STAB_END__;
c01006a9:	c7 45 f0 74 3a 11 c0 	movl   $0xc0113a74,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c01006b0:	c7 45 ec 75 3a 11 c0 	movl   $0xc0113a75,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01006b7:	c7 45 e8 78 65 11 c0 	movl   $0xc0116578,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006c4:	76 0b                	jbe    c01006d1 <debuginfo_eip+0x73>
c01006c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006c9:	48                   	dec    %eax
c01006ca:	0f b6 00             	movzbl (%eax),%eax
c01006cd:	84 c0                	test   %al,%al
c01006cf:	74 0a                	je     c01006db <debuginfo_eip+0x7d>
        return -1;
c01006d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006d6:	e9 ab 02 00 00       	jmp    c0100986 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01006e5:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01006e8:	c1 f8 02             	sar    $0x2,%eax
c01006eb:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006f1:	48                   	dec    %eax
c01006f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006fc:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c0100703:	00 
c0100704:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100707:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010070e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100715:	89 04 24             	mov    %eax,(%esp)
c0100718:	e8 ef fd ff ff       	call   c010050c <stab_binsearch>
    if (lfile == 0)
c010071d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100720:	85 c0                	test   %eax,%eax
c0100722:	75 0a                	jne    c010072e <debuginfo_eip+0xd0>
        return -1;
c0100724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100729:	e9 58 02 00 00       	jmp    c0100986 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010072e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100731:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100734:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100737:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010073a:	8b 45 08             	mov    0x8(%ebp),%eax
c010073d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100741:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100748:	00 
c0100749:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010074c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100750:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100753:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100757:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010075a:	89 04 24             	mov    %eax,(%esp)
c010075d:	e8 aa fd ff ff       	call   c010050c <stab_binsearch>

    if (lfun <= rfun) {
c0100762:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100765:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100768:	39 c2                	cmp    %eax,%edx
c010076a:	7f 78                	jg     c01007e4 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010076c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	89 d0                	mov    %edx,%eax
c0100773:	01 c0                	add    %eax,%eax
c0100775:	01 d0                	add    %edx,%eax
c0100777:	c1 e0 02             	shl    $0x2,%eax
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077f:	01 d0                	add    %edx,%eax
c0100781:	8b 10                	mov    (%eax),%edx
c0100783:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100786:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100789:	39 c2                	cmp    %eax,%edx
c010078b:	73 22                	jae    c01007af <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010078d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100790:	89 c2                	mov    %eax,%edx
c0100792:	89 d0                	mov    %edx,%eax
c0100794:	01 c0                	add    %eax,%eax
c0100796:	01 d0                	add    %edx,%eax
c0100798:	c1 e0 02             	shl    $0x2,%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a0:	01 d0                	add    %edx,%eax
c01007a2:	8b 10                	mov    (%eax),%edx
c01007a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007a7:	01 c2                	add    %eax,%edx
c01007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ac:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	8b 50 08             	mov    0x8(%eax),%edx
c01007c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ca:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d0:	8b 40 10             	mov    0x10(%eax),%eax
c01007d3:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007df:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007e2:	eb 15                	jmp    c01007f9 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ea:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007fc:	8b 40 08             	mov    0x8(%eax),%eax
c01007ff:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c0100806:	00 
c0100807:	89 04 24             	mov    %eax,(%esp)
c010080a:	e8 a8 4e 00 00       	call   c01056b7 <strfind>
c010080f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100812:	8b 52 08             	mov    0x8(%edx),%edx
c0100815:	29 d0                	sub    %edx,%eax
c0100817:	89 c2                	mov    %eax,%edx
c0100819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010081f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100822:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100826:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010082d:	00 
c010082e:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100831:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100835:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100838:	89 44 24 04          	mov    %eax,0x4(%esp)
c010083c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083f:	89 04 24             	mov    %eax,(%esp)
c0100842:	e8 c5 fc ff ff       	call   c010050c <stab_binsearch>
    if (lline <= rline) {
c0100847:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010084d:	39 c2                	cmp    %eax,%edx
c010084f:	7f 23                	jg     c0100874 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
c0100851:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100854:	89 c2                	mov    %eax,%edx
c0100856:	89 d0                	mov    %edx,%eax
c0100858:	01 c0                	add    %eax,%eax
c010085a:	01 d0                	add    %edx,%eax
c010085c:	c1 e0 02             	shl    $0x2,%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010086f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100872:	eb 11                	jmp    c0100885 <debuginfo_eip+0x227>
        return -1;
c0100874:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100879:	e9 08 01 00 00       	jmp    c0100986 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010087e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100881:	48                   	dec    %eax
c0100882:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100885:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088b:	39 c2                	cmp    %eax,%edx
c010088d:	7c 56                	jl     c01008e5 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
c010088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100892:	89 c2                	mov    %eax,%edx
c0100894:	89 d0                	mov    %edx,%eax
c0100896:	01 c0                	add    %eax,%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	c1 e0 02             	shl    $0x2,%eax
c010089d:	89 c2                	mov    %eax,%edx
c010089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a2:	01 d0                	add    %edx,%eax
c01008a4:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008a8:	3c 84                	cmp    $0x84,%al
c01008aa:	74 39                	je     c01008e5 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008af:	89 c2                	mov    %eax,%edx
c01008b1:	89 d0                	mov    %edx,%eax
c01008b3:	01 c0                	add    %eax,%eax
c01008b5:	01 d0                	add    %edx,%eax
c01008b7:	c1 e0 02             	shl    $0x2,%eax
c01008ba:	89 c2                	mov    %eax,%edx
c01008bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008bf:	01 d0                	add    %edx,%eax
c01008c1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008c5:	3c 64                	cmp    $0x64,%al
c01008c7:	75 b5                	jne    c010087e <debuginfo_eip+0x220>
c01008c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008cc:	89 c2                	mov    %eax,%edx
c01008ce:	89 d0                	mov    %edx,%eax
c01008d0:	01 c0                	add    %eax,%eax
c01008d2:	01 d0                	add    %edx,%eax
c01008d4:	c1 e0 02             	shl    $0x2,%eax
c01008d7:	89 c2                	mov    %eax,%edx
c01008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008dc:	01 d0                	add    %edx,%eax
c01008de:	8b 40 08             	mov    0x8(%eax),%eax
c01008e1:	85 c0                	test   %eax,%eax
c01008e3:	74 99                	je     c010087e <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008eb:	39 c2                	cmp    %eax,%edx
c01008ed:	7c 42                	jl     c0100931 <debuginfo_eip+0x2d3>
c01008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008f2:	89 c2                	mov    %eax,%edx
c01008f4:	89 d0                	mov    %edx,%eax
c01008f6:	01 c0                	add    %eax,%eax
c01008f8:	01 d0                	add    %edx,%eax
c01008fa:	c1 e0 02             	shl    $0x2,%eax
c01008fd:	89 c2                	mov    %eax,%edx
c01008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100902:	01 d0                	add    %edx,%eax
c0100904:	8b 10                	mov    (%eax),%edx
c0100906:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100909:	2b 45 ec             	sub    -0x14(%ebp),%eax
c010090c:	39 c2                	cmp    %eax,%edx
c010090e:	73 21                	jae    c0100931 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100910:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100913:	89 c2                	mov    %eax,%edx
c0100915:	89 d0                	mov    %edx,%eax
c0100917:	01 c0                	add    %eax,%eax
c0100919:	01 d0                	add    %edx,%eax
c010091b:	c1 e0 02             	shl    $0x2,%eax
c010091e:	89 c2                	mov    %eax,%edx
c0100920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100923:	01 d0                	add    %edx,%eax
c0100925:	8b 10                	mov    (%eax),%edx
c0100927:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010092a:	01 c2                	add    %eax,%edx
c010092c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010092f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100931:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100934:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100937:	39 c2                	cmp    %eax,%edx
c0100939:	7d 46                	jge    c0100981 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
c010093b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010093e:	40                   	inc    %eax
c010093f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100942:	eb 16                	jmp    c010095a <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100944:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100947:	8b 40 14             	mov    0x14(%eax),%eax
c010094a:	8d 50 01             	lea    0x1(%eax),%edx
c010094d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100950:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100953:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100956:	40                   	inc    %eax
c0100957:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010095d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100960:	39 c2                	cmp    %eax,%edx
c0100962:	7d 1d                	jge    c0100981 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100964:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100967:	89 c2                	mov    %eax,%edx
c0100969:	89 d0                	mov    %edx,%eax
c010096b:	01 c0                	add    %eax,%eax
c010096d:	01 d0                	add    %edx,%eax
c010096f:	c1 e0 02             	shl    $0x2,%eax
c0100972:	89 c2                	mov    %eax,%edx
c0100974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100977:	01 d0                	add    %edx,%eax
c0100979:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010097d:	3c a0                	cmp    $0xa0,%al
c010097f:	74 c3                	je     c0100944 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
c0100981:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100986:	c9                   	leave  
c0100987:	c3                   	ret    

c0100988 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100988:	f3 0f 1e fb          	endbr32 
c010098c:	55                   	push   %ebp
c010098d:	89 e5                	mov    %esp,%ebp
c010098f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100992:	c7 04 24 82 61 10 c0 	movl   $0xc0106182,(%esp)
c0100999:	e8 27 f9 ff ff       	call   c01002c5 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010099e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c01009a5:	c0 
c01009a6:	c7 04 24 9b 61 10 c0 	movl   $0xc010619b,(%esp)
c01009ad:	e8 13 f9 ff ff       	call   c01002c5 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009b2:	c7 44 24 04 67 60 10 	movl   $0xc0106067,0x4(%esp)
c01009b9:	c0 
c01009ba:	c7 04 24 b3 61 10 c0 	movl   $0xc01061b3,(%esp)
c01009c1:	e8 ff f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009c6:	c7 44 24 04 00 c0 11 	movl   $0xc011c000,0x4(%esp)
c01009cd:	c0 
c01009ce:	c7 04 24 cb 61 10 c0 	movl   $0xc01061cb,(%esp)
c01009d5:	e8 eb f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009da:	c7 44 24 04 28 cf 11 	movl   $0xc011cf28,0x4(%esp)
c01009e1:	c0 
c01009e2:	c7 04 24 e3 61 10 c0 	movl   $0xc01061e3,(%esp)
c01009e9:	e8 d7 f8 ff ff       	call   c01002c5 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009ee:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c01009f3:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01009f8:	05 ff 03 00 00       	add    $0x3ff,%eax
c01009fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a03:	85 c0                	test   %eax,%eax
c0100a05:	0f 48 c2             	cmovs  %edx,%eax
c0100a08:	c1 f8 0a             	sar    $0xa,%eax
c0100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0f:	c7 04 24 fc 61 10 c0 	movl   $0xc01061fc,(%esp)
c0100a16:	e8 aa f8 ff ff       	call   c01002c5 <cprintf>
}
c0100a1b:	90                   	nop
c0100a1c:	c9                   	leave  
c0100a1d:	c3                   	ret    

c0100a1e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a1e:	f3 0f 1e fb          	endbr32 
c0100a22:	55                   	push   %ebp
c0100a23:	89 e5                	mov    %esp,%ebp
c0100a25:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a2b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a35:	89 04 24             	mov    %eax,(%esp)
c0100a38:	e8 21 fc ff ff       	call   c010065e <debuginfo_eip>
c0100a3d:	85 c0                	test   %eax,%eax
c0100a3f:	74 15                	je     c0100a56 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a48:	c7 04 24 26 62 10 c0 	movl   $0xc0106226,(%esp)
c0100a4f:	e8 71 f8 ff ff       	call   c01002c5 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a54:	eb 6c                	jmp    c0100ac2 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a5d:	eb 1b                	jmp    c0100a7a <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
c0100a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a65:	01 d0                	add    %edx,%eax
c0100a67:	0f b6 10             	movzbl (%eax),%edx
c0100a6a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a73:	01 c8                	add    %ecx,%eax
c0100a75:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a77:	ff 45 f4             	incl   -0xc(%ebp)
c0100a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a7d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a80:	7c dd                	jl     c0100a5f <print_debuginfo+0x41>
        fnname[j] = '\0';
c0100a82:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a8b:	01 d0                	add    %edx,%eax
c0100a8d:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a93:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a96:	89 d1                	mov    %edx,%ecx
c0100a98:	29 c1                	sub    %eax,%ecx
c0100a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100aa0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100aa4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100aaa:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aae:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 42 62 10 c0 	movl   $0xc0106242,(%esp)
c0100abd:	e8 03 f8 ff ff       	call   c01002c5 <cprintf>
}
c0100ac2:	90                   	nop
c0100ac3:	c9                   	leave  
c0100ac4:	c3                   	ret    

c0100ac5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ac5:	f3 0f 1e fb          	endbr32 
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100acf:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ad2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ad8:	c9                   	leave  
c0100ad9:	c3                   	ret    

c0100ada <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ada:	f3 0f 1e fb          	endbr32 
c0100ade:	55                   	push   %ebp
c0100adf:	89 e5                	mov    %esp,%ebp
c0100ae1:	53                   	push   %ebx
c0100ae2:	83 ec 44             	sub    $0x44,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ae5:	89 e8                	mov    %ebp,%eax
c0100ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c0100aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
c0100aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
c0100af0:	e8 d0 ff ff ff       	call   c0100ac5 <read_eip>
c0100af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;   //这里有个细节问题，就是不能for int i，这里面的C标准似乎不允许
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
c0100af8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aff:	eb 7e                	jmp    c0100b7f <print_stackframe+0xa5>
	{
		cprintf("ebp:0x%08x eip:0x%08x\n",ebp,eip);
c0100b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b04:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0f:	c7 04 24 54 62 10 c0 	movl   $0xc0106254,(%esp)
c0100b16:	e8 aa f7 ff ff       	call   c01002c5 <cprintf>
		uint32_t *args=(uint32_t *)ebp+2;
c0100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1e:	83 c0 08             	add    $0x8,%eax
c0100b21:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("arg :0x%08x 0x%08x 0x%08x 0x%08x\n",*(args+0),*(args+1),*(args+2),*(args+3));//依次打印调用函数的参数1 2 3 4
c0100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b27:	83 c0 0c             	add    $0xc,%eax
c0100b2a:	8b 18                	mov    (%eax),%ebx
c0100b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b2f:	83 c0 08             	add    $0x8,%eax
c0100b32:	8b 08                	mov    (%eax),%ecx
c0100b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b37:	83 c0 04             	add    $0x4,%eax
c0100b3a:	8b 10                	mov    (%eax),%edx
c0100b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b3f:	8b 00                	mov    (%eax),%eax
c0100b41:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100b45:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100b49:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b51:	c7 04 24 6c 62 10 c0 	movl   $0xc010626c,(%esp)
c0100b58:	e8 68 f7 ff ff       	call   c01002c5 <cprintf>
 
 
    //因为使用的是栈数据结构，因此可以直接根据ebp就能读取到各个栈帧的地址和值，ebp+4处为返回地址，
    //ebp+8处为第一个参数值（最后一个入栈的参数值，对应32位系统），ebp-4处为第一个局部变量，ebp处为上一层 ebp 值。

		print_debuginfo(eip-1);
c0100b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b60:	48                   	dec    %eax
c0100b61:	89 04 24             	mov    %eax,(%esp)
c0100b64:	e8 b5 fe ff ff       	call   c0100a1e <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
c0100b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6c:	83 c0 04             	add    $0x4,%eax
c0100b6f:	8b 00                	mov    (%eax),%eax
c0100b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
c0100b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b77:	8b 00                	mov    (%eax),%eax
c0100b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(i=0;i<STACKFRAME_DEPTH&&ebp!=0;i++)
c0100b7c:	ff 45 ec             	incl   -0x14(%ebp)
c0100b7f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b83:	7f 0a                	jg     c0100b8f <print_stackframe+0xb5>
c0100b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b89:	0f 85 72 ff ff ff    	jne    c0100b01 <print_stackframe+0x27>
    }
}
c0100b8f:	90                   	nop
c0100b90:	83 c4 44             	add    $0x44,%esp
c0100b93:	5b                   	pop    %ebx
c0100b94:	5d                   	pop    %ebp
c0100b95:	c3                   	ret    

c0100b96 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b96:	f3 0f 1e fb          	endbr32 
c0100b9a:	55                   	push   %ebp
c0100b9b:	89 e5                	mov    %esp,%ebp
c0100b9d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba7:	eb 0c                	jmp    c0100bb5 <parse+0x1f>
            *buf ++ = '\0';
c0100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bac:	8d 50 01             	lea    0x1(%eax),%edx
c0100baf:	89 55 08             	mov    %edx,0x8(%ebp)
c0100bb2:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb8:	0f b6 00             	movzbl (%eax),%eax
c0100bbb:	84 c0                	test   %al,%al
c0100bbd:	74 1d                	je     c0100bdc <parse+0x46>
c0100bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc2:	0f b6 00             	movzbl (%eax),%eax
c0100bc5:	0f be c0             	movsbl %al,%eax
c0100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bcc:	c7 04 24 10 63 10 c0 	movl   $0xc0106310,(%esp)
c0100bd3:	e8 a9 4a 00 00       	call   c0105681 <strchr>
c0100bd8:	85 c0                	test   %eax,%eax
c0100bda:	75 cd                	jne    c0100ba9 <parse+0x13>
        }
        if (*buf == '\0') {
c0100bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdf:	0f b6 00             	movzbl (%eax),%eax
c0100be2:	84 c0                	test   %al,%al
c0100be4:	74 65                	je     c0100c4b <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100be6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bea:	75 14                	jne    c0100c00 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bec:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bf3:	00 
c0100bf4:	c7 04 24 15 63 10 c0 	movl   $0xc0106315,(%esp)
c0100bfb:	e8 c5 f6 ff ff       	call   c01002c5 <cprintf>
        }
        argv[argc ++] = buf;
c0100c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c03:	8d 50 01             	lea    0x1(%eax),%edx
c0100c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100c09:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c13:	01 c2                	add    %eax,%edx
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1a:	eb 03                	jmp    c0100c1f <parse+0x89>
            buf ++;
c0100c1c:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	0f b6 00             	movzbl (%eax),%eax
c0100c25:	84 c0                	test   %al,%al
c0100c27:	74 8c                	je     c0100bb5 <parse+0x1f>
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	0f b6 00             	movzbl (%eax),%eax
c0100c2f:	0f be c0             	movsbl %al,%eax
c0100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c36:	c7 04 24 10 63 10 c0 	movl   $0xc0106310,(%esp)
c0100c3d:	e8 3f 4a 00 00       	call   c0105681 <strchr>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	74 d6                	je     c0100c1c <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c46:	e9 6a ff ff ff       	jmp    c0100bb5 <parse+0x1f>
            break;
c0100c4b:	90                   	nop
        }
    }
    return argc;
c0100c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c4f:	c9                   	leave  
c0100c50:	c3                   	ret    

c0100c51 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c51:	f3 0f 1e fb          	endbr32 
c0100c55:	55                   	push   %ebp
c0100c56:	89 e5                	mov    %esp,%ebp
c0100c58:	53                   	push   %ebx
c0100c59:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c5c:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c63:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c66:	89 04 24             	mov    %eax,(%esp)
c0100c69:	e8 28 ff ff ff       	call   c0100b96 <parse>
c0100c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c75:	75 0a                	jne    c0100c81 <runcmd+0x30>
        return 0;
c0100c77:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c7c:	e9 83 00 00 00       	jmp    c0100d04 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c88:	eb 5a                	jmp    c0100ce4 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c8a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c90:	89 d0                	mov    %edx,%eax
c0100c92:	01 c0                	add    %eax,%eax
c0100c94:	01 d0                	add    %edx,%eax
c0100c96:	c1 e0 02             	shl    $0x2,%eax
c0100c99:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100c9e:	8b 00                	mov    (%eax),%eax
c0100ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ca4:	89 04 24             	mov    %eax,(%esp)
c0100ca7:	e8 31 49 00 00       	call   c01055dd <strcmp>
c0100cac:	85 c0                	test   %eax,%eax
c0100cae:	75 31                	jne    c0100ce1 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cb3:	89 d0                	mov    %edx,%eax
c0100cb5:	01 c0                	add    %eax,%eax
c0100cb7:	01 d0                	add    %edx,%eax
c0100cb9:	c1 e0 02             	shl    $0x2,%eax
c0100cbc:	05 08 90 11 c0       	add    $0xc0119008,%eax
c0100cc1:	8b 10                	mov    (%eax),%edx
c0100cc3:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100cc6:	83 c0 04             	add    $0x4,%eax
c0100cc9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100ccc:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100cd2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cda:	89 1c 24             	mov    %ebx,(%esp)
c0100cdd:	ff d2                	call   *%edx
c0100cdf:	eb 23                	jmp    c0100d04 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce1:	ff 45 f4             	incl   -0xc(%ebp)
c0100ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce7:	83 f8 02             	cmp    $0x2,%eax
c0100cea:	76 9e                	jbe    c0100c8a <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cec:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf3:	c7 04 24 33 63 10 c0 	movl   $0xc0106333,(%esp)
c0100cfa:	e8 c6 f5 ff ff       	call   c01002c5 <cprintf>
    return 0;
c0100cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d04:	83 c4 64             	add    $0x64,%esp
c0100d07:	5b                   	pop    %ebx
c0100d08:	5d                   	pop    %ebp
c0100d09:	c3                   	ret    

c0100d0a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100d0a:	f3 0f 1e fb          	endbr32 
c0100d0e:	55                   	push   %ebp
c0100d0f:	89 e5                	mov    %esp,%ebp
c0100d11:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100d14:	c7 04 24 4c 63 10 c0 	movl   $0xc010634c,(%esp)
c0100d1b:	e8 a5 f5 ff ff       	call   c01002c5 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d20:	c7 04 24 74 63 10 c0 	movl   $0xc0106374,(%esp)
c0100d27:	e8 99 f5 ff ff       	call   c01002c5 <cprintf>

    if (tf != NULL) {
c0100d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d30:	74 0b                	je     c0100d3d <kmonitor+0x33>
        print_trapframe(tf);
c0100d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d35:	89 04 24             	mov    %eax,(%esp)
c0100d38:	e8 b6 0e 00 00       	call   c0101bf3 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d3d:	c7 04 24 99 63 10 c0 	movl   $0xc0106399,(%esp)
c0100d44:	e8 2f f6 ff ff       	call   c0100378 <readline>
c0100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d50:	74 eb                	je     c0100d3d <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
c0100d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5c:	89 04 24             	mov    %eax,(%esp)
c0100d5f:	e8 ed fe ff ff       	call   c0100c51 <runcmd>
c0100d64:	85 c0                	test   %eax,%eax
c0100d66:	78 02                	js     c0100d6a <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
c0100d68:	eb d3                	jmp    c0100d3d <kmonitor+0x33>
                break;
c0100d6a:	90                   	nop
            }
        }
    }
}
c0100d6b:	90                   	nop
c0100d6c:	c9                   	leave  
c0100d6d:	c3                   	ret    

c0100d6e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d6e:	f3 0f 1e fb          	endbr32 
c0100d72:	55                   	push   %ebp
c0100d73:	89 e5                	mov    %esp,%ebp
c0100d75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d7f:	eb 3d                	jmp    c0100dbe <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d84:	89 d0                	mov    %edx,%eax
c0100d86:	01 c0                	add    %eax,%eax
c0100d88:	01 d0                	add    %edx,%eax
c0100d8a:	c1 e0 02             	shl    $0x2,%eax
c0100d8d:	05 04 90 11 c0       	add    $0xc0119004,%eax
c0100d92:	8b 08                	mov    (%eax),%ecx
c0100d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d97:	89 d0                	mov    %edx,%eax
c0100d99:	01 c0                	add    %eax,%eax
c0100d9b:	01 d0                	add    %edx,%eax
c0100d9d:	c1 e0 02             	shl    $0x2,%eax
c0100da0:	05 00 90 11 c0       	add    $0xc0119000,%eax
c0100da5:	8b 00                	mov    (%eax),%eax
c0100da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100dab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100daf:	c7 04 24 9d 63 10 c0 	movl   $0xc010639d,(%esp)
c0100db6:	e8 0a f5 ff ff       	call   c01002c5 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100dbb:	ff 45 f4             	incl   -0xc(%ebp)
c0100dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100dc1:	83 f8 02             	cmp    $0x2,%eax
c0100dc4:	76 bb                	jbe    c0100d81 <mon_help+0x13>
    }
    return 0;
c0100dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dcb:	c9                   	leave  
c0100dcc:	c3                   	ret    

c0100dcd <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100dcd:	f3 0f 1e fb          	endbr32 
c0100dd1:	55                   	push   %ebp
c0100dd2:	89 e5                	mov    %esp,%ebp
c0100dd4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dd7:	e8 ac fb ff ff       	call   c0100988 <print_kerninfo>
    return 0;
c0100ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de1:	c9                   	leave  
c0100de2:	c3                   	ret    

c0100de3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100de3:	f3 0f 1e fb          	endbr32 
c0100de7:	55                   	push   %ebp
c0100de8:	89 e5                	mov    %esp,%ebp
c0100dea:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ded:	e8 e8 fc ff ff       	call   c0100ada <print_stackframe>
    return 0;
c0100df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df7:	c9                   	leave  
c0100df8:	c3                   	ret    

c0100df9 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100df9:	f3 0f 1e fb          	endbr32 
c0100dfd:	55                   	push   %ebp
c0100dfe:	89 e5                	mov    %esp,%ebp
c0100e00:	83 ec 28             	sub    $0x28,%esp
c0100e03:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100e09:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e15:	ee                   	out    %al,(%dx)
}
c0100e16:	90                   	nop
c0100e17:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e1d:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e29:	ee                   	out    %al,(%dx)
}
c0100e2a:	90                   	nop
c0100e2b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100e31:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e35:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e39:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e3d:	ee                   	out    %al,(%dx)
}
c0100e3e:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100e3f:	c7 05 0c cf 11 c0 00 	movl   $0x0,0xc011cf0c
c0100e46:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e49:	c7 04 24 a6 63 10 c0 	movl   $0xc01063a6,(%esp)
c0100e50:	e8 70 f4 ff ff       	call   c01002c5 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e5c:	e8 95 09 00 00       	call   c01017f6 <pic_enable>
}
c0100e61:	90                   	nop
c0100e62:	c9                   	leave  
c0100e63:	c3                   	ret    

c0100e64 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e64:	55                   	push   %ebp
c0100e65:	89 e5                	mov    %esp,%ebp
c0100e67:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e6a:	9c                   	pushf  
c0100e6b:	58                   	pop    %eax
c0100e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e72:	25 00 02 00 00       	and    $0x200,%eax
c0100e77:	85 c0                	test   %eax,%eax
c0100e79:	74 0c                	je     c0100e87 <__intr_save+0x23>
        intr_disable();
c0100e7b:	e8 05 0b 00 00       	call   c0101985 <intr_disable>
        return 1;
c0100e80:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e85:	eb 05                	jmp    c0100e8c <__intr_save+0x28>
    }
    return 0;
c0100e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e8c:	c9                   	leave  
c0100e8d:	c3                   	ret    

c0100e8e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e8e:	55                   	push   %ebp
c0100e8f:	89 e5                	mov    %esp,%ebp
c0100e91:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e98:	74 05                	je     c0100e9f <__intr_restore+0x11>
        intr_enable();
c0100e9a:	e8 da 0a 00 00       	call   c0101979 <intr_enable>
    }
}
c0100e9f:	90                   	nop
c0100ea0:	c9                   	leave  
c0100ea1:	c3                   	ret    

c0100ea2 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100ea2:	f3 0f 1e fb          	endbr32 
c0100ea6:	55                   	push   %ebp
c0100ea7:	89 e5                	mov    %esp,%ebp
c0100ea9:	83 ec 10             	sub    $0x10,%esp
c0100eac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100eb6:	89 c2                	mov    %eax,%edx
c0100eb8:	ec                   	in     (%dx),%al
c0100eb9:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ebc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100ec2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ec6:	89 c2                	mov    %eax,%edx
c0100ec8:	ec                   	in     (%dx),%al
c0100ec9:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100ecc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100ed2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100ed6:	89 c2                	mov    %eax,%edx
c0100ed8:	ec                   	in     (%dx),%al
c0100ed9:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100edc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ee2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ee6:	89 c2                	mov    %eax,%edx
c0100ee8:	ec                   	in     (%dx),%al
c0100ee9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100eec:	90                   	nop
c0100eed:	c9                   	leave  
c0100eee:	c3                   	ret    

c0100eef <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100eef:	f3 0f 1e fb          	endbr32 
c0100ef3:	55                   	push   %ebp
c0100ef4:	89 e5                	mov    %esp,%ebp
c0100ef6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ef9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f03:	0f b7 00             	movzwl (%eax),%eax
c0100f06:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f0d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f15:	0f b7 00             	movzwl (%eax),%eax
c0100f18:	0f b7 c0             	movzwl %ax,%eax
c0100f1b:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100f20:	74 12                	je     c0100f34 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100f22:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100f29:	66 c7 05 46 c4 11 c0 	movw   $0x3b4,0xc011c446
c0100f30:	b4 03 
c0100f32:	eb 13                	jmp    c0100f47 <cga_init+0x58>
    } else {
        *cp = was;
c0100f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f3b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100f3e:	66 c7 05 46 c4 11 c0 	movw   $0x3d4,0xc011c446
c0100f45:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100f47:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f4e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f52:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f5e:	ee                   	out    %al,(%dx)
}
c0100f5f:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f60:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f67:	40                   	inc    %eax
c0100f68:	0f b7 c0             	movzwl %ax,%eax
c0100f6b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f73:	89 c2                	mov    %eax,%edx
c0100f75:	ec                   	in     (%dx),%al
c0100f76:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f79:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f7d:	0f b6 c0             	movzbl %al,%eax
c0100f80:	c1 e0 08             	shl    $0x8,%eax
c0100f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f86:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100f8d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f91:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
}
c0100f9e:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f9f:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0100fa6:	40                   	inc    %eax
c0100fa7:	0f b7 c0             	movzwl %ax,%eax
c0100faa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100fb2:	89 c2                	mov    %eax,%edx
c0100fb4:	ec                   	in     (%dx),%al
c0100fb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100fb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fbc:	0f b6 c0             	movzbl %al,%eax
c0100fbf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fc5:	a3 40 c4 11 c0       	mov    %eax,0xc011c440
    crt_pos = pos;
c0100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100fcd:	0f b7 c0             	movzwl %ax,%eax
c0100fd0:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
}
c0100fd6:	90                   	nop
c0100fd7:	c9                   	leave  
c0100fd8:	c3                   	ret    

c0100fd9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100fd9:	f3 0f 1e fb          	endbr32 
c0100fdd:	55                   	push   %ebp
c0100fde:	89 e5                	mov    %esp,%ebp
c0100fe0:	83 ec 48             	sub    $0x48,%esp
c0100fe3:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100fe9:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fed:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100ff1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100ff5:	ee                   	out    %al,(%dx)
}
c0100ff6:	90                   	nop
c0100ff7:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100ffd:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101001:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101005:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101009:	ee                   	out    %al,(%dx)
}
c010100a:	90                   	nop
c010100b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101011:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101015:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101019:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010101d:	ee                   	out    %al,(%dx)
}
c010101e:	90                   	nop
c010101f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101025:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101029:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010102d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101031:	ee                   	out    %al,(%dx)
}
c0101032:	90                   	nop
c0101033:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101039:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010103d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101041:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101045:	ee                   	out    %al,(%dx)
}
c0101046:	90                   	nop
c0101047:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c010104d:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101051:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101055:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101059:	ee                   	out    %al,(%dx)
}
c010105a:	90                   	nop
c010105b:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101061:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101065:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101069:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010106d:	ee                   	out    %al,(%dx)
}
c010106e:	90                   	nop
c010106f:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101075:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101079:	89 c2                	mov    %eax,%edx
c010107b:	ec                   	in     (%dx),%al
c010107c:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010107f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101083:	3c ff                	cmp    $0xff,%al
c0101085:	0f 95 c0             	setne  %al
c0101088:	0f b6 c0             	movzbl %al,%eax
c010108b:	a3 48 c4 11 c0       	mov    %eax,0xc011c448
c0101090:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101096:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010109a:	89 c2                	mov    %eax,%edx
c010109c:	ec                   	in     (%dx),%al
c010109d:	88 45 f1             	mov    %al,-0xf(%ebp)
c01010a0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01010a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010aa:	89 c2                	mov    %eax,%edx
c01010ac:	ec                   	in     (%dx),%al
c01010ad:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01010b0:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01010b5:	85 c0                	test   %eax,%eax
c01010b7:	74 0c                	je     c01010c5 <serial_init+0xec>
        pic_enable(IRQ_COM1);
c01010b9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01010c0:	e8 31 07 00 00       	call   c01017f6 <pic_enable>
    }
}
c01010c5:	90                   	nop
c01010c6:	c9                   	leave  
c01010c7:	c3                   	ret    

c01010c8 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01010c8:	f3 0f 1e fb          	endbr32 
c01010cc:	55                   	push   %ebp
c01010cd:	89 e5                	mov    %esp,%ebp
c01010cf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01010d9:	eb 08                	jmp    c01010e3 <lpt_putc_sub+0x1b>
        delay();
c01010db:	e8 c2 fd ff ff       	call   c0100ea2 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010e0:	ff 45 fc             	incl   -0x4(%ebp)
c01010e3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01010e9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01010ed:	89 c2                	mov    %eax,%edx
c01010ef:	ec                   	in     (%dx),%al
c01010f0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01010f3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010f7:	84 c0                	test   %al,%al
c01010f9:	78 09                	js     c0101104 <lpt_putc_sub+0x3c>
c01010fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101102:	7e d7                	jle    c01010db <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
c0101104:	8b 45 08             	mov    0x8(%ebp),%eax
c0101107:	0f b6 c0             	movzbl %al,%eax
c010110a:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101110:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101113:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101117:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010111b:	ee                   	out    %al,(%dx)
}
c010111c:	90                   	nop
c010111d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101123:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101127:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010112b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010112f:	ee                   	out    %al,(%dx)
}
c0101130:	90                   	nop
c0101131:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101137:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010113b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010113f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101143:	ee                   	out    %al,(%dx)
}
c0101144:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101145:	90                   	nop
c0101146:	c9                   	leave  
c0101147:	c3                   	ret    

c0101148 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101148:	f3 0f 1e fb          	endbr32 
c010114c:	55                   	push   %ebp
c010114d:	89 e5                	mov    %esp,%ebp
c010114f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101152:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101156:	74 0d                	je     c0101165 <lpt_putc+0x1d>
        lpt_putc_sub(c);
c0101158:	8b 45 08             	mov    0x8(%ebp),%eax
c010115b:	89 04 24             	mov    %eax,(%esp)
c010115e:	e8 65 ff ff ff       	call   c01010c8 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101163:	eb 24                	jmp    c0101189 <lpt_putc+0x41>
        lpt_putc_sub('\b');
c0101165:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010116c:	e8 57 ff ff ff       	call   c01010c8 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101171:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101178:	e8 4b ff ff ff       	call   c01010c8 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010117d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101184:	e8 3f ff ff ff       	call   c01010c8 <lpt_putc_sub>
}
c0101189:	90                   	nop
c010118a:	c9                   	leave  
c010118b:	c3                   	ret    

c010118c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010118c:	f3 0f 1e fb          	endbr32 
c0101190:	55                   	push   %ebp
c0101191:	89 e5                	mov    %esp,%ebp
c0101193:	53                   	push   %ebx
c0101194:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101197:	8b 45 08             	mov    0x8(%ebp),%eax
c010119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010119f:	85 c0                	test   %eax,%eax
c01011a1:	75 07                	jne    c01011aa <cga_putc+0x1e>
        c |= 0x0700;
c01011a3:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01011aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ad:	0f b6 c0             	movzbl %al,%eax
c01011b0:	83 f8 0d             	cmp    $0xd,%eax
c01011b3:	74 72                	je     c0101227 <cga_putc+0x9b>
c01011b5:	83 f8 0d             	cmp    $0xd,%eax
c01011b8:	0f 8f a3 00 00 00    	jg     c0101261 <cga_putc+0xd5>
c01011be:	83 f8 08             	cmp    $0x8,%eax
c01011c1:	74 0a                	je     c01011cd <cga_putc+0x41>
c01011c3:	83 f8 0a             	cmp    $0xa,%eax
c01011c6:	74 4c                	je     c0101214 <cga_putc+0x88>
c01011c8:	e9 94 00 00 00       	jmp    c0101261 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
c01011cd:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011d4:	85 c0                	test   %eax,%eax
c01011d6:	0f 84 af 00 00 00    	je     c010128b <cga_putc+0xff>
            crt_pos --;
c01011dc:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01011e3:	48                   	dec    %eax
c01011e4:	0f b7 c0             	movzwl %ax,%eax
c01011e7:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01011f0:	98                   	cwtl   
c01011f1:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01011f6:	98                   	cwtl   
c01011f7:	83 c8 20             	or     $0x20,%eax
c01011fa:	98                   	cwtl   
c01011fb:	8b 15 40 c4 11 c0    	mov    0xc011c440,%edx
c0101201:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101208:	01 c9                	add    %ecx,%ecx
c010120a:	01 ca                	add    %ecx,%edx
c010120c:	0f b7 c0             	movzwl %ax,%eax
c010120f:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101212:	eb 77                	jmp    c010128b <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
c0101214:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010121b:	83 c0 50             	add    $0x50,%eax
c010121e:	0f b7 c0             	movzwl %ax,%eax
c0101221:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101227:	0f b7 1d 44 c4 11 c0 	movzwl 0xc011c444,%ebx
c010122e:	0f b7 0d 44 c4 11 c0 	movzwl 0xc011c444,%ecx
c0101235:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010123a:	89 c8                	mov    %ecx,%eax
c010123c:	f7 e2                	mul    %edx
c010123e:	c1 ea 06             	shr    $0x6,%edx
c0101241:	89 d0                	mov    %edx,%eax
c0101243:	c1 e0 02             	shl    $0x2,%eax
c0101246:	01 d0                	add    %edx,%eax
c0101248:	c1 e0 04             	shl    $0x4,%eax
c010124b:	29 c1                	sub    %eax,%ecx
c010124d:	89 c8                	mov    %ecx,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	29 c3                	sub    %eax,%ebx
c0101254:	89 d8                	mov    %ebx,%eax
c0101256:	0f b7 c0             	movzwl %ax,%eax
c0101259:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
        break;
c010125f:	eb 2b                	jmp    c010128c <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101261:	8b 0d 40 c4 11 c0    	mov    0xc011c440,%ecx
c0101267:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010126e:	8d 50 01             	lea    0x1(%eax),%edx
c0101271:	0f b7 d2             	movzwl %dx,%edx
c0101274:	66 89 15 44 c4 11 c0 	mov    %dx,0xc011c444
c010127b:	01 c0                	add    %eax,%eax
c010127d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101280:	8b 45 08             	mov    0x8(%ebp),%eax
c0101283:	0f b7 c0             	movzwl %ax,%eax
c0101286:	66 89 02             	mov    %ax,(%edx)
        break;
c0101289:	eb 01                	jmp    c010128c <cga_putc+0x100>
        break;
c010128b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010128c:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101293:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101298:	76 5d                	jbe    c01012f7 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010129a:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c010129f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012a5:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012aa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012b1:	00 
c01012b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01012b6:	89 04 24             	mov    %eax,(%esp)
c01012b9:	e8 c8 45 00 00       	call   c0105886 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012be:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01012c5:	eb 14                	jmp    c01012db <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
c01012c7:	a1 40 c4 11 c0       	mov    0xc011c440,%eax
c01012cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012cf:	01 d2                	add    %edx,%edx
c01012d1:	01 d0                	add    %edx,%eax
c01012d3:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01012d8:	ff 45 f4             	incl   -0xc(%ebp)
c01012db:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01012e2:	7e e3                	jle    c01012c7 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
c01012e4:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c01012eb:	83 e8 50             	sub    $0x50,%eax
c01012ee:	0f b7 c0             	movzwl %ax,%eax
c01012f1:	66 a3 44 c4 11 c0    	mov    %ax,0xc011c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012f7:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c01012fe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101302:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101306:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010130a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010130e:	ee                   	out    %al,(%dx)
}
c010130f:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101310:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c0101317:	c1 e8 08             	shr    $0x8,%eax
c010131a:	0f b7 c0             	movzwl %ax,%eax
c010131d:	0f b6 c0             	movzbl %al,%eax
c0101320:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101327:	42                   	inc    %edx
c0101328:	0f b7 d2             	movzwl %dx,%edx
c010132b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010132f:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101332:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101336:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010133a:	ee                   	out    %al,(%dx)
}
c010133b:	90                   	nop
    outb(addr_6845, 15);
c010133c:	0f b7 05 46 c4 11 c0 	movzwl 0xc011c446,%eax
c0101343:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101347:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010134f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101353:	ee                   	out    %al,(%dx)
}
c0101354:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101355:	0f b7 05 44 c4 11 c0 	movzwl 0xc011c444,%eax
c010135c:	0f b6 c0             	movzbl %al,%eax
c010135f:	0f b7 15 46 c4 11 c0 	movzwl 0xc011c446,%edx
c0101366:	42                   	inc    %edx
c0101367:	0f b7 d2             	movzwl %dx,%edx
c010136a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c010136e:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101371:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101375:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101379:	ee                   	out    %al,(%dx)
}
c010137a:	90                   	nop
}
c010137b:	90                   	nop
c010137c:	83 c4 34             	add    $0x34,%esp
c010137f:	5b                   	pop    %ebx
c0101380:	5d                   	pop    %ebp
c0101381:	c3                   	ret    

c0101382 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101382:	f3 0f 1e fb          	endbr32 
c0101386:	55                   	push   %ebp
c0101387:	89 e5                	mov    %esp,%ebp
c0101389:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101393:	eb 08                	jmp    c010139d <serial_putc_sub+0x1b>
        delay();
c0101395:	e8 08 fb ff ff       	call   c0100ea2 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010139a:	ff 45 fc             	incl   -0x4(%ebp)
c010139d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013a7:	89 c2                	mov    %eax,%edx
c01013a9:	ec                   	in     (%dx),%al
c01013aa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ad:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013b1:	0f b6 c0             	movzbl %al,%eax
c01013b4:	83 e0 20             	and    $0x20,%eax
c01013b7:	85 c0                	test   %eax,%eax
c01013b9:	75 09                	jne    c01013c4 <serial_putc_sub+0x42>
c01013bb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01013c2:	7e d1                	jle    c0101395 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
c01013c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01013c7:	0f b6 c0             	movzbl %al,%eax
c01013ca:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01013d0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013d3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01013d7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01013db:	ee                   	out    %al,(%dx)
}
c01013dc:	90                   	nop
}
c01013dd:	90                   	nop
c01013de:	c9                   	leave  
c01013df:	c3                   	ret    

c01013e0 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01013e0:	f3 0f 1e fb          	endbr32 
c01013e4:	55                   	push   %ebp
c01013e5:	89 e5                	mov    %esp,%ebp
c01013e7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01013ea:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013ee:	74 0d                	je     c01013fd <serial_putc+0x1d>
        serial_putc_sub(c);
c01013f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01013f3:	89 04 24             	mov    %eax,(%esp)
c01013f6:	e8 87 ff ff ff       	call   c0101382 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013fb:	eb 24                	jmp    c0101421 <serial_putc+0x41>
        serial_putc_sub('\b');
c01013fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101404:	e8 79 ff ff ff       	call   c0101382 <serial_putc_sub>
        serial_putc_sub(' ');
c0101409:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101410:	e8 6d ff ff ff       	call   c0101382 <serial_putc_sub>
        serial_putc_sub('\b');
c0101415:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010141c:	e8 61 ff ff ff       	call   c0101382 <serial_putc_sub>
}
c0101421:	90                   	nop
c0101422:	c9                   	leave  
c0101423:	c3                   	ret    

c0101424 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101424:	f3 0f 1e fb          	endbr32 
c0101428:	55                   	push   %ebp
c0101429:	89 e5                	mov    %esp,%ebp
c010142b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010142e:	eb 33                	jmp    c0101463 <cons_intr+0x3f>
        if (c != 0) {
c0101430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101434:	74 2d                	je     c0101463 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
c0101436:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c010143b:	8d 50 01             	lea    0x1(%eax),%edx
c010143e:	89 15 64 c6 11 c0    	mov    %edx,0xc011c664
c0101444:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101447:	88 90 60 c4 11 c0    	mov    %dl,-0x3fee3ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010144d:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101452:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101457:	75 0a                	jne    c0101463 <cons_intr+0x3f>
                cons.wpos = 0;
c0101459:	c7 05 64 c6 11 c0 00 	movl   $0x0,0xc011c664
c0101460:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101463:	8b 45 08             	mov    0x8(%ebp),%eax
c0101466:	ff d0                	call   *%eax
c0101468:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010146b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010146f:	75 bf                	jne    c0101430 <cons_intr+0xc>
            }
        }
    }
}
c0101471:	90                   	nop
c0101472:	90                   	nop
c0101473:	c9                   	leave  
c0101474:	c3                   	ret    

c0101475 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101475:	f3 0f 1e fb          	endbr32 
c0101479:	55                   	push   %ebp
c010147a:	89 e5                	mov    %esp,%ebp
c010147c:	83 ec 10             	sub    $0x10,%esp
c010147f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101485:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101489:	89 c2                	mov    %eax,%edx
c010148b:	ec                   	in     (%dx),%al
c010148c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010148f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101493:	0f b6 c0             	movzbl %al,%eax
c0101496:	83 e0 01             	and    $0x1,%eax
c0101499:	85 c0                	test   %eax,%eax
c010149b:	75 07                	jne    c01014a4 <serial_proc_data+0x2f>
        return -1;
c010149d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014a2:	eb 2a                	jmp    c01014ce <serial_proc_data+0x59>
c01014a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014aa:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014ae:	89 c2                	mov    %eax,%edx
c01014b0:	ec                   	in     (%dx),%al
c01014b1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014b8:	0f b6 c0             	movzbl %al,%eax
c01014bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014be:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014c2:	75 07                	jne    c01014cb <serial_proc_data+0x56>
        c = '\b';
c01014c4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01014cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01014ce:	c9                   	leave  
c01014cf:	c3                   	ret    

c01014d0 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01014d0:	f3 0f 1e fb          	endbr32 
c01014d4:	55                   	push   %ebp
c01014d5:	89 e5                	mov    %esp,%ebp
c01014d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01014da:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01014df:	85 c0                	test   %eax,%eax
c01014e1:	74 0c                	je     c01014ef <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01014e3:	c7 04 24 75 14 10 c0 	movl   $0xc0101475,(%esp)
c01014ea:	e8 35 ff ff ff       	call   c0101424 <cons_intr>
    }
}
c01014ef:	90                   	nop
c01014f0:	c9                   	leave  
c01014f1:	c3                   	ret    

c01014f2 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014f2:	f3 0f 1e fb          	endbr32 
c01014f6:	55                   	push   %ebp
c01014f7:	89 e5                	mov    %esp,%ebp
c01014f9:	83 ec 38             	sub    $0x38,%esp
c01014fc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101502:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101505:	89 c2                	mov    %eax,%edx
c0101507:	ec                   	in     (%dx),%al
c0101508:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010150b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010150f:	0f b6 c0             	movzbl %al,%eax
c0101512:	83 e0 01             	and    $0x1,%eax
c0101515:	85 c0                	test   %eax,%eax
c0101517:	75 0a                	jne    c0101523 <kbd_proc_data+0x31>
        return -1;
c0101519:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010151e:	e9 56 01 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
c0101523:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101529:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010152c:	89 c2                	mov    %eax,%edx
c010152e:	ec                   	in     (%dx),%al
c010152f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101532:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101536:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101539:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010153d:	75 17                	jne    c0101556 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
c010153f:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101544:	83 c8 40             	or     $0x40,%eax
c0101547:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c010154c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101551:	e9 23 01 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101556:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010155a:	84 c0                	test   %al,%al
c010155c:	79 45                	jns    c01015a3 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010155e:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101563:	83 e0 40             	and    $0x40,%eax
c0101566:	85 c0                	test   %eax,%eax
c0101568:	75 08                	jne    c0101572 <kbd_proc_data+0x80>
c010156a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010156e:	24 7f                	and    $0x7f,%al
c0101570:	eb 04                	jmp    c0101576 <kbd_proc_data+0x84>
c0101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101576:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101579:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157d:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c0101584:	0c 40                	or     $0x40,%al
c0101586:	0f b6 c0             	movzbl %al,%eax
c0101589:	f7 d0                	not    %eax
c010158b:	89 c2                	mov    %eax,%edx
c010158d:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101592:	21 d0                	and    %edx,%eax
c0101594:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
        return 0;
c0101599:	b8 00 00 00 00       	mov    $0x0,%eax
c010159e:	e9 d6 00 00 00       	jmp    c0101679 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015a3:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015a8:	83 e0 40             	and    $0x40,%eax
c01015ab:	85 c0                	test   %eax,%eax
c01015ad:	74 11                	je     c01015c0 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015af:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015b3:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015b8:	83 e0 bf             	and    $0xffffffbf,%eax
c01015bb:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    }

    shift |= shiftcode[data];
c01015c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015c4:	0f b6 80 40 90 11 c0 	movzbl -0x3fee6fc0(%eax),%eax
c01015cb:	0f b6 d0             	movzbl %al,%edx
c01015ce:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015d3:	09 d0                	or     %edx,%eax
c01015d5:	a3 68 c6 11 c0       	mov    %eax,0xc011c668
    shift ^= togglecode[data];
c01015da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015de:	0f b6 80 40 91 11 c0 	movzbl -0x3fee6ec0(%eax),%eax
c01015e5:	0f b6 d0             	movzbl %al,%edx
c01015e8:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015ed:	31 d0                	xor    %edx,%eax
c01015ef:	a3 68 c6 11 c0       	mov    %eax,0xc011c668

    c = charcode[shift & (CTL | SHIFT)][data];
c01015f4:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c01015f9:	83 e0 03             	and    $0x3,%eax
c01015fc:	8b 14 85 40 95 11 c0 	mov    -0x3fee6ac0(,%eax,4),%edx
c0101603:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101607:	01 d0                	add    %edx,%eax
c0101609:	0f b6 00             	movzbl (%eax),%eax
c010160c:	0f b6 c0             	movzbl %al,%eax
c010160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101612:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101617:	83 e0 08             	and    $0x8,%eax
c010161a:	85 c0                	test   %eax,%eax
c010161c:	74 22                	je     c0101640 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010161e:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101622:	7e 0c                	jle    c0101630 <kbd_proc_data+0x13e>
c0101624:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101628:	7f 06                	jg     c0101630 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010162a:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010162e:	eb 10                	jmp    c0101640 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101630:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101634:	7e 0a                	jle    c0101640 <kbd_proc_data+0x14e>
c0101636:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010163a:	7f 04                	jg     c0101640 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010163c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101640:	a1 68 c6 11 c0       	mov    0xc011c668,%eax
c0101645:	f7 d0                	not    %eax
c0101647:	83 e0 06             	and    $0x6,%eax
c010164a:	85 c0                	test   %eax,%eax
c010164c:	75 28                	jne    c0101676 <kbd_proc_data+0x184>
c010164e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101655:	75 1f                	jne    c0101676 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101657:	c7 04 24 c1 63 10 c0 	movl   $0xc01063c1,(%esp)
c010165e:	e8 62 ec ff ff       	call   c01002c5 <cprintf>
c0101663:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101669:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010166d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101671:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101674:	ee                   	out    %al,(%dx)
}
c0101675:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101679:	c9                   	leave  
c010167a:	c3                   	ret    

c010167b <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010167b:	f3 0f 1e fb          	endbr32 
c010167f:	55                   	push   %ebp
c0101680:	89 e5                	mov    %esp,%ebp
c0101682:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101685:	c7 04 24 f2 14 10 c0 	movl   $0xc01014f2,(%esp)
c010168c:	e8 93 fd ff ff       	call   c0101424 <cons_intr>
}
c0101691:	90                   	nop
c0101692:	c9                   	leave  
c0101693:	c3                   	ret    

c0101694 <kbd_init>:

static void
kbd_init(void) {
c0101694:	f3 0f 1e fb          	endbr32 
c0101698:	55                   	push   %ebp
c0101699:	89 e5                	mov    %esp,%ebp
c010169b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010169e:	e8 d8 ff ff ff       	call   c010167b <kbd_intr>
    pic_enable(IRQ_KBD);
c01016a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016aa:	e8 47 01 00 00       	call   c01017f6 <pic_enable>
}
c01016af:	90                   	nop
c01016b0:	c9                   	leave  
c01016b1:	c3                   	ret    

c01016b2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016b2:	f3 0f 1e fb          	endbr32 
c01016b6:	55                   	push   %ebp
c01016b7:	89 e5                	mov    %esp,%ebp
c01016b9:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016bc:	e8 2e f8 ff ff       	call   c0100eef <cga_init>
    serial_init();
c01016c1:	e8 13 f9 ff ff       	call   c0100fd9 <serial_init>
    kbd_init();
c01016c6:	e8 c9 ff ff ff       	call   c0101694 <kbd_init>
    if (!serial_exists) {
c01016cb:	a1 48 c4 11 c0       	mov    0xc011c448,%eax
c01016d0:	85 c0                	test   %eax,%eax
c01016d2:	75 0c                	jne    c01016e0 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01016d4:	c7 04 24 cd 63 10 c0 	movl   $0xc01063cd,(%esp)
c01016db:	e8 e5 eb ff ff       	call   c01002c5 <cprintf>
    }
}
c01016e0:	90                   	nop
c01016e1:	c9                   	leave  
c01016e2:	c3                   	ret    

c01016e3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016e3:	f3 0f 1e fb          	endbr32 
c01016e7:	55                   	push   %ebp
c01016e8:	89 e5                	mov    %esp,%ebp
c01016ea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016ed:	e8 72 f7 ff ff       	call   c0100e64 <__intr_save>
c01016f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f8:	89 04 24             	mov    %eax,(%esp)
c01016fb:	e8 48 fa ff ff       	call   c0101148 <lpt_putc>
        cga_putc(c);
c0101700:	8b 45 08             	mov    0x8(%ebp),%eax
c0101703:	89 04 24             	mov    %eax,(%esp)
c0101706:	e8 81 fa ff ff       	call   c010118c <cga_putc>
        serial_putc(c);
c010170b:	8b 45 08             	mov    0x8(%ebp),%eax
c010170e:	89 04 24             	mov    %eax,(%esp)
c0101711:	e8 ca fc ff ff       	call   c01013e0 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101719:	89 04 24             	mov    %eax,(%esp)
c010171c:	e8 6d f7 ff ff       	call   c0100e8e <__intr_restore>
}
c0101721:	90                   	nop
c0101722:	c9                   	leave  
c0101723:	c3                   	ret    

c0101724 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101724:	f3 0f 1e fb          	endbr32 
c0101728:	55                   	push   %ebp
c0101729:	89 e5                	mov    %esp,%ebp
c010172b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010172e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101735:	e8 2a f7 ff ff       	call   c0100e64 <__intr_save>
c010173a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010173d:	e8 8e fd ff ff       	call   c01014d0 <serial_intr>
        kbd_intr();
c0101742:	e8 34 ff ff ff       	call   c010167b <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101747:	8b 15 60 c6 11 c0    	mov    0xc011c660,%edx
c010174d:	a1 64 c6 11 c0       	mov    0xc011c664,%eax
c0101752:	39 c2                	cmp    %eax,%edx
c0101754:	74 31                	je     c0101787 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
c0101756:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c010175b:	8d 50 01             	lea    0x1(%eax),%edx
c010175e:	89 15 60 c6 11 c0    	mov    %edx,0xc011c660
c0101764:	0f b6 80 60 c4 11 c0 	movzbl -0x3fee3ba0(%eax),%eax
c010176b:	0f b6 c0             	movzbl %al,%eax
c010176e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101771:	a1 60 c6 11 c0       	mov    0xc011c660,%eax
c0101776:	3d 00 02 00 00       	cmp    $0x200,%eax
c010177b:	75 0a                	jne    c0101787 <cons_getc+0x63>
                cons.rpos = 0;
c010177d:	c7 05 60 c6 11 c0 00 	movl   $0x0,0xc011c660
c0101784:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101787:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010178a:	89 04 24             	mov    %eax,(%esp)
c010178d:	e8 fc f6 ff ff       	call   c0100e8e <__intr_restore>
    return c;
c0101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101795:	c9                   	leave  
c0101796:	c3                   	ret    

c0101797 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101797:	f3 0f 1e fb          	endbr32 
c010179b:	55                   	push   %ebp
c010179c:	89 e5                	mov    %esp,%ebp
c010179e:	83 ec 14             	sub    $0x14,%esp
c01017a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017ab:	66 a3 50 95 11 c0    	mov    %ax,0xc0119550
    if (did_init) {
c01017b1:	a1 6c c6 11 c0       	mov    0xc011c66c,%eax
c01017b6:	85 c0                	test   %eax,%eax
c01017b8:	74 39                	je     c01017f3 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
c01017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01017bd:	0f b6 c0             	movzbl %al,%eax
c01017c0:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01017c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017cd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017d1:	ee                   	out    %al,(%dx)
}
c01017d2:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01017d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017d7:	c1 e8 08             	shr    $0x8,%eax
c01017da:	0f b7 c0             	movzwl %ax,%eax
c01017dd:	0f b6 c0             	movzbl %al,%eax
c01017e0:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01017e6:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017ed:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017f1:	ee                   	out    %al,(%dx)
}
c01017f2:	90                   	nop
    }
}
c01017f3:	90                   	nop
c01017f4:	c9                   	leave  
c01017f5:	c3                   	ret    

c01017f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017f6:	f3 0f 1e fb          	endbr32 
c01017fa:	55                   	push   %ebp
c01017fb:	89 e5                	mov    %esp,%ebp
c01017fd:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101800:	8b 45 08             	mov    0x8(%ebp),%eax
c0101803:	ba 01 00 00 00       	mov    $0x1,%edx
c0101808:	88 c1                	mov    %al,%cl
c010180a:	d3 e2                	shl    %cl,%edx
c010180c:	89 d0                	mov    %edx,%eax
c010180e:	98                   	cwtl   
c010180f:	f7 d0                	not    %eax
c0101811:	0f bf d0             	movswl %ax,%edx
c0101814:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010181b:	98                   	cwtl   
c010181c:	21 d0                	and    %edx,%eax
c010181e:	98                   	cwtl   
c010181f:	0f b7 c0             	movzwl %ax,%eax
c0101822:	89 04 24             	mov    %eax,(%esp)
c0101825:	e8 6d ff ff ff       	call   c0101797 <pic_setmask>
}
c010182a:	90                   	nop
c010182b:	c9                   	leave  
c010182c:	c3                   	ret    

c010182d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010182d:	f3 0f 1e fb          	endbr32 
c0101831:	55                   	push   %ebp
c0101832:	89 e5                	mov    %esp,%ebp
c0101834:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101837:	c7 05 6c c6 11 c0 01 	movl   $0x1,0xc011c66c
c010183e:	00 00 00 
c0101841:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101847:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
}
c0101854:	90                   	nop
c0101855:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010185b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101863:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101867:	ee                   	out    %al,(%dx)
}
c0101868:	90                   	nop
c0101869:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010186f:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101873:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101877:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
}
c010187c:	90                   	nop
c010187d:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101883:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101887:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010188b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010188f:	ee                   	out    %al,(%dx)
}
c0101890:	90                   	nop
c0101891:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101897:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010189f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01018a3:	ee                   	out    %al,(%dx)
}
c01018a4:	90                   	nop
c01018a5:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01018ab:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018af:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01018b3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01018b7:	ee                   	out    %al,(%dx)
}
c01018b8:	90                   	nop
c01018b9:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01018bf:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01018c7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01018cb:	ee                   	out    %al,(%dx)
}
c01018cc:	90                   	nop
c01018cd:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01018d3:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01018db:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01018df:	ee                   	out    %al,(%dx)
}
c01018e0:	90                   	nop
c01018e1:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01018e7:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018eb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01018ef:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01018f3:	ee                   	out    %al,(%dx)
}
c01018f4:	90                   	nop
c01018f5:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01018fb:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101903:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101907:	ee                   	out    %al,(%dx)
}
c0101908:	90                   	nop
c0101909:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010190f:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101913:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101917:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010191b:	ee                   	out    %al,(%dx)
}
c010191c:	90                   	nop
c010191d:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101923:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101927:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010192b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010192f:	ee                   	out    %al,(%dx)
}
c0101930:	90                   	nop
c0101931:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101937:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010193b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010193f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101943:	ee                   	out    %al,(%dx)
}
c0101944:	90                   	nop
c0101945:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010194b:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010194f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101953:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101957:	ee                   	out    %al,(%dx)
}
c0101958:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101959:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c0101960:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101965:	74 0f                	je     c0101976 <pic_init+0x149>
        pic_setmask(irq_mask);
c0101967:	0f b7 05 50 95 11 c0 	movzwl 0xc0119550,%eax
c010196e:	89 04 24             	mov    %eax,(%esp)
c0101971:	e8 21 fe ff ff       	call   c0101797 <pic_setmask>
    }
}
c0101976:	90                   	nop
c0101977:	c9                   	leave  
c0101978:	c3                   	ret    

c0101979 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101979:	f3 0f 1e fb          	endbr32 
c010197d:	55                   	push   %ebp
c010197e:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101980:	fb                   	sti    
}
c0101981:	90                   	nop
    sti();
}
c0101982:	90                   	nop
c0101983:	5d                   	pop    %ebp
c0101984:	c3                   	ret    

c0101985 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101985:	f3 0f 1e fb          	endbr32 
c0101989:	55                   	push   %ebp
c010198a:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010198c:	fa                   	cli    
}
c010198d:	90                   	nop
    cli();
}
c010198e:	90                   	nop
c010198f:	5d                   	pop    %ebp
c0101990:	c3                   	ret    

c0101991 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101991:	f3 0f 1e fb          	endbr32 
c0101995:	55                   	push   %ebp
c0101996:	89 e5                	mov    %esp,%ebp
c0101998:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010199b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01019a2:	00 
c01019a3:	c7 04 24 00 64 10 c0 	movl   $0xc0106400,(%esp)
c01019aa:	e8 16 e9 ff ff       	call   c01002c5 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01019af:	90                   	nop
c01019b0:	c9                   	leave  
c01019b1:	c3                   	ret    

c01019b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01019b2:	f3 0f 1e fb          	endbr32 
c01019b6:	55                   	push   %ebp
c01019b7:	89 e5                	mov    %esp,%ebp
c01019b9:	83 ec 10             	sub    $0x10,%esp
      */
    extern uintptr_t __vectors[];

    //all gate DPL=0, so use DPL_KERNEL 
    int i;
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
c01019bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01019c3:	e9 c4 00 00 00       	jmp    c0101a8c <idt_init+0xda>
        SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
c01019c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cb:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c01019d2:	0f b7 d0             	movzwl %ax,%edx
c01019d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d8:	66 89 14 c5 80 c6 11 	mov    %dx,-0x3fee3980(,%eax,8)
c01019df:	c0 
c01019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e3:	66 c7 04 c5 82 c6 11 	movw   $0x8,-0x3fee397e(,%eax,8)
c01019ea:	c0 08 00 
c01019ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f0:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c01019f7:	c0 
c01019f8:	80 e2 e0             	and    $0xe0,%dl
c01019fb:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a05:	0f b6 14 c5 84 c6 11 	movzbl -0x3fee397c(,%eax,8),%edx
c0101a0c:	c0 
c0101a0d:	80 e2 1f             	and    $0x1f,%dl
c0101a10:	88 14 c5 84 c6 11 c0 	mov    %dl,-0x3fee397c(,%eax,8)
c0101a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1a:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a21:	c0 
c0101a22:	80 e2 f0             	and    $0xf0,%dl
c0101a25:	80 ca 0e             	or     $0xe,%dl
c0101a28:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a32:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a39:	c0 
c0101a3a:	80 e2 ef             	and    $0xef,%dl
c0101a3d:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a47:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a4e:	c0 
c0101a4f:	80 e2 9f             	and    $0x9f,%dl
c0101a52:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a5c:	0f b6 14 c5 85 c6 11 	movzbl -0x3fee397b(,%eax,8),%edx
c0101a63:	c0 
c0101a64:	80 ca 80             	or     $0x80,%dl
c0101a67:	88 14 c5 85 c6 11 c0 	mov    %dl,-0x3fee397b(,%eax,8)
c0101a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a71:	8b 04 85 e0 95 11 c0 	mov    -0x3fee6a20(,%eax,4),%eax
c0101a78:	c1 e8 10             	shr    $0x10,%eax
c0101a7b:	0f b7 d0             	movzwl %ax,%edx
c0101a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a81:	66 89 14 c5 86 c6 11 	mov    %dx,-0x3fee397a(,%eax,8)
c0101a88:	c0 
    for(i=0;i<sizeof(idt)/sizeof(struct gatedesc);i++){
c0101a89:	ff 45 fc             	incl   -0x4(%ebp)
c0101a8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a8f:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a94:	0f 86 2e ff ff ff    	jbe    c01019c8 <idt_init+0x16>
    }
    SETGATE(idt[T_SYSCALL],1,KERNEL_CS,__vectors[T_SYSCALL],DPL_USER);
c0101a9a:	a1 e0 97 11 c0       	mov    0xc01197e0,%eax
c0101a9f:	0f b7 c0             	movzwl %ax,%eax
c0101aa2:	66 a3 80 ca 11 c0    	mov    %ax,0xc011ca80
c0101aa8:	66 c7 05 82 ca 11 c0 	movw   $0x8,0xc011ca82
c0101aaf:	08 00 
c0101ab1:	0f b6 05 84 ca 11 c0 	movzbl 0xc011ca84,%eax
c0101ab8:	24 e0                	and    $0xe0,%al
c0101aba:	a2 84 ca 11 c0       	mov    %al,0xc011ca84
c0101abf:	0f b6 05 84 ca 11 c0 	movzbl 0xc011ca84,%eax
c0101ac6:	24 1f                	and    $0x1f,%al
c0101ac8:	a2 84 ca 11 c0       	mov    %al,0xc011ca84
c0101acd:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101ad4:	0c 0f                	or     $0xf,%al
c0101ad6:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101adb:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101ae2:	24 ef                	and    $0xef,%al
c0101ae4:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101ae9:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101af0:	0c 60                	or     $0x60,%al
c0101af2:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101af7:	0f b6 05 85 ca 11 c0 	movzbl 0xc011ca85,%eax
c0101afe:	0c 80                	or     $0x80,%al
c0101b00:	a2 85 ca 11 c0       	mov    %al,0xc011ca85
c0101b05:	a1 e0 97 11 c0       	mov    0xc01197e0,%eax
c0101b0a:	c1 e8 10             	shr    $0x10,%eax
c0101b0d:	0f b7 c0             	movzwl %ax,%eax
c0101b10:	66 a3 86 ca 11 c0    	mov    %ax,0xc011ca86
    SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],DPL_USER);
c0101b16:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101b1b:	0f b7 c0             	movzwl %ax,%eax
c0101b1e:	66 a3 48 ca 11 c0    	mov    %ax,0xc011ca48
c0101b24:	66 c7 05 4a ca 11 c0 	movw   $0x8,0xc011ca4a
c0101b2b:	08 00 
c0101b2d:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101b34:	24 e0                	and    $0xe0,%al
c0101b36:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101b3b:	0f b6 05 4c ca 11 c0 	movzbl 0xc011ca4c,%eax
c0101b42:	24 1f                	and    $0x1f,%al
c0101b44:	a2 4c ca 11 c0       	mov    %al,0xc011ca4c
c0101b49:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b50:	24 f0                	and    $0xf0,%al
c0101b52:	0c 0e                	or     $0xe,%al
c0101b54:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b59:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b60:	24 ef                	and    $0xef,%al
c0101b62:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b67:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b6e:	0c 60                	or     $0x60,%al
c0101b70:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b75:	0f b6 05 4d ca 11 c0 	movzbl 0xc011ca4d,%eax
c0101b7c:	0c 80                	or     $0x80,%al
c0101b7e:	a2 4d ca 11 c0       	mov    %al,0xc011ca4d
c0101b83:	a1 c4 97 11 c0       	mov    0xc01197c4,%eax
c0101b88:	c1 e8 10             	shr    $0x10,%eax
c0101b8b:	0f b7 c0             	movzwl %ax,%eax
c0101b8e:	66 a3 4e ca 11 c0    	mov    %ax,0xc011ca4e
c0101b94:	c7 45 f8 60 95 11 c0 	movl   $0xc0119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101b9e:	0f 01 18             	lidtl  (%eax)
}
c0101ba1:	90                   	nop
    
    //建立好中断门描述符表后，通过指令lidt把中断门描述符表的起始地址装入IDTR寄存器中，从而完成中段描述符表的初始化工作。
    lidt(&idt_pd);
}
c0101ba2:	90                   	nop
c0101ba3:	c9                   	leave  
c0101ba4:	c3                   	ret    

c0101ba5 <trapname>:

static const char *
trapname(int trapno) {
c0101ba5:	f3 0f 1e fb          	endbr32 
c0101ba9:	55                   	push   %ebp
c0101baa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101baf:	83 f8 13             	cmp    $0x13,%eax
c0101bb2:	77 0c                	ja     c0101bc0 <trapname+0x1b>
        return excnames[trapno];
c0101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb7:	8b 04 85 60 67 10 c0 	mov    -0x3fef98a0(,%eax,4),%eax
c0101bbe:	eb 18                	jmp    c0101bd8 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101bc0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101bc4:	7e 0d                	jle    c0101bd3 <trapname+0x2e>
c0101bc6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101bca:	7f 07                	jg     c0101bd3 <trapname+0x2e>
        return "Hardware Interrupt";
c0101bcc:	b8 0a 64 10 c0       	mov    $0xc010640a,%eax
c0101bd1:	eb 05                	jmp    c0101bd8 <trapname+0x33>
    }
    return "(unknown trap)";
c0101bd3:	b8 1d 64 10 c0       	mov    $0xc010641d,%eax
}
c0101bd8:	5d                   	pop    %ebp
c0101bd9:	c3                   	ret    

c0101bda <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101bda:	f3 0f 1e fb          	endbr32 
c0101bde:	55                   	push   %ebp
c0101bdf:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101be8:	83 f8 08             	cmp    $0x8,%eax
c0101beb:	0f 94 c0             	sete   %al
c0101bee:	0f b6 c0             	movzbl %al,%eax
}
c0101bf1:	5d                   	pop    %ebp
c0101bf2:	c3                   	ret    

c0101bf3 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101bf3:	f3 0f 1e fb          	endbr32 
c0101bf7:	55                   	push   %ebp
c0101bf8:	89 e5                	mov    %esp,%ebp
c0101bfa:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c04:	c7 04 24 5e 64 10 c0 	movl   $0xc010645e,(%esp)
c0101c0b:	e8 b5 e6 ff ff       	call   c01002c5 <cprintf>
    print_regs(&tf->tf_regs);
c0101c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c13:	89 04 24             	mov    %eax,(%esp)
c0101c16:	e8 8d 01 00 00       	call   c0101da8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c26:	c7 04 24 6f 64 10 c0 	movl   $0xc010646f,(%esp)
c0101c2d:	e8 93 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101c39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3d:	c7 04 24 82 64 10 c0 	movl   $0xc0106482,(%esp)
c0101c44:	e8 7c e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c54:	c7 04 24 95 64 10 c0 	movl   $0xc0106495,(%esp)
c0101c5b:	e8 65 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6b:	c7 04 24 a8 64 10 c0 	movl   $0xc01064a8,(%esp)
c0101c72:	e8 4e e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101c77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7a:	8b 40 30             	mov    0x30(%eax),%eax
c0101c7d:	89 04 24             	mov    %eax,(%esp)
c0101c80:	e8 20 ff ff ff       	call   c0101ba5 <trapname>
c0101c85:	8b 55 08             	mov    0x8(%ebp),%edx
c0101c88:	8b 52 30             	mov    0x30(%edx),%edx
c0101c8b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101c8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101c93:	c7 04 24 bb 64 10 c0 	movl   $0xc01064bb,(%esp)
c0101c9a:	e8 26 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca2:	8b 40 34             	mov    0x34(%eax),%eax
c0101ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca9:	c7 04 24 cd 64 10 c0 	movl   $0xc01064cd,(%esp)
c0101cb0:	e8 10 e6 ff ff       	call   c01002c5 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb8:	8b 40 38             	mov    0x38(%eax),%eax
c0101cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbf:	c7 04 24 dc 64 10 c0 	movl   $0xc01064dc,(%esp)
c0101cc6:	e8 fa e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cce:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd6:	c7 04 24 eb 64 10 c0 	movl   $0xc01064eb,(%esp)
c0101cdd:	e8 e3 e5 ff ff       	call   c01002c5 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce5:	8b 40 40             	mov    0x40(%eax),%eax
c0101ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cec:	c7 04 24 fe 64 10 c0 	movl   $0xc01064fe,(%esp)
c0101cf3:	e8 cd e5 ff ff       	call   c01002c5 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101cf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101cff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101d06:	eb 3d                	jmp    c0101d45 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0b:	8b 50 40             	mov    0x40(%eax),%edx
c0101d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101d11:	21 d0                	and    %edx,%eax
c0101d13:	85 c0                	test   %eax,%eax
c0101d15:	74 28                	je     c0101d3f <print_trapframe+0x14c>
c0101d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d1a:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101d21:	85 c0                	test   %eax,%eax
c0101d23:	74 1a                	je     c0101d3f <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
c0101d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d28:	8b 04 85 80 95 11 c0 	mov    -0x3fee6a80(,%eax,4),%eax
c0101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d33:	c7 04 24 0d 65 10 c0 	movl   $0xc010650d,(%esp)
c0101d3a:	e8 86 e5 ff ff       	call   c01002c5 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101d3f:	ff 45 f4             	incl   -0xc(%ebp)
c0101d42:	d1 65 f0             	shll   -0x10(%ebp)
c0101d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101d48:	83 f8 17             	cmp    $0x17,%eax
c0101d4b:	76 bb                	jbe    c0101d08 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d50:	8b 40 40             	mov    0x40(%eax),%eax
c0101d53:	c1 e8 0c             	shr    $0xc,%eax
c0101d56:	83 e0 03             	and    $0x3,%eax
c0101d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5d:	c7 04 24 11 65 10 c0 	movl   $0xc0106511,(%esp)
c0101d64:	e8 5c e5 ff ff       	call   c01002c5 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6c:	89 04 24             	mov    %eax,(%esp)
c0101d6f:	e8 66 fe ff ff       	call   c0101bda <trap_in_kernel>
c0101d74:	85 c0                	test   %eax,%eax
c0101d76:	75 2d                	jne    c0101da5 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d7b:	8b 40 44             	mov    0x44(%eax),%eax
c0101d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d82:	c7 04 24 1a 65 10 c0 	movl   $0xc010651a,(%esp)
c0101d89:	e8 37 e5 ff ff       	call   c01002c5 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d91:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101d95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d99:	c7 04 24 29 65 10 c0 	movl   $0xc0106529,(%esp)
c0101da0:	e8 20 e5 ff ff       	call   c01002c5 <cprintf>
    }
}
c0101da5:	90                   	nop
c0101da6:	c9                   	leave  
c0101da7:	c3                   	ret    

c0101da8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101da8:	f3 0f 1e fb          	endbr32 
c0101dac:	55                   	push   %ebp
c0101dad:	89 e5                	mov    %esp,%ebp
c0101daf:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db5:	8b 00                	mov    (%eax),%eax
c0101db7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dbb:	c7 04 24 3c 65 10 c0 	movl   $0xc010653c,(%esp)
c0101dc2:	e8 fe e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dca:	8b 40 04             	mov    0x4(%eax),%eax
c0101dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd1:	c7 04 24 4b 65 10 c0 	movl   $0xc010654b,(%esp)
c0101dd8:	e8 e8 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de0:	8b 40 08             	mov    0x8(%eax),%eax
c0101de3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101de7:	c7 04 24 5a 65 10 c0 	movl   $0xc010655a,(%esp)
c0101dee:	e8 d2 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df6:	8b 40 0c             	mov    0xc(%eax),%eax
c0101df9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dfd:	c7 04 24 69 65 10 c0 	movl   $0xc0106569,(%esp)
c0101e04:	e8 bc e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e0c:	8b 40 10             	mov    0x10(%eax),%eax
c0101e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e13:	c7 04 24 78 65 10 c0 	movl   $0xc0106578,(%esp)
c0101e1a:	e8 a6 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101e1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e22:	8b 40 14             	mov    0x14(%eax),%eax
c0101e25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e29:	c7 04 24 87 65 10 c0 	movl   $0xc0106587,(%esp)
c0101e30:	e8 90 e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101e35:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e38:	8b 40 18             	mov    0x18(%eax),%eax
c0101e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e3f:	c7 04 24 96 65 10 c0 	movl   $0xc0106596,(%esp)
c0101e46:	e8 7a e4 ff ff       	call   c01002c5 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101e51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e55:	c7 04 24 a5 65 10 c0 	movl   $0xc01065a5,(%esp)
c0101e5c:	e8 64 e4 ff ff       	call   c01002c5 <cprintf>
}
c0101e61:	90                   	nop
c0101e62:	c9                   	leave  
c0101e63:	c3                   	ret    

c0101e64 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101e64:	f3 0f 1e fb          	endbr32 
c0101e68:	55                   	push   %ebp
c0101e69:	89 e5                	mov    %esp,%ebp
c0101e6b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e71:	8b 40 30             	mov    0x30(%eax),%eax
c0101e74:	83 f8 79             	cmp    $0x79,%eax
c0101e77:	0f 87 99 00 00 00    	ja     c0101f16 <trap_dispatch+0xb2>
c0101e7d:	83 f8 78             	cmp    $0x78,%eax
c0101e80:	73 78                	jae    c0101efa <trap_dispatch+0x96>
c0101e82:	83 f8 2f             	cmp    $0x2f,%eax
c0101e85:	0f 87 8b 00 00 00    	ja     c0101f16 <trap_dispatch+0xb2>
c0101e8b:	83 f8 2e             	cmp    $0x2e,%eax
c0101e8e:	0f 83 b7 00 00 00    	jae    c0101f4b <trap_dispatch+0xe7>
c0101e94:	83 f8 24             	cmp    $0x24,%eax
c0101e97:	74 15                	je     c0101eae <trap_dispatch+0x4a>
c0101e99:	83 f8 24             	cmp    $0x24,%eax
c0101e9c:	77 78                	ja     c0101f16 <trap_dispatch+0xb2>
c0101e9e:	83 f8 20             	cmp    $0x20,%eax
c0101ea1:	0f 84 a7 00 00 00    	je     c0101f4e <trap_dispatch+0xea>
c0101ea7:	83 f8 21             	cmp    $0x21,%eax
c0101eaa:	74 28                	je     c0101ed4 <trap_dispatch+0x70>
c0101eac:	eb 68                	jmp    c0101f16 <trap_dispatch+0xb2>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101eae:	e8 71 f8 ff ff       	call   c0101724 <cons_getc>
c0101eb3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101eb6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101eba:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ebe:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ec6:	c7 04 24 b4 65 10 c0 	movl   $0xc01065b4,(%esp)
c0101ecd:	e8 f3 e3 ff ff       	call   c01002c5 <cprintf>
        break;
c0101ed2:	eb 7b                	jmp    c0101f4f <trap_dispatch+0xeb>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ed4:	e8 4b f8 ff ff       	call   c0101724 <cons_getc>
c0101ed9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101edc:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ee0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ee4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101eec:	c7 04 24 c6 65 10 c0 	movl   $0xc01065c6,(%esp)
c0101ef3:	e8 cd e3 ff ff       	call   c01002c5 <cprintf>
        break;
c0101ef8:	eb 55                	jmp    c0101f4f <trap_dispatch+0xeb>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101efa:	c7 44 24 08 d5 65 10 	movl   $0xc01065d5,0x8(%esp)
c0101f01:	c0 
c0101f02:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0101f09:	00 
c0101f0a:	c7 04 24 e5 65 10 c0 	movl   $0xc01065e5,(%esp)
c0101f11:	e8 1b e5 ff ff       	call   c0100431 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101f16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f19:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f1d:	83 e0 03             	and    $0x3,%eax
c0101f20:	85 c0                	test   %eax,%eax
c0101f22:	75 2b                	jne    c0101f4f <trap_dispatch+0xeb>
            print_trapframe(tf);
c0101f24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f27:	89 04 24             	mov    %eax,(%esp)
c0101f2a:	e8 c4 fc ff ff       	call   c0101bf3 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101f2f:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0101f36:	c0 
c0101f37:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0101f3e:	00 
c0101f3f:	c7 04 24 e5 65 10 c0 	movl   $0xc01065e5,(%esp)
c0101f46:	e8 e6 e4 ff ff       	call   c0100431 <__panic>
        break;
c0101f4b:	90                   	nop
c0101f4c:	eb 01                	jmp    c0101f4f <trap_dispatch+0xeb>
        break;
c0101f4e:	90                   	nop
        }
    }
}
c0101f4f:	90                   	nop
c0101f50:	c9                   	leave  
c0101f51:	c3                   	ret    

c0101f52 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f52:	f3 0f 1e fb          	endbr32 
c0101f56:	55                   	push   %ebp
c0101f57:	89 e5                	mov    %esp,%ebp
c0101f59:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f5f:	89 04 24             	mov    %eax,(%esp)
c0101f62:	e8 fd fe ff ff       	call   c0101e64 <trap_dispatch>
}
c0101f67:	90                   	nop
c0101f68:	c9                   	leave  
c0101f69:	c3                   	ret    

c0101f6a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  jmp __alltraps
c0101f6e:	e9 69 0a 00 00       	jmp    c01029dc <__alltraps>

c0101f73 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $1
c0101f75:	6a 01                	push   $0x1
  jmp __alltraps
c0101f77:	e9 60 0a 00 00       	jmp    c01029dc <__alltraps>

c0101f7c <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $2
c0101f7e:	6a 02                	push   $0x2
  jmp __alltraps
c0101f80:	e9 57 0a 00 00       	jmp    c01029dc <__alltraps>

c0101f85 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $3
c0101f87:	6a 03                	push   $0x3
  jmp __alltraps
c0101f89:	e9 4e 0a 00 00       	jmp    c01029dc <__alltraps>

c0101f8e <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $4
c0101f90:	6a 04                	push   $0x4
  jmp __alltraps
c0101f92:	e9 45 0a 00 00       	jmp    c01029dc <__alltraps>

c0101f97 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $5
c0101f99:	6a 05                	push   $0x5
  jmp __alltraps
c0101f9b:	e9 3c 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fa0 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $6
c0101fa2:	6a 06                	push   $0x6
  jmp __alltraps
c0101fa4:	e9 33 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fa9 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $7
c0101fab:	6a 07                	push   $0x7
  jmp __alltraps
c0101fad:	e9 2a 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fb2 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101fb2:	6a 08                	push   $0x8
  jmp __alltraps
c0101fb4:	e9 23 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fb9 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101fb9:	6a 00                	push   $0x0
  pushl $9
c0101fbb:	6a 09                	push   $0x9
  jmp __alltraps
c0101fbd:	e9 1a 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fc2 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101fc2:	6a 0a                	push   $0xa
  jmp __alltraps
c0101fc4:	e9 13 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fc9 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101fc9:	6a 0b                	push   $0xb
  jmp __alltraps
c0101fcb:	e9 0c 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fd0 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101fd0:	6a 0c                	push   $0xc
  jmp __alltraps
c0101fd2:	e9 05 0a 00 00       	jmp    c01029dc <__alltraps>

c0101fd7 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101fd7:	6a 0d                	push   $0xd
  jmp __alltraps
c0101fd9:	e9 fe 09 00 00       	jmp    c01029dc <__alltraps>

c0101fde <vector14>:
.globl vector14
vector14:
  pushl $14
c0101fde:	6a 0e                	push   $0xe
  jmp __alltraps
c0101fe0:	e9 f7 09 00 00       	jmp    c01029dc <__alltraps>

c0101fe5 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101fe5:	6a 00                	push   $0x0
  pushl $15
c0101fe7:	6a 0f                	push   $0xf
  jmp __alltraps
c0101fe9:	e9 ee 09 00 00       	jmp    c01029dc <__alltraps>

c0101fee <vector16>:
.globl vector16
vector16:
  pushl $0
c0101fee:	6a 00                	push   $0x0
  pushl $16
c0101ff0:	6a 10                	push   $0x10
  jmp __alltraps
c0101ff2:	e9 e5 09 00 00       	jmp    c01029dc <__alltraps>

c0101ff7 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ff7:	6a 11                	push   $0x11
  jmp __alltraps
c0101ff9:	e9 de 09 00 00       	jmp    c01029dc <__alltraps>

c0101ffe <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ffe:	6a 00                	push   $0x0
  pushl $18
c0102000:	6a 12                	push   $0x12
  jmp __alltraps
c0102002:	e9 d5 09 00 00       	jmp    c01029dc <__alltraps>

c0102007 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102007:	6a 00                	push   $0x0
  pushl $19
c0102009:	6a 13                	push   $0x13
  jmp __alltraps
c010200b:	e9 cc 09 00 00       	jmp    c01029dc <__alltraps>

c0102010 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102010:	6a 00                	push   $0x0
  pushl $20
c0102012:	6a 14                	push   $0x14
  jmp __alltraps
c0102014:	e9 c3 09 00 00       	jmp    c01029dc <__alltraps>

c0102019 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $21
c010201b:	6a 15                	push   $0x15
  jmp __alltraps
c010201d:	e9 ba 09 00 00       	jmp    c01029dc <__alltraps>

c0102022 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102022:	6a 00                	push   $0x0
  pushl $22
c0102024:	6a 16                	push   $0x16
  jmp __alltraps
c0102026:	e9 b1 09 00 00       	jmp    c01029dc <__alltraps>

c010202b <vector23>:
.globl vector23
vector23:
  pushl $0
c010202b:	6a 00                	push   $0x0
  pushl $23
c010202d:	6a 17                	push   $0x17
  jmp __alltraps
c010202f:	e9 a8 09 00 00       	jmp    c01029dc <__alltraps>

c0102034 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102034:	6a 00                	push   $0x0
  pushl $24
c0102036:	6a 18                	push   $0x18
  jmp __alltraps
c0102038:	e9 9f 09 00 00       	jmp    c01029dc <__alltraps>

c010203d <vector25>:
.globl vector25
vector25:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $25
c010203f:	6a 19                	push   $0x19
  jmp __alltraps
c0102041:	e9 96 09 00 00       	jmp    c01029dc <__alltraps>

c0102046 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102046:	6a 00                	push   $0x0
  pushl $26
c0102048:	6a 1a                	push   $0x1a
  jmp __alltraps
c010204a:	e9 8d 09 00 00       	jmp    c01029dc <__alltraps>

c010204f <vector27>:
.globl vector27
vector27:
  pushl $0
c010204f:	6a 00                	push   $0x0
  pushl $27
c0102051:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102053:	e9 84 09 00 00       	jmp    c01029dc <__alltraps>

c0102058 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102058:	6a 00                	push   $0x0
  pushl $28
c010205a:	6a 1c                	push   $0x1c
  jmp __alltraps
c010205c:	e9 7b 09 00 00       	jmp    c01029dc <__alltraps>

c0102061 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $29
c0102063:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102065:	e9 72 09 00 00       	jmp    c01029dc <__alltraps>

c010206a <vector30>:
.globl vector30
vector30:
  pushl $0
c010206a:	6a 00                	push   $0x0
  pushl $30
c010206c:	6a 1e                	push   $0x1e
  jmp __alltraps
c010206e:	e9 69 09 00 00       	jmp    c01029dc <__alltraps>

c0102073 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102073:	6a 00                	push   $0x0
  pushl $31
c0102075:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102077:	e9 60 09 00 00       	jmp    c01029dc <__alltraps>

c010207c <vector32>:
.globl vector32
vector32:
  pushl $0
c010207c:	6a 00                	push   $0x0
  pushl $32
c010207e:	6a 20                	push   $0x20
  jmp __alltraps
c0102080:	e9 57 09 00 00       	jmp    c01029dc <__alltraps>

c0102085 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $33
c0102087:	6a 21                	push   $0x21
  jmp __alltraps
c0102089:	e9 4e 09 00 00       	jmp    c01029dc <__alltraps>

c010208e <vector34>:
.globl vector34
vector34:
  pushl $0
c010208e:	6a 00                	push   $0x0
  pushl $34
c0102090:	6a 22                	push   $0x22
  jmp __alltraps
c0102092:	e9 45 09 00 00       	jmp    c01029dc <__alltraps>

c0102097 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102097:	6a 00                	push   $0x0
  pushl $35
c0102099:	6a 23                	push   $0x23
  jmp __alltraps
c010209b:	e9 3c 09 00 00       	jmp    c01029dc <__alltraps>

c01020a0 <vector36>:
.globl vector36
vector36:
  pushl $0
c01020a0:	6a 00                	push   $0x0
  pushl $36
c01020a2:	6a 24                	push   $0x24
  jmp __alltraps
c01020a4:	e9 33 09 00 00       	jmp    c01029dc <__alltraps>

c01020a9 <vector37>:
.globl vector37
vector37:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $37
c01020ab:	6a 25                	push   $0x25
  jmp __alltraps
c01020ad:	e9 2a 09 00 00       	jmp    c01029dc <__alltraps>

c01020b2 <vector38>:
.globl vector38
vector38:
  pushl $0
c01020b2:	6a 00                	push   $0x0
  pushl $38
c01020b4:	6a 26                	push   $0x26
  jmp __alltraps
c01020b6:	e9 21 09 00 00       	jmp    c01029dc <__alltraps>

c01020bb <vector39>:
.globl vector39
vector39:
  pushl $0
c01020bb:	6a 00                	push   $0x0
  pushl $39
c01020bd:	6a 27                	push   $0x27
  jmp __alltraps
c01020bf:	e9 18 09 00 00       	jmp    c01029dc <__alltraps>

c01020c4 <vector40>:
.globl vector40
vector40:
  pushl $0
c01020c4:	6a 00                	push   $0x0
  pushl $40
c01020c6:	6a 28                	push   $0x28
  jmp __alltraps
c01020c8:	e9 0f 09 00 00       	jmp    c01029dc <__alltraps>

c01020cd <vector41>:
.globl vector41
vector41:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $41
c01020cf:	6a 29                	push   $0x29
  jmp __alltraps
c01020d1:	e9 06 09 00 00       	jmp    c01029dc <__alltraps>

c01020d6 <vector42>:
.globl vector42
vector42:
  pushl $0
c01020d6:	6a 00                	push   $0x0
  pushl $42
c01020d8:	6a 2a                	push   $0x2a
  jmp __alltraps
c01020da:	e9 fd 08 00 00       	jmp    c01029dc <__alltraps>

c01020df <vector43>:
.globl vector43
vector43:
  pushl $0
c01020df:	6a 00                	push   $0x0
  pushl $43
c01020e1:	6a 2b                	push   $0x2b
  jmp __alltraps
c01020e3:	e9 f4 08 00 00       	jmp    c01029dc <__alltraps>

c01020e8 <vector44>:
.globl vector44
vector44:
  pushl $0
c01020e8:	6a 00                	push   $0x0
  pushl $44
c01020ea:	6a 2c                	push   $0x2c
  jmp __alltraps
c01020ec:	e9 eb 08 00 00       	jmp    c01029dc <__alltraps>

c01020f1 <vector45>:
.globl vector45
vector45:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $45
c01020f3:	6a 2d                	push   $0x2d
  jmp __alltraps
c01020f5:	e9 e2 08 00 00       	jmp    c01029dc <__alltraps>

c01020fa <vector46>:
.globl vector46
vector46:
  pushl $0
c01020fa:	6a 00                	push   $0x0
  pushl $46
c01020fc:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020fe:	e9 d9 08 00 00       	jmp    c01029dc <__alltraps>

c0102103 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102103:	6a 00                	push   $0x0
  pushl $47
c0102105:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102107:	e9 d0 08 00 00       	jmp    c01029dc <__alltraps>

c010210c <vector48>:
.globl vector48
vector48:
  pushl $0
c010210c:	6a 00                	push   $0x0
  pushl $48
c010210e:	6a 30                	push   $0x30
  jmp __alltraps
c0102110:	e9 c7 08 00 00       	jmp    c01029dc <__alltraps>

c0102115 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $49
c0102117:	6a 31                	push   $0x31
  jmp __alltraps
c0102119:	e9 be 08 00 00       	jmp    c01029dc <__alltraps>

c010211e <vector50>:
.globl vector50
vector50:
  pushl $0
c010211e:	6a 00                	push   $0x0
  pushl $50
c0102120:	6a 32                	push   $0x32
  jmp __alltraps
c0102122:	e9 b5 08 00 00       	jmp    c01029dc <__alltraps>

c0102127 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102127:	6a 00                	push   $0x0
  pushl $51
c0102129:	6a 33                	push   $0x33
  jmp __alltraps
c010212b:	e9 ac 08 00 00       	jmp    c01029dc <__alltraps>

c0102130 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102130:	6a 00                	push   $0x0
  pushl $52
c0102132:	6a 34                	push   $0x34
  jmp __alltraps
c0102134:	e9 a3 08 00 00       	jmp    c01029dc <__alltraps>

c0102139 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $53
c010213b:	6a 35                	push   $0x35
  jmp __alltraps
c010213d:	e9 9a 08 00 00       	jmp    c01029dc <__alltraps>

c0102142 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102142:	6a 00                	push   $0x0
  pushl $54
c0102144:	6a 36                	push   $0x36
  jmp __alltraps
c0102146:	e9 91 08 00 00       	jmp    c01029dc <__alltraps>

c010214b <vector55>:
.globl vector55
vector55:
  pushl $0
c010214b:	6a 00                	push   $0x0
  pushl $55
c010214d:	6a 37                	push   $0x37
  jmp __alltraps
c010214f:	e9 88 08 00 00       	jmp    c01029dc <__alltraps>

c0102154 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $56
c0102156:	6a 38                	push   $0x38
  jmp __alltraps
c0102158:	e9 7f 08 00 00       	jmp    c01029dc <__alltraps>

c010215d <vector57>:
.globl vector57
vector57:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $57
c010215f:	6a 39                	push   $0x39
  jmp __alltraps
c0102161:	e9 76 08 00 00       	jmp    c01029dc <__alltraps>

c0102166 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $58
c0102168:	6a 3a                	push   $0x3a
  jmp __alltraps
c010216a:	e9 6d 08 00 00       	jmp    c01029dc <__alltraps>

c010216f <vector59>:
.globl vector59
vector59:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $59
c0102171:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102173:	e9 64 08 00 00       	jmp    c01029dc <__alltraps>

c0102178 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $60
c010217a:	6a 3c                	push   $0x3c
  jmp __alltraps
c010217c:	e9 5b 08 00 00       	jmp    c01029dc <__alltraps>

c0102181 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $61
c0102183:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102185:	e9 52 08 00 00       	jmp    c01029dc <__alltraps>

c010218a <vector62>:
.globl vector62
vector62:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $62
c010218c:	6a 3e                	push   $0x3e
  jmp __alltraps
c010218e:	e9 49 08 00 00       	jmp    c01029dc <__alltraps>

c0102193 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $63
c0102195:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102197:	e9 40 08 00 00       	jmp    c01029dc <__alltraps>

c010219c <vector64>:
.globl vector64
vector64:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $64
c010219e:	6a 40                	push   $0x40
  jmp __alltraps
c01021a0:	e9 37 08 00 00       	jmp    c01029dc <__alltraps>

c01021a5 <vector65>:
.globl vector65
vector65:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $65
c01021a7:	6a 41                	push   $0x41
  jmp __alltraps
c01021a9:	e9 2e 08 00 00       	jmp    c01029dc <__alltraps>

c01021ae <vector66>:
.globl vector66
vector66:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $66
c01021b0:	6a 42                	push   $0x42
  jmp __alltraps
c01021b2:	e9 25 08 00 00       	jmp    c01029dc <__alltraps>

c01021b7 <vector67>:
.globl vector67
vector67:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $67
c01021b9:	6a 43                	push   $0x43
  jmp __alltraps
c01021bb:	e9 1c 08 00 00       	jmp    c01029dc <__alltraps>

c01021c0 <vector68>:
.globl vector68
vector68:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $68
c01021c2:	6a 44                	push   $0x44
  jmp __alltraps
c01021c4:	e9 13 08 00 00       	jmp    c01029dc <__alltraps>

c01021c9 <vector69>:
.globl vector69
vector69:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $69
c01021cb:	6a 45                	push   $0x45
  jmp __alltraps
c01021cd:	e9 0a 08 00 00       	jmp    c01029dc <__alltraps>

c01021d2 <vector70>:
.globl vector70
vector70:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $70
c01021d4:	6a 46                	push   $0x46
  jmp __alltraps
c01021d6:	e9 01 08 00 00       	jmp    c01029dc <__alltraps>

c01021db <vector71>:
.globl vector71
vector71:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $71
c01021dd:	6a 47                	push   $0x47
  jmp __alltraps
c01021df:	e9 f8 07 00 00       	jmp    c01029dc <__alltraps>

c01021e4 <vector72>:
.globl vector72
vector72:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $72
c01021e6:	6a 48                	push   $0x48
  jmp __alltraps
c01021e8:	e9 ef 07 00 00       	jmp    c01029dc <__alltraps>

c01021ed <vector73>:
.globl vector73
vector73:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $73
c01021ef:	6a 49                	push   $0x49
  jmp __alltraps
c01021f1:	e9 e6 07 00 00       	jmp    c01029dc <__alltraps>

c01021f6 <vector74>:
.globl vector74
vector74:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $74
c01021f8:	6a 4a                	push   $0x4a
  jmp __alltraps
c01021fa:	e9 dd 07 00 00       	jmp    c01029dc <__alltraps>

c01021ff <vector75>:
.globl vector75
vector75:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $75
c0102201:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102203:	e9 d4 07 00 00       	jmp    c01029dc <__alltraps>

c0102208 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $76
c010220a:	6a 4c                	push   $0x4c
  jmp __alltraps
c010220c:	e9 cb 07 00 00       	jmp    c01029dc <__alltraps>

c0102211 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $77
c0102213:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102215:	e9 c2 07 00 00       	jmp    c01029dc <__alltraps>

c010221a <vector78>:
.globl vector78
vector78:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $78
c010221c:	6a 4e                	push   $0x4e
  jmp __alltraps
c010221e:	e9 b9 07 00 00       	jmp    c01029dc <__alltraps>

c0102223 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $79
c0102225:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102227:	e9 b0 07 00 00       	jmp    c01029dc <__alltraps>

c010222c <vector80>:
.globl vector80
vector80:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $80
c010222e:	6a 50                	push   $0x50
  jmp __alltraps
c0102230:	e9 a7 07 00 00       	jmp    c01029dc <__alltraps>

c0102235 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $81
c0102237:	6a 51                	push   $0x51
  jmp __alltraps
c0102239:	e9 9e 07 00 00       	jmp    c01029dc <__alltraps>

c010223e <vector82>:
.globl vector82
vector82:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $82
c0102240:	6a 52                	push   $0x52
  jmp __alltraps
c0102242:	e9 95 07 00 00       	jmp    c01029dc <__alltraps>

c0102247 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $83
c0102249:	6a 53                	push   $0x53
  jmp __alltraps
c010224b:	e9 8c 07 00 00       	jmp    c01029dc <__alltraps>

c0102250 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $84
c0102252:	6a 54                	push   $0x54
  jmp __alltraps
c0102254:	e9 83 07 00 00       	jmp    c01029dc <__alltraps>

c0102259 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $85
c010225b:	6a 55                	push   $0x55
  jmp __alltraps
c010225d:	e9 7a 07 00 00       	jmp    c01029dc <__alltraps>

c0102262 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $86
c0102264:	6a 56                	push   $0x56
  jmp __alltraps
c0102266:	e9 71 07 00 00       	jmp    c01029dc <__alltraps>

c010226b <vector87>:
.globl vector87
vector87:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $87
c010226d:	6a 57                	push   $0x57
  jmp __alltraps
c010226f:	e9 68 07 00 00       	jmp    c01029dc <__alltraps>

c0102274 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $88
c0102276:	6a 58                	push   $0x58
  jmp __alltraps
c0102278:	e9 5f 07 00 00       	jmp    c01029dc <__alltraps>

c010227d <vector89>:
.globl vector89
vector89:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $89
c010227f:	6a 59                	push   $0x59
  jmp __alltraps
c0102281:	e9 56 07 00 00       	jmp    c01029dc <__alltraps>

c0102286 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $90
c0102288:	6a 5a                	push   $0x5a
  jmp __alltraps
c010228a:	e9 4d 07 00 00       	jmp    c01029dc <__alltraps>

c010228f <vector91>:
.globl vector91
vector91:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $91
c0102291:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102293:	e9 44 07 00 00       	jmp    c01029dc <__alltraps>

c0102298 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $92
c010229a:	6a 5c                	push   $0x5c
  jmp __alltraps
c010229c:	e9 3b 07 00 00       	jmp    c01029dc <__alltraps>

c01022a1 <vector93>:
.globl vector93
vector93:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $93
c01022a3:	6a 5d                	push   $0x5d
  jmp __alltraps
c01022a5:	e9 32 07 00 00       	jmp    c01029dc <__alltraps>

c01022aa <vector94>:
.globl vector94
vector94:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $94
c01022ac:	6a 5e                	push   $0x5e
  jmp __alltraps
c01022ae:	e9 29 07 00 00       	jmp    c01029dc <__alltraps>

c01022b3 <vector95>:
.globl vector95
vector95:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $95
c01022b5:	6a 5f                	push   $0x5f
  jmp __alltraps
c01022b7:	e9 20 07 00 00       	jmp    c01029dc <__alltraps>

c01022bc <vector96>:
.globl vector96
vector96:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $96
c01022be:	6a 60                	push   $0x60
  jmp __alltraps
c01022c0:	e9 17 07 00 00       	jmp    c01029dc <__alltraps>

c01022c5 <vector97>:
.globl vector97
vector97:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $97
c01022c7:	6a 61                	push   $0x61
  jmp __alltraps
c01022c9:	e9 0e 07 00 00       	jmp    c01029dc <__alltraps>

c01022ce <vector98>:
.globl vector98
vector98:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $98
c01022d0:	6a 62                	push   $0x62
  jmp __alltraps
c01022d2:	e9 05 07 00 00       	jmp    c01029dc <__alltraps>

c01022d7 <vector99>:
.globl vector99
vector99:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $99
c01022d9:	6a 63                	push   $0x63
  jmp __alltraps
c01022db:	e9 fc 06 00 00       	jmp    c01029dc <__alltraps>

c01022e0 <vector100>:
.globl vector100
vector100:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $100
c01022e2:	6a 64                	push   $0x64
  jmp __alltraps
c01022e4:	e9 f3 06 00 00       	jmp    c01029dc <__alltraps>

c01022e9 <vector101>:
.globl vector101
vector101:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $101
c01022eb:	6a 65                	push   $0x65
  jmp __alltraps
c01022ed:	e9 ea 06 00 00       	jmp    c01029dc <__alltraps>

c01022f2 <vector102>:
.globl vector102
vector102:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $102
c01022f4:	6a 66                	push   $0x66
  jmp __alltraps
c01022f6:	e9 e1 06 00 00       	jmp    c01029dc <__alltraps>

c01022fb <vector103>:
.globl vector103
vector103:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $103
c01022fd:	6a 67                	push   $0x67
  jmp __alltraps
c01022ff:	e9 d8 06 00 00       	jmp    c01029dc <__alltraps>

c0102304 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $104
c0102306:	6a 68                	push   $0x68
  jmp __alltraps
c0102308:	e9 cf 06 00 00       	jmp    c01029dc <__alltraps>

c010230d <vector105>:
.globl vector105
vector105:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $105
c010230f:	6a 69                	push   $0x69
  jmp __alltraps
c0102311:	e9 c6 06 00 00       	jmp    c01029dc <__alltraps>

c0102316 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $106
c0102318:	6a 6a                	push   $0x6a
  jmp __alltraps
c010231a:	e9 bd 06 00 00       	jmp    c01029dc <__alltraps>

c010231f <vector107>:
.globl vector107
vector107:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $107
c0102321:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102323:	e9 b4 06 00 00       	jmp    c01029dc <__alltraps>

c0102328 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $108
c010232a:	6a 6c                	push   $0x6c
  jmp __alltraps
c010232c:	e9 ab 06 00 00       	jmp    c01029dc <__alltraps>

c0102331 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $109
c0102333:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102335:	e9 a2 06 00 00       	jmp    c01029dc <__alltraps>

c010233a <vector110>:
.globl vector110
vector110:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $110
c010233c:	6a 6e                	push   $0x6e
  jmp __alltraps
c010233e:	e9 99 06 00 00       	jmp    c01029dc <__alltraps>

c0102343 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $111
c0102345:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102347:	e9 90 06 00 00       	jmp    c01029dc <__alltraps>

c010234c <vector112>:
.globl vector112
vector112:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $112
c010234e:	6a 70                	push   $0x70
  jmp __alltraps
c0102350:	e9 87 06 00 00       	jmp    c01029dc <__alltraps>

c0102355 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $113
c0102357:	6a 71                	push   $0x71
  jmp __alltraps
c0102359:	e9 7e 06 00 00       	jmp    c01029dc <__alltraps>

c010235e <vector114>:
.globl vector114
vector114:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $114
c0102360:	6a 72                	push   $0x72
  jmp __alltraps
c0102362:	e9 75 06 00 00       	jmp    c01029dc <__alltraps>

c0102367 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $115
c0102369:	6a 73                	push   $0x73
  jmp __alltraps
c010236b:	e9 6c 06 00 00       	jmp    c01029dc <__alltraps>

c0102370 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $116
c0102372:	6a 74                	push   $0x74
  jmp __alltraps
c0102374:	e9 63 06 00 00       	jmp    c01029dc <__alltraps>

c0102379 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $117
c010237b:	6a 75                	push   $0x75
  jmp __alltraps
c010237d:	e9 5a 06 00 00       	jmp    c01029dc <__alltraps>

c0102382 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $118
c0102384:	6a 76                	push   $0x76
  jmp __alltraps
c0102386:	e9 51 06 00 00       	jmp    c01029dc <__alltraps>

c010238b <vector119>:
.globl vector119
vector119:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $119
c010238d:	6a 77                	push   $0x77
  jmp __alltraps
c010238f:	e9 48 06 00 00       	jmp    c01029dc <__alltraps>

c0102394 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $120
c0102396:	6a 78                	push   $0x78
  jmp __alltraps
c0102398:	e9 3f 06 00 00       	jmp    c01029dc <__alltraps>

c010239d <vector121>:
.globl vector121
vector121:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $121
c010239f:	6a 79                	push   $0x79
  jmp __alltraps
c01023a1:	e9 36 06 00 00       	jmp    c01029dc <__alltraps>

c01023a6 <vector122>:
.globl vector122
vector122:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $122
c01023a8:	6a 7a                	push   $0x7a
  jmp __alltraps
c01023aa:	e9 2d 06 00 00       	jmp    c01029dc <__alltraps>

c01023af <vector123>:
.globl vector123
vector123:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $123
c01023b1:	6a 7b                	push   $0x7b
  jmp __alltraps
c01023b3:	e9 24 06 00 00       	jmp    c01029dc <__alltraps>

c01023b8 <vector124>:
.globl vector124
vector124:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $124
c01023ba:	6a 7c                	push   $0x7c
  jmp __alltraps
c01023bc:	e9 1b 06 00 00       	jmp    c01029dc <__alltraps>

c01023c1 <vector125>:
.globl vector125
vector125:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $125
c01023c3:	6a 7d                	push   $0x7d
  jmp __alltraps
c01023c5:	e9 12 06 00 00       	jmp    c01029dc <__alltraps>

c01023ca <vector126>:
.globl vector126
vector126:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $126
c01023cc:	6a 7e                	push   $0x7e
  jmp __alltraps
c01023ce:	e9 09 06 00 00       	jmp    c01029dc <__alltraps>

c01023d3 <vector127>:
.globl vector127
vector127:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $127
c01023d5:	6a 7f                	push   $0x7f
  jmp __alltraps
c01023d7:	e9 00 06 00 00       	jmp    c01029dc <__alltraps>

c01023dc <vector128>:
.globl vector128
vector128:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $128
c01023de:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01023e3:	e9 f4 05 00 00       	jmp    c01029dc <__alltraps>

c01023e8 <vector129>:
.globl vector129
vector129:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $129
c01023ea:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01023ef:	e9 e8 05 00 00       	jmp    c01029dc <__alltraps>

c01023f4 <vector130>:
.globl vector130
vector130:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $130
c01023f6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01023fb:	e9 dc 05 00 00       	jmp    c01029dc <__alltraps>

c0102400 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $131
c0102402:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102407:	e9 d0 05 00 00       	jmp    c01029dc <__alltraps>

c010240c <vector132>:
.globl vector132
vector132:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $132
c010240e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102413:	e9 c4 05 00 00       	jmp    c01029dc <__alltraps>

c0102418 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $133
c010241a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010241f:	e9 b8 05 00 00       	jmp    c01029dc <__alltraps>

c0102424 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $134
c0102426:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010242b:	e9 ac 05 00 00       	jmp    c01029dc <__alltraps>

c0102430 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $135
c0102432:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102437:	e9 a0 05 00 00       	jmp    c01029dc <__alltraps>

c010243c <vector136>:
.globl vector136
vector136:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $136
c010243e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102443:	e9 94 05 00 00       	jmp    c01029dc <__alltraps>

c0102448 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $137
c010244a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010244f:	e9 88 05 00 00       	jmp    c01029dc <__alltraps>

c0102454 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $138
c0102456:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010245b:	e9 7c 05 00 00       	jmp    c01029dc <__alltraps>

c0102460 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $139
c0102462:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102467:	e9 70 05 00 00       	jmp    c01029dc <__alltraps>

c010246c <vector140>:
.globl vector140
vector140:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $140
c010246e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102473:	e9 64 05 00 00       	jmp    c01029dc <__alltraps>

c0102478 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $141
c010247a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010247f:	e9 58 05 00 00       	jmp    c01029dc <__alltraps>

c0102484 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $142
c0102486:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010248b:	e9 4c 05 00 00       	jmp    c01029dc <__alltraps>

c0102490 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $143
c0102492:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102497:	e9 40 05 00 00       	jmp    c01029dc <__alltraps>

c010249c <vector144>:
.globl vector144
vector144:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $144
c010249e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01024a3:	e9 34 05 00 00       	jmp    c01029dc <__alltraps>

c01024a8 <vector145>:
.globl vector145
vector145:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $145
c01024aa:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01024af:	e9 28 05 00 00       	jmp    c01029dc <__alltraps>

c01024b4 <vector146>:
.globl vector146
vector146:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $146
c01024b6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01024bb:	e9 1c 05 00 00       	jmp    c01029dc <__alltraps>

c01024c0 <vector147>:
.globl vector147
vector147:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $147
c01024c2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01024c7:	e9 10 05 00 00       	jmp    c01029dc <__alltraps>

c01024cc <vector148>:
.globl vector148
vector148:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $148
c01024ce:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01024d3:	e9 04 05 00 00       	jmp    c01029dc <__alltraps>

c01024d8 <vector149>:
.globl vector149
vector149:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $149
c01024da:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01024df:	e9 f8 04 00 00       	jmp    c01029dc <__alltraps>

c01024e4 <vector150>:
.globl vector150
vector150:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $150
c01024e6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01024eb:	e9 ec 04 00 00       	jmp    c01029dc <__alltraps>

c01024f0 <vector151>:
.globl vector151
vector151:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $151
c01024f2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01024f7:	e9 e0 04 00 00       	jmp    c01029dc <__alltraps>

c01024fc <vector152>:
.globl vector152
vector152:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $152
c01024fe:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102503:	e9 d4 04 00 00       	jmp    c01029dc <__alltraps>

c0102508 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $153
c010250a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010250f:	e9 c8 04 00 00       	jmp    c01029dc <__alltraps>

c0102514 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $154
c0102516:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010251b:	e9 bc 04 00 00       	jmp    c01029dc <__alltraps>

c0102520 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $155
c0102522:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102527:	e9 b0 04 00 00       	jmp    c01029dc <__alltraps>

c010252c <vector156>:
.globl vector156
vector156:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $156
c010252e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102533:	e9 a4 04 00 00       	jmp    c01029dc <__alltraps>

c0102538 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $157
c010253a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010253f:	e9 98 04 00 00       	jmp    c01029dc <__alltraps>

c0102544 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $158
c0102546:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010254b:	e9 8c 04 00 00       	jmp    c01029dc <__alltraps>

c0102550 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $159
c0102552:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102557:	e9 80 04 00 00       	jmp    c01029dc <__alltraps>

c010255c <vector160>:
.globl vector160
vector160:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $160
c010255e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102563:	e9 74 04 00 00       	jmp    c01029dc <__alltraps>

c0102568 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $161
c010256a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010256f:	e9 68 04 00 00       	jmp    c01029dc <__alltraps>

c0102574 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $162
c0102576:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010257b:	e9 5c 04 00 00       	jmp    c01029dc <__alltraps>

c0102580 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $163
c0102582:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102587:	e9 50 04 00 00       	jmp    c01029dc <__alltraps>

c010258c <vector164>:
.globl vector164
vector164:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $164
c010258e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102593:	e9 44 04 00 00       	jmp    c01029dc <__alltraps>

c0102598 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $165
c010259a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010259f:	e9 38 04 00 00       	jmp    c01029dc <__alltraps>

c01025a4 <vector166>:
.globl vector166
vector166:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $166
c01025a6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01025ab:	e9 2c 04 00 00       	jmp    c01029dc <__alltraps>

c01025b0 <vector167>:
.globl vector167
vector167:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $167
c01025b2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01025b7:	e9 20 04 00 00       	jmp    c01029dc <__alltraps>

c01025bc <vector168>:
.globl vector168
vector168:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $168
c01025be:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01025c3:	e9 14 04 00 00       	jmp    c01029dc <__alltraps>

c01025c8 <vector169>:
.globl vector169
vector169:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $169
c01025ca:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01025cf:	e9 08 04 00 00       	jmp    c01029dc <__alltraps>

c01025d4 <vector170>:
.globl vector170
vector170:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $170
c01025d6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01025db:	e9 fc 03 00 00       	jmp    c01029dc <__alltraps>

c01025e0 <vector171>:
.globl vector171
vector171:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $171
c01025e2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01025e7:	e9 f0 03 00 00       	jmp    c01029dc <__alltraps>

c01025ec <vector172>:
.globl vector172
vector172:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $172
c01025ee:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01025f3:	e9 e4 03 00 00       	jmp    c01029dc <__alltraps>

c01025f8 <vector173>:
.globl vector173
vector173:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $173
c01025fa:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025ff:	e9 d8 03 00 00       	jmp    c01029dc <__alltraps>

c0102604 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $174
c0102606:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010260b:	e9 cc 03 00 00       	jmp    c01029dc <__alltraps>

c0102610 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $175
c0102612:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102617:	e9 c0 03 00 00       	jmp    c01029dc <__alltraps>

c010261c <vector176>:
.globl vector176
vector176:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $176
c010261e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102623:	e9 b4 03 00 00       	jmp    c01029dc <__alltraps>

c0102628 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $177
c010262a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010262f:	e9 a8 03 00 00       	jmp    c01029dc <__alltraps>

c0102634 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $178
c0102636:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010263b:	e9 9c 03 00 00       	jmp    c01029dc <__alltraps>

c0102640 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $179
c0102642:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102647:	e9 90 03 00 00       	jmp    c01029dc <__alltraps>

c010264c <vector180>:
.globl vector180
vector180:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $180
c010264e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102653:	e9 84 03 00 00       	jmp    c01029dc <__alltraps>

c0102658 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $181
c010265a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010265f:	e9 78 03 00 00       	jmp    c01029dc <__alltraps>

c0102664 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $182
c0102666:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010266b:	e9 6c 03 00 00       	jmp    c01029dc <__alltraps>

c0102670 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $183
c0102672:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102677:	e9 60 03 00 00       	jmp    c01029dc <__alltraps>

c010267c <vector184>:
.globl vector184
vector184:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $184
c010267e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102683:	e9 54 03 00 00       	jmp    c01029dc <__alltraps>

c0102688 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $185
c010268a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010268f:	e9 48 03 00 00       	jmp    c01029dc <__alltraps>

c0102694 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $186
c0102696:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010269b:	e9 3c 03 00 00       	jmp    c01029dc <__alltraps>

c01026a0 <vector187>:
.globl vector187
vector187:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $187
c01026a2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01026a7:	e9 30 03 00 00       	jmp    c01029dc <__alltraps>

c01026ac <vector188>:
.globl vector188
vector188:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $188
c01026ae:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01026b3:	e9 24 03 00 00       	jmp    c01029dc <__alltraps>

c01026b8 <vector189>:
.globl vector189
vector189:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $189
c01026ba:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01026bf:	e9 18 03 00 00       	jmp    c01029dc <__alltraps>

c01026c4 <vector190>:
.globl vector190
vector190:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $190
c01026c6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01026cb:	e9 0c 03 00 00       	jmp    c01029dc <__alltraps>

c01026d0 <vector191>:
.globl vector191
vector191:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $191
c01026d2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01026d7:	e9 00 03 00 00       	jmp    c01029dc <__alltraps>

c01026dc <vector192>:
.globl vector192
vector192:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $192
c01026de:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01026e3:	e9 f4 02 00 00       	jmp    c01029dc <__alltraps>

c01026e8 <vector193>:
.globl vector193
vector193:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $193
c01026ea:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01026ef:	e9 e8 02 00 00       	jmp    c01029dc <__alltraps>

c01026f4 <vector194>:
.globl vector194
vector194:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $194
c01026f6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01026fb:	e9 dc 02 00 00       	jmp    c01029dc <__alltraps>

c0102700 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $195
c0102702:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102707:	e9 d0 02 00 00       	jmp    c01029dc <__alltraps>

c010270c <vector196>:
.globl vector196
vector196:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $196
c010270e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102713:	e9 c4 02 00 00       	jmp    c01029dc <__alltraps>

c0102718 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $197
c010271a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010271f:	e9 b8 02 00 00       	jmp    c01029dc <__alltraps>

c0102724 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $198
c0102726:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010272b:	e9 ac 02 00 00       	jmp    c01029dc <__alltraps>

c0102730 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $199
c0102732:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102737:	e9 a0 02 00 00       	jmp    c01029dc <__alltraps>

c010273c <vector200>:
.globl vector200
vector200:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $200
c010273e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102743:	e9 94 02 00 00       	jmp    c01029dc <__alltraps>

c0102748 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $201
c010274a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010274f:	e9 88 02 00 00       	jmp    c01029dc <__alltraps>

c0102754 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $202
c0102756:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010275b:	e9 7c 02 00 00       	jmp    c01029dc <__alltraps>

c0102760 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $203
c0102762:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102767:	e9 70 02 00 00       	jmp    c01029dc <__alltraps>

c010276c <vector204>:
.globl vector204
vector204:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $204
c010276e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102773:	e9 64 02 00 00       	jmp    c01029dc <__alltraps>

c0102778 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $205
c010277a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010277f:	e9 58 02 00 00       	jmp    c01029dc <__alltraps>

c0102784 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $206
c0102786:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010278b:	e9 4c 02 00 00       	jmp    c01029dc <__alltraps>

c0102790 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $207
c0102792:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102797:	e9 40 02 00 00       	jmp    c01029dc <__alltraps>

c010279c <vector208>:
.globl vector208
vector208:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $208
c010279e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01027a3:	e9 34 02 00 00       	jmp    c01029dc <__alltraps>

c01027a8 <vector209>:
.globl vector209
vector209:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $209
c01027aa:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01027af:	e9 28 02 00 00       	jmp    c01029dc <__alltraps>

c01027b4 <vector210>:
.globl vector210
vector210:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $210
c01027b6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01027bb:	e9 1c 02 00 00       	jmp    c01029dc <__alltraps>

c01027c0 <vector211>:
.globl vector211
vector211:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $211
c01027c2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01027c7:	e9 10 02 00 00       	jmp    c01029dc <__alltraps>

c01027cc <vector212>:
.globl vector212
vector212:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $212
c01027ce:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01027d3:	e9 04 02 00 00       	jmp    c01029dc <__alltraps>

c01027d8 <vector213>:
.globl vector213
vector213:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $213
c01027da:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01027df:	e9 f8 01 00 00       	jmp    c01029dc <__alltraps>

c01027e4 <vector214>:
.globl vector214
vector214:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $214
c01027e6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01027eb:	e9 ec 01 00 00       	jmp    c01029dc <__alltraps>

c01027f0 <vector215>:
.globl vector215
vector215:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $215
c01027f2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01027f7:	e9 e0 01 00 00       	jmp    c01029dc <__alltraps>

c01027fc <vector216>:
.globl vector216
vector216:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $216
c01027fe:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102803:	e9 d4 01 00 00       	jmp    c01029dc <__alltraps>

c0102808 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $217
c010280a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010280f:	e9 c8 01 00 00       	jmp    c01029dc <__alltraps>

c0102814 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $218
c0102816:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010281b:	e9 bc 01 00 00       	jmp    c01029dc <__alltraps>

c0102820 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $219
c0102822:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102827:	e9 b0 01 00 00       	jmp    c01029dc <__alltraps>

c010282c <vector220>:
.globl vector220
vector220:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $220
c010282e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102833:	e9 a4 01 00 00       	jmp    c01029dc <__alltraps>

c0102838 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $221
c010283a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010283f:	e9 98 01 00 00       	jmp    c01029dc <__alltraps>

c0102844 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $222
c0102846:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010284b:	e9 8c 01 00 00       	jmp    c01029dc <__alltraps>

c0102850 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $223
c0102852:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102857:	e9 80 01 00 00       	jmp    c01029dc <__alltraps>

c010285c <vector224>:
.globl vector224
vector224:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $224
c010285e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102863:	e9 74 01 00 00       	jmp    c01029dc <__alltraps>

c0102868 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $225
c010286a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010286f:	e9 68 01 00 00       	jmp    c01029dc <__alltraps>

c0102874 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $226
c0102876:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010287b:	e9 5c 01 00 00       	jmp    c01029dc <__alltraps>

c0102880 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $227
c0102882:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102887:	e9 50 01 00 00       	jmp    c01029dc <__alltraps>

c010288c <vector228>:
.globl vector228
vector228:
  pushl $0
c010288c:	6a 00                	push   $0x0
  pushl $228
c010288e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102893:	e9 44 01 00 00       	jmp    c01029dc <__alltraps>

c0102898 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102898:	6a 00                	push   $0x0
  pushl $229
c010289a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010289f:	e9 38 01 00 00       	jmp    c01029dc <__alltraps>

c01028a4 <vector230>:
.globl vector230
vector230:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $230
c01028a6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01028ab:	e9 2c 01 00 00       	jmp    c01029dc <__alltraps>

c01028b0 <vector231>:
.globl vector231
vector231:
  pushl $0
c01028b0:	6a 00                	push   $0x0
  pushl $231
c01028b2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01028b7:	e9 20 01 00 00       	jmp    c01029dc <__alltraps>

c01028bc <vector232>:
.globl vector232
vector232:
  pushl $0
c01028bc:	6a 00                	push   $0x0
  pushl $232
c01028be:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01028c3:	e9 14 01 00 00       	jmp    c01029dc <__alltraps>

c01028c8 <vector233>:
.globl vector233
vector233:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $233
c01028ca:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01028cf:	e9 08 01 00 00       	jmp    c01029dc <__alltraps>

c01028d4 <vector234>:
.globl vector234
vector234:
  pushl $0
c01028d4:	6a 00                	push   $0x0
  pushl $234
c01028d6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01028db:	e9 fc 00 00 00       	jmp    c01029dc <__alltraps>

c01028e0 <vector235>:
.globl vector235
vector235:
  pushl $0
c01028e0:	6a 00                	push   $0x0
  pushl $235
c01028e2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01028e7:	e9 f0 00 00 00       	jmp    c01029dc <__alltraps>

c01028ec <vector236>:
.globl vector236
vector236:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $236
c01028ee:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01028f3:	e9 e4 00 00 00       	jmp    c01029dc <__alltraps>

c01028f8 <vector237>:
.globl vector237
vector237:
  pushl $0
c01028f8:	6a 00                	push   $0x0
  pushl $237
c01028fa:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028ff:	e9 d8 00 00 00       	jmp    c01029dc <__alltraps>

c0102904 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102904:	6a 00                	push   $0x0
  pushl $238
c0102906:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010290b:	e9 cc 00 00 00       	jmp    c01029dc <__alltraps>

c0102910 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $239
c0102912:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102917:	e9 c0 00 00 00       	jmp    c01029dc <__alltraps>

c010291c <vector240>:
.globl vector240
vector240:
  pushl $0
c010291c:	6a 00                	push   $0x0
  pushl $240
c010291e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102923:	e9 b4 00 00 00       	jmp    c01029dc <__alltraps>

c0102928 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102928:	6a 00                	push   $0x0
  pushl $241
c010292a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010292f:	e9 a8 00 00 00       	jmp    c01029dc <__alltraps>

c0102934 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $242
c0102936:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010293b:	e9 9c 00 00 00       	jmp    c01029dc <__alltraps>

c0102940 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102940:	6a 00                	push   $0x0
  pushl $243
c0102942:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102947:	e9 90 00 00 00       	jmp    c01029dc <__alltraps>

c010294c <vector244>:
.globl vector244
vector244:
  pushl $0
c010294c:	6a 00                	push   $0x0
  pushl $244
c010294e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102953:	e9 84 00 00 00       	jmp    c01029dc <__alltraps>

c0102958 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $245
c010295a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010295f:	e9 78 00 00 00       	jmp    c01029dc <__alltraps>

c0102964 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102964:	6a 00                	push   $0x0
  pushl $246
c0102966:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010296b:	e9 6c 00 00 00       	jmp    c01029dc <__alltraps>

c0102970 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $247
c0102972:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102977:	e9 60 00 00 00       	jmp    c01029dc <__alltraps>

c010297c <vector248>:
.globl vector248
vector248:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $248
c010297e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102983:	e9 54 00 00 00       	jmp    c01029dc <__alltraps>

c0102988 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102988:	6a 00                	push   $0x0
  pushl $249
c010298a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010298f:	e9 48 00 00 00       	jmp    c01029dc <__alltraps>

c0102994 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102994:	6a 00                	push   $0x0
  pushl $250
c0102996:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010299b:	e9 3c 00 00 00       	jmp    c01029dc <__alltraps>

c01029a0 <vector251>:
.globl vector251
vector251:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $251
c01029a2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01029a7:	e9 30 00 00 00       	jmp    c01029dc <__alltraps>

c01029ac <vector252>:
.globl vector252
vector252:
  pushl $0
c01029ac:	6a 00                	push   $0x0
  pushl $252
c01029ae:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01029b3:	e9 24 00 00 00       	jmp    c01029dc <__alltraps>

c01029b8 <vector253>:
.globl vector253
vector253:
  pushl $0
c01029b8:	6a 00                	push   $0x0
  pushl $253
c01029ba:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01029bf:	e9 18 00 00 00       	jmp    c01029dc <__alltraps>

c01029c4 <vector254>:
.globl vector254
vector254:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $254
c01029c6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01029cb:	e9 0c 00 00 00       	jmp    c01029dc <__alltraps>

c01029d0 <vector255>:
.globl vector255
vector255:
  pushl $0
c01029d0:	6a 00                	push   $0x0
  pushl $255
c01029d2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01029d7:	e9 00 00 00 00       	jmp    c01029dc <__alltraps>

c01029dc <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01029dc:	1e                   	push   %ds
    pushl %es
c01029dd:	06                   	push   %es
    pushl %fs
c01029de:	0f a0                	push   %fs
    pushl %gs
c01029e0:	0f a8                	push   %gs
    pushal
c01029e2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01029e3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01029e8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01029ea:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01029ec:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01029ed:	e8 60 f5 ff ff       	call   c0101f52 <trap>

    # pop the pushed stack pointer
    popl %esp
c01029f2:	5c                   	pop    %esp

c01029f3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01029f3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01029f4:	0f a9                	pop    %gs
    popl %fs
c01029f6:	0f a1                	pop    %fs
    popl %es
c01029f8:	07                   	pop    %es
    popl %ds
c01029f9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01029fa:	83 c4 08             	add    $0x8,%esp
    iret
c01029fd:	cf                   	iret   

c01029fe <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01029fe:	55                   	push   %ebp
c01029ff:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102a01:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102a06:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a09:	29 c2                	sub    %eax,%edx
c0102a0b:	89 d0                	mov    %edx,%eax
c0102a0d:	c1 f8 02             	sar    $0x2,%eax
c0102a10:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102a16:	5d                   	pop    %ebp
c0102a17:	c3                   	ret    

c0102a18 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102a18:	55                   	push   %ebp
c0102a19:	89 e5                	mov    %esp,%ebp
c0102a1b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102a1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a21:	89 04 24             	mov    %eax,(%esp)
c0102a24:	e8 d5 ff ff ff       	call   c01029fe <page2ppn>
c0102a29:	c1 e0 0c             	shl    $0xc,%eax
}
c0102a2c:	c9                   	leave  
c0102a2d:	c3                   	ret    

c0102a2e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102a2e:	55                   	push   %ebp
c0102a2f:	89 e5                	mov    %esp,%ebp
c0102a31:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a37:	c1 e8 0c             	shr    $0xc,%eax
c0102a3a:	89 c2                	mov    %eax,%edx
c0102a3c:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102a41:	39 c2                	cmp    %eax,%edx
c0102a43:	72 1c                	jb     c0102a61 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102a45:	c7 44 24 08 b0 67 10 	movl   $0xc01067b0,0x8(%esp)
c0102a4c:	c0 
c0102a4d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102a54:	00 
c0102a55:	c7 04 24 cf 67 10 c0 	movl   $0xc01067cf,(%esp)
c0102a5c:	e8 d0 d9 ff ff       	call   c0100431 <__panic>
    }
    return &pages[PPN(pa)];
c0102a61:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6a:	c1 e8 0c             	shr    $0xc,%eax
c0102a6d:	89 c2                	mov    %eax,%edx
c0102a6f:	89 d0                	mov    %edx,%eax
c0102a71:	c1 e0 02             	shl    $0x2,%eax
c0102a74:	01 d0                	add    %edx,%eax
c0102a76:	c1 e0 02             	shl    $0x2,%eax
c0102a79:	01 c8                	add    %ecx,%eax
}
c0102a7b:	c9                   	leave  
c0102a7c:	c3                   	ret    

c0102a7d <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102a7d:	55                   	push   %ebp
c0102a7e:	89 e5                	mov    %esp,%ebp
c0102a80:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a86:	89 04 24             	mov    %eax,(%esp)
c0102a89:	e8 8a ff ff ff       	call   c0102a18 <page2pa>
c0102a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a94:	c1 e8 0c             	shr    $0xc,%eax
c0102a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a9a:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102a9f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102aa2:	72 23                	jb     c0102ac7 <page2kva+0x4a>
c0102aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102aab:	c7 44 24 08 e0 67 10 	movl   $0xc01067e0,0x8(%esp)
c0102ab2:	c0 
c0102ab3:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102aba:	00 
c0102abb:	c7 04 24 cf 67 10 c0 	movl   $0xc01067cf,(%esp)
c0102ac2:	e8 6a d9 ff ff       	call   c0100431 <__panic>
c0102ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aca:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102acf:	c9                   	leave  
c0102ad0:	c3                   	ret    

c0102ad1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102ad1:	55                   	push   %ebp
c0102ad2:	89 e5                	mov    %esp,%ebp
c0102ad4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ada:	83 e0 01             	and    $0x1,%eax
c0102add:	85 c0                	test   %eax,%eax
c0102adf:	75 1c                	jne    c0102afd <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102ae1:	c7 44 24 08 04 68 10 	movl   $0xc0106804,0x8(%esp)
c0102ae8:	c0 
c0102ae9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102af0:	00 
c0102af1:	c7 04 24 cf 67 10 c0 	movl   $0xc01067cf,(%esp)
c0102af8:	e8 34 d9 ff ff       	call   c0100431 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b05:	89 04 24             	mov    %eax,(%esp)
c0102b08:	e8 21 ff ff ff       	call   c0102a2e <pa2page>
}
c0102b0d:	c9                   	leave  
c0102b0e:	c3                   	ret    

c0102b0f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102b0f:	55                   	push   %ebp
c0102b10:	89 e5                	mov    %esp,%ebp
c0102b12:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102b1d:	89 04 24             	mov    %eax,(%esp)
c0102b20:	e8 09 ff ff ff       	call   c0102a2e <pa2page>
}
c0102b25:	c9                   	leave  
c0102b26:	c3                   	ret    

c0102b27 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102b27:	55                   	push   %ebp
c0102b28:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102b2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b2d:	8b 00                	mov    (%eax),%eax
}
c0102b2f:	5d                   	pop    %ebp
c0102b30:	c3                   	ret    

c0102b31 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102b31:	55                   	push   %ebp
c0102b32:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b37:	8b 00                	mov    (%eax),%eax
c0102b39:	8d 50 01             	lea    0x1(%eax),%edx
c0102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b3f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b44:	8b 00                	mov    (%eax),%eax
}
c0102b46:	5d                   	pop    %ebp
c0102b47:	c3                   	ret    

c0102b48 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102b48:	55                   	push   %ebp
c0102b49:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b4e:	8b 00                	mov    (%eax),%eax
c0102b50:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102b53:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b56:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b5b:	8b 00                	mov    (%eax),%eax
}
c0102b5d:	5d                   	pop    %ebp
c0102b5e:	c3                   	ret    

c0102b5f <__intr_save>:
__intr_save(void) {
c0102b5f:	55                   	push   %ebp
c0102b60:	89 e5                	mov    %esp,%ebp
c0102b62:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102b65:	9c                   	pushf  
c0102b66:	58                   	pop    %eax
c0102b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102b6d:	25 00 02 00 00       	and    $0x200,%eax
c0102b72:	85 c0                	test   %eax,%eax
c0102b74:	74 0c                	je     c0102b82 <__intr_save+0x23>
        intr_disable();
c0102b76:	e8 0a ee ff ff       	call   c0101985 <intr_disable>
        return 1;
c0102b7b:	b8 01 00 00 00       	mov    $0x1,%eax
c0102b80:	eb 05                	jmp    c0102b87 <__intr_save+0x28>
    return 0;
c0102b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b87:	c9                   	leave  
c0102b88:	c3                   	ret    

c0102b89 <__intr_restore>:
__intr_restore(bool flag) {
c0102b89:	55                   	push   %ebp
c0102b8a:	89 e5                	mov    %esp,%ebp
c0102b8c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102b8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b93:	74 05                	je     c0102b9a <__intr_restore+0x11>
        intr_enable();
c0102b95:	e8 df ed ff ff       	call   c0101979 <intr_enable>
}
c0102b9a:	90                   	nop
c0102b9b:	c9                   	leave  
c0102b9c:	c3                   	ret    

c0102b9d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b9d:	55                   	push   %ebp
c0102b9e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba3:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102ba6:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bab:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102bad:	b8 23 00 00 00       	mov    $0x23,%eax
c0102bb2:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102bb4:	b8 10 00 00 00       	mov    $0x10,%eax
c0102bb9:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102bbb:	b8 10 00 00 00       	mov    $0x10,%eax
c0102bc0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102bc2:	b8 10 00 00 00       	mov    $0x10,%eax
c0102bc7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102bc9:	ea d0 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102bd0
}
c0102bd0:	90                   	nop
c0102bd1:	5d                   	pop    %ebp
c0102bd2:	c3                   	ret    

c0102bd3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102bd3:	f3 0f 1e fb          	endbr32 
c0102bd7:	55                   	push   %ebp
c0102bd8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdd:	a3 a4 ce 11 c0       	mov    %eax,0xc011cea4
}
c0102be2:	90                   	nop
c0102be3:	5d                   	pop    %ebp
c0102be4:	c3                   	ret    

c0102be5 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102be5:	f3 0f 1e fb          	endbr32 
c0102be9:	55                   	push   %ebp
c0102bea:	89 e5                	mov    %esp,%ebp
c0102bec:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102bef:	b8 00 90 11 c0       	mov    $0xc0119000,%eax
c0102bf4:	89 04 24             	mov    %eax,(%esp)
c0102bf7:	e8 d7 ff ff ff       	call   c0102bd3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102bfc:	66 c7 05 a8 ce 11 c0 	movw   $0x10,0xc011cea8
c0102c03:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102c05:	66 c7 05 28 9a 11 c0 	movw   $0x68,0xc0119a28
c0102c0c:	68 00 
c0102c0e:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c13:	0f b7 c0             	movzwl %ax,%eax
c0102c16:	66 a3 2a 9a 11 c0    	mov    %ax,0xc0119a2a
c0102c1c:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102c21:	c1 e8 10             	shr    $0x10,%eax
c0102c24:	a2 2c 9a 11 c0       	mov    %al,0xc0119a2c
c0102c29:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c30:	24 f0                	and    $0xf0,%al
c0102c32:	0c 09                	or     $0x9,%al
c0102c34:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c39:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c40:	24 ef                	and    $0xef,%al
c0102c42:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c47:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c4e:	24 9f                	and    $0x9f,%al
c0102c50:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c55:	0f b6 05 2d 9a 11 c0 	movzbl 0xc0119a2d,%eax
c0102c5c:	0c 80                	or     $0x80,%al
c0102c5e:	a2 2d 9a 11 c0       	mov    %al,0xc0119a2d
c0102c63:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c6a:	24 f0                	and    $0xf0,%al
c0102c6c:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c71:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c78:	24 ef                	and    $0xef,%al
c0102c7a:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c7f:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c86:	24 df                	and    $0xdf,%al
c0102c88:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c8d:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102c94:	0c 40                	or     $0x40,%al
c0102c96:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102c9b:	0f b6 05 2e 9a 11 c0 	movzbl 0xc0119a2e,%eax
c0102ca2:	24 7f                	and    $0x7f,%al
c0102ca4:	a2 2e 9a 11 c0       	mov    %al,0xc0119a2e
c0102ca9:	b8 a0 ce 11 c0       	mov    $0xc011cea0,%eax
c0102cae:	c1 e8 18             	shr    $0x18,%eax
c0102cb1:	a2 2f 9a 11 c0       	mov    %al,0xc0119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102cb6:	c7 04 24 30 9a 11 c0 	movl   $0xc0119a30,(%esp)
c0102cbd:	e8 db fe ff ff       	call   c0102b9d <lgdt>
c0102cc2:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102cc8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102ccc:	0f 00 d8             	ltr    %ax
}
c0102ccf:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0102cd0:	90                   	nop
c0102cd1:	c9                   	leave  
c0102cd2:	c3                   	ret    

c0102cd3 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102cd3:	f3 0f 1e fb          	endbr32 
c0102cd7:	55                   	push   %ebp
c0102cd8:	89 e5                	mov    %esp,%ebp
c0102cda:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102cdd:	c7 05 10 cf 11 c0 d8 	movl   $0xc01071d8,0xc011cf10
c0102ce4:	71 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102ce7:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102cec:	8b 00                	mov    (%eax),%eax
c0102cee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cf2:	c7 04 24 30 68 10 c0 	movl   $0xc0106830,(%esp)
c0102cf9:	e8 c7 d5 ff ff       	call   c01002c5 <cprintf>
    pmm_manager->init();
c0102cfe:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d03:	8b 40 04             	mov    0x4(%eax),%eax
c0102d06:	ff d0                	call   *%eax
}
c0102d08:	90                   	nop
c0102d09:	c9                   	leave  
c0102d0a:	c3                   	ret    

c0102d0b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102d0b:	f3 0f 1e fb          	endbr32 
c0102d0f:	55                   	push   %ebp
c0102d10:	89 e5                	mov    %esp,%ebp
c0102d12:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102d15:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d1a:	8b 40 08             	mov    0x8(%eax),%eax
c0102d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d24:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d27:	89 14 24             	mov    %edx,(%esp)
c0102d2a:	ff d0                	call   *%eax
}
c0102d2c:	90                   	nop
c0102d2d:	c9                   	leave  
c0102d2e:	c3                   	ret    

c0102d2f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102d2f:	f3 0f 1e fb          	endbr32 
c0102d33:	55                   	push   %ebp
c0102d34:	89 e5                	mov    %esp,%ebp
c0102d36:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d40:	e8 1a fe ff ff       	call   c0102b5f <__intr_save>
c0102d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102d48:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d50:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d53:	89 14 24             	mov    %edx,(%esp)
c0102d56:	ff d0                	call   *%eax
c0102d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d5e:	89 04 24             	mov    %eax,(%esp)
c0102d61:	e8 23 fe ff ff       	call   c0102b89 <__intr_restore>
    return page;
c0102d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d69:	c9                   	leave  
c0102d6a:	c3                   	ret    

c0102d6b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102d6b:	f3 0f 1e fb          	endbr32 
c0102d6f:	55                   	push   %ebp
c0102d70:	89 e5                	mov    %esp,%ebp
c0102d72:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d75:	e8 e5 fd ff ff       	call   c0102b5f <__intr_save>
c0102d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102d7d:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102d82:	8b 40 10             	mov    0x10(%eax),%eax
c0102d85:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d88:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d8f:	89 14 24             	mov    %edx,(%esp)
c0102d92:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d97:	89 04 24             	mov    %eax,(%esp)
c0102d9a:	e8 ea fd ff ff       	call   c0102b89 <__intr_restore>
}
c0102d9f:	90                   	nop
c0102da0:	c9                   	leave  
c0102da1:	c3                   	ret    

c0102da2 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102da2:	f3 0f 1e fb          	endbr32 
c0102da6:	55                   	push   %ebp
c0102da7:	89 e5                	mov    %esp,%ebp
c0102da9:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102dac:	e8 ae fd ff ff       	call   c0102b5f <__intr_save>
c0102db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102db4:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c0102db9:	8b 40 14             	mov    0x14(%eax),%eax
c0102dbc:	ff d0                	call   *%eax
c0102dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc4:	89 04 24             	mov    %eax,(%esp)
c0102dc7:	e8 bd fd ff ff       	call   c0102b89 <__intr_restore>
    return ret;
c0102dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102dcf:	c9                   	leave  
c0102dd0:	c3                   	ret    

c0102dd1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102dd1:	f3 0f 1e fb          	endbr32 
c0102dd5:	55                   	push   %ebp
c0102dd6:	89 e5                	mov    %esp,%ebp
c0102dd8:	57                   	push   %edi
c0102dd9:	56                   	push   %esi
c0102dda:	53                   	push   %ebx
c0102ddb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102de1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102def:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102df6:	c7 04 24 47 68 10 c0 	movl   $0xc0106847,(%esp)
c0102dfd:	e8 c3 d4 ff ff       	call   c01002c5 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102e02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e09:	e9 1a 01 00 00       	jmp    c0102f28 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e0e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e11:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e14:	89 d0                	mov    %edx,%eax
c0102e16:	c1 e0 02             	shl    $0x2,%eax
c0102e19:	01 d0                	add    %edx,%eax
c0102e1b:	c1 e0 02             	shl    $0x2,%eax
c0102e1e:	01 c8                	add    %ecx,%eax
c0102e20:	8b 50 08             	mov    0x8(%eax),%edx
c0102e23:	8b 40 04             	mov    0x4(%eax),%eax
c0102e26:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102e29:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e2c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e32:	89 d0                	mov    %edx,%eax
c0102e34:	c1 e0 02             	shl    $0x2,%eax
c0102e37:	01 d0                	add    %edx,%eax
c0102e39:	c1 e0 02             	shl    $0x2,%eax
c0102e3c:	01 c8                	add    %ecx,%eax
c0102e3e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e41:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e44:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e47:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e4a:	01 c8                	add    %ecx,%eax
c0102e4c:	11 da                	adc    %ebx,%edx
c0102e4e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e51:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102e54:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e57:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e5a:	89 d0                	mov    %edx,%eax
c0102e5c:	c1 e0 02             	shl    $0x2,%eax
c0102e5f:	01 d0                	add    %edx,%eax
c0102e61:	c1 e0 02             	shl    $0x2,%eax
c0102e64:	01 c8                	add    %ecx,%eax
c0102e66:	83 c0 14             	add    $0x14,%eax
c0102e69:	8b 00                	mov    (%eax),%eax
c0102e6b:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102e6e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e71:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102e74:	83 c0 ff             	add    $0xffffffff,%eax
c0102e77:	83 d2 ff             	adc    $0xffffffff,%edx
c0102e7a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102e80:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102e86:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e89:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e8c:	89 d0                	mov    %edx,%eax
c0102e8e:	c1 e0 02             	shl    $0x2,%eax
c0102e91:	01 d0                	add    %edx,%eax
c0102e93:	c1 e0 02             	shl    $0x2,%eax
c0102e96:	01 c8                	add    %ecx,%eax
c0102e98:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e9b:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e9e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102ea1:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102ea5:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102eab:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102eb1:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102eb5:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102eb9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ebc:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102ebf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102ec3:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102ec7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102ecb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102ecf:	c7 04 24 54 68 10 c0 	movl   $0xc0106854,(%esp)
c0102ed6:	e8 ea d3 ff ff       	call   c01002c5 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102edb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ee1:	89 d0                	mov    %edx,%eax
c0102ee3:	c1 e0 02             	shl    $0x2,%eax
c0102ee6:	01 d0                	add    %edx,%eax
c0102ee8:	c1 e0 02             	shl    $0x2,%eax
c0102eeb:	01 c8                	add    %ecx,%eax
c0102eed:	83 c0 14             	add    $0x14,%eax
c0102ef0:	8b 00                	mov    (%eax),%eax
c0102ef2:	83 f8 01             	cmp    $0x1,%eax
c0102ef5:	75 2e                	jne    c0102f25 <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
c0102ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102efd:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102f00:	89 d0                	mov    %edx,%eax
c0102f02:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0102f05:	73 1e                	jae    c0102f25 <page_init+0x154>
c0102f07:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0102f0c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f11:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0102f14:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0102f17:	72 0c                	jb     c0102f25 <page_init+0x154>
                maxpa = end;
c0102f19:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f1c:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102f1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102f22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102f25:	ff 45 dc             	incl   -0x24(%ebp)
c0102f28:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102f2b:	8b 00                	mov    (%eax),%eax
c0102f2d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102f30:	0f 8c d8 fe ff ff    	jl     c0102e0e <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102f36:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0102f3b:	b8 00 00 00 00       	mov    $0x0,%eax
c0102f40:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0102f43:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0102f46:	73 0e                	jae    c0102f56 <page_init+0x185>
        maxpa = KMEMSIZE;
c0102f48:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102f4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f5c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f60:	c1 ea 0c             	shr    $0xc,%edx
c0102f63:	a3 80 ce 11 c0       	mov    %eax,0xc011ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102f68:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102f6f:	b8 28 cf 11 c0       	mov    $0xc011cf28,%eax
c0102f74:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102f77:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102f7a:	01 d0                	add    %edx,%eax
c0102f7c:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102f7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f82:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f87:	f7 75 c0             	divl   -0x40(%ebp)
c0102f8a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102f8d:	29 d0                	sub    %edx,%eax
c0102f8f:	a3 18 cf 11 c0       	mov    %eax,0xc011cf18

    for (i = 0; i < npage; i ++) {
c0102f94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f9b:	eb 2f                	jmp    c0102fcc <page_init+0x1fb>
        SetPageReserved(pages + i);
c0102f9d:	8b 0d 18 cf 11 c0    	mov    0xc011cf18,%ecx
c0102fa3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fa6:	89 d0                	mov    %edx,%eax
c0102fa8:	c1 e0 02             	shl    $0x2,%eax
c0102fab:	01 d0                	add    %edx,%eax
c0102fad:	c1 e0 02             	shl    $0x2,%eax
c0102fb0:	01 c8                	add    %ecx,%eax
c0102fb2:	83 c0 04             	add    $0x4,%eax
c0102fb5:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102fbc:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102fbf:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102fc2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102fc5:	0f ab 10             	bts    %edx,(%eax)
}
c0102fc8:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0102fc9:	ff 45 dc             	incl   -0x24(%ebp)
c0102fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102fcf:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0102fd4:	39 c2                	cmp    %eax,%edx
c0102fd6:	72 c5                	jb     c0102f9d <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102fd8:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0102fde:	89 d0                	mov    %edx,%eax
c0102fe0:	c1 e0 02             	shl    $0x2,%eax
c0102fe3:	01 d0                	add    %edx,%eax
c0102fe5:	c1 e0 02             	shl    $0x2,%eax
c0102fe8:	89 c2                	mov    %eax,%edx
c0102fea:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0102fef:	01 d0                	add    %edx,%eax
c0102ff1:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102ff4:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102ffb:	77 23                	ja     c0103020 <page_init+0x24f>
c0102ffd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103000:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103004:	c7 44 24 08 84 68 10 	movl   $0xc0106884,0x8(%esp)
c010300b:	c0 
c010300c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103013:	00 
c0103014:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c010301b:	e8 11 d4 ff ff       	call   c0100431 <__panic>
c0103020:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103023:	05 00 00 00 40       	add    $0x40000000,%eax
c0103028:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010302b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103032:	e9 4b 01 00 00       	jmp    c0103182 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103037:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010303a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010303d:	89 d0                	mov    %edx,%eax
c010303f:	c1 e0 02             	shl    $0x2,%eax
c0103042:	01 d0                	add    %edx,%eax
c0103044:	c1 e0 02             	shl    $0x2,%eax
c0103047:	01 c8                	add    %ecx,%eax
c0103049:	8b 50 08             	mov    0x8(%eax),%edx
c010304c:	8b 40 04             	mov    0x4(%eax),%eax
c010304f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103052:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103055:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103058:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010305b:	89 d0                	mov    %edx,%eax
c010305d:	c1 e0 02             	shl    $0x2,%eax
c0103060:	01 d0                	add    %edx,%eax
c0103062:	c1 e0 02             	shl    $0x2,%eax
c0103065:	01 c8                	add    %ecx,%eax
c0103067:	8b 48 0c             	mov    0xc(%eax),%ecx
c010306a:	8b 58 10             	mov    0x10(%eax),%ebx
c010306d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103070:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103073:	01 c8                	add    %ecx,%eax
c0103075:	11 da                	adc    %ebx,%edx
c0103077:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010307a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010307d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103080:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103083:	89 d0                	mov    %edx,%eax
c0103085:	c1 e0 02             	shl    $0x2,%eax
c0103088:	01 d0                	add    %edx,%eax
c010308a:	c1 e0 02             	shl    $0x2,%eax
c010308d:	01 c8                	add    %ecx,%eax
c010308f:	83 c0 14             	add    $0x14,%eax
c0103092:	8b 00                	mov    (%eax),%eax
c0103094:	83 f8 01             	cmp    $0x1,%eax
c0103097:	0f 85 e2 00 00 00    	jne    c010317f <page_init+0x3ae>
            if (begin < freemem) {
c010309d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01030a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01030a5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01030a8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01030ab:	19 d1                	sbb    %edx,%ecx
c01030ad:	73 0d                	jae    c01030bc <page_init+0x2eb>
                begin = freemem;
c01030af:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01030b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030b5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01030bc:	ba 00 00 00 38       	mov    $0x38000000,%edx
c01030c1:	b8 00 00 00 00       	mov    $0x0,%eax
c01030c6:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c01030c9:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01030cc:	73 0e                	jae    c01030dc <page_init+0x30b>
                end = KMEMSIZE;
c01030ce:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01030d5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01030dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030e2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01030e5:	89 d0                	mov    %edx,%eax
c01030e7:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01030ea:	0f 83 8f 00 00 00    	jae    c010317f <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
c01030f0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01030f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01030fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01030fd:	01 d0                	add    %edx,%eax
c01030ff:	48                   	dec    %eax
c0103100:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103103:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103106:	ba 00 00 00 00       	mov    $0x0,%edx
c010310b:	f7 75 b0             	divl   -0x50(%ebp)
c010310e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103111:	29 d0                	sub    %edx,%eax
c0103113:	ba 00 00 00 00       	mov    $0x0,%edx
c0103118:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010311b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010311e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103121:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103124:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103127:	ba 00 00 00 00       	mov    $0x0,%edx
c010312c:	89 c3                	mov    %eax,%ebx
c010312e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103134:	89 de                	mov    %ebx,%esi
c0103136:	89 d0                	mov    %edx,%eax
c0103138:	83 e0 00             	and    $0x0,%eax
c010313b:	89 c7                	mov    %eax,%edi
c010313d:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103140:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103143:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103146:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103149:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010314c:	89 d0                	mov    %edx,%eax
c010314e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103151:	73 2c                	jae    c010317f <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103153:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103156:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103159:	2b 45 d0             	sub    -0x30(%ebp),%eax
c010315c:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010315f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103163:	c1 ea 0c             	shr    $0xc,%edx
c0103166:	89 c3                	mov    %eax,%ebx
c0103168:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010316b:	89 04 24             	mov    %eax,(%esp)
c010316e:	e8 bb f8 ff ff       	call   c0102a2e <pa2page>
c0103173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103177:	89 04 24             	mov    %eax,(%esp)
c010317a:	e8 8c fb ff ff       	call   c0102d0b <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010317f:	ff 45 dc             	incl   -0x24(%ebp)
c0103182:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103185:	8b 00                	mov    (%eax),%eax
c0103187:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010318a:	0f 8c a7 fe ff ff    	jl     c0103037 <page_init+0x266>
                }
            }
        }
    }
}
c0103190:	90                   	nop
c0103191:	90                   	nop
c0103192:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103198:	5b                   	pop    %ebx
c0103199:	5e                   	pop    %esi
c010319a:	5f                   	pop    %edi
c010319b:	5d                   	pop    %ebp
c010319c:	c3                   	ret    

c010319d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010319d:	f3 0f 1e fb          	endbr32 
c01031a1:	55                   	push   %ebp
c01031a2:	89 e5                	mov    %esp,%ebp
c01031a4:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01031a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031aa:	33 45 14             	xor    0x14(%ebp),%eax
c01031ad:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031b2:	85 c0                	test   %eax,%eax
c01031b4:	74 24                	je     c01031da <boot_map_segment+0x3d>
c01031b6:	c7 44 24 0c b6 68 10 	movl   $0xc01068b6,0xc(%esp)
c01031bd:	c0 
c01031be:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c01031c5:	c0 
c01031c6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01031cd:	00 
c01031ce:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c01031d5:	e8 57 d2 ff ff       	call   c0100431 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01031da:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01031e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031e4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031e9:	89 c2                	mov    %eax,%edx
c01031eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01031ee:	01 c2                	add    %eax,%edx
c01031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031f3:	01 d0                	add    %edx,%eax
c01031f5:	48                   	dec    %eax
c01031f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031fc:	ba 00 00 00 00       	mov    $0x0,%edx
c0103201:	f7 75 f0             	divl   -0x10(%ebp)
c0103204:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103207:	29 d0                	sub    %edx,%eax
c0103209:	c1 e8 0c             	shr    $0xc,%eax
c010320c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010320f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103212:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103215:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103218:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010321d:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103220:	8b 45 14             	mov    0x14(%ebp),%eax
c0103223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103229:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010322e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103231:	eb 68                	jmp    c010329b <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010323a:	00 
c010323b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010323e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103242:	8b 45 08             	mov    0x8(%ebp),%eax
c0103245:	89 04 24             	mov    %eax,(%esp)
c0103248:	e8 8a 01 00 00       	call   c01033d7 <get_pte>
c010324d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103250:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103254:	75 24                	jne    c010327a <boot_map_segment+0xdd>
c0103256:	c7 44 24 0c e2 68 10 	movl   $0xc01068e2,0xc(%esp)
c010325d:	c0 
c010325e:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103265:	c0 
c0103266:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010326d:	00 
c010326e:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103275:	e8 b7 d1 ff ff       	call   c0100431 <__panic>
        *ptep = pa | PTE_P | perm;
c010327a:	8b 45 14             	mov    0x14(%ebp),%eax
c010327d:	0b 45 18             	or     0x18(%ebp),%eax
c0103280:	83 c8 01             	or     $0x1,%eax
c0103283:	89 c2                	mov    %eax,%edx
c0103285:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103288:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010328a:	ff 4d f4             	decl   -0xc(%ebp)
c010328d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103294:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010329b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010329f:	75 92                	jne    c0103233 <boot_map_segment+0x96>
    }
}
c01032a1:	90                   	nop
c01032a2:	90                   	nop
c01032a3:	c9                   	leave  
c01032a4:	c3                   	ret    

c01032a5 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01032a5:	f3 0f 1e fb          	endbr32 
c01032a9:	55                   	push   %ebp
c01032aa:	89 e5                	mov    %esp,%ebp
c01032ac:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01032af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b6:	e8 74 fa ff ff       	call   c0102d2f <alloc_pages>
c01032bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01032be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032c2:	75 1c                	jne    c01032e0 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
c01032c4:	c7 44 24 08 ef 68 10 	movl   $0xc01068ef,0x8(%esp)
c01032cb:	c0 
c01032cc:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01032d3:	00 
c01032d4:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c01032db:	e8 51 d1 ff ff       	call   c0100431 <__panic>
    }
    return page2kva(p);
c01032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e3:	89 04 24             	mov    %eax,(%esp)
c01032e6:	e8 92 f7 ff ff       	call   c0102a7d <page2kva>
}
c01032eb:	c9                   	leave  
c01032ec:	c3                   	ret    

c01032ed <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01032ed:	f3 0f 1e fb          	endbr32 
c01032f1:	55                   	push   %ebp
c01032f2:	89 e5                	mov    %esp,%ebp
c01032f4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01032f7:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01032fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032ff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103306:	77 23                	ja     c010332b <pmm_init+0x3e>
c0103308:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010330b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010330f:	c7 44 24 08 84 68 10 	movl   $0xc0106884,0x8(%esp)
c0103316:	c0 
c0103317:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010331e:	00 
c010331f:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103326:	e8 06 d1 ff ff       	call   c0100431 <__panic>
c010332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103333:	a3 14 cf 11 c0       	mov    %eax,0xc011cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103338:	e8 96 f9 ff ff       	call   c0102cd3 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010333d:	e8 8f fa ff ff       	call   c0102dd1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103342:	e8 64 02 00 00       	call   c01035ab <check_alloc_page>

    check_pgdir();
c0103347:	e8 82 02 00 00       	call   c01035ce <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010334c:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103351:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103354:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010335b:	77 23                	ja     c0103380 <pmm_init+0x93>
c010335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103360:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103364:	c7 44 24 08 84 68 10 	movl   $0xc0106884,0x8(%esp)
c010336b:	c0 
c010336c:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103373:	00 
c0103374:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c010337b:	e8 b1 d0 ff ff       	call   c0100431 <__panic>
c0103380:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103383:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0103389:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010338e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103393:	83 ca 03             	or     $0x3,%edx
c0103396:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103398:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010339d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01033a4:	00 
c01033a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01033ac:	00 
c01033ad:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01033b4:	38 
c01033b5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01033bc:	c0 
c01033bd:	89 04 24             	mov    %eax,(%esp)
c01033c0:	e8 d8 fd ff ff       	call   c010319d <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01033c5:	e8 1b f8 ff ff       	call   c0102be5 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01033ca:	e8 9f 08 00 00       	call   c0103c6e <check_boot_pgdir>

    print_pgdir();
c01033cf:	e8 24 0d 00 00       	call   c01040f8 <print_pgdir>

}
c01033d4:	90                   	nop
c01033d5:	c9                   	leave  
c01033d6:	c3                   	ret    

c01033d7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01033d7:	f3 0f 1e fb          	endbr32 
c01033db:	55                   	push   %ebp
c01033dc:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01033de:	90                   	nop
c01033df:	5d                   	pop    %ebp
c01033e0:	c3                   	ret    

c01033e1 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01033e1:	f3 0f 1e fb          	endbr32 
c01033e5:	55                   	push   %ebp
c01033e6:	89 e5                	mov    %esp,%ebp
c01033e8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01033f2:	00 
c01033f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01033fd:	89 04 24             	mov    %eax,(%esp)
c0103400:	e8 d2 ff ff ff       	call   c01033d7 <get_pte>
c0103405:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010340c:	74 08                	je     c0103416 <get_page+0x35>
        *ptep_store = ptep;
c010340e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103411:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103414:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010341a:	74 1b                	je     c0103437 <get_page+0x56>
c010341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010341f:	8b 00                	mov    (%eax),%eax
c0103421:	83 e0 01             	and    $0x1,%eax
c0103424:	85 c0                	test   %eax,%eax
c0103426:	74 0f                	je     c0103437 <get_page+0x56>
        return pte2page(*ptep);
c0103428:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010342b:	8b 00                	mov    (%eax),%eax
c010342d:	89 04 24             	mov    %eax,(%esp)
c0103430:	e8 9c f6 ff ff       	call   c0102ad1 <pte2page>
c0103435:	eb 05                	jmp    c010343c <get_page+0x5b>
    }
    return NULL;
c0103437:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010343c:	c9                   	leave  
c010343d:	c3                   	ret    

c010343e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010343e:	55                   	push   %ebp
c010343f:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103441:	90                   	nop
c0103442:	5d                   	pop    %ebp
c0103443:	c3                   	ret    

c0103444 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103444:	f3 0f 1e fb          	endbr32 
c0103448:	55                   	push   %ebp
c0103449:	89 e5                	mov    %esp,%ebp
c010344b:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010344e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103455:	00 
c0103456:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103459:	89 44 24 04          	mov    %eax,0x4(%esp)
c010345d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103460:	89 04 24             	mov    %eax,(%esp)
c0103463:	e8 6f ff ff ff       	call   c01033d7 <get_pte>
c0103468:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c010346b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010346f:	74 19                	je     c010348a <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
c0103471:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103474:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103478:	8b 45 0c             	mov    0xc(%ebp),%eax
c010347b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010347f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103482:	89 04 24             	mov    %eax,(%esp)
c0103485:	e8 b4 ff ff ff       	call   c010343e <page_remove_pte>
    }
}
c010348a:	90                   	nop
c010348b:	c9                   	leave  
c010348c:	c3                   	ret    

c010348d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010348d:	f3 0f 1e fb          	endbr32 
c0103491:	55                   	push   %ebp
c0103492:	89 e5                	mov    %esp,%ebp
c0103494:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103497:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010349e:	00 
c010349f:	8b 45 10             	mov    0x10(%ebp),%eax
c01034a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01034a9:	89 04 24             	mov    %eax,(%esp)
c01034ac:	e8 26 ff ff ff       	call   c01033d7 <get_pte>
c01034b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01034b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034b8:	75 0a                	jne    c01034c4 <page_insert+0x37>
        return -E_NO_MEM;
c01034ba:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01034bf:	e9 84 00 00 00       	jmp    c0103548 <page_insert+0xbb>
    }
    page_ref_inc(page);
c01034c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034c7:	89 04 24             	mov    %eax,(%esp)
c01034ca:	e8 62 f6 ff ff       	call   c0102b31 <page_ref_inc>
    if (*ptep & PTE_P) {
c01034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d2:	8b 00                	mov    (%eax),%eax
c01034d4:	83 e0 01             	and    $0x1,%eax
c01034d7:	85 c0                	test   %eax,%eax
c01034d9:	74 3e                	je     c0103519 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
c01034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034de:	8b 00                	mov    (%eax),%eax
c01034e0:	89 04 24             	mov    %eax,(%esp)
c01034e3:	e8 e9 f5 ff ff       	call   c0102ad1 <pte2page>
c01034e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01034f1:	75 0d                	jne    c0103500 <page_insert+0x73>
            page_ref_dec(page);
c01034f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034f6:	89 04 24             	mov    %eax,(%esp)
c01034f9:	e8 4a f6 ff ff       	call   c0102b48 <page_ref_dec>
c01034fe:	eb 19                	jmp    c0103519 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103500:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103503:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103507:	8b 45 10             	mov    0x10(%ebp),%eax
c010350a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010350e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103511:	89 04 24             	mov    %eax,(%esp)
c0103514:	e8 25 ff ff ff       	call   c010343e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103519:	8b 45 0c             	mov    0xc(%ebp),%eax
c010351c:	89 04 24             	mov    %eax,(%esp)
c010351f:	e8 f4 f4 ff ff       	call   c0102a18 <page2pa>
c0103524:	0b 45 14             	or     0x14(%ebp),%eax
c0103527:	83 c8 01             	or     $0x1,%eax
c010352a:	89 c2                	mov    %eax,%edx
c010352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103531:	8b 45 10             	mov    0x10(%ebp),%eax
c0103534:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103538:	8b 45 08             	mov    0x8(%ebp),%eax
c010353b:	89 04 24             	mov    %eax,(%esp)
c010353e:	e8 07 00 00 00       	call   c010354a <tlb_invalidate>
    return 0;
c0103543:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103548:	c9                   	leave  
c0103549:	c3                   	ret    

c010354a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010354a:	f3 0f 1e fb          	endbr32 
c010354e:	55                   	push   %ebp
c010354f:	89 e5                	mov    %esp,%ebp
c0103551:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103554:	0f 20 d8             	mov    %cr3,%eax
c0103557:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010355a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010355d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103560:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103563:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010356a:	77 23                	ja     c010358f <tlb_invalidate+0x45>
c010356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103573:	c7 44 24 08 84 68 10 	movl   $0xc0106884,0x8(%esp)
c010357a:	c0 
c010357b:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c0103582:	00 
c0103583:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c010358a:	e8 a2 ce ff ff       	call   c0100431 <__panic>
c010358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103592:	05 00 00 00 40       	add    $0x40000000,%eax
c0103597:	39 d0                	cmp    %edx,%eax
c0103599:	75 0d                	jne    c01035a8 <tlb_invalidate+0x5e>
        invlpg((void *)la);
c010359b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010359e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01035a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035a4:	0f 01 38             	invlpg (%eax)
}
c01035a7:	90                   	nop
    }
}
c01035a8:	90                   	nop
c01035a9:	c9                   	leave  
c01035aa:	c3                   	ret    

c01035ab <check_alloc_page>:

static void
check_alloc_page(void) {
c01035ab:	f3 0f 1e fb          	endbr32 
c01035af:	55                   	push   %ebp
c01035b0:	89 e5                	mov    %esp,%ebp
c01035b2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01035b5:	a1 10 cf 11 c0       	mov    0xc011cf10,%eax
c01035ba:	8b 40 18             	mov    0x18(%eax),%eax
c01035bd:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01035bf:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01035c6:	e8 fa cc ff ff       	call   c01002c5 <cprintf>
}
c01035cb:	90                   	nop
c01035cc:	c9                   	leave  
c01035cd:	c3                   	ret    

c01035ce <check_pgdir>:

static void
check_pgdir(void) {
c01035ce:	f3 0f 1e fb          	endbr32 
c01035d2:	55                   	push   %ebp
c01035d3:	89 e5                	mov    %esp,%ebp
c01035d5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035d8:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01035dd:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035e2:	76 24                	jbe    c0103608 <check_pgdir+0x3a>
c01035e4:	c7 44 24 0c 27 69 10 	movl   $0xc0106927,0xc(%esp)
c01035eb:	c0 
c01035ec:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c01035f3:	c0 
c01035f4:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c01035fb:	00 
c01035fc:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103603:	e8 29 ce ff ff       	call   c0100431 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103608:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010360d:	85 c0                	test   %eax,%eax
c010360f:	74 0e                	je     c010361f <check_pgdir+0x51>
c0103611:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103616:	25 ff 0f 00 00       	and    $0xfff,%eax
c010361b:	85 c0                	test   %eax,%eax
c010361d:	74 24                	je     c0103643 <check_pgdir+0x75>
c010361f:	c7 44 24 0c 44 69 10 	movl   $0xc0106944,0xc(%esp)
c0103626:	c0 
c0103627:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c010362e:	c0 
c010362f:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0103636:	00 
c0103637:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c010363e:	e8 ee cd ff ff       	call   c0100431 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103643:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103648:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010364f:	00 
c0103650:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103657:	00 
c0103658:	89 04 24             	mov    %eax,(%esp)
c010365b:	e8 81 fd ff ff       	call   c01033e1 <get_page>
c0103660:	85 c0                	test   %eax,%eax
c0103662:	74 24                	je     c0103688 <check_pgdir+0xba>
c0103664:	c7 44 24 0c 7c 69 10 	movl   $0xc010697c,0xc(%esp)
c010366b:	c0 
c010366c:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103673:	c0 
c0103674:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c010367b:	00 
c010367c:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103683:	e8 a9 cd ff ff       	call   c0100431 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103688:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010368f:	e8 9b f6 ff ff       	call   c0102d2f <alloc_pages>
c0103694:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103697:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010369c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01036a3:	00 
c01036a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036ab:	00 
c01036ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01036af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01036b3:	89 04 24             	mov    %eax,(%esp)
c01036b6:	e8 d2 fd ff ff       	call   c010348d <page_insert>
c01036bb:	85 c0                	test   %eax,%eax
c01036bd:	74 24                	je     c01036e3 <check_pgdir+0x115>
c01036bf:	c7 44 24 0c a4 69 10 	movl   $0xc01069a4,0xc(%esp)
c01036c6:	c0 
c01036c7:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c01036ce:	c0 
c01036cf:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c01036d6:	00 
c01036d7:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c01036de:	e8 4e cd ff ff       	call   c0100431 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01036e3:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01036e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036ef:	00 
c01036f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036f7:	00 
c01036f8:	89 04 24             	mov    %eax,(%esp)
c01036fb:	e8 d7 fc ff ff       	call   c01033d7 <get_pte>
c0103700:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103707:	75 24                	jne    c010372d <check_pgdir+0x15f>
c0103709:	c7 44 24 0c d0 69 10 	movl   $0xc01069d0,0xc(%esp)
c0103710:	c0 
c0103711:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103718:	c0 
c0103719:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0103720:	00 
c0103721:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103728:	e8 04 cd ff ff       	call   c0100431 <__panic>
    assert(pte2page(*ptep) == p1);
c010372d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103730:	8b 00                	mov    (%eax),%eax
c0103732:	89 04 24             	mov    %eax,(%esp)
c0103735:	e8 97 f3 ff ff       	call   c0102ad1 <pte2page>
c010373a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010373d:	74 24                	je     c0103763 <check_pgdir+0x195>
c010373f:	c7 44 24 0c fd 69 10 	movl   $0xc01069fd,0xc(%esp)
c0103746:	c0 
c0103747:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c010374e:	c0 
c010374f:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0103756:	00 
c0103757:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c010375e:	e8 ce cc ff ff       	call   c0100431 <__panic>
    assert(page_ref(p1) == 1);
c0103763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103766:	89 04 24             	mov    %eax,(%esp)
c0103769:	e8 b9 f3 ff ff       	call   c0102b27 <page_ref>
c010376e:	83 f8 01             	cmp    $0x1,%eax
c0103771:	74 24                	je     c0103797 <check_pgdir+0x1c9>
c0103773:	c7 44 24 0c 13 6a 10 	movl   $0xc0106a13,0xc(%esp)
c010377a:	c0 
c010377b:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103782:	c0 
c0103783:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c010378a:	00 
c010378b:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103792:	e8 9a cc ff ff       	call   c0100431 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103797:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010379c:	8b 00                	mov    (%eax),%eax
c010379e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01037a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037a9:	c1 e8 0c             	shr    $0xc,%eax
c01037ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01037af:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c01037b4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01037b7:	72 23                	jb     c01037dc <check_pgdir+0x20e>
c01037b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01037c0:	c7 44 24 08 e0 67 10 	movl   $0xc01067e0,0x8(%esp)
c01037c7:	c0 
c01037c8:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01037cf:	00 
c01037d0:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c01037d7:	e8 55 cc ff ff       	call   c0100431 <__panic>
c01037dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037df:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037e4:	83 c0 04             	add    $0x4,%eax
c01037e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037ea:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01037ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037f6:	00 
c01037f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01037fe:	00 
c01037ff:	89 04 24             	mov    %eax,(%esp)
c0103802:	e8 d0 fb ff ff       	call   c01033d7 <get_pte>
c0103807:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010380a:	74 24                	je     c0103830 <check_pgdir+0x262>
c010380c:	c7 44 24 0c 28 6a 10 	movl   $0xc0106a28,0xc(%esp)
c0103813:	c0 
c0103814:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c010381b:	c0 
c010381c:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0103823:	00 
c0103824:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c010382b:	e8 01 cc ff ff       	call   c0100431 <__panic>

    p2 = alloc_page();
c0103830:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103837:	e8 f3 f4 ff ff       	call   c0102d2f <alloc_pages>
c010383c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010383f:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103844:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010384b:	00 
c010384c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103853:	00 
c0103854:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103857:	89 54 24 04          	mov    %edx,0x4(%esp)
c010385b:	89 04 24             	mov    %eax,(%esp)
c010385e:	e8 2a fc ff ff       	call   c010348d <page_insert>
c0103863:	85 c0                	test   %eax,%eax
c0103865:	74 24                	je     c010388b <check_pgdir+0x2bd>
c0103867:	c7 44 24 0c 50 6a 10 	movl   $0xc0106a50,0xc(%esp)
c010386e:	c0 
c010386f:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103876:	c0 
c0103877:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c010387e:	00 
c010387f:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103886:	e8 a6 cb ff ff       	call   c0100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010388b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103890:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103897:	00 
c0103898:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010389f:	00 
c01038a0:	89 04 24             	mov    %eax,(%esp)
c01038a3:	e8 2f fb ff ff       	call   c01033d7 <get_pte>
c01038a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038af:	75 24                	jne    c01038d5 <check_pgdir+0x307>
c01038b1:	c7 44 24 0c 88 6a 10 	movl   $0xc0106a88,0xc(%esp)
c01038b8:	c0 
c01038b9:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c01038c0:	c0 
c01038c1:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c01038c8:	00 
c01038c9:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c01038d0:	e8 5c cb ff ff       	call   c0100431 <__panic>
    assert(*ptep & PTE_U);
c01038d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d8:	8b 00                	mov    (%eax),%eax
c01038da:	83 e0 04             	and    $0x4,%eax
c01038dd:	85 c0                	test   %eax,%eax
c01038df:	75 24                	jne    c0103905 <check_pgdir+0x337>
c01038e1:	c7 44 24 0c b8 6a 10 	movl   $0xc0106ab8,0xc(%esp)
c01038e8:	c0 
c01038e9:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c01038f0:	c0 
c01038f1:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c01038f8:	00 
c01038f9:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103900:	e8 2c cb ff ff       	call   c0100431 <__panic>
    assert(*ptep & PTE_W);
c0103905:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103908:	8b 00                	mov    (%eax),%eax
c010390a:	83 e0 02             	and    $0x2,%eax
c010390d:	85 c0                	test   %eax,%eax
c010390f:	75 24                	jne    c0103935 <check_pgdir+0x367>
c0103911:	c7 44 24 0c c6 6a 10 	movl   $0xc0106ac6,0xc(%esp)
c0103918:	c0 
c0103919:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103920:	c0 
c0103921:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0103928:	00 
c0103929:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103930:	e8 fc ca ff ff       	call   c0100431 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103935:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c010393a:	8b 00                	mov    (%eax),%eax
c010393c:	83 e0 04             	and    $0x4,%eax
c010393f:	85 c0                	test   %eax,%eax
c0103941:	75 24                	jne    c0103967 <check_pgdir+0x399>
c0103943:	c7 44 24 0c d4 6a 10 	movl   $0xc0106ad4,0xc(%esp)
c010394a:	c0 
c010394b:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103952:	c0 
c0103953:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c010395a:	00 
c010395b:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103962:	e8 ca ca ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 1);
c0103967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010396a:	89 04 24             	mov    %eax,(%esp)
c010396d:	e8 b5 f1 ff ff       	call   c0102b27 <page_ref>
c0103972:	83 f8 01             	cmp    $0x1,%eax
c0103975:	74 24                	je     c010399b <check_pgdir+0x3cd>
c0103977:	c7 44 24 0c ea 6a 10 	movl   $0xc0106aea,0xc(%esp)
c010397e:	c0 
c010397f:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103986:	c0 
c0103987:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010398e:	00 
c010398f:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103996:	e8 96 ca ff ff       	call   c0100431 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010399b:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c01039a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01039a7:	00 
c01039a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01039af:	00 
c01039b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01039b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039b7:	89 04 24             	mov    %eax,(%esp)
c01039ba:	e8 ce fa ff ff       	call   c010348d <page_insert>
c01039bf:	85 c0                	test   %eax,%eax
c01039c1:	74 24                	je     c01039e7 <check_pgdir+0x419>
c01039c3:	c7 44 24 0c fc 6a 10 	movl   $0xc0106afc,0xc(%esp)
c01039ca:	c0 
c01039cb:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01039da:	00 
c01039db:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c01039e2:	e8 4a ca ff ff       	call   c0100431 <__panic>
    assert(page_ref(p1) == 2);
c01039e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ea:	89 04 24             	mov    %eax,(%esp)
c01039ed:	e8 35 f1 ff ff       	call   c0102b27 <page_ref>
c01039f2:	83 f8 02             	cmp    $0x2,%eax
c01039f5:	74 24                	je     c0103a1b <check_pgdir+0x44d>
c01039f7:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c01039fe:	c0 
c01039ff:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103a06:	c0 
c0103a07:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0103a0e:	00 
c0103a0f:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103a16:	e8 16 ca ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0103a1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a1e:	89 04 24             	mov    %eax,(%esp)
c0103a21:	e8 01 f1 ff ff       	call   c0102b27 <page_ref>
c0103a26:	85 c0                	test   %eax,%eax
c0103a28:	74 24                	je     c0103a4e <check_pgdir+0x480>
c0103a2a:	c7 44 24 0c 3a 6b 10 	movl   $0xc0106b3a,0xc(%esp)
c0103a31:	c0 
c0103a32:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103a39:	c0 
c0103a3a:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103a41:	00 
c0103a42:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103a49:	e8 e3 c9 ff ff       	call   c0100431 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a4e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103a53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a5a:	00 
c0103a5b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a62:	00 
c0103a63:	89 04 24             	mov    %eax,(%esp)
c0103a66:	e8 6c f9 ff ff       	call   c01033d7 <get_pte>
c0103a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a72:	75 24                	jne    c0103a98 <check_pgdir+0x4ca>
c0103a74:	c7 44 24 0c 88 6a 10 	movl   $0xc0106a88,0xc(%esp)
c0103a7b:	c0 
c0103a7c:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103a83:	c0 
c0103a84:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0103a8b:	00 
c0103a8c:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103a93:	e8 99 c9 ff ff       	call   c0100431 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a9b:	8b 00                	mov    (%eax),%eax
c0103a9d:	89 04 24             	mov    %eax,(%esp)
c0103aa0:	e8 2c f0 ff ff       	call   c0102ad1 <pte2page>
c0103aa5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103aa8:	74 24                	je     c0103ace <check_pgdir+0x500>
c0103aaa:	c7 44 24 0c fd 69 10 	movl   $0xc01069fd,0xc(%esp)
c0103ab1:	c0 
c0103ab2:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103ab9:	c0 
c0103aba:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0103ac1:	00 
c0103ac2:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103ac9:	e8 63 c9 ff ff       	call   c0100431 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ad1:	8b 00                	mov    (%eax),%eax
c0103ad3:	83 e0 04             	and    $0x4,%eax
c0103ad6:	85 c0                	test   %eax,%eax
c0103ad8:	74 24                	je     c0103afe <check_pgdir+0x530>
c0103ada:	c7 44 24 0c 4c 6b 10 	movl   $0xc0106b4c,0xc(%esp)
c0103ae1:	c0 
c0103ae2:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103ae9:	c0 
c0103aea:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103af1:	00 
c0103af2:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103af9:	e8 33 c9 ff ff       	call   c0100431 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103afe:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103b0a:	00 
c0103b0b:	89 04 24             	mov    %eax,(%esp)
c0103b0e:	e8 31 f9 ff ff       	call   c0103444 <page_remove>
    assert(page_ref(p1) == 1);
c0103b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b16:	89 04 24             	mov    %eax,(%esp)
c0103b19:	e8 09 f0 ff ff       	call   c0102b27 <page_ref>
c0103b1e:	83 f8 01             	cmp    $0x1,%eax
c0103b21:	74 24                	je     c0103b47 <check_pgdir+0x579>
c0103b23:	c7 44 24 0c 13 6a 10 	movl   $0xc0106a13,0xc(%esp)
c0103b2a:	c0 
c0103b2b:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103b32:	c0 
c0103b33:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0103b3a:	00 
c0103b3b:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103b42:	e8 ea c8 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0103b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b4a:	89 04 24             	mov    %eax,(%esp)
c0103b4d:	e8 d5 ef ff ff       	call   c0102b27 <page_ref>
c0103b52:	85 c0                	test   %eax,%eax
c0103b54:	74 24                	je     c0103b7a <check_pgdir+0x5ac>
c0103b56:	c7 44 24 0c 3a 6b 10 	movl   $0xc0106b3a,0xc(%esp)
c0103b5d:	c0 
c0103b5e:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103b65:	c0 
c0103b66:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103b6d:	00 
c0103b6e:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103b75:	e8 b7 c8 ff ff       	call   c0100431 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b7a:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103b7f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b86:	00 
c0103b87:	89 04 24             	mov    %eax,(%esp)
c0103b8a:	e8 b5 f8 ff ff       	call   c0103444 <page_remove>
    assert(page_ref(p1) == 0);
c0103b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b92:	89 04 24             	mov    %eax,(%esp)
c0103b95:	e8 8d ef ff ff       	call   c0102b27 <page_ref>
c0103b9a:	85 c0                	test   %eax,%eax
c0103b9c:	74 24                	je     c0103bc2 <check_pgdir+0x5f4>
c0103b9e:	c7 44 24 0c 61 6b 10 	movl   $0xc0106b61,0xc(%esp)
c0103ba5:	c0 
c0103ba6:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103bad:	c0 
c0103bae:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103bb5:	00 
c0103bb6:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103bbd:	e8 6f c8 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p2) == 0);
c0103bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bc5:	89 04 24             	mov    %eax,(%esp)
c0103bc8:	e8 5a ef ff ff       	call   c0102b27 <page_ref>
c0103bcd:	85 c0                	test   %eax,%eax
c0103bcf:	74 24                	je     c0103bf5 <check_pgdir+0x627>
c0103bd1:	c7 44 24 0c 3a 6b 10 	movl   $0xc0106b3a,0xc(%esp)
c0103bd8:	c0 
c0103bd9:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103be0:	c0 
c0103be1:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103be8:	00 
c0103be9:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103bf0:	e8 3c c8 ff ff       	call   c0100431 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103bf5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103bfa:	8b 00                	mov    (%eax),%eax
c0103bfc:	89 04 24             	mov    %eax,(%esp)
c0103bff:	e8 0b ef ff ff       	call   c0102b0f <pde2page>
c0103c04:	89 04 24             	mov    %eax,(%esp)
c0103c07:	e8 1b ef ff ff       	call   c0102b27 <page_ref>
c0103c0c:	83 f8 01             	cmp    $0x1,%eax
c0103c0f:	74 24                	je     c0103c35 <check_pgdir+0x667>
c0103c11:	c7 44 24 0c 74 6b 10 	movl   $0xc0106b74,0xc(%esp)
c0103c18:	c0 
c0103c19:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103c20:	c0 
c0103c21:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103c28:	00 
c0103c29:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103c30:	e8 fc c7 ff ff       	call   c0100431 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103c35:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c3a:	8b 00                	mov    (%eax),%eax
c0103c3c:	89 04 24             	mov    %eax,(%esp)
c0103c3f:	e8 cb ee ff ff       	call   c0102b0f <pde2page>
c0103c44:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c4b:	00 
c0103c4c:	89 04 24             	mov    %eax,(%esp)
c0103c4f:	e8 17 f1 ff ff       	call   c0102d6b <free_pages>
    boot_pgdir[0] = 0;
c0103c54:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103c59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103c5f:	c7 04 24 9b 6b 10 c0 	movl   $0xc0106b9b,(%esp)
c0103c66:	e8 5a c6 ff ff       	call   c01002c5 <cprintf>
}
c0103c6b:	90                   	nop
c0103c6c:	c9                   	leave  
c0103c6d:	c3                   	ret    

c0103c6e <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c6e:	f3 0f 1e fb          	endbr32 
c0103c72:	55                   	push   %ebp
c0103c73:	89 e5                	mov    %esp,%ebp
c0103c75:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c7f:	e9 ca 00 00 00       	jmp    c0103d4e <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c8d:	c1 e8 0c             	shr    $0xc,%eax
c0103c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103c93:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103c98:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103c9b:	72 23                	jb     c0103cc0 <check_boot_pgdir+0x52>
c0103c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ca0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ca4:	c7 44 24 08 e0 67 10 	movl   $0xc01067e0,0x8(%esp)
c0103cab:	c0 
c0103cac:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103cb3:	00 
c0103cb4:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103cbb:	e8 71 c7 ff ff       	call   c0100431 <__panic>
c0103cc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cc3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103cc8:	89 c2                	mov    %eax,%edx
c0103cca:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103ccf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103cd6:	00 
c0103cd7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cdb:	89 04 24             	mov    %eax,(%esp)
c0103cde:	e8 f4 f6 ff ff       	call   c01033d7 <get_pte>
c0103ce3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103ce6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103cea:	75 24                	jne    c0103d10 <check_boot_pgdir+0xa2>
c0103cec:	c7 44 24 0c b8 6b 10 	movl   $0xc0106bb8,0xc(%esp)
c0103cf3:	c0 
c0103cf4:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103cfb:	c0 
c0103cfc:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103d03:	00 
c0103d04:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103d0b:	e8 21 c7 ff ff       	call   c0100431 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d13:	8b 00                	mov    (%eax),%eax
c0103d15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d1a:	89 c2                	mov    %eax,%edx
c0103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d1f:	39 c2                	cmp    %eax,%edx
c0103d21:	74 24                	je     c0103d47 <check_boot_pgdir+0xd9>
c0103d23:	c7 44 24 0c f5 6b 10 	movl   $0xc0106bf5,0xc(%esp)
c0103d2a:	c0 
c0103d2b:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103d32:	c0 
c0103d33:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103d3a:	00 
c0103d3b:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103d42:	e8 ea c6 ff ff       	call   c0100431 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103d47:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d51:	a1 80 ce 11 c0       	mov    0xc011ce80,%eax
c0103d56:	39 c2                	cmp    %eax,%edx
c0103d58:	0f 82 26 ff ff ff    	jb     c0103c84 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103d5e:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d63:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103d68:	8b 00                	mov    (%eax),%eax
c0103d6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d6f:	89 c2                	mov    %eax,%edx
c0103d71:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d79:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103d80:	77 23                	ja     c0103da5 <check_boot_pgdir+0x137>
c0103d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d85:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d89:	c7 44 24 08 84 68 10 	movl   $0xc0106884,0x8(%esp)
c0103d90:	c0 
c0103d91:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103d98:	00 
c0103d99:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103da0:	e8 8c c6 ff ff       	call   c0100431 <__panic>
c0103da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103da8:	05 00 00 00 40       	add    $0x40000000,%eax
c0103dad:	39 d0                	cmp    %edx,%eax
c0103daf:	74 24                	je     c0103dd5 <check_boot_pgdir+0x167>
c0103db1:	c7 44 24 0c 0c 6c 10 	movl   $0xc0106c0c,0xc(%esp)
c0103db8:	c0 
c0103db9:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103dc0:	c0 
c0103dc1:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103dc8:	00 
c0103dc9:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103dd0:	e8 5c c6 ff ff       	call   c0100431 <__panic>

    assert(boot_pgdir[0] == 0);
c0103dd5:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103dda:	8b 00                	mov    (%eax),%eax
c0103ddc:	85 c0                	test   %eax,%eax
c0103dde:	74 24                	je     c0103e04 <check_boot_pgdir+0x196>
c0103de0:	c7 44 24 0c 40 6c 10 	movl   $0xc0106c40,0xc(%esp)
c0103de7:	c0 
c0103de8:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103def:	c0 
c0103df0:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103df7:	00 
c0103df8:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103dff:	e8 2d c6 ff ff       	call   c0100431 <__panic>

    struct Page *p;
    p = alloc_page();
c0103e04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e0b:	e8 1f ef ff ff       	call   c0102d2f <alloc_pages>
c0103e10:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103e13:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e18:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e1f:	00 
c0103e20:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103e27:	00 
c0103e28:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103e2b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e2f:	89 04 24             	mov    %eax,(%esp)
c0103e32:	e8 56 f6 ff ff       	call   c010348d <page_insert>
c0103e37:	85 c0                	test   %eax,%eax
c0103e39:	74 24                	je     c0103e5f <check_boot_pgdir+0x1f1>
c0103e3b:	c7 44 24 0c 54 6c 10 	movl   $0xc0106c54,0xc(%esp)
c0103e42:	c0 
c0103e43:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103e4a:	c0 
c0103e4b:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103e52:	00 
c0103e53:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103e5a:	e8 d2 c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p) == 1);
c0103e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e62:	89 04 24             	mov    %eax,(%esp)
c0103e65:	e8 bd ec ff ff       	call   c0102b27 <page_ref>
c0103e6a:	83 f8 01             	cmp    $0x1,%eax
c0103e6d:	74 24                	je     c0103e93 <check_boot_pgdir+0x225>
c0103e6f:	c7 44 24 0c 82 6c 10 	movl   $0xc0106c82,0xc(%esp)
c0103e76:	c0 
c0103e77:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103e7e:	c0 
c0103e7f:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103e86:	00 
c0103e87:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103e8e:	e8 9e c5 ff ff       	call   c0100431 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103e93:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103e98:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e9f:	00 
c0103ea0:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103ea7:	00 
c0103ea8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103eab:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103eaf:	89 04 24             	mov    %eax,(%esp)
c0103eb2:	e8 d6 f5 ff ff       	call   c010348d <page_insert>
c0103eb7:	85 c0                	test   %eax,%eax
c0103eb9:	74 24                	je     c0103edf <check_boot_pgdir+0x271>
c0103ebb:	c7 44 24 0c 94 6c 10 	movl   $0xc0106c94,0xc(%esp)
c0103ec2:	c0 
c0103ec3:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103eca:	c0 
c0103ecb:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103ed2:	00 
c0103ed3:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103eda:	e8 52 c5 ff ff       	call   c0100431 <__panic>
    assert(page_ref(p) == 2);
c0103edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ee2:	89 04 24             	mov    %eax,(%esp)
c0103ee5:	e8 3d ec ff ff       	call   c0102b27 <page_ref>
c0103eea:	83 f8 02             	cmp    $0x2,%eax
c0103eed:	74 24                	je     c0103f13 <check_boot_pgdir+0x2a5>
c0103eef:	c7 44 24 0c cb 6c 10 	movl   $0xc0106ccb,0xc(%esp)
c0103ef6:	c0 
c0103ef7:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103efe:	c0 
c0103eff:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103f06:	00 
c0103f07:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103f0e:	e8 1e c5 ff ff       	call   c0100431 <__panic>

    const char *str = "ucore: Hello world!!";
c0103f13:	c7 45 e8 dc 6c 10 c0 	movl   $0xc0106cdc,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103f1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f21:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f28:	e8 32 16 00 00       	call   c010555f <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103f2d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103f34:	00 
c0103f35:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f3c:	e8 9c 16 00 00       	call   c01055dd <strcmp>
c0103f41:	85 c0                	test   %eax,%eax
c0103f43:	74 24                	je     c0103f69 <check_boot_pgdir+0x2fb>
c0103f45:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0103f4c:	c0 
c0103f4d:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103f54:	c0 
c0103f55:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103f5c:	00 
c0103f5d:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103f64:	e8 c8 c4 ff ff       	call   c0100431 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f6c:	89 04 24             	mov    %eax,(%esp)
c0103f6f:	e8 09 eb ff ff       	call   c0102a7d <page2kva>
c0103f74:	05 00 01 00 00       	add    $0x100,%eax
c0103f79:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103f7c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f83:	e8 79 15 00 00       	call   c0105501 <strlen>
c0103f88:	85 c0                	test   %eax,%eax
c0103f8a:	74 24                	je     c0103fb0 <check_boot_pgdir+0x342>
c0103f8c:	c7 44 24 0c 2c 6d 10 	movl   $0xc0106d2c,0xc(%esp)
c0103f93:	c0 
c0103f94:	c7 44 24 08 cd 68 10 	movl   $0xc01068cd,0x8(%esp)
c0103f9b:	c0 
c0103f9c:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103fa3:	00 
c0103fa4:	c7 04 24 a8 68 10 c0 	movl   $0xc01068a8,(%esp)
c0103fab:	e8 81 c4 ff ff       	call   c0100431 <__panic>

    free_page(p);
c0103fb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fb7:	00 
c0103fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fbb:	89 04 24             	mov    %eax,(%esp)
c0103fbe:	e8 a8 ed ff ff       	call   c0102d6b <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0103fc3:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103fc8:	8b 00                	mov    (%eax),%eax
c0103fca:	89 04 24             	mov    %eax,(%esp)
c0103fcd:	e8 3d eb ff ff       	call   c0102b0f <pde2page>
c0103fd2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fd9:	00 
c0103fda:	89 04 24             	mov    %eax,(%esp)
c0103fdd:	e8 89 ed ff ff       	call   c0102d6b <free_pages>
    boot_pgdir[0] = 0;
c0103fe2:	a1 e0 99 11 c0       	mov    0xc01199e0,%eax
c0103fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103fed:	c7 04 24 50 6d 10 c0 	movl   $0xc0106d50,(%esp)
c0103ff4:	e8 cc c2 ff ff       	call   c01002c5 <cprintf>
}
c0103ff9:	90                   	nop
c0103ffa:	c9                   	leave  
c0103ffb:	c3                   	ret    

c0103ffc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103ffc:	f3 0f 1e fb          	endbr32 
c0104000:	55                   	push   %ebp
c0104001:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104003:	8b 45 08             	mov    0x8(%ebp),%eax
c0104006:	83 e0 04             	and    $0x4,%eax
c0104009:	85 c0                	test   %eax,%eax
c010400b:	74 04                	je     c0104011 <perm2str+0x15>
c010400d:	b0 75                	mov    $0x75,%al
c010400f:	eb 02                	jmp    c0104013 <perm2str+0x17>
c0104011:	b0 2d                	mov    $0x2d,%al
c0104013:	a2 08 cf 11 c0       	mov    %al,0xc011cf08
    str[1] = 'r';
c0104018:	c6 05 09 cf 11 c0 72 	movb   $0x72,0xc011cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010401f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104022:	83 e0 02             	and    $0x2,%eax
c0104025:	85 c0                	test   %eax,%eax
c0104027:	74 04                	je     c010402d <perm2str+0x31>
c0104029:	b0 77                	mov    $0x77,%al
c010402b:	eb 02                	jmp    c010402f <perm2str+0x33>
c010402d:	b0 2d                	mov    $0x2d,%al
c010402f:	a2 0a cf 11 c0       	mov    %al,0xc011cf0a
    str[3] = '\0';
c0104034:	c6 05 0b cf 11 c0 00 	movb   $0x0,0xc011cf0b
    return str;
c010403b:	b8 08 cf 11 c0       	mov    $0xc011cf08,%eax
}
c0104040:	5d                   	pop    %ebp
c0104041:	c3                   	ret    

c0104042 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104042:	f3 0f 1e fb          	endbr32 
c0104046:	55                   	push   %ebp
c0104047:	89 e5                	mov    %esp,%ebp
c0104049:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010404c:	8b 45 10             	mov    0x10(%ebp),%eax
c010404f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104052:	72 0d                	jb     c0104061 <get_pgtable_items+0x1f>
        return 0;
c0104054:	b8 00 00 00 00       	mov    $0x0,%eax
c0104059:	e9 98 00 00 00       	jmp    c01040f6 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010405e:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104061:	8b 45 10             	mov    0x10(%ebp),%eax
c0104064:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104067:	73 18                	jae    c0104081 <get_pgtable_items+0x3f>
c0104069:	8b 45 10             	mov    0x10(%ebp),%eax
c010406c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104073:	8b 45 14             	mov    0x14(%ebp),%eax
c0104076:	01 d0                	add    %edx,%eax
c0104078:	8b 00                	mov    (%eax),%eax
c010407a:	83 e0 01             	and    $0x1,%eax
c010407d:	85 c0                	test   %eax,%eax
c010407f:	74 dd                	je     c010405e <get_pgtable_items+0x1c>
    }
    if (start < right) {
c0104081:	8b 45 10             	mov    0x10(%ebp),%eax
c0104084:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104087:	73 68                	jae    c01040f1 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104089:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010408d:	74 08                	je     c0104097 <get_pgtable_items+0x55>
            *left_store = start;
c010408f:	8b 45 18             	mov    0x18(%ebp),%eax
c0104092:	8b 55 10             	mov    0x10(%ebp),%edx
c0104095:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104097:	8b 45 10             	mov    0x10(%ebp),%eax
c010409a:	8d 50 01             	lea    0x1(%eax),%edx
c010409d:	89 55 10             	mov    %edx,0x10(%ebp)
c01040a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01040a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01040aa:	01 d0                	add    %edx,%eax
c01040ac:	8b 00                	mov    (%eax),%eax
c01040ae:	83 e0 07             	and    $0x7,%eax
c01040b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01040b4:	eb 03                	jmp    c01040b9 <get_pgtable_items+0x77>
            start ++;
c01040b6:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01040b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01040bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01040bf:	73 1d                	jae    c01040de <get_pgtable_items+0x9c>
c01040c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01040c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01040cb:	8b 45 14             	mov    0x14(%ebp),%eax
c01040ce:	01 d0                	add    %edx,%eax
c01040d0:	8b 00                	mov    (%eax),%eax
c01040d2:	83 e0 07             	and    $0x7,%eax
c01040d5:	89 c2                	mov    %eax,%edx
c01040d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040da:	39 c2                	cmp    %eax,%edx
c01040dc:	74 d8                	je     c01040b6 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
c01040de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01040e2:	74 08                	je     c01040ec <get_pgtable_items+0xaa>
            *right_store = start;
c01040e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01040e7:	8b 55 10             	mov    0x10(%ebp),%edx
c01040ea:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01040ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040ef:	eb 05                	jmp    c01040f6 <get_pgtable_items+0xb4>
    }
    return 0;
c01040f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01040f6:	c9                   	leave  
c01040f7:	c3                   	ret    

c01040f8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01040f8:	f3 0f 1e fb          	endbr32 
c01040fc:	55                   	push   %ebp
c01040fd:	89 e5                	mov    %esp,%ebp
c01040ff:	57                   	push   %edi
c0104100:	56                   	push   %esi
c0104101:	53                   	push   %ebx
c0104102:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104105:	c7 04 24 70 6d 10 c0 	movl   $0xc0106d70,(%esp)
c010410c:	e8 b4 c1 ff ff       	call   c01002c5 <cprintf>
    size_t left, right = 0, perm;
c0104111:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104118:	e9 fa 00 00 00       	jmp    c0104217 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010411d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104120:	89 04 24             	mov    %eax,(%esp)
c0104123:	e8 d4 fe ff ff       	call   c0103ffc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104128:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010412b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010412e:	29 d1                	sub    %edx,%ecx
c0104130:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104132:	89 d6                	mov    %edx,%esi
c0104134:	c1 e6 16             	shl    $0x16,%esi
c0104137:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010413a:	89 d3                	mov    %edx,%ebx
c010413c:	c1 e3 16             	shl    $0x16,%ebx
c010413f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104142:	89 d1                	mov    %edx,%ecx
c0104144:	c1 e1 16             	shl    $0x16,%ecx
c0104147:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010414a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010414d:	29 d7                	sub    %edx,%edi
c010414f:	89 fa                	mov    %edi,%edx
c0104151:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104155:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104159:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010415d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104161:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104165:	c7 04 24 a1 6d 10 c0 	movl   $0xc0106da1,(%esp)
c010416c:	e8 54 c1 ff ff       	call   c01002c5 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104171:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104174:	c1 e0 0a             	shl    $0xa,%eax
c0104177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010417a:	eb 54                	jmp    c01041d0 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010417c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010417f:	89 04 24             	mov    %eax,(%esp)
c0104182:	e8 75 fe ff ff       	call   c0103ffc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104187:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010418a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010418d:	29 d1                	sub    %edx,%ecx
c010418f:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104191:	89 d6                	mov    %edx,%esi
c0104193:	c1 e6 0c             	shl    $0xc,%esi
c0104196:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104199:	89 d3                	mov    %edx,%ebx
c010419b:	c1 e3 0c             	shl    $0xc,%ebx
c010419e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01041a1:	89 d1                	mov    %edx,%ecx
c01041a3:	c1 e1 0c             	shl    $0xc,%ecx
c01041a6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01041a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01041ac:	29 d7                	sub    %edx,%edi
c01041ae:	89 fa                	mov    %edi,%edx
c01041b0:	89 44 24 14          	mov    %eax,0x14(%esp)
c01041b4:	89 74 24 10          	mov    %esi,0x10(%esp)
c01041b8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01041bc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01041c0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041c4:	c7 04 24 c0 6d 10 c0 	movl   $0xc0106dc0,(%esp)
c01041cb:	e8 f5 c0 ff ff       	call   c01002c5 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01041d0:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c01041d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041db:	89 d3                	mov    %edx,%ebx
c01041dd:	c1 e3 0a             	shl    $0xa,%ebx
c01041e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041e3:	89 d1                	mov    %edx,%ecx
c01041e5:	c1 e1 0a             	shl    $0xa,%ecx
c01041e8:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01041eb:	89 54 24 14          	mov    %edx,0x14(%esp)
c01041ef:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01041f2:	89 54 24 10          	mov    %edx,0x10(%esp)
c01041f6:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01041fa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01041fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104202:	89 0c 24             	mov    %ecx,(%esp)
c0104205:	e8 38 fe ff ff       	call   c0104042 <get_pgtable_items>
c010420a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010420d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104211:	0f 85 65 ff ff ff    	jne    c010417c <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104217:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010421c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010421f:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104222:	89 54 24 14          	mov    %edx,0x14(%esp)
c0104226:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104229:	89 54 24 10          	mov    %edx,0x10(%esp)
c010422d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104231:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104235:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010423c:	00 
c010423d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104244:	e8 f9 fd ff ff       	call   c0104042 <get_pgtable_items>
c0104249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010424c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104250:	0f 85 c7 fe ff ff    	jne    c010411d <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104256:	c7 04 24 e4 6d 10 c0 	movl   $0xc0106de4,(%esp)
c010425d:	e8 63 c0 ff ff       	call   c01002c5 <cprintf>
}
c0104262:	90                   	nop
c0104263:	83 c4 4c             	add    $0x4c,%esp
c0104266:	5b                   	pop    %ebx
c0104267:	5e                   	pop    %esi
c0104268:	5f                   	pop    %edi
c0104269:	5d                   	pop    %ebp
c010426a:	c3                   	ret    

c010426b <page2ppn>:
page2ppn(struct Page *page) {
c010426b:	55                   	push   %ebp
c010426c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010426e:	a1 18 cf 11 c0       	mov    0xc011cf18,%eax
c0104273:	8b 55 08             	mov    0x8(%ebp),%edx
c0104276:	29 c2                	sub    %eax,%edx
c0104278:	89 d0                	mov    %edx,%eax
c010427a:	c1 f8 02             	sar    $0x2,%eax
c010427d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104283:	5d                   	pop    %ebp
c0104284:	c3                   	ret    

c0104285 <page2pa>:
page2pa(struct Page *page) {
c0104285:	55                   	push   %ebp
c0104286:	89 e5                	mov    %esp,%ebp
c0104288:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010428b:	8b 45 08             	mov    0x8(%ebp),%eax
c010428e:	89 04 24             	mov    %eax,(%esp)
c0104291:	e8 d5 ff ff ff       	call   c010426b <page2ppn>
c0104296:	c1 e0 0c             	shl    $0xc,%eax
}
c0104299:	c9                   	leave  
c010429a:	c3                   	ret    

c010429b <page_ref>:
page_ref(struct Page *page) {
c010429b:	55                   	push   %ebp
c010429c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010429e:	8b 45 08             	mov    0x8(%ebp),%eax
c01042a1:	8b 00                	mov    (%eax),%eax
}
c01042a3:	5d                   	pop    %ebp
c01042a4:	c3                   	ret    

c01042a5 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01042a5:	55                   	push   %ebp
c01042a6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01042a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ab:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042ae:	89 10                	mov    %edx,(%eax)
}
c01042b0:	90                   	nop
c01042b1:	5d                   	pop    %ebp
c01042b2:	c3                   	ret    

c01042b3 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01042b3:	f3 0f 1e fb          	endbr32 
c01042b7:	55                   	push   %ebp
c01042b8:	89 e5                	mov    %esp,%ebp
c01042ba:	83 ec 10             	sub    $0x10,%esp
c01042bd:	c7 45 fc 1c cf 11 c0 	movl   $0xc011cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01042c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01042ca:	89 50 04             	mov    %edx,0x4(%eax)
c01042cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042d0:	8b 50 04             	mov    0x4(%eax),%edx
c01042d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01042d6:	89 10                	mov    %edx,(%eax)
}
c01042d8:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01042d9:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c01042e0:	00 00 00 
}
c01042e3:	90                   	nop
c01042e4:	c9                   	leave  
c01042e5:	c3                   	ret    

c01042e6 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01042e6:	f3 0f 1e fb          	endbr32 
c01042ea:	55                   	push   %ebp
c01042eb:	89 e5                	mov    %esp,%ebp
c01042ed:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01042f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01042f4:	75 24                	jne    c010431a <default_init_memmap+0x34>
c01042f6:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c01042fd:	c0 
c01042fe:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104305:	c0 
c0104306:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010430d:	00 
c010430e:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104315:	e8 17 c1 ff ff       	call   c0100431 <__panic>
    struct Page *p = base;
c010431a:	8b 45 08             	mov    0x8(%ebp),%eax
c010431d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104320:	eb 7d                	jmp    c010439f <default_init_memmap+0xb9>
        assert(PageReserved(p));
c0104322:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104325:	83 c0 04             	add    $0x4,%eax
c0104328:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010432f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104332:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104335:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104338:	0f a3 10             	bt     %edx,(%eax)
c010433b:	19 c0                	sbb    %eax,%eax
c010433d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0104340:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104344:	0f 95 c0             	setne  %al
c0104347:	0f b6 c0             	movzbl %al,%eax
c010434a:	85 c0                	test   %eax,%eax
c010434c:	75 24                	jne    c0104372 <default_init_memmap+0x8c>
c010434e:	c7 44 24 0c 49 6e 10 	movl   $0xc0106e49,0xc(%esp)
c0104355:	c0 
c0104356:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010435d:	c0 
c010435e:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104365:	00 
c0104366:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010436d:	e8 bf c0 ff ff       	call   c0100431 <__panic>
        p->flags = p->property = 0;
c0104372:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104375:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010437c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437f:	8b 50 08             	mov    0x8(%eax),%edx
c0104382:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104385:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104388:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010438f:	00 
c0104390:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104393:	89 04 24             	mov    %eax,(%esp)
c0104396:	e8 0a ff ff ff       	call   c01042a5 <set_page_ref>
    for (; p != base + n; p ++) {
c010439b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010439f:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043a2:	89 d0                	mov    %edx,%eax
c01043a4:	c1 e0 02             	shl    $0x2,%eax
c01043a7:	01 d0                	add    %edx,%eax
c01043a9:	c1 e0 02             	shl    $0x2,%eax
c01043ac:	89 c2                	mov    %eax,%edx
c01043ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01043b1:	01 d0                	add    %edx,%eax
c01043b3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01043b6:	0f 85 66 ff ff ff    	jne    c0104322 <default_init_memmap+0x3c>
    }
    base->property = n;
c01043bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01043bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043c2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01043c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c8:	83 c0 04             	add    $0x4,%eax
c01043cb:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01043d2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01043d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01043db:	0f ab 10             	bts    %edx,(%eax)
}
c01043de:	90                   	nop
    nr_free += n;
c01043df:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c01043e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043e8:	01 d0                	add    %edx,%eax
c01043ea:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
    list_add(&free_list, &(base->page_link));
c01043ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f2:	83 c0 0c             	add    $0xc,%eax
c01043f5:	c7 45 e4 1c cf 11 c0 	movl   $0xc011cf1c,-0x1c(%ebp)
c01043fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01043ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104402:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104405:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104408:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010440b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010440e:	8b 40 04             	mov    0x4(%eax),%eax
c0104411:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104414:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104417:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010441a:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010441d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104420:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104423:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104426:	89 10                	mov    %edx,(%eax)
c0104428:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010442b:	8b 10                	mov    (%eax),%edx
c010442d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104430:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104433:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104436:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104439:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010443c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010443f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104442:	89 10                	mov    %edx,(%eax)
}
c0104444:	90                   	nop
}
c0104445:	90                   	nop
}
c0104446:	90                   	nop
}
c0104447:	90                   	nop
c0104448:	c9                   	leave  
c0104449:	c3                   	ret    

c010444a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010444a:	f3 0f 1e fb          	endbr32 
c010444e:	55                   	push   %ebp
c010444f:	89 e5                	mov    %esp,%ebp
c0104451:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104458:	75 24                	jne    c010447e <default_alloc_pages+0x34>
c010445a:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c0104461:	c0 
c0104462:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104469:	c0 
c010446a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0104471:	00 
c0104472:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104479:	e8 b3 bf ff ff       	call   c0100431 <__panic>
    if (n > nr_free) {
c010447e:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104483:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104486:	76 0a                	jbe    c0104492 <default_alloc_pages+0x48>
        return NULL;
c0104488:	b8 00 00 00 00       	mov    $0x0,%eax
c010448d:	e9 4e 01 00 00       	jmp    c01045e0 <default_alloc_pages+0x196>
    }
    struct Page *page = NULL;
c0104492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104499:	c7 45 f0 1c cf 11 c0 	movl   $0xc011cf1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01044a0:	eb 1c                	jmp    c01044be <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
c01044a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044a5:	83 e8 0c             	sub    $0xc,%eax
c01044a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01044ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044ae:	8b 40 08             	mov    0x8(%eax),%eax
c01044b1:	39 45 08             	cmp    %eax,0x8(%ebp)
c01044b4:	77 08                	ja     c01044be <default_alloc_pages+0x74>
            page = p;
c01044b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            //SetPageReserved(page);
            break;
c01044bc:	eb 18                	jmp    c01044d6 <default_alloc_pages+0x8c>
c01044be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01044c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044c7:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01044ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044cd:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01044d4:	75 cc                	jne    c01044a2 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
c01044d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044da:	0f 84 fd 00 00 00    	je     c01045dd <default_alloc_pages+0x193>
        //list_del(&(page->page_link));
        if (page->property > n) {
c01044e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e3:	8b 40 08             	mov    0x8(%eax),%eax
c01044e6:	39 45 08             	cmp    %eax,0x8(%ebp)
c01044e9:	0f 83 9a 00 00 00    	jae    c0104589 <default_alloc_pages+0x13f>
            struct Page *p = page + n;
c01044ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01044f2:	89 d0                	mov    %edx,%eax
c01044f4:	c1 e0 02             	shl    $0x2,%eax
c01044f7:	01 d0                	add    %edx,%eax
c01044f9:	c1 e0 02             	shl    $0x2,%eax
c01044fc:	89 c2                	mov    %eax,%edx
c01044fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104501:	01 d0                	add    %edx,%eax
c0104503:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0104506:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104509:	8b 40 08             	mov    0x8(%eax),%eax
c010450c:	2b 45 08             	sub    0x8(%ebp),%eax
c010450f:	89 c2                	mov    %eax,%edx
c0104511:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104514:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0104517:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010451a:	83 c0 04             	add    $0x4,%eax
c010451d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104524:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104527:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010452a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010452d:	0f ab 10             	bts    %edx,(%eax)
}
c0104530:	90                   	nop
            //ClearPageReserved(p);
            list_add(&free_list, &(p->page_link));
c0104531:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104534:	83 c0 0c             	add    $0xc,%eax
c0104537:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
c010453e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104541:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104544:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104547:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010454a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c010454d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104550:	8b 40 04             	mov    0x4(%eax),%eax
c0104553:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104556:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104559:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010455c:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010455f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0104562:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104565:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104568:	89 10                	mov    %edx,(%eax)
c010456a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010456d:	8b 10                	mov    (%eax),%edx
c010456f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104572:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104575:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104578:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010457b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010457e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104581:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104584:	89 10                	mov    %edx,(%eax)
}
c0104586:	90                   	nop
}
c0104587:	90                   	nop
}
c0104588:	90                   	nop
    }
        list_del(&(page->page_link));
c0104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458c:	83 c0 0c             	add    $0xc,%eax
c010458f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104592:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104595:	8b 40 04             	mov    0x4(%eax),%eax
c0104598:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010459b:	8b 12                	mov    (%edx),%edx
c010459d:	89 55 b0             	mov    %edx,-0x50(%ebp)
c01045a0:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01045a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01045a6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01045a9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01045ac:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01045af:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01045b2:	89 10                	mov    %edx,(%eax)
}
c01045b4:	90                   	nop
}
c01045b5:	90                   	nop
        nr_free -= n;
c01045b6:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01045bb:	2b 45 08             	sub    0x8(%ebp),%eax
c01045be:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
        ClearPageProperty(page);
c01045c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c6:	83 c0 04             	add    $0x4,%eax
c01045c9:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c01045d0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01045d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01045d6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01045d9:	0f b3 10             	btr    %edx,(%eax)
}
c01045dc:	90                   	nop
    }
    return page;
c01045dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01045e0:	c9                   	leave  
c01045e1:	c3                   	ret    

c01045e2 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01045e2:	f3 0f 1e fb          	endbr32 
c01045e6:	55                   	push   %ebp
c01045e7:	89 e5                	mov    %esp,%ebp
c01045e9:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c01045ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01045f3:	75 24                	jne    c0104619 <default_free_pages+0x37>
c01045f5:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c01045fc:	c0 
c01045fd:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104604:	c0 
c0104605:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010460c:	00 
c010460d:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104614:	e8 18 be ff ff       	call   c0100431 <__panic>
    struct Page *p = base;
c0104619:	8b 45 08             	mov    0x8(%ebp),%eax
c010461c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010461f:	e9 9d 00 00 00       	jmp    c01046c1 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
c0104624:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104627:	83 c0 04             	add    $0x4,%eax
c010462a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104631:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104634:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104637:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010463a:	0f a3 10             	bt     %edx,(%eax)
c010463d:	19 c0                	sbb    %eax,%eax
c010463f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104642:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104646:	0f 95 c0             	setne  %al
c0104649:	0f b6 c0             	movzbl %al,%eax
c010464c:	85 c0                	test   %eax,%eax
c010464e:	75 2c                	jne    c010467c <default_free_pages+0x9a>
c0104650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104653:	83 c0 04             	add    $0x4,%eax
c0104656:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010465d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104660:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104663:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104666:	0f a3 10             	bt     %edx,(%eax)
c0104669:	19 c0                	sbb    %eax,%eax
c010466b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010466e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104672:	0f 95 c0             	setne  %al
c0104675:	0f b6 c0             	movzbl %al,%eax
c0104678:	85 c0                	test   %eax,%eax
c010467a:	74 24                	je     c01046a0 <default_free_pages+0xbe>
c010467c:	c7 44 24 0c 5c 6e 10 	movl   $0xc0106e5c,0xc(%esp)
c0104683:	c0 
c0104684:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010468b:	c0 
c010468c:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0104693:	00 
c0104694:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010469b:	e8 91 bd ff ff       	call   c0100431 <__panic>
        p->flags = 0;
c01046a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01046aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046b1:	00 
c01046b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046b5:	89 04 24             	mov    %eax,(%esp)
c01046b8:	e8 e8 fb ff ff       	call   c01042a5 <set_page_ref>
    for (; p != base + n; p ++) {
c01046bd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01046c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046c4:	89 d0                	mov    %edx,%eax
c01046c6:	c1 e0 02             	shl    $0x2,%eax
c01046c9:	01 d0                	add    %edx,%eax
c01046cb:	c1 e0 02             	shl    $0x2,%eax
c01046ce:	89 c2                	mov    %eax,%edx
c01046d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d3:	01 d0                	add    %edx,%eax
c01046d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046d8:	0f 85 46 ff ff ff    	jne    c0104624 <default_free_pages+0x42>
    }
    base->property = n;
c01046de:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01046e4:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01046e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ea:	83 c0 04             	add    $0x4,%eax
c01046ed:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01046f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01046fa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01046fd:	0f ab 10             	bts    %edx,(%eax)
}
c0104700:	90                   	nop
c0104701:	c7 45 d4 1c cf 11 c0 	movl   $0xc011cf1c,-0x2c(%ebp)
    return listelm->next;
c0104708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010470b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c010470e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104711:	e9 0e 01 00 00       	jmp    c0104824 <default_free_pages+0x242>
        p = le2page(le, page_link);
c0104716:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104719:	83 e8 0c             	sub    $0xc,%eax
c010471c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104722:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104725:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104728:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010472b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c010472e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104731:	8b 50 08             	mov    0x8(%eax),%edx
c0104734:	89 d0                	mov    %edx,%eax
c0104736:	c1 e0 02             	shl    $0x2,%eax
c0104739:	01 d0                	add    %edx,%eax
c010473b:	c1 e0 02             	shl    $0x2,%eax
c010473e:	89 c2                	mov    %eax,%edx
c0104740:	8b 45 08             	mov    0x8(%ebp),%eax
c0104743:	01 d0                	add    %edx,%eax
c0104745:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104748:	75 5d                	jne    c01047a7 <default_free_pages+0x1c5>
            base->property += p->property;
c010474a:	8b 45 08             	mov    0x8(%ebp),%eax
c010474d:	8b 50 08             	mov    0x8(%eax),%edx
c0104750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104753:	8b 40 08             	mov    0x8(%eax),%eax
c0104756:	01 c2                	add    %eax,%edx
c0104758:	8b 45 08             	mov    0x8(%ebp),%eax
c010475b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010475e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104761:	83 c0 04             	add    $0x4,%eax
c0104764:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010476b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010476e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104771:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104774:	0f b3 10             	btr    %edx,(%eax)
}
c0104777:	90                   	nop
            list_del(&(p->page_link));
c0104778:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010477b:	83 c0 0c             	add    $0xc,%eax
c010477e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104781:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104784:	8b 40 04             	mov    0x4(%eax),%eax
c0104787:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010478a:	8b 12                	mov    (%edx),%edx
c010478c:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010478f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104792:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104795:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104798:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010479b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010479e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01047a1:	89 10                	mov    %edx,(%eax)
}
c01047a3:	90                   	nop
}
c01047a4:	90                   	nop
c01047a5:	eb 7d                	jmp    c0104824 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
c01047a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047aa:	8b 50 08             	mov    0x8(%eax),%edx
c01047ad:	89 d0                	mov    %edx,%eax
c01047af:	c1 e0 02             	shl    $0x2,%eax
c01047b2:	01 d0                	add    %edx,%eax
c01047b4:	c1 e0 02             	shl    $0x2,%eax
c01047b7:	89 c2                	mov    %eax,%edx
c01047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047bc:	01 d0                	add    %edx,%eax
c01047be:	39 45 08             	cmp    %eax,0x8(%ebp)
c01047c1:	75 61                	jne    c0104824 <default_free_pages+0x242>
            p->property += base->property;
c01047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c6:	8b 50 08             	mov    0x8(%eax),%edx
c01047c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047cc:	8b 40 08             	mov    0x8(%eax),%eax
c01047cf:	01 c2                	add    %eax,%edx
c01047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d4:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01047d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01047da:	83 c0 04             	add    $0x4,%eax
c01047dd:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c01047e4:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01047e7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01047ea:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01047ed:	0f b3 10             	btr    %edx,(%eax)
}
c01047f0:	90                   	nop
            base = p;
c01047f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f4:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c01047f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fa:	83 c0 0c             	add    $0xc,%eax
c01047fd:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104800:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104803:	8b 40 04             	mov    0x4(%eax),%eax
c0104806:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104809:	8b 12                	mov    (%edx),%edx
c010480b:	89 55 ac             	mov    %edx,-0x54(%ebp)
c010480e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104811:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104814:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104817:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010481a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010481d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104820:	89 10                	mov    %edx,(%eax)
}
c0104822:	90                   	nop
}
c0104823:	90                   	nop
    while (le != &free_list) {
c0104824:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c010482b:	0f 85 e5 fe ff ff    	jne    c0104716 <default_free_pages+0x134>
        }
    }
    nr_free += n;
c0104831:	8b 15 24 cf 11 c0    	mov    0xc011cf24,%edx
c0104837:	8b 45 0c             	mov    0xc(%ebp),%eax
c010483a:	01 d0                	add    %edx,%eax
c010483c:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24
c0104841:	c7 45 9c 1c cf 11 c0 	movl   $0xc011cf1c,-0x64(%ebp)
    return listelm->next;
c0104848:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010484b:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c010484e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104851:	eb 74                	jmp    c01048c7 <default_free_pages+0x2e5>
        p = le2page(le, page_link);
c0104853:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104856:	83 e8 0c             	sub    $0xc,%eax
c0104859:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c010485c:	8b 45 08             	mov    0x8(%ebp),%eax
c010485f:	8b 50 08             	mov    0x8(%eax),%edx
c0104862:	89 d0                	mov    %edx,%eax
c0104864:	c1 e0 02             	shl    $0x2,%eax
c0104867:	01 d0                	add    %edx,%eax
c0104869:	c1 e0 02             	shl    $0x2,%eax
c010486c:	89 c2                	mov    %eax,%edx
c010486e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104871:	01 d0                	add    %edx,%eax
c0104873:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104876:	72 40                	jb     c01048b8 <default_free_pages+0x2d6>
            assert(base + base->property != p);
c0104878:	8b 45 08             	mov    0x8(%ebp),%eax
c010487b:	8b 50 08             	mov    0x8(%eax),%edx
c010487e:	89 d0                	mov    %edx,%eax
c0104880:	c1 e0 02             	shl    $0x2,%eax
c0104883:	01 d0                	add    %edx,%eax
c0104885:	c1 e0 02             	shl    $0x2,%eax
c0104888:	89 c2                	mov    %eax,%edx
c010488a:	8b 45 08             	mov    0x8(%ebp),%eax
c010488d:	01 d0                	add    %edx,%eax
c010488f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104892:	75 3e                	jne    c01048d2 <default_free_pages+0x2f0>
c0104894:	c7 44 24 0c 81 6e 10 	movl   $0xc0106e81,0xc(%esp)
c010489b:	c0 
c010489c:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01048a3:	c0 
c01048a4:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01048ab:	00 
c01048ac:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01048b3:	e8 79 bb ff ff       	call   c0100431 <__panic>
c01048b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048bb:	89 45 98             	mov    %eax,-0x68(%ebp)
c01048be:	8b 45 98             	mov    -0x68(%ebp),%eax
c01048c1:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c01048c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01048c7:	81 7d f0 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x10(%ebp)
c01048ce:	75 83                	jne    c0104853 <default_free_pages+0x271>
c01048d0:	eb 01                	jmp    c01048d3 <default_free_pages+0x2f1>
            break;
c01048d2:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c01048d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d6:	8d 50 0c             	lea    0xc(%eax),%edx
c01048d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048dc:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01048df:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01048e2:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01048e5:	8b 00                	mov    (%eax),%eax
c01048e7:	8b 55 90             	mov    -0x70(%ebp),%edx
c01048ea:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01048ed:	89 45 88             	mov    %eax,-0x78(%ebp)
c01048f0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01048f3:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c01048f6:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01048f9:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01048fc:	89 10                	mov    %edx,(%eax)
c01048fe:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104901:	8b 10                	mov    (%eax),%edx
c0104903:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104906:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104909:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010490c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010490f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104912:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104915:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104918:	89 10                	mov    %edx,(%eax)
}
c010491a:	90                   	nop
}
c010491b:	90                   	nop
}
c010491c:	90                   	nop
c010491d:	c9                   	leave  
c010491e:	c3                   	ret    

c010491f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010491f:	f3 0f 1e fb          	endbr32 
c0104923:	55                   	push   %ebp
c0104924:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0104926:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
}
c010492b:	5d                   	pop    %ebp
c010492c:	c3                   	ret    

c010492d <basic_check>:

static void
basic_check(void) {
c010492d:	f3 0f 1e fb          	endbr32 
c0104931:	55                   	push   %ebp
c0104932:	89 e5                	mov    %esp,%ebp
c0104934:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104937:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010493e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104941:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104947:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010494a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104951:	e8 d9 e3 ff ff       	call   c0102d2f <alloc_pages>
c0104956:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104959:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010495d:	75 24                	jne    c0104983 <basic_check+0x56>
c010495f:	c7 44 24 0c 9c 6e 10 	movl   $0xc0106e9c,0xc(%esp)
c0104966:	c0 
c0104967:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010496e:	c0 
c010496f:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104976:	00 
c0104977:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010497e:	e8 ae ba ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104983:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010498a:	e8 a0 e3 ff ff       	call   c0102d2f <alloc_pages>
c010498f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104996:	75 24                	jne    c01049bc <basic_check+0x8f>
c0104998:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c010499f:	c0 
c01049a0:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01049a7:	c0 
c01049a8:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01049af:	00 
c01049b0:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01049b7:	e8 75 ba ff ff       	call   c0100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01049bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049c3:	e8 67 e3 ff ff       	call   c0102d2f <alloc_pages>
c01049c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049cf:	75 24                	jne    c01049f5 <basic_check+0xc8>
c01049d1:	c7 44 24 0c d4 6e 10 	movl   $0xc0106ed4,0xc(%esp)
c01049d8:	c0 
c01049d9:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01049e0:	c0 
c01049e1:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01049e8:	00 
c01049e9:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01049f0:	e8 3c ba ff ff       	call   c0100431 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01049f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049fb:	74 10                	je     c0104a0d <basic_check+0xe0>
c01049fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a00:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a03:	74 08                	je     c0104a0d <basic_check+0xe0>
c0104a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a0b:	75 24                	jne    c0104a31 <basic_check+0x104>
c0104a0d:	c7 44 24 0c f0 6e 10 	movl   $0xc0106ef0,0xc(%esp)
c0104a14:	c0 
c0104a15:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104a1c:	c0 
c0104a1d:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104a24:	00 
c0104a25:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104a2c:	e8 00 ba ff ff       	call   c0100431 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a34:	89 04 24             	mov    %eax,(%esp)
c0104a37:	e8 5f f8 ff ff       	call   c010429b <page_ref>
c0104a3c:	85 c0                	test   %eax,%eax
c0104a3e:	75 1e                	jne    c0104a5e <basic_check+0x131>
c0104a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a43:	89 04 24             	mov    %eax,(%esp)
c0104a46:	e8 50 f8 ff ff       	call   c010429b <page_ref>
c0104a4b:	85 c0                	test   %eax,%eax
c0104a4d:	75 0f                	jne    c0104a5e <basic_check+0x131>
c0104a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a52:	89 04 24             	mov    %eax,(%esp)
c0104a55:	e8 41 f8 ff ff       	call   c010429b <page_ref>
c0104a5a:	85 c0                	test   %eax,%eax
c0104a5c:	74 24                	je     c0104a82 <basic_check+0x155>
c0104a5e:	c7 44 24 0c 14 6f 10 	movl   $0xc0106f14,0xc(%esp)
c0104a65:	c0 
c0104a66:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104a6d:	c0 
c0104a6e:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104a75:	00 
c0104a76:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104a7d:	e8 af b9 ff ff       	call   c0100431 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a85:	89 04 24             	mov    %eax,(%esp)
c0104a88:	e8 f8 f7 ff ff       	call   c0104285 <page2pa>
c0104a8d:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104a93:	c1 e2 0c             	shl    $0xc,%edx
c0104a96:	39 d0                	cmp    %edx,%eax
c0104a98:	72 24                	jb     c0104abe <basic_check+0x191>
c0104a9a:	c7 44 24 0c 50 6f 10 	movl   $0xc0106f50,0xc(%esp)
c0104aa1:	c0 
c0104aa2:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104aa9:	c0 
c0104aaa:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0104ab1:	00 
c0104ab2:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104ab9:	e8 73 b9 ff ff       	call   c0100431 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac1:	89 04 24             	mov    %eax,(%esp)
c0104ac4:	e8 bc f7 ff ff       	call   c0104285 <page2pa>
c0104ac9:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104acf:	c1 e2 0c             	shl    $0xc,%edx
c0104ad2:	39 d0                	cmp    %edx,%eax
c0104ad4:	72 24                	jb     c0104afa <basic_check+0x1cd>
c0104ad6:	c7 44 24 0c 6d 6f 10 	movl   $0xc0106f6d,0xc(%esp)
c0104add:	c0 
c0104ade:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104ae5:	c0 
c0104ae6:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0104aed:	00 
c0104aee:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104af5:	e8 37 b9 ff ff       	call   c0100431 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104afd:	89 04 24             	mov    %eax,(%esp)
c0104b00:	e8 80 f7 ff ff       	call   c0104285 <page2pa>
c0104b05:	8b 15 80 ce 11 c0    	mov    0xc011ce80,%edx
c0104b0b:	c1 e2 0c             	shl    $0xc,%edx
c0104b0e:	39 d0                	cmp    %edx,%eax
c0104b10:	72 24                	jb     c0104b36 <basic_check+0x209>
c0104b12:	c7 44 24 0c 8a 6f 10 	movl   $0xc0106f8a,0xc(%esp)
c0104b19:	c0 
c0104b1a:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104b21:	c0 
c0104b22:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0104b29:	00 
c0104b2a:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104b31:	e8 fb b8 ff ff       	call   c0100431 <__panic>

    list_entry_t free_list_store = free_list;
c0104b36:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104b3b:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104b41:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104b47:	c7 45 dc 1c cf 11 c0 	movl   $0xc011cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104b4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b51:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b54:	89 50 04             	mov    %edx,0x4(%eax)
c0104b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b5a:	8b 50 04             	mov    0x4(%eax),%edx
c0104b5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b60:	89 10                	mov    %edx,(%eax)
}
c0104b62:	90                   	nop
c0104b63:	c7 45 e0 1c cf 11 c0 	movl   $0xc011cf1c,-0x20(%ebp)
    return list->next == list;
c0104b6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b6d:	8b 40 04             	mov    0x4(%eax),%eax
c0104b70:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104b73:	0f 94 c0             	sete   %al
c0104b76:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104b79:	85 c0                	test   %eax,%eax
c0104b7b:	75 24                	jne    c0104ba1 <basic_check+0x274>
c0104b7d:	c7 44 24 0c a7 6f 10 	movl   $0xc0106fa7,0xc(%esp)
c0104b84:	c0 
c0104b85:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104b8c:	c0 
c0104b8d:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0104b94:	00 
c0104b95:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104b9c:	e8 90 b8 ff ff       	call   c0100431 <__panic>

    unsigned int nr_free_store = nr_free;
c0104ba1:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104ba9:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0104bb0:	00 00 00 

    assert(alloc_page() == NULL);
c0104bb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bba:	e8 70 e1 ff ff       	call   c0102d2f <alloc_pages>
c0104bbf:	85 c0                	test   %eax,%eax
c0104bc1:	74 24                	je     c0104be7 <basic_check+0x2ba>
c0104bc3:	c7 44 24 0c be 6f 10 	movl   $0xc0106fbe,0xc(%esp)
c0104bca:	c0 
c0104bcb:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104bd2:	c0 
c0104bd3:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0104bda:	00 
c0104bdb:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104be2:	e8 4a b8 ff ff       	call   c0100431 <__panic>

    free_page(p0);
c0104be7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104bee:	00 
c0104bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bf2:	89 04 24             	mov    %eax,(%esp)
c0104bf5:	e8 71 e1 ff ff       	call   c0102d6b <free_pages>
    free_page(p1);
c0104bfa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c01:	00 
c0104c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c05:	89 04 24             	mov    %eax,(%esp)
c0104c08:	e8 5e e1 ff ff       	call   c0102d6b <free_pages>
    free_page(p2);
c0104c0d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c14:	00 
c0104c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c18:	89 04 24             	mov    %eax,(%esp)
c0104c1b:	e8 4b e1 ff ff       	call   c0102d6b <free_pages>
    assert(nr_free == 3);
c0104c20:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104c25:	83 f8 03             	cmp    $0x3,%eax
c0104c28:	74 24                	je     c0104c4e <basic_check+0x321>
c0104c2a:	c7 44 24 0c d3 6f 10 	movl   $0xc0106fd3,0xc(%esp)
c0104c31:	c0 
c0104c32:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104c39:	c0 
c0104c3a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104c41:	00 
c0104c42:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104c49:	e8 e3 b7 ff ff       	call   c0100431 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104c4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c55:	e8 d5 e0 ff ff       	call   c0102d2f <alloc_pages>
c0104c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104c61:	75 24                	jne    c0104c87 <basic_check+0x35a>
c0104c63:	c7 44 24 0c 9c 6e 10 	movl   $0xc0106e9c,0xc(%esp)
c0104c6a:	c0 
c0104c6b:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104c72:	c0 
c0104c73:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104c7a:	00 
c0104c7b:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104c82:	e8 aa b7 ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104c87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c8e:	e8 9c e0 ff ff       	call   c0102d2f <alloc_pages>
c0104c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c9a:	75 24                	jne    c0104cc0 <basic_check+0x393>
c0104c9c:	c7 44 24 0c b8 6e 10 	movl   $0xc0106eb8,0xc(%esp)
c0104ca3:	c0 
c0104ca4:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104cab:	c0 
c0104cac:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0104cb3:	00 
c0104cb4:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104cbb:	e8 71 b7 ff ff       	call   c0100431 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104cc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104cc7:	e8 63 e0 ff ff       	call   c0102d2f <alloc_pages>
c0104ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cd3:	75 24                	jne    c0104cf9 <basic_check+0x3cc>
c0104cd5:	c7 44 24 0c d4 6e 10 	movl   $0xc0106ed4,0xc(%esp)
c0104cdc:	c0 
c0104cdd:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104ce4:	c0 
c0104ce5:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0104cec:	00 
c0104ced:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104cf4:	e8 38 b7 ff ff       	call   c0100431 <__panic>

    assert(alloc_page() == NULL);
c0104cf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d00:	e8 2a e0 ff ff       	call   c0102d2f <alloc_pages>
c0104d05:	85 c0                	test   %eax,%eax
c0104d07:	74 24                	je     c0104d2d <basic_check+0x400>
c0104d09:	c7 44 24 0c be 6f 10 	movl   $0xc0106fbe,0xc(%esp)
c0104d10:	c0 
c0104d11:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104d18:	c0 
c0104d19:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104d20:	00 
c0104d21:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104d28:	e8 04 b7 ff ff       	call   c0100431 <__panic>

    free_page(p0);
c0104d2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d34:	00 
c0104d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d38:	89 04 24             	mov    %eax,(%esp)
c0104d3b:	e8 2b e0 ff ff       	call   c0102d6b <free_pages>
c0104d40:	c7 45 d8 1c cf 11 c0 	movl   $0xc011cf1c,-0x28(%ebp)
c0104d47:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104d4a:	8b 40 04             	mov    0x4(%eax),%eax
c0104d4d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104d50:	0f 94 c0             	sete   %al
c0104d53:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104d56:	85 c0                	test   %eax,%eax
c0104d58:	74 24                	je     c0104d7e <basic_check+0x451>
c0104d5a:	c7 44 24 0c e0 6f 10 	movl   $0xc0106fe0,0xc(%esp)
c0104d61:	c0 
c0104d62:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104d69:	c0 
c0104d6a:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0104d71:	00 
c0104d72:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104d79:	e8 b3 b6 ff ff       	call   c0100431 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104d7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d85:	e8 a5 df ff ff       	call   c0102d2f <alloc_pages>
c0104d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104d93:	74 24                	je     c0104db9 <basic_check+0x48c>
c0104d95:	c7 44 24 0c f8 6f 10 	movl   $0xc0106ff8,0xc(%esp)
c0104d9c:	c0 
c0104d9d:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104da4:	c0 
c0104da5:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0104dac:	00 
c0104dad:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104db4:	e8 78 b6 ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c0104db9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dc0:	e8 6a df ff ff       	call   c0102d2f <alloc_pages>
c0104dc5:	85 c0                	test   %eax,%eax
c0104dc7:	74 24                	je     c0104ded <basic_check+0x4c0>
c0104dc9:	c7 44 24 0c be 6f 10 	movl   $0xc0106fbe,0xc(%esp)
c0104dd0:	c0 
c0104dd1:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104dd8:	c0 
c0104dd9:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0104de0:	00 
c0104de1:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104de8:	e8 44 b6 ff ff       	call   c0100431 <__panic>

    assert(nr_free == 0);
c0104ded:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c0104df2:	85 c0                	test   %eax,%eax
c0104df4:	74 24                	je     c0104e1a <basic_check+0x4ed>
c0104df6:	c7 44 24 0c 11 70 10 	movl   $0xc0107011,0xc(%esp)
c0104dfd:	c0 
c0104dfe:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104e05:	c0 
c0104e06:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0104e0d:	00 
c0104e0e:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104e15:	e8 17 b6 ff ff       	call   c0100431 <__panic>
    free_list = free_list_store;
c0104e1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104e1d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104e20:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0104e25:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    nr_free = nr_free_store;
c0104e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e2e:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_page(p);
c0104e33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e3a:	00 
c0104e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e3e:	89 04 24             	mov    %eax,(%esp)
c0104e41:	e8 25 df ff ff       	call   c0102d6b <free_pages>
    free_page(p1);
c0104e46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e4d:	00 
c0104e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e51:	89 04 24             	mov    %eax,(%esp)
c0104e54:	e8 12 df ff ff       	call   c0102d6b <free_pages>
    free_page(p2);
c0104e59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e60:	00 
c0104e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e64:	89 04 24             	mov    %eax,(%esp)
c0104e67:	e8 ff de ff ff       	call   c0102d6b <free_pages>
}
c0104e6c:	90                   	nop
c0104e6d:	c9                   	leave  
c0104e6e:	c3                   	ret    

c0104e6f <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104e6f:	f3 0f 1e fb          	endbr32 
c0104e73:	55                   	push   %ebp
c0104e74:	89 e5                	mov    %esp,%ebp
c0104e76:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104e8a:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104e91:	eb 6a                	jmp    c0104efd <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
c0104e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e96:	83 e8 0c             	sub    $0xc,%eax
c0104e99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104e9c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104e9f:	83 c0 04             	add    $0x4,%eax
c0104ea2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104ea9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104eac:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104eaf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104eb2:	0f a3 10             	bt     %edx,(%eax)
c0104eb5:	19 c0                	sbb    %eax,%eax
c0104eb7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104eba:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104ebe:	0f 95 c0             	setne  %al
c0104ec1:	0f b6 c0             	movzbl %al,%eax
c0104ec4:	85 c0                	test   %eax,%eax
c0104ec6:	75 24                	jne    c0104eec <default_check+0x7d>
c0104ec8:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c0104ecf:	c0 
c0104ed0:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104ed7:	c0 
c0104ed8:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104edf:	00 
c0104ee0:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104ee7:	e8 45 b5 ff ff       	call   c0100431 <__panic>
        count ++, total += p->property;
c0104eec:	ff 45 f4             	incl   -0xc(%ebp)
c0104eef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104ef2:	8b 50 08             	mov    0x8(%eax),%edx
c0104ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef8:	01 d0                	add    %edx,%eax
c0104efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104f03:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f06:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104f09:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f0c:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c0104f13:	0f 85 7a ff ff ff    	jne    c0104e93 <default_check+0x24>
    }
    assert(total == nr_free_pages());
c0104f19:	e8 84 de ff ff       	call   c0102da2 <nr_free_pages>
c0104f1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f21:	39 d0                	cmp    %edx,%eax
c0104f23:	74 24                	je     c0104f49 <default_check+0xda>
c0104f25:	c7 44 24 0c 2e 70 10 	movl   $0xc010702e,0xc(%esp)
c0104f2c:	c0 
c0104f2d:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104f34:	c0 
c0104f35:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0104f3c:	00 
c0104f3d:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104f44:	e8 e8 b4 ff ff       	call   c0100431 <__panic>

    basic_check();
c0104f49:	e8 df f9 ff ff       	call   c010492d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104f4e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104f55:	e8 d5 dd ff ff       	call   c0102d2f <alloc_pages>
c0104f5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104f5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104f61:	75 24                	jne    c0104f87 <default_check+0x118>
c0104f63:	c7 44 24 0c 47 70 10 	movl   $0xc0107047,0xc(%esp)
c0104f6a:	c0 
c0104f6b:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104f72:	c0 
c0104f73:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104f7a:	00 
c0104f7b:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104f82:	e8 aa b4 ff ff       	call   c0100431 <__panic>
    assert(!PageProperty(p0));
c0104f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f8a:	83 c0 04             	add    $0x4,%eax
c0104f8d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104f94:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f97:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104f9a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104f9d:	0f a3 10             	bt     %edx,(%eax)
c0104fa0:	19 c0                	sbb    %eax,%eax
c0104fa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104fa5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104fa9:	0f 95 c0             	setne  %al
c0104fac:	0f b6 c0             	movzbl %al,%eax
c0104faf:	85 c0                	test   %eax,%eax
c0104fb1:	74 24                	je     c0104fd7 <default_check+0x168>
c0104fb3:	c7 44 24 0c 52 70 10 	movl   $0xc0107052,0xc(%esp)
c0104fba:	c0 
c0104fbb:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0104fc2:	c0 
c0104fc3:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104fca:	00 
c0104fcb:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0104fd2:	e8 5a b4 ff ff       	call   c0100431 <__panic>

    list_entry_t free_list_store = free_list;
c0104fd7:	a1 1c cf 11 c0       	mov    0xc011cf1c,%eax
c0104fdc:	8b 15 20 cf 11 c0    	mov    0xc011cf20,%edx
c0104fe2:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104fe5:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104fe8:	c7 45 b0 1c cf 11 c0 	movl   $0xc011cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104fef:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ff2:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104ff5:	89 50 04             	mov    %edx,0x4(%eax)
c0104ff8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ffb:	8b 50 04             	mov    0x4(%eax),%edx
c0104ffe:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105001:	89 10                	mov    %edx,(%eax)
}
c0105003:	90                   	nop
c0105004:	c7 45 b4 1c cf 11 c0 	movl   $0xc011cf1c,-0x4c(%ebp)
    return list->next == list;
c010500b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010500e:	8b 40 04             	mov    0x4(%eax),%eax
c0105011:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105014:	0f 94 c0             	sete   %al
c0105017:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010501a:	85 c0                	test   %eax,%eax
c010501c:	75 24                	jne    c0105042 <default_check+0x1d3>
c010501e:	c7 44 24 0c a7 6f 10 	movl   $0xc0106fa7,0xc(%esp)
c0105025:	c0 
c0105026:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010502d:	c0 
c010502e:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0105035:	00 
c0105036:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010503d:	e8 ef b3 ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c0105042:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105049:	e8 e1 dc ff ff       	call   c0102d2f <alloc_pages>
c010504e:	85 c0                	test   %eax,%eax
c0105050:	74 24                	je     c0105076 <default_check+0x207>
c0105052:	c7 44 24 0c be 6f 10 	movl   $0xc0106fbe,0xc(%esp)
c0105059:	c0 
c010505a:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0105061:	c0 
c0105062:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0105069:	00 
c010506a:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0105071:	e8 bb b3 ff ff       	call   c0100431 <__panic>

    unsigned int nr_free_store = nr_free;
c0105076:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c010507b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010507e:	c7 05 24 cf 11 c0 00 	movl   $0x0,0xc011cf24
c0105085:	00 00 00 

    free_pages(p0 + 2, 3);
c0105088:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010508b:	83 c0 28             	add    $0x28,%eax
c010508e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105095:	00 
c0105096:	89 04 24             	mov    %eax,(%esp)
c0105099:	e8 cd dc ff ff       	call   c0102d6b <free_pages>
    assert(alloc_pages(4) == NULL);
c010509e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01050a5:	e8 85 dc ff ff       	call   c0102d2f <alloc_pages>
c01050aa:	85 c0                	test   %eax,%eax
c01050ac:	74 24                	je     c01050d2 <default_check+0x263>
c01050ae:	c7 44 24 0c 64 70 10 	movl   $0xc0107064,0xc(%esp)
c01050b5:	c0 
c01050b6:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01050bd:	c0 
c01050be:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01050c5:	00 
c01050c6:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01050cd:	e8 5f b3 ff ff       	call   c0100431 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01050d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050d5:	83 c0 28             	add    $0x28,%eax
c01050d8:	83 c0 04             	add    $0x4,%eax
c01050db:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01050e2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01050e5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01050e8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01050eb:	0f a3 10             	bt     %edx,(%eax)
c01050ee:	19 c0                	sbb    %eax,%eax
c01050f0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01050f3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01050f7:	0f 95 c0             	setne  %al
c01050fa:	0f b6 c0             	movzbl %al,%eax
c01050fd:	85 c0                	test   %eax,%eax
c01050ff:	74 0e                	je     c010510f <default_check+0x2a0>
c0105101:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105104:	83 c0 28             	add    $0x28,%eax
c0105107:	8b 40 08             	mov    0x8(%eax),%eax
c010510a:	83 f8 03             	cmp    $0x3,%eax
c010510d:	74 24                	je     c0105133 <default_check+0x2c4>
c010510f:	c7 44 24 0c 7c 70 10 	movl   $0xc010707c,0xc(%esp)
c0105116:	c0 
c0105117:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010511e:	c0 
c010511f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105126:	00 
c0105127:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010512e:	e8 fe b2 ff ff       	call   c0100431 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105133:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010513a:	e8 f0 db ff ff       	call   c0102d2f <alloc_pages>
c010513f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105142:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105146:	75 24                	jne    c010516c <default_check+0x2fd>
c0105148:	c7 44 24 0c a8 70 10 	movl   $0xc01070a8,0xc(%esp)
c010514f:	c0 
c0105150:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0105157:	c0 
c0105158:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010515f:	00 
c0105160:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0105167:	e8 c5 b2 ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c010516c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105173:	e8 b7 db ff ff       	call   c0102d2f <alloc_pages>
c0105178:	85 c0                	test   %eax,%eax
c010517a:	74 24                	je     c01051a0 <default_check+0x331>
c010517c:	c7 44 24 0c be 6f 10 	movl   $0xc0106fbe,0xc(%esp)
c0105183:	c0 
c0105184:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010518b:	c0 
c010518c:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0105193:	00 
c0105194:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010519b:	e8 91 b2 ff ff       	call   c0100431 <__panic>
    assert(p0 + 2 == p1);
c01051a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051a3:	83 c0 28             	add    $0x28,%eax
c01051a6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01051a9:	74 24                	je     c01051cf <default_check+0x360>
c01051ab:	c7 44 24 0c c6 70 10 	movl   $0xc01070c6,0xc(%esp)
c01051b2:	c0 
c01051b3:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01051ba:	c0 
c01051bb:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01051c2:	00 
c01051c3:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01051ca:	e8 62 b2 ff ff       	call   c0100431 <__panic>

    p2 = p0 + 1;
c01051cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051d2:	83 c0 14             	add    $0x14,%eax
c01051d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01051d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051df:	00 
c01051e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051e3:	89 04 24             	mov    %eax,(%esp)
c01051e6:	e8 80 db ff ff       	call   c0102d6b <free_pages>
    free_pages(p1, 3);
c01051eb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01051f2:	00 
c01051f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051f6:	89 04 24             	mov    %eax,(%esp)
c01051f9:	e8 6d db ff ff       	call   c0102d6b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01051fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105201:	83 c0 04             	add    $0x4,%eax
c0105204:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010520b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010520e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105211:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105214:	0f a3 10             	bt     %edx,(%eax)
c0105217:	19 c0                	sbb    %eax,%eax
c0105219:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010521c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105220:	0f 95 c0             	setne  %al
c0105223:	0f b6 c0             	movzbl %al,%eax
c0105226:	85 c0                	test   %eax,%eax
c0105228:	74 0b                	je     c0105235 <default_check+0x3c6>
c010522a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010522d:	8b 40 08             	mov    0x8(%eax),%eax
c0105230:	83 f8 01             	cmp    $0x1,%eax
c0105233:	74 24                	je     c0105259 <default_check+0x3ea>
c0105235:	c7 44 24 0c d4 70 10 	movl   $0xc01070d4,0xc(%esp)
c010523c:	c0 
c010523d:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0105244:	c0 
c0105245:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c010524c:	00 
c010524d:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0105254:	e8 d8 b1 ff ff       	call   c0100431 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105259:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010525c:	83 c0 04             	add    $0x4,%eax
c010525f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105266:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105269:	8b 45 90             	mov    -0x70(%ebp),%eax
c010526c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010526f:	0f a3 10             	bt     %edx,(%eax)
c0105272:	19 c0                	sbb    %eax,%eax
c0105274:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105277:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010527b:	0f 95 c0             	setne  %al
c010527e:	0f b6 c0             	movzbl %al,%eax
c0105281:	85 c0                	test   %eax,%eax
c0105283:	74 0b                	je     c0105290 <default_check+0x421>
c0105285:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105288:	8b 40 08             	mov    0x8(%eax),%eax
c010528b:	83 f8 03             	cmp    $0x3,%eax
c010528e:	74 24                	je     c01052b4 <default_check+0x445>
c0105290:	c7 44 24 0c fc 70 10 	movl   $0xc01070fc,0xc(%esp)
c0105297:	c0 
c0105298:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010529f:	c0 
c01052a0:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01052a7:	00 
c01052a8:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01052af:	e8 7d b1 ff ff       	call   c0100431 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01052b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052bb:	e8 6f da ff ff       	call   c0102d2f <alloc_pages>
c01052c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052c6:	83 e8 14             	sub    $0x14,%eax
c01052c9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01052cc:	74 24                	je     c01052f2 <default_check+0x483>
c01052ce:	c7 44 24 0c 22 71 10 	movl   $0xc0107122,0xc(%esp)
c01052d5:	c0 
c01052d6:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01052dd:	c0 
c01052de:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01052e5:	00 
c01052e6:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01052ed:	e8 3f b1 ff ff       	call   c0100431 <__panic>
    free_page(p0);
c01052f2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01052f9:	00 
c01052fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052fd:	89 04 24             	mov    %eax,(%esp)
c0105300:	e8 66 da ff ff       	call   c0102d6b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0105305:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010530c:	e8 1e da ff ff       	call   c0102d2f <alloc_pages>
c0105311:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105314:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105317:	83 c0 14             	add    $0x14,%eax
c010531a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010531d:	74 24                	je     c0105343 <default_check+0x4d4>
c010531f:	c7 44 24 0c 40 71 10 	movl   $0xc0107140,0xc(%esp)
c0105326:	c0 
c0105327:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010532e:	c0 
c010532f:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105336:	00 
c0105337:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010533e:	e8 ee b0 ff ff       	call   c0100431 <__panic>

    free_pages(p0, 2);
c0105343:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010534a:	00 
c010534b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010534e:	89 04 24             	mov    %eax,(%esp)
c0105351:	e8 15 da ff ff       	call   c0102d6b <free_pages>
    free_page(p2);
c0105356:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010535d:	00 
c010535e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105361:	89 04 24             	mov    %eax,(%esp)
c0105364:	e8 02 da ff ff       	call   c0102d6b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105369:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105370:	e8 ba d9 ff ff       	call   c0102d2f <alloc_pages>
c0105375:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105378:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010537c:	75 24                	jne    c01053a2 <default_check+0x533>
c010537e:	c7 44 24 0c 60 71 10 	movl   $0xc0107160,0xc(%esp)
c0105385:	c0 
c0105386:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c010538d:	c0 
c010538e:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0105395:	00 
c0105396:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c010539d:	e8 8f b0 ff ff       	call   c0100431 <__panic>
    assert(alloc_page() == NULL);
c01053a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053a9:	e8 81 d9 ff ff       	call   c0102d2f <alloc_pages>
c01053ae:	85 c0                	test   %eax,%eax
c01053b0:	74 24                	je     c01053d6 <default_check+0x567>
c01053b2:	c7 44 24 0c be 6f 10 	movl   $0xc0106fbe,0xc(%esp)
c01053b9:	c0 
c01053ba:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01053c1:	c0 
c01053c2:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c01053c9:	00 
c01053ca:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01053d1:	e8 5b b0 ff ff       	call   c0100431 <__panic>

    assert(nr_free == 0);
c01053d6:	a1 24 cf 11 c0       	mov    0xc011cf24,%eax
c01053db:	85 c0                	test   %eax,%eax
c01053dd:	74 24                	je     c0105403 <default_check+0x594>
c01053df:	c7 44 24 0c 11 70 10 	movl   $0xc0107011,0xc(%esp)
c01053e6:	c0 
c01053e7:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01053ee:	c0 
c01053ef:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01053f6:	00 
c01053f7:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01053fe:	e8 2e b0 ff ff       	call   c0100431 <__panic>
    nr_free = nr_free_store;
c0105403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105406:	a3 24 cf 11 c0       	mov    %eax,0xc011cf24

    free_list = free_list_store;
c010540b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010540e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105411:	a3 1c cf 11 c0       	mov    %eax,0xc011cf1c
c0105416:	89 15 20 cf 11 c0    	mov    %edx,0xc011cf20
    free_pages(p0, 5);
c010541c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105423:	00 
c0105424:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105427:	89 04 24             	mov    %eax,(%esp)
c010542a:	e8 3c d9 ff ff       	call   c0102d6b <free_pages>

    le = &free_list;
c010542f:	c7 45 ec 1c cf 11 c0 	movl   $0xc011cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105436:	eb 5a                	jmp    c0105492 <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
c0105438:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010543b:	8b 40 04             	mov    0x4(%eax),%eax
c010543e:	8b 00                	mov    (%eax),%eax
c0105440:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105443:	75 0d                	jne    c0105452 <default_check+0x5e3>
c0105445:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105448:	8b 00                	mov    (%eax),%eax
c010544a:	8b 40 04             	mov    0x4(%eax),%eax
c010544d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105450:	74 24                	je     c0105476 <default_check+0x607>
c0105452:	c7 44 24 0c 80 71 10 	movl   $0xc0107180,0xc(%esp)
c0105459:	c0 
c010545a:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c0105461:	c0 
c0105462:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0105469:	00 
c010546a:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c0105471:	e8 bb af ff ff       	call   c0100431 <__panic>
        struct Page *p = le2page(le, page_link);
c0105476:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105479:	83 e8 0c             	sub    $0xc,%eax
c010547c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c010547f:	ff 4d f4             	decl   -0xc(%ebp)
c0105482:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105485:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105488:	8b 40 08             	mov    0x8(%eax),%eax
c010548b:	29 c2                	sub    %eax,%edx
c010548d:	89 d0                	mov    %edx,%eax
c010548f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105495:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105498:	8b 45 88             	mov    -0x78(%ebp),%eax
c010549b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010549e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054a1:	81 7d ec 1c cf 11 c0 	cmpl   $0xc011cf1c,-0x14(%ebp)
c01054a8:	75 8e                	jne    c0105438 <default_check+0x5c9>
    }
    assert(count == 0);
c01054aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01054ae:	74 24                	je     c01054d4 <default_check+0x665>
c01054b0:	c7 44 24 0c ad 71 10 	movl   $0xc01071ad,0xc(%esp)
c01054b7:	c0 
c01054b8:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01054bf:	c0 
c01054c0:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01054c7:	00 
c01054c8:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01054cf:	e8 5d af ff ff       	call   c0100431 <__panic>
    assert(total == 0);
c01054d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054d8:	74 24                	je     c01054fe <default_check+0x68f>
c01054da:	c7 44 24 0c b8 71 10 	movl   $0xc01071b8,0xc(%esp)
c01054e1:	c0 
c01054e2:	c7 44 24 08 1e 6e 10 	movl   $0xc0106e1e,0x8(%esp)
c01054e9:	c0 
c01054ea:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01054f1:	00 
c01054f2:	c7 04 24 33 6e 10 c0 	movl   $0xc0106e33,(%esp)
c01054f9:	e8 33 af ff ff       	call   c0100431 <__panic>
}
c01054fe:	90                   	nop
c01054ff:	c9                   	leave  
c0105500:	c3                   	ret    

c0105501 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105501:	f3 0f 1e fb          	endbr32 
c0105505:	55                   	push   %ebp
c0105506:	89 e5                	mov    %esp,%ebp
c0105508:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010550b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105512:	eb 03                	jmp    c0105517 <strlen+0x16>
        cnt ++;
c0105514:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105517:	8b 45 08             	mov    0x8(%ebp),%eax
c010551a:	8d 50 01             	lea    0x1(%eax),%edx
c010551d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105520:	0f b6 00             	movzbl (%eax),%eax
c0105523:	84 c0                	test   %al,%al
c0105525:	75 ed                	jne    c0105514 <strlen+0x13>
    }
    return cnt;
c0105527:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010552a:	c9                   	leave  
c010552b:	c3                   	ret    

c010552c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010552c:	f3 0f 1e fb          	endbr32 
c0105530:	55                   	push   %ebp
c0105531:	89 e5                	mov    %esp,%ebp
c0105533:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010553d:	eb 03                	jmp    c0105542 <strnlen+0x16>
        cnt ++;
c010553f:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105542:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105545:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105548:	73 10                	jae    c010555a <strnlen+0x2e>
c010554a:	8b 45 08             	mov    0x8(%ebp),%eax
c010554d:	8d 50 01             	lea    0x1(%eax),%edx
c0105550:	89 55 08             	mov    %edx,0x8(%ebp)
c0105553:	0f b6 00             	movzbl (%eax),%eax
c0105556:	84 c0                	test   %al,%al
c0105558:	75 e5                	jne    c010553f <strnlen+0x13>
    }
    return cnt;
c010555a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010555d:	c9                   	leave  
c010555e:	c3                   	ret    

c010555f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010555f:	f3 0f 1e fb          	endbr32 
c0105563:	55                   	push   %ebp
c0105564:	89 e5                	mov    %esp,%ebp
c0105566:	57                   	push   %edi
c0105567:	56                   	push   %esi
c0105568:	83 ec 20             	sub    $0x20,%esp
c010556b:	8b 45 08             	mov    0x8(%ebp),%eax
c010556e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105571:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105574:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105577:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010557a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010557d:	89 d1                	mov    %edx,%ecx
c010557f:	89 c2                	mov    %eax,%edx
c0105581:	89 ce                	mov    %ecx,%esi
c0105583:	89 d7                	mov    %edx,%edi
c0105585:	ac                   	lods   %ds:(%esi),%al
c0105586:	aa                   	stos   %al,%es:(%edi)
c0105587:	84 c0                	test   %al,%al
c0105589:	75 fa                	jne    c0105585 <strcpy+0x26>
c010558b:	89 fa                	mov    %edi,%edx
c010558d:	89 f1                	mov    %esi,%ecx
c010558f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105592:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105595:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105598:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010559b:	83 c4 20             	add    $0x20,%esp
c010559e:	5e                   	pop    %esi
c010559f:	5f                   	pop    %edi
c01055a0:	5d                   	pop    %ebp
c01055a1:	c3                   	ret    

c01055a2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01055a2:	f3 0f 1e fb          	endbr32 
c01055a6:	55                   	push   %ebp
c01055a7:	89 e5                	mov    %esp,%ebp
c01055a9:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01055ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01055af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01055b2:	eb 1e                	jmp    c01055d2 <strncpy+0x30>
        if ((*p = *src) != '\0') {
c01055b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055b7:	0f b6 10             	movzbl (%eax),%edx
c01055ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055bd:	88 10                	mov    %dl,(%eax)
c01055bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055c2:	0f b6 00             	movzbl (%eax),%eax
c01055c5:	84 c0                	test   %al,%al
c01055c7:	74 03                	je     c01055cc <strncpy+0x2a>
            src ++;
c01055c9:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01055cc:	ff 45 fc             	incl   -0x4(%ebp)
c01055cf:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01055d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055d6:	75 dc                	jne    c01055b4 <strncpy+0x12>
    }
    return dst;
c01055d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055db:	c9                   	leave  
c01055dc:	c3                   	ret    

c01055dd <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01055dd:	f3 0f 1e fb          	endbr32 
c01055e1:	55                   	push   %ebp
c01055e2:	89 e5                	mov    %esp,%ebp
c01055e4:	57                   	push   %edi
c01055e5:	56                   	push   %esi
c01055e6:	83 ec 20             	sub    $0x20,%esp
c01055e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01055f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055fb:	89 d1                	mov    %edx,%ecx
c01055fd:	89 c2                	mov    %eax,%edx
c01055ff:	89 ce                	mov    %ecx,%esi
c0105601:	89 d7                	mov    %edx,%edi
c0105603:	ac                   	lods   %ds:(%esi),%al
c0105604:	ae                   	scas   %es:(%edi),%al
c0105605:	75 08                	jne    c010560f <strcmp+0x32>
c0105607:	84 c0                	test   %al,%al
c0105609:	75 f8                	jne    c0105603 <strcmp+0x26>
c010560b:	31 c0                	xor    %eax,%eax
c010560d:	eb 04                	jmp    c0105613 <strcmp+0x36>
c010560f:	19 c0                	sbb    %eax,%eax
c0105611:	0c 01                	or     $0x1,%al
c0105613:	89 fa                	mov    %edi,%edx
c0105615:	89 f1                	mov    %esi,%ecx
c0105617:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010561a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010561d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105620:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105623:	83 c4 20             	add    $0x20,%esp
c0105626:	5e                   	pop    %esi
c0105627:	5f                   	pop    %edi
c0105628:	5d                   	pop    %ebp
c0105629:	c3                   	ret    

c010562a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010562a:	f3 0f 1e fb          	endbr32 
c010562e:	55                   	push   %ebp
c010562f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105631:	eb 09                	jmp    c010563c <strncmp+0x12>
        n --, s1 ++, s2 ++;
c0105633:	ff 4d 10             	decl   0x10(%ebp)
c0105636:	ff 45 08             	incl   0x8(%ebp)
c0105639:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010563c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105640:	74 1a                	je     c010565c <strncmp+0x32>
c0105642:	8b 45 08             	mov    0x8(%ebp),%eax
c0105645:	0f b6 00             	movzbl (%eax),%eax
c0105648:	84 c0                	test   %al,%al
c010564a:	74 10                	je     c010565c <strncmp+0x32>
c010564c:	8b 45 08             	mov    0x8(%ebp),%eax
c010564f:	0f b6 10             	movzbl (%eax),%edx
c0105652:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105655:	0f b6 00             	movzbl (%eax),%eax
c0105658:	38 c2                	cmp    %al,%dl
c010565a:	74 d7                	je     c0105633 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010565c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105660:	74 18                	je     c010567a <strncmp+0x50>
c0105662:	8b 45 08             	mov    0x8(%ebp),%eax
c0105665:	0f b6 00             	movzbl (%eax),%eax
c0105668:	0f b6 d0             	movzbl %al,%edx
c010566b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566e:	0f b6 00             	movzbl (%eax),%eax
c0105671:	0f b6 c0             	movzbl %al,%eax
c0105674:	29 c2                	sub    %eax,%edx
c0105676:	89 d0                	mov    %edx,%eax
c0105678:	eb 05                	jmp    c010567f <strncmp+0x55>
c010567a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010567f:	5d                   	pop    %ebp
c0105680:	c3                   	ret    

c0105681 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105681:	f3 0f 1e fb          	endbr32 
c0105685:	55                   	push   %ebp
c0105686:	89 e5                	mov    %esp,%ebp
c0105688:	83 ec 04             	sub    $0x4,%esp
c010568b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010568e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105691:	eb 13                	jmp    c01056a6 <strchr+0x25>
        if (*s == c) {
c0105693:	8b 45 08             	mov    0x8(%ebp),%eax
c0105696:	0f b6 00             	movzbl (%eax),%eax
c0105699:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010569c:	75 05                	jne    c01056a3 <strchr+0x22>
            return (char *)s;
c010569e:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a1:	eb 12                	jmp    c01056b5 <strchr+0x34>
        }
        s ++;
c01056a3:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01056a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a9:	0f b6 00             	movzbl (%eax),%eax
c01056ac:	84 c0                	test   %al,%al
c01056ae:	75 e3                	jne    c0105693 <strchr+0x12>
    }
    return NULL;
c01056b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056b5:	c9                   	leave  
c01056b6:	c3                   	ret    

c01056b7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01056b7:	f3 0f 1e fb          	endbr32 
c01056bb:	55                   	push   %ebp
c01056bc:	89 e5                	mov    %esp,%ebp
c01056be:	83 ec 04             	sub    $0x4,%esp
c01056c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056c4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01056c7:	eb 0e                	jmp    c01056d7 <strfind+0x20>
        if (*s == c) {
c01056c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056cc:	0f b6 00             	movzbl (%eax),%eax
c01056cf:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01056d2:	74 0f                	je     c01056e3 <strfind+0x2c>
            break;
        }
        s ++;
c01056d4:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01056d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056da:	0f b6 00             	movzbl (%eax),%eax
c01056dd:	84 c0                	test   %al,%al
c01056df:	75 e8                	jne    c01056c9 <strfind+0x12>
c01056e1:	eb 01                	jmp    c01056e4 <strfind+0x2d>
            break;
c01056e3:	90                   	nop
    }
    return (char *)s;
c01056e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01056e7:	c9                   	leave  
c01056e8:	c3                   	ret    

c01056e9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01056e9:	f3 0f 1e fb          	endbr32 
c01056ed:	55                   	push   %ebp
c01056ee:	89 e5                	mov    %esp,%ebp
c01056f0:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01056f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01056fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105701:	eb 03                	jmp    c0105706 <strtol+0x1d>
        s ++;
c0105703:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105706:	8b 45 08             	mov    0x8(%ebp),%eax
c0105709:	0f b6 00             	movzbl (%eax),%eax
c010570c:	3c 20                	cmp    $0x20,%al
c010570e:	74 f3                	je     c0105703 <strtol+0x1a>
c0105710:	8b 45 08             	mov    0x8(%ebp),%eax
c0105713:	0f b6 00             	movzbl (%eax),%eax
c0105716:	3c 09                	cmp    $0x9,%al
c0105718:	74 e9                	je     c0105703 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
c010571a:	8b 45 08             	mov    0x8(%ebp),%eax
c010571d:	0f b6 00             	movzbl (%eax),%eax
c0105720:	3c 2b                	cmp    $0x2b,%al
c0105722:	75 05                	jne    c0105729 <strtol+0x40>
        s ++;
c0105724:	ff 45 08             	incl   0x8(%ebp)
c0105727:	eb 14                	jmp    c010573d <strtol+0x54>
    }
    else if (*s == '-') {
c0105729:	8b 45 08             	mov    0x8(%ebp),%eax
c010572c:	0f b6 00             	movzbl (%eax),%eax
c010572f:	3c 2d                	cmp    $0x2d,%al
c0105731:	75 0a                	jne    c010573d <strtol+0x54>
        s ++, neg = 1;
c0105733:	ff 45 08             	incl   0x8(%ebp)
c0105736:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010573d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105741:	74 06                	je     c0105749 <strtol+0x60>
c0105743:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105747:	75 22                	jne    c010576b <strtol+0x82>
c0105749:	8b 45 08             	mov    0x8(%ebp),%eax
c010574c:	0f b6 00             	movzbl (%eax),%eax
c010574f:	3c 30                	cmp    $0x30,%al
c0105751:	75 18                	jne    c010576b <strtol+0x82>
c0105753:	8b 45 08             	mov    0x8(%ebp),%eax
c0105756:	40                   	inc    %eax
c0105757:	0f b6 00             	movzbl (%eax),%eax
c010575a:	3c 78                	cmp    $0x78,%al
c010575c:	75 0d                	jne    c010576b <strtol+0x82>
        s += 2, base = 16;
c010575e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105762:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105769:	eb 29                	jmp    c0105794 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
c010576b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010576f:	75 16                	jne    c0105787 <strtol+0x9e>
c0105771:	8b 45 08             	mov    0x8(%ebp),%eax
c0105774:	0f b6 00             	movzbl (%eax),%eax
c0105777:	3c 30                	cmp    $0x30,%al
c0105779:	75 0c                	jne    c0105787 <strtol+0x9e>
        s ++, base = 8;
c010577b:	ff 45 08             	incl   0x8(%ebp)
c010577e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105785:	eb 0d                	jmp    c0105794 <strtol+0xab>
    }
    else if (base == 0) {
c0105787:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010578b:	75 07                	jne    c0105794 <strtol+0xab>
        base = 10;
c010578d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105794:	8b 45 08             	mov    0x8(%ebp),%eax
c0105797:	0f b6 00             	movzbl (%eax),%eax
c010579a:	3c 2f                	cmp    $0x2f,%al
c010579c:	7e 1b                	jle    c01057b9 <strtol+0xd0>
c010579e:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a1:	0f b6 00             	movzbl (%eax),%eax
c01057a4:	3c 39                	cmp    $0x39,%al
c01057a6:	7f 11                	jg     c01057b9 <strtol+0xd0>
            dig = *s - '0';
c01057a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ab:	0f b6 00             	movzbl (%eax),%eax
c01057ae:	0f be c0             	movsbl %al,%eax
c01057b1:	83 e8 30             	sub    $0x30,%eax
c01057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057b7:	eb 48                	jmp    c0105801 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01057b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bc:	0f b6 00             	movzbl (%eax),%eax
c01057bf:	3c 60                	cmp    $0x60,%al
c01057c1:	7e 1b                	jle    c01057de <strtol+0xf5>
c01057c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c6:	0f b6 00             	movzbl (%eax),%eax
c01057c9:	3c 7a                	cmp    $0x7a,%al
c01057cb:	7f 11                	jg     c01057de <strtol+0xf5>
            dig = *s - 'a' + 10;
c01057cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d0:	0f b6 00             	movzbl (%eax),%eax
c01057d3:	0f be c0             	movsbl %al,%eax
c01057d6:	83 e8 57             	sub    $0x57,%eax
c01057d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057dc:	eb 23                	jmp    c0105801 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01057de:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e1:	0f b6 00             	movzbl (%eax),%eax
c01057e4:	3c 40                	cmp    $0x40,%al
c01057e6:	7e 3b                	jle    c0105823 <strtol+0x13a>
c01057e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057eb:	0f b6 00             	movzbl (%eax),%eax
c01057ee:	3c 5a                	cmp    $0x5a,%al
c01057f0:	7f 31                	jg     c0105823 <strtol+0x13a>
            dig = *s - 'A' + 10;
c01057f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f5:	0f b6 00             	movzbl (%eax),%eax
c01057f8:	0f be c0             	movsbl %al,%eax
c01057fb:	83 e8 37             	sub    $0x37,%eax
c01057fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105804:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105807:	7d 19                	jge    c0105822 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
c0105809:	ff 45 08             	incl   0x8(%ebp)
c010580c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010580f:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105813:	89 c2                	mov    %eax,%edx
c0105815:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105818:	01 d0                	add    %edx,%eax
c010581a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c010581d:	e9 72 ff ff ff       	jmp    c0105794 <strtol+0xab>
            break;
c0105822:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105827:	74 08                	je     c0105831 <strtol+0x148>
        *endptr = (char *) s;
c0105829:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582c:	8b 55 08             	mov    0x8(%ebp),%edx
c010582f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105831:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105835:	74 07                	je     c010583e <strtol+0x155>
c0105837:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010583a:	f7 d8                	neg    %eax
c010583c:	eb 03                	jmp    c0105841 <strtol+0x158>
c010583e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105841:	c9                   	leave  
c0105842:	c3                   	ret    

c0105843 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105843:	f3 0f 1e fb          	endbr32 
c0105847:	55                   	push   %ebp
c0105848:	89 e5                	mov    %esp,%ebp
c010584a:	57                   	push   %edi
c010584b:	83 ec 24             	sub    $0x24,%esp
c010584e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105851:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105854:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105858:	8b 45 08             	mov    0x8(%ebp),%eax
c010585b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010585e:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105861:	8b 45 10             	mov    0x10(%ebp),%eax
c0105864:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105867:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010586a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010586e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105871:	89 d7                	mov    %edx,%edi
c0105873:	f3 aa                	rep stos %al,%es:(%edi)
c0105875:	89 fa                	mov    %edi,%edx
c0105877:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010587a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010587d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105880:	83 c4 24             	add    $0x24,%esp
c0105883:	5f                   	pop    %edi
c0105884:	5d                   	pop    %ebp
c0105885:	c3                   	ret    

c0105886 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105886:	f3 0f 1e fb          	endbr32 
c010588a:	55                   	push   %ebp
c010588b:	89 e5                	mov    %esp,%ebp
c010588d:	57                   	push   %edi
c010588e:	56                   	push   %esi
c010588f:	53                   	push   %ebx
c0105890:	83 ec 30             	sub    $0x30,%esp
c0105893:	8b 45 08             	mov    0x8(%ebp),%eax
c0105896:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105899:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010589f:	8b 45 10             	mov    0x10(%ebp),%eax
c01058a2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01058a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01058ab:	73 42                	jae    c01058ef <memmove+0x69>
c01058ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01058bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058c2:	c1 e8 02             	shr    $0x2,%eax
c01058c5:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01058c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058cd:	89 d7                	mov    %edx,%edi
c01058cf:	89 c6                	mov    %eax,%esi
c01058d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01058d3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01058d6:	83 e1 03             	and    $0x3,%ecx
c01058d9:	74 02                	je     c01058dd <memmove+0x57>
c01058db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01058dd:	89 f0                	mov    %esi,%eax
c01058df:	89 fa                	mov    %edi,%edx
c01058e1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01058e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01058e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01058ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c01058ed:	eb 36                	jmp    c0105925 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01058ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058f2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058f8:	01 c2                	add    %eax,%edx
c01058fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058fd:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105900:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105903:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105906:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105909:	89 c1                	mov    %eax,%ecx
c010590b:	89 d8                	mov    %ebx,%eax
c010590d:	89 d6                	mov    %edx,%esi
c010590f:	89 c7                	mov    %eax,%edi
c0105911:	fd                   	std    
c0105912:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105914:	fc                   	cld    
c0105915:	89 f8                	mov    %edi,%eax
c0105917:	89 f2                	mov    %esi,%edx
c0105919:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010591c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010591f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105922:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105925:	83 c4 30             	add    $0x30,%esp
c0105928:	5b                   	pop    %ebx
c0105929:	5e                   	pop    %esi
c010592a:	5f                   	pop    %edi
c010592b:	5d                   	pop    %ebp
c010592c:	c3                   	ret    

c010592d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010592d:	f3 0f 1e fb          	endbr32 
c0105931:	55                   	push   %ebp
c0105932:	89 e5                	mov    %esp,%ebp
c0105934:	57                   	push   %edi
c0105935:	56                   	push   %esi
c0105936:	83 ec 20             	sub    $0x20,%esp
c0105939:	8b 45 08             	mov    0x8(%ebp),%eax
c010593c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010593f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105942:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105945:	8b 45 10             	mov    0x10(%ebp),%eax
c0105948:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010594b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010594e:	c1 e8 02             	shr    $0x2,%eax
c0105951:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105953:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105956:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105959:	89 d7                	mov    %edx,%edi
c010595b:	89 c6                	mov    %eax,%esi
c010595d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010595f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105962:	83 e1 03             	and    $0x3,%ecx
c0105965:	74 02                	je     c0105969 <memcpy+0x3c>
c0105967:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105969:	89 f0                	mov    %esi,%eax
c010596b:	89 fa                	mov    %edi,%edx
c010596d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105970:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105973:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105976:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105979:	83 c4 20             	add    $0x20,%esp
c010597c:	5e                   	pop    %esi
c010597d:	5f                   	pop    %edi
c010597e:	5d                   	pop    %ebp
c010597f:	c3                   	ret    

c0105980 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105980:	f3 0f 1e fb          	endbr32 
c0105984:	55                   	push   %ebp
c0105985:	89 e5                	mov    %esp,%ebp
c0105987:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010598a:	8b 45 08             	mov    0x8(%ebp),%eax
c010598d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105990:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105993:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105996:	eb 2e                	jmp    c01059c6 <memcmp+0x46>
        if (*s1 != *s2) {
c0105998:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010599b:	0f b6 10             	movzbl (%eax),%edx
c010599e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059a1:	0f b6 00             	movzbl (%eax),%eax
c01059a4:	38 c2                	cmp    %al,%dl
c01059a6:	74 18                	je     c01059c0 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01059a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059ab:	0f b6 00             	movzbl (%eax),%eax
c01059ae:	0f b6 d0             	movzbl %al,%edx
c01059b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059b4:	0f b6 00             	movzbl (%eax),%eax
c01059b7:	0f b6 c0             	movzbl %al,%eax
c01059ba:	29 c2                	sub    %eax,%edx
c01059bc:	89 d0                	mov    %edx,%eax
c01059be:	eb 18                	jmp    c01059d8 <memcmp+0x58>
        }
        s1 ++, s2 ++;
c01059c0:	ff 45 fc             	incl   -0x4(%ebp)
c01059c3:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c01059c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059cc:	89 55 10             	mov    %edx,0x10(%ebp)
c01059cf:	85 c0                	test   %eax,%eax
c01059d1:	75 c5                	jne    c0105998 <memcmp+0x18>
    }
    return 0;
c01059d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059d8:	c9                   	leave  
c01059d9:	c3                   	ret    

c01059da <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01059da:	f3 0f 1e fb          	endbr32 
c01059de:	55                   	push   %ebp
c01059df:	89 e5                	mov    %esp,%ebp
c01059e1:	83 ec 58             	sub    $0x58,%esp
c01059e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01059ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01059ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01059f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01059f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01059f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01059fc:	8b 45 18             	mov    0x18(%ebp),%eax
c01059ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105a0b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a18:	74 1c                	je     c0105a36 <printnum+0x5c>
c0105a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a1d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105a22:	f7 75 e4             	divl   -0x1c(%ebp)
c0105a25:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a2b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105a30:	f7 75 e4             	divl   -0x1c(%ebp)
c0105a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a36:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a39:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a3c:	f7 75 e4             	divl   -0x1c(%ebp)
c0105a3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105a42:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a48:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a4e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105a51:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a54:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105a57:	8b 45 18             	mov    0x18(%ebp),%eax
c0105a5a:	ba 00 00 00 00       	mov    $0x0,%edx
c0105a5f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105a62:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105a65:	19 d1                	sbb    %edx,%ecx
c0105a67:	72 4c                	jb     c0105ab5 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105a69:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105a6c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a6f:	8b 45 20             	mov    0x20(%ebp),%eax
c0105a72:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105a76:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105a7a:	8b 45 18             	mov    0x18(%ebp),%eax
c0105a7d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a84:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a87:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a8b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a99:	89 04 24             	mov    %eax,(%esp)
c0105a9c:	e8 39 ff ff ff       	call   c01059da <printnum>
c0105aa1:	eb 1b                	jmp    c0105abe <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aaa:	8b 45 20             	mov    0x20(%ebp),%eax
c0105aad:	89 04 24             	mov    %eax,(%esp)
c0105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab3:	ff d0                	call   *%eax
        while (-- width > 0)
c0105ab5:	ff 4d 1c             	decl   0x1c(%ebp)
c0105ab8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105abc:	7f e5                	jg     c0105aa3 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105abe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105ac1:	05 74 72 10 c0       	add    $0xc0107274,%eax
c0105ac6:	0f b6 00             	movzbl (%eax),%eax
c0105ac9:	0f be c0             	movsbl %al,%eax
c0105acc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105acf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ad3:	89 04 24             	mov    %eax,(%esp)
c0105ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad9:	ff d0                	call   *%eax
}
c0105adb:	90                   	nop
c0105adc:	c9                   	leave  
c0105add:	c3                   	ret    

c0105ade <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105ade:	f3 0f 1e fb          	endbr32 
c0105ae2:	55                   	push   %ebp
c0105ae3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105ae9:	7e 14                	jle    c0105aff <getuint+0x21>
        return va_arg(*ap, unsigned long long);
c0105aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aee:	8b 00                	mov    (%eax),%eax
c0105af0:	8d 48 08             	lea    0x8(%eax),%ecx
c0105af3:	8b 55 08             	mov    0x8(%ebp),%edx
c0105af6:	89 0a                	mov    %ecx,(%edx)
c0105af8:	8b 50 04             	mov    0x4(%eax),%edx
c0105afb:	8b 00                	mov    (%eax),%eax
c0105afd:	eb 30                	jmp    c0105b2f <getuint+0x51>
    }
    else if (lflag) {
c0105aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b03:	74 16                	je     c0105b1b <getuint+0x3d>
        return va_arg(*ap, unsigned long);
c0105b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b08:	8b 00                	mov    (%eax),%eax
c0105b0a:	8d 48 04             	lea    0x4(%eax),%ecx
c0105b0d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b10:	89 0a                	mov    %ecx,(%edx)
c0105b12:	8b 00                	mov    (%eax),%eax
c0105b14:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b19:	eb 14                	jmp    c0105b2f <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1e:	8b 00                	mov    (%eax),%eax
c0105b20:	8d 48 04             	lea    0x4(%eax),%ecx
c0105b23:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b26:	89 0a                	mov    %ecx,(%edx)
c0105b28:	8b 00                	mov    (%eax),%eax
c0105b2a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105b2f:	5d                   	pop    %ebp
c0105b30:	c3                   	ret    

c0105b31 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105b31:	f3 0f 1e fb          	endbr32 
c0105b35:	55                   	push   %ebp
c0105b36:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105b38:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105b3c:	7e 14                	jle    c0105b52 <getint+0x21>
        return va_arg(*ap, long long);
c0105b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b41:	8b 00                	mov    (%eax),%eax
c0105b43:	8d 48 08             	lea    0x8(%eax),%ecx
c0105b46:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b49:	89 0a                	mov    %ecx,(%edx)
c0105b4b:	8b 50 04             	mov    0x4(%eax),%edx
c0105b4e:	8b 00                	mov    (%eax),%eax
c0105b50:	eb 28                	jmp    c0105b7a <getint+0x49>
    }
    else if (lflag) {
c0105b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b56:	74 12                	je     c0105b6a <getint+0x39>
        return va_arg(*ap, long);
c0105b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5b:	8b 00                	mov    (%eax),%eax
c0105b5d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105b60:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b63:	89 0a                	mov    %ecx,(%edx)
c0105b65:	8b 00                	mov    (%eax),%eax
c0105b67:	99                   	cltd   
c0105b68:	eb 10                	jmp    c0105b7a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
c0105b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6d:	8b 00                	mov    (%eax),%eax
c0105b6f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105b72:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b75:	89 0a                	mov    %ecx,(%edx)
c0105b77:	8b 00                	mov    (%eax),%eax
c0105b79:	99                   	cltd   
    }
}
c0105b7a:	5d                   	pop    %ebp
c0105b7b:	c3                   	ret    

c0105b7c <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105b7c:	f3 0f 1e fb          	endbr32 
c0105b80:	55                   	push   %ebp
c0105b81:	89 e5                	mov    %esp,%ebp
c0105b83:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105b86:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b93:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b96:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba4:	89 04 24             	mov    %eax,(%esp)
c0105ba7:	e8 03 00 00 00       	call   c0105baf <vprintfmt>
    va_end(ap);
}
c0105bac:	90                   	nop
c0105bad:	c9                   	leave  
c0105bae:	c3                   	ret    

c0105baf <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105baf:	f3 0f 1e fb          	endbr32 
c0105bb3:	55                   	push   %ebp
c0105bb4:	89 e5                	mov    %esp,%ebp
c0105bb6:	56                   	push   %esi
c0105bb7:	53                   	push   %ebx
c0105bb8:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105bbb:	eb 17                	jmp    c0105bd4 <vprintfmt+0x25>
            if (ch == '\0') {
c0105bbd:	85 db                	test   %ebx,%ebx
c0105bbf:	0f 84 c0 03 00 00    	je     c0105f85 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
c0105bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bcc:	89 1c 24             	mov    %ebx,(%esp)
c0105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd2:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105bd4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bd7:	8d 50 01             	lea    0x1(%eax),%edx
c0105bda:	89 55 10             	mov    %edx,0x10(%ebp)
c0105bdd:	0f b6 00             	movzbl (%eax),%eax
c0105be0:	0f b6 d8             	movzbl %al,%ebx
c0105be3:	83 fb 25             	cmp    $0x25,%ebx
c0105be6:	75 d5                	jne    c0105bbd <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105bf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105c00:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c03:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105c06:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c09:	8d 50 01             	lea    0x1(%eax),%edx
c0105c0c:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c0f:	0f b6 00             	movzbl (%eax),%eax
c0105c12:	0f b6 d8             	movzbl %al,%ebx
c0105c15:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105c18:	83 f8 55             	cmp    $0x55,%eax
c0105c1b:	0f 87 38 03 00 00    	ja     c0105f59 <vprintfmt+0x3aa>
c0105c21:	8b 04 85 98 72 10 c0 	mov    -0x3fef8d68(,%eax,4),%eax
c0105c28:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105c2f:	eb d5                	jmp    c0105c06 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105c35:	eb cf                	jmp    c0105c06 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105c37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105c3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c41:	89 d0                	mov    %edx,%eax
c0105c43:	c1 e0 02             	shl    $0x2,%eax
c0105c46:	01 d0                	add    %edx,%eax
c0105c48:	01 c0                	add    %eax,%eax
c0105c4a:	01 d8                	add    %ebx,%eax
c0105c4c:	83 e8 30             	sub    $0x30,%eax
c0105c4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105c52:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c55:	0f b6 00             	movzbl (%eax),%eax
c0105c58:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105c5b:	83 fb 2f             	cmp    $0x2f,%ebx
c0105c5e:	7e 38                	jle    c0105c98 <vprintfmt+0xe9>
c0105c60:	83 fb 39             	cmp    $0x39,%ebx
c0105c63:	7f 33                	jg     c0105c98 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
c0105c65:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105c68:	eb d4                	jmp    c0105c3e <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105c6a:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c6d:	8d 50 04             	lea    0x4(%eax),%edx
c0105c70:	89 55 14             	mov    %edx,0x14(%ebp)
c0105c73:	8b 00                	mov    (%eax),%eax
c0105c75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105c78:	eb 1f                	jmp    c0105c99 <vprintfmt+0xea>

        case '.':
            if (width < 0)
c0105c7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c7e:	79 86                	jns    c0105c06 <vprintfmt+0x57>
                width = 0;
c0105c80:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105c87:	e9 7a ff ff ff       	jmp    c0105c06 <vprintfmt+0x57>

        case '#':
            altflag = 1;
c0105c8c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105c93:	e9 6e ff ff ff       	jmp    c0105c06 <vprintfmt+0x57>
            goto process_precision;
c0105c98:	90                   	nop

        process_precision:
            if (width < 0)
c0105c99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c9d:	0f 89 63 ff ff ff    	jns    c0105c06 <vprintfmt+0x57>
                width = precision, precision = -1;
c0105ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ca6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ca9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105cb0:	e9 51 ff ff ff       	jmp    c0105c06 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105cb5:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105cb8:	e9 49 ff ff ff       	jmp    c0105c06 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105cbd:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cc0:	8d 50 04             	lea    0x4(%eax),%edx
c0105cc3:	89 55 14             	mov    %edx,0x14(%ebp)
c0105cc6:	8b 00                	mov    (%eax),%eax
c0105cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ccb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ccf:	89 04 24             	mov    %eax,(%esp)
c0105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd5:	ff d0                	call   *%eax
            break;
c0105cd7:	e9 a4 02 00 00       	jmp    c0105f80 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105cdc:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cdf:	8d 50 04             	lea    0x4(%eax),%edx
c0105ce2:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ce5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105ce7:	85 db                	test   %ebx,%ebx
c0105ce9:	79 02                	jns    c0105ced <vprintfmt+0x13e>
                err = -err;
c0105ceb:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105ced:	83 fb 06             	cmp    $0x6,%ebx
c0105cf0:	7f 0b                	jg     c0105cfd <vprintfmt+0x14e>
c0105cf2:	8b 34 9d 58 72 10 c0 	mov    -0x3fef8da8(,%ebx,4),%esi
c0105cf9:	85 f6                	test   %esi,%esi
c0105cfb:	75 23                	jne    c0105d20 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
c0105cfd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d01:	c7 44 24 08 85 72 10 	movl   $0xc0107285,0x8(%esp)
c0105d08:	c0 
c0105d09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d13:	89 04 24             	mov    %eax,(%esp)
c0105d16:	e8 61 fe ff ff       	call   c0105b7c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105d1b:	e9 60 02 00 00       	jmp    c0105f80 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
c0105d20:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105d24:	c7 44 24 08 8e 72 10 	movl   $0xc010728e,0x8(%esp)
c0105d2b:	c0 
c0105d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d36:	89 04 24             	mov    %eax,(%esp)
c0105d39:	e8 3e fe ff ff       	call   c0105b7c <printfmt>
            break;
c0105d3e:	e9 3d 02 00 00       	jmp    c0105f80 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105d43:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d46:	8d 50 04             	lea    0x4(%eax),%edx
c0105d49:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d4c:	8b 30                	mov    (%eax),%esi
c0105d4e:	85 f6                	test   %esi,%esi
c0105d50:	75 05                	jne    c0105d57 <vprintfmt+0x1a8>
                p = "(null)";
c0105d52:	be 91 72 10 c0       	mov    $0xc0107291,%esi
            }
            if (width > 0 && padc != '-') {
c0105d57:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105d5b:	7e 76                	jle    c0105dd3 <vprintfmt+0x224>
c0105d5d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105d61:	74 70                	je     c0105dd3 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d6a:	89 34 24             	mov    %esi,(%esp)
c0105d6d:	e8 ba f7 ff ff       	call   c010552c <strnlen>
c0105d72:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105d75:	29 c2                	sub    %eax,%edx
c0105d77:	89 d0                	mov    %edx,%eax
c0105d79:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d7c:	eb 16                	jmp    c0105d94 <vprintfmt+0x1e5>
                    putch(padc, putdat);
c0105d7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105d82:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d85:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d89:	89 04 24             	mov    %eax,(%esp)
c0105d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105d91:	ff 4d e8             	decl   -0x18(%ebp)
c0105d94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105d98:	7f e4                	jg     c0105d7e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105d9a:	eb 37                	jmp    c0105dd3 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105d9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105da0:	74 1f                	je     c0105dc1 <vprintfmt+0x212>
c0105da2:	83 fb 1f             	cmp    $0x1f,%ebx
c0105da5:	7e 05                	jle    c0105dac <vprintfmt+0x1fd>
c0105da7:	83 fb 7e             	cmp    $0x7e,%ebx
c0105daa:	7e 15                	jle    c0105dc1 <vprintfmt+0x212>
                    putch('?', putdat);
c0105dac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105daf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105db3:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105dba:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dbd:	ff d0                	call   *%eax
c0105dbf:	eb 0f                	jmp    c0105dd0 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
c0105dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dc8:	89 1c 24             	mov    %ebx,(%esp)
c0105dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dce:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105dd0:	ff 4d e8             	decl   -0x18(%ebp)
c0105dd3:	89 f0                	mov    %esi,%eax
c0105dd5:	8d 70 01             	lea    0x1(%eax),%esi
c0105dd8:	0f b6 00             	movzbl (%eax),%eax
c0105ddb:	0f be d8             	movsbl %al,%ebx
c0105dde:	85 db                	test   %ebx,%ebx
c0105de0:	74 27                	je     c0105e09 <vprintfmt+0x25a>
c0105de2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105de6:	78 b4                	js     c0105d9c <vprintfmt+0x1ed>
c0105de8:	ff 4d e4             	decl   -0x1c(%ebp)
c0105deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105def:	79 ab                	jns    c0105d9c <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
c0105df1:	eb 16                	jmp    c0105e09 <vprintfmt+0x25a>
                putch(' ', putdat);
c0105df3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dfa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105e01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e04:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105e06:	ff 4d e8             	decl   -0x18(%ebp)
c0105e09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e0d:	7f e4                	jg     c0105df3 <vprintfmt+0x244>
            }
            break;
c0105e0f:	e9 6c 01 00 00       	jmp    c0105f80 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105e14:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e1b:	8d 45 14             	lea    0x14(%ebp),%eax
c0105e1e:	89 04 24             	mov    %eax,(%esp)
c0105e21:	e8 0b fd ff ff       	call   c0105b31 <getint>
c0105e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e32:	85 d2                	test   %edx,%edx
c0105e34:	79 26                	jns    c0105e5c <vprintfmt+0x2ad>
                putch('-', putdat);
c0105e36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e3d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e47:	ff d0                	call   *%eax
                num = -(long long)num;
c0105e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e4f:	f7 d8                	neg    %eax
c0105e51:	83 d2 00             	adc    $0x0,%edx
c0105e54:	f7 da                	neg    %edx
c0105e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e59:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105e5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105e63:	e9 a8 00 00 00       	jmp    c0105f10 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e6f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105e72:	89 04 24             	mov    %eax,(%esp)
c0105e75:	e8 64 fc ff ff       	call   c0105ade <getuint>
c0105e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105e80:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105e87:	e9 84 00 00 00       	jmp    c0105f10 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e93:	8d 45 14             	lea    0x14(%ebp),%eax
c0105e96:	89 04 24             	mov    %eax,(%esp)
c0105e99:	e8 40 fc ff ff       	call   c0105ade <getuint>
c0105e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ea1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105ea4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105eab:	eb 63                	jmp    c0105f10 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
c0105ead:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eb4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105ebb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ebe:	ff d0                	call   *%eax
            putch('x', putdat);
c0105ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ec7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed1:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105ed3:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ed6:	8d 50 04             	lea    0x4(%eax),%edx
c0105ed9:	89 55 14             	mov    %edx,0x14(%ebp)
c0105edc:	8b 00                	mov    (%eax),%eax
c0105ede:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ee1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ee8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105eef:	eb 1f                	jmp    c0105f10 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ef8:	8d 45 14             	lea    0x14(%ebp),%eax
c0105efb:	89 04 24             	mov    %eax,(%esp)
c0105efe:	e8 db fb ff ff       	call   c0105ade <getuint>
c0105f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105f09:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105f10:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f17:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105f1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105f1e:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105f22:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f30:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105f34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3e:	89 04 24             	mov    %eax,(%esp)
c0105f41:	e8 94 fa ff ff       	call   c01059da <printnum>
            break;
c0105f46:	eb 38                	jmp    c0105f80 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105f48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f4f:	89 1c 24             	mov    %ebx,(%esp)
c0105f52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f55:	ff d0                	call   *%eax
            break;
c0105f57:	eb 27                	jmp    c0105f80 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105f59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f60:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105f67:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105f6c:	ff 4d 10             	decl   0x10(%ebp)
c0105f6f:	eb 03                	jmp    c0105f74 <vprintfmt+0x3c5>
c0105f71:	ff 4d 10             	decl   0x10(%ebp)
c0105f74:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f77:	48                   	dec    %eax
c0105f78:	0f b6 00             	movzbl (%eax),%eax
c0105f7b:	3c 25                	cmp    $0x25,%al
c0105f7d:	75 f2                	jne    c0105f71 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
c0105f7f:	90                   	nop
    while (1) {
c0105f80:	e9 36 fc ff ff       	jmp    c0105bbb <vprintfmt+0xc>
                return;
c0105f85:	90                   	nop
        }
    }
}
c0105f86:	83 c4 40             	add    $0x40,%esp
c0105f89:	5b                   	pop    %ebx
c0105f8a:	5e                   	pop    %esi
c0105f8b:	5d                   	pop    %ebp
c0105f8c:	c3                   	ret    

c0105f8d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105f8d:	f3 0f 1e fb          	endbr32 
c0105f91:	55                   	push   %ebp
c0105f92:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105f94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f97:	8b 40 08             	mov    0x8(%eax),%eax
c0105f9a:	8d 50 01             	lea    0x1(%eax),%edx
c0105f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fa0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fa6:	8b 10                	mov    (%eax),%edx
c0105fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fab:	8b 40 04             	mov    0x4(%eax),%eax
c0105fae:	39 c2                	cmp    %eax,%edx
c0105fb0:	73 12                	jae    c0105fc4 <sprintputch+0x37>
        *b->buf ++ = ch;
c0105fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fb5:	8b 00                	mov    (%eax),%eax
c0105fb7:	8d 48 01             	lea    0x1(%eax),%ecx
c0105fba:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105fbd:	89 0a                	mov    %ecx,(%edx)
c0105fbf:	8b 55 08             	mov    0x8(%ebp),%edx
c0105fc2:	88 10                	mov    %dl,(%eax)
    }
}
c0105fc4:	90                   	nop
c0105fc5:	5d                   	pop    %ebp
c0105fc6:	c3                   	ret    

c0105fc7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105fc7:	f3 0f 1e fb          	endbr32 
c0105fcb:	55                   	push   %ebp
c0105fcc:	89 e5                	mov    %esp,%ebp
c0105fce:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105fd1:	8d 45 14             	lea    0x14(%ebp),%eax
c0105fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fda:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fde:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fe1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fef:	89 04 24             	mov    %eax,(%esp)
c0105ff2:	e8 08 00 00 00       	call   c0105fff <vsnprintf>
c0105ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ffd:	c9                   	leave  
c0105ffe:	c3                   	ret    

c0105fff <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105fff:	f3 0f 1e fb          	endbr32 
c0106003:	55                   	push   %ebp
c0106004:	89 e5                	mov    %esp,%ebp
c0106006:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0106009:	8b 45 08             	mov    0x8(%ebp),%eax
c010600c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010600f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106012:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106015:	8b 45 08             	mov    0x8(%ebp),%eax
c0106018:	01 d0                	add    %edx,%eax
c010601a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010601d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106024:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106028:	74 0a                	je     c0106034 <vsnprintf+0x35>
c010602a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010602d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106030:	39 c2                	cmp    %eax,%edx
c0106032:	76 07                	jbe    c010603b <vsnprintf+0x3c>
        return -E_INVAL;
c0106034:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0106039:	eb 2a                	jmp    c0106065 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010603b:	8b 45 14             	mov    0x14(%ebp),%eax
c010603e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106042:	8b 45 10             	mov    0x10(%ebp),%eax
c0106045:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106049:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010604c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106050:	c7 04 24 8d 5f 10 c0 	movl   $0xc0105f8d,(%esp)
c0106057:	e8 53 fb ff ff       	call   c0105baf <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010605c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010605f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0106062:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106065:	c9                   	leave  
c0106066:	c3                   	ret    

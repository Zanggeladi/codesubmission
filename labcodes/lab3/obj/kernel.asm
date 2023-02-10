
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 10 12 00       	mov    $0x121000,%eax
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
c0100020:	a3 00 10 12 c0       	mov    %eax,0xc0121000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
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
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 04 41 12 c0       	mov    $0xc0124104,%edx
c0100041:	b8 00 30 12 c0       	mov    $0xc0123000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 30 12 c0 	movl   $0xc0123000,(%esp)
c010005d:	e8 b2 84 00 00       	call   c0108514 <memset>

    cons_init();                // init the console
c0100062:	e8 be 1d 00 00       	call   c0101e25 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 00 8e 10 c0 	movl   $0xc0108e00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 1c 8e 10 c0 	movl   $0xc0108e1c,(%esp)
c010007c:	e8 2b 02 00 00       	call   c01002ac <cprintf>

    print_kerninfo();
c0100081:	e8 cc 08 00 00       	call   c0100952 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 98 00 00 00       	call   c0100123 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 aa 6c 00 00       	call   c0106d3a <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 f5 1e 00 00       	call   c0101f8a <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 7a 20 00 00       	call   c0102114 <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 ce 36 00 00       	call   c010376d <vmm_init>

    ide_init();                 // init ide devices
c010009f:	e8 39 0d 00 00       	call   c0100ddd <ide_init>
    swap_init();                // init swap
c01000a4:	e8 c3 40 00 00       	call   c010416c <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 1a 15 00 00       	call   c01015c8 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 11 20 00 00       	call   c01020c4 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000b3:	eb fe                	jmp    c01000b3 <kern_init+0x7d>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 9b 0c 00 00       	call   c0100d72 <mon_backtrace>
}
c01000d7:	90                   	nop
c01000d8:	c9                   	leave  
c01000d9:	c3                   	ret    

c01000da <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000da:	55                   	push   %ebp
c01000db:	89 e5                	mov    %esp,%ebp
c01000dd:	53                   	push   %ebx
c01000de:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000e7:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ed:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000f1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000f9:	89 04 24             	mov    %eax,(%esp)
c01000fc:	e8 b4 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100101:	90                   	nop
c0100102:	83 c4 14             	add    $0x14,%esp
c0100105:	5b                   	pop    %ebx
c0100106:	5d                   	pop    %ebp
c0100107:	c3                   	ret    

c0100108 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100108:	55                   	push   %ebp
c0100109:	89 e5                	mov    %esp,%ebp
c010010b:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100111:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100115:	8b 45 08             	mov    0x8(%ebp),%eax
c0100118:	89 04 24             	mov    %eax,(%esp)
c010011b:	e8 ba ff ff ff       	call   c01000da <grade_backtrace1>
}
c0100120:	90                   	nop
c0100121:	c9                   	leave  
c0100122:	c3                   	ret    

c0100123 <grade_backtrace>:

void
grade_backtrace(void) {
c0100123:	55                   	push   %ebp
c0100124:	89 e5                	mov    %esp,%ebp
c0100126:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100129:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012e:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100135:	ff 
c0100136:	89 44 24 04          	mov    %eax,0x4(%esp)
c010013a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100141:	e8 c2 ff ff ff       	call   c0100108 <grade_backtrace0>
}
c0100146:	90                   	nop
c0100147:	c9                   	leave  
c0100148:	c3                   	ret    

c0100149 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100149:	55                   	push   %ebp
c010014a:	89 e5                	mov    %esp,%ebp
c010014c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100152:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100155:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100158:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010015b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015f:	83 e0 03             	and    $0x3,%eax
c0100162:	89 c2                	mov    %eax,%edx
c0100164:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100169:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100171:	c7 04 24 21 8e 10 c0 	movl   $0xc0108e21,(%esp)
c0100178:	e8 2f 01 00 00       	call   c01002ac <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100181:	89 c2                	mov    %eax,%edx
c0100183:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 2f 8e 10 c0 	movl   $0xc0108e2f,(%esp)
c0100197:	e8 10 01 00 00       	call   c01002ac <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	89 c2                	mov    %eax,%edx
c01001a2:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001a7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001af:	c7 04 24 3d 8e 10 c0 	movl   $0xc0108e3d,(%esp)
c01001b6:	e8 f1 00 00 00       	call   c01002ac <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bf:	89 c2                	mov    %eax,%edx
c01001c1:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001c6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ce:	c7 04 24 4b 8e 10 c0 	movl   $0xc0108e4b,(%esp)
c01001d5:	e8 d2 00 00 00       	call   c01002ac <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001da:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001de:	89 c2                	mov    %eax,%edx
c01001e0:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001e5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ed:	c7 04 24 59 8e 10 c0 	movl   $0xc0108e59,(%esp)
c01001f4:	e8 b3 00 00 00       	call   c01002ac <cprintf>
    round ++;
c01001f9:	a1 00 30 12 c0       	mov    0xc0123000,%eax
c01001fe:	40                   	inc    %eax
c01001ff:	a3 00 30 12 c0       	mov    %eax,0xc0123000
}
c0100204:	90                   	nop
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
c010020a:	83 ec 08             	sub    $0x8,%esp
c010020d:	cd 78                	int    $0x78
c010020f:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
c0100211:	90                   	nop
c0100212:	5d                   	pop    %ebp
c0100213:	c3                   	ret    

c0100214 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100214:	55                   	push   %ebp
c0100215:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
c0100217:	cd 79                	int    $0x79
c0100219:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
c010021b:	90                   	nop
c010021c:	5d                   	pop    %ebp
c010021d:	c3                   	ret    

c010021e <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010021e:	55                   	push   %ebp
c010021f:	89 e5                	mov    %esp,%ebp
c0100221:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100224:	e8 20 ff ff ff       	call   c0100149 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100229:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0100230:	e8 77 00 00 00       	call   c01002ac <cprintf>
    lab1_switch_to_user();
c0100235:	e8 cd ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010023a:	e8 0a ff ff ff       	call   c0100149 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023f:	c7 04 24 88 8e 10 c0 	movl   $0xc0108e88,(%esp)
c0100246:	e8 61 00 00 00       	call   c01002ac <cprintf>
    lab1_switch_to_kernel();
c010024b:	e8 c4 ff ff ff       	call   c0100214 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100250:	e8 f4 fe ff ff       	call   c0100149 <lab1_print_cur_status>
}
c0100255:	90                   	nop
c0100256:	c9                   	leave  
c0100257:	c3                   	ret    

c0100258 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100258:	55                   	push   %ebp
c0100259:	89 e5                	mov    %esp,%ebp
c010025b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010025e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100261:	89 04 24             	mov    %eax,(%esp)
c0100264:	e8 e9 1b 00 00       	call   c0101e52 <cons_putc>
    (*cnt) ++;
c0100269:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026c:	8b 00                	mov    (%eax),%eax
c010026e:	8d 50 01             	lea    0x1(%eax),%edx
c0100271:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100274:	89 10                	mov    %edx,(%eax)
}
c0100276:	90                   	nop
c0100277:	c9                   	leave  
c0100278:	c3                   	ret    

c0100279 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100279:	55                   	push   %ebp
c010027a:	89 e5                	mov    %esp,%ebp
c010027c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010027f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100286:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100289:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010028d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100290:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100294:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100297:	89 44 24 04          	mov    %eax,0x4(%esp)
c010029b:	c7 04 24 58 02 10 c0 	movl   $0xc0100258,(%esp)
c01002a2:	e8 c0 85 00 00       	call   c0108867 <vprintfmt>
    return cnt;
c01002a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002aa:	c9                   	leave  
c01002ab:	c3                   	ret    

c01002ac <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002ac:	55                   	push   %ebp
c01002ad:	89 e5                	mov    %esp,%ebp
c01002af:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002b2:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af ff ff ff       	call   c0100279 <vcprintf>
c01002ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002d0:	c9                   	leave  
c01002d1:	c3                   	ret    

c01002d2 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002d2:	55                   	push   %ebp
c01002d3:	89 e5                	mov    %esp,%ebp
c01002d5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01002db:	89 04 24             	mov    %eax,(%esp)
c01002de:	e8 6f 1b 00 00       	call   c0101e52 <cons_putc>
}
c01002e3:	90                   	nop
c01002e4:	c9                   	leave  
c01002e5:	c3                   	ret    

c01002e6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002e6:	55                   	push   %ebp
c01002e7:	89 e5                	mov    %esp,%ebp
c01002e9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002f3:	eb 13                	jmp    c0100308 <cputs+0x22>
        cputch(c, &cnt);
c01002f5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002f9:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100300:	89 04 24             	mov    %eax,(%esp)
c0100303:	e8 50 ff ff ff       	call   c0100258 <cputch>
    while ((c = *str ++) != '\0') {
c0100308:	8b 45 08             	mov    0x8(%ebp),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100311:	0f b6 00             	movzbl (%eax),%eax
c0100314:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100317:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010031b:	75 d8                	jne    c01002f5 <cputs+0xf>
    }
    cputch('\n', &cnt);
c010031d:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100320:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100324:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010032b:	e8 28 ff ff ff       	call   c0100258 <cputch>
    return cnt;
c0100330:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100333:	c9                   	leave  
c0100334:	c3                   	ret    

c0100335 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100335:	55                   	push   %ebp
c0100336:	89 e5                	mov    %esp,%ebp
c0100338:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010033b:	e8 4f 1b 00 00       	call   c0101e8f <cons_getc>
c0100340:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100347:	74 f2                	je     c010033b <getchar+0x6>
        /* do nothing */;
    return c;
c0100349:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010034c:	c9                   	leave  
c010034d:	c3                   	ret    

c010034e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010034e:	55                   	push   %ebp
c010034f:	89 e5                	mov    %esp,%ebp
c0100351:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100354:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100358:	74 13                	je     c010036d <readline+0x1f>
        cprintf("%s", prompt);
c010035a:	8b 45 08             	mov    0x8(%ebp),%eax
c010035d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100361:	c7 04 24 a7 8e 10 c0 	movl   $0xc0108ea7,(%esp)
c0100368:	e8 3f ff ff ff       	call   c01002ac <cprintf>
    }
    int i = 0, c;
c010036d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100374:	e8 bc ff ff ff       	call   c0100335 <getchar>
c0100379:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010037c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100380:	79 07                	jns    c0100389 <readline+0x3b>
            return NULL;
c0100382:	b8 00 00 00 00       	mov    $0x0,%eax
c0100387:	eb 78                	jmp    c0100401 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100389:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010038d:	7e 28                	jle    c01003b7 <readline+0x69>
c010038f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100396:	7f 1f                	jg     c01003b7 <readline+0x69>
            cputchar(c);
c0100398:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 2f ff ff ff       	call   c01002d2 <cputchar>
            buf[i ++] = c;
c01003a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003af:	88 90 20 30 12 c0    	mov    %dl,-0x3fedcfe0(%eax)
c01003b5:	eb 45                	jmp    c01003fc <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003b7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003bb:	75 16                	jne    c01003d3 <readline+0x85>
c01003bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003c1:	7e 10                	jle    c01003d3 <readline+0x85>
            cputchar(c);
c01003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c6:	89 04 24             	mov    %eax,(%esp)
c01003c9:	e8 04 ff ff ff       	call   c01002d2 <cputchar>
            i --;
c01003ce:	ff 4d f4             	decl   -0xc(%ebp)
c01003d1:	eb 29                	jmp    c01003fc <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003d3:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003d7:	74 06                	je     c01003df <readline+0x91>
c01003d9:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003dd:	75 95                	jne    c0100374 <readline+0x26>
            cputchar(c);
c01003df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003e2:	89 04 24             	mov    %eax,(%esp)
c01003e5:	e8 e8 fe ff ff       	call   c01002d2 <cputchar>
            buf[i] = '\0';
c01003ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ed:	05 20 30 12 c0       	add    $0xc0123020,%eax
c01003f2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003f5:	b8 20 30 12 c0       	mov    $0xc0123020,%eax
c01003fa:	eb 05                	jmp    c0100401 <readline+0xb3>
        c = getchar();
c01003fc:	e9 73 ff ff ff       	jmp    c0100374 <readline+0x26>
        }
    }
}
c0100401:	c9                   	leave  
c0100402:	c3                   	ret    

c0100403 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100403:	55                   	push   %ebp
c0100404:	89 e5                	mov    %esp,%ebp
c0100406:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100409:	a1 20 34 12 c0       	mov    0xc0123420,%eax
c010040e:	85 c0                	test   %eax,%eax
c0100410:	75 5b                	jne    c010046d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100412:	c7 05 20 34 12 c0 01 	movl   $0x1,0xc0123420
c0100419:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010041c:	8d 45 14             	lea    0x14(%ebp),%eax
c010041f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100422:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100425:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100429:	8b 45 08             	mov    0x8(%ebp),%eax
c010042c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100430:	c7 04 24 aa 8e 10 c0 	movl   $0xc0108eaa,(%esp)
c0100437:	e8 70 fe ff ff       	call   c01002ac <cprintf>
    vcprintf(fmt, ap);
c010043c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010043f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100443:	8b 45 10             	mov    0x10(%ebp),%eax
c0100446:	89 04 24             	mov    %eax,(%esp)
c0100449:	e8 2b fe ff ff       	call   c0100279 <vcprintf>
    cprintf("\n");
c010044e:	c7 04 24 c6 8e 10 c0 	movl   $0xc0108ec6,(%esp)
c0100455:	e8 52 fe ff ff       	call   c01002ac <cprintf>
    
    cprintf("stack trackback:\n");
c010045a:	c7 04 24 c8 8e 10 c0 	movl   $0xc0108ec8,(%esp)
c0100461:	e8 46 fe ff ff       	call   c01002ac <cprintf>
    print_stackframe();
c0100466:	e8 32 06 00 00       	call   c0100a9d <print_stackframe>
c010046b:	eb 01                	jmp    c010046e <__panic+0x6b>
        goto panic_dead;
c010046d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c010046e:	e8 58 1c 00 00       	call   c01020cb <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100473:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010047a:	e8 26 08 00 00       	call   c0100ca5 <kmonitor>
c010047f:	eb f2                	jmp    c0100473 <__panic+0x70>

c0100481 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100481:	55                   	push   %ebp
c0100482:	89 e5                	mov    %esp,%ebp
c0100484:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100487:	8d 45 14             	lea    0x14(%ebp),%eax
c010048a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010048d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100490:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100494:	8b 45 08             	mov    0x8(%ebp),%eax
c0100497:	89 44 24 04          	mov    %eax,0x4(%esp)
c010049b:	c7 04 24 da 8e 10 c0 	movl   $0xc0108eda,(%esp)
c01004a2:	e8 05 fe ff ff       	call   c01002ac <cprintf>
    vcprintf(fmt, ap);
c01004a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b1:	89 04 24             	mov    %eax,(%esp)
c01004b4:	e8 c0 fd ff ff       	call   c0100279 <vcprintf>
    cprintf("\n");
c01004b9:	c7 04 24 c6 8e 10 c0 	movl   $0xc0108ec6,(%esp)
c01004c0:	e8 e7 fd ff ff       	call   c01002ac <cprintf>
    va_end(ap);
}
c01004c5:	90                   	nop
c01004c6:	c9                   	leave  
c01004c7:	c3                   	ret    

c01004c8 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004c8:	55                   	push   %ebp
c01004c9:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004cb:	a1 20 34 12 c0       	mov    0xc0123420,%eax
}
c01004d0:	5d                   	pop    %ebp
c01004d1:	c3                   	ret    

c01004d2 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004d2:	55                   	push   %ebp
c01004d3:	89 e5                	mov    %esp,%ebp
c01004d5:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004db:	8b 00                	mov    (%eax),%eax
c01004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e3:	8b 00                	mov    (%eax),%eax
c01004e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ef:	e9 ca 00 00 00       	jmp    c01005be <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004fa:	01 d0                	add    %edx,%eax
c01004fc:	89 c2                	mov    %eax,%edx
c01004fe:	c1 ea 1f             	shr    $0x1f,%edx
c0100501:	01 d0                	add    %edx,%eax
c0100503:	d1 f8                	sar    %eax
c0100505:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100508:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010050b:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010050e:	eb 03                	jmp    c0100513 <stab_binsearch+0x41>
            m --;
c0100510:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100513:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100516:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100519:	7c 1f                	jl     c010053a <stab_binsearch+0x68>
c010051b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010051e:	89 d0                	mov    %edx,%eax
c0100520:	01 c0                	add    %eax,%eax
c0100522:	01 d0                	add    %edx,%eax
c0100524:	c1 e0 02             	shl    $0x2,%eax
c0100527:	89 c2                	mov    %eax,%edx
c0100529:	8b 45 08             	mov    0x8(%ebp),%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100532:	0f b6 c0             	movzbl %al,%eax
c0100535:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100538:	75 d6                	jne    c0100510 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010053a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010053d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100540:	7d 09                	jge    c010054b <stab_binsearch+0x79>
            l = true_m + 1;
c0100542:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100545:	40                   	inc    %eax
c0100546:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100549:	eb 73                	jmp    c01005be <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010054b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100552:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100555:	89 d0                	mov    %edx,%eax
c0100557:	01 c0                	add    %eax,%eax
c0100559:	01 d0                	add    %edx,%eax
c010055b:	c1 e0 02             	shl    $0x2,%eax
c010055e:	89 c2                	mov    %eax,%edx
c0100560:	8b 45 08             	mov    0x8(%ebp),%eax
c0100563:	01 d0                	add    %edx,%eax
c0100565:	8b 40 08             	mov    0x8(%eax),%eax
c0100568:	39 45 18             	cmp    %eax,0x18(%ebp)
c010056b:	76 11                	jbe    c010057e <stab_binsearch+0xac>
            *region_left = m;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100573:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100575:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100578:	40                   	inc    %eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010057c:	eb 40                	jmp    c01005be <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c010057e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100581:	89 d0                	mov    %edx,%eax
c0100583:	01 c0                	add    %eax,%eax
c0100585:	01 d0                	add    %edx,%eax
c0100587:	c1 e0 02             	shl    $0x2,%eax
c010058a:	89 c2                	mov    %eax,%edx
c010058c:	8b 45 08             	mov    0x8(%ebp),%eax
c010058f:	01 d0                	add    %edx,%eax
c0100591:	8b 40 08             	mov    0x8(%eax),%eax
c0100594:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100597:	73 14                	jae    c01005ad <stab_binsearch+0xdb>
            *region_right = m - 1;
c0100599:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059f:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a7:	48                   	dec    %eax
c01005a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005ab:	eb 11                	jmp    c01005be <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b3:	89 10                	mov    %edx,(%eax)
            l = m;
c01005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005bb:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005be:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005c4:	0f 8e 2a ff ff ff    	jle    c01004f4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005ce:	75 0f                	jne    c01005df <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d3:	8b 00                	mov    (%eax),%eax
c01005d5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01005db:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005dd:	eb 3e                	jmp    c010061d <stab_binsearch+0x14b>
        l = *region_right;
c01005df:	8b 45 10             	mov    0x10(%ebp),%eax
c01005e2:	8b 00                	mov    (%eax),%eax
c01005e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e7:	eb 03                	jmp    c01005ec <stab_binsearch+0x11a>
c01005e9:	ff 4d fc             	decl   -0x4(%ebp)
c01005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ef:	8b 00                	mov    (%eax),%eax
c01005f1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005f4:	7e 1f                	jle    c0100615 <stab_binsearch+0x143>
c01005f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f9:	89 d0                	mov    %edx,%eax
c01005fb:	01 c0                	add    %eax,%eax
c01005fd:	01 d0                	add    %edx,%eax
c01005ff:	c1 e0 02             	shl    $0x2,%eax
c0100602:	89 c2                	mov    %eax,%edx
c0100604:	8b 45 08             	mov    0x8(%ebp),%eax
c0100607:	01 d0                	add    %edx,%eax
c0100609:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010060d:	0f b6 c0             	movzbl %al,%eax
c0100610:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100613:	75 d4                	jne    c01005e9 <stab_binsearch+0x117>
        *region_left = l;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010061b:	89 10                	mov    %edx,(%eax)
}
c010061d:	90                   	nop
c010061e:	c9                   	leave  
c010061f:	c3                   	ret    

c0100620 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100620:	55                   	push   %ebp
c0100621:	89 e5                	mov    %esp,%ebp
c0100623:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100629:	c7 00 f8 8e 10 c0    	movl   $0xc0108ef8,(%eax)
    info->eip_line = 0;
c010062f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063c:	c7 40 08 f8 8e 10 c0 	movl   $0xc0108ef8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100643:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100646:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010064d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100650:	8b 55 08             	mov    0x8(%ebp),%edx
c0100653:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100656:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100659:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100660:	c7 45 f4 fc ad 10 c0 	movl   $0xc010adfc,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100667:	c7 45 f0 04 a5 11 c0 	movl   $0xc011a504,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010066e:	c7 45 ec 05 a5 11 c0 	movl   $0xc011a505,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100675:	c7 45 e8 84 de 11 c0 	movl   $0xc011de84,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010067c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100682:	76 0b                	jbe    c010068f <debuginfo_eip+0x6f>
c0100684:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100687:	48                   	dec    %eax
c0100688:	0f b6 00             	movzbl (%eax),%eax
c010068b:	84 c0                	test   %al,%al
c010068d:	74 0a                	je     c0100699 <debuginfo_eip+0x79>
        return -1;
c010068f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100694:	e9 b7 02 00 00       	jmp    c0100950 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100699:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01006a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a6:	29 c2                	sub    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	c1 f8 02             	sar    $0x2,%eax
c01006ad:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b3:	48                   	dec    %eax
c01006b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ba:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006be:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c5:	00 
c01006c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d7:	89 04 24             	mov    %eax,(%esp)
c01006da:	e8 f3 fd ff ff       	call   c01004d2 <stab_binsearch>
    if (lfile == 0)
c01006df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e2:	85 c0                	test   %eax,%eax
c01006e4:	75 0a                	jne    c01006f0 <debuginfo_eip+0xd0>
        return -1;
c01006e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006eb:	e9 60 02 00 00       	jmp    c0100950 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 ae fd ff ff       	call   c01004d2 <stab_binsearch>

    if (lfun <= rfun) {
c0100724:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100727:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 7c                	jg     c01007aa <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010072e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	8b 00                	mov    (%eax),%eax
c0100745:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100748:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010074b:	29 d1                	sub    %edx,%ecx
c010074d:	89 ca                	mov    %ecx,%edx
c010074f:	39 d0                	cmp    %edx,%eax
c0100751:	73 22                	jae    c0100775 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100753:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100756:	89 c2                	mov    %eax,%edx
c0100758:	89 d0                	mov    %edx,%eax
c010075a:	01 c0                	add    %eax,%eax
c010075c:	01 d0                	add    %edx,%eax
c010075e:	c1 e0 02             	shl    $0x2,%eax
c0100761:	89 c2                	mov    %eax,%edx
c0100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100766:	01 d0                	add    %edx,%eax
c0100768:	8b 10                	mov    (%eax),%edx
c010076a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010076d:	01 c2                	add    %eax,%edx
c010076f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100772:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100775:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100778:	89 c2                	mov    %eax,%edx
c010077a:	89 d0                	mov    %edx,%eax
c010077c:	01 c0                	add    %eax,%eax
c010077e:	01 d0                	add    %edx,%eax
c0100780:	c1 e0 02             	shl    $0x2,%eax
c0100783:	89 c2                	mov    %eax,%edx
c0100785:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100788:	01 d0                	add    %edx,%eax
c010078a:	8b 50 08             	mov    0x8(%eax),%edx
c010078d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100790:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100793:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100796:	8b 40 10             	mov    0x10(%eax),%eax
c0100799:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010079c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a8:	eb 15                	jmp    c01007bf <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01007b0:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c2:	8b 40 08             	mov    0x8(%eax),%eax
c01007c5:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007cc:	00 
c01007cd:	89 04 24             	mov    %eax,(%esp)
c01007d0:	e8 bb 7b 00 00       	call   c0108390 <strfind>
c01007d5:	89 c2                	mov    %eax,%edx
c01007d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007da:	8b 40 08             	mov    0x8(%eax),%eax
c01007dd:	29 c2                	sub    %eax,%edx
c01007df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e2:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007ec:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007f3:	00 
c01007f4:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007fb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100805:	89 04 24             	mov    %eax,(%esp)
c0100808:	e8 c5 fc ff ff       	call   c01004d2 <stab_binsearch>
    if (lline <= rline) {
c010080d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100810:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100813:	39 c2                	cmp    %eax,%edx
c0100815:	7f 23                	jg     c010083a <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c0100817:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010081a:	89 c2                	mov    %eax,%edx
c010081c:	89 d0                	mov    %edx,%eax
c010081e:	01 c0                	add    %eax,%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	c1 e0 02             	shl    $0x2,%eax
c0100825:	89 c2                	mov    %eax,%edx
c0100827:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082a:	01 d0                	add    %edx,%eax
c010082c:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100830:	89 c2                	mov    %eax,%edx
c0100832:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100835:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100838:	eb 11                	jmp    c010084b <debuginfo_eip+0x22b>
        return -1;
c010083a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083f:	e9 0c 01 00 00       	jmp    c0100950 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100847:	48                   	dec    %eax
c0100848:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010084b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100851:	39 c2                	cmp    %eax,%edx
c0100853:	7c 56                	jl     c01008ab <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c0100855:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100858:	89 c2                	mov    %eax,%edx
c010085a:	89 d0                	mov    %edx,%eax
c010085c:	01 c0                	add    %eax,%eax
c010085e:	01 d0                	add    %edx,%eax
c0100860:	c1 e0 02             	shl    $0x2,%eax
c0100863:	89 c2                	mov    %eax,%edx
c0100865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100868:	01 d0                	add    %edx,%eax
c010086a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086e:	3c 84                	cmp    $0x84,%al
c0100870:	74 39                	je     c01008ab <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100872:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100875:	89 c2                	mov    %eax,%edx
c0100877:	89 d0                	mov    %edx,%eax
c0100879:	01 c0                	add    %eax,%eax
c010087b:	01 d0                	add    %edx,%eax
c010087d:	c1 e0 02             	shl    $0x2,%eax
c0100880:	89 c2                	mov    %eax,%edx
c0100882:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100885:	01 d0                	add    %edx,%eax
c0100887:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010088b:	3c 64                	cmp    $0x64,%al
c010088d:	75 b5                	jne    c0100844 <debuginfo_eip+0x224>
c010088f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100892:	89 c2                	mov    %eax,%edx
c0100894:	89 d0                	mov    %edx,%eax
c0100896:	01 c0                	add    %eax,%eax
c0100898:	01 d0                	add    %edx,%eax
c010089a:	c1 e0 02             	shl    $0x2,%eax
c010089d:	89 c2                	mov    %eax,%edx
c010089f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a2:	01 d0                	add    %edx,%eax
c01008a4:	8b 40 08             	mov    0x8(%eax),%eax
c01008a7:	85 c0                	test   %eax,%eax
c01008a9:	74 99                	je     c0100844 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008b1:	39 c2                	cmp    %eax,%edx
c01008b3:	7c 46                	jl     c01008fb <debuginfo_eip+0x2db>
c01008b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b8:	89 c2                	mov    %eax,%edx
c01008ba:	89 d0                	mov    %edx,%eax
c01008bc:	01 c0                	add    %eax,%eax
c01008be:	01 d0                	add    %edx,%eax
c01008c0:	c1 e0 02             	shl    $0x2,%eax
c01008c3:	89 c2                	mov    %eax,%edx
c01008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c8:	01 d0                	add    %edx,%eax
c01008ca:	8b 00                	mov    (%eax),%eax
c01008cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008d2:	29 d1                	sub    %edx,%ecx
c01008d4:	89 ca                	mov    %ecx,%edx
c01008d6:	39 d0                	cmp    %edx,%eax
c01008d8:	73 21                	jae    c01008fb <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008dd:	89 c2                	mov    %eax,%edx
c01008df:	89 d0                	mov    %edx,%eax
c01008e1:	01 c0                	add    %eax,%eax
c01008e3:	01 d0                	add    %edx,%eax
c01008e5:	c1 e0 02             	shl    $0x2,%eax
c01008e8:	89 c2                	mov    %eax,%edx
c01008ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ed:	01 d0                	add    %edx,%eax
c01008ef:	8b 10                	mov    (%eax),%edx
c01008f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f4:	01 c2                	add    %eax,%edx
c01008f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100901:	39 c2                	cmp    %eax,%edx
c0100903:	7d 46                	jge    c010094b <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c0100905:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100908:	40                   	inc    %eax
c0100909:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010090c:	eb 16                	jmp    c0100924 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010090e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100911:	8b 40 14             	mov    0x14(%eax),%eax
c0100914:	8d 50 01             	lea    0x1(%eax),%edx
c0100917:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c010091d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100920:	40                   	inc    %eax
c0100921:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100927:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010092a:	39 c2                	cmp    %eax,%edx
c010092c:	7d 1d                	jge    c010094b <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	89 c2                	mov    %eax,%edx
c0100933:	89 d0                	mov    %edx,%eax
c0100935:	01 c0                	add    %eax,%eax
c0100937:	01 d0                	add    %edx,%eax
c0100939:	c1 e0 02             	shl    $0x2,%eax
c010093c:	89 c2                	mov    %eax,%edx
c010093e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100941:	01 d0                	add    %edx,%eax
c0100943:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100947:	3c a0                	cmp    $0xa0,%al
c0100949:	74 c3                	je     c010090e <debuginfo_eip+0x2ee>
        }
    }
    return 0;
c010094b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100950:	c9                   	leave  
c0100951:	c3                   	ret    

c0100952 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100952:	55                   	push   %ebp
c0100953:	89 e5                	mov    %esp,%ebp
c0100955:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100958:	c7 04 24 02 8f 10 c0 	movl   $0xc0108f02,(%esp)
c010095f:	e8 48 f9 ff ff       	call   c01002ac <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100964:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010096b:	c0 
c010096c:	c7 04 24 1b 8f 10 c0 	movl   $0xc0108f1b,(%esp)
c0100973:	e8 34 f9 ff ff       	call   c01002ac <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100978:	c7 44 24 04 eb 8d 10 	movl   $0xc0108deb,0x4(%esp)
c010097f:	c0 
c0100980:	c7 04 24 33 8f 10 c0 	movl   $0xc0108f33,(%esp)
c0100987:	e8 20 f9 ff ff       	call   c01002ac <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c010098c:	c7 44 24 04 00 30 12 	movl   $0xc0123000,0x4(%esp)
c0100993:	c0 
c0100994:	c7 04 24 4b 8f 10 c0 	movl   $0xc0108f4b,(%esp)
c010099b:	e8 0c f9 ff ff       	call   c01002ac <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009a0:	c7 44 24 04 04 41 12 	movl   $0xc0124104,0x4(%esp)
c01009a7:	c0 
c01009a8:	c7 04 24 63 8f 10 c0 	movl   $0xc0108f63,(%esp)
c01009af:	e8 f8 f8 ff ff       	call   c01002ac <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009b4:	b8 04 41 12 c0       	mov    $0xc0124104,%eax
c01009b9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009bf:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009c4:	29 c2                	sub    %eax,%edx
c01009c6:	89 d0                	mov    %edx,%eax
c01009c8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ce:	85 c0                	test   %eax,%eax
c01009d0:	0f 48 c2             	cmovs  %edx,%eax
c01009d3:	c1 f8 0a             	sar    $0xa,%eax
c01009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009da:	c7 04 24 7c 8f 10 c0 	movl   $0xc0108f7c,(%esp)
c01009e1:	e8 c6 f8 ff ff       	call   c01002ac <cprintf>
}
c01009e6:	90                   	nop
c01009e7:	c9                   	leave  
c01009e8:	c3                   	ret    

c01009e9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009e9:	55                   	push   %ebp
c01009ea:	89 e5                	mov    %esp,%ebp
c01009ec:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01009fc:	89 04 24             	mov    %eax,(%esp)
c01009ff:	e8 1c fc ff ff       	call   c0100620 <debuginfo_eip>
c0100a04:	85 c0                	test   %eax,%eax
c0100a06:	74 15                	je     c0100a1d <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0f:	c7 04 24 a6 8f 10 c0 	movl   $0xc0108fa6,(%esp)
c0100a16:	e8 91 f8 ff ff       	call   c01002ac <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a1b:	eb 6c                	jmp    c0100a89 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a24:	eb 1b                	jmp    c0100a41 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2c:	01 d0                	add    %edx,%eax
c0100a2e:	0f b6 00             	movzbl (%eax),%eax
c0100a31:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a3a:	01 ca                	add    %ecx,%edx
c0100a3c:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a3e:	ff 45 f4             	incl   -0xc(%ebp)
c0100a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a44:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a47:	7c dd                	jl     c0100a26 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a49:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a52:	01 d0                	add    %edx,%eax
c0100a54:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a5a:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a5d:	89 d1                	mov    %edx,%ecx
c0100a5f:	29 c1                	sub    %eax,%ecx
c0100a61:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a67:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a6b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a71:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a75:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a7d:	c7 04 24 c2 8f 10 c0 	movl   $0xc0108fc2,(%esp)
c0100a84:	e8 23 f8 ff ff       	call   c01002ac <cprintf>
}
c0100a89:	90                   	nop
c0100a8a:	c9                   	leave  
c0100a8b:	c3                   	ret    

c0100a8c <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a8c:	55                   	push   %ebp
c0100a8d:	89 e5                	mov    %esp,%ebp
c0100a8f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a92:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a9b:	c9                   	leave  
c0100a9c:	c3                   	ret    

c0100a9d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a9d:	55                   	push   %ebp
c0100a9e:	89 e5                	mov    %esp,%ebp
c0100aa0:	53                   	push   %ebx
c0100aa1:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aa4:	89 e8                	mov    %ebp,%eax
c0100aa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
c0100aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     
    uint32_t *ebp = (uint32_t *)read_ebp();
c0100aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t esp = read_eip();
c0100aaf:	e8 d8 ff ff ff       	call   c0100a8c <read_eip>
c0100ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(ebp){
c0100ab7:	eb 73                	jmp    c0100b2c <print_stackframe+0x8f>
        cprintf("ebp:0x%08x eip:0x%08x args:",(uint32_t)ebp,esp);
c0100ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100abc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100abf:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac7:	c7 04 24 d4 8f 10 c0 	movl   $0xc0108fd4,(%esp)
c0100ace:	e8 d9 f7 ff ff       	call   c01002ac <cprintf>
        cprintf("0x%08x 0x%08x 0x%08x 0x%08x\n",ebp[2],ebp[3],ebp[4],ebp[5]);
c0100ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad6:	83 c0 14             	add    $0x14,%eax
c0100ad9:	8b 18                	mov    (%eax),%ebx
c0100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ade:	83 c0 10             	add    $0x10,%eax
c0100ae1:	8b 08                	mov    (%eax),%ecx
c0100ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae6:	83 c0 0c             	add    $0xc,%eax
c0100ae9:	8b 10                	mov    (%eax),%edx
c0100aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aee:	83 c0 08             	add    $0x8,%eax
c0100af1:	8b 00                	mov    (%eax),%eax
c0100af3:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100af7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100afb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b03:	c7 04 24 f0 8f 10 c0 	movl   $0xc0108ff0,(%esp)
c0100b0a:	e8 9d f7 ff ff       	call   c01002ac <cprintf>
        print_debuginfo(esp - 1);
c0100b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b12:	48                   	dec    %eax
c0100b13:	89 04 24             	mov    %eax,(%esp)
c0100b16:	e8 ce fe ff ff       	call   c01009e9 <print_debuginfo>
        esp = ebp[1];
c0100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1e:	8b 40 04             	mov    0x4(%eax),%eax
c0100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = (uint32_t *)*ebp;
c0100b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b27:	8b 00                	mov    (%eax),%eax
c0100b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(ebp){
c0100b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b30:	75 87                	jne    c0100ab9 <print_stackframe+0x1c>
    }
}
c0100b32:	90                   	nop
c0100b33:	83 c4 34             	add    $0x34,%esp
c0100b36:	5b                   	pop    %ebx
c0100b37:	5d                   	pop    %ebp
c0100b38:	c3                   	ret    

c0100b39 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b39:	55                   	push   %ebp
c0100b3a:	89 e5                	mov    %esp,%ebp
c0100b3c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b46:	eb 0c                	jmp    c0100b54 <parse+0x1b>
            *buf ++ = '\0';
c0100b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4b:	8d 50 01             	lea    0x1(%eax),%edx
c0100b4e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b51:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b57:	0f b6 00             	movzbl (%eax),%eax
c0100b5a:	84 c0                	test   %al,%al
c0100b5c:	74 1d                	je     c0100b7b <parse+0x42>
c0100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b61:	0f b6 00             	movzbl (%eax),%eax
c0100b64:	0f be c0             	movsbl %al,%eax
c0100b67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b6b:	c7 04 24 90 90 10 c0 	movl   $0xc0109090,(%esp)
c0100b72:	e8 e7 77 00 00       	call   c010835e <strchr>
c0100b77:	85 c0                	test   %eax,%eax
c0100b79:	75 cd                	jne    c0100b48 <parse+0xf>
        }
        if (*buf == '\0') {
c0100b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b7e:	0f b6 00             	movzbl (%eax),%eax
c0100b81:	84 c0                	test   %al,%al
c0100b83:	74 65                	je     c0100bea <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b85:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b89:	75 14                	jne    c0100b9f <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b8b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b92:	00 
c0100b93:	c7 04 24 95 90 10 c0 	movl   $0xc0109095,(%esp)
c0100b9a:	e8 0d f7 ff ff       	call   c01002ac <cprintf>
        }
        argv[argc ++] = buf;
c0100b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ba2:	8d 50 01             	lea    0x1(%eax),%edx
c0100ba5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ba8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100baf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bb2:	01 c2                	add    %eax,%edx
c0100bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bb9:	eb 03                	jmp    c0100bbe <parse+0x85>
            buf ++;
c0100bbb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bc1:	0f b6 00             	movzbl (%eax),%eax
c0100bc4:	84 c0                	test   %al,%al
c0100bc6:	74 8c                	je     c0100b54 <parse+0x1b>
c0100bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcb:	0f b6 00             	movzbl (%eax),%eax
c0100bce:	0f be c0             	movsbl %al,%eax
c0100bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd5:	c7 04 24 90 90 10 c0 	movl   $0xc0109090,(%esp)
c0100bdc:	e8 7d 77 00 00       	call   c010835e <strchr>
c0100be1:	85 c0                	test   %eax,%eax
c0100be3:	74 d6                	je     c0100bbb <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100be5:	e9 6a ff ff ff       	jmp    c0100b54 <parse+0x1b>
            break;
c0100bea:	90                   	nop
        }
    }
    return argc;
c0100beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bee:	c9                   	leave  
c0100bef:	c3                   	ret    

c0100bf0 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bf0:	55                   	push   %ebp
c0100bf1:	89 e5                	mov    %esp,%ebp
c0100bf3:	53                   	push   %ebx
c0100bf4:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bf7:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c01:	89 04 24             	mov    %eax,(%esp)
c0100c04:	e8 30 ff ff ff       	call   c0100b39 <parse>
c0100c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c10:	75 0a                	jne    c0100c1c <runcmd+0x2c>
        return 0;
c0100c12:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c17:	e9 83 00 00 00       	jmp    c0100c9f <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c23:	eb 5a                	jmp    c0100c7f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c25:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c2b:	89 d0                	mov    %edx,%eax
c0100c2d:	01 c0                	add    %eax,%eax
c0100c2f:	01 d0                	add    %edx,%eax
c0100c31:	c1 e0 02             	shl    $0x2,%eax
c0100c34:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100c39:	8b 00                	mov    (%eax),%eax
c0100c3b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c3f:	89 04 24             	mov    %eax,(%esp)
c0100c42:	e8 7a 76 00 00       	call   c01082c1 <strcmp>
c0100c47:	85 c0                	test   %eax,%eax
c0100c49:	75 31                	jne    c0100c7c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c4e:	89 d0                	mov    %edx,%eax
c0100c50:	01 c0                	add    %eax,%eax
c0100c52:	01 d0                	add    %edx,%eax
c0100c54:	c1 e0 02             	shl    $0x2,%eax
c0100c57:	05 08 00 12 c0       	add    $0xc0120008,%eax
c0100c5c:	8b 10                	mov    (%eax),%edx
c0100c5e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c61:	83 c0 04             	add    $0x4,%eax
c0100c64:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c67:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c75:	89 1c 24             	mov    %ebx,(%esp)
c0100c78:	ff d2                	call   *%edx
c0100c7a:	eb 23                	jmp    c0100c9f <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c7c:	ff 45 f4             	incl   -0xc(%ebp)
c0100c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c82:	83 f8 02             	cmp    $0x2,%eax
c0100c85:	76 9e                	jbe    c0100c25 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c87:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8e:	c7 04 24 b3 90 10 c0 	movl   $0xc01090b3,(%esp)
c0100c95:	e8 12 f6 ff ff       	call   c01002ac <cprintf>
    return 0;
c0100c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9f:	83 c4 64             	add    $0x64,%esp
c0100ca2:	5b                   	pop    %ebx
c0100ca3:	5d                   	pop    %ebp
c0100ca4:	c3                   	ret    

c0100ca5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ca5:	55                   	push   %ebp
c0100ca6:	89 e5                	mov    %esp,%ebp
c0100ca8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cab:	c7 04 24 cc 90 10 c0 	movl   $0xc01090cc,(%esp)
c0100cb2:	e8 f5 f5 ff ff       	call   c01002ac <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cb7:	c7 04 24 f4 90 10 c0 	movl   $0xc01090f4,(%esp)
c0100cbe:	e8 e9 f5 ff ff       	call   c01002ac <cprintf>

    if (tf != NULL) {
c0100cc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cc7:	74 0b                	je     c0100cd4 <kmonitor+0x2f>
        print_trapframe(tf);
c0100cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ccc:	89 04 24             	mov    %eax,(%esp)
c0100ccf:	e8 f8 15 00 00       	call   c01022cc <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cd4:	c7 04 24 19 91 10 c0 	movl   $0xc0109119,(%esp)
c0100cdb:	e8 6e f6 ff ff       	call   c010034e <readline>
c0100ce0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100ce7:	74 eb                	je     c0100cd4 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cf3:	89 04 24             	mov    %eax,(%esp)
c0100cf6:	e8 f5 fe ff ff       	call   c0100bf0 <runcmd>
c0100cfb:	85 c0                	test   %eax,%eax
c0100cfd:	78 02                	js     c0100d01 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100cff:	eb d3                	jmp    c0100cd4 <kmonitor+0x2f>
                break;
c0100d01:	90                   	nop
            }
        }
    }
}
c0100d02:	90                   	nop
c0100d03:	c9                   	leave  
c0100d04:	c3                   	ret    

c0100d05 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d05:	55                   	push   %ebp
c0100d06:	89 e5                	mov    %esp,%ebp
c0100d08:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d12:	eb 3d                	jmp    c0100d51 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d17:	89 d0                	mov    %edx,%eax
c0100d19:	01 c0                	add    %eax,%eax
c0100d1b:	01 d0                	add    %edx,%eax
c0100d1d:	c1 e0 02             	shl    $0x2,%eax
c0100d20:	05 04 00 12 c0       	add    $0xc0120004,%eax
c0100d25:	8b 08                	mov    (%eax),%ecx
c0100d27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d2a:	89 d0                	mov    %edx,%eax
c0100d2c:	01 c0                	add    %eax,%eax
c0100d2e:	01 d0                	add    %edx,%eax
c0100d30:	c1 e0 02             	shl    $0x2,%eax
c0100d33:	05 00 00 12 c0       	add    $0xc0120000,%eax
c0100d38:	8b 00                	mov    (%eax),%eax
c0100d3a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d42:	c7 04 24 1d 91 10 c0 	movl   $0xc010911d,(%esp)
c0100d49:	e8 5e f5 ff ff       	call   c01002ac <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d4e:	ff 45 f4             	incl   -0xc(%ebp)
c0100d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d54:	83 f8 02             	cmp    $0x2,%eax
c0100d57:	76 bb                	jbe    c0100d14 <mon_help+0xf>
    }
    return 0;
c0100d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d5e:	c9                   	leave  
c0100d5f:	c3                   	ret    

c0100d60 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d60:	55                   	push   %ebp
c0100d61:	89 e5                	mov    %esp,%ebp
c0100d63:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d66:	e8 e7 fb ff ff       	call   c0100952 <print_kerninfo>
    return 0;
c0100d6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d70:	c9                   	leave  
c0100d71:	c3                   	ret    

c0100d72 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d72:	55                   	push   %ebp
c0100d73:	89 e5                	mov    %esp,%ebp
c0100d75:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d78:	e8 20 fd ff ff       	call   c0100a9d <print_stackframe>
    return 0;
c0100d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d82:	c9                   	leave  
c0100d83:	c3                   	ret    

c0100d84 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100d84:	55                   	push   %ebp
c0100d85:	89 e5                	mov    %esp,%ebp
c0100d87:	83 ec 14             	sub    $0x14,%esp
c0100d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d8d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100d91:	90                   	nop
c0100d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100d95:	83 c0 07             	add    $0x7,%eax
c0100d98:	0f b7 c0             	movzwl %ax,%eax
c0100d9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d9f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100da3:	89 c2                	mov    %eax,%edx
c0100da5:	ec                   	in     (%dx),%al
c0100da6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100da9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100dad:	0f b6 c0             	movzbl %al,%eax
c0100db0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100db6:	25 80 00 00 00       	and    $0x80,%eax
c0100dbb:	85 c0                	test   %eax,%eax
c0100dbd:	75 d3                	jne    c0100d92 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100dbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100dc3:	74 11                	je     c0100dd6 <ide_wait_ready+0x52>
c0100dc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dc8:	83 e0 21             	and    $0x21,%eax
c0100dcb:	85 c0                	test   %eax,%eax
c0100dcd:	74 07                	je     c0100dd6 <ide_wait_ready+0x52>
        return -1;
c0100dcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100dd4:	eb 05                	jmp    c0100ddb <ide_wait_ready+0x57>
    }
    return 0;
c0100dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ddb:	c9                   	leave  
c0100ddc:	c3                   	ret    

c0100ddd <ide_init>:

void
ide_init(void) {
c0100ddd:	55                   	push   %ebp
c0100dde:	89 e5                	mov    %esp,%ebp
c0100de0:	57                   	push   %edi
c0100de1:	53                   	push   %ebx
c0100de2:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100de8:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100dee:	e9 ba 02 00 00       	jmp    c01010ad <ide_init+0x2d0>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100df3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100df7:	89 d0                	mov    %edx,%eax
c0100df9:	c1 e0 03             	shl    $0x3,%eax
c0100dfc:	29 d0                	sub    %edx,%eax
c0100dfe:	c1 e0 03             	shl    $0x3,%eax
c0100e01:	05 40 34 12 c0       	add    $0xc0123440,%eax
c0100e06:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e09:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e0d:	d1 e8                	shr    %eax
c0100e0f:	0f b7 c0             	movzwl %ax,%eax
c0100e12:	8b 04 85 28 91 10 c0 	mov    -0x3fef6ed8(,%eax,4),%eax
c0100e19:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e1d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e28:	00 
c0100e29:	89 04 24             	mov    %eax,(%esp)
c0100e2c:	e8 53 ff ff ff       	call   c0100d84 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e31:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e35:	c1 e0 04             	shl    $0x4,%eax
c0100e38:	24 10                	and    $0x10,%al
c0100e3a:	0c e0                	or     $0xe0,%al
c0100e3c:	0f b6 c0             	movzbl %al,%eax
c0100e3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e43:	83 c2 06             	add    $0x6,%edx
c0100e46:	0f b7 d2             	movzwl %dx,%edx
c0100e49:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c0100e4d:	88 45 c9             	mov    %al,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e50:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100e54:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0100e58:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e59:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e64:	00 
c0100e65:	89 04 24             	mov    %eax,(%esp)
c0100e68:	e8 17 ff ff ff       	call   c0100d84 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100e6d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e71:	83 c0 07             	add    $0x7,%eax
c0100e74:	0f b7 c0             	movzwl %ax,%eax
c0100e77:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c0100e7b:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c0100e7f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0100e83:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0100e87:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e88:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e93:	00 
c0100e94:	89 04 24             	mov    %eax,(%esp)
c0100e97:	e8 e8 fe ff ff       	call   c0100d84 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100e9c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ea0:	83 c0 07             	add    $0x7,%eax
c0100ea3:	0f b7 c0             	movzwl %ax,%eax
c0100ea6:	66 89 45 d2          	mov    %ax,-0x2e(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eaa:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100eae:	89 c2                	mov    %eax,%edx
c0100eb0:	ec                   	in     (%dx),%al
c0100eb1:	88 45 d1             	mov    %al,-0x2f(%ebp)
    return data;
c0100eb4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100eb8:	84 c0                	test   %al,%al
c0100eba:	0f 84 e3 01 00 00    	je     c01010a3 <ide_init+0x2c6>
c0100ec0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ec4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0100ecb:	00 
c0100ecc:	89 04 24             	mov    %eax,(%esp)
c0100ecf:	e8 b0 fe ff ff       	call   c0100d84 <ide_wait_ready>
c0100ed4:	85 c0                	test   %eax,%eax
c0100ed6:	0f 85 c7 01 00 00    	jne    c01010a3 <ide_init+0x2c6>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100edc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ee0:	89 d0                	mov    %edx,%eax
c0100ee2:	c1 e0 03             	shl    $0x3,%eax
c0100ee5:	29 d0                	sub    %edx,%eax
c0100ee7:	c1 e0 03             	shl    $0x3,%eax
c0100eea:	05 40 34 12 c0       	add    $0xc0123440,%eax
c0100eef:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100ef2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ef6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0100ef9:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100eff:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100f02:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c0100f09:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0100f0c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f0f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f12:	89 cb                	mov    %ecx,%ebx
c0100f14:	89 df                	mov    %ebx,%edi
c0100f16:	89 c1                	mov    %eax,%ecx
c0100f18:	fc                   	cld    
c0100f19:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f1b:	89 c8                	mov    %ecx,%eax
c0100f1d:	89 fb                	mov    %edi,%ebx
c0100f1f:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f22:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f25:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f31:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f37:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100f3d:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f42:	85 c0                	test   %eax,%eax
c0100f44:	74 0e                	je     c0100f54 <ide_init+0x177>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f49:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100f52:	eb 09                	jmp    c0100f5d <ide_init+0x180>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f57:	8b 40 78             	mov    0x78(%eax),%eax
c0100f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100f5d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f61:	89 d0                	mov    %edx,%eax
c0100f63:	c1 e0 03             	shl    $0x3,%eax
c0100f66:	29 d0                	sub    %edx,%eax
c0100f68:	c1 e0 03             	shl    $0x3,%eax
c0100f6b:	8d 90 44 34 12 c0    	lea    -0x3fedcbbc(%eax),%edx
c0100f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100f74:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100f76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7a:	89 d0                	mov    %edx,%eax
c0100f7c:	c1 e0 03             	shl    $0x3,%eax
c0100f7f:	29 d0                	sub    %edx,%eax
c0100f81:	c1 e0 03             	shl    $0x3,%eax
c0100f84:	8d 90 48 34 12 c0    	lea    -0x3fedcbb8(%eax),%edx
c0100f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f8d:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f92:	83 c0 62             	add    $0x62,%eax
c0100f95:	0f b7 00             	movzwl (%eax),%eax
c0100f98:	25 00 02 00 00       	and    $0x200,%eax
c0100f9d:	85 c0                	test   %eax,%eax
c0100f9f:	75 24                	jne    c0100fc5 <ide_init+0x1e8>
c0100fa1:	c7 44 24 0c 30 91 10 	movl   $0xc0109130,0xc(%esp)
c0100fa8:	c0 
c0100fa9:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c0100fb0:	c0 
c0100fb1:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0100fb8:	00 
c0100fb9:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0100fc0:	e8 3e f4 ff ff       	call   c0100403 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0100fc5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fc9:	89 d0                	mov    %edx,%eax
c0100fcb:	c1 e0 03             	shl    $0x3,%eax
c0100fce:	29 d0                	sub    %edx,%eax
c0100fd0:	c1 e0 03             	shl    $0x3,%eax
c0100fd3:	05 40 34 12 c0       	add    $0xc0123440,%eax
c0100fd8:	83 c0 0c             	add    $0xc,%eax
c0100fdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100fe1:	83 c0 36             	add    $0x36,%eax
c0100fe4:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0100fe7:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0100fee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ff5:	eb 34                	jmp    c010102b <ide_init+0x24e>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0100ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100ffa:	8d 50 01             	lea    0x1(%eax),%edx
c0100ffd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101000:	01 d0                	add    %edx,%eax
c0101002:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0101005:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0101008:	01 ca                	add    %ecx,%edx
c010100a:	0f b6 00             	movzbl (%eax),%eax
c010100d:	88 02                	mov    %al,(%edx)
c010100f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0101012:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101015:	01 d0                	add    %edx,%eax
c0101017:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010101a:	8d 4a 01             	lea    0x1(%edx),%ecx
c010101d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101020:	01 ca                	add    %ecx,%edx
c0101022:	0f b6 00             	movzbl (%eax),%eax
c0101025:	88 02                	mov    %al,(%edx)
        for (i = 0; i < length; i += 2) {
c0101027:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010102b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010102e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101031:	72 c4                	jb     c0100ff7 <ide_init+0x21a>
        }
        do {
            model[i] = '\0';
c0101033:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101036:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101039:	01 d0                	add    %edx,%eax
c010103b:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010103e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101041:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101044:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101047:	85 c0                	test   %eax,%eax
c0101049:	74 0f                	je     c010105a <ide_init+0x27d>
c010104b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010104e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101051:	01 d0                	add    %edx,%eax
c0101053:	0f b6 00             	movzbl (%eax),%eax
c0101056:	3c 20                	cmp    $0x20,%al
c0101058:	74 d9                	je     c0101033 <ide_init+0x256>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010105a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010105e:	89 d0                	mov    %edx,%eax
c0101060:	c1 e0 03             	shl    $0x3,%eax
c0101063:	29 d0                	sub    %edx,%eax
c0101065:	c1 e0 03             	shl    $0x3,%eax
c0101068:	05 40 34 12 c0       	add    $0xc0123440,%eax
c010106d:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101070:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101074:	89 d0                	mov    %edx,%eax
c0101076:	c1 e0 03             	shl    $0x3,%eax
c0101079:	29 d0                	sub    %edx,%eax
c010107b:	c1 e0 03             	shl    $0x3,%eax
c010107e:	05 48 34 12 c0       	add    $0xc0123448,%eax
c0101083:	8b 10                	mov    (%eax),%edx
c0101085:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101089:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010108d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101091:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101095:	c7 04 24 9a 91 10 c0 	movl   $0xc010919a,(%esp)
c010109c:	e8 0b f2 ff ff       	call   c01002ac <cprintf>
c01010a1:	eb 01                	jmp    c01010a4 <ide_init+0x2c7>
            continue ;
c01010a3:	90                   	nop
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01010a4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010a8:	40                   	inc    %eax
c01010a9:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01010ad:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010b1:	83 f8 03             	cmp    $0x3,%eax
c01010b4:	0f 86 39 fd ff ff    	jbe    c0100df3 <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01010ba:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c01010c1:	e8 91 0e 00 00       	call   c0101f57 <pic_enable>
    pic_enable(IRQ_IDE2);
c01010c6:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c01010cd:	e8 85 0e 00 00       	call   c0101f57 <pic_enable>
}
c01010d2:	90                   	nop
c01010d3:	81 c4 50 02 00 00    	add    $0x250,%esp
c01010d9:	5b                   	pop    %ebx
c01010da:	5f                   	pop    %edi
c01010db:	5d                   	pop    %ebp
c01010dc:	c3                   	ret    

c01010dd <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c01010dd:	55                   	push   %ebp
c01010de:	89 e5                	mov    %esp,%ebp
c01010e0:	83 ec 04             	sub    $0x4,%esp
c01010e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c01010ea:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01010ee:	83 f8 03             	cmp    $0x3,%eax
c01010f1:	77 21                	ja     c0101114 <ide_device_valid+0x37>
c01010f3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01010f7:	89 d0                	mov    %edx,%eax
c01010f9:	c1 e0 03             	shl    $0x3,%eax
c01010fc:	29 d0                	sub    %edx,%eax
c01010fe:	c1 e0 03             	shl    $0x3,%eax
c0101101:	05 40 34 12 c0       	add    $0xc0123440,%eax
c0101106:	0f b6 00             	movzbl (%eax),%eax
c0101109:	84 c0                	test   %al,%al
c010110b:	74 07                	je     c0101114 <ide_device_valid+0x37>
c010110d:	b8 01 00 00 00       	mov    $0x1,%eax
c0101112:	eb 05                	jmp    c0101119 <ide_device_valid+0x3c>
c0101114:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101119:	c9                   	leave  
c010111a:	c3                   	ret    

c010111b <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c010111b:	55                   	push   %ebp
c010111c:	89 e5                	mov    %esp,%ebp
c010111e:	83 ec 08             	sub    $0x8,%esp
c0101121:	8b 45 08             	mov    0x8(%ebp),%eax
c0101124:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101128:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c010112c:	89 04 24             	mov    %eax,(%esp)
c010112f:	e8 a9 ff ff ff       	call   c01010dd <ide_device_valid>
c0101134:	85 c0                	test   %eax,%eax
c0101136:	74 17                	je     c010114f <ide_device_size+0x34>
        return ide_devices[ideno].size;
c0101138:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c010113c:	89 d0                	mov    %edx,%eax
c010113e:	c1 e0 03             	shl    $0x3,%eax
c0101141:	29 d0                	sub    %edx,%eax
c0101143:	c1 e0 03             	shl    $0x3,%eax
c0101146:	05 48 34 12 c0       	add    $0xc0123448,%eax
c010114b:	8b 00                	mov    (%eax),%eax
c010114d:	eb 05                	jmp    c0101154 <ide_device_size+0x39>
    }
    return 0;
c010114f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101154:	c9                   	leave  
c0101155:	c3                   	ret    

c0101156 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101156:	55                   	push   %ebp
c0101157:	89 e5                	mov    %esp,%ebp
c0101159:	57                   	push   %edi
c010115a:	53                   	push   %ebx
c010115b:	83 ec 50             	sub    $0x50,%esp
c010115e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101161:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101165:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c010116c:	77 23                	ja     c0101191 <ide_read_secs+0x3b>
c010116e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101172:	83 f8 03             	cmp    $0x3,%eax
c0101175:	77 1a                	ja     c0101191 <ide_read_secs+0x3b>
c0101177:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c010117b:	89 d0                	mov    %edx,%eax
c010117d:	c1 e0 03             	shl    $0x3,%eax
c0101180:	29 d0                	sub    %edx,%eax
c0101182:	c1 e0 03             	shl    $0x3,%eax
c0101185:	05 40 34 12 c0       	add    $0xc0123440,%eax
c010118a:	0f b6 00             	movzbl (%eax),%eax
c010118d:	84 c0                	test   %al,%al
c010118f:	75 24                	jne    c01011b5 <ide_read_secs+0x5f>
c0101191:	c7 44 24 0c b8 91 10 	movl   $0xc01091b8,0xc(%esp)
c0101198:	c0 
c0101199:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c01011a0:	c0 
c01011a1:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01011a8:	00 
c01011a9:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c01011b0:	e8 4e f2 ff ff       	call   c0100403 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011b5:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01011bc:	77 0f                	ja     c01011cd <ide_read_secs+0x77>
c01011be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01011c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01011c4:	01 d0                	add    %edx,%eax
c01011c6:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c01011cb:	76 24                	jbe    c01011f1 <ide_read_secs+0x9b>
c01011cd:	c7 44 24 0c e0 91 10 	movl   $0xc01091e0,0xc(%esp)
c01011d4:	c0 
c01011d5:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c01011dc:	c0 
c01011dd:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01011e4:	00 
c01011e5:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c01011ec:	e8 12 f2 ff ff       	call   c0100403 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c01011f1:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011f5:	d1 e8                	shr    %eax
c01011f7:	0f b7 c0             	movzwl %ax,%eax
c01011fa:	8b 04 85 28 91 10 c0 	mov    -0x3fef6ed8(,%eax,4),%eax
c0101201:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101205:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101209:	d1 e8                	shr    %eax
c010120b:	0f b7 c0             	movzwl %ax,%eax
c010120e:	0f b7 04 85 2a 91 10 	movzwl -0x3fef6ed6(,%eax,4),%eax
c0101215:	c0 
c0101216:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c010121a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010121e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101225:	00 
c0101226:	89 04 24             	mov    %eax,(%esp)
c0101229:	e8 56 fb ff ff       	call   c0100d84 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c010122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101231:	83 c0 02             	add    $0x2,%eax
c0101234:	0f b7 c0             	movzwl %ax,%eax
c0101237:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c010123b:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010123f:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101243:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101247:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101248:	8b 45 14             	mov    0x14(%ebp),%eax
c010124b:	0f b6 c0             	movzbl %al,%eax
c010124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101252:	83 c2 02             	add    $0x2,%edx
c0101255:	0f b7 d2             	movzwl %dx,%edx
c0101258:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c010125c:	88 45 d9             	mov    %al,-0x27(%ebp)
c010125f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101263:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101267:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101268:	8b 45 0c             	mov    0xc(%ebp),%eax
c010126b:	0f b6 c0             	movzbl %al,%eax
c010126e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101272:	83 c2 03             	add    $0x3,%edx
c0101275:	0f b7 d2             	movzwl %dx,%edx
c0101278:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c010127c:	88 45 dd             	mov    %al,-0x23(%ebp)
c010127f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101283:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101287:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101288:	8b 45 0c             	mov    0xc(%ebp),%eax
c010128b:	c1 e8 08             	shr    $0x8,%eax
c010128e:	0f b6 c0             	movzbl %al,%eax
c0101291:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101295:	83 c2 04             	add    $0x4,%edx
c0101298:	0f b7 d2             	movzwl %dx,%edx
c010129b:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c010129f:	88 45 e1             	mov    %al,-0x1f(%ebp)
c01012a2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01012a6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01012aa:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012ae:	c1 e8 10             	shr    $0x10,%eax
c01012b1:	0f b6 c0             	movzbl %al,%eax
c01012b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012b8:	83 c2 05             	add    $0x5,%edx
c01012bb:	0f b7 d2             	movzwl %dx,%edx
c01012be:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c2:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012cd:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c01012ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01012d1:	c0 e0 04             	shl    $0x4,%al
c01012d4:	24 10                	and    $0x10,%al
c01012d6:	88 c2                	mov    %al,%dl
c01012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012db:	c1 e8 18             	shr    $0x18,%eax
c01012de:	24 0f                	and    $0xf,%al
c01012e0:	08 d0                	or     %dl,%al
c01012e2:	0c e0                	or     $0xe0,%al
c01012e4:	0f b6 c0             	movzbl %al,%eax
c01012e7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012eb:	83 c2 06             	add    $0x6,%edx
c01012ee:	0f b7 d2             	movzwl %dx,%edx
c01012f1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012f5:	88 45 e9             	mov    %al,-0x17(%ebp)
c01012f8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012fc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101300:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101301:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101305:	83 c0 07             	add    $0x7,%eax
c0101308:	0f b7 c0             	movzwl %ax,%eax
c010130b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010130f:	c6 45 ed 20          	movb   $0x20,-0x13(%ebp)
c0101313:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101317:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010131b:	ee                   	out    %al,(%dx)

    int ret = 0;
c010131c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101323:	eb 57                	jmp    c010137c <ide_read_secs+0x226>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101325:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101330:	00 
c0101331:	89 04 24             	mov    %eax,(%esp)
c0101334:	e8 4b fa ff ff       	call   c0100d84 <ide_wait_ready>
c0101339:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010133c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101340:	75 42                	jne    c0101384 <ide_read_secs+0x22e>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101342:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101346:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101349:	8b 45 10             	mov    0x10(%ebp),%eax
c010134c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010134f:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c0101356:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101359:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c010135c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010135f:	89 cb                	mov    %ecx,%ebx
c0101361:	89 df                	mov    %ebx,%edi
c0101363:	89 c1                	mov    %eax,%ecx
c0101365:	fc                   	cld    
c0101366:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101368:	89 c8                	mov    %ecx,%eax
c010136a:	89 fb                	mov    %edi,%ebx
c010136c:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c010136f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101372:	ff 4d 14             	decl   0x14(%ebp)
c0101375:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c010137c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101380:	75 a3                	jne    c0101325 <ide_read_secs+0x1cf>
    }

out:
c0101382:	eb 01                	jmp    c0101385 <ide_read_secs+0x22f>
            goto out;
c0101384:	90                   	nop
    return ret;
c0101385:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101388:	83 c4 50             	add    $0x50,%esp
c010138b:	5b                   	pop    %ebx
c010138c:	5f                   	pop    %edi
c010138d:	5d                   	pop    %ebp
c010138e:	c3                   	ret    

c010138f <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c010138f:	55                   	push   %ebp
c0101390:	89 e5                	mov    %esp,%ebp
c0101392:	56                   	push   %esi
c0101393:	53                   	push   %ebx
c0101394:	83 ec 50             	sub    $0x50,%esp
c0101397:	8b 45 08             	mov    0x8(%ebp),%eax
c010139a:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c010139e:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01013a5:	77 23                	ja     c01013ca <ide_write_secs+0x3b>
c01013a7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01013ab:	83 f8 03             	cmp    $0x3,%eax
c01013ae:	77 1a                	ja     c01013ca <ide_write_secs+0x3b>
c01013b0:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c01013b4:	89 d0                	mov    %edx,%eax
c01013b6:	c1 e0 03             	shl    $0x3,%eax
c01013b9:	29 d0                	sub    %edx,%eax
c01013bb:	c1 e0 03             	shl    $0x3,%eax
c01013be:	05 40 34 12 c0       	add    $0xc0123440,%eax
c01013c3:	0f b6 00             	movzbl (%eax),%eax
c01013c6:	84 c0                	test   %al,%al
c01013c8:	75 24                	jne    c01013ee <ide_write_secs+0x5f>
c01013ca:	c7 44 24 0c b8 91 10 	movl   $0xc01091b8,0xc(%esp)
c01013d1:	c0 
c01013d2:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c01013d9:	c0 
c01013da:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01013e1:	00 
c01013e2:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c01013e9:	e8 15 f0 ff ff       	call   c0100403 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01013ee:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c01013f5:	77 0f                	ja     c0101406 <ide_write_secs+0x77>
c01013f7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01013fa:	8b 45 14             	mov    0x14(%ebp),%eax
c01013fd:	01 d0                	add    %edx,%eax
c01013ff:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101404:	76 24                	jbe    c010142a <ide_write_secs+0x9b>
c0101406:	c7 44 24 0c e0 91 10 	movl   $0xc01091e0,0xc(%esp)
c010140d:	c0 
c010140e:	c7 44 24 08 73 91 10 	movl   $0xc0109173,0x8(%esp)
c0101415:	c0 
c0101416:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c010141d:	00 
c010141e:	c7 04 24 88 91 10 c0 	movl   $0xc0109188,(%esp)
c0101425:	e8 d9 ef ff ff       	call   c0100403 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010142a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010142e:	d1 e8                	shr    %eax
c0101430:	0f b7 c0             	movzwl %ax,%eax
c0101433:	8b 04 85 28 91 10 c0 	mov    -0x3fef6ed8(,%eax,4),%eax
c010143a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010143e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101442:	d1 e8                	shr    %eax
c0101444:	0f b7 c0             	movzwl %ax,%eax
c0101447:	0f b7 04 85 2a 91 10 	movzwl -0x3fef6ed6(,%eax,4),%eax
c010144e:	c0 
c010144f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101453:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101457:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010145e:	00 
c010145f:	89 04 24             	mov    %eax,(%esp)
c0101462:	e8 1d f9 ff ff       	call   c0100d84 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101467:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010146a:	83 c0 02             	add    $0x2,%eax
c010146d:	0f b7 c0             	movzwl %ax,%eax
c0101470:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101474:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101478:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010147c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101480:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101481:	8b 45 14             	mov    0x14(%ebp),%eax
c0101484:	0f b6 c0             	movzbl %al,%eax
c0101487:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010148b:	83 c2 02             	add    $0x2,%edx
c010148e:	0f b7 d2             	movzwl %dx,%edx
c0101491:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101495:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101498:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010149c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01014a0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014a4:	0f b6 c0             	movzbl %al,%eax
c01014a7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014ab:	83 c2 03             	add    $0x3,%edx
c01014ae:	0f b7 d2             	movzwl %dx,%edx
c01014b1:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c01014b5:	88 45 dd             	mov    %al,-0x23(%ebp)
c01014b8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01014bc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01014c0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014c4:	c1 e8 08             	shr    $0x8,%eax
c01014c7:	0f b6 c0             	movzbl %al,%eax
c01014ca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014ce:	83 c2 04             	add    $0x4,%edx
c01014d1:	0f b7 d2             	movzwl %dx,%edx
c01014d4:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01014d8:	88 45 e1             	mov    %al,-0x1f(%ebp)
c01014db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01014df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01014e3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01014e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014e7:	c1 e8 10             	shr    $0x10,%eax
c01014ea:	0f b6 c0             	movzbl %al,%eax
c01014ed:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014f1:	83 c2 05             	add    $0x5,%edx
c01014f4:	0f b7 d2             	movzwl %dx,%edx
c01014f7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01014fb:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01014fe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101502:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101506:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101507:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010150a:	c0 e0 04             	shl    $0x4,%al
c010150d:	24 10                	and    $0x10,%al
c010150f:	88 c2                	mov    %al,%dl
c0101511:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101514:	c1 e8 18             	shr    $0x18,%eax
c0101517:	24 0f                	and    $0xf,%al
c0101519:	08 d0                	or     %dl,%al
c010151b:	0c e0                	or     $0xe0,%al
c010151d:	0f b6 c0             	movzbl %al,%eax
c0101520:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101524:	83 c2 06             	add    $0x6,%edx
c0101527:	0f b7 d2             	movzwl %dx,%edx
c010152a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010152e:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101531:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101535:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101539:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c010153a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010153e:	83 c0 07             	add    $0x7,%eax
c0101541:	0f b7 c0             	movzwl %ax,%eax
c0101544:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101548:	c6 45 ed 30          	movb   $0x30,-0x13(%ebp)
c010154c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101550:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101554:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010155c:	eb 57                	jmp    c01015b5 <ide_write_secs+0x226>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c010155e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101562:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101569:	00 
c010156a:	89 04 24             	mov    %eax,(%esp)
c010156d:	e8 12 f8 ff ff       	call   c0100d84 <ide_wait_ready>
c0101572:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101579:	75 42                	jne    c01015bd <ide_write_secs+0x22e>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c010157b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010157f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101582:	8b 45 10             	mov    0x10(%ebp),%eax
c0101585:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101588:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c010158f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101592:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101595:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101598:	89 cb                	mov    %ecx,%ebx
c010159a:	89 de                	mov    %ebx,%esi
c010159c:	89 c1                	mov    %eax,%ecx
c010159e:	fc                   	cld    
c010159f:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c01015a1:	89 c8                	mov    %ecx,%eax
c01015a3:	89 f3                	mov    %esi,%ebx
c01015a5:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c01015a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01015ab:	ff 4d 14             	decl   0x14(%ebp)
c01015ae:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01015b5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01015b9:	75 a3                	jne    c010155e <ide_write_secs+0x1cf>
    }

out:
c01015bb:	eb 01                	jmp    c01015be <ide_write_secs+0x22f>
            goto out;
c01015bd:	90                   	nop
    return ret;
c01015be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c1:	83 c4 50             	add    $0x50,%esp
c01015c4:	5b                   	pop    %ebx
c01015c5:	5e                   	pop    %esi
c01015c6:	5d                   	pop    %ebp
c01015c7:	c3                   	ret    

c01015c8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c01015c8:	55                   	push   %ebp
c01015c9:	89 e5                	mov    %esp,%ebp
c01015cb:	83 ec 28             	sub    $0x28,%esp
c01015ce:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c01015d4:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015d8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01015dc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01015e0:	ee                   	out    %al,(%dx)
c01015e1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c01015e7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c01015eb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01015ef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01015f3:	ee                   	out    %al,(%dx)
c01015f4:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c01015fa:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c01015fe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101602:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101606:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0101607:	c7 05 0c 40 12 c0 00 	movl   $0x0,0xc012400c
c010160e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0101611:	c7 04 24 1a 92 10 c0 	movl   $0xc010921a,(%esp)
c0101618:	e8 8f ec ff ff       	call   c01002ac <cprintf>
    pic_enable(IRQ_TIMER);
c010161d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0101624:	e8 2e 09 00 00       	call   c0101f57 <pic_enable>
}
c0101629:	90                   	nop
c010162a:	c9                   	leave  
c010162b:	c3                   	ret    

c010162c <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010162c:	55                   	push   %ebp
c010162d:	89 e5                	mov    %esp,%ebp
c010162f:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0101632:	9c                   	pushf  
c0101633:	58                   	pop    %eax
c0101634:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0101637:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010163a:	25 00 02 00 00       	and    $0x200,%eax
c010163f:	85 c0                	test   %eax,%eax
c0101641:	74 0c                	je     c010164f <__intr_save+0x23>
        intr_disable();
c0101643:	e8 83 0a 00 00       	call   c01020cb <intr_disable>
        return 1;
c0101648:	b8 01 00 00 00       	mov    $0x1,%eax
c010164d:	eb 05                	jmp    c0101654 <__intr_save+0x28>
    }
    return 0;
c010164f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101654:	c9                   	leave  
c0101655:	c3                   	ret    

c0101656 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0101656:	55                   	push   %ebp
c0101657:	89 e5                	mov    %esp,%ebp
c0101659:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010165c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0101660:	74 05                	je     c0101667 <__intr_restore+0x11>
        intr_enable();
c0101662:	e8 5d 0a 00 00       	call   c01020c4 <intr_enable>
    }
}
c0101667:	90                   	nop
c0101668:	c9                   	leave  
c0101669:	c3                   	ret    

c010166a <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c010166a:	55                   	push   %ebp
c010166b:	89 e5                	mov    %esp,%ebp
c010166d:	83 ec 10             	sub    $0x10,%esp
c0101670:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101676:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010167a:	89 c2                	mov    %eax,%edx
c010167c:	ec                   	in     (%dx),%al
c010167d:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101680:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0101686:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010168a:	89 c2                	mov    %eax,%edx
c010168c:	ec                   	in     (%dx),%al
c010168d:	88 45 f5             	mov    %al,-0xb(%ebp)
c0101690:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0101696:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010169a:	89 c2                	mov    %eax,%edx
c010169c:	ec                   	in     (%dx),%al
c010169d:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016a0:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c01016a6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01016aa:	89 c2                	mov    %eax,%edx
c01016ac:	ec                   	in     (%dx),%al
c01016ad:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c01016b0:	90                   	nop
c01016b1:	c9                   	leave  
c01016b2:	c3                   	ret    

c01016b3 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c01016b3:	55                   	push   %ebp
c01016b4:	89 e5                	mov    %esp,%ebp
c01016b6:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c01016b9:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c01016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016c3:	0f b7 00             	movzwl (%eax),%eax
c01016c6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c01016ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016cd:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c01016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016d5:	0f b7 00             	movzwl (%eax),%eax
c01016d8:	0f b7 c0             	movzwl %ax,%eax
c01016db:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c01016e0:	74 12                	je     c01016f4 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c01016e2:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c01016e9:	66 c7 05 26 35 12 c0 	movw   $0x3b4,0xc0123526
c01016f0:	b4 03 
c01016f2:	eb 13                	jmp    c0101707 <cga_init+0x54>
    } else {
        *cp = was;
c01016f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016fb:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c01016fe:	66 c7 05 26 35 12 c0 	movw   $0x3d4,0xc0123526
c0101705:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0101707:	0f b7 05 26 35 12 c0 	movzwl 0xc0123526,%eax
c010170e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101712:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101716:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010171a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010171e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c010171f:	0f b7 05 26 35 12 c0 	movzwl 0xc0123526,%eax
c0101726:	40                   	inc    %eax
c0101727:	0f b7 c0             	movzwl %ax,%eax
c010172a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010172e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101732:	89 c2                	mov    %eax,%edx
c0101734:	ec                   	in     (%dx),%al
c0101735:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0101738:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010173c:	0f b6 c0             	movzbl %al,%eax
c010173f:	c1 e0 08             	shl    $0x8,%eax
c0101742:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101745:	0f b7 05 26 35 12 c0 	movzwl 0xc0123526,%eax
c010174c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101750:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101754:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101758:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010175c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c010175d:	0f b7 05 26 35 12 c0 	movzwl 0xc0123526,%eax
c0101764:	40                   	inc    %eax
c0101765:	0f b7 c0             	movzwl %ax,%eax
c0101768:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010176c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101770:	89 c2                	mov    %eax,%edx
c0101772:	ec                   	in     (%dx),%al
c0101773:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0101776:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010177a:	0f b6 c0             	movzbl %al,%eax
c010177d:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0101780:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101783:	a3 20 35 12 c0       	mov    %eax,0xc0123520
    crt_pos = pos;
c0101788:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010178b:	0f b7 c0             	movzwl %ax,%eax
c010178e:	66 a3 24 35 12 c0    	mov    %ax,0xc0123524
}
c0101794:	90                   	nop
c0101795:	c9                   	leave  
c0101796:	c3                   	ret    

c0101797 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101797:	55                   	push   %ebp
c0101798:	89 e5                	mov    %esp,%ebp
c010179a:	83 ec 48             	sub    $0x48,%esp
c010179d:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c01017a3:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017ab:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
c01017b0:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c01017b6:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c01017ba:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017be:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017c2:	ee                   	out    %al,(%dx)
c01017c3:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c01017c9:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c01017cd:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017d1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017d5:	ee                   	out    %al,(%dx)
c01017d6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01017dc:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c01017e0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017e4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017e8:	ee                   	out    %al,(%dx)
c01017e9:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c01017ef:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c01017f3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017fb:	ee                   	out    %al,(%dx)
c01017fc:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101802:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0101806:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010180a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010180e:	ee                   	out    %al,(%dx)
c010180f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101815:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0101819:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010181d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101821:	ee                   	out    %al,(%dx)
c0101822:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101828:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010182c:	89 c2                	mov    %eax,%edx
c010182e:	ec                   	in     (%dx),%al
c010182f:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101832:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101836:	3c ff                	cmp    $0xff,%al
c0101838:	0f 95 c0             	setne  %al
c010183b:	0f b6 c0             	movzbl %al,%eax
c010183e:	a3 28 35 12 c0       	mov    %eax,0xc0123528
c0101843:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101849:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010184d:	89 c2                	mov    %eax,%edx
c010184f:	ec                   	in     (%dx),%al
c0101850:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101853:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101859:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010185d:	89 c2                	mov    %eax,%edx
c010185f:	ec                   	in     (%dx),%al
c0101860:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101863:	a1 28 35 12 c0       	mov    0xc0123528,%eax
c0101868:	85 c0                	test   %eax,%eax
c010186a:	74 0c                	je     c0101878 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010186c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101873:	e8 df 06 00 00       	call   c0101f57 <pic_enable>
    }
}
c0101878:	90                   	nop
c0101879:	c9                   	leave  
c010187a:	c3                   	ret    

c010187b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010187b:	55                   	push   %ebp
c010187c:	89 e5                	mov    %esp,%ebp
c010187e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101888:	eb 08                	jmp    c0101892 <lpt_putc_sub+0x17>
        delay();
c010188a:	e8 db fd ff ff       	call   c010166a <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010188f:	ff 45 fc             	incl   -0x4(%ebp)
c0101892:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101898:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010189c:	89 c2                	mov    %eax,%edx
c010189e:	ec                   	in     (%dx),%al
c010189f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01018a2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018a6:	84 c0                	test   %al,%al
c01018a8:	78 09                	js     c01018b3 <lpt_putc_sub+0x38>
c01018aa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01018b1:	7e d7                	jle    c010188a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01018b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01018b6:	0f b6 c0             	movzbl %al,%eax
c01018b9:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01018bf:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018c6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018ca:	ee                   	out    %al,(%dx)
c01018cb:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01018d1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01018d5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018d9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018dd:	ee                   	out    %al,(%dx)
c01018de:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01018e4:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c01018e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018f0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01018f1:	90                   	nop
c01018f2:	c9                   	leave  
c01018f3:	c3                   	ret    

c01018f4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01018f4:	55                   	push   %ebp
c01018f5:	89 e5                	mov    %esp,%ebp
c01018f7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01018fa:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01018fe:	74 0d                	je     c010190d <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101900:	8b 45 08             	mov    0x8(%ebp),%eax
c0101903:	89 04 24             	mov    %eax,(%esp)
c0101906:	e8 70 ff ff ff       	call   c010187b <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010190b:	eb 24                	jmp    c0101931 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c010190d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101914:	e8 62 ff ff ff       	call   c010187b <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101919:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101920:	e8 56 ff ff ff       	call   c010187b <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101925:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010192c:	e8 4a ff ff ff       	call   c010187b <lpt_putc_sub>
}
c0101931:	90                   	nop
c0101932:	c9                   	leave  
c0101933:	c3                   	ret    

c0101934 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101934:	55                   	push   %ebp
c0101935:	89 e5                	mov    %esp,%ebp
c0101937:	53                   	push   %ebx
c0101938:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010193b:	8b 45 08             	mov    0x8(%ebp),%eax
c010193e:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101943:	85 c0                	test   %eax,%eax
c0101945:	75 07                	jne    c010194e <cga_putc+0x1a>
        c |= 0x0700;
c0101947:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010194e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101951:	0f b6 c0             	movzbl %al,%eax
c0101954:	83 f8 0a             	cmp    $0xa,%eax
c0101957:	74 55                	je     c01019ae <cga_putc+0x7a>
c0101959:	83 f8 0d             	cmp    $0xd,%eax
c010195c:	74 63                	je     c01019c1 <cga_putc+0x8d>
c010195e:	83 f8 08             	cmp    $0x8,%eax
c0101961:	0f 85 94 00 00 00    	jne    c01019fb <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c0101967:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c010196e:	85 c0                	test   %eax,%eax
c0101970:	0f 84 af 00 00 00    	je     c0101a25 <cga_putc+0xf1>
            crt_pos --;
c0101976:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c010197d:	48                   	dec    %eax
c010197e:	0f b7 c0             	movzwl %ax,%eax
c0101981:	66 a3 24 35 12 c0    	mov    %ax,0xc0123524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101987:	8b 45 08             	mov    0x8(%ebp),%eax
c010198a:	98                   	cwtl   
c010198b:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101990:	98                   	cwtl   
c0101991:	83 c8 20             	or     $0x20,%eax
c0101994:	98                   	cwtl   
c0101995:	8b 15 20 35 12 c0    	mov    0xc0123520,%edx
c010199b:	0f b7 0d 24 35 12 c0 	movzwl 0xc0123524,%ecx
c01019a2:	01 c9                	add    %ecx,%ecx
c01019a4:	01 ca                	add    %ecx,%edx
c01019a6:	0f b7 c0             	movzwl %ax,%eax
c01019a9:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01019ac:	eb 77                	jmp    c0101a25 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c01019ae:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c01019b5:	83 c0 50             	add    $0x50,%eax
c01019b8:	0f b7 c0             	movzwl %ax,%eax
c01019bb:	66 a3 24 35 12 c0    	mov    %ax,0xc0123524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01019c1:	0f b7 1d 24 35 12 c0 	movzwl 0xc0123524,%ebx
c01019c8:	0f b7 0d 24 35 12 c0 	movzwl 0xc0123524,%ecx
c01019cf:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01019d4:	89 c8                	mov    %ecx,%eax
c01019d6:	f7 e2                	mul    %edx
c01019d8:	c1 ea 06             	shr    $0x6,%edx
c01019db:	89 d0                	mov    %edx,%eax
c01019dd:	c1 e0 02             	shl    $0x2,%eax
c01019e0:	01 d0                	add    %edx,%eax
c01019e2:	c1 e0 04             	shl    $0x4,%eax
c01019e5:	29 c1                	sub    %eax,%ecx
c01019e7:	89 c8                	mov    %ecx,%eax
c01019e9:	0f b7 c0             	movzwl %ax,%eax
c01019ec:	29 c3                	sub    %eax,%ebx
c01019ee:	89 d8                	mov    %ebx,%eax
c01019f0:	0f b7 c0             	movzwl %ax,%eax
c01019f3:	66 a3 24 35 12 c0    	mov    %ax,0xc0123524
        break;
c01019f9:	eb 2b                	jmp    c0101a26 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01019fb:	8b 0d 20 35 12 c0    	mov    0xc0123520,%ecx
c0101a01:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c0101a08:	8d 50 01             	lea    0x1(%eax),%edx
c0101a0b:	0f b7 d2             	movzwl %dx,%edx
c0101a0e:	66 89 15 24 35 12 c0 	mov    %dx,0xc0123524
c0101a15:	01 c0                	add    %eax,%eax
c0101a17:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1d:	0f b7 c0             	movzwl %ax,%eax
c0101a20:	66 89 02             	mov    %ax,(%edx)
        break;
c0101a23:	eb 01                	jmp    c0101a26 <cga_putc+0xf2>
        break;
c0101a25:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a26:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c0101a2d:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101a32:	76 5d                	jbe    c0101a91 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a34:	a1 20 35 12 c0       	mov    0xc0123520,%eax
c0101a39:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a3f:	a1 20 35 12 c0       	mov    0xc0123520,%eax
c0101a44:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101a4b:	00 
c0101a4c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a50:	89 04 24             	mov    %eax,(%esp)
c0101a53:	e8 fc 6a 00 00       	call   c0108554 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a58:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101a5f:	eb 14                	jmp    c0101a75 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c0101a61:	a1 20 35 12 c0       	mov    0xc0123520,%eax
c0101a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101a69:	01 d2                	add    %edx,%edx
c0101a6b:	01 d0                	add    %edx,%eax
c0101a6d:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a72:	ff 45 f4             	incl   -0xc(%ebp)
c0101a75:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101a7c:	7e e3                	jle    c0101a61 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c0101a7e:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c0101a85:	83 e8 50             	sub    $0x50,%eax
c0101a88:	0f b7 c0             	movzwl %ax,%eax
c0101a8b:	66 a3 24 35 12 c0    	mov    %ax,0xc0123524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101a91:	0f b7 05 26 35 12 c0 	movzwl 0xc0123526,%eax
c0101a98:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101a9c:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101aa0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101aa4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101aa8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101aa9:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c0101ab0:	c1 e8 08             	shr    $0x8,%eax
c0101ab3:	0f b7 c0             	movzwl %ax,%eax
c0101ab6:	0f b6 c0             	movzbl %al,%eax
c0101ab9:	0f b7 15 26 35 12 c0 	movzwl 0xc0123526,%edx
c0101ac0:	42                   	inc    %edx
c0101ac1:	0f b7 d2             	movzwl %dx,%edx
c0101ac4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ac8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101acb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101acf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101ad3:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101ad4:	0f b7 05 26 35 12 c0 	movzwl 0xc0123526,%eax
c0101adb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101adf:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101ae3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ae7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101aeb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101aec:	0f b7 05 24 35 12 c0 	movzwl 0xc0123524,%eax
c0101af3:	0f b6 c0             	movzbl %al,%eax
c0101af6:	0f b7 15 26 35 12 c0 	movzwl 0xc0123526,%edx
c0101afd:	42                   	inc    %edx
c0101afe:	0f b7 d2             	movzwl %dx,%edx
c0101b01:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101b05:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101b08:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101b0c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b10:	ee                   	out    %al,(%dx)
}
c0101b11:	90                   	nop
c0101b12:	83 c4 34             	add    $0x34,%esp
c0101b15:	5b                   	pop    %ebx
c0101b16:	5d                   	pop    %ebp
c0101b17:	c3                   	ret    

c0101b18 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101b18:	55                   	push   %ebp
c0101b19:	89 e5                	mov    %esp,%ebp
c0101b1b:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b25:	eb 08                	jmp    c0101b2f <serial_putc_sub+0x17>
        delay();
c0101b27:	e8 3e fb ff ff       	call   c010166a <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b2c:	ff 45 fc             	incl   -0x4(%ebp)
c0101b2f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b35:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101b39:	89 c2                	mov    %eax,%edx
c0101b3b:	ec                   	in     (%dx),%al
c0101b3c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101b3f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101b43:	0f b6 c0             	movzbl %al,%eax
c0101b46:	83 e0 20             	and    $0x20,%eax
c0101b49:	85 c0                	test   %eax,%eax
c0101b4b:	75 09                	jne    c0101b56 <serial_putc_sub+0x3e>
c0101b4d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101b54:	7e d1                	jle    c0101b27 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b59:	0f b6 c0             	movzbl %al,%eax
c0101b5c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101b62:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b65:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101b69:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101b6d:	ee                   	out    %al,(%dx)
}
c0101b6e:	90                   	nop
c0101b6f:	c9                   	leave  
c0101b70:	c3                   	ret    

c0101b71 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101b71:	55                   	push   %ebp
c0101b72:	89 e5                	mov    %esp,%ebp
c0101b74:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101b77:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101b7b:	74 0d                	je     c0101b8a <serial_putc+0x19>
        serial_putc_sub(c);
c0101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b80:	89 04 24             	mov    %eax,(%esp)
c0101b83:	e8 90 ff ff ff       	call   c0101b18 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101b88:	eb 24                	jmp    c0101bae <serial_putc+0x3d>
        serial_putc_sub('\b');
c0101b8a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101b91:	e8 82 ff ff ff       	call   c0101b18 <serial_putc_sub>
        serial_putc_sub(' ');
c0101b96:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101b9d:	e8 76 ff ff ff       	call   c0101b18 <serial_putc_sub>
        serial_putc_sub('\b');
c0101ba2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101ba9:	e8 6a ff ff ff       	call   c0101b18 <serial_putc_sub>
}
c0101bae:	90                   	nop
c0101baf:	c9                   	leave  
c0101bb0:	c3                   	ret    

c0101bb1 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101bb1:	55                   	push   %ebp
c0101bb2:	89 e5                	mov    %esp,%ebp
c0101bb4:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101bb7:	eb 33                	jmp    c0101bec <cons_intr+0x3b>
        if (c != 0) {
c0101bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101bbd:	74 2d                	je     c0101bec <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101bbf:	a1 44 37 12 c0       	mov    0xc0123744,%eax
c0101bc4:	8d 50 01             	lea    0x1(%eax),%edx
c0101bc7:	89 15 44 37 12 c0    	mov    %edx,0xc0123744
c0101bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101bd0:	88 90 40 35 12 c0    	mov    %dl,-0x3fedcac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101bd6:	a1 44 37 12 c0       	mov    0xc0123744,%eax
c0101bdb:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101be0:	75 0a                	jne    c0101bec <cons_intr+0x3b>
                cons.wpos = 0;
c0101be2:	c7 05 44 37 12 c0 00 	movl   $0x0,0xc0123744
c0101be9:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bef:	ff d0                	call   *%eax
c0101bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101bf4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101bf8:	75 bf                	jne    c0101bb9 <cons_intr+0x8>
            }
        }
    }
}
c0101bfa:	90                   	nop
c0101bfb:	c9                   	leave  
c0101bfc:	c3                   	ret    

c0101bfd <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101bfd:	55                   	push   %ebp
c0101bfe:	89 e5                	mov    %esp,%ebp
c0101c00:	83 ec 10             	sub    $0x10,%esp
c0101c03:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c09:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c0d:	89 c2                	mov    %eax,%edx
c0101c0f:	ec                   	in     (%dx),%al
c0101c10:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101c13:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101c17:	0f b6 c0             	movzbl %al,%eax
c0101c1a:	83 e0 01             	and    $0x1,%eax
c0101c1d:	85 c0                	test   %eax,%eax
c0101c1f:	75 07                	jne    c0101c28 <serial_proc_data+0x2b>
        return -1;
c0101c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c26:	eb 2a                	jmp    c0101c52 <serial_proc_data+0x55>
c0101c28:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c2e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101c32:	89 c2                	mov    %eax,%edx
c0101c34:	ec                   	in     (%dx),%al
c0101c35:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101c38:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c3c:	0f b6 c0             	movzbl %al,%eax
c0101c3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101c42:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101c46:	75 07                	jne    c0101c4f <serial_proc_data+0x52>
        c = '\b';
c0101c48:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101c52:	c9                   	leave  
c0101c53:	c3                   	ret    

c0101c54 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101c54:	55                   	push   %ebp
c0101c55:	89 e5                	mov    %esp,%ebp
c0101c57:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101c5a:	a1 28 35 12 c0       	mov    0xc0123528,%eax
c0101c5f:	85 c0                	test   %eax,%eax
c0101c61:	74 0c                	je     c0101c6f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101c63:	c7 04 24 fd 1b 10 c0 	movl   $0xc0101bfd,(%esp)
c0101c6a:	e8 42 ff ff ff       	call   c0101bb1 <cons_intr>
    }
}
c0101c6f:	90                   	nop
c0101c70:	c9                   	leave  
c0101c71:	c3                   	ret    

c0101c72 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101c72:	55                   	push   %ebp
c0101c73:	89 e5                	mov    %esp,%ebp
c0101c75:	83 ec 38             	sub    $0x38,%esp
c0101c78:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c81:	89 c2                	mov    %eax,%edx
c0101c83:	ec                   	in     (%dx),%al
c0101c84:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101c87:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101c8b:	0f b6 c0             	movzbl %al,%eax
c0101c8e:	83 e0 01             	and    $0x1,%eax
c0101c91:	85 c0                	test   %eax,%eax
c0101c93:	75 0a                	jne    c0101c9f <kbd_proc_data+0x2d>
        return -1;
c0101c95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c9a:	e9 55 01 00 00       	jmp    c0101df4 <kbd_proc_data+0x182>
c0101c9f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101ca8:	89 c2                	mov    %eax,%edx
c0101caa:	ec                   	in     (%dx),%al
c0101cab:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101cae:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101cb2:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101cb5:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101cb9:	75 17                	jne    c0101cd2 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101cbb:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101cc0:	83 c8 40             	or     $0x40,%eax
c0101cc3:	a3 48 37 12 c0       	mov    %eax,0xc0123748
        return 0;
c0101cc8:	b8 00 00 00 00       	mov    $0x0,%eax
c0101ccd:	e9 22 01 00 00       	jmp    c0101df4 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c0101cd2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cd6:	84 c0                	test   %al,%al
c0101cd8:	79 45                	jns    c0101d1f <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101cda:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101cdf:	83 e0 40             	and    $0x40,%eax
c0101ce2:	85 c0                	test   %eax,%eax
c0101ce4:	75 08                	jne    c0101cee <kbd_proc_data+0x7c>
c0101ce6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cea:	24 7f                	and    $0x7f,%al
c0101cec:	eb 04                	jmp    c0101cf2 <kbd_proc_data+0x80>
c0101cee:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cf2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101cf5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cf9:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c0101d00:	0c 40                	or     $0x40,%al
c0101d02:	0f b6 c0             	movzbl %al,%eax
c0101d05:	f7 d0                	not    %eax
c0101d07:	89 c2                	mov    %eax,%edx
c0101d09:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d0e:	21 d0                	and    %edx,%eax
c0101d10:	a3 48 37 12 c0       	mov    %eax,0xc0123748
        return 0;
c0101d15:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d1a:	e9 d5 00 00 00       	jmp    c0101df4 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c0101d1f:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d24:	83 e0 40             	and    $0x40,%eax
c0101d27:	85 c0                	test   %eax,%eax
c0101d29:	74 11                	je     c0101d3c <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d2b:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d2f:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d34:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d37:	a3 48 37 12 c0       	mov    %eax,0xc0123748
    }

    shift |= shiftcode[data];
c0101d3c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d40:	0f b6 80 40 00 12 c0 	movzbl -0x3fedffc0(%eax),%eax
c0101d47:	0f b6 d0             	movzbl %al,%edx
c0101d4a:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d4f:	09 d0                	or     %edx,%eax
c0101d51:	a3 48 37 12 c0       	mov    %eax,0xc0123748
    shift ^= togglecode[data];
c0101d56:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d5a:	0f b6 80 40 01 12 c0 	movzbl -0x3fedfec0(%eax),%eax
c0101d61:	0f b6 d0             	movzbl %al,%edx
c0101d64:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d69:	31 d0                	xor    %edx,%eax
c0101d6b:	a3 48 37 12 c0       	mov    %eax,0xc0123748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101d70:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d75:	83 e0 03             	and    $0x3,%eax
c0101d78:	8b 14 85 40 05 12 c0 	mov    -0x3fedfac0(,%eax,4),%edx
c0101d7f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d83:	01 d0                	add    %edx,%eax
c0101d85:	0f b6 00             	movzbl (%eax),%eax
c0101d88:	0f b6 c0             	movzbl %al,%eax
c0101d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101d8e:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101d93:	83 e0 08             	and    $0x8,%eax
c0101d96:	85 c0                	test   %eax,%eax
c0101d98:	74 22                	je     c0101dbc <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101d9a:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101d9e:	7e 0c                	jle    c0101dac <kbd_proc_data+0x13a>
c0101da0:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101da4:	7f 06                	jg     c0101dac <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101da6:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101daa:	eb 10                	jmp    c0101dbc <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101dac:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101db0:	7e 0a                	jle    c0101dbc <kbd_proc_data+0x14a>
c0101db2:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101db6:	7f 04                	jg     c0101dbc <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101db8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101dbc:	a1 48 37 12 c0       	mov    0xc0123748,%eax
c0101dc1:	f7 d0                	not    %eax
c0101dc3:	83 e0 06             	and    $0x6,%eax
c0101dc6:	85 c0                	test   %eax,%eax
c0101dc8:	75 27                	jne    c0101df1 <kbd_proc_data+0x17f>
c0101dca:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101dd1:	75 1e                	jne    c0101df1 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c0101dd3:	c7 04 24 35 92 10 c0 	movl   $0xc0109235,(%esp)
c0101dda:	e8 cd e4 ff ff       	call   c01002ac <cprintf>
c0101ddf:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101de5:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101de9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101ded:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101df0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101df4:	c9                   	leave  
c0101df5:	c3                   	ret    

c0101df6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101df6:	55                   	push   %ebp
c0101df7:	89 e5                	mov    %esp,%ebp
c0101df9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101dfc:	c7 04 24 72 1c 10 c0 	movl   $0xc0101c72,(%esp)
c0101e03:	e8 a9 fd ff ff       	call   c0101bb1 <cons_intr>
}
c0101e08:	90                   	nop
c0101e09:	c9                   	leave  
c0101e0a:	c3                   	ret    

c0101e0b <kbd_init>:

static void
kbd_init(void) {
c0101e0b:	55                   	push   %ebp
c0101e0c:	89 e5                	mov    %esp,%ebp
c0101e0e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101e11:	e8 e0 ff ff ff       	call   c0101df6 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101e16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101e1d:	e8 35 01 00 00       	call   c0101f57 <pic_enable>
}
c0101e22:	90                   	nop
c0101e23:	c9                   	leave  
c0101e24:	c3                   	ret    

c0101e25 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e25:	55                   	push   %ebp
c0101e26:	89 e5                	mov    %esp,%ebp
c0101e28:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101e2b:	e8 83 f8 ff ff       	call   c01016b3 <cga_init>
    serial_init();
c0101e30:	e8 62 f9 ff ff       	call   c0101797 <serial_init>
    kbd_init();
c0101e35:	e8 d1 ff ff ff       	call   c0101e0b <kbd_init>
    if (!serial_exists) {
c0101e3a:	a1 28 35 12 c0       	mov    0xc0123528,%eax
c0101e3f:	85 c0                	test   %eax,%eax
c0101e41:	75 0c                	jne    c0101e4f <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101e43:	c7 04 24 41 92 10 c0 	movl   $0xc0109241,(%esp)
c0101e4a:	e8 5d e4 ff ff       	call   c01002ac <cprintf>
    }
}
c0101e4f:	90                   	nop
c0101e50:	c9                   	leave  
c0101e51:	c3                   	ret    

c0101e52 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101e52:	55                   	push   %ebp
c0101e53:	89 e5                	mov    %esp,%ebp
c0101e55:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e58:	e8 cf f7 ff ff       	call   c010162c <__intr_save>
c0101e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e63:	89 04 24             	mov    %eax,(%esp)
c0101e66:	e8 89 fa ff ff       	call   c01018f4 <lpt_putc>
        cga_putc(c);
c0101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6e:	89 04 24             	mov    %eax,(%esp)
c0101e71:	e8 be fa ff ff       	call   c0101934 <cga_putc>
        serial_putc(c);
c0101e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e79:	89 04 24             	mov    %eax,(%esp)
c0101e7c:	e8 f0 fc ff ff       	call   c0101b71 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101e84:	89 04 24             	mov    %eax,(%esp)
c0101e87:	e8 ca f7 ff ff       	call   c0101656 <__intr_restore>
}
c0101e8c:	90                   	nop
c0101e8d:	c9                   	leave  
c0101e8e:	c3                   	ret    

c0101e8f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101e8f:	55                   	push   %ebp
c0101e90:	89 e5                	mov    %esp,%ebp
c0101e92:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e9c:	e8 8b f7 ff ff       	call   c010162c <__intr_save>
c0101ea1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101ea4:	e8 ab fd ff ff       	call   c0101c54 <serial_intr>
        kbd_intr();
c0101ea9:	e8 48 ff ff ff       	call   c0101df6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101eae:	8b 15 40 37 12 c0    	mov    0xc0123740,%edx
c0101eb4:	a1 44 37 12 c0       	mov    0xc0123744,%eax
c0101eb9:	39 c2                	cmp    %eax,%edx
c0101ebb:	74 31                	je     c0101eee <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101ebd:	a1 40 37 12 c0       	mov    0xc0123740,%eax
c0101ec2:	8d 50 01             	lea    0x1(%eax),%edx
c0101ec5:	89 15 40 37 12 c0    	mov    %edx,0xc0123740
c0101ecb:	0f b6 80 40 35 12 c0 	movzbl -0x3fedcac0(%eax),%eax
c0101ed2:	0f b6 c0             	movzbl %al,%eax
c0101ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101ed8:	a1 40 37 12 c0       	mov    0xc0123740,%eax
c0101edd:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101ee2:	75 0a                	jne    c0101eee <cons_getc+0x5f>
                cons.rpos = 0;
c0101ee4:	c7 05 40 37 12 c0 00 	movl   $0x0,0xc0123740
c0101eeb:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ef1:	89 04 24             	mov    %eax,(%esp)
c0101ef4:	e8 5d f7 ff ff       	call   c0101656 <__intr_restore>
    return c;
c0101ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101efc:	c9                   	leave  
c0101efd:	c3                   	ret    

c0101efe <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101efe:	55                   	push   %ebp
c0101eff:	89 e5                	mov    %esp,%ebp
c0101f01:	83 ec 14             	sub    $0x14,%esp
c0101f04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f07:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f0e:	66 a3 50 05 12 c0    	mov    %ax,0xc0120550
    if (did_init) {
c0101f14:	a1 4c 37 12 c0       	mov    0xc012374c,%eax
c0101f19:	85 c0                	test   %eax,%eax
c0101f1b:	74 37                	je     c0101f54 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101f20:	0f b6 c0             	movzbl %al,%eax
c0101f23:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101f29:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f2c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f30:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f34:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f35:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f39:	c1 e8 08             	shr    $0x8,%eax
c0101f3c:	0f b7 c0             	movzwl %ax,%eax
c0101f3f:	0f b6 c0             	movzbl %al,%eax
c0101f42:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101f48:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101f4b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f4f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f53:	ee                   	out    %al,(%dx)
    }
}
c0101f54:	90                   	nop
c0101f55:	c9                   	leave  
c0101f56:	c3                   	ret    

c0101f57 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f57:	55                   	push   %ebp
c0101f58:	89 e5                	mov    %esp,%ebp
c0101f5a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f60:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f65:	88 c1                	mov    %al,%cl
c0101f67:	d3 e2                	shl    %cl,%edx
c0101f69:	89 d0                	mov    %edx,%eax
c0101f6b:	98                   	cwtl   
c0101f6c:	f7 d0                	not    %eax
c0101f6e:	0f bf d0             	movswl %ax,%edx
c0101f71:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c0101f78:	98                   	cwtl   
c0101f79:	21 d0                	and    %edx,%eax
c0101f7b:	98                   	cwtl   
c0101f7c:	0f b7 c0             	movzwl %ax,%eax
c0101f7f:	89 04 24             	mov    %eax,(%esp)
c0101f82:	e8 77 ff ff ff       	call   c0101efe <pic_setmask>
}
c0101f87:	90                   	nop
c0101f88:	c9                   	leave  
c0101f89:	c3                   	ret    

c0101f8a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101f8a:	55                   	push   %ebp
c0101f8b:	89 e5                	mov    %esp,%ebp
c0101f8d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101f90:	c7 05 4c 37 12 c0 01 	movl   $0x1,0xc012374c
c0101f97:	00 00 00 
c0101f9a:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101fa0:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101fa4:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101fa8:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101fac:	ee                   	out    %al,(%dx)
c0101fad:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101fb3:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101fb7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101fbb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101fbf:	ee                   	out    %al,(%dx)
c0101fc0:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101fc6:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101fca:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101fce:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101fd2:	ee                   	out    %al,(%dx)
c0101fd3:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101fd9:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101fdd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101fe1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fe5:	ee                   	out    %al,(%dx)
c0101fe6:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101fec:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c0101ff0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101ff4:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101ff8:	ee                   	out    %al,(%dx)
c0101ff9:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101fff:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c0102003:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102007:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010200b:	ee                   	out    %al,(%dx)
c010200c:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0102012:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c0102016:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010201a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010201e:	ee                   	out    %al,(%dx)
c010201f:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0102025:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c0102029:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010202d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102031:	ee                   	out    %al,(%dx)
c0102032:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0102038:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c010203c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102040:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102044:	ee                   	out    %al,(%dx)
c0102045:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010204b:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c010204f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102053:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102057:	ee                   	out    %al,(%dx)
c0102058:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c010205e:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0102062:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102066:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010206a:	ee                   	out    %al,(%dx)
c010206b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102071:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0102075:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102079:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010207d:	ee                   	out    %al,(%dx)
c010207e:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0102084:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0102088:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010208c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102090:	ee                   	out    %al,(%dx)
c0102091:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0102097:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c010209b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010209f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020a3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020a4:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c01020ab:	3d ff ff 00 00       	cmp    $0xffff,%eax
c01020b0:	74 0f                	je     c01020c1 <pic_init+0x137>
        pic_setmask(irq_mask);
c01020b2:	0f b7 05 50 05 12 c0 	movzwl 0xc0120550,%eax
c01020b9:	89 04 24             	mov    %eax,(%esp)
c01020bc:	e8 3d fe ff ff       	call   c0101efe <pic_setmask>
    }
}
c01020c1:	90                   	nop
c01020c2:	c9                   	leave  
c01020c3:	c3                   	ret    

c01020c4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01020c4:	55                   	push   %ebp
c01020c5:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c01020c7:	fb                   	sti    
    sti();
}
c01020c8:	90                   	nop
c01020c9:	5d                   	pop    %ebp
c01020ca:	c3                   	ret    

c01020cb <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01020cb:	55                   	push   %ebp
c01020cc:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01020ce:	fa                   	cli    
    cli();
}
c01020cf:	90                   	nop
c01020d0:	5d                   	pop    %ebp
c01020d1:	c3                   	ret    

c01020d2 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020d2:	55                   	push   %ebp
c01020d3:	89 e5                	mov    %esp,%ebp
c01020d5:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020d8:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01020df:	00 
c01020e0:	c7 04 24 60 92 10 c0 	movl   $0xc0109260,(%esp)
c01020e7:	e8 c0 e1 ff ff       	call   c01002ac <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01020ec:	c7 04 24 6a 92 10 c0 	movl   $0xc010926a,(%esp)
c01020f3:	e8 b4 e1 ff ff       	call   c01002ac <cprintf>
    panic("EOT: kernel seems ok.");
c01020f8:	c7 44 24 08 78 92 10 	movl   $0xc0109278,0x8(%esp)
c01020ff:	c0 
c0102100:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0102107:	00 
c0102108:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c010210f:	e8 ef e2 ff ff       	call   c0100403 <__panic>

c0102114 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102114:	55                   	push   %ebp
c0102115:	89 e5                	mov    %esp,%ebp
c0102117:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];

    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c010211a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102121:	e9 c4 00 00 00       	jmp    c01021ea <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102126:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102129:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c0102130:	0f b7 d0             	movzwl %ax,%edx
c0102133:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102136:	66 89 14 c5 60 37 12 	mov    %dx,-0x3fedc8a0(,%eax,8)
c010213d:	c0 
c010213e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102141:	66 c7 04 c5 62 37 12 	movw   $0x8,-0x3fedc89e(,%eax,8)
c0102148:	c0 08 00 
c010214b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010214e:	0f b6 14 c5 64 37 12 	movzbl -0x3fedc89c(,%eax,8),%edx
c0102155:	c0 
c0102156:	80 e2 e0             	and    $0xe0,%dl
c0102159:	88 14 c5 64 37 12 c0 	mov    %dl,-0x3fedc89c(,%eax,8)
c0102160:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102163:	0f b6 14 c5 64 37 12 	movzbl -0x3fedc89c(,%eax,8),%edx
c010216a:	c0 
c010216b:	80 e2 1f             	and    $0x1f,%dl
c010216e:	88 14 c5 64 37 12 c0 	mov    %dl,-0x3fedc89c(,%eax,8)
c0102175:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102178:	0f b6 14 c5 65 37 12 	movzbl -0x3fedc89b(,%eax,8),%edx
c010217f:	c0 
c0102180:	80 e2 f0             	and    $0xf0,%dl
c0102183:	80 ca 0e             	or     $0xe,%dl
c0102186:	88 14 c5 65 37 12 c0 	mov    %dl,-0x3fedc89b(,%eax,8)
c010218d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102190:	0f b6 14 c5 65 37 12 	movzbl -0x3fedc89b(,%eax,8),%edx
c0102197:	c0 
c0102198:	80 e2 ef             	and    $0xef,%dl
c010219b:	88 14 c5 65 37 12 c0 	mov    %dl,-0x3fedc89b(,%eax,8)
c01021a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a5:	0f b6 14 c5 65 37 12 	movzbl -0x3fedc89b(,%eax,8),%edx
c01021ac:	c0 
c01021ad:	80 e2 9f             	and    $0x9f,%dl
c01021b0:	88 14 c5 65 37 12 c0 	mov    %dl,-0x3fedc89b(,%eax,8)
c01021b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ba:	0f b6 14 c5 65 37 12 	movzbl -0x3fedc89b(,%eax,8),%edx
c01021c1:	c0 
c01021c2:	80 ca 80             	or     $0x80,%dl
c01021c5:	88 14 c5 65 37 12 c0 	mov    %dl,-0x3fedc89b(,%eax,8)
c01021cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021cf:	8b 04 85 e0 05 12 c0 	mov    -0x3fedfa20(,%eax,4),%eax
c01021d6:	c1 e8 10             	shr    $0x10,%eax
c01021d9:	0f b7 d0             	movzwl %ax,%edx
c01021dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021df:	66 89 14 c5 66 37 12 	mov    %dx,-0x3fedc89a(,%eax,8)
c01021e6:	c0 
    for (int i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
c01021e7:	ff 45 fc             	incl   -0x4(%ebp)
c01021ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ed:	3d ff 00 00 00       	cmp    $0xff,%eax
c01021f2:	0f 86 2e ff ff ff    	jbe    c0102126 <idt_init+0x12>
    }

    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01021f8:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c01021fd:	0f b7 c0             	movzwl %ax,%eax
c0102200:	66 a3 28 3b 12 c0    	mov    %ax,0xc0123b28
c0102206:	66 c7 05 2a 3b 12 c0 	movw   $0x8,0xc0123b2a
c010220d:	08 00 
c010220f:	0f b6 05 2c 3b 12 c0 	movzbl 0xc0123b2c,%eax
c0102216:	24 e0                	and    $0xe0,%al
c0102218:	a2 2c 3b 12 c0       	mov    %al,0xc0123b2c
c010221d:	0f b6 05 2c 3b 12 c0 	movzbl 0xc0123b2c,%eax
c0102224:	24 1f                	and    $0x1f,%al
c0102226:	a2 2c 3b 12 c0       	mov    %al,0xc0123b2c
c010222b:	0f b6 05 2d 3b 12 c0 	movzbl 0xc0123b2d,%eax
c0102232:	24 f0                	and    $0xf0,%al
c0102234:	0c 0e                	or     $0xe,%al
c0102236:	a2 2d 3b 12 c0       	mov    %al,0xc0123b2d
c010223b:	0f b6 05 2d 3b 12 c0 	movzbl 0xc0123b2d,%eax
c0102242:	24 ef                	and    $0xef,%al
c0102244:	a2 2d 3b 12 c0       	mov    %al,0xc0123b2d
c0102249:	0f b6 05 2d 3b 12 c0 	movzbl 0xc0123b2d,%eax
c0102250:	0c 60                	or     $0x60,%al
c0102252:	a2 2d 3b 12 c0       	mov    %al,0xc0123b2d
c0102257:	0f b6 05 2d 3b 12 c0 	movzbl 0xc0123b2d,%eax
c010225e:	0c 80                	or     $0x80,%al
c0102260:	a2 2d 3b 12 c0       	mov    %al,0xc0123b2d
c0102265:	a1 c4 07 12 c0       	mov    0xc01207c4,%eax
c010226a:	c1 e8 10             	shr    $0x10,%eax
c010226d:	0f b7 c0             	movzwl %ax,%eax
c0102270:	66 a3 2e 3b 12 c0    	mov    %ax,0xc0123b2e
c0102276:	c7 45 f8 60 05 12 c0 	movl   $0xc0120560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010227d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102280:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd);
}
c0102283:	90                   	nop
c0102284:	c9                   	leave  
c0102285:	c3                   	ret    

c0102286 <trapname>:

static const char *
trapname(int trapno) {
c0102286:	55                   	push   %ebp
c0102287:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102289:	8b 45 08             	mov    0x8(%ebp),%eax
c010228c:	83 f8 13             	cmp    $0x13,%eax
c010228f:	77 0c                	ja     c010229d <trapname+0x17>
        return excnames[trapno];
c0102291:	8b 45 08             	mov    0x8(%ebp),%eax
c0102294:	8b 04 85 40 96 10 c0 	mov    -0x3fef69c0(,%eax,4),%eax
c010229b:	eb 18                	jmp    c01022b5 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010229d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01022a1:	7e 0d                	jle    c01022b0 <trapname+0x2a>
c01022a3:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01022a7:	7f 07                	jg     c01022b0 <trapname+0x2a>
        return "Hardware Interrupt";
c01022a9:	b8 9f 92 10 c0       	mov    $0xc010929f,%eax
c01022ae:	eb 05                	jmp    c01022b5 <trapname+0x2f>
    }
    return "(unknown trap)";
c01022b0:	b8 b2 92 10 c0       	mov    $0xc01092b2,%eax
}
c01022b5:	5d                   	pop    %ebp
c01022b6:	c3                   	ret    

c01022b7 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01022b7:	55                   	push   %ebp
c01022b8:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01022ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01022bd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01022c1:	83 f8 08             	cmp    $0x8,%eax
c01022c4:	0f 94 c0             	sete   %al
c01022c7:	0f b6 c0             	movzbl %al,%eax
}
c01022ca:	5d                   	pop    %ebp
c01022cb:	c3                   	ret    

c01022cc <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01022cc:	55                   	push   %ebp
c01022cd:	89 e5                	mov    %esp,%ebp
c01022cf:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01022d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022d9:	c7 04 24 f3 92 10 c0 	movl   $0xc01092f3,(%esp)
c01022e0:	e8 c7 df ff ff       	call   c01002ac <cprintf>
    print_regs(&tf->tf_regs);
c01022e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e8:	89 04 24             	mov    %eax,(%esp)
c01022eb:	e8 8f 01 00 00       	call   c010247f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022fb:	c7 04 24 04 93 10 c0 	movl   $0xc0109304,(%esp)
c0102302:	e8 a5 df ff ff       	call   c01002ac <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102307:	8b 45 08             	mov    0x8(%ebp),%eax
c010230a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010230e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102312:	c7 04 24 17 93 10 c0 	movl   $0xc0109317,(%esp)
c0102319:	e8 8e df ff ff       	call   c01002ac <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010231e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102321:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102325:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102329:	c7 04 24 2a 93 10 c0 	movl   $0xc010932a,(%esp)
c0102330:	e8 77 df ff ff       	call   c01002ac <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102335:	8b 45 08             	mov    0x8(%ebp),%eax
c0102338:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010233c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102340:	c7 04 24 3d 93 10 c0 	movl   $0xc010933d,(%esp)
c0102347:	e8 60 df ff ff       	call   c01002ac <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010234c:	8b 45 08             	mov    0x8(%ebp),%eax
c010234f:	8b 40 30             	mov    0x30(%eax),%eax
c0102352:	89 04 24             	mov    %eax,(%esp)
c0102355:	e8 2c ff ff ff       	call   c0102286 <trapname>
c010235a:	89 c2                	mov    %eax,%edx
c010235c:	8b 45 08             	mov    0x8(%ebp),%eax
c010235f:	8b 40 30             	mov    0x30(%eax),%eax
c0102362:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010236a:	c7 04 24 50 93 10 c0 	movl   $0xc0109350,(%esp)
c0102371:	e8 36 df ff ff       	call   c01002ac <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102376:	8b 45 08             	mov    0x8(%ebp),%eax
c0102379:	8b 40 34             	mov    0x34(%eax),%eax
c010237c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102380:	c7 04 24 62 93 10 c0 	movl   $0xc0109362,(%esp)
c0102387:	e8 20 df ff ff       	call   c01002ac <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010238c:	8b 45 08             	mov    0x8(%ebp),%eax
c010238f:	8b 40 38             	mov    0x38(%eax),%eax
c0102392:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102396:	c7 04 24 71 93 10 c0 	movl   $0xc0109371,(%esp)
c010239d:	e8 0a df ff ff       	call   c01002ac <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01023a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023ad:	c7 04 24 80 93 10 c0 	movl   $0xc0109380,(%esp)
c01023b4:	e8 f3 de ff ff       	call   c01002ac <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01023b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023bc:	8b 40 40             	mov    0x40(%eax),%eax
c01023bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c3:	c7 04 24 93 93 10 c0 	movl   $0xc0109393,(%esp)
c01023ca:	e8 dd de ff ff       	call   c01002ac <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023d6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023dd:	eb 3d                	jmp    c010241c <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023df:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e2:	8b 50 40             	mov    0x40(%eax),%edx
c01023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023e8:	21 d0                	and    %edx,%eax
c01023ea:	85 c0                	test   %eax,%eax
c01023ec:	74 28                	je     c0102416 <print_trapframe+0x14a>
c01023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023f1:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c01023f8:	85 c0                	test   %eax,%eax
c01023fa:	74 1a                	je     c0102416 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c01023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023ff:	8b 04 85 80 05 12 c0 	mov    -0x3fedfa80(,%eax,4),%eax
c0102406:	89 44 24 04          	mov    %eax,0x4(%esp)
c010240a:	c7 04 24 a2 93 10 c0 	movl   $0xc01093a2,(%esp)
c0102411:	e8 96 de ff ff       	call   c01002ac <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102416:	ff 45 f4             	incl   -0xc(%ebp)
c0102419:	d1 65 f0             	shll   -0x10(%ebp)
c010241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010241f:	83 f8 17             	cmp    $0x17,%eax
c0102422:	76 bb                	jbe    c01023df <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102424:	8b 45 08             	mov    0x8(%ebp),%eax
c0102427:	8b 40 40             	mov    0x40(%eax),%eax
c010242a:	c1 e8 0c             	shr    $0xc,%eax
c010242d:	83 e0 03             	and    $0x3,%eax
c0102430:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102434:	c7 04 24 a6 93 10 c0 	movl   $0xc01093a6,(%esp)
c010243b:	e8 6c de ff ff       	call   c01002ac <cprintf>

    if (!trap_in_kernel(tf)) {
c0102440:	8b 45 08             	mov    0x8(%ebp),%eax
c0102443:	89 04 24             	mov    %eax,(%esp)
c0102446:	e8 6c fe ff ff       	call   c01022b7 <trap_in_kernel>
c010244b:	85 c0                	test   %eax,%eax
c010244d:	75 2d                	jne    c010247c <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010244f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102452:	8b 40 44             	mov    0x44(%eax),%eax
c0102455:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102459:	c7 04 24 af 93 10 c0 	movl   $0xc01093af,(%esp)
c0102460:	e8 47 de ff ff       	call   c01002ac <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102465:	8b 45 08             	mov    0x8(%ebp),%eax
c0102468:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010246c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102470:	c7 04 24 be 93 10 c0 	movl   $0xc01093be,(%esp)
c0102477:	e8 30 de ff ff       	call   c01002ac <cprintf>
    }
}
c010247c:	90                   	nop
c010247d:	c9                   	leave  
c010247e:	c3                   	ret    

c010247f <print_regs>:

void
print_regs(struct pushregs *regs) {
c010247f:	55                   	push   %ebp
c0102480:	89 e5                	mov    %esp,%ebp
c0102482:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102485:	8b 45 08             	mov    0x8(%ebp),%eax
c0102488:	8b 00                	mov    (%eax),%eax
c010248a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248e:	c7 04 24 d1 93 10 c0 	movl   $0xc01093d1,(%esp)
c0102495:	e8 12 de ff ff       	call   c01002ac <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c010249a:	8b 45 08             	mov    0x8(%ebp),%eax
c010249d:	8b 40 04             	mov    0x4(%eax),%eax
c01024a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a4:	c7 04 24 e0 93 10 c0 	movl   $0xc01093e0,(%esp)
c01024ab:	e8 fc dd ff ff       	call   c01002ac <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01024b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b3:	8b 40 08             	mov    0x8(%eax),%eax
c01024b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ba:	c7 04 24 ef 93 10 c0 	movl   $0xc01093ef,(%esp)
c01024c1:	e8 e6 dd ff ff       	call   c01002ac <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c9:	8b 40 0c             	mov    0xc(%eax),%eax
c01024cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d0:	c7 04 24 fe 93 10 c0 	movl   $0xc01093fe,(%esp)
c01024d7:	e8 d0 dd ff ff       	call   c01002ac <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024df:	8b 40 10             	mov    0x10(%eax),%eax
c01024e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e6:	c7 04 24 0d 94 10 c0 	movl   $0xc010940d,(%esp)
c01024ed:	e8 ba dd ff ff       	call   c01002ac <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01024f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f5:	8b 40 14             	mov    0x14(%eax),%eax
c01024f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fc:	c7 04 24 1c 94 10 c0 	movl   $0xc010941c,(%esp)
c0102503:	e8 a4 dd ff ff       	call   c01002ac <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102508:	8b 45 08             	mov    0x8(%ebp),%eax
c010250b:	8b 40 18             	mov    0x18(%eax),%eax
c010250e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102512:	c7 04 24 2b 94 10 c0 	movl   $0xc010942b,(%esp)
c0102519:	e8 8e dd ff ff       	call   c01002ac <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010251e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102521:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102524:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102528:	c7 04 24 3a 94 10 c0 	movl   $0xc010943a,(%esp)
c010252f:	e8 78 dd ff ff       	call   c01002ac <cprintf>
}
c0102534:	90                   	nop
c0102535:	c9                   	leave  
c0102536:	c3                   	ret    

c0102537 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102537:	55                   	push   %ebp
c0102538:	89 e5                	mov    %esp,%ebp
c010253a:	53                   	push   %ebx
c010253b:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010253e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102541:	8b 40 34             	mov    0x34(%eax),%eax
c0102544:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102547:	85 c0                	test   %eax,%eax
c0102549:	74 07                	je     c0102552 <print_pgfault+0x1b>
c010254b:	bb 49 94 10 c0       	mov    $0xc0109449,%ebx
c0102550:	eb 05                	jmp    c0102557 <print_pgfault+0x20>
c0102552:	bb 5a 94 10 c0       	mov    $0xc010945a,%ebx
            (tf->tf_err & 2) ? 'W' : 'R',
c0102557:	8b 45 08             	mov    0x8(%ebp),%eax
c010255a:	8b 40 34             	mov    0x34(%eax),%eax
c010255d:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102560:	85 c0                	test   %eax,%eax
c0102562:	74 07                	je     c010256b <print_pgfault+0x34>
c0102564:	b9 57 00 00 00       	mov    $0x57,%ecx
c0102569:	eb 05                	jmp    c0102570 <print_pgfault+0x39>
c010256b:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102570:	8b 45 08             	mov    0x8(%ebp),%eax
c0102573:	8b 40 34             	mov    0x34(%eax),%eax
c0102576:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102579:	85 c0                	test   %eax,%eax
c010257b:	74 07                	je     c0102584 <print_pgfault+0x4d>
c010257d:	ba 55 00 00 00       	mov    $0x55,%edx
c0102582:	eb 05                	jmp    c0102589 <print_pgfault+0x52>
c0102584:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102589:	0f 20 d0             	mov    %cr2,%eax
c010258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102592:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0102596:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010259a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010259e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025a2:	c7 04 24 68 94 10 c0 	movl   $0xc0109468,(%esp)
c01025a9:	e8 fe dc ff ff       	call   c01002ac <cprintf>
}
c01025ae:	90                   	nop
c01025af:	83 c4 34             	add    $0x34,%esp
c01025b2:	5b                   	pop    %ebx
c01025b3:	5d                   	pop    %ebp
c01025b4:	c3                   	ret    

c01025b5 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01025b5:	55                   	push   %ebp
c01025b6:	89 e5                	mov    %esp,%ebp
c01025b8:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01025bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01025be:	89 04 24             	mov    %eax,(%esp)
c01025c1:	e8 71 ff ff ff       	call   c0102537 <print_pgfault>
    if (check_mm_struct != NULL) {
c01025c6:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c01025cb:	85 c0                	test   %eax,%eax
c01025cd:	74 26                	je     c01025f5 <pgfault_handler+0x40>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025cf:	0f 20 d0             	mov    %cr2,%eax
c01025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01025db:	8b 50 34             	mov    0x34(%eax),%edx
c01025de:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c01025e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01025eb:	89 04 24             	mov    %eax,(%esp)
c01025ee:	e8 e1 18 00 00       	call   c0103ed4 <do_pgfault>
c01025f3:	eb 1c                	jmp    c0102611 <pgfault_handler+0x5c>
    }
    panic("unhandled page fault.\n");
c01025f5:	c7 44 24 08 8b 94 10 	movl   $0xc010948b,0x8(%esp)
c01025fc:	c0 
c01025fd:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0102604:	00 
c0102605:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c010260c:	e8 f2 dd ff ff       	call   c0100403 <__panic>
}
c0102611:	c9                   	leave  
c0102612:	c3                   	ret    

c0102613 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102613:	55                   	push   %ebp
c0102614:	89 e5                	mov    %esp,%ebp
c0102616:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102619:	8b 45 08             	mov    0x8(%ebp),%eax
c010261c:	8b 40 30             	mov    0x30(%eax),%eax
c010261f:	83 f8 24             	cmp    $0x24,%eax
c0102622:	0f 84 da 00 00 00    	je     c0102702 <trap_dispatch+0xef>
c0102628:	83 f8 24             	cmp    $0x24,%eax
c010262b:	77 1c                	ja     c0102649 <trap_dispatch+0x36>
c010262d:	83 f8 20             	cmp    $0x20,%eax
c0102630:	0f 84 86 00 00 00    	je     c01026bc <trap_dispatch+0xa9>
c0102636:	83 f8 21             	cmp    $0x21,%eax
c0102639:	0f 84 ec 00 00 00    	je     c010272b <trap_dispatch+0x118>
c010263f:	83 f8 0e             	cmp    $0xe,%eax
c0102642:	74 32                	je     c0102676 <trap_dispatch+0x63>
c0102644:	e9 25 02 00 00       	jmp    c010286e <trap_dispatch+0x25b>
c0102649:	83 f8 78             	cmp    $0x78,%eax
c010264c:	0f 84 a0 01 00 00    	je     c01027f2 <trap_dispatch+0x1df>
c0102652:	83 f8 78             	cmp    $0x78,%eax
c0102655:	77 11                	ja     c0102668 <trap_dispatch+0x55>
c0102657:	83 e8 2e             	sub    $0x2e,%eax
c010265a:	83 f8 01             	cmp    $0x1,%eax
c010265d:	0f 87 0b 02 00 00    	ja     c010286e <trap_dispatch+0x25b>
        tf->tf_eflags &= ~FL_IOPL_MASK;
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102663:	e9 42 02 00 00       	jmp    c01028aa <trap_dispatch+0x297>
    switch (tf->tf_trapno) {
c0102668:	83 f8 79             	cmp    $0x79,%eax
c010266b:	0f 84 c4 01 00 00    	je     c0102835 <trap_dispatch+0x222>
c0102671:	e9 f8 01 00 00       	jmp    c010286e <trap_dispatch+0x25b>
        if ((ret = pgfault_handler(tf)) != 0) {
c0102676:	8b 45 08             	mov    0x8(%ebp),%eax
c0102679:	89 04 24             	mov    %eax,(%esp)
c010267c:	e8 34 ff ff ff       	call   c01025b5 <pgfault_handler>
c0102681:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102684:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102688:	0f 84 15 02 00 00    	je     c01028a3 <trap_dispatch+0x290>
            print_trapframe(tf);
c010268e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102691:	89 04 24             	mov    %eax,(%esp)
c0102694:	e8 33 fc ff ff       	call   c01022cc <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102699:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010269c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026a0:	c7 44 24 08 a2 94 10 	movl   $0xc01094a2,0x8(%esp)
c01026a7:	c0 
c01026a8:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c01026af:	00 
c01026b0:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c01026b7:	e8 47 dd ff ff       	call   c0100403 <__panic>
        ticks++;
c01026bc:	a1 0c 40 12 c0       	mov    0xc012400c,%eax
c01026c1:	40                   	inc    %eax
c01026c2:	a3 0c 40 12 c0       	mov    %eax,0xc012400c
        if (ticks % TICK_NUM == 0) {
c01026c7:	8b 0d 0c 40 12 c0    	mov    0xc012400c,%ecx
c01026cd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01026d2:	89 c8                	mov    %ecx,%eax
c01026d4:	f7 e2                	mul    %edx
c01026d6:	c1 ea 05             	shr    $0x5,%edx
c01026d9:	89 d0                	mov    %edx,%eax
c01026db:	c1 e0 02             	shl    $0x2,%eax
c01026de:	01 d0                	add    %edx,%eax
c01026e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01026e7:	01 d0                	add    %edx,%eax
c01026e9:	c1 e0 02             	shl    $0x2,%eax
c01026ec:	29 c1                	sub    %eax,%ecx
c01026ee:	89 ca                	mov    %ecx,%edx
c01026f0:	85 d2                	test   %edx,%edx
c01026f2:	0f 85 ae 01 00 00    	jne    c01028a6 <trap_dispatch+0x293>
            print_ticks();
c01026f8:	e8 d5 f9 ff ff       	call   c01020d2 <print_ticks>
        break;
c01026fd:	e9 a4 01 00 00       	jmp    c01028a6 <trap_dispatch+0x293>
        c = cons_getc();
c0102702:	e8 88 f7 ff ff       	call   c0101e8f <cons_getc>
c0102707:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010270a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c010270e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102712:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102716:	89 44 24 04          	mov    %eax,0x4(%esp)
c010271a:	c7 04 24 bd 94 10 c0 	movl   $0xc01094bd,(%esp)
c0102721:	e8 86 db ff ff       	call   c01002ac <cprintf>
        break;
c0102726:	e9 7f 01 00 00       	jmp    c01028aa <trap_dispatch+0x297>
        c = cons_getc();
c010272b:	e8 5f f7 ff ff       	call   c0101e8f <cons_getc>
c0102730:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102733:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0102737:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010273b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010273f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102743:	c7 04 24 cf 94 10 c0 	movl   $0xc01094cf,(%esp)
c010274a:	e8 5d db ff ff       	call   c01002ac <cprintf>
        if ( c =='3'){
c010274f:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
c0102753:	75 4c                	jne    c01027a1 <trap_dispatch+0x18e>
			tf->tf_cs = USER_CS;
c0102755:	8b 45 08             	mov    0x8(%ebp),%eax
c0102758:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
            tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010275e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102761:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0102767:	8b 45 08             	mov    0x8(%ebp),%eax
c010276a:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010276e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102771:	66 89 50 28          	mov    %dx,0x28(%eax)
c0102775:	8b 45 08             	mov    0x8(%ebp),%eax
c0102778:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010277c:	8b 45 08             	mov    0x8(%ebp),%eax
c010277f:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags |= FL_IOPL_MASK;
c0102783:	8b 45 08             	mov    0x8(%ebp),%eax
c0102786:	8b 40 40             	mov    0x40(%eax),%eax
c0102789:	0d 00 30 00 00       	or     $0x3000,%eax
c010278e:	89 c2                	mov    %eax,%edx
c0102790:	8b 45 08             	mov    0x8(%ebp),%eax
c0102793:	89 50 40             	mov    %edx,0x40(%eax)
			print_trapframe(tf);
c0102796:	8b 45 08             	mov    0x8(%ebp),%eax
c0102799:	89 04 24             	mov    %eax,(%esp)
c010279c:	e8 2b fb ff ff       	call   c01022cc <print_trapframe>
		if ( c =='0'){
c01027a1:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
c01027a5:	0f 85 fe 00 00 00    	jne    c01028a9 <trap_dispatch+0x296>
			tf->tf_cs = KERNEL_CS;
c01027ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ae:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = KERNEL_DS;
c01027b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b7:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
            tf->tf_es = KERNEL_DS;
c01027bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c0:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
            tf->tf_ss = KERNEL_DS;
c01027c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c9:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
c01027cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01027d2:	8b 40 40             	mov    0x40(%eax),%eax
c01027d5:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c01027da:	89 c2                	mov    %eax,%edx
c01027dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01027df:	89 50 40             	mov    %edx,0x40(%eax)
			print_trapframe(tf);
c01027e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e5:	89 04 24             	mov    %eax,(%esp)
c01027e8:	e8 df fa ff ff       	call   c01022cc <print_trapframe>
        break;
c01027ed:	e9 b7 00 00 00       	jmp    c01028a9 <trap_dispatch+0x296>
        tf->tf_cs = USER_CS;
c01027f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01027f5:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
        tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c01027fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01027fe:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c0102804:	8b 45 08             	mov    0x8(%ebp),%eax
c0102807:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010280b:	8b 45 08             	mov    0x8(%ebp),%eax
c010280e:	66 89 50 28          	mov    %dx,0x28(%eax)
c0102812:	8b 45 08             	mov    0x8(%ebp),%eax
c0102815:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0102819:	8b 45 08             	mov    0x8(%ebp),%eax
c010281c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        tf->tf_eflags |= FL_IOPL_MASK;
c0102820:	8b 45 08             	mov    0x8(%ebp),%eax
c0102823:	8b 40 40             	mov    0x40(%eax),%eax
c0102826:	0d 00 30 00 00       	or     $0x3000,%eax
c010282b:	89 c2                	mov    %eax,%edx
c010282d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102830:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c0102833:	eb 75                	jmp    c01028aa <trap_dispatch+0x297>
        tf->tf_cs = KERNEL_CS;
c0102835:	8b 45 08             	mov    0x8(%ebp),%eax
c0102838:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
        tf->tf_ds = KERNEL_DS;
c010283e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102841:	66 c7 40 2c 10 00    	movw   $0x10,0x2c(%eax)
        tf->tf_es = KERNEL_DS;
c0102847:	8b 45 08             	mov    0x8(%ebp),%eax
c010284a:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
        tf->tf_ss = KERNEL_DS;
c0102850:	8b 45 08             	mov    0x8(%ebp),%eax
c0102853:	66 c7 40 48 10 00    	movw   $0x10,0x48(%eax)
        tf->tf_eflags &= ~FL_IOPL_MASK;
c0102859:	8b 45 08             	mov    0x8(%ebp),%eax
c010285c:	8b 40 40             	mov    0x40(%eax),%eax
c010285f:	25 ff cf ff ff       	and    $0xffffcfff,%eax
c0102864:	89 c2                	mov    %eax,%edx
c0102866:	8b 45 08             	mov    0x8(%ebp),%eax
c0102869:	89 50 40             	mov    %edx,0x40(%eax)
        break;
c010286c:	eb 3c                	jmp    c01028aa <trap_dispatch+0x297>
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010286e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102871:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102875:	83 e0 03             	and    $0x3,%eax
c0102878:	85 c0                	test   %eax,%eax
c010287a:	75 2e                	jne    c01028aa <trap_dispatch+0x297>
            print_trapframe(tf);
c010287c:	8b 45 08             	mov    0x8(%ebp),%eax
c010287f:	89 04 24             	mov    %eax,(%esp)
c0102882:	e8 45 fa ff ff       	call   c01022cc <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102887:	c7 44 24 08 de 94 10 	movl   $0xc01094de,0x8(%esp)
c010288e:	c0 
c010288f:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0102896:	00 
c0102897:	c7 04 24 8e 92 10 c0 	movl   $0xc010928e,(%esp)
c010289e:	e8 60 db ff ff       	call   c0100403 <__panic>
        break;
c01028a3:	90                   	nop
c01028a4:	eb 04                	jmp    c01028aa <trap_dispatch+0x297>
        break;
c01028a6:	90                   	nop
c01028a7:	eb 01                	jmp    c01028aa <trap_dispatch+0x297>
        break;
c01028a9:	90                   	nop
        }
    }
}
c01028aa:	90                   	nop
c01028ab:	c9                   	leave  
c01028ac:	c3                   	ret    

c01028ad <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c01028ad:	55                   	push   %ebp
c01028ae:	89 e5                	mov    %esp,%ebp
c01028b0:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c01028b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b6:	89 04 24             	mov    %eax,(%esp)
c01028b9:	e8 55 fd ff ff       	call   c0102613 <trap_dispatch>
}
c01028be:	90                   	nop
c01028bf:	c9                   	leave  
c01028c0:	c3                   	ret    

c01028c1 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $0
c01028c3:	6a 00                	push   $0x0
  jmp __alltraps
c01028c5:	e9 69 0a 00 00       	jmp    c0103333 <__alltraps>

c01028ca <vector1>:
.globl vector1
vector1:
  pushl $0
c01028ca:	6a 00                	push   $0x0
  pushl $1
c01028cc:	6a 01                	push   $0x1
  jmp __alltraps
c01028ce:	e9 60 0a 00 00       	jmp    c0103333 <__alltraps>

c01028d3 <vector2>:
.globl vector2
vector2:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $2
c01028d5:	6a 02                	push   $0x2
  jmp __alltraps
c01028d7:	e9 57 0a 00 00       	jmp    c0103333 <__alltraps>

c01028dc <vector3>:
.globl vector3
vector3:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $3
c01028de:	6a 03                	push   $0x3
  jmp __alltraps
c01028e0:	e9 4e 0a 00 00       	jmp    c0103333 <__alltraps>

c01028e5 <vector4>:
.globl vector4
vector4:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $4
c01028e7:	6a 04                	push   $0x4
  jmp __alltraps
c01028e9:	e9 45 0a 00 00       	jmp    c0103333 <__alltraps>

c01028ee <vector5>:
.globl vector5
vector5:
  pushl $0
c01028ee:	6a 00                	push   $0x0
  pushl $5
c01028f0:	6a 05                	push   $0x5
  jmp __alltraps
c01028f2:	e9 3c 0a 00 00       	jmp    c0103333 <__alltraps>

c01028f7 <vector6>:
.globl vector6
vector6:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $6
c01028f9:	6a 06                	push   $0x6
  jmp __alltraps
c01028fb:	e9 33 0a 00 00       	jmp    c0103333 <__alltraps>

c0102900 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $7
c0102902:	6a 07                	push   $0x7
  jmp __alltraps
c0102904:	e9 2a 0a 00 00       	jmp    c0103333 <__alltraps>

c0102909 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102909:	6a 08                	push   $0x8
  jmp __alltraps
c010290b:	e9 23 0a 00 00       	jmp    c0103333 <__alltraps>

c0102910 <vector9>:
.globl vector9
vector9:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $9
c0102912:	6a 09                	push   $0x9
  jmp __alltraps
c0102914:	e9 1a 0a 00 00       	jmp    c0103333 <__alltraps>

c0102919 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102919:	6a 0a                	push   $0xa
  jmp __alltraps
c010291b:	e9 13 0a 00 00       	jmp    c0103333 <__alltraps>

c0102920 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102920:	6a 0b                	push   $0xb
  jmp __alltraps
c0102922:	e9 0c 0a 00 00       	jmp    c0103333 <__alltraps>

c0102927 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102927:	6a 0c                	push   $0xc
  jmp __alltraps
c0102929:	e9 05 0a 00 00       	jmp    c0103333 <__alltraps>

c010292e <vector13>:
.globl vector13
vector13:
  pushl $13
c010292e:	6a 0d                	push   $0xd
  jmp __alltraps
c0102930:	e9 fe 09 00 00       	jmp    c0103333 <__alltraps>

c0102935 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102935:	6a 0e                	push   $0xe
  jmp __alltraps
c0102937:	e9 f7 09 00 00       	jmp    c0103333 <__alltraps>

c010293c <vector15>:
.globl vector15
vector15:
  pushl $0
c010293c:	6a 00                	push   $0x0
  pushl $15
c010293e:	6a 0f                	push   $0xf
  jmp __alltraps
c0102940:	e9 ee 09 00 00       	jmp    c0103333 <__alltraps>

c0102945 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102945:	6a 00                	push   $0x0
  pushl $16
c0102947:	6a 10                	push   $0x10
  jmp __alltraps
c0102949:	e9 e5 09 00 00       	jmp    c0103333 <__alltraps>

c010294e <vector17>:
.globl vector17
vector17:
  pushl $17
c010294e:	6a 11                	push   $0x11
  jmp __alltraps
c0102950:	e9 de 09 00 00       	jmp    c0103333 <__alltraps>

c0102955 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102955:	6a 00                	push   $0x0
  pushl $18
c0102957:	6a 12                	push   $0x12
  jmp __alltraps
c0102959:	e9 d5 09 00 00       	jmp    c0103333 <__alltraps>

c010295e <vector19>:
.globl vector19
vector19:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $19
c0102960:	6a 13                	push   $0x13
  jmp __alltraps
c0102962:	e9 cc 09 00 00       	jmp    c0103333 <__alltraps>

c0102967 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102967:	6a 00                	push   $0x0
  pushl $20
c0102969:	6a 14                	push   $0x14
  jmp __alltraps
c010296b:	e9 c3 09 00 00       	jmp    c0103333 <__alltraps>

c0102970 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102970:	6a 00                	push   $0x0
  pushl $21
c0102972:	6a 15                	push   $0x15
  jmp __alltraps
c0102974:	e9 ba 09 00 00       	jmp    c0103333 <__alltraps>

c0102979 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102979:	6a 00                	push   $0x0
  pushl $22
c010297b:	6a 16                	push   $0x16
  jmp __alltraps
c010297d:	e9 b1 09 00 00       	jmp    c0103333 <__alltraps>

c0102982 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $23
c0102984:	6a 17                	push   $0x17
  jmp __alltraps
c0102986:	e9 a8 09 00 00       	jmp    c0103333 <__alltraps>

c010298b <vector24>:
.globl vector24
vector24:
  pushl $0
c010298b:	6a 00                	push   $0x0
  pushl $24
c010298d:	6a 18                	push   $0x18
  jmp __alltraps
c010298f:	e9 9f 09 00 00       	jmp    c0103333 <__alltraps>

c0102994 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102994:	6a 00                	push   $0x0
  pushl $25
c0102996:	6a 19                	push   $0x19
  jmp __alltraps
c0102998:	e9 96 09 00 00       	jmp    c0103333 <__alltraps>

c010299d <vector26>:
.globl vector26
vector26:
  pushl $0
c010299d:	6a 00                	push   $0x0
  pushl $26
c010299f:	6a 1a                	push   $0x1a
  jmp __alltraps
c01029a1:	e9 8d 09 00 00       	jmp    c0103333 <__alltraps>

c01029a6 <vector27>:
.globl vector27
vector27:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $27
c01029a8:	6a 1b                	push   $0x1b
  jmp __alltraps
c01029aa:	e9 84 09 00 00       	jmp    c0103333 <__alltraps>

c01029af <vector28>:
.globl vector28
vector28:
  pushl $0
c01029af:	6a 00                	push   $0x0
  pushl $28
c01029b1:	6a 1c                	push   $0x1c
  jmp __alltraps
c01029b3:	e9 7b 09 00 00       	jmp    c0103333 <__alltraps>

c01029b8 <vector29>:
.globl vector29
vector29:
  pushl $0
c01029b8:	6a 00                	push   $0x0
  pushl $29
c01029ba:	6a 1d                	push   $0x1d
  jmp __alltraps
c01029bc:	e9 72 09 00 00       	jmp    c0103333 <__alltraps>

c01029c1 <vector30>:
.globl vector30
vector30:
  pushl $0
c01029c1:	6a 00                	push   $0x0
  pushl $30
c01029c3:	6a 1e                	push   $0x1e
  jmp __alltraps
c01029c5:	e9 69 09 00 00       	jmp    c0103333 <__alltraps>

c01029ca <vector31>:
.globl vector31
vector31:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $31
c01029cc:	6a 1f                	push   $0x1f
  jmp __alltraps
c01029ce:	e9 60 09 00 00       	jmp    c0103333 <__alltraps>

c01029d3 <vector32>:
.globl vector32
vector32:
  pushl $0
c01029d3:	6a 00                	push   $0x0
  pushl $32
c01029d5:	6a 20                	push   $0x20
  jmp __alltraps
c01029d7:	e9 57 09 00 00       	jmp    c0103333 <__alltraps>

c01029dc <vector33>:
.globl vector33
vector33:
  pushl $0
c01029dc:	6a 00                	push   $0x0
  pushl $33
c01029de:	6a 21                	push   $0x21
  jmp __alltraps
c01029e0:	e9 4e 09 00 00       	jmp    c0103333 <__alltraps>

c01029e5 <vector34>:
.globl vector34
vector34:
  pushl $0
c01029e5:	6a 00                	push   $0x0
  pushl $34
c01029e7:	6a 22                	push   $0x22
  jmp __alltraps
c01029e9:	e9 45 09 00 00       	jmp    c0103333 <__alltraps>

c01029ee <vector35>:
.globl vector35
vector35:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $35
c01029f0:	6a 23                	push   $0x23
  jmp __alltraps
c01029f2:	e9 3c 09 00 00       	jmp    c0103333 <__alltraps>

c01029f7 <vector36>:
.globl vector36
vector36:
  pushl $0
c01029f7:	6a 00                	push   $0x0
  pushl $36
c01029f9:	6a 24                	push   $0x24
  jmp __alltraps
c01029fb:	e9 33 09 00 00       	jmp    c0103333 <__alltraps>

c0102a00 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102a00:	6a 00                	push   $0x0
  pushl $37
c0102a02:	6a 25                	push   $0x25
  jmp __alltraps
c0102a04:	e9 2a 09 00 00       	jmp    c0103333 <__alltraps>

c0102a09 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102a09:	6a 00                	push   $0x0
  pushl $38
c0102a0b:	6a 26                	push   $0x26
  jmp __alltraps
c0102a0d:	e9 21 09 00 00       	jmp    c0103333 <__alltraps>

c0102a12 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $39
c0102a14:	6a 27                	push   $0x27
  jmp __alltraps
c0102a16:	e9 18 09 00 00       	jmp    c0103333 <__alltraps>

c0102a1b <vector40>:
.globl vector40
vector40:
  pushl $0
c0102a1b:	6a 00                	push   $0x0
  pushl $40
c0102a1d:	6a 28                	push   $0x28
  jmp __alltraps
c0102a1f:	e9 0f 09 00 00       	jmp    c0103333 <__alltraps>

c0102a24 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102a24:	6a 00                	push   $0x0
  pushl $41
c0102a26:	6a 29                	push   $0x29
  jmp __alltraps
c0102a28:	e9 06 09 00 00       	jmp    c0103333 <__alltraps>

c0102a2d <vector42>:
.globl vector42
vector42:
  pushl $0
c0102a2d:	6a 00                	push   $0x0
  pushl $42
c0102a2f:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102a31:	e9 fd 08 00 00       	jmp    c0103333 <__alltraps>

c0102a36 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $43
c0102a38:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102a3a:	e9 f4 08 00 00       	jmp    c0103333 <__alltraps>

c0102a3f <vector44>:
.globl vector44
vector44:
  pushl $0
c0102a3f:	6a 00                	push   $0x0
  pushl $44
c0102a41:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102a43:	e9 eb 08 00 00       	jmp    c0103333 <__alltraps>

c0102a48 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102a48:	6a 00                	push   $0x0
  pushl $45
c0102a4a:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102a4c:	e9 e2 08 00 00       	jmp    c0103333 <__alltraps>

c0102a51 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102a51:	6a 00                	push   $0x0
  pushl $46
c0102a53:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102a55:	e9 d9 08 00 00       	jmp    c0103333 <__alltraps>

c0102a5a <vector47>:
.globl vector47
vector47:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $47
c0102a5c:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102a5e:	e9 d0 08 00 00       	jmp    c0103333 <__alltraps>

c0102a63 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102a63:	6a 00                	push   $0x0
  pushl $48
c0102a65:	6a 30                	push   $0x30
  jmp __alltraps
c0102a67:	e9 c7 08 00 00       	jmp    c0103333 <__alltraps>

c0102a6c <vector49>:
.globl vector49
vector49:
  pushl $0
c0102a6c:	6a 00                	push   $0x0
  pushl $49
c0102a6e:	6a 31                	push   $0x31
  jmp __alltraps
c0102a70:	e9 be 08 00 00       	jmp    c0103333 <__alltraps>

c0102a75 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102a75:	6a 00                	push   $0x0
  pushl $50
c0102a77:	6a 32                	push   $0x32
  jmp __alltraps
c0102a79:	e9 b5 08 00 00       	jmp    c0103333 <__alltraps>

c0102a7e <vector51>:
.globl vector51
vector51:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $51
c0102a80:	6a 33                	push   $0x33
  jmp __alltraps
c0102a82:	e9 ac 08 00 00       	jmp    c0103333 <__alltraps>

c0102a87 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102a87:	6a 00                	push   $0x0
  pushl $52
c0102a89:	6a 34                	push   $0x34
  jmp __alltraps
c0102a8b:	e9 a3 08 00 00       	jmp    c0103333 <__alltraps>

c0102a90 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102a90:	6a 00                	push   $0x0
  pushl $53
c0102a92:	6a 35                	push   $0x35
  jmp __alltraps
c0102a94:	e9 9a 08 00 00       	jmp    c0103333 <__alltraps>

c0102a99 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a99:	6a 00                	push   $0x0
  pushl $54
c0102a9b:	6a 36                	push   $0x36
  jmp __alltraps
c0102a9d:	e9 91 08 00 00       	jmp    c0103333 <__alltraps>

c0102aa2 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $55
c0102aa4:	6a 37                	push   $0x37
  jmp __alltraps
c0102aa6:	e9 88 08 00 00       	jmp    c0103333 <__alltraps>

c0102aab <vector56>:
.globl vector56
vector56:
  pushl $0
c0102aab:	6a 00                	push   $0x0
  pushl $56
c0102aad:	6a 38                	push   $0x38
  jmp __alltraps
c0102aaf:	e9 7f 08 00 00       	jmp    c0103333 <__alltraps>

c0102ab4 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102ab4:	6a 00                	push   $0x0
  pushl $57
c0102ab6:	6a 39                	push   $0x39
  jmp __alltraps
c0102ab8:	e9 76 08 00 00       	jmp    c0103333 <__alltraps>

c0102abd <vector58>:
.globl vector58
vector58:
  pushl $0
c0102abd:	6a 00                	push   $0x0
  pushl $58
c0102abf:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102ac1:	e9 6d 08 00 00       	jmp    c0103333 <__alltraps>

c0102ac6 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $59
c0102ac8:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102aca:	e9 64 08 00 00       	jmp    c0103333 <__alltraps>

c0102acf <vector60>:
.globl vector60
vector60:
  pushl $0
c0102acf:	6a 00                	push   $0x0
  pushl $60
c0102ad1:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102ad3:	e9 5b 08 00 00       	jmp    c0103333 <__alltraps>

c0102ad8 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102ad8:	6a 00                	push   $0x0
  pushl $61
c0102ada:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102adc:	e9 52 08 00 00       	jmp    c0103333 <__alltraps>

c0102ae1 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102ae1:	6a 00                	push   $0x0
  pushl $62
c0102ae3:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102ae5:	e9 49 08 00 00       	jmp    c0103333 <__alltraps>

c0102aea <vector63>:
.globl vector63
vector63:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $63
c0102aec:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102aee:	e9 40 08 00 00       	jmp    c0103333 <__alltraps>

c0102af3 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102af3:	6a 00                	push   $0x0
  pushl $64
c0102af5:	6a 40                	push   $0x40
  jmp __alltraps
c0102af7:	e9 37 08 00 00       	jmp    c0103333 <__alltraps>

c0102afc <vector65>:
.globl vector65
vector65:
  pushl $0
c0102afc:	6a 00                	push   $0x0
  pushl $65
c0102afe:	6a 41                	push   $0x41
  jmp __alltraps
c0102b00:	e9 2e 08 00 00       	jmp    c0103333 <__alltraps>

c0102b05 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102b05:	6a 00                	push   $0x0
  pushl $66
c0102b07:	6a 42                	push   $0x42
  jmp __alltraps
c0102b09:	e9 25 08 00 00       	jmp    c0103333 <__alltraps>

c0102b0e <vector67>:
.globl vector67
vector67:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $67
c0102b10:	6a 43                	push   $0x43
  jmp __alltraps
c0102b12:	e9 1c 08 00 00       	jmp    c0103333 <__alltraps>

c0102b17 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102b17:	6a 00                	push   $0x0
  pushl $68
c0102b19:	6a 44                	push   $0x44
  jmp __alltraps
c0102b1b:	e9 13 08 00 00       	jmp    c0103333 <__alltraps>

c0102b20 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102b20:	6a 00                	push   $0x0
  pushl $69
c0102b22:	6a 45                	push   $0x45
  jmp __alltraps
c0102b24:	e9 0a 08 00 00       	jmp    c0103333 <__alltraps>

c0102b29 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102b29:	6a 00                	push   $0x0
  pushl $70
c0102b2b:	6a 46                	push   $0x46
  jmp __alltraps
c0102b2d:	e9 01 08 00 00       	jmp    c0103333 <__alltraps>

c0102b32 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102b32:	6a 00                	push   $0x0
  pushl $71
c0102b34:	6a 47                	push   $0x47
  jmp __alltraps
c0102b36:	e9 f8 07 00 00       	jmp    c0103333 <__alltraps>

c0102b3b <vector72>:
.globl vector72
vector72:
  pushl $0
c0102b3b:	6a 00                	push   $0x0
  pushl $72
c0102b3d:	6a 48                	push   $0x48
  jmp __alltraps
c0102b3f:	e9 ef 07 00 00       	jmp    c0103333 <__alltraps>

c0102b44 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102b44:	6a 00                	push   $0x0
  pushl $73
c0102b46:	6a 49                	push   $0x49
  jmp __alltraps
c0102b48:	e9 e6 07 00 00       	jmp    c0103333 <__alltraps>

c0102b4d <vector74>:
.globl vector74
vector74:
  pushl $0
c0102b4d:	6a 00                	push   $0x0
  pushl $74
c0102b4f:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102b51:	e9 dd 07 00 00       	jmp    c0103333 <__alltraps>

c0102b56 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102b56:	6a 00                	push   $0x0
  pushl $75
c0102b58:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102b5a:	e9 d4 07 00 00       	jmp    c0103333 <__alltraps>

c0102b5f <vector76>:
.globl vector76
vector76:
  pushl $0
c0102b5f:	6a 00                	push   $0x0
  pushl $76
c0102b61:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102b63:	e9 cb 07 00 00       	jmp    c0103333 <__alltraps>

c0102b68 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102b68:	6a 00                	push   $0x0
  pushl $77
c0102b6a:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102b6c:	e9 c2 07 00 00       	jmp    c0103333 <__alltraps>

c0102b71 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102b71:	6a 00                	push   $0x0
  pushl $78
c0102b73:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102b75:	e9 b9 07 00 00       	jmp    c0103333 <__alltraps>

c0102b7a <vector79>:
.globl vector79
vector79:
  pushl $0
c0102b7a:	6a 00                	push   $0x0
  pushl $79
c0102b7c:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102b7e:	e9 b0 07 00 00       	jmp    c0103333 <__alltraps>

c0102b83 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102b83:	6a 00                	push   $0x0
  pushl $80
c0102b85:	6a 50                	push   $0x50
  jmp __alltraps
c0102b87:	e9 a7 07 00 00       	jmp    c0103333 <__alltraps>

c0102b8c <vector81>:
.globl vector81
vector81:
  pushl $0
c0102b8c:	6a 00                	push   $0x0
  pushl $81
c0102b8e:	6a 51                	push   $0x51
  jmp __alltraps
c0102b90:	e9 9e 07 00 00       	jmp    c0103333 <__alltraps>

c0102b95 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b95:	6a 00                	push   $0x0
  pushl $82
c0102b97:	6a 52                	push   $0x52
  jmp __alltraps
c0102b99:	e9 95 07 00 00       	jmp    c0103333 <__alltraps>

c0102b9e <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b9e:	6a 00                	push   $0x0
  pushl $83
c0102ba0:	6a 53                	push   $0x53
  jmp __alltraps
c0102ba2:	e9 8c 07 00 00       	jmp    c0103333 <__alltraps>

c0102ba7 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102ba7:	6a 00                	push   $0x0
  pushl $84
c0102ba9:	6a 54                	push   $0x54
  jmp __alltraps
c0102bab:	e9 83 07 00 00       	jmp    c0103333 <__alltraps>

c0102bb0 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102bb0:	6a 00                	push   $0x0
  pushl $85
c0102bb2:	6a 55                	push   $0x55
  jmp __alltraps
c0102bb4:	e9 7a 07 00 00       	jmp    c0103333 <__alltraps>

c0102bb9 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102bb9:	6a 00                	push   $0x0
  pushl $86
c0102bbb:	6a 56                	push   $0x56
  jmp __alltraps
c0102bbd:	e9 71 07 00 00       	jmp    c0103333 <__alltraps>

c0102bc2 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102bc2:	6a 00                	push   $0x0
  pushl $87
c0102bc4:	6a 57                	push   $0x57
  jmp __alltraps
c0102bc6:	e9 68 07 00 00       	jmp    c0103333 <__alltraps>

c0102bcb <vector88>:
.globl vector88
vector88:
  pushl $0
c0102bcb:	6a 00                	push   $0x0
  pushl $88
c0102bcd:	6a 58                	push   $0x58
  jmp __alltraps
c0102bcf:	e9 5f 07 00 00       	jmp    c0103333 <__alltraps>

c0102bd4 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102bd4:	6a 00                	push   $0x0
  pushl $89
c0102bd6:	6a 59                	push   $0x59
  jmp __alltraps
c0102bd8:	e9 56 07 00 00       	jmp    c0103333 <__alltraps>

c0102bdd <vector90>:
.globl vector90
vector90:
  pushl $0
c0102bdd:	6a 00                	push   $0x0
  pushl $90
c0102bdf:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102be1:	e9 4d 07 00 00       	jmp    c0103333 <__alltraps>

c0102be6 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $91
c0102be8:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102bea:	e9 44 07 00 00       	jmp    c0103333 <__alltraps>

c0102bef <vector92>:
.globl vector92
vector92:
  pushl $0
c0102bef:	6a 00                	push   $0x0
  pushl $92
c0102bf1:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102bf3:	e9 3b 07 00 00       	jmp    c0103333 <__alltraps>

c0102bf8 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102bf8:	6a 00                	push   $0x0
  pushl $93
c0102bfa:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102bfc:	e9 32 07 00 00       	jmp    c0103333 <__alltraps>

c0102c01 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102c01:	6a 00                	push   $0x0
  pushl $94
c0102c03:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102c05:	e9 29 07 00 00       	jmp    c0103333 <__alltraps>

c0102c0a <vector95>:
.globl vector95
vector95:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $95
c0102c0c:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102c0e:	e9 20 07 00 00       	jmp    c0103333 <__alltraps>

c0102c13 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102c13:	6a 00                	push   $0x0
  pushl $96
c0102c15:	6a 60                	push   $0x60
  jmp __alltraps
c0102c17:	e9 17 07 00 00       	jmp    c0103333 <__alltraps>

c0102c1c <vector97>:
.globl vector97
vector97:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $97
c0102c1e:	6a 61                	push   $0x61
  jmp __alltraps
c0102c20:	e9 0e 07 00 00       	jmp    c0103333 <__alltraps>

c0102c25 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102c25:	6a 00                	push   $0x0
  pushl $98
c0102c27:	6a 62                	push   $0x62
  jmp __alltraps
c0102c29:	e9 05 07 00 00       	jmp    c0103333 <__alltraps>

c0102c2e <vector99>:
.globl vector99
vector99:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $99
c0102c30:	6a 63                	push   $0x63
  jmp __alltraps
c0102c32:	e9 fc 06 00 00       	jmp    c0103333 <__alltraps>

c0102c37 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102c37:	6a 00                	push   $0x0
  pushl $100
c0102c39:	6a 64                	push   $0x64
  jmp __alltraps
c0102c3b:	e9 f3 06 00 00       	jmp    c0103333 <__alltraps>

c0102c40 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $101
c0102c42:	6a 65                	push   $0x65
  jmp __alltraps
c0102c44:	e9 ea 06 00 00       	jmp    c0103333 <__alltraps>

c0102c49 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102c49:	6a 00                	push   $0x0
  pushl $102
c0102c4b:	6a 66                	push   $0x66
  jmp __alltraps
c0102c4d:	e9 e1 06 00 00       	jmp    c0103333 <__alltraps>

c0102c52 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102c52:	6a 00                	push   $0x0
  pushl $103
c0102c54:	6a 67                	push   $0x67
  jmp __alltraps
c0102c56:	e9 d8 06 00 00       	jmp    c0103333 <__alltraps>

c0102c5b <vector104>:
.globl vector104
vector104:
  pushl $0
c0102c5b:	6a 00                	push   $0x0
  pushl $104
c0102c5d:	6a 68                	push   $0x68
  jmp __alltraps
c0102c5f:	e9 cf 06 00 00       	jmp    c0103333 <__alltraps>

c0102c64 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $105
c0102c66:	6a 69                	push   $0x69
  jmp __alltraps
c0102c68:	e9 c6 06 00 00       	jmp    c0103333 <__alltraps>

c0102c6d <vector106>:
.globl vector106
vector106:
  pushl $0
c0102c6d:	6a 00                	push   $0x0
  pushl $106
c0102c6f:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102c71:	e9 bd 06 00 00       	jmp    c0103333 <__alltraps>

c0102c76 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102c76:	6a 00                	push   $0x0
  pushl $107
c0102c78:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102c7a:	e9 b4 06 00 00       	jmp    c0103333 <__alltraps>

c0102c7f <vector108>:
.globl vector108
vector108:
  pushl $0
c0102c7f:	6a 00                	push   $0x0
  pushl $108
c0102c81:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102c83:	e9 ab 06 00 00       	jmp    c0103333 <__alltraps>

c0102c88 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $109
c0102c8a:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102c8c:	e9 a2 06 00 00       	jmp    c0103333 <__alltraps>

c0102c91 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102c91:	6a 00                	push   $0x0
  pushl $110
c0102c93:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c95:	e9 99 06 00 00       	jmp    c0103333 <__alltraps>

c0102c9a <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c9a:	6a 00                	push   $0x0
  pushl $111
c0102c9c:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c9e:	e9 90 06 00 00       	jmp    c0103333 <__alltraps>

c0102ca3 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102ca3:	6a 00                	push   $0x0
  pushl $112
c0102ca5:	6a 70                	push   $0x70
  jmp __alltraps
c0102ca7:	e9 87 06 00 00       	jmp    c0103333 <__alltraps>

c0102cac <vector113>:
.globl vector113
vector113:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $113
c0102cae:	6a 71                	push   $0x71
  jmp __alltraps
c0102cb0:	e9 7e 06 00 00       	jmp    c0103333 <__alltraps>

c0102cb5 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102cb5:	6a 00                	push   $0x0
  pushl $114
c0102cb7:	6a 72                	push   $0x72
  jmp __alltraps
c0102cb9:	e9 75 06 00 00       	jmp    c0103333 <__alltraps>

c0102cbe <vector115>:
.globl vector115
vector115:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $115
c0102cc0:	6a 73                	push   $0x73
  jmp __alltraps
c0102cc2:	e9 6c 06 00 00       	jmp    c0103333 <__alltraps>

c0102cc7 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102cc7:	6a 00                	push   $0x0
  pushl $116
c0102cc9:	6a 74                	push   $0x74
  jmp __alltraps
c0102ccb:	e9 63 06 00 00       	jmp    c0103333 <__alltraps>

c0102cd0 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $117
c0102cd2:	6a 75                	push   $0x75
  jmp __alltraps
c0102cd4:	e9 5a 06 00 00       	jmp    c0103333 <__alltraps>

c0102cd9 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102cd9:	6a 00                	push   $0x0
  pushl $118
c0102cdb:	6a 76                	push   $0x76
  jmp __alltraps
c0102cdd:	e9 51 06 00 00       	jmp    c0103333 <__alltraps>

c0102ce2 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102ce2:	6a 00                	push   $0x0
  pushl $119
c0102ce4:	6a 77                	push   $0x77
  jmp __alltraps
c0102ce6:	e9 48 06 00 00       	jmp    c0103333 <__alltraps>

c0102ceb <vector120>:
.globl vector120
vector120:
  pushl $0
c0102ceb:	6a 00                	push   $0x0
  pushl $120
c0102ced:	6a 78                	push   $0x78
  jmp __alltraps
c0102cef:	e9 3f 06 00 00       	jmp    c0103333 <__alltraps>

c0102cf4 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $121
c0102cf6:	6a 79                	push   $0x79
  jmp __alltraps
c0102cf8:	e9 36 06 00 00       	jmp    c0103333 <__alltraps>

c0102cfd <vector122>:
.globl vector122
vector122:
  pushl $0
c0102cfd:	6a 00                	push   $0x0
  pushl $122
c0102cff:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102d01:	e9 2d 06 00 00       	jmp    c0103333 <__alltraps>

c0102d06 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102d06:	6a 00                	push   $0x0
  pushl $123
c0102d08:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102d0a:	e9 24 06 00 00       	jmp    c0103333 <__alltraps>

c0102d0f <vector124>:
.globl vector124
vector124:
  pushl $0
c0102d0f:	6a 00                	push   $0x0
  pushl $124
c0102d11:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102d13:	e9 1b 06 00 00       	jmp    c0103333 <__alltraps>

c0102d18 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $125
c0102d1a:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102d1c:	e9 12 06 00 00       	jmp    c0103333 <__alltraps>

c0102d21 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102d21:	6a 00                	push   $0x0
  pushl $126
c0102d23:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102d25:	e9 09 06 00 00       	jmp    c0103333 <__alltraps>

c0102d2a <vector127>:
.globl vector127
vector127:
  pushl $0
c0102d2a:	6a 00                	push   $0x0
  pushl $127
c0102d2c:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102d2e:	e9 00 06 00 00       	jmp    c0103333 <__alltraps>

c0102d33 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102d33:	6a 00                	push   $0x0
  pushl $128
c0102d35:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102d3a:	e9 f4 05 00 00       	jmp    c0103333 <__alltraps>

c0102d3f <vector129>:
.globl vector129
vector129:
  pushl $0
c0102d3f:	6a 00                	push   $0x0
  pushl $129
c0102d41:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102d46:	e9 e8 05 00 00       	jmp    c0103333 <__alltraps>

c0102d4b <vector130>:
.globl vector130
vector130:
  pushl $0
c0102d4b:	6a 00                	push   $0x0
  pushl $130
c0102d4d:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102d52:	e9 dc 05 00 00       	jmp    c0103333 <__alltraps>

c0102d57 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102d57:	6a 00                	push   $0x0
  pushl $131
c0102d59:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102d5e:	e9 d0 05 00 00       	jmp    c0103333 <__alltraps>

c0102d63 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102d63:	6a 00                	push   $0x0
  pushl $132
c0102d65:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102d6a:	e9 c4 05 00 00       	jmp    c0103333 <__alltraps>

c0102d6f <vector133>:
.globl vector133
vector133:
  pushl $0
c0102d6f:	6a 00                	push   $0x0
  pushl $133
c0102d71:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102d76:	e9 b8 05 00 00       	jmp    c0103333 <__alltraps>

c0102d7b <vector134>:
.globl vector134
vector134:
  pushl $0
c0102d7b:	6a 00                	push   $0x0
  pushl $134
c0102d7d:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102d82:	e9 ac 05 00 00       	jmp    c0103333 <__alltraps>

c0102d87 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102d87:	6a 00                	push   $0x0
  pushl $135
c0102d89:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d8e:	e9 a0 05 00 00       	jmp    c0103333 <__alltraps>

c0102d93 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d93:	6a 00                	push   $0x0
  pushl $136
c0102d95:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d9a:	e9 94 05 00 00       	jmp    c0103333 <__alltraps>

c0102d9f <vector137>:
.globl vector137
vector137:
  pushl $0
c0102d9f:	6a 00                	push   $0x0
  pushl $137
c0102da1:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102da6:	e9 88 05 00 00       	jmp    c0103333 <__alltraps>

c0102dab <vector138>:
.globl vector138
vector138:
  pushl $0
c0102dab:	6a 00                	push   $0x0
  pushl $138
c0102dad:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102db2:	e9 7c 05 00 00       	jmp    c0103333 <__alltraps>

c0102db7 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102db7:	6a 00                	push   $0x0
  pushl $139
c0102db9:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102dbe:	e9 70 05 00 00       	jmp    c0103333 <__alltraps>

c0102dc3 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102dc3:	6a 00                	push   $0x0
  pushl $140
c0102dc5:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102dca:	e9 64 05 00 00       	jmp    c0103333 <__alltraps>

c0102dcf <vector141>:
.globl vector141
vector141:
  pushl $0
c0102dcf:	6a 00                	push   $0x0
  pushl $141
c0102dd1:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102dd6:	e9 58 05 00 00       	jmp    c0103333 <__alltraps>

c0102ddb <vector142>:
.globl vector142
vector142:
  pushl $0
c0102ddb:	6a 00                	push   $0x0
  pushl $142
c0102ddd:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102de2:	e9 4c 05 00 00       	jmp    c0103333 <__alltraps>

c0102de7 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102de7:	6a 00                	push   $0x0
  pushl $143
c0102de9:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102dee:	e9 40 05 00 00       	jmp    c0103333 <__alltraps>

c0102df3 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102df3:	6a 00                	push   $0x0
  pushl $144
c0102df5:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102dfa:	e9 34 05 00 00       	jmp    c0103333 <__alltraps>

c0102dff <vector145>:
.globl vector145
vector145:
  pushl $0
c0102dff:	6a 00                	push   $0x0
  pushl $145
c0102e01:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102e06:	e9 28 05 00 00       	jmp    c0103333 <__alltraps>

c0102e0b <vector146>:
.globl vector146
vector146:
  pushl $0
c0102e0b:	6a 00                	push   $0x0
  pushl $146
c0102e0d:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102e12:	e9 1c 05 00 00       	jmp    c0103333 <__alltraps>

c0102e17 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102e17:	6a 00                	push   $0x0
  pushl $147
c0102e19:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102e1e:	e9 10 05 00 00       	jmp    c0103333 <__alltraps>

c0102e23 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102e23:	6a 00                	push   $0x0
  pushl $148
c0102e25:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102e2a:	e9 04 05 00 00       	jmp    c0103333 <__alltraps>

c0102e2f <vector149>:
.globl vector149
vector149:
  pushl $0
c0102e2f:	6a 00                	push   $0x0
  pushl $149
c0102e31:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102e36:	e9 f8 04 00 00       	jmp    c0103333 <__alltraps>

c0102e3b <vector150>:
.globl vector150
vector150:
  pushl $0
c0102e3b:	6a 00                	push   $0x0
  pushl $150
c0102e3d:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102e42:	e9 ec 04 00 00       	jmp    c0103333 <__alltraps>

c0102e47 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102e47:	6a 00                	push   $0x0
  pushl $151
c0102e49:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102e4e:	e9 e0 04 00 00       	jmp    c0103333 <__alltraps>

c0102e53 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102e53:	6a 00                	push   $0x0
  pushl $152
c0102e55:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102e5a:	e9 d4 04 00 00       	jmp    c0103333 <__alltraps>

c0102e5f <vector153>:
.globl vector153
vector153:
  pushl $0
c0102e5f:	6a 00                	push   $0x0
  pushl $153
c0102e61:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102e66:	e9 c8 04 00 00       	jmp    c0103333 <__alltraps>

c0102e6b <vector154>:
.globl vector154
vector154:
  pushl $0
c0102e6b:	6a 00                	push   $0x0
  pushl $154
c0102e6d:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102e72:	e9 bc 04 00 00       	jmp    c0103333 <__alltraps>

c0102e77 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102e77:	6a 00                	push   $0x0
  pushl $155
c0102e79:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102e7e:	e9 b0 04 00 00       	jmp    c0103333 <__alltraps>

c0102e83 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102e83:	6a 00                	push   $0x0
  pushl $156
c0102e85:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102e8a:	e9 a4 04 00 00       	jmp    c0103333 <__alltraps>

c0102e8f <vector157>:
.globl vector157
vector157:
  pushl $0
c0102e8f:	6a 00                	push   $0x0
  pushl $157
c0102e91:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e96:	e9 98 04 00 00       	jmp    c0103333 <__alltraps>

c0102e9b <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e9b:	6a 00                	push   $0x0
  pushl $158
c0102e9d:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102ea2:	e9 8c 04 00 00       	jmp    c0103333 <__alltraps>

c0102ea7 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102ea7:	6a 00                	push   $0x0
  pushl $159
c0102ea9:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102eae:	e9 80 04 00 00       	jmp    c0103333 <__alltraps>

c0102eb3 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102eb3:	6a 00                	push   $0x0
  pushl $160
c0102eb5:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102eba:	e9 74 04 00 00       	jmp    c0103333 <__alltraps>

c0102ebf <vector161>:
.globl vector161
vector161:
  pushl $0
c0102ebf:	6a 00                	push   $0x0
  pushl $161
c0102ec1:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102ec6:	e9 68 04 00 00       	jmp    c0103333 <__alltraps>

c0102ecb <vector162>:
.globl vector162
vector162:
  pushl $0
c0102ecb:	6a 00                	push   $0x0
  pushl $162
c0102ecd:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102ed2:	e9 5c 04 00 00       	jmp    c0103333 <__alltraps>

c0102ed7 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102ed7:	6a 00                	push   $0x0
  pushl $163
c0102ed9:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102ede:	e9 50 04 00 00       	jmp    c0103333 <__alltraps>

c0102ee3 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102ee3:	6a 00                	push   $0x0
  pushl $164
c0102ee5:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102eea:	e9 44 04 00 00       	jmp    c0103333 <__alltraps>

c0102eef <vector165>:
.globl vector165
vector165:
  pushl $0
c0102eef:	6a 00                	push   $0x0
  pushl $165
c0102ef1:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ef6:	e9 38 04 00 00       	jmp    c0103333 <__alltraps>

c0102efb <vector166>:
.globl vector166
vector166:
  pushl $0
c0102efb:	6a 00                	push   $0x0
  pushl $166
c0102efd:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102f02:	e9 2c 04 00 00       	jmp    c0103333 <__alltraps>

c0102f07 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102f07:	6a 00                	push   $0x0
  pushl $167
c0102f09:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102f0e:	e9 20 04 00 00       	jmp    c0103333 <__alltraps>

c0102f13 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102f13:	6a 00                	push   $0x0
  pushl $168
c0102f15:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102f1a:	e9 14 04 00 00       	jmp    c0103333 <__alltraps>

c0102f1f <vector169>:
.globl vector169
vector169:
  pushl $0
c0102f1f:	6a 00                	push   $0x0
  pushl $169
c0102f21:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102f26:	e9 08 04 00 00       	jmp    c0103333 <__alltraps>

c0102f2b <vector170>:
.globl vector170
vector170:
  pushl $0
c0102f2b:	6a 00                	push   $0x0
  pushl $170
c0102f2d:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102f32:	e9 fc 03 00 00       	jmp    c0103333 <__alltraps>

c0102f37 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102f37:	6a 00                	push   $0x0
  pushl $171
c0102f39:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102f3e:	e9 f0 03 00 00       	jmp    c0103333 <__alltraps>

c0102f43 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102f43:	6a 00                	push   $0x0
  pushl $172
c0102f45:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102f4a:	e9 e4 03 00 00       	jmp    c0103333 <__alltraps>

c0102f4f <vector173>:
.globl vector173
vector173:
  pushl $0
c0102f4f:	6a 00                	push   $0x0
  pushl $173
c0102f51:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102f56:	e9 d8 03 00 00       	jmp    c0103333 <__alltraps>

c0102f5b <vector174>:
.globl vector174
vector174:
  pushl $0
c0102f5b:	6a 00                	push   $0x0
  pushl $174
c0102f5d:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102f62:	e9 cc 03 00 00       	jmp    c0103333 <__alltraps>

c0102f67 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102f67:	6a 00                	push   $0x0
  pushl $175
c0102f69:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102f6e:	e9 c0 03 00 00       	jmp    c0103333 <__alltraps>

c0102f73 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102f73:	6a 00                	push   $0x0
  pushl $176
c0102f75:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102f7a:	e9 b4 03 00 00       	jmp    c0103333 <__alltraps>

c0102f7f <vector177>:
.globl vector177
vector177:
  pushl $0
c0102f7f:	6a 00                	push   $0x0
  pushl $177
c0102f81:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102f86:	e9 a8 03 00 00       	jmp    c0103333 <__alltraps>

c0102f8b <vector178>:
.globl vector178
vector178:
  pushl $0
c0102f8b:	6a 00                	push   $0x0
  pushl $178
c0102f8d:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102f92:	e9 9c 03 00 00       	jmp    c0103333 <__alltraps>

c0102f97 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f97:	6a 00                	push   $0x0
  pushl $179
c0102f99:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f9e:	e9 90 03 00 00       	jmp    c0103333 <__alltraps>

c0102fa3 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102fa3:	6a 00                	push   $0x0
  pushl $180
c0102fa5:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102faa:	e9 84 03 00 00       	jmp    c0103333 <__alltraps>

c0102faf <vector181>:
.globl vector181
vector181:
  pushl $0
c0102faf:	6a 00                	push   $0x0
  pushl $181
c0102fb1:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102fb6:	e9 78 03 00 00       	jmp    c0103333 <__alltraps>

c0102fbb <vector182>:
.globl vector182
vector182:
  pushl $0
c0102fbb:	6a 00                	push   $0x0
  pushl $182
c0102fbd:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102fc2:	e9 6c 03 00 00       	jmp    c0103333 <__alltraps>

c0102fc7 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102fc7:	6a 00                	push   $0x0
  pushl $183
c0102fc9:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102fce:	e9 60 03 00 00       	jmp    c0103333 <__alltraps>

c0102fd3 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102fd3:	6a 00                	push   $0x0
  pushl $184
c0102fd5:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102fda:	e9 54 03 00 00       	jmp    c0103333 <__alltraps>

c0102fdf <vector185>:
.globl vector185
vector185:
  pushl $0
c0102fdf:	6a 00                	push   $0x0
  pushl $185
c0102fe1:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102fe6:	e9 48 03 00 00       	jmp    c0103333 <__alltraps>

c0102feb <vector186>:
.globl vector186
vector186:
  pushl $0
c0102feb:	6a 00                	push   $0x0
  pushl $186
c0102fed:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ff2:	e9 3c 03 00 00       	jmp    c0103333 <__alltraps>

c0102ff7 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ff7:	6a 00                	push   $0x0
  pushl $187
c0102ff9:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ffe:	e9 30 03 00 00       	jmp    c0103333 <__alltraps>

c0103003 <vector188>:
.globl vector188
vector188:
  pushl $0
c0103003:	6a 00                	push   $0x0
  pushl $188
c0103005:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010300a:	e9 24 03 00 00       	jmp    c0103333 <__alltraps>

c010300f <vector189>:
.globl vector189
vector189:
  pushl $0
c010300f:	6a 00                	push   $0x0
  pushl $189
c0103011:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0103016:	e9 18 03 00 00       	jmp    c0103333 <__alltraps>

c010301b <vector190>:
.globl vector190
vector190:
  pushl $0
c010301b:	6a 00                	push   $0x0
  pushl $190
c010301d:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0103022:	e9 0c 03 00 00       	jmp    c0103333 <__alltraps>

c0103027 <vector191>:
.globl vector191
vector191:
  pushl $0
c0103027:	6a 00                	push   $0x0
  pushl $191
c0103029:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010302e:	e9 00 03 00 00       	jmp    c0103333 <__alltraps>

c0103033 <vector192>:
.globl vector192
vector192:
  pushl $0
c0103033:	6a 00                	push   $0x0
  pushl $192
c0103035:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010303a:	e9 f4 02 00 00       	jmp    c0103333 <__alltraps>

c010303f <vector193>:
.globl vector193
vector193:
  pushl $0
c010303f:	6a 00                	push   $0x0
  pushl $193
c0103041:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0103046:	e9 e8 02 00 00       	jmp    c0103333 <__alltraps>

c010304b <vector194>:
.globl vector194
vector194:
  pushl $0
c010304b:	6a 00                	push   $0x0
  pushl $194
c010304d:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103052:	e9 dc 02 00 00       	jmp    c0103333 <__alltraps>

c0103057 <vector195>:
.globl vector195
vector195:
  pushl $0
c0103057:	6a 00                	push   $0x0
  pushl $195
c0103059:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010305e:	e9 d0 02 00 00       	jmp    c0103333 <__alltraps>

c0103063 <vector196>:
.globl vector196
vector196:
  pushl $0
c0103063:	6a 00                	push   $0x0
  pushl $196
c0103065:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010306a:	e9 c4 02 00 00       	jmp    c0103333 <__alltraps>

c010306f <vector197>:
.globl vector197
vector197:
  pushl $0
c010306f:	6a 00                	push   $0x0
  pushl $197
c0103071:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103076:	e9 b8 02 00 00       	jmp    c0103333 <__alltraps>

c010307b <vector198>:
.globl vector198
vector198:
  pushl $0
c010307b:	6a 00                	push   $0x0
  pushl $198
c010307d:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103082:	e9 ac 02 00 00       	jmp    c0103333 <__alltraps>

c0103087 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103087:	6a 00                	push   $0x0
  pushl $199
c0103089:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010308e:	e9 a0 02 00 00       	jmp    c0103333 <__alltraps>

c0103093 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103093:	6a 00                	push   $0x0
  pushl $200
c0103095:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010309a:	e9 94 02 00 00       	jmp    c0103333 <__alltraps>

c010309f <vector201>:
.globl vector201
vector201:
  pushl $0
c010309f:	6a 00                	push   $0x0
  pushl $201
c01030a1:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01030a6:	e9 88 02 00 00       	jmp    c0103333 <__alltraps>

c01030ab <vector202>:
.globl vector202
vector202:
  pushl $0
c01030ab:	6a 00                	push   $0x0
  pushl $202
c01030ad:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01030b2:	e9 7c 02 00 00       	jmp    c0103333 <__alltraps>

c01030b7 <vector203>:
.globl vector203
vector203:
  pushl $0
c01030b7:	6a 00                	push   $0x0
  pushl $203
c01030b9:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01030be:	e9 70 02 00 00       	jmp    c0103333 <__alltraps>

c01030c3 <vector204>:
.globl vector204
vector204:
  pushl $0
c01030c3:	6a 00                	push   $0x0
  pushl $204
c01030c5:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01030ca:	e9 64 02 00 00       	jmp    c0103333 <__alltraps>

c01030cf <vector205>:
.globl vector205
vector205:
  pushl $0
c01030cf:	6a 00                	push   $0x0
  pushl $205
c01030d1:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01030d6:	e9 58 02 00 00       	jmp    c0103333 <__alltraps>

c01030db <vector206>:
.globl vector206
vector206:
  pushl $0
c01030db:	6a 00                	push   $0x0
  pushl $206
c01030dd:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01030e2:	e9 4c 02 00 00       	jmp    c0103333 <__alltraps>

c01030e7 <vector207>:
.globl vector207
vector207:
  pushl $0
c01030e7:	6a 00                	push   $0x0
  pushl $207
c01030e9:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01030ee:	e9 40 02 00 00       	jmp    c0103333 <__alltraps>

c01030f3 <vector208>:
.globl vector208
vector208:
  pushl $0
c01030f3:	6a 00                	push   $0x0
  pushl $208
c01030f5:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01030fa:	e9 34 02 00 00       	jmp    c0103333 <__alltraps>

c01030ff <vector209>:
.globl vector209
vector209:
  pushl $0
c01030ff:	6a 00                	push   $0x0
  pushl $209
c0103101:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103106:	e9 28 02 00 00       	jmp    c0103333 <__alltraps>

c010310b <vector210>:
.globl vector210
vector210:
  pushl $0
c010310b:	6a 00                	push   $0x0
  pushl $210
c010310d:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103112:	e9 1c 02 00 00       	jmp    c0103333 <__alltraps>

c0103117 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103117:	6a 00                	push   $0x0
  pushl $211
c0103119:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010311e:	e9 10 02 00 00       	jmp    c0103333 <__alltraps>

c0103123 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103123:	6a 00                	push   $0x0
  pushl $212
c0103125:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010312a:	e9 04 02 00 00       	jmp    c0103333 <__alltraps>

c010312f <vector213>:
.globl vector213
vector213:
  pushl $0
c010312f:	6a 00                	push   $0x0
  pushl $213
c0103131:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103136:	e9 f8 01 00 00       	jmp    c0103333 <__alltraps>

c010313b <vector214>:
.globl vector214
vector214:
  pushl $0
c010313b:	6a 00                	push   $0x0
  pushl $214
c010313d:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103142:	e9 ec 01 00 00       	jmp    c0103333 <__alltraps>

c0103147 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103147:	6a 00                	push   $0x0
  pushl $215
c0103149:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010314e:	e9 e0 01 00 00       	jmp    c0103333 <__alltraps>

c0103153 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103153:	6a 00                	push   $0x0
  pushl $216
c0103155:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010315a:	e9 d4 01 00 00       	jmp    c0103333 <__alltraps>

c010315f <vector217>:
.globl vector217
vector217:
  pushl $0
c010315f:	6a 00                	push   $0x0
  pushl $217
c0103161:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103166:	e9 c8 01 00 00       	jmp    c0103333 <__alltraps>

c010316b <vector218>:
.globl vector218
vector218:
  pushl $0
c010316b:	6a 00                	push   $0x0
  pushl $218
c010316d:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103172:	e9 bc 01 00 00       	jmp    c0103333 <__alltraps>

c0103177 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103177:	6a 00                	push   $0x0
  pushl $219
c0103179:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010317e:	e9 b0 01 00 00       	jmp    c0103333 <__alltraps>

c0103183 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103183:	6a 00                	push   $0x0
  pushl $220
c0103185:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010318a:	e9 a4 01 00 00       	jmp    c0103333 <__alltraps>

c010318f <vector221>:
.globl vector221
vector221:
  pushl $0
c010318f:	6a 00                	push   $0x0
  pushl $221
c0103191:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103196:	e9 98 01 00 00       	jmp    c0103333 <__alltraps>

c010319b <vector222>:
.globl vector222
vector222:
  pushl $0
c010319b:	6a 00                	push   $0x0
  pushl $222
c010319d:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01031a2:	e9 8c 01 00 00       	jmp    c0103333 <__alltraps>

c01031a7 <vector223>:
.globl vector223
vector223:
  pushl $0
c01031a7:	6a 00                	push   $0x0
  pushl $223
c01031a9:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01031ae:	e9 80 01 00 00       	jmp    c0103333 <__alltraps>

c01031b3 <vector224>:
.globl vector224
vector224:
  pushl $0
c01031b3:	6a 00                	push   $0x0
  pushl $224
c01031b5:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01031ba:	e9 74 01 00 00       	jmp    c0103333 <__alltraps>

c01031bf <vector225>:
.globl vector225
vector225:
  pushl $0
c01031bf:	6a 00                	push   $0x0
  pushl $225
c01031c1:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01031c6:	e9 68 01 00 00       	jmp    c0103333 <__alltraps>

c01031cb <vector226>:
.globl vector226
vector226:
  pushl $0
c01031cb:	6a 00                	push   $0x0
  pushl $226
c01031cd:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01031d2:	e9 5c 01 00 00       	jmp    c0103333 <__alltraps>

c01031d7 <vector227>:
.globl vector227
vector227:
  pushl $0
c01031d7:	6a 00                	push   $0x0
  pushl $227
c01031d9:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01031de:	e9 50 01 00 00       	jmp    c0103333 <__alltraps>

c01031e3 <vector228>:
.globl vector228
vector228:
  pushl $0
c01031e3:	6a 00                	push   $0x0
  pushl $228
c01031e5:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01031ea:	e9 44 01 00 00       	jmp    c0103333 <__alltraps>

c01031ef <vector229>:
.globl vector229
vector229:
  pushl $0
c01031ef:	6a 00                	push   $0x0
  pushl $229
c01031f1:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01031f6:	e9 38 01 00 00       	jmp    c0103333 <__alltraps>

c01031fb <vector230>:
.globl vector230
vector230:
  pushl $0
c01031fb:	6a 00                	push   $0x0
  pushl $230
c01031fd:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103202:	e9 2c 01 00 00       	jmp    c0103333 <__alltraps>

c0103207 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103207:	6a 00                	push   $0x0
  pushl $231
c0103209:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010320e:	e9 20 01 00 00       	jmp    c0103333 <__alltraps>

c0103213 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103213:	6a 00                	push   $0x0
  pushl $232
c0103215:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010321a:	e9 14 01 00 00       	jmp    c0103333 <__alltraps>

c010321f <vector233>:
.globl vector233
vector233:
  pushl $0
c010321f:	6a 00                	push   $0x0
  pushl $233
c0103221:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103226:	e9 08 01 00 00       	jmp    c0103333 <__alltraps>

c010322b <vector234>:
.globl vector234
vector234:
  pushl $0
c010322b:	6a 00                	push   $0x0
  pushl $234
c010322d:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103232:	e9 fc 00 00 00       	jmp    c0103333 <__alltraps>

c0103237 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103237:	6a 00                	push   $0x0
  pushl $235
c0103239:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010323e:	e9 f0 00 00 00       	jmp    c0103333 <__alltraps>

c0103243 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103243:	6a 00                	push   $0x0
  pushl $236
c0103245:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010324a:	e9 e4 00 00 00       	jmp    c0103333 <__alltraps>

c010324f <vector237>:
.globl vector237
vector237:
  pushl $0
c010324f:	6a 00                	push   $0x0
  pushl $237
c0103251:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103256:	e9 d8 00 00 00       	jmp    c0103333 <__alltraps>

c010325b <vector238>:
.globl vector238
vector238:
  pushl $0
c010325b:	6a 00                	push   $0x0
  pushl $238
c010325d:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103262:	e9 cc 00 00 00       	jmp    c0103333 <__alltraps>

c0103267 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103267:	6a 00                	push   $0x0
  pushl $239
c0103269:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010326e:	e9 c0 00 00 00       	jmp    c0103333 <__alltraps>

c0103273 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103273:	6a 00                	push   $0x0
  pushl $240
c0103275:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010327a:	e9 b4 00 00 00       	jmp    c0103333 <__alltraps>

c010327f <vector241>:
.globl vector241
vector241:
  pushl $0
c010327f:	6a 00                	push   $0x0
  pushl $241
c0103281:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103286:	e9 a8 00 00 00       	jmp    c0103333 <__alltraps>

c010328b <vector242>:
.globl vector242
vector242:
  pushl $0
c010328b:	6a 00                	push   $0x0
  pushl $242
c010328d:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103292:	e9 9c 00 00 00       	jmp    c0103333 <__alltraps>

c0103297 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103297:	6a 00                	push   $0x0
  pushl $243
c0103299:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010329e:	e9 90 00 00 00       	jmp    c0103333 <__alltraps>

c01032a3 <vector244>:
.globl vector244
vector244:
  pushl $0
c01032a3:	6a 00                	push   $0x0
  pushl $244
c01032a5:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01032aa:	e9 84 00 00 00       	jmp    c0103333 <__alltraps>

c01032af <vector245>:
.globl vector245
vector245:
  pushl $0
c01032af:	6a 00                	push   $0x0
  pushl $245
c01032b1:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01032b6:	e9 78 00 00 00       	jmp    c0103333 <__alltraps>

c01032bb <vector246>:
.globl vector246
vector246:
  pushl $0
c01032bb:	6a 00                	push   $0x0
  pushl $246
c01032bd:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01032c2:	e9 6c 00 00 00       	jmp    c0103333 <__alltraps>

c01032c7 <vector247>:
.globl vector247
vector247:
  pushl $0
c01032c7:	6a 00                	push   $0x0
  pushl $247
c01032c9:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01032ce:	e9 60 00 00 00       	jmp    c0103333 <__alltraps>

c01032d3 <vector248>:
.globl vector248
vector248:
  pushl $0
c01032d3:	6a 00                	push   $0x0
  pushl $248
c01032d5:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01032da:	e9 54 00 00 00       	jmp    c0103333 <__alltraps>

c01032df <vector249>:
.globl vector249
vector249:
  pushl $0
c01032df:	6a 00                	push   $0x0
  pushl $249
c01032e1:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01032e6:	e9 48 00 00 00       	jmp    c0103333 <__alltraps>

c01032eb <vector250>:
.globl vector250
vector250:
  pushl $0
c01032eb:	6a 00                	push   $0x0
  pushl $250
c01032ed:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01032f2:	e9 3c 00 00 00       	jmp    c0103333 <__alltraps>

c01032f7 <vector251>:
.globl vector251
vector251:
  pushl $0
c01032f7:	6a 00                	push   $0x0
  pushl $251
c01032f9:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01032fe:	e9 30 00 00 00       	jmp    c0103333 <__alltraps>

c0103303 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103303:	6a 00                	push   $0x0
  pushl $252
c0103305:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010330a:	e9 24 00 00 00       	jmp    c0103333 <__alltraps>

c010330f <vector253>:
.globl vector253
vector253:
  pushl $0
c010330f:	6a 00                	push   $0x0
  pushl $253
c0103311:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103316:	e9 18 00 00 00       	jmp    c0103333 <__alltraps>

c010331b <vector254>:
.globl vector254
vector254:
  pushl $0
c010331b:	6a 00                	push   $0x0
  pushl $254
c010331d:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103322:	e9 0c 00 00 00       	jmp    c0103333 <__alltraps>

c0103327 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103327:	6a 00                	push   $0x0
  pushl $255
c0103329:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010332e:	e9 00 00 00 00       	jmp    c0103333 <__alltraps>

c0103333 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0103333:	1e                   	push   %ds
    pushl %es
c0103334:	06                   	push   %es
    pushl %fs
c0103335:	0f a0                	push   %fs
    pushl %gs
c0103337:	0f a8                	push   %gs
    pushal
c0103339:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010333a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010333f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0103341:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0103343:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0103344:	e8 64 f5 ff ff       	call   c01028ad <trap>

    # pop the pushed stack pointer
    popl %esp
c0103349:	5c                   	pop    %esp

c010334a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010334a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010334b:	0f a9                	pop    %gs
    popl %fs
c010334d:	0f a1                	pop    %fs
    popl %es
c010334f:	07                   	pop    %es
    popl %ds
c0103350:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0103351:	83 c4 08             	add    $0x8,%esp
    iret
c0103354:	cf                   	iret   

c0103355 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103355:	55                   	push   %ebp
c0103356:	89 e5                	mov    %esp,%ebp
c0103358:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010335b:	8b 45 08             	mov    0x8(%ebp),%eax
c010335e:	c1 e8 0c             	shr    $0xc,%eax
c0103361:	89 c2                	mov    %eax,%edx
c0103363:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0103368:	39 c2                	cmp    %eax,%edx
c010336a:	72 1c                	jb     c0103388 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010336c:	c7 44 24 08 90 96 10 	movl   $0xc0109690,0x8(%esp)
c0103373:	c0 
c0103374:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010337b:	00 
c010337c:	c7 04 24 af 96 10 c0 	movl   $0xc01096af,(%esp)
c0103383:	e8 7b d0 ff ff       	call   c0100403 <__panic>
    }
    return &pages[PPN(pa)];
c0103388:	a1 00 41 12 c0       	mov    0xc0124100,%eax
c010338d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103390:	c1 ea 0c             	shr    $0xc,%edx
c0103393:	c1 e2 05             	shl    $0x5,%edx
c0103396:	01 d0                	add    %edx,%eax
}
c0103398:	c9                   	leave  
c0103399:	c3                   	ret    

c010339a <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c010339a:	55                   	push   %ebp
c010339b:	89 e5                	mov    %esp,%ebp
c010339d:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01033a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01033a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01033a8:	89 04 24             	mov    %eax,(%esp)
c01033ab:	e8 a5 ff ff ff       	call   c0103355 <pa2page>
}
c01033b0:	c9                   	leave  
c01033b1:	c3                   	ret    

c01033b2 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01033b2:	55                   	push   %ebp
c01033b3:	89 e5                	mov    %esp,%ebp
c01033b5:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01033b8:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01033bf:	e8 4b 4b 00 00       	call   c0107f0f <kmalloc>
c01033c4:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01033c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033cb:	74 58                	je     c0103425 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01033d9:	89 50 04             	mov    %edx,0x4(%eax)
c01033dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033df:	8b 50 04             	mov    0x4(%eax),%edx
c01033e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e5:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c01033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033fe:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103405:	a1 68 3f 12 c0       	mov    0xc0123f68,%eax
c010340a:	85 c0                	test   %eax,%eax
c010340c:	74 0d                	je     c010341b <mm_create+0x69>
c010340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103411:	89 04 24             	mov    %eax,(%esp)
c0103414:	e8 e3 0d 00 00       	call   c01041fc <swap_init_mm>
c0103419:	eb 0a                	jmp    c0103425 <mm_create+0x73>
        else mm->sm_priv = NULL;
c010341b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010341e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103425:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103428:	c9                   	leave  
c0103429:	c3                   	ret    

c010342a <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010342a:	55                   	push   %ebp
c010342b:	89 e5                	mov    %esp,%ebp
c010342d:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0103430:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0103437:	e8 d3 4a 00 00       	call   c0107f0f <kmalloc>
c010343c:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103443:	74 1b                	je     c0103460 <vma_create+0x36>
        vma->vm_start = vm_start;
c0103445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103448:	8b 55 08             	mov    0x8(%ebp),%edx
c010344b:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010344e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103451:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103454:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103457:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010345a:	8b 55 10             	mov    0x10(%ebp),%edx
c010345d:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0103460:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103463:	c9                   	leave  
c0103464:	c3                   	ret    

c0103465 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0103465:	55                   	push   %ebp
c0103466:	89 e5                	mov    %esp,%ebp
c0103468:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c010346b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0103472:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103476:	0f 84 95 00 00 00    	je     c0103511 <find_vma+0xac>
        vma = mm->mmap_cache;
c010347c:	8b 45 08             	mov    0x8(%ebp),%eax
c010347f:	8b 40 08             	mov    0x8(%eax),%eax
c0103482:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103485:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103489:	74 16                	je     c01034a1 <find_vma+0x3c>
c010348b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010348e:	8b 40 04             	mov    0x4(%eax),%eax
c0103491:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0103494:	72 0b                	jb     c01034a1 <find_vma+0x3c>
c0103496:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103499:	8b 40 08             	mov    0x8(%eax),%eax
c010349c:	39 45 0c             	cmp    %eax,0xc(%ebp)
c010349f:	72 61                	jb     c0103502 <find_vma+0x9d>
                bool found = 0;
c01034a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01034a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01034ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01034b4:	eb 28                	jmp    c01034de <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b9:	83 e8 10             	sub    $0x10,%eax
c01034bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01034bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034c2:	8b 40 04             	mov    0x4(%eax),%eax
c01034c5:	39 45 0c             	cmp    %eax,0xc(%ebp)
c01034c8:	72 14                	jb     c01034de <find_vma+0x79>
c01034ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034cd:	8b 40 08             	mov    0x8(%eax),%eax
c01034d0:	39 45 0c             	cmp    %eax,0xc(%ebp)
c01034d3:	73 09                	jae    c01034de <find_vma+0x79>
                        found = 1;
c01034d5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01034dc:	eb 17                	jmp    c01034f5 <find_vma+0x90>
c01034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e7:	8b 40 04             	mov    0x4(%eax),%eax
                while ((le = list_next(le)) != list) {
c01034ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01034f3:	75 c1                	jne    c01034b6 <find_vma+0x51>
                    }
                }
                if (!found) {
c01034f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01034f9:	75 07                	jne    c0103502 <find_vma+0x9d>
                    vma = NULL;
c01034fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103502:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103506:	74 09                	je     c0103511 <find_vma+0xac>
            mm->mmap_cache = vma;
c0103508:	8b 45 08             	mov    0x8(%ebp),%eax
c010350b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010350e:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103511:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103514:	c9                   	leave  
c0103515:	c3                   	ret    

c0103516 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103516:	55                   	push   %ebp
c0103517:	89 e5                	mov    %esp,%ebp
c0103519:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010351c:	8b 45 08             	mov    0x8(%ebp),%eax
c010351f:	8b 50 04             	mov    0x4(%eax),%edx
c0103522:	8b 45 08             	mov    0x8(%ebp),%eax
c0103525:	8b 40 08             	mov    0x8(%eax),%eax
c0103528:	39 c2                	cmp    %eax,%edx
c010352a:	72 24                	jb     c0103550 <check_vma_overlap+0x3a>
c010352c:	c7 44 24 0c bd 96 10 	movl   $0xc01096bd,0xc(%esp)
c0103533:	c0 
c0103534:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c010353b:	c0 
c010353c:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0103543:	00 
c0103544:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c010354b:	e8 b3 ce ff ff       	call   c0100403 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103550:	8b 45 08             	mov    0x8(%ebp),%eax
c0103553:	8b 50 08             	mov    0x8(%eax),%edx
c0103556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103559:	8b 40 04             	mov    0x4(%eax),%eax
c010355c:	39 c2                	cmp    %eax,%edx
c010355e:	76 24                	jbe    c0103584 <check_vma_overlap+0x6e>
c0103560:	c7 44 24 0c 00 97 10 	movl   $0xc0109700,0xc(%esp)
c0103567:	c0 
c0103568:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c010356f:	c0 
c0103570:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0103577:	00 
c0103578:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c010357f:	e8 7f ce ff ff       	call   c0100403 <__panic>
    assert(next->vm_start < next->vm_end);
c0103584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103587:	8b 50 04             	mov    0x4(%eax),%edx
c010358a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010358d:	8b 40 08             	mov    0x8(%eax),%eax
c0103590:	39 c2                	cmp    %eax,%edx
c0103592:	72 24                	jb     c01035b8 <check_vma_overlap+0xa2>
c0103594:	c7 44 24 0c 1f 97 10 	movl   $0xc010971f,0xc(%esp)
c010359b:	c0 
c010359c:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c01035a3:	c0 
c01035a4:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01035ab:	00 
c01035ac:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c01035b3:	e8 4b ce ff ff       	call   c0100403 <__panic>
}
c01035b8:	90                   	nop
c01035b9:	c9                   	leave  
c01035ba:	c3                   	ret    

c01035bb <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01035bb:	55                   	push   %ebp
c01035bc:	89 e5                	mov    %esp,%ebp
c01035be:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01035c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035c4:	8b 50 04             	mov    0x4(%eax),%edx
c01035c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035ca:	8b 40 08             	mov    0x8(%eax),%eax
c01035cd:	39 c2                	cmp    %eax,%edx
c01035cf:	72 24                	jb     c01035f5 <insert_vma_struct+0x3a>
c01035d1:	c7 44 24 0c 3d 97 10 	movl   $0xc010973d,0xc(%esp)
c01035d8:	c0 
c01035d9:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c01035e0:	c0 
c01035e1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01035e8:	00 
c01035e9:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c01035f0:	e8 0e ce ff ff       	call   c0100403 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c01035f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c01035fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0103601:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103604:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0103607:	eb 1f                	jmp    c0103628 <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103609:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010360c:	83 e8 10             	sub    $0x10,%eax
c010360f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0103612:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103615:	8b 50 04             	mov    0x4(%eax),%edx
c0103618:	8b 45 0c             	mov    0xc(%ebp),%eax
c010361b:	8b 40 04             	mov    0x4(%eax),%eax
c010361e:	39 c2                	cmp    %eax,%edx
c0103620:	77 1f                	ja     c0103641 <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c0103622:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103625:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103628:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010362b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010362e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103631:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0103634:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103637:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010363a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010363d:	75 ca                	jne    c0103609 <insert_vma_struct+0x4e>
c010363f:	eb 01                	jmp    c0103642 <insert_vma_struct+0x87>
                break;
c0103641:	90                   	nop
c0103642:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103645:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103648:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010364b:	8b 40 04             	mov    0x4(%eax),%eax
        }

    le_next = list_next(le_prev);
c010364e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103654:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103657:	74 15                	je     c010366e <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103659:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010365c:	8d 50 f0             	lea    -0x10(%eax),%edx
c010365f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103662:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103666:	89 14 24             	mov    %edx,(%esp)
c0103669:	e8 a8 fe ff ff       	call   c0103516 <check_vma_overlap>
    }
    if (le_next != list) {
c010366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103671:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103674:	74 15                	je     c010368b <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103679:	83 e8 10             	sub    $0x10,%eax
c010367c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103680:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103683:	89 04 24             	mov    %eax,(%esp)
c0103686:	e8 8b fe ff ff       	call   c0103516 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c010368b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010368e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103691:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103696:	8d 50 10             	lea    0x10(%eax),%edx
c0103699:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010369c:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010369f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c01036a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01036a5:	8b 40 04             	mov    0x4(%eax),%eax
c01036a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036ab:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01036ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01036b1:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01036b4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01036b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036ba:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01036bd:	89 10                	mov    %edx,(%eax)
c01036bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036c2:	8b 10                	mov    (%eax),%edx
c01036c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01036c7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01036ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036cd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01036d0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01036d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036d6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01036d9:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01036db:	8b 45 08             	mov    0x8(%ebp),%eax
c01036de:	8b 40 10             	mov    0x10(%eax),%eax
c01036e1:	8d 50 01             	lea    0x1(%eax),%edx
c01036e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e7:	89 50 10             	mov    %edx,0x10(%eax)
}
c01036ea:	90                   	nop
c01036eb:	c9                   	leave  
c01036ec:	c3                   	ret    

c01036ed <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01036ed:	55                   	push   %ebp
c01036ee:	89 e5                	mov    %esp,%ebp
c01036f0:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01036f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c01036f9:	eb 3e                	jmp    c0103739 <mm_destroy+0x4c>
c01036fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103701:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103704:	8b 40 04             	mov    0x4(%eax),%eax
c0103707:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010370a:	8b 12                	mov    (%edx),%edx
c010370c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010370f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103712:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103718:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010371b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010371e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103721:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0103723:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103726:	83 e8 10             	sub    $0x10,%eax
c0103729:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103730:	00 
c0103731:	89 04 24             	mov    %eax,(%esp)
c0103734:	e8 76 48 00 00       	call   c0107faf <kfree>
c0103739:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010373c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c010373f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103742:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list) {
c0103745:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103748:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010374b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010374e:	75 ab                	jne    c01036fb <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0103750:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103757:	00 
c0103758:	8b 45 08             	mov    0x8(%ebp),%eax
c010375b:	89 04 24             	mov    %eax,(%esp)
c010375e:	e8 4c 48 00 00       	call   c0107faf <kfree>
    mm=NULL;
c0103763:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c010376a:	90                   	nop
c010376b:	c9                   	leave  
c010376c:	c3                   	ret    

c010376d <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010376d:	55                   	push   %ebp
c010376e:	89 e5                	mov    %esp,%ebp
c0103770:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103773:	e8 03 00 00 00       	call   c010377b <check_vmm>
}
c0103778:	90                   	nop
c0103779:	c9                   	leave  
c010377a:	c3                   	ret    

c010377b <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010377b:	55                   	push   %ebp
c010377c:	89 e5                	mov    %esp,%ebp
c010377e:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103781:	e8 5d 30 00 00       	call   c01067e3 <nr_free_pages>
c0103786:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103789:	e8 42 00 00 00       	call   c01037d0 <check_vma_struct>
    check_pgfault();
c010378e:	e8 fd 04 00 00       	call   c0103c90 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0103793:	e8 4b 30 00 00       	call   c01067e3 <nr_free_pages>
c0103798:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010379b:	74 24                	je     c01037c1 <check_vmm+0x46>
c010379d:	c7 44 24 0c 5c 97 10 	movl   $0xc010975c,0xc(%esp)
c01037a4:	c0 
c01037a5:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c01037ac:	c0 
c01037ad:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c01037b4:	00 
c01037b5:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c01037bc:	e8 42 cc ff ff       	call   c0100403 <__panic>

    cprintf("check_vmm() succeeded.\n");
c01037c1:	c7 04 24 83 97 10 c0 	movl   $0xc0109783,(%esp)
c01037c8:	e8 df ca ff ff       	call   c01002ac <cprintf>
}
c01037cd:	90                   	nop
c01037ce:	c9                   	leave  
c01037cf:	c3                   	ret    

c01037d0 <check_vma_struct>:

static void
check_vma_struct(void) {
c01037d0:	55                   	push   %ebp
c01037d1:	89 e5                	mov    %esp,%ebp
c01037d3:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01037d6:	e8 08 30 00 00       	call   c01067e3 <nr_free_pages>
c01037db:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01037de:	e8 cf fb ff ff       	call   c01033b2 <mm_create>
c01037e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01037e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01037ea:	75 24                	jne    c0103810 <check_vma_struct+0x40>
c01037ec:	c7 44 24 0c 9b 97 10 	movl   $0xc010979b,0xc(%esp)
c01037f3:	c0 
c01037f4:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c01037fb:	c0 
c01037fc:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103803:	00 
c0103804:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c010380b:	e8 f3 cb ff ff       	call   c0100403 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103810:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103817:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010381a:	89 d0                	mov    %edx,%eax
c010381c:	c1 e0 02             	shl    $0x2,%eax
c010381f:	01 d0                	add    %edx,%eax
c0103821:	01 c0                	add    %eax,%eax
c0103823:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103829:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010382c:	eb 6f                	jmp    c010389d <check_vma_struct+0xcd>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010382e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103831:	89 d0                	mov    %edx,%eax
c0103833:	c1 e0 02             	shl    $0x2,%eax
c0103836:	01 d0                	add    %edx,%eax
c0103838:	83 c0 02             	add    $0x2,%eax
c010383b:	89 c1                	mov    %eax,%ecx
c010383d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103840:	89 d0                	mov    %edx,%eax
c0103842:	c1 e0 02             	shl    $0x2,%eax
c0103845:	01 d0                	add    %edx,%eax
c0103847:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010384e:	00 
c010384f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103853:	89 04 24             	mov    %eax,(%esp)
c0103856:	e8 cf fb ff ff       	call   c010342a <vma_create>
c010385b:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma != NULL);
c010385e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103862:	75 24                	jne    c0103888 <check_vma_struct+0xb8>
c0103864:	c7 44 24 0c a6 97 10 	movl   $0xc01097a6,0xc(%esp)
c010386b:	c0 
c010386c:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103873:	c0 
c0103874:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010387b:	00 
c010387c:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103883:	e8 7b cb ff ff       	call   c0100403 <__panic>
        insert_vma_struct(mm, vma);
c0103888:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010388b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010388f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103892:	89 04 24             	mov    %eax,(%esp)
c0103895:	e8 21 fd ff ff       	call   c01035bb <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
c010389a:	ff 4d f4             	decl   -0xc(%ebp)
c010389d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038a1:	7f 8b                	jg     c010382e <check_vma_struct+0x5e>
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01038a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038a6:	40                   	inc    %eax
c01038a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038aa:	eb 6f                	jmp    c010391b <check_vma_struct+0x14b>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01038ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038af:	89 d0                	mov    %edx,%eax
c01038b1:	c1 e0 02             	shl    $0x2,%eax
c01038b4:	01 d0                	add    %edx,%eax
c01038b6:	83 c0 02             	add    $0x2,%eax
c01038b9:	89 c1                	mov    %eax,%ecx
c01038bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038be:	89 d0                	mov    %edx,%eax
c01038c0:	c1 e0 02             	shl    $0x2,%eax
c01038c3:	01 d0                	add    %edx,%eax
c01038c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01038cc:	00 
c01038cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01038d1:	89 04 24             	mov    %eax,(%esp)
c01038d4:	e8 51 fb ff ff       	call   c010342a <vma_create>
c01038d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma != NULL);
c01038dc:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01038e0:	75 24                	jne    c0103906 <check_vma_struct+0x136>
c01038e2:	c7 44 24 0c a6 97 10 	movl   $0xc01097a6,0xc(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01038f9:	00 
c01038fa:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103901:	e8 fd ca ff ff       	call   c0100403 <__panic>
        insert_vma_struct(mm, vma);
c0103906:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103909:	89 44 24 04          	mov    %eax,0x4(%esp)
c010390d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103910:	89 04 24             	mov    %eax,(%esp)
c0103913:	e8 a3 fc ff ff       	call   c01035bb <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
c0103918:	ff 45 f4             	incl   -0xc(%ebp)
c010391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010391e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103921:	7e 89                	jle    c01038ac <check_vma_struct+0xdc>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103923:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103926:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103929:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010392c:	8b 40 04             	mov    0x4(%eax),%eax
c010392f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103932:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103939:	e9 96 00 00 00       	jmp    c01039d4 <check_vma_struct+0x204>
        assert(le != &(mm->mmap_list));
c010393e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103941:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103944:	75 24                	jne    c010396a <check_vma_struct+0x19a>
c0103946:	c7 44 24 0c b2 97 10 	movl   $0xc01097b2,0xc(%esp)
c010394d:	c0 
c010394e:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103955:	c0 
c0103956:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010395d:	00 
c010395e:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103965:	e8 99 ca ff ff       	call   c0100403 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c010396a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010396d:	83 e8 10             	sub    $0x10,%eax
c0103970:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103973:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103976:	8b 48 04             	mov    0x4(%eax),%ecx
c0103979:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010397c:	89 d0                	mov    %edx,%eax
c010397e:	c1 e0 02             	shl    $0x2,%eax
c0103981:	01 d0                	add    %edx,%eax
c0103983:	39 c1                	cmp    %eax,%ecx
c0103985:	75 17                	jne    c010399e <check_vma_struct+0x1ce>
c0103987:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010398a:	8b 48 08             	mov    0x8(%eax),%ecx
c010398d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103990:	89 d0                	mov    %edx,%eax
c0103992:	c1 e0 02             	shl    $0x2,%eax
c0103995:	01 d0                	add    %edx,%eax
c0103997:	83 c0 02             	add    $0x2,%eax
c010399a:	39 c1                	cmp    %eax,%ecx
c010399c:	74 24                	je     c01039c2 <check_vma_struct+0x1f2>
c010399e:	c7 44 24 0c cc 97 10 	movl   $0xc01097cc,0xc(%esp)
c01039a5:	c0 
c01039a6:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c01039ad:	c0 
c01039ae:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01039b5:	00 
c01039b6:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c01039bd:	e8 41 ca ff ff       	call   c0100403 <__panic>
c01039c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039c5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01039c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01039cb:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01039ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i ++) {
c01039d1:	ff 45 f4             	incl   -0xc(%ebp)
c01039d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01039da:	0f 8e 5e ff ff ff    	jle    c010393e <check_vma_struct+0x16e>
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01039e0:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01039e7:	e9 cb 01 00 00       	jmp    c0103bb7 <check_vma_struct+0x3e7>
        struct vma_struct *vma1 = find_vma(mm, i);
c01039ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039f6:	89 04 24             	mov    %eax,(%esp)
c01039f9:	e8 67 fa ff ff       	call   c0103465 <find_vma>
c01039fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma1 != NULL);
c0103a01:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103a05:	75 24                	jne    c0103a2b <check_vma_struct+0x25b>
c0103a07:	c7 44 24 0c 01 98 10 	movl   $0xc0109801,0xc(%esp)
c0103a0e:	c0 
c0103a0f:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103a16:	c0 
c0103a17:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103a1e:	00 
c0103a1f:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103a26:	e8 d8 c9 ff ff       	call   c0100403 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0103a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a2e:	40                   	inc    %eax
c0103a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a36:	89 04 24             	mov    %eax,(%esp)
c0103a39:	e8 27 fa ff ff       	call   c0103465 <find_vma>
c0103a3e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(vma2 != NULL);
c0103a41:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0103a45:	75 24                	jne    c0103a6b <check_vma_struct+0x29b>
c0103a47:	c7 44 24 0c 0e 98 10 	movl   $0xc010980e,0xc(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103a56:	c0 
c0103a57:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103a5e:	00 
c0103a5f:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103a66:	e8 98 c9 ff ff       	call   c0100403 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0103a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6e:	83 c0 02             	add    $0x2,%eax
c0103a71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a78:	89 04 24             	mov    %eax,(%esp)
c0103a7b:	e8 e5 f9 ff ff       	call   c0103465 <find_vma>
c0103a80:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma3 == NULL);
c0103a83:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103a87:	74 24                	je     c0103aad <check_vma_struct+0x2dd>
c0103a89:	c7 44 24 0c 1b 98 10 	movl   $0xc010981b,0xc(%esp)
c0103a90:	c0 
c0103a91:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103a98:	c0 
c0103a99:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103aa0:	00 
c0103aa1:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103aa8:	e8 56 c9 ff ff       	call   c0100403 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0103aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab0:	83 c0 03             	add    $0x3,%eax
c0103ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103aba:	89 04 24             	mov    %eax,(%esp)
c0103abd:	e8 a3 f9 ff ff       	call   c0103465 <find_vma>
c0103ac2:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma4 == NULL);
c0103ac5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103ac9:	74 24                	je     c0103aef <check_vma_struct+0x31f>
c0103acb:	c7 44 24 0c 28 98 10 	movl   $0xc0109828,0xc(%esp)
c0103ad2:	c0 
c0103ad3:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103ada:	c0 
c0103adb:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0103ae2:	00 
c0103ae3:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103aea:	e8 14 c9 ff ff       	call   c0100403 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0103aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103af2:	83 c0 04             	add    $0x4,%eax
c0103af5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103afc:	89 04 24             	mov    %eax,(%esp)
c0103aff:	e8 61 f9 ff ff       	call   c0103465 <find_vma>
c0103b04:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma5 == NULL);
c0103b07:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103b0b:	74 24                	je     c0103b31 <check_vma_struct+0x361>
c0103b0d:	c7 44 24 0c 35 98 10 	movl   $0xc0109835,0xc(%esp)
c0103b14:	c0 
c0103b15:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103b1c:	c0 
c0103b1d:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103b24:	00 
c0103b25:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103b2c:	e8 d2 c8 ff ff       	call   c0100403 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0103b31:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b34:	8b 50 04             	mov    0x4(%eax),%edx
c0103b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b3a:	39 c2                	cmp    %eax,%edx
c0103b3c:	75 10                	jne    c0103b4e <check_vma_struct+0x37e>
c0103b3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b41:	8b 40 08             	mov    0x8(%eax),%eax
c0103b44:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b47:	83 c2 02             	add    $0x2,%edx
c0103b4a:	39 d0                	cmp    %edx,%eax
c0103b4c:	74 24                	je     c0103b72 <check_vma_struct+0x3a2>
c0103b4e:	c7 44 24 0c 44 98 10 	movl   $0xc0109844,0xc(%esp)
c0103b55:	c0 
c0103b56:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103b5d:	c0 
c0103b5e:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0103b65:	00 
c0103b66:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103b6d:	e8 91 c8 ff ff       	call   c0100403 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0103b72:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103b75:	8b 50 04             	mov    0x4(%eax),%edx
c0103b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b7b:	39 c2                	cmp    %eax,%edx
c0103b7d:	75 10                	jne    c0103b8f <check_vma_struct+0x3bf>
c0103b7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103b82:	8b 40 08             	mov    0x8(%eax),%eax
c0103b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b88:	83 c2 02             	add    $0x2,%edx
c0103b8b:	39 d0                	cmp    %edx,%eax
c0103b8d:	74 24                	je     c0103bb3 <check_vma_struct+0x3e3>
c0103b8f:	c7 44 24 0c 74 98 10 	movl   $0xc0109874,0xc(%esp)
c0103b96:	c0 
c0103b97:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103b9e:	c0 
c0103b9f:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0103ba6:	00 
c0103ba7:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103bae:	e8 50 c8 ff ff       	call   c0100403 <__panic>
    for (i = 5; i <= 5 * step2; i +=5) {
c0103bb3:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0103bb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103bba:	89 d0                	mov    %edx,%eax
c0103bbc:	c1 e0 02             	shl    $0x2,%eax
c0103bbf:	01 d0                	add    %edx,%eax
c0103bc1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103bc4:	0f 8e 22 fe ff ff    	jle    c01039ec <check_vma_struct+0x21c>
    }

    for (i =4; i>=0; i--) {
c0103bca:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0103bd1:	eb 6f                	jmp    c0103c42 <check_vma_struct+0x472>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0103bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103bdd:	89 04 24             	mov    %eax,(%esp)
c0103be0:	e8 80 f8 ff ff       	call   c0103465 <find_vma>
c0103be5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if (vma_below_5 != NULL ) {
c0103be8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103bec:	74 27                	je     c0103c15 <check_vma_struct+0x445>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0103bee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bf1:	8b 50 08             	mov    0x8(%eax),%edx
c0103bf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bf7:	8b 40 04             	mov    0x4(%eax),%eax
c0103bfa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103bfe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c09:	c7 04 24 a4 98 10 c0 	movl   $0xc01098a4,(%esp)
c0103c10:	e8 97 c6 ff ff       	call   c01002ac <cprintf>
        }
        assert(vma_below_5 == NULL);
c0103c15:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103c19:	74 24                	je     c0103c3f <check_vma_struct+0x46f>
c0103c1b:	c7 44 24 0c c9 98 10 	movl   $0xc01098c9,0xc(%esp)
c0103c22:	c0 
c0103c23:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103c2a:	c0 
c0103c2b:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103c32:	00 
c0103c33:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103c3a:	e8 c4 c7 ff ff       	call   c0100403 <__panic>
    for (i =4; i>=0; i--) {
c0103c3f:	ff 4d f4             	decl   -0xc(%ebp)
c0103c42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c46:	79 8b                	jns    c0103bd3 <check_vma_struct+0x403>
    }

    mm_destroy(mm);
c0103c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c4b:	89 04 24             	mov    %eax,(%esp)
c0103c4e:	e8 9a fa ff ff       	call   c01036ed <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0103c53:	e8 8b 2b 00 00       	call   c01067e3 <nr_free_pages>
c0103c58:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103c5b:	74 24                	je     c0103c81 <check_vma_struct+0x4b1>
c0103c5d:	c7 44 24 0c 5c 97 10 	movl   $0xc010975c,0xc(%esp)
c0103c64:	c0 
c0103c65:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103c6c:	c0 
c0103c6d:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103c74:	00 
c0103c75:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103c7c:	e8 82 c7 ff ff       	call   c0100403 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0103c81:	c7 04 24 e0 98 10 c0 	movl   $0xc01098e0,(%esp)
c0103c88:	e8 1f c6 ff ff       	call   c01002ac <cprintf>
}
c0103c8d:	90                   	nop
c0103c8e:	c9                   	leave  
c0103c8f:	c3                   	ret    

c0103c90 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0103c90:	55                   	push   %ebp
c0103c91:	89 e5                	mov    %esp,%ebp
c0103c93:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103c96:	e8 48 2b 00 00       	call   c01067e3 <nr_free_pages>
c0103c9b:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0103c9e:	e8 0f f7 ff ff       	call   c01033b2 <mm_create>
c0103ca3:	a3 10 40 12 c0       	mov    %eax,0xc0124010
    assert(check_mm_struct != NULL);
c0103ca8:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0103cad:	85 c0                	test   %eax,%eax
c0103caf:	75 24                	jne    c0103cd5 <check_pgfault+0x45>
c0103cb1:	c7 44 24 0c ff 98 10 	movl   $0xc01098ff,0xc(%esp)
c0103cb8:	c0 
c0103cb9:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103cc0:	c0 
c0103cc1:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103cc8:	00 
c0103cc9:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103cd0:	e8 2e c7 ff ff       	call   c0100403 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0103cd5:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0103cda:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0103cdd:	8b 15 00 0a 12 c0    	mov    0xc0120a00,%edx
c0103ce3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ce6:	89 50 0c             	mov    %edx,0xc(%eax)
c0103ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cec:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0103cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cf5:	8b 00                	mov    (%eax),%eax
c0103cf7:	85 c0                	test   %eax,%eax
c0103cf9:	74 24                	je     c0103d1f <check_pgfault+0x8f>
c0103cfb:	c7 44 24 0c 17 99 10 	movl   $0xc0109917,0xc(%esp)
c0103d02:	c0 
c0103d03:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103d0a:	c0 
c0103d0b:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103d12:	00 
c0103d13:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103d1a:	e8 e4 c6 ff ff       	call   c0100403 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0103d1f:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0103d26:	00 
c0103d27:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0103d2e:	00 
c0103d2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0103d36:	e8 ef f6 ff ff       	call   c010342a <vma_create>
c0103d3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0103d3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103d42:	75 24                	jne    c0103d68 <check_pgfault+0xd8>
c0103d44:	c7 44 24 0c a6 97 10 	movl   $0xc01097a6,0xc(%esp)
c0103d4b:	c0 
c0103d4c:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103d53:	c0 
c0103d54:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103d5b:	00 
c0103d5c:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103d63:	e8 9b c6 ff ff       	call   c0100403 <__panic>

    insert_vma_struct(mm, vma);
c0103d68:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d72:	89 04 24             	mov    %eax,(%esp)
c0103d75:	e8 41 f8 ff ff       	call   c01035bb <insert_vma_struct>

    uintptr_t addr = 0x100;
c0103d7a:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0103d81:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d8b:	89 04 24             	mov    %eax,(%esp)
c0103d8e:	e8 d2 f6 ff ff       	call   c0103465 <find_vma>
c0103d93:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103d96:	74 24                	je     c0103dbc <check_pgfault+0x12c>
c0103d98:	c7 44 24 0c 25 99 10 	movl   $0xc0109925,0xc(%esp)
c0103d9f:	c0 
c0103da0:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103da7:	c0 
c0103da8:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103daf:	00 
c0103db0:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103db7:	e8 47 c6 ff ff       	call   c0100403 <__panic>

    int i, sum = 0;
c0103dbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103dca:	eb 16                	jmp    c0103de2 <check_pgfault+0x152>
        *(char *)(addr + i) = i;
c0103dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103dcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103dd2:	01 d0                	add    %edx,%eax
c0103dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103dd7:	88 10                	mov    %dl,(%eax)
        sum += i;
c0103dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ddc:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103ddf:	ff 45 f4             	incl   -0xc(%ebp)
c0103de2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103de6:	7e e4                	jle    c0103dcc <check_pgfault+0x13c>
    }
    for (i = 0; i < 100; i ++) {
c0103de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103def:	eb 14                	jmp    c0103e05 <check_pgfault+0x175>
        sum -= *(char *)(addr + i);
c0103df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103df4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103df7:	01 d0                	add    %edx,%eax
c0103df9:	0f b6 00             	movzbl (%eax),%eax
c0103dfc:	0f be c0             	movsbl %al,%eax
c0103dff:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103e02:	ff 45 f4             	incl   -0xc(%ebp)
c0103e05:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103e09:	7e e6                	jle    c0103df1 <check_pgfault+0x161>
    }
    assert(sum == 0);
c0103e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103e0f:	74 24                	je     c0103e35 <check_pgfault+0x1a5>
c0103e11:	c7 44 24 0c 3f 99 10 	movl   $0xc010993f,0xc(%esp)
c0103e18:	c0 
c0103e19:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103e20:	c0 
c0103e21:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103e28:	00 
c0103e29:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103e30:	e8 ce c5 ff ff       	call   c0100403 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0103e35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e38:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103e3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103e3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e4a:	89 04 24             	mov    %eax,(%esp)
c0103e4d:	e8 f0 31 00 00       	call   c0107042 <page_remove>
    free_page(pde2page(pgdir[0]));
c0103e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e55:	8b 00                	mov    (%eax),%eax
c0103e57:	89 04 24             	mov    %eax,(%esp)
c0103e5a:	e8 3b f5 ff ff       	call   c010339a <pde2page>
c0103e5f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e66:	00 
c0103e67:	89 04 24             	mov    %eax,(%esp)
c0103e6a:	e8 41 29 00 00       	call   c01067b0 <free_pages>
    pgdir[0] = 0;
c0103e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0103e78:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0103e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e85:	89 04 24             	mov    %eax,(%esp)
c0103e88:	e8 60 f8 ff ff       	call   c01036ed <mm_destroy>
    check_mm_struct = NULL;
c0103e8d:	c7 05 10 40 12 c0 00 	movl   $0x0,0xc0124010
c0103e94:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0103e97:	e8 47 29 00 00       	call   c01067e3 <nr_free_pages>
c0103e9c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103e9f:	74 24                	je     c0103ec5 <check_pgfault+0x235>
c0103ea1:	c7 44 24 0c 5c 97 10 	movl   $0xc010975c,0xc(%esp)
c0103ea8:	c0 
c0103ea9:	c7 44 24 08 db 96 10 	movl   $0xc01096db,0x8(%esp)
c0103eb0:	c0 
c0103eb1:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103eb8:	00 
c0103eb9:	c7 04 24 f0 96 10 c0 	movl   $0xc01096f0,(%esp)
c0103ec0:	e8 3e c5 ff ff       	call   c0100403 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0103ec5:	c7 04 24 48 99 10 c0 	movl   $0xc0109948,(%esp)
c0103ecc:	e8 db c3 ff ff       	call   c01002ac <cprintf>
}
c0103ed1:	90                   	nop
c0103ed2:	c9                   	leave  
c0103ed3:	c3                   	ret    

c0103ed4 <do_pgfault>:

// mm:应用程序虚拟存储总管
// error_code:错误的类型
// addr:具体出错的虚拟地址
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0103ed4:	55                   	push   %ebp
c0103ed5:	89 e5                	mov    %esp,%ebp
c0103ed7:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0103eda:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0103ee1:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ee4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ee8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eeb:	89 04 24             	mov    %eax,(%esp)
c0103eee:	e8 72 f5 ff ff       	call   c0103465 <find_vma>
c0103ef3:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0103ef6:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0103efb:	40                   	inc    %eax
c0103efc:	a3 64 3f 12 c0       	mov    %eax,0xc0123f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0103f01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103f05:	74 0b                	je     c0103f12 <do_pgfault+0x3e>
c0103f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f0a:	8b 40 04             	mov    0x4(%eax),%eax
c0103f0d:	39 45 10             	cmp    %eax,0x10(%ebp)
c0103f10:	73 18                	jae    c0103f2a <do_pgfault+0x56>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0103f12:	8b 45 10             	mov    0x10(%ebp),%eax
c0103f15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f19:	c7 04 24 64 99 10 c0 	movl   $0xc0109964,(%esp)
c0103f20:	e8 87 c3 ff ff       	call   c01002ac <cprintf>
        goto failed;
c0103f25:	e9 ba 01 00 00       	jmp    c01040e4 <do_pgfault+0x210>
    }
    //check the error_code
    switch (error_code & 3) {
c0103f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103f2d:	83 e0 03             	and    $0x3,%eax
c0103f30:	85 c0                	test   %eax,%eax
c0103f32:	74 34                	je     c0103f68 <do_pgfault+0x94>
c0103f34:	83 f8 01             	cmp    $0x1,%eax
c0103f37:	74 1e                	je     c0103f57 <do_pgfault+0x83>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0103f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f3c:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f3f:	83 e0 02             	and    $0x2,%eax
c0103f42:	85 c0                	test   %eax,%eax
c0103f44:	75 40                	jne    c0103f86 <do_pgfault+0xb2>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0103f46:	c7 04 24 94 99 10 c0 	movl   $0xc0109994,(%esp)
c0103f4d:	e8 5a c3 ff ff       	call   c01002ac <cprintf>
            goto failed;
c0103f52:	e9 8d 01 00 00       	jmp    c01040e4 <do_pgfault+0x210>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0103f57:	c7 04 24 f4 99 10 c0 	movl   $0xc01099f4,(%esp)
c0103f5e:	e8 49 c3 ff ff       	call   c01002ac <cprintf>
        goto failed;
c0103f63:	e9 7c 01 00 00       	jmp    c01040e4 <do_pgfault+0x210>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0103f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f6b:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f6e:	83 e0 05             	and    $0x5,%eax
c0103f71:	85 c0                	test   %eax,%eax
c0103f73:	75 12                	jne    c0103f87 <do_pgfault+0xb3>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0103f75:	c7 04 24 2c 9a 10 c0 	movl   $0xc0109a2c,(%esp)
c0103f7c:	e8 2b c3 ff ff       	call   c01002ac <cprintf>
            goto failed;
c0103f81:	e9 5e 01 00 00       	jmp    c01040e4 <do_pgfault+0x210>
        break;
c0103f86:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0103f87:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0103f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f91:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f94:	83 e0 02             	and    $0x2,%eax
c0103f97:	85 c0                	test   %eax,%eax
c0103f99:	74 04                	je     c0103f9f <do_pgfault+0xcb>
        perm |= PTE_W;
c0103f9b:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0103f9f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fa8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103fad:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0103fb0:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0103fb7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    //查找页目录，如果不存在则失败
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
c0103fbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fc1:	8b 40 0c             	mov    0xc(%eax),%eax
c0103fc4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103fcb:	00 
c0103fcc:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fcf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fd3:	89 04 24             	mov    %eax,(%esp)
c0103fd6:	e8 45 2e 00 00       	call   c0106e20 <get_pte>
c0103fdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103fde:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103fe2:	75 11                	jne    c0103ff5 <do_pgfault+0x121>
        cprintf("get_pte in do_pgfault failed\n");
c0103fe4:	c7 04 24 8f 9a 10 c0 	movl   $0xc0109a8f,(%esp)
c0103feb:	e8 bc c2 ff ff       	call   c01002ac <cprintf>
        goto failed;
c0103ff0:	e9 ef 00 00 00       	jmp    c01040e4 <do_pgfault+0x210>
    }
    //新创建的二级页表
    if (*ptep == 0) { 
c0103ff5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ff8:	8b 00                	mov    (%eax),%eax
c0103ffa:	85 c0                	test   %eax,%eax
c0103ffc:	75 35                	jne    c0104033 <do_pgfault+0x15f>
        //初始化建立虚拟地址与物理页之间的映射关系
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0103ffe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104001:	8b 40 0c             	mov    0xc(%eax),%eax
c0104004:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104007:	89 54 24 08          	mov    %edx,0x8(%esp)
c010400b:	8b 55 10             	mov    0x10(%ebp),%edx
c010400e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104012:	89 04 24             	mov    %eax,(%esp)
c0104015:	e8 82 31 00 00       	call   c010719c <pgdir_alloc_page>
c010401a:	85 c0                	test   %eax,%eax
c010401c:	0f 85 bb 00 00 00    	jne    c01040dd <do_pgfault+0x209>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0104022:	c7 04 24 b0 9a 10 c0 	movl   $0xc0109ab0,(%esp)
c0104029:	e8 7e c2 ff ff       	call   c01002ac <cprintf>
            goto failed;
c010402e:	e9 b1 00 00 00       	jmp    c01040e4 <do_pgfault+0x210>
        }
    }
    else {//页表项非空，尝试换入页面
        if(swap_init_ok) {
c0104033:	a1 68 3f 12 c0       	mov    0xc0123f68,%eax
c0104038:	85 c0                	test   %eax,%eax
c010403a:	0f 84 86 00 00 00    	je     c01040c6 <do_pgfault+0x1f2>
            struct Page *page=NULL;
c0104040:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
c0104047:	8d 45 e0             	lea    -0x20(%ebp),%eax
c010404a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010404e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104051:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104055:	8b 45 08             	mov    0x8(%ebp),%eax
c0104058:	89 04 24             	mov    %eax,(%esp)
c010405b:	e8 8e 03 00 00       	call   c01043ee <swap_in>
c0104060:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104067:	74 0e                	je     c0104077 <do_pgfault+0x1a3>
                cprintf("swap_in in do_pgfault failed\n");
c0104069:	c7 04 24 d7 9a 10 c0 	movl   $0xc0109ad7,(%esp)
c0104070:	e8 37 c2 ff ff       	call   c01002ac <cprintf>
c0104075:	eb 6d                	jmp    c01040e4 <do_pgfault+0x210>
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
c0104077:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010407a:	8b 45 08             	mov    0x8(%ebp),%eax
c010407d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104080:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0104083:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0104087:	8b 4d 10             	mov    0x10(%ebp),%ecx
c010408a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010408e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104092:	89 04 24             	mov    %eax,(%esp)
c0104095:	e8 ed 2f 00 00       	call   c0107087 <page_insert>
            swap_map_swappable(mm, addr, page, 1);//将此页面设置为可交换的 ,也添加到算法所维护的次序队列
c010409a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010409d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01040a4:	00 
c01040a5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01040a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01040ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01040b3:	89 04 24             	mov    %eax,(%esp)
c01040b6:	e8 71 01 00 00       	call   c010422c <swap_map_swappable>
	        page->pra_vaddr = addr;		//设置页对应的虚拟地址
c01040bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040be:	8b 55 10             	mov    0x10(%ebp),%edx
c01040c1:	89 50 1c             	mov    %edx,0x1c(%eax)
c01040c4:	eb 17                	jmp    c01040dd <do_pgfault+0x209>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c01040c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040c9:	8b 00                	mov    (%eax),%eax
c01040cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040cf:	c7 04 24 f8 9a 10 c0 	movl   $0xc0109af8,(%esp)
c01040d6:	e8 d1 c1 ff ff       	call   c01002ac <cprintf>
            goto failed;
c01040db:	eb 07                	jmp    c01040e4 <do_pgfault+0x210>
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
   ret = 0;
c01040dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01040e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01040e7:	c9                   	leave  
c01040e8:	c3                   	ret    

c01040e9 <pa2page>:
pa2page(uintptr_t pa) {
c01040e9:	55                   	push   %ebp
c01040ea:	89 e5                	mov    %esp,%ebp
c01040ec:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01040ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01040f2:	c1 e8 0c             	shr    $0xc,%eax
c01040f5:	89 c2                	mov    %eax,%edx
c01040f7:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c01040fc:	39 c2                	cmp    %eax,%edx
c01040fe:	72 1c                	jb     c010411c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104100:	c7 44 24 08 20 9b 10 	movl   $0xc0109b20,0x8(%esp)
c0104107:	c0 
c0104108:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010410f:	00 
c0104110:	c7 04 24 3f 9b 10 c0 	movl   $0xc0109b3f,(%esp)
c0104117:	e8 e7 c2 ff ff       	call   c0100403 <__panic>
    return &pages[PPN(pa)];
c010411c:	a1 00 41 12 c0       	mov    0xc0124100,%eax
c0104121:	8b 55 08             	mov    0x8(%ebp),%edx
c0104124:	c1 ea 0c             	shr    $0xc,%edx
c0104127:	c1 e2 05             	shl    $0x5,%edx
c010412a:	01 d0                	add    %edx,%eax
}
c010412c:	c9                   	leave  
c010412d:	c3                   	ret    

c010412e <pte2page>:
pte2page(pte_t pte) {
c010412e:	55                   	push   %ebp
c010412f:	89 e5                	mov    %esp,%ebp
c0104131:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104134:	8b 45 08             	mov    0x8(%ebp),%eax
c0104137:	83 e0 01             	and    $0x1,%eax
c010413a:	85 c0                	test   %eax,%eax
c010413c:	75 1c                	jne    c010415a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010413e:	c7 44 24 08 50 9b 10 	movl   $0xc0109b50,0x8(%esp)
c0104145:	c0 
c0104146:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010414d:	00 
c010414e:	c7 04 24 3f 9b 10 c0 	movl   $0xc0109b3f,(%esp)
c0104155:	e8 a9 c2 ff ff       	call   c0100403 <__panic>
    return pa2page(PTE_ADDR(pte));
c010415a:	8b 45 08             	mov    0x8(%ebp),%eax
c010415d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104162:	89 04 24             	mov    %eax,(%esp)
c0104165:	e8 7f ff ff ff       	call   c01040e9 <pa2page>
}
c010416a:	c9                   	leave  
c010416b:	c3                   	ret    

c010416c <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010416c:	55                   	push   %ebp
c010416d:	89 e5                	mov    %esp,%ebp
c010416f:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0104172:	e8 50 3f 00 00       	call   c01080c7 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0104177:	a1 bc 40 12 c0       	mov    0xc01240bc,%eax
c010417c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0104181:	76 0c                	jbe    c010418f <swap_init+0x23>
c0104183:	a1 bc 40 12 c0       	mov    0xc01240bc,%eax
c0104188:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c010418d:	76 25                	jbe    c01041b4 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010418f:	a1 bc 40 12 c0       	mov    0xc01240bc,%eax
c0104194:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104198:	c7 44 24 08 71 9b 10 	movl   $0xc0109b71,0x8(%esp)
c010419f:	c0 
c01041a0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01041a7:	00 
c01041a8:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c01041af:	e8 4f c2 ff ff       	call   c0100403 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01041b4:	c7 05 70 3f 12 c0 e0 	movl   $0xc01209e0,0xc0123f70
c01041bb:	09 12 c0 
     int r = sm->init();
c01041be:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c01041c3:	8b 40 04             	mov    0x4(%eax),%eax
c01041c6:	ff d0                	call   *%eax
c01041c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01041cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041cf:	75 26                	jne    c01041f7 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c01041d1:	c7 05 68 3f 12 c0 01 	movl   $0x1,0xc0123f68
c01041d8:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c01041db:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c01041e0:	8b 00                	mov    (%eax),%eax
c01041e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041e6:	c7 04 24 9b 9b 10 c0 	movl   $0xc0109b9b,(%esp)
c01041ed:	e8 ba c0 ff ff       	call   c01002ac <cprintf>
          check_swap();
c01041f2:	e8 9e 04 00 00       	call   c0104695 <check_swap>
     }

     return r;
c01041f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01041fa:	c9                   	leave  
c01041fb:	c3                   	ret    

c01041fc <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01041fc:	55                   	push   %ebp
c01041fd:	89 e5                	mov    %esp,%ebp
c01041ff:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0104202:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c0104207:	8b 40 08             	mov    0x8(%eax),%eax
c010420a:	8b 55 08             	mov    0x8(%ebp),%edx
c010420d:	89 14 24             	mov    %edx,(%esp)
c0104210:	ff d0                	call   *%eax
}
c0104212:	c9                   	leave  
c0104213:	c3                   	ret    

c0104214 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0104214:	55                   	push   %ebp
c0104215:	89 e5                	mov    %esp,%ebp
c0104217:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c010421a:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c010421f:	8b 40 0c             	mov    0xc(%eax),%eax
c0104222:	8b 55 08             	mov    0x8(%ebp),%edx
c0104225:	89 14 24             	mov    %edx,(%esp)
c0104228:	ff d0                	call   *%eax
}
c010422a:	c9                   	leave  
c010422b:	c3                   	ret    

c010422c <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010422c:	55                   	push   %ebp
c010422d:	89 e5                	mov    %esp,%ebp
c010422f:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0104232:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c0104237:	8b 40 10             	mov    0x10(%eax),%eax
c010423a:	8b 55 14             	mov    0x14(%ebp),%edx
c010423d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104241:	8b 55 10             	mov    0x10(%ebp),%edx
c0104244:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104248:	8b 55 0c             	mov    0xc(%ebp),%edx
c010424b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010424f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104252:	89 14 24             	mov    %edx,(%esp)
c0104255:	ff d0                	call   *%eax
}
c0104257:	c9                   	leave  
c0104258:	c3                   	ret    

c0104259 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0104259:	55                   	push   %ebp
c010425a:	89 e5                	mov    %esp,%ebp
c010425c:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010425f:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c0104264:	8b 40 14             	mov    0x14(%eax),%eax
c0104267:	8b 55 0c             	mov    0xc(%ebp),%edx
c010426a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010426e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104271:	89 14 24             	mov    %edx,(%esp)
c0104274:	ff d0                	call   *%eax
}
c0104276:	c9                   	leave  
c0104277:	c3                   	ret    

c0104278 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0104278:	55                   	push   %ebp
c0104279:	89 e5                	mov    %esp,%ebp
c010427b:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010427e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104285:	e9 53 01 00 00       	jmp    c01043dd <swap_out+0x165>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c010428a:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c010428f:	8b 40 18             	mov    0x18(%eax),%eax
c0104292:	8b 55 10             	mov    0x10(%ebp),%edx
c0104295:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104299:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c010429c:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01042a3:	89 14 24             	mov    %edx,(%esp)
c01042a6:	ff d0                	call   *%eax
c01042a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01042ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01042af:	74 18                	je     c01042c9 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01042b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042b8:	c7 04 24 b0 9b 10 c0 	movl   $0xc0109bb0,(%esp)
c01042bf:	e8 e8 bf ff ff       	call   c01002ac <cprintf>
c01042c4:	e9 20 01 00 00       	jmp    c01043e9 <swap_out+0x171>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01042c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042cc:	8b 40 1c             	mov    0x1c(%eax),%eax
c01042cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c01042d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01042d5:	8b 40 0c             	mov    0xc(%eax),%eax
c01042d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01042df:	00 
c01042e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042e3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042e7:	89 04 24             	mov    %eax,(%esp)
c01042ea:	e8 31 2b 00 00       	call   c0106e20 <get_pte>
c01042ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01042f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042f5:	8b 00                	mov    (%eax),%eax
c01042f7:	83 e0 01             	and    $0x1,%eax
c01042fa:	85 c0                	test   %eax,%eax
c01042fc:	75 24                	jne    c0104322 <swap_out+0xaa>
c01042fe:	c7 44 24 0c dd 9b 10 	movl   $0xc0109bdd,0xc(%esp)
c0104305:	c0 
c0104306:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c010430d:	c0 
c010430e:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104315:	00 
c0104316:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c010431d:	e8 e1 c0 ff ff       	call   c0100403 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0104322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104325:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104328:	8b 52 1c             	mov    0x1c(%edx),%edx
c010432b:	c1 ea 0c             	shr    $0xc,%edx
c010432e:	42                   	inc    %edx
c010432f:	c1 e2 08             	shl    $0x8,%edx
c0104332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104336:	89 14 24             	mov    %edx,(%esp)
c0104339:	e8 44 3e 00 00       	call   c0108182 <swapfs_write>
c010433e:	85 c0                	test   %eax,%eax
c0104340:	74 34                	je     c0104376 <swap_out+0xfe>
                    cprintf("SWAP: failed to save\n");
c0104342:	c7 04 24 07 9c 10 c0 	movl   $0xc0109c07,(%esp)
c0104349:	e8 5e bf ff ff       	call   c01002ac <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010434e:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c0104353:	8b 40 10             	mov    0x10(%eax),%eax
c0104356:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104359:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104360:	00 
c0104361:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104365:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104368:	89 54 24 04          	mov    %edx,0x4(%esp)
c010436c:	8b 55 08             	mov    0x8(%ebp),%edx
c010436f:	89 14 24             	mov    %edx,(%esp)
c0104372:	ff d0                	call   *%eax
c0104374:	eb 64                	jmp    c01043da <swap_out+0x162>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0104376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104379:	8b 40 1c             	mov    0x1c(%eax),%eax
c010437c:	c1 e8 0c             	shr    $0xc,%eax
c010437f:	40                   	inc    %eax
c0104380:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104384:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104387:	89 44 24 08          	mov    %eax,0x8(%esp)
c010438b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010438e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104392:	c7 04 24 20 9c 10 c0 	movl   $0xc0109c20,(%esp)
c0104399:	e8 0e bf ff ff       	call   c01002ac <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010439e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043a1:	8b 40 1c             	mov    0x1c(%eax),%eax
c01043a4:	c1 e8 0c             	shr    $0xc,%eax
c01043a7:	40                   	inc    %eax
c01043a8:	c1 e0 08             	shl    $0x8,%eax
c01043ab:	89 c2                	mov    %eax,%edx
c01043ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043b0:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01043b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043bc:	00 
c01043bd:	89 04 24             	mov    %eax,(%esp)
c01043c0:	e8 eb 23 00 00       	call   c01067b0 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01043c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c8:	8b 40 0c             	mov    0xc(%eax),%eax
c01043cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01043ce:	89 54 24 04          	mov    %edx,0x4(%esp)
c01043d2:	89 04 24             	mov    %eax,(%esp)
c01043d5:	e8 66 2d 00 00       	call   c0107140 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
c01043da:	ff 45 f4             	incl   -0xc(%ebp)
c01043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01043e3:	0f 85 a1 fe ff ff    	jne    c010428a <swap_out+0x12>
     }
     return i;
c01043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01043ec:	c9                   	leave  
c01043ed:	c3                   	ret    

c01043ee <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01043ee:	55                   	push   %ebp
c01043ef:	89 e5                	mov    %esp,%ebp
c01043f1:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01043f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043fb:	e8 45 23 00 00       	call   c0106745 <alloc_pages>
c0104400:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0104403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104407:	75 24                	jne    c010442d <swap_in+0x3f>
c0104409:	c7 44 24 0c 60 9c 10 	movl   $0xc0109c60,0xc(%esp)
c0104410:	c0 
c0104411:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104418:	c0 
c0104419:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0104420:	00 
c0104421:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104428:	e8 d6 bf ff ff       	call   c0100403 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010442d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104430:	8b 40 0c             	mov    0xc(%eax),%eax
c0104433:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010443a:	00 
c010443b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010443e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104442:	89 04 24             	mov    %eax,(%esp)
c0104445:	e8 d6 29 00 00       	call   c0106e20 <get_pte>
c010444a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010444d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104450:	8b 00                	mov    (%eax),%eax
c0104452:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104455:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104459:	89 04 24             	mov    %eax,(%esp)
c010445c:	e8 af 3c 00 00       	call   c0108110 <swapfs_read>
c0104461:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104464:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104468:	74 2a                	je     c0104494 <swap_in+0xa6>
     {
        assert(r!=0);
c010446a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010446e:	75 24                	jne    c0104494 <swap_in+0xa6>
c0104470:	c7 44 24 0c 6d 9c 10 	movl   $0xc0109c6d,0xc(%esp)
c0104477:	c0 
c0104478:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c010447f:	c0 
c0104480:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0104487:	00 
c0104488:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c010448f:	e8 6f bf ff ff       	call   c0100403 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0104494:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104497:	8b 00                	mov    (%eax),%eax
c0104499:	c1 e8 08             	shr    $0x8,%eax
c010449c:	89 c2                	mov    %eax,%edx
c010449e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044a1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044a9:	c7 04 24 74 9c 10 c0 	movl   $0xc0109c74,(%esp)
c01044b0:	e8 f7 bd ff ff       	call   c01002ac <cprintf>
     *ptr_result=result;
c01044b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01044b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044bb:	89 10                	mov    %edx,(%eax)
     return 0;
c01044bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044c2:	c9                   	leave  
c01044c3:	c3                   	ret    

c01044c4 <check_content_set>:



static inline void
check_content_set(void)
{
c01044c4:	55                   	push   %ebp
c01044c5:	89 e5                	mov    %esp,%ebp
c01044c7:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01044ca:	b8 00 10 00 00       	mov    $0x1000,%eax
c01044cf:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01044d2:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c01044d7:	83 f8 01             	cmp    $0x1,%eax
c01044da:	74 24                	je     c0104500 <check_content_set+0x3c>
c01044dc:	c7 44 24 0c b2 9c 10 	movl   $0xc0109cb2,0xc(%esp)
c01044e3:	c0 
c01044e4:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01044eb:	c0 
c01044ec:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01044f3:	00 
c01044f4:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c01044fb:	e8 03 bf ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0104500:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104505:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104508:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c010450d:	83 f8 01             	cmp    $0x1,%eax
c0104510:	74 24                	je     c0104536 <check_content_set+0x72>
c0104512:	c7 44 24 0c b2 9c 10 	movl   $0xc0109cb2,0xc(%esp)
c0104519:	c0 
c010451a:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104521:	c0 
c0104522:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0104529:	00 
c010452a:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104531:	e8 cd be ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0104536:	b8 00 20 00 00       	mov    $0x2000,%eax
c010453b:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010453e:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104543:	83 f8 02             	cmp    $0x2,%eax
c0104546:	74 24                	je     c010456c <check_content_set+0xa8>
c0104548:	c7 44 24 0c c1 9c 10 	movl   $0xc0109cc1,0xc(%esp)
c010454f:	c0 
c0104550:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104557:	c0 
c0104558:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c010455f:	00 
c0104560:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104567:	e8 97 be ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010456c:	b8 10 20 00 00       	mov    $0x2010,%eax
c0104571:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104574:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104579:	83 f8 02             	cmp    $0x2,%eax
c010457c:	74 24                	je     c01045a2 <check_content_set+0xde>
c010457e:	c7 44 24 0c c1 9c 10 	movl   $0xc0109cc1,0xc(%esp)
c0104585:	c0 
c0104586:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c010458d:	c0 
c010458e:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0104595:	00 
c0104596:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c010459d:	e8 61 be ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01045a2:	b8 00 30 00 00       	mov    $0x3000,%eax
c01045a7:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01045aa:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c01045af:	83 f8 03             	cmp    $0x3,%eax
c01045b2:	74 24                	je     c01045d8 <check_content_set+0x114>
c01045b4:	c7 44 24 0c d0 9c 10 	movl   $0xc0109cd0,0xc(%esp)
c01045bb:	c0 
c01045bc:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01045c3:	c0 
c01045c4:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01045cb:	00 
c01045cc:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c01045d3:	e8 2b be ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01045d8:	b8 10 30 00 00       	mov    $0x3010,%eax
c01045dd:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01045e0:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c01045e5:	83 f8 03             	cmp    $0x3,%eax
c01045e8:	74 24                	je     c010460e <check_content_set+0x14a>
c01045ea:	c7 44 24 0c d0 9c 10 	movl   $0xc0109cd0,0xc(%esp)
c01045f1:	c0 
c01045f2:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01045f9:	c0 
c01045fa:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0104601:	00 
c0104602:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104609:	e8 f5 bd ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010460e:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104613:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104616:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c010461b:	83 f8 04             	cmp    $0x4,%eax
c010461e:	74 24                	je     c0104644 <check_content_set+0x180>
c0104620:	c7 44 24 0c df 9c 10 	movl   $0xc0109cdf,0xc(%esp)
c0104627:	c0 
c0104628:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c010462f:	c0 
c0104630:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0104637:	00 
c0104638:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c010463f:	e8 bf bd ff ff       	call   c0100403 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0104644:	b8 10 40 00 00       	mov    $0x4010,%eax
c0104649:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010464c:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104651:	83 f8 04             	cmp    $0x4,%eax
c0104654:	74 24                	je     c010467a <check_content_set+0x1b6>
c0104656:	c7 44 24 0c df 9c 10 	movl   $0xc0109cdf,0xc(%esp)
c010465d:	c0 
c010465e:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104665:	c0 
c0104666:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c010466d:	00 
c010466e:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104675:	e8 89 bd ff ff       	call   c0100403 <__panic>
}
c010467a:	90                   	nop
c010467b:	c9                   	leave  
c010467c:	c3                   	ret    

c010467d <check_content_access>:

static inline int
check_content_access(void)
{
c010467d:	55                   	push   %ebp
c010467e:	89 e5                	mov    %esp,%ebp
c0104680:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0104683:	a1 70 3f 12 c0       	mov    0xc0123f70,%eax
c0104688:	8b 40 1c             	mov    0x1c(%eax),%eax
c010468b:	ff d0                	call   *%eax
c010468d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0104690:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104693:	c9                   	leave  
c0104694:	c3                   	ret    

c0104695 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0104695:	55                   	push   %ebp
c0104696:	89 e5                	mov    %esp,%ebp
c0104698:	83 ec 78             	sub    $0x78,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010469b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01046a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01046a9:	c7 45 e8 ec 40 12 c0 	movl   $0xc01240ec,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01046b0:	eb 6a                	jmp    c010471c <check_swap+0x87>
        struct Page *p = le2page(le, page_link);
c01046b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01046b5:	83 e8 0c             	sub    $0xc,%eax
c01046b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(PageProperty(p));
c01046bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046be:	83 c0 04             	add    $0x4,%eax
c01046c1:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01046c8:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01046cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01046ce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01046d1:	0f a3 10             	bt     %edx,(%eax)
c01046d4:	19 c0                	sbb    %eax,%eax
c01046d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01046d9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01046dd:	0f 95 c0             	setne  %al
c01046e0:	0f b6 c0             	movzbl %al,%eax
c01046e3:	85 c0                	test   %eax,%eax
c01046e5:	75 24                	jne    c010470b <check_swap+0x76>
c01046e7:	c7 44 24 0c ee 9c 10 	movl   $0xc0109cee,0xc(%esp)
c01046ee:	c0 
c01046ef:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01046f6:	c0 
c01046f7:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01046fe:	00 
c01046ff:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104706:	e8 f8 bc ff ff       	call   c0100403 <__panic>
        count ++, total += p->property;
c010470b:	ff 45 f4             	incl   -0xc(%ebp)
c010470e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104711:	8b 50 08             	mov    0x8(%eax),%edx
c0104714:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104717:	01 d0                	add    %edx,%eax
c0104719:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010471c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010471f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104722:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104725:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0104728:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010472b:	81 7d e8 ec 40 12 c0 	cmpl   $0xc01240ec,-0x18(%ebp)
c0104732:	0f 85 7a ff ff ff    	jne    c01046b2 <check_swap+0x1d>
     }
     assert(total == nr_free_pages());
c0104738:	e8 a6 20 00 00       	call   c01067e3 <nr_free_pages>
c010473d:	89 c2                	mov    %eax,%edx
c010473f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104742:	39 c2                	cmp    %eax,%edx
c0104744:	74 24                	je     c010476a <check_swap+0xd5>
c0104746:	c7 44 24 0c fe 9c 10 	movl   $0xc0109cfe,0xc(%esp)
c010474d:	c0 
c010474e:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104755:	c0 
c0104756:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c010475d:	00 
c010475e:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104765:	e8 99 bc ff ff       	call   c0100403 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010476a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010476d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104774:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104778:	c7 04 24 18 9d 10 c0 	movl   $0xc0109d18,(%esp)
c010477f:	e8 28 bb ff ff       	call   c01002ac <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0104784:	e8 29 ec ff ff       	call   c01033b2 <mm_create>
c0104789:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     assert(mm != NULL);
c010478c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104790:	75 24                	jne    c01047b6 <check_swap+0x121>
c0104792:	c7 44 24 0c 3e 9d 10 	movl   $0xc0109d3e,0xc(%esp)
c0104799:	c0 
c010479a:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01047a1:	c0 
c01047a2:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01047a9:	00 
c01047aa:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c01047b1:	e8 4d bc ff ff       	call   c0100403 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01047b6:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c01047bb:	85 c0                	test   %eax,%eax
c01047bd:	74 24                	je     c01047e3 <check_swap+0x14e>
c01047bf:	c7 44 24 0c 49 9d 10 	movl   $0xc0109d49,0xc(%esp)
c01047c6:	c0 
c01047c7:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01047ce:	c0 
c01047cf:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01047d6:	00 
c01047d7:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c01047de:	e8 20 bc ff ff       	call   c0100403 <__panic>

     check_mm_struct = mm;
c01047e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047e6:	a3 10 40 12 c0       	mov    %eax,0xc0124010

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01047eb:	8b 15 00 0a 12 c0    	mov    0xc0120a00,%edx
c01047f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047f4:	89 50 0c             	mov    %edx,0xc(%eax)
c01047f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047fa:	8b 40 0c             	mov    0xc(%eax),%eax
c01047fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(pgdir[0] == 0);
c0104800:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104803:	8b 00                	mov    (%eax),%eax
c0104805:	85 c0                	test   %eax,%eax
c0104807:	74 24                	je     c010482d <check_swap+0x198>
c0104809:	c7 44 24 0c 61 9d 10 	movl   $0xc0109d61,0xc(%esp)
c0104810:	c0 
c0104811:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104818:	c0 
c0104819:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104820:	00 
c0104821:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104828:	e8 d6 bb ff ff       	call   c0100403 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010482d:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0104834:	00 
c0104835:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010483c:	00 
c010483d:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0104844:	e8 e1 eb ff ff       	call   c010342a <vma_create>
c0104849:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(vma != NULL);
c010484c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104850:	75 24                	jne    c0104876 <check_swap+0x1e1>
c0104852:	c7 44 24 0c 6f 9d 10 	movl   $0xc0109d6f,0xc(%esp)
c0104859:	c0 
c010485a:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104861:	c0 
c0104862:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104869:	00 
c010486a:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104871:	e8 8d bb ff ff       	call   c0100403 <__panic>

     insert_vma_struct(mm, vma);
c0104876:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104879:	89 44 24 04          	mov    %eax,0x4(%esp)
c010487d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104880:	89 04 24             	mov    %eax,(%esp)
c0104883:	e8 33 ed ff ff       	call   c01035bb <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0104888:	c7 04 24 7c 9d 10 c0 	movl   $0xc0109d7c,(%esp)
c010488f:	e8 18 ba ff ff       	call   c01002ac <cprintf>
     pte_t *temp_ptep=NULL;
c0104894:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010489b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010489e:	8b 40 0c             	mov    0xc(%eax),%eax
c01048a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01048a8:	00 
c01048a9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048b0:	00 
c01048b1:	89 04 24             	mov    %eax,(%esp)
c01048b4:	e8 67 25 00 00       	call   c0106e20 <get_pte>
c01048b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(temp_ptep!= NULL);
c01048bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01048c0:	75 24                	jne    c01048e6 <check_swap+0x251>
c01048c2:	c7 44 24 0c b0 9d 10 	movl   $0xc0109db0,0xc(%esp)
c01048c9:	c0 
c01048ca:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c01048d1:	c0 
c01048d2:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01048d9:	00 
c01048da:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c01048e1:	e8 1d bb ff ff       	call   c0100403 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01048e6:	c7 04 24 c4 9d 10 c0 	movl   $0xc0109dc4,(%esp)
c01048ed:	e8 ba b9 ff ff       	call   c01002ac <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01048f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01048f9:	e9 a4 00 00 00       	jmp    c01049a2 <check_swap+0x30d>
          check_rp[i] = alloc_page();
c01048fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104905:	e8 3b 1e 00 00       	call   c0106745 <alloc_pages>
c010490a:	89 c2                	mov    %eax,%edx
c010490c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010490f:	89 14 85 20 40 12 c0 	mov    %edx,-0x3fedbfe0(,%eax,4)
          assert(check_rp[i] != NULL );
c0104916:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104919:	8b 04 85 20 40 12 c0 	mov    -0x3fedbfe0(,%eax,4),%eax
c0104920:	85 c0                	test   %eax,%eax
c0104922:	75 24                	jne    c0104948 <check_swap+0x2b3>
c0104924:	c7 44 24 0c e8 9d 10 	movl   $0xc0109de8,0xc(%esp)
c010492b:	c0 
c010492c:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104933:	c0 
c0104934:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010493b:	00 
c010493c:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104943:	e8 bb ba ff ff       	call   c0100403 <__panic>
          assert(!PageProperty(check_rp[i]));
c0104948:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010494b:	8b 04 85 20 40 12 c0 	mov    -0x3fedbfe0(,%eax,4),%eax
c0104952:	83 c0 04             	add    $0x4,%eax
c0104955:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010495c:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010495f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104962:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104965:	0f a3 10             	bt     %edx,(%eax)
c0104968:	19 c0                	sbb    %eax,%eax
c010496a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010496d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0104971:	0f 95 c0             	setne  %al
c0104974:	0f b6 c0             	movzbl %al,%eax
c0104977:	85 c0                	test   %eax,%eax
c0104979:	74 24                	je     c010499f <check_swap+0x30a>
c010497b:	c7 44 24 0c fc 9d 10 	movl   $0xc0109dfc,0xc(%esp)
c0104982:	c0 
c0104983:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c010498a:	c0 
c010498b:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104992:	00 
c0104993:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c010499a:	e8 64 ba ff ff       	call   c0100403 <__panic>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010499f:	ff 45 ec             	incl   -0x14(%ebp)
c01049a2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01049a6:	0f 8e 52 ff ff ff    	jle    c01048fe <check_swap+0x269>
     }
     list_entry_t free_list_store = free_list;
c01049ac:	a1 ec 40 12 c0       	mov    0xc01240ec,%eax
c01049b1:	8b 15 f0 40 12 c0    	mov    0xc01240f0,%edx
c01049b7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01049ba:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01049bd:	c7 45 a4 ec 40 12 c0 	movl   $0xc01240ec,-0x5c(%ebp)
    elm->prev = elm->next = elm;
c01049c4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01049c7:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01049ca:	89 50 04             	mov    %edx,0x4(%eax)
c01049cd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01049d0:	8b 50 04             	mov    0x4(%eax),%edx
c01049d3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01049d6:	89 10                	mov    %edx,(%eax)
c01049d8:	c7 45 a8 ec 40 12 c0 	movl   $0xc01240ec,-0x58(%ebp)
    return list->next == list;
c01049df:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01049e2:	8b 40 04             	mov    0x4(%eax),%eax
c01049e5:	39 45 a8             	cmp    %eax,-0x58(%ebp)
c01049e8:	0f 94 c0             	sete   %al
c01049eb:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01049ee:	85 c0                	test   %eax,%eax
c01049f0:	75 24                	jne    c0104a16 <check_swap+0x381>
c01049f2:	c7 44 24 0c 17 9e 10 	movl   $0xc0109e17,0xc(%esp)
c01049f9:	c0 
c01049fa:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104a01:	c0 
c0104a02:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104a09:	00 
c0104a0a:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104a11:	e8 ed b9 ff ff       	call   c0100403 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0104a16:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0104a1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     nr_free = 0;
c0104a1e:	c7 05 f4 40 12 c0 00 	movl   $0x0,0xc01240f4
c0104a25:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104a2f:	eb 1d                	jmp    c0104a4e <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0104a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a34:	8b 04 85 20 40 12 c0 	mov    -0x3fedbfe0(,%eax,4),%eax
c0104a3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a42:	00 
c0104a43:	89 04 24             	mov    %eax,(%esp)
c0104a46:	e8 65 1d 00 00       	call   c01067b0 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104a4b:	ff 45 ec             	incl   -0x14(%ebp)
c0104a4e:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104a52:	7e dd                	jle    c0104a31 <check_swap+0x39c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0104a54:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0104a59:	83 f8 04             	cmp    $0x4,%eax
c0104a5c:	74 24                	je     c0104a82 <check_swap+0x3ed>
c0104a5e:	c7 44 24 0c 30 9e 10 	movl   $0xc0109e30,0xc(%esp)
c0104a65:	c0 
c0104a66:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104a6d:	c0 
c0104a6e:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0104a75:	00 
c0104a76:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104a7d:	e8 81 b9 ff ff       	call   c0100403 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0104a82:	c7 04 24 54 9e 10 c0 	movl   $0xc0109e54,(%esp)
c0104a89:	e8 1e b8 ff ff       	call   c01002ac <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0104a8e:	c7 05 64 3f 12 c0 00 	movl   $0x0,0xc0123f64
c0104a95:	00 00 00 
     
     check_content_set();
c0104a98:	e8 27 fa ff ff       	call   c01044c4 <check_content_set>
     assert( nr_free == 0);         
c0104a9d:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0104aa2:	85 c0                	test   %eax,%eax
c0104aa4:	74 24                	je     c0104aca <check_swap+0x435>
c0104aa6:	c7 44 24 0c 7b 9e 10 	movl   $0xc0109e7b,0xc(%esp)
c0104aad:	c0 
c0104aae:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104ab5:	c0 
c0104ab6:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0104abd:	00 
c0104abe:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104ac5:	e8 39 b9 ff ff       	call   c0100403 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104aca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104ad1:	eb 25                	jmp    c0104af8 <check_swap+0x463>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0104ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ad6:	c7 04 85 40 40 12 c0 	movl   $0xffffffff,-0x3fedbfc0(,%eax,4)
c0104add:	ff ff ff ff 
c0104ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ae4:	8b 14 85 40 40 12 c0 	mov    -0x3fedbfc0(,%eax,4),%edx
c0104aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aee:	89 14 85 80 40 12 c0 	mov    %edx,-0x3fedbf80(,%eax,4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104af5:	ff 45 ec             	incl   -0x14(%ebp)
c0104af8:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0104afc:	7e d5                	jle    c0104ad3 <check_swap+0x43e>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104afe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104b05:	e9 ec 00 00 00       	jmp    c0104bf6 <check_swap+0x561>
         check_ptep[i]=0;
c0104b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b0d:	c7 04 85 d4 40 12 c0 	movl   $0x0,-0x3fedbf2c(,%eax,4)
c0104b14:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0104b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b1b:	40                   	inc    %eax
c0104b1c:	c1 e0 0c             	shl    $0xc,%eax
c0104b1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b26:	00 
c0104b27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b2e:	89 04 24             	mov    %eax,(%esp)
c0104b31:	e8 ea 22 00 00       	call   c0106e20 <get_pte>
c0104b36:	89 c2                	mov    %eax,%edx
c0104b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b3b:	89 14 85 d4 40 12 c0 	mov    %edx,-0x3fedbf2c(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0104b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b45:	8b 04 85 d4 40 12 c0 	mov    -0x3fedbf2c(,%eax,4),%eax
c0104b4c:	85 c0                	test   %eax,%eax
c0104b4e:	75 24                	jne    c0104b74 <check_swap+0x4df>
c0104b50:	c7 44 24 0c 88 9e 10 	movl   $0xc0109e88,0xc(%esp)
c0104b57:	c0 
c0104b58:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104b5f:	c0 
c0104b60:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104b67:	00 
c0104b68:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104b6f:	e8 8f b8 ff ff       	call   c0100403 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0104b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b77:	8b 04 85 d4 40 12 c0 	mov    -0x3fedbf2c(,%eax,4),%eax
c0104b7e:	8b 00                	mov    (%eax),%eax
c0104b80:	89 04 24             	mov    %eax,(%esp)
c0104b83:	e8 a6 f5 ff ff       	call   c010412e <pte2page>
c0104b88:	89 c2                	mov    %eax,%edx
c0104b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b8d:	8b 04 85 20 40 12 c0 	mov    -0x3fedbfe0(,%eax,4),%eax
c0104b94:	39 c2                	cmp    %eax,%edx
c0104b96:	74 24                	je     c0104bbc <check_swap+0x527>
c0104b98:	c7 44 24 0c a0 9e 10 	movl   $0xc0109ea0,0xc(%esp)
c0104b9f:	c0 
c0104ba0:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104ba7:	c0 
c0104ba8:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0104baf:	00 
c0104bb0:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104bb7:	e8 47 b8 ff ff       	call   c0100403 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0104bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bbf:	8b 04 85 d4 40 12 c0 	mov    -0x3fedbf2c(,%eax,4),%eax
c0104bc6:	8b 00                	mov    (%eax),%eax
c0104bc8:	83 e0 01             	and    $0x1,%eax
c0104bcb:	85 c0                	test   %eax,%eax
c0104bcd:	75 24                	jne    c0104bf3 <check_swap+0x55e>
c0104bcf:	c7 44 24 0c c8 9e 10 	movl   $0xc0109ec8,0xc(%esp)
c0104bd6:	c0 
c0104bd7:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104bde:	c0 
c0104bdf:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104be6:	00 
c0104be7:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104bee:	e8 10 b8 ff ff       	call   c0100403 <__panic>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104bf3:	ff 45 ec             	incl   -0x14(%ebp)
c0104bf6:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104bfa:	0f 8e 0a ff ff ff    	jle    c0104b0a <check_swap+0x475>
     }
     cprintf("set up init env for check_swap over!\n");
c0104c00:	c7 04 24 e4 9e 10 c0 	movl   $0xc0109ee4,(%esp)
c0104c07:	e8 a0 b6 ff ff       	call   c01002ac <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0104c0c:	e8 6c fa ff ff       	call   c010467d <check_content_access>
c0104c11:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(ret==0);
c0104c14:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104c18:	74 24                	je     c0104c3e <check_swap+0x5a9>
c0104c1a:	c7 44 24 0c 0a 9f 10 	movl   $0xc0109f0a,0xc(%esp)
c0104c21:	c0 
c0104c22:	c7 44 24 08 f2 9b 10 	movl   $0xc0109bf2,0x8(%esp)
c0104c29:	c0 
c0104c2a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104c31:	00 
c0104c32:	c7 04 24 8c 9b 10 c0 	movl   $0xc0109b8c,(%esp)
c0104c39:	e8 c5 b7 ff ff       	call   c0100403 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c3e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104c45:	eb 1d                	jmp    c0104c64 <check_swap+0x5cf>
         free_pages(check_rp[i],1);
c0104c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c4a:	8b 04 85 20 40 12 c0 	mov    -0x3fedbfe0(,%eax,4),%eax
c0104c51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c58:	00 
c0104c59:	89 04 24             	mov    %eax,(%esp)
c0104c5c:	e8 4f 1b 00 00       	call   c01067b0 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104c61:	ff 45 ec             	incl   -0x14(%ebp)
c0104c64:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104c68:	7e dd                	jle    c0104c47 <check_swap+0x5b2>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0104c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c6d:	89 04 24             	mov    %eax,(%esp)
c0104c70:	e8 78 ea ff ff       	call   c01036ed <mm_destroy>
         
     nr_free = nr_free_store;
c0104c75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104c78:	a3 f4 40 12 c0       	mov    %eax,0xc01240f4
     free_list = free_list_store;
c0104c7d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104c80:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0104c83:	a3 ec 40 12 c0       	mov    %eax,0xc01240ec
c0104c88:	89 15 f0 40 12 c0    	mov    %edx,0xc01240f0

     
     le = &free_list;
c0104c8e:	c7 45 e8 ec 40 12 c0 	movl   $0xc01240ec,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104c95:	eb 1c                	jmp    c0104cb3 <check_swap+0x61e>
         struct Page *p = le2page(le, page_link);
c0104c97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c9a:	83 e8 0c             	sub    $0xc,%eax
c0104c9d:	89 45 cc             	mov    %eax,-0x34(%ebp)
         count --, total -= p->property;
c0104ca0:	ff 4d f4             	decl   -0xc(%ebp)
c0104ca3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ca6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104ca9:	8b 40 08             	mov    0x8(%eax),%eax
c0104cac:	29 c2                	sub    %eax,%edx
c0104cae:	89 d0                	mov    %edx,%eax
c0104cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cb6:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0104cb9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104cbc:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0104cbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104cc2:	81 7d e8 ec 40 12 c0 	cmpl   $0xc01240ec,-0x18(%ebp)
c0104cc9:	75 cc                	jne    c0104c97 <check_swap+0x602>
     }
     cprintf("count is %d, total is %d\n",count,total);
c0104ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cce:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cd9:	c7 04 24 11 9f 10 c0 	movl   $0xc0109f11,(%esp)
c0104ce0:	e8 c7 b5 ff ff       	call   c01002ac <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0104ce5:	c7 04 24 2b 9f 10 c0 	movl   $0xc0109f2b,(%esp)
c0104cec:	e8 bb b5 ff ff       	call   c01002ac <cprintf>
}
c0104cf1:	90                   	nop
c0104cf2:	c9                   	leave  
c0104cf3:	c3                   	ret    

c0104cf4 <_fifo_init_mm>:
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
//清空队列，表头指向队列的头
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0104cf4:	55                   	push   %ebp
c0104cf5:	89 e5                	mov    %esp,%ebp
c0104cf7:	83 ec 10             	sub    $0x10,%esp
c0104cfa:	c7 45 fc e4 40 12 c0 	movl   $0xc01240e4,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0104d01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d04:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104d07:	89 50 04             	mov    %edx,0x4(%eax)
c0104d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d0d:	8b 50 04             	mov    0x4(%eax),%edx
c0104d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104d13:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0104d15:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d18:	c7 40 14 e4 40 12 c0 	movl   $0xc01240e4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0104d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104d24:	c9                   	leave  
c0104d25:	c3                   	ret    

c0104d26 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104d26:	55                   	push   %ebp
c0104d27:	89 e5                	mov    %esp,%ebp
c0104d29:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0104d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d2f:	8b 40 14             	mov    0x14(%eax),%eax
c0104d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0104d35:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d38:	83 c0 14             	add    $0x14,%eax
c0104d3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0104d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d42:	74 06                	je     c0104d4a <_fifo_map_swappable+0x24>
c0104d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d48:	75 24                	jne    c0104d6e <_fifo_map_swappable+0x48>
c0104d4a:	c7 44 24 0c 44 9f 10 	movl   $0xc0109f44,0xc(%esp)
c0104d51:	c0 
c0104d52:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104d59:	c0 
c0104d5a:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
c0104d61:	00 
c0104d62:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104d69:	e8 95 b6 ff ff       	call   c0100403 <__panic>
c0104d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d71:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d77:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d83:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d89:	8b 40 04             	mov    0x4(%eax),%eax
c0104d8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104d92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104d95:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104d98:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0104d9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104da1:	89 10                	mov    %edx,(%eax)
c0104da3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104da6:	8b 10                	mov    (%eax),%edx
c0104da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104dab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104db1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104db4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104db7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104dba:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104dbd:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c0104dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104dc4:	c9                   	leave  
c0104dc5:	c3                   	ret    

c0104dc6 <_fifo_swap_out_victim>:
 *                            then assign the value of *ptr_page to the addr of this page.
 */
//查询哪个页面需要被换出
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0104dc6:	55                   	push   %ebp
c0104dc7:	89 e5                	mov    %esp,%ebp
c0104dc9:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0104dcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dcf:	8b 40 14             	mov    0x14(%eax),%eax
c0104dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(head != NULL);
c0104dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104dd9:	75 24                	jne    c0104dff <_fifo_swap_out_victim+0x39>
c0104ddb:	c7 44 24 0c 8b 9f 10 	movl   $0xc0109f8b,0xc(%esp)
c0104de2:	c0 
c0104de3:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104dea:	c0 
c0104deb:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
c0104df2:	00 
c0104df3:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104dfa:	e8 04 b6 ff ff       	call   c0100403 <__panic>
     assert(in_tick==0);
c0104dff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104e03:	74 24                	je     c0104e29 <_fifo_swap_out_victim+0x63>
c0104e05:	c7 44 24 0c 98 9f 10 	movl   $0xc0109f98,0xc(%esp)
c0104e0c:	c0 
c0104e0d:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104e14:	c0 
c0104e15:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
c0104e1c:	00 
c0104e1d:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104e24:	e8 da b5 ff ff       	call   c0100403 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     list_entry_t *le = head->prev;//用le指示需要被换出的页
c0104e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e2c:	8b 00                	mov    (%eax),%eax
c0104e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c0104e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104e37:	75 24                	jne    c0104e5d <_fifo_swap_out_victim+0x97>
c0104e39:	c7 44 24 0c a3 9f 10 	movl   $0xc0109fa3,0xc(%esp)
c0104e40:	c0 
c0104e41:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104e48:	c0 
c0104e49:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c0104e50:	00 
c0104e51:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104e58:	e8 a6 b5 ff ff       	call   c0100403 <__panic>
     struct Page *p = le2page(le, pra_page_link);//le2page宏可以根据链表元素获得对应的Page指针p  
c0104e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e60:	83 e8 14             	sub    $0x14,%eax
c0104e63:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e69:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e6f:	8b 40 04             	mov    0x4(%eax),%eax
c0104e72:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104e75:	8b 12                	mov    (%edx),%edx
c0104e77:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0104e7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    prev->next = next;
c0104e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e80:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e83:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104e86:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104e8c:	89 10                	mov    %edx,(%eax)
     list_del(le); //将进来最早的页面从队列中删除
     assert(p !=NULL);
c0104e8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104e92:	75 24                	jne    c0104eb8 <_fifo_swap_out_victim+0xf2>
c0104e94:	c7 44 24 0c ac 9f 10 	movl   $0xc0109fac,0xc(%esp)
c0104e9b:	c0 
c0104e9c:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104ea3:	c0 
c0104ea4:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
c0104eab:	00 
c0104eac:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104eb3:	e8 4b b5 ff ff       	call   c0100403 <__panic>
     *ptr_page = p; 
c0104eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104ebe:	89 10                	mov    %edx,(%eax)
     return 0;
c0104ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ec5:	c9                   	leave  
c0104ec6:	c3                   	ret    

c0104ec7 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0104ec7:	55                   	push   %ebp
c0104ec8:	89 e5                	mov    %esp,%ebp
c0104eca:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0104ecd:	c7 04 24 b8 9f 10 c0 	movl   $0xc0109fb8,(%esp)
c0104ed4:	e8 d3 b3 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0104ed9:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104ede:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0104ee1:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104ee6:	83 f8 04             	cmp    $0x4,%eax
c0104ee9:	74 24                	je     c0104f0f <_fifo_check_swap+0x48>
c0104eeb:	c7 44 24 0c de 9f 10 	movl   $0xc0109fde,0xc(%esp)
c0104ef2:	c0 
c0104ef3:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104efa:	c0 
c0104efb:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0104f02:	00 
c0104f03:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104f0a:	e8 f4 b4 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0104f0f:	c7 04 24 f0 9f 10 c0 	movl   $0xc0109ff0,(%esp)
c0104f16:	e8 91 b3 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0104f1b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104f20:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0104f23:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104f28:	83 f8 04             	cmp    $0x4,%eax
c0104f2b:	74 24                	je     c0104f51 <_fifo_check_swap+0x8a>
c0104f2d:	c7 44 24 0c de 9f 10 	movl   $0xc0109fde,0xc(%esp)
c0104f34:	c0 
c0104f35:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104f3c:	c0 
c0104f3d:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
c0104f44:	00 
c0104f45:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104f4c:	e8 b2 b4 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0104f51:	c7 04 24 18 a0 10 c0 	movl   $0xc010a018,(%esp)
c0104f58:	e8 4f b3 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0104f5d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104f62:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0104f65:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104f6a:	83 f8 04             	cmp    $0x4,%eax
c0104f6d:	74 24                	je     c0104f93 <_fifo_check_swap+0xcc>
c0104f6f:	c7 44 24 0c de 9f 10 	movl   $0xc0109fde,0xc(%esp)
c0104f76:	c0 
c0104f77:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104f7e:	c0 
c0104f7f:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c0104f86:	00 
c0104f87:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104f8e:	e8 70 b4 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0104f93:	c7 04 24 40 a0 10 c0 	movl   $0xc010a040,(%esp)
c0104f9a:	e8 0d b3 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0104f9f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104fa4:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0104fa7:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104fac:	83 f8 04             	cmp    $0x4,%eax
c0104faf:	74 24                	je     c0104fd5 <_fifo_check_swap+0x10e>
c0104fb1:	c7 44 24 0c de 9f 10 	movl   $0xc0109fde,0xc(%esp)
c0104fb8:	c0 
c0104fb9:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0104fc0:	c0 
c0104fc1:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104fc8:	00 
c0104fc9:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0104fd0:	e8 2e b4 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0104fd5:	c7 04 24 68 a0 10 c0 	movl   $0xc010a068,(%esp)
c0104fdc:	e8 cb b2 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0104fe1:	b8 00 50 00 00       	mov    $0x5000,%eax
c0104fe6:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0104fe9:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0104fee:	83 f8 05             	cmp    $0x5,%eax
c0104ff1:	74 24                	je     c0105017 <_fifo_check_swap+0x150>
c0104ff3:	c7 44 24 0c 8e a0 10 	movl   $0xc010a08e,0xc(%esp)
c0104ffa:	c0 
c0104ffb:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0105002:	c0 
c0105003:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c010500a:	00 
c010500b:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0105012:	e8 ec b3 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105017:	c7 04 24 40 a0 10 c0 	movl   $0xc010a040,(%esp)
c010501e:	e8 89 b2 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105023:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105028:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010502b:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0105030:	83 f8 05             	cmp    $0x5,%eax
c0105033:	74 24                	je     c0105059 <_fifo_check_swap+0x192>
c0105035:	c7 44 24 0c 8e a0 10 	movl   $0xc010a08e,0xc(%esp)
c010503c:	c0 
c010503d:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0105044:	c0 
c0105045:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010504c:	00 
c010504d:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0105054:	e8 aa b3 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105059:	c7 04 24 f0 9f 10 c0 	movl   $0xc0109ff0,(%esp)
c0105060:	e8 47 b2 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105065:	b8 00 10 00 00       	mov    $0x1000,%eax
c010506a:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c010506d:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0105072:	83 f8 06             	cmp    $0x6,%eax
c0105075:	74 24                	je     c010509b <_fifo_check_swap+0x1d4>
c0105077:	c7 44 24 0c 9d a0 10 	movl   $0xc010a09d,0xc(%esp)
c010507e:	c0 
c010507f:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0105086:	c0 
c0105087:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c010508e:	00 
c010508f:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0105096:	e8 68 b3 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010509b:	c7 04 24 40 a0 10 c0 	movl   $0xc010a040,(%esp)
c01050a2:	e8 05 b2 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01050a7:	b8 00 20 00 00       	mov    $0x2000,%eax
c01050ac:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01050af:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c01050b4:	83 f8 07             	cmp    $0x7,%eax
c01050b7:	74 24                	je     c01050dd <_fifo_check_swap+0x216>
c01050b9:	c7 44 24 0c ac a0 10 	movl   $0xc010a0ac,0xc(%esp)
c01050c0:	c0 
c01050c1:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c01050c8:	c0 
c01050c9:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01050d0:	00 
c01050d1:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c01050d8:	e8 26 b3 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01050dd:	c7 04 24 b8 9f 10 c0 	movl   $0xc0109fb8,(%esp)
c01050e4:	e8 c3 b1 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01050e9:	b8 00 30 00 00       	mov    $0x3000,%eax
c01050ee:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01050f1:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c01050f6:	83 f8 08             	cmp    $0x8,%eax
c01050f9:	74 24                	je     c010511f <_fifo_check_swap+0x258>
c01050fb:	c7 44 24 0c bb a0 10 	movl   $0xc010a0bb,0xc(%esp)
c0105102:	c0 
c0105103:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c010510a:	c0 
c010510b:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
c0105112:	00 
c0105113:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c010511a:	e8 e4 b2 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010511f:	c7 04 24 18 a0 10 c0 	movl   $0xc010a018,(%esp)
c0105126:	e8 81 b1 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010512b:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105130:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0105133:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c0105138:	83 f8 09             	cmp    $0x9,%eax
c010513b:	74 24                	je     c0105161 <_fifo_check_swap+0x29a>
c010513d:	c7 44 24 0c ca a0 10 	movl   $0xc010a0ca,0xc(%esp)
c0105144:	c0 
c0105145:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c010514c:	c0 
c010514d:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0105154:	00 
c0105155:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c010515c:	e8 a2 b2 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0105161:	c7 04 24 68 a0 10 c0 	movl   $0xc010a068,(%esp)
c0105168:	e8 3f b1 ff ff       	call   c01002ac <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010516d:	b8 00 50 00 00       	mov    $0x5000,%eax
c0105172:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0105175:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c010517a:	83 f8 0a             	cmp    $0xa,%eax
c010517d:	74 24                	je     c01051a3 <_fifo_check_swap+0x2dc>
c010517f:	c7 44 24 0c d9 a0 10 	movl   $0xc010a0d9,0xc(%esp)
c0105186:	c0 
c0105187:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c010518e:	c0 
c010518f:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0105196:	00 
c0105197:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c010519e:	e8 60 b2 ff ff       	call   c0100403 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01051a3:	c7 04 24 f0 9f 10 c0 	movl   $0xc0109ff0,(%esp)
c01051aa:	e8 fd b0 ff ff       	call   c01002ac <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01051af:	b8 00 10 00 00       	mov    $0x1000,%eax
c01051b4:	0f b6 00             	movzbl (%eax),%eax
c01051b7:	3c 0a                	cmp    $0xa,%al
c01051b9:	74 24                	je     c01051df <_fifo_check_swap+0x318>
c01051bb:	c7 44 24 0c ec a0 10 	movl   $0xc010a0ec,0xc(%esp)
c01051c2:	c0 
c01051c3:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c01051ca:	c0 
c01051cb:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c01051d2:	00 
c01051d3:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c01051da:	e8 24 b2 ff ff       	call   c0100403 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01051df:	b8 00 10 00 00       	mov    $0x1000,%eax
c01051e4:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c01051e7:	a1 64 3f 12 c0       	mov    0xc0123f64,%eax
c01051ec:	83 f8 0b             	cmp    $0xb,%eax
c01051ef:	74 24                	je     c0105215 <_fifo_check_swap+0x34e>
c01051f1:	c7 44 24 0c 0d a1 10 	movl   $0xc010a10d,0xc(%esp)
c01051f8:	c0 
c01051f9:	c7 44 24 08 62 9f 10 	movl   $0xc0109f62,0x8(%esp)
c0105200:	c0 
c0105201:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0105208:	00 
c0105209:	c7 04 24 77 9f 10 c0 	movl   $0xc0109f77,(%esp)
c0105210:	e8 ee b1 ff ff       	call   c0100403 <__panic>
    return 0;
c0105215:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010521a:	c9                   	leave  
c010521b:	c3                   	ret    

c010521c <_fifo_init>:


static int
_fifo_init(void)
{
c010521c:	55                   	push   %ebp
c010521d:	89 e5                	mov    %esp,%ebp
    return 0;
c010521f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105224:	5d                   	pop    %ebp
c0105225:	c3                   	ret    

c0105226 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105226:	55                   	push   %ebp
c0105227:	89 e5                	mov    %esp,%ebp
    return 0;
c0105229:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010522e:	5d                   	pop    %ebp
c010522f:	c3                   	ret    

c0105230 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0105230:	55                   	push   %ebp
c0105231:	89 e5                	mov    %esp,%ebp
c0105233:	b8 00 00 00 00       	mov    $0x0,%eax
c0105238:	5d                   	pop    %ebp
c0105239:	c3                   	ret    

c010523a <page2ppn>:
page2ppn(struct Page *page) {
c010523a:	55                   	push   %ebp
c010523b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010523d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105240:	8b 15 00 41 12 c0    	mov    0xc0124100,%edx
c0105246:	29 d0                	sub    %edx,%eax
c0105248:	c1 f8 05             	sar    $0x5,%eax
}
c010524b:	5d                   	pop    %ebp
c010524c:	c3                   	ret    

c010524d <page2pa>:
page2pa(struct Page *page) {
c010524d:	55                   	push   %ebp
c010524e:	89 e5                	mov    %esp,%ebp
c0105250:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105253:	8b 45 08             	mov    0x8(%ebp),%eax
c0105256:	89 04 24             	mov    %eax,(%esp)
c0105259:	e8 dc ff ff ff       	call   c010523a <page2ppn>
c010525e:	c1 e0 0c             	shl    $0xc,%eax
}
c0105261:	c9                   	leave  
c0105262:	c3                   	ret    

c0105263 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0105263:	55                   	push   %ebp
c0105264:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105266:	8b 45 08             	mov    0x8(%ebp),%eax
c0105269:	8b 00                	mov    (%eax),%eax
}
c010526b:	5d                   	pop    %ebp
c010526c:	c3                   	ret    

c010526d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010526d:	55                   	push   %ebp
c010526e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105270:	8b 45 08             	mov    0x8(%ebp),%eax
c0105273:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105276:	89 10                	mov    %edx,(%eax)
}
c0105278:	90                   	nop
c0105279:	5d                   	pop    %ebp
c010527a:	c3                   	ret    

c010527b <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

//将双向链表初始化，同时将空闲页总数nr_free初始化为0
static void
default_init(void) {
c010527b:	55                   	push   %ebp
c010527c:	89 e5                	mov    %esp,%ebp
c010527e:	83 ec 10             	sub    $0x10,%esp
c0105281:	c7 45 fc ec 40 12 c0 	movl   $0xc01240ec,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0105288:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010528b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010528e:	89 50 04             	mov    %edx,0x4(%eax)
c0105291:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105294:	8b 50 04             	mov    0x4(%eax),%edx
c0105297:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010529a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010529c:	c7 05 f4 40 12 c0 00 	movl   $0x0,0xc01240f4
c01052a3:	00 00 00 
}
c01052a6:	90                   	nop
c01052a7:	c9                   	leave  
c01052a8:	c3                   	ret    

c01052a9 <default_init_memmap>:

//初始化一个空闲块
static void
default_init_memmap(struct Page *base, size_t n) {
c01052a9:	55                   	push   %ebp
c01052aa:	89 e5                	mov    %esp,%ebp
c01052ac:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01052af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01052b3:	75 24                	jne    c01052d9 <default_init_memmap+0x30>
c01052b5:	c7 44 24 0c 30 a1 10 	movl   $0xc010a130,0xc(%esp)
c01052bc:	c0 
c01052bd:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01052c4:	c0 
c01052c5:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c01052cc:	00 
c01052cd:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01052d4:	e8 2a b1 ff ff       	call   c0100403 <__panic>
    struct Page *p = base;
c01052d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01052df:	eb 7d                	jmp    c010535e <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01052e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052e4:	83 c0 04             	add    $0x4,%eax
c01052e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01052ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01052f7:	0f a3 10             	bt     %edx,(%eax)
c01052fa:	19 c0                	sbb    %eax,%eax
c01052fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01052ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105303:	0f 95 c0             	setne  %al
c0105306:	0f b6 c0             	movzbl %al,%eax
c0105309:	85 c0                	test   %eax,%eax
c010530b:	75 24                	jne    c0105331 <default_init_memmap+0x88>
c010530d:	c7 44 24 0c 61 a1 10 	movl   $0xc010a161,0xc(%esp)
c0105314:	c0 
c0105315:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c010531c:	c0 
c010531d:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c0105324:	00 
c0105325:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c010532c:	e8 d2 b0 ff ff       	call   c0100403 <__panic>
        p->flags = p->property = 0;
c0105331:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105334:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010533b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010533e:	8b 50 08             	mov    0x8(%eax),%edx
c0105341:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105344:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105347:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010534e:	00 
c010534f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105352:	89 04 24             	mov    %eax,(%esp)
c0105355:	e8 13 ff ff ff       	call   c010526d <set_page_ref>
    for (; p != base + n; p ++) {
c010535a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010535e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105361:	c1 e0 05             	shl    $0x5,%eax
c0105364:	89 c2                	mov    %eax,%edx
c0105366:	8b 45 08             	mov    0x8(%ebp),%eax
c0105369:	01 d0                	add    %edx,%eax
c010536b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010536e:	0f 85 6d ff ff ff    	jne    c01052e1 <default_init_memmap+0x38>
    }
    base->property = n;
c0105374:	8b 45 08             	mov    0x8(%ebp),%eax
c0105377:	8b 55 0c             	mov    0xc(%ebp),%edx
c010537a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010537d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105380:	83 c0 04             	add    $0x4,%eax
c0105383:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c010538a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010538d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105390:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105393:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105396:	8b 15 f4 40 12 c0    	mov    0xc01240f4,%edx
c010539c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010539f:	01 d0                	add    %edx,%eax
c01053a1:	a3 f4 40 12 c0       	mov    %eax,0xc01240f4
    list_add(&free_list, &(base->page_link));
c01053a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a9:	83 c0 0c             	add    $0xc,%eax
c01053ac:	c7 45 e4 ec 40 12 c0 	movl   $0xc01240ec,-0x1c(%ebp)
c01053b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01053bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_add(elm, listelm, listelm->next);
c01053c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053c5:	8b 40 04             	mov    0x4(%eax),%eax
c01053c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01053ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053d1:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01053d4:	89 45 cc             	mov    %eax,-0x34(%ebp)
    prev->next = next->prev = elm;
c01053d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01053da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053dd:	89 10                	mov    %edx,(%eax)
c01053df:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01053e2:	8b 10                	mov    (%eax),%edx
c01053e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053e7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01053ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01053f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01053f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01053f9:	89 10                	mov    %edx,(%eax)
}
c01053fb:	90                   	nop
c01053fc:	c9                   	leave  
c01053fd:	c3                   	ret    

c01053fe <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01053fe:	55                   	push   %ebp
c01053ff:	89 e5                	mov    %esp,%ebp
c0105401:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0105404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105408:	75 24                	jne    c010542e <default_alloc_pages+0x30>
c010540a:	c7 44 24 0c 30 a1 10 	movl   $0xc010a130,0xc(%esp)
c0105411:	c0 
c0105412:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105419:	c0 
c010541a:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0105421:	00 
c0105422:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105429:	e8 d5 af ff ff       	call   c0100403 <__panic>
    if (n > nr_free) {
c010542e:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0105433:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105436:	76 0a                	jbe    c0105442 <default_alloc_pages+0x44>
        return NULL;
c0105438:	b8 00 00 00 00       	mov    $0x0,%eax
c010543d:	e9 40 01 00 00       	jmp    c0105582 <default_alloc_pages+0x184>
    }
    struct Page *page = NULL;
c0105442:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105449:	c7 45 f0 ec 40 12 c0 	movl   $0xc01240ec,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105450:	eb 1c                	jmp    c010546e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0105452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105455:	83 e8 0c             	sub    $0xc,%eax
c0105458:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010545b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010545e:	8b 40 08             	mov    0x8(%eax),%eax
c0105461:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105464:	77 08                	ja     c010546e <default_alloc_pages+0x70>
            page = p;
c0105466:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105469:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010546c:	eb 18                	jmp    c0105486 <default_alloc_pages+0x88>
c010546e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105471:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0105474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105477:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010547a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010547d:	81 7d f0 ec 40 12 c0 	cmpl   $0xc01240ec,-0x10(%ebp)
c0105484:	75 cc                	jne    c0105452 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0105486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010548a:	0f 84 ef 00 00 00    	je     c010557f <default_alloc_pages+0x181>
        list_del(&(page->page_link));
c0105490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105493:	83 c0 0c             	add    $0xc,%eax
c0105496:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105499:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010549c:	8b 40 04             	mov    0x4(%eax),%eax
c010549f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054a2:	8b 12                	mov    (%edx),%edx
c01054a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
    prev->next = next;
c01054aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054ad:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01054b0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01054b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054b9:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01054bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054be:	8b 40 08             	mov    0x8(%eax),%eax
c01054c1:	39 45 08             	cmp    %eax,0x8(%ebp)
c01054c4:	0f 83 8f 00 00 00    	jae    c0105559 <default_alloc_pages+0x15b>
            struct Page *p = page + n;
c01054ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01054cd:	c1 e0 05             	shl    $0x5,%eax
c01054d0:	89 c2                	mov    %eax,%edx
c01054d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054d5:	01 d0                	add    %edx,%eax
c01054d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01054da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054dd:	8b 40 08             	mov    0x8(%eax),%eax
c01054e0:	2b 45 08             	sub    0x8(%ebp),%eax
c01054e3:	89 c2                	mov    %eax,%edx
c01054e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054e8:	89 50 08             	mov    %edx,0x8(%eax)
            //
            SetPageProperty(p);
c01054eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ee:	83 c0 04             	add    $0x4,%eax
c01054f1:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01054f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01054fb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01054fe:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105501:	0f ab 10             	bts    %edx,(%eax)
            //
            list_add(&free_list, &(p->page_link));
c0105504:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105507:	83 c0 0c             	add    $0xc,%eax
c010550a:	c7 45 d4 ec 40 12 c0 	movl   $0xc01240ec,-0x2c(%ebp)
c0105511:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105514:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105517:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010551a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010551d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105520:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105523:	8b 40 04             	mov    0x4(%eax),%eax
c0105526:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105529:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010552c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010552f:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105532:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c0105535:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105538:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010553b:	89 10                	mov    %edx,(%eax)
c010553d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105540:	8b 10                	mov    (%eax),%edx
c0105542:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105545:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105548:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010554b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010554e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105551:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105554:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105557:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0105559:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c010555e:	2b 45 08             	sub    0x8(%ebp),%eax
c0105561:	a3 f4 40 12 c0       	mov    %eax,0xc01240f4
        ClearPageProperty(page);
c0105566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105569:	83 c0 04             	add    $0x4,%eax
c010556c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105573:	89 45 ac             	mov    %eax,-0x54(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105576:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105579:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010557c:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010557f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    //mycode

    //mycode
}
c0105582:	c9                   	leave  
c0105583:	c3                   	ret    

c0105584 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105584:	55                   	push   %ebp
c0105585:	89 e5                	mov    %esp,%ebp
c0105587:	81 ec 88 00 00 00    	sub    $0x88,%esp
    //mycode
    assert(n > 0);
c010558d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105591:	75 24                	jne    c01055b7 <default_free_pages+0x33>
c0105593:	c7 44 24 0c 30 a1 10 	movl   $0xc010a130,0xc(%esp)
c010559a:	c0 
c010559b:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01055a2:	c0 
c01055a3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c01055aa:	00 
c01055ab:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01055b2:	e8 4c ae ff ff       	call   c0100403 <__panic>
    struct Page *p = base;
c01055b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01055bd:	e9 9d 00 00 00       	jmp    c010565f <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01055c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055c5:	83 c0 04             	add    $0x4,%eax
c01055c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01055cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055d8:	0f a3 10             	bt     %edx,(%eax)
c01055db:	19 c0                	sbb    %eax,%eax
c01055dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01055e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055e4:	0f 95 c0             	setne  %al
c01055e7:	0f b6 c0             	movzbl %al,%eax
c01055ea:	85 c0                	test   %eax,%eax
c01055ec:	75 2c                	jne    c010561a <default_free_pages+0x96>
c01055ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055f1:	83 c0 04             	add    $0x4,%eax
c01055f4:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01055fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01055fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105601:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105604:	0f a3 10             	bt     %edx,(%eax)
c0105607:	19 c0                	sbb    %eax,%eax
c0105609:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010560c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105610:	0f 95 c0             	setne  %al
c0105613:	0f b6 c0             	movzbl %al,%eax
c0105616:	85 c0                	test   %eax,%eax
c0105618:	74 24                	je     c010563e <default_free_pages+0xba>
c010561a:	c7 44 24 0c 74 a1 10 	movl   $0xc010a174,0xc(%esp)
c0105621:	c0 
c0105622:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105629:	c0 
c010562a:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0105631:	00 
c0105632:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105639:	e8 c5 ad ff ff       	call   c0100403 <__panic>
        p->flags = 0;
c010563e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0105648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010564f:	00 
c0105650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105653:	89 04 24             	mov    %eax,(%esp)
c0105656:	e8 12 fc ff ff       	call   c010526d <set_page_ref>
    for (; p != base + n; p ++) {
c010565b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010565f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105662:	c1 e0 05             	shl    $0x5,%eax
c0105665:	89 c2                	mov    %eax,%edx
c0105667:	8b 45 08             	mov    0x8(%ebp),%eax
c010566a:	01 d0                	add    %edx,%eax
c010566c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010566f:	0f 85 4d ff ff ff    	jne    c01055c2 <default_free_pages+0x3e>
    }
    base->property = n;
c0105675:	8b 45 08             	mov    0x8(%ebp),%eax
c0105678:	8b 55 0c             	mov    0xc(%ebp),%edx
c010567b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010567e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105681:	83 c0 04             	add    $0x4,%eax
c0105684:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010568b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010568e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105691:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105694:	0f ab 10             	bts    %edx,(%eax)
    list_entry_t *le = &free_list;
c0105697:	c7 45 f0 ec 40 12 c0 	movl   $0xc01240ec,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010569e:	e9 eb 00 00 00       	jmp    c010578e <default_free_pages+0x20a>
        p = le2page(le, page_link);
c01056a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056a6:	83 e8 0c             	sub    $0xc,%eax
c01056a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property == p) {
c01056ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01056af:	8b 40 08             	mov    0x8(%eax),%eax
c01056b2:	c1 e0 05             	shl    $0x5,%eax
c01056b5:	89 c2                	mov    %eax,%edx
c01056b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ba:	01 d0                	add    %edx,%eax
c01056bc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01056bf:	75 5a                	jne    c010571b <default_free_pages+0x197>
            base->property += p->property;
c01056c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c4:	8b 50 08             	mov    0x8(%eax),%edx
c01056c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ca:	8b 40 08             	mov    0x8(%eax),%eax
c01056cd:	01 c2                	add    %eax,%edx
c01056cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d2:	89 50 08             	mov    %edx,0x8(%eax)
            //p->property = 0;
            ClearPageProperty(p);
c01056d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056d8:	83 c0 04             	add    $0x4,%eax
c01056db:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01056e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01056e5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01056e8:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01056eb:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c01056ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f1:	83 c0 0c             	add    $0xc,%eax
c01056f4:	89 45 cc             	mov    %eax,-0x34(%ebp)
    __list_del(listelm->prev, listelm->next);
c01056f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01056fa:	8b 40 04             	mov    0x4(%eax),%eax
c01056fd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105700:	8b 12                	mov    (%edx),%edx
c0105702:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105705:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next;
c0105708:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010570b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010570e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105711:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105714:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105717:	89 10                	mov    %edx,(%eax)
c0105719:	eb 73                	jmp    c010578e <default_free_pages+0x20a>
        }
        else if (p + p->property == base) {
c010571b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010571e:	8b 40 08             	mov    0x8(%eax),%eax
c0105721:	c1 e0 05             	shl    $0x5,%eax
c0105724:	89 c2                	mov    %eax,%edx
c0105726:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105729:	01 d0                	add    %edx,%eax
c010572b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010572e:	75 5e                	jne    c010578e <default_free_pages+0x20a>
            p->property += base->property;
c0105730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105733:	8b 50 08             	mov    0x8(%eax),%edx
c0105736:	8b 45 08             	mov    0x8(%ebp),%eax
c0105739:	8b 40 08             	mov    0x8(%eax),%eax
c010573c:	01 c2                	add    %eax,%edx
c010573e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105741:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0105744:	8b 45 08             	mov    0x8(%ebp),%eax
c0105747:	83 c0 04             	add    $0x4,%eax
c010574a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105751:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0105754:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105757:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010575a:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c010575d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105760:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105766:	83 c0 0c             	add    $0xc,%eax
c0105769:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
c010576c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010576f:	8b 40 04             	mov    0x4(%eax),%eax
c0105772:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105775:	8b 12                	mov    (%edx),%edx
c0105777:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c010577a:	89 45 b0             	mov    %eax,-0x50(%ebp)
    prev->next = next;
c010577d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105780:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105783:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105786:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105789:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010578c:	89 10                	mov    %edx,(%eax)
c010578e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105791:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return listelm->next;
c0105794:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105797:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010579a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010579d:	81 7d f0 ec 40 12 c0 	cmpl   $0xc01240ec,-0x10(%ebp)
c01057a4:	0f 85 f9 fe ff ff    	jne    c01056a3 <default_free_pages+0x11f>
        }
    }
    le = &free_list;
c01057aa:	c7 45 f0 ec 40 12 c0 	movl   $0xc01240ec,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01057b1:	eb 1e                	jmp    c01057d1 <default_free_pages+0x24d>
        p = le2page(le, page_link);
c01057b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057b6:	83 e8 0c             	sub    $0xc,%eax
c01057b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c01057bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bf:	8b 40 08             	mov    0x8(%eax),%eax
c01057c2:	c1 e0 05             	shl    $0x5,%eax
c01057c5:	89 c2                	mov    %eax,%edx
c01057c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ca:	01 d0                	add    %edx,%eax
c01057cc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01057cf:	73 1a                	jae    c01057eb <default_free_pages+0x267>
c01057d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d4:	89 45 a0             	mov    %eax,-0x60(%ebp)
c01057d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01057da:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01057dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057e0:	81 7d f0 ec 40 12 c0 	cmpl   $0xc01240ec,-0x10(%ebp)
c01057e7:	75 ca                	jne    c01057b3 <default_free_pages+0x22f>
c01057e9:	eb 01                	jmp    c01057ec <default_free_pages+0x268>
            break;
c01057eb:	90                   	nop
        }
    }
    nr_free += n;
c01057ec:	8b 15 f4 40 12 c0    	mov    0xc01240f4,%edx
c01057f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057f5:	01 d0                	add    %edx,%eax
c01057f7:	a3 f4 40 12 c0       	mov    %eax,0xc01240f4
    list_add_before(le, &(base->page_link));
c01057fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ff:	8d 50 0c             	lea    0xc(%eax),%edx
c0105802:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105805:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0105808:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
c010580b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010580e:	8b 00                	mov    (%eax),%eax
c0105810:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105813:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0105816:	89 45 90             	mov    %eax,-0x70(%ebp)
c0105819:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010581c:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
c010581f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105822:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105825:	89 10                	mov    %edx,(%eax)
c0105827:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010582a:	8b 10                	mov    (%eax),%edx
c010582c:	8b 45 90             	mov    -0x70(%ebp),%eax
c010582f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105832:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105835:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105838:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010583b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010583e:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105841:	89 10                	mov    %edx,(%eax)
}
c0105843:	90                   	nop
c0105844:	c9                   	leave  
c0105845:	c3                   	ret    

c0105846 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105846:	55                   	push   %ebp
c0105847:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105849:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
}
c010584e:	5d                   	pop    %ebp
c010584f:	c3                   	ret    

c0105850 <basic_check>:

static void
basic_check(void) {
c0105850:	55                   	push   %ebp
c0105851:	89 e5                	mov    %esp,%ebp
c0105853:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010585d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105860:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105863:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105866:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105869:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105870:	e8 d0 0e 00 00       	call   c0106745 <alloc_pages>
c0105875:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105878:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010587c:	75 24                	jne    c01058a2 <basic_check+0x52>
c010587e:	c7 44 24 0c 99 a1 10 	movl   $0xc010a199,0xc(%esp)
c0105885:	c0 
c0105886:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c010588d:	c0 
c010588e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0105895:	00 
c0105896:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c010589d:	e8 61 ab ff ff       	call   c0100403 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01058a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058a9:	e8 97 0e 00 00       	call   c0106745 <alloc_pages>
c01058ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058b5:	75 24                	jne    c01058db <basic_check+0x8b>
c01058b7:	c7 44 24 0c b5 a1 10 	movl   $0xc010a1b5,0xc(%esp)
c01058be:	c0 
c01058bf:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01058c6:	c0 
c01058c7:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01058ce:	00 
c01058cf:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01058d6:	e8 28 ab ff ff       	call   c0100403 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01058db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058e2:	e8 5e 0e 00 00       	call   c0106745 <alloc_pages>
c01058e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01058ee:	75 24                	jne    c0105914 <basic_check+0xc4>
c01058f0:	c7 44 24 0c d1 a1 10 	movl   $0xc010a1d1,0xc(%esp)
c01058f7:	c0 
c01058f8:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01058ff:	c0 
c0105900:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0105907:	00 
c0105908:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c010590f:	e8 ef aa ff ff       	call   c0100403 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105914:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105917:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010591a:	74 10                	je     c010592c <basic_check+0xdc>
c010591c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010591f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105922:	74 08                	je     c010592c <basic_check+0xdc>
c0105924:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105927:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010592a:	75 24                	jne    c0105950 <basic_check+0x100>
c010592c:	c7 44 24 0c f0 a1 10 	movl   $0xc010a1f0,0xc(%esp)
c0105933:	c0 
c0105934:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c010593b:	c0 
c010593c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0105943:	00 
c0105944:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c010594b:	e8 b3 aa ff ff       	call   c0100403 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105950:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105953:	89 04 24             	mov    %eax,(%esp)
c0105956:	e8 08 f9 ff ff       	call   c0105263 <page_ref>
c010595b:	85 c0                	test   %eax,%eax
c010595d:	75 1e                	jne    c010597d <basic_check+0x12d>
c010595f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105962:	89 04 24             	mov    %eax,(%esp)
c0105965:	e8 f9 f8 ff ff       	call   c0105263 <page_ref>
c010596a:	85 c0                	test   %eax,%eax
c010596c:	75 0f                	jne    c010597d <basic_check+0x12d>
c010596e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105971:	89 04 24             	mov    %eax,(%esp)
c0105974:	e8 ea f8 ff ff       	call   c0105263 <page_ref>
c0105979:	85 c0                	test   %eax,%eax
c010597b:	74 24                	je     c01059a1 <basic_check+0x151>
c010597d:	c7 44 24 0c 14 a2 10 	movl   $0xc010a214,0xc(%esp)
c0105984:	c0 
c0105985:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c010598c:	c0 
c010598d:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0105994:	00 
c0105995:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c010599c:	e8 62 aa ff ff       	call   c0100403 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01059a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059a4:	89 04 24             	mov    %eax,(%esp)
c01059a7:	e8 a1 f8 ff ff       	call   c010524d <page2pa>
c01059ac:	8b 15 80 3f 12 c0    	mov    0xc0123f80,%edx
c01059b2:	c1 e2 0c             	shl    $0xc,%edx
c01059b5:	39 d0                	cmp    %edx,%eax
c01059b7:	72 24                	jb     c01059dd <basic_check+0x18d>
c01059b9:	c7 44 24 0c 50 a2 10 	movl   $0xc010a250,0xc(%esp)
c01059c0:	c0 
c01059c1:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01059c8:	c0 
c01059c9:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01059d0:	00 
c01059d1:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01059d8:	e8 26 aa ff ff       	call   c0100403 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01059dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059e0:	89 04 24             	mov    %eax,(%esp)
c01059e3:	e8 65 f8 ff ff       	call   c010524d <page2pa>
c01059e8:	8b 15 80 3f 12 c0    	mov    0xc0123f80,%edx
c01059ee:	c1 e2 0c             	shl    $0xc,%edx
c01059f1:	39 d0                	cmp    %edx,%eax
c01059f3:	72 24                	jb     c0105a19 <basic_check+0x1c9>
c01059f5:	c7 44 24 0c 6d a2 10 	movl   $0xc010a26d,0xc(%esp)
c01059fc:	c0 
c01059fd:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105a04:	c0 
c0105a05:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0105a0c:	00 
c0105a0d:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105a14:	e8 ea a9 ff ff       	call   c0100403 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a1c:	89 04 24             	mov    %eax,(%esp)
c0105a1f:	e8 29 f8 ff ff       	call   c010524d <page2pa>
c0105a24:	8b 15 80 3f 12 c0    	mov    0xc0123f80,%edx
c0105a2a:	c1 e2 0c             	shl    $0xc,%edx
c0105a2d:	39 d0                	cmp    %edx,%eax
c0105a2f:	72 24                	jb     c0105a55 <basic_check+0x205>
c0105a31:	c7 44 24 0c 8a a2 10 	movl   $0xc010a28a,0xc(%esp)
c0105a38:	c0 
c0105a39:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105a40:	c0 
c0105a41:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0105a48:	00 
c0105a49:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105a50:	e8 ae a9 ff ff       	call   c0100403 <__panic>

    list_entry_t free_list_store = free_list;
c0105a55:	a1 ec 40 12 c0       	mov    0xc01240ec,%eax
c0105a5a:	8b 15 f0 40 12 c0    	mov    0xc01240f0,%edx
c0105a60:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105a63:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105a66:	c7 45 dc ec 40 12 c0 	movl   $0xc01240ec,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105a6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a70:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105a73:	89 50 04             	mov    %edx,0x4(%eax)
c0105a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a79:	8b 50 04             	mov    0x4(%eax),%edx
c0105a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a7f:	89 10                	mov    %edx,(%eax)
c0105a81:	c7 45 e0 ec 40 12 c0 	movl   $0xc01240ec,-0x20(%ebp)
    return list->next == list;
c0105a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a8b:	8b 40 04             	mov    0x4(%eax),%eax
c0105a8e:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105a91:	0f 94 c0             	sete   %al
c0105a94:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105a97:	85 c0                	test   %eax,%eax
c0105a99:	75 24                	jne    c0105abf <basic_check+0x26f>
c0105a9b:	c7 44 24 0c a7 a2 10 	movl   $0xc010a2a7,0xc(%esp)
c0105aa2:	c0 
c0105aa3:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105aaa:	c0 
c0105aab:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0105ab2:	00 
c0105ab3:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105aba:	e8 44 a9 ff ff       	call   c0100403 <__panic>

    unsigned int nr_free_store = nr_free;
c0105abf:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0105ac4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0105ac7:	c7 05 f4 40 12 c0 00 	movl   $0x0,0xc01240f4
c0105ace:	00 00 00 

    assert(alloc_page() == NULL);
c0105ad1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ad8:	e8 68 0c 00 00       	call   c0106745 <alloc_pages>
c0105add:	85 c0                	test   %eax,%eax
c0105adf:	74 24                	je     c0105b05 <basic_check+0x2b5>
c0105ae1:	c7 44 24 0c be a2 10 	movl   $0xc010a2be,0xc(%esp)
c0105ae8:	c0 
c0105ae9:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105af0:	c0 
c0105af1:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0105af8:	00 
c0105af9:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105b00:	e8 fe a8 ff ff       	call   c0100403 <__panic>

    free_page(p0);
c0105b05:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b0c:	00 
c0105b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b10:	89 04 24             	mov    %eax,(%esp)
c0105b13:	e8 98 0c 00 00       	call   c01067b0 <free_pages>
    free_page(p1);
c0105b18:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b1f:	00 
c0105b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b23:	89 04 24             	mov    %eax,(%esp)
c0105b26:	e8 85 0c 00 00       	call   c01067b0 <free_pages>
    free_page(p2);
c0105b2b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b32:	00 
c0105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b36:	89 04 24             	mov    %eax,(%esp)
c0105b39:	e8 72 0c 00 00       	call   c01067b0 <free_pages>
    assert(nr_free == 3);
c0105b3e:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0105b43:	83 f8 03             	cmp    $0x3,%eax
c0105b46:	74 24                	je     c0105b6c <basic_check+0x31c>
c0105b48:	c7 44 24 0c d3 a2 10 	movl   $0xc010a2d3,0xc(%esp)
c0105b4f:	c0 
c0105b50:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105b57:	c0 
c0105b58:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0105b5f:	00 
c0105b60:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105b67:	e8 97 a8 ff ff       	call   c0100403 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0105b6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b73:	e8 cd 0b 00 00       	call   c0106745 <alloc_pages>
c0105b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105b7f:	75 24                	jne    c0105ba5 <basic_check+0x355>
c0105b81:	c7 44 24 0c 99 a1 10 	movl   $0xc010a199,0xc(%esp)
c0105b88:	c0 
c0105b89:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105b90:	c0 
c0105b91:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0105b98:	00 
c0105b99:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105ba0:	e8 5e a8 ff ff       	call   c0100403 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105ba5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105bac:	e8 94 0b 00 00       	call   c0106745 <alloc_pages>
c0105bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105bb8:	75 24                	jne    c0105bde <basic_check+0x38e>
c0105bba:	c7 44 24 0c b5 a1 10 	movl   $0xc010a1b5,0xc(%esp)
c0105bc1:	c0 
c0105bc2:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105bc9:	c0 
c0105bca:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0105bd1:	00 
c0105bd2:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105bd9:	e8 25 a8 ff ff       	call   c0100403 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105bde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105be5:	e8 5b 0b 00 00       	call   c0106745 <alloc_pages>
c0105bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105bf1:	75 24                	jne    c0105c17 <basic_check+0x3c7>
c0105bf3:	c7 44 24 0c d1 a1 10 	movl   $0xc010a1d1,0xc(%esp)
c0105bfa:	c0 
c0105bfb:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105c02:	c0 
c0105c03:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0105c0a:	00 
c0105c0b:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105c12:	e8 ec a7 ff ff       	call   c0100403 <__panic>

    assert(alloc_page() == NULL);
c0105c17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105c1e:	e8 22 0b 00 00       	call   c0106745 <alloc_pages>
c0105c23:	85 c0                	test   %eax,%eax
c0105c25:	74 24                	je     c0105c4b <basic_check+0x3fb>
c0105c27:	c7 44 24 0c be a2 10 	movl   $0xc010a2be,0xc(%esp)
c0105c2e:	c0 
c0105c2f:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105c36:	c0 
c0105c37:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0105c3e:	00 
c0105c3f:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105c46:	e8 b8 a7 ff ff       	call   c0100403 <__panic>

    free_page(p0);
c0105c4b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c52:	00 
c0105c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c56:	89 04 24             	mov    %eax,(%esp)
c0105c59:	e8 52 0b 00 00       	call   c01067b0 <free_pages>
c0105c5e:	c7 45 d8 ec 40 12 c0 	movl   $0xc01240ec,-0x28(%ebp)
c0105c65:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105c68:	8b 40 04             	mov    0x4(%eax),%eax
c0105c6b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0105c6e:	0f 94 c0             	sete   %al
c0105c71:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0105c74:	85 c0                	test   %eax,%eax
c0105c76:	74 24                	je     c0105c9c <basic_check+0x44c>
c0105c78:	c7 44 24 0c e0 a2 10 	movl   $0xc010a2e0,0xc(%esp)
c0105c7f:	c0 
c0105c80:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105c87:	c0 
c0105c88:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0105c8f:	00 
c0105c90:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105c97:	e8 67 a7 ff ff       	call   c0100403 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0105c9c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ca3:	e8 9d 0a 00 00       	call   c0106745 <alloc_pages>
c0105ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105cab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105cb1:	74 24                	je     c0105cd7 <basic_check+0x487>
c0105cb3:	c7 44 24 0c f8 a2 10 	movl   $0xc010a2f8,0xc(%esp)
c0105cba:	c0 
c0105cbb:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105cc2:	c0 
c0105cc3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0105cca:	00 
c0105ccb:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105cd2:	e8 2c a7 ff ff       	call   c0100403 <__panic>
    assert(alloc_page() == NULL);
c0105cd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105cde:	e8 62 0a 00 00       	call   c0106745 <alloc_pages>
c0105ce3:	85 c0                	test   %eax,%eax
c0105ce5:	74 24                	je     c0105d0b <basic_check+0x4bb>
c0105ce7:	c7 44 24 0c be a2 10 	movl   $0xc010a2be,0xc(%esp)
c0105cee:	c0 
c0105cef:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105cf6:	c0 
c0105cf7:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0105cfe:	00 
c0105cff:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105d06:	e8 f8 a6 ff ff       	call   c0100403 <__panic>

    assert(nr_free == 0);
c0105d0b:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0105d10:	85 c0                	test   %eax,%eax
c0105d12:	74 24                	je     c0105d38 <basic_check+0x4e8>
c0105d14:	c7 44 24 0c 11 a3 10 	movl   $0xc010a311,0xc(%esp)
c0105d1b:	c0 
c0105d1c:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105d23:	c0 
c0105d24:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0105d2b:	00 
c0105d2c:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105d33:	e8 cb a6 ff ff       	call   c0100403 <__panic>
    free_list = free_list_store;
c0105d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105d3b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d3e:	a3 ec 40 12 c0       	mov    %eax,0xc01240ec
c0105d43:	89 15 f0 40 12 c0    	mov    %edx,0xc01240f0
    nr_free = nr_free_store;
c0105d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d4c:	a3 f4 40 12 c0       	mov    %eax,0xc01240f4

    free_page(p);
c0105d51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d58:	00 
c0105d59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d5c:	89 04 24             	mov    %eax,(%esp)
c0105d5f:	e8 4c 0a 00 00       	call   c01067b0 <free_pages>
    free_page(p1);
c0105d64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d6b:	00 
c0105d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d6f:	89 04 24             	mov    %eax,(%esp)
c0105d72:	e8 39 0a 00 00       	call   c01067b0 <free_pages>
    free_page(p2);
c0105d77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d7e:	00 
c0105d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d82:	89 04 24             	mov    %eax,(%esp)
c0105d85:	e8 26 0a 00 00       	call   c01067b0 <free_pages>
}
c0105d8a:	90                   	nop
c0105d8b:	c9                   	leave  
c0105d8c:	c3                   	ret    

c0105d8d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0105d8d:	55                   	push   %ebp
c0105d8e:	89 e5                	mov    %esp,%ebp
c0105d90:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0105d96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105d9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0105da4:	c7 45 ec ec 40 12 c0 	movl   $0xc01240ec,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105dab:	eb 6a                	jmp    c0105e17 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0105dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105db0:	83 e8 0c             	sub    $0xc,%eax
c0105db3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0105db6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105db9:	83 c0 04             	add    $0x4,%eax
c0105dbc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105dc3:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105dc6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105dc9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105dcc:	0f a3 10             	bt     %edx,(%eax)
c0105dcf:	19 c0                	sbb    %eax,%eax
c0105dd1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0105dd4:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0105dd8:	0f 95 c0             	setne  %al
c0105ddb:	0f b6 c0             	movzbl %al,%eax
c0105dde:	85 c0                	test   %eax,%eax
c0105de0:	75 24                	jne    c0105e06 <default_check+0x79>
c0105de2:	c7 44 24 0c 1e a3 10 	movl   $0xc010a31e,0xc(%esp)
c0105de9:	c0 
c0105dea:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105df1:	c0 
c0105df2:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0105df9:	00 
c0105dfa:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105e01:	e8 fd a5 ff ff       	call   c0100403 <__panic>
        count ++, total += p->property;
c0105e06:	ff 45 f4             	incl   -0xc(%ebp)
c0105e09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e0c:	8b 50 08             	mov    0x8(%eax),%edx
c0105e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e12:	01 d0                	add    %edx,%eax
c0105e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e1a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0105e1d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105e20:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e26:	81 7d ec ec 40 12 c0 	cmpl   $0xc01240ec,-0x14(%ebp)
c0105e2d:	0f 85 7a ff ff ff    	jne    c0105dad <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0105e33:	e8 ab 09 00 00       	call   c01067e3 <nr_free_pages>
c0105e38:	89 c2                	mov    %eax,%edx
c0105e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e3d:	39 c2                	cmp    %eax,%edx
c0105e3f:	74 24                	je     c0105e65 <default_check+0xd8>
c0105e41:	c7 44 24 0c 2e a3 10 	movl   $0xc010a32e,0xc(%esp)
c0105e48:	c0 
c0105e49:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105e50:	c0 
c0105e51:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0105e58:	00 
c0105e59:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105e60:	e8 9e a5 ff ff       	call   c0100403 <__panic>

    basic_check();
c0105e65:	e8 e6 f9 ff ff       	call   c0105850 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105e6a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105e71:	e8 cf 08 00 00       	call   c0106745 <alloc_pages>
c0105e76:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0105e79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e7d:	75 24                	jne    c0105ea3 <default_check+0x116>
c0105e7f:	c7 44 24 0c 47 a3 10 	movl   $0xc010a347,0xc(%esp)
c0105e86:	c0 
c0105e87:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105e8e:	c0 
c0105e8f:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0105e96:	00 
c0105e97:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105e9e:	e8 60 a5 ff ff       	call   c0100403 <__panic>
    assert(!PageProperty(p0));
c0105ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ea6:	83 c0 04             	add    $0x4,%eax
c0105ea9:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0105eb0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105eb3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105eb6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105eb9:	0f a3 10             	bt     %edx,(%eax)
c0105ebc:	19 c0                	sbb    %eax,%eax
c0105ebe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0105ec1:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105ec5:	0f 95 c0             	setne  %al
c0105ec8:	0f b6 c0             	movzbl %al,%eax
c0105ecb:	85 c0                	test   %eax,%eax
c0105ecd:	74 24                	je     c0105ef3 <default_check+0x166>
c0105ecf:	c7 44 24 0c 52 a3 10 	movl   $0xc010a352,0xc(%esp)
c0105ed6:	c0 
c0105ed7:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105ede:	c0 
c0105edf:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0105ee6:	00 
c0105ee7:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105eee:	e8 10 a5 ff ff       	call   c0100403 <__panic>

    list_entry_t free_list_store = free_list;
c0105ef3:	a1 ec 40 12 c0       	mov    0xc01240ec,%eax
c0105ef8:	8b 15 f0 40 12 c0    	mov    0xc01240f0,%edx
c0105efe:	89 45 80             	mov    %eax,-0x80(%ebp)
c0105f01:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0105f04:	c7 45 b0 ec 40 12 c0 	movl   $0xc01240ec,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0105f0b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105f0e:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105f11:	89 50 04             	mov    %edx,0x4(%eax)
c0105f14:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105f17:	8b 50 04             	mov    0x4(%eax),%edx
c0105f1a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105f1d:	89 10                	mov    %edx,(%eax)
c0105f1f:	c7 45 b4 ec 40 12 c0 	movl   $0xc01240ec,-0x4c(%ebp)
    return list->next == list;
c0105f26:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105f29:	8b 40 04             	mov    0x4(%eax),%eax
c0105f2c:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0105f2f:	0f 94 c0             	sete   %al
c0105f32:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105f35:	85 c0                	test   %eax,%eax
c0105f37:	75 24                	jne    c0105f5d <default_check+0x1d0>
c0105f39:	c7 44 24 0c a7 a2 10 	movl   $0xc010a2a7,0xc(%esp)
c0105f40:	c0 
c0105f41:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105f48:	c0 
c0105f49:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0105f50:	00 
c0105f51:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105f58:	e8 a6 a4 ff ff       	call   c0100403 <__panic>
    assert(alloc_page() == NULL);
c0105f5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105f64:	e8 dc 07 00 00       	call   c0106745 <alloc_pages>
c0105f69:	85 c0                	test   %eax,%eax
c0105f6b:	74 24                	je     c0105f91 <default_check+0x204>
c0105f6d:	c7 44 24 0c be a2 10 	movl   $0xc010a2be,0xc(%esp)
c0105f74:	c0 
c0105f75:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105f7c:	c0 
c0105f7d:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0105f84:	00 
c0105f85:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105f8c:	e8 72 a4 ff ff       	call   c0100403 <__panic>

    unsigned int nr_free_store = nr_free;
c0105f91:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c0105f96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0105f99:	c7 05 f4 40 12 c0 00 	movl   $0x0,0xc01240f4
c0105fa0:	00 00 00 

    free_pages(p0 + 2, 3);
c0105fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fa6:	83 c0 40             	add    $0x40,%eax
c0105fa9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0105fb0:	00 
c0105fb1:	89 04 24             	mov    %eax,(%esp)
c0105fb4:	e8 f7 07 00 00       	call   c01067b0 <free_pages>
    assert(alloc_pages(4) == NULL);
c0105fb9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0105fc0:	e8 80 07 00 00       	call   c0106745 <alloc_pages>
c0105fc5:	85 c0                	test   %eax,%eax
c0105fc7:	74 24                	je     c0105fed <default_check+0x260>
c0105fc9:	c7 44 24 0c 64 a3 10 	movl   $0xc010a364,0xc(%esp)
c0105fd0:	c0 
c0105fd1:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0105fd8:	c0 
c0105fd9:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0105fe0:	00 
c0105fe1:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0105fe8:	e8 16 a4 ff ff       	call   c0100403 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ff0:	83 c0 40             	add    $0x40,%eax
c0105ff3:	83 c0 04             	add    $0x4,%eax
c0105ff6:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0105ffd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106000:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106003:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0106006:	0f a3 10             	bt     %edx,(%eax)
c0106009:	19 c0                	sbb    %eax,%eax
c010600b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010600e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0106012:	0f 95 c0             	setne  %al
c0106015:	0f b6 c0             	movzbl %al,%eax
c0106018:	85 c0                	test   %eax,%eax
c010601a:	74 0e                	je     c010602a <default_check+0x29d>
c010601c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010601f:	83 c0 40             	add    $0x40,%eax
c0106022:	8b 40 08             	mov    0x8(%eax),%eax
c0106025:	83 f8 03             	cmp    $0x3,%eax
c0106028:	74 24                	je     c010604e <default_check+0x2c1>
c010602a:	c7 44 24 0c 7c a3 10 	movl   $0xc010a37c,0xc(%esp)
c0106031:	c0 
c0106032:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0106039:	c0 
c010603a:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0106041:	00 
c0106042:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0106049:	e8 b5 a3 ff ff       	call   c0100403 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010604e:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0106055:	e8 eb 06 00 00       	call   c0106745 <alloc_pages>
c010605a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010605d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106061:	75 24                	jne    c0106087 <default_check+0x2fa>
c0106063:	c7 44 24 0c a8 a3 10 	movl   $0xc010a3a8,0xc(%esp)
c010606a:	c0 
c010606b:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0106072:	c0 
c0106073:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010607a:	00 
c010607b:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0106082:	e8 7c a3 ff ff       	call   c0100403 <__panic>
    assert(alloc_page() == NULL);
c0106087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010608e:	e8 b2 06 00 00       	call   c0106745 <alloc_pages>
c0106093:	85 c0                	test   %eax,%eax
c0106095:	74 24                	je     c01060bb <default_check+0x32e>
c0106097:	c7 44 24 0c be a2 10 	movl   $0xc010a2be,0xc(%esp)
c010609e:	c0 
c010609f:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01060a6:	c0 
c01060a7:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01060ae:	00 
c01060af:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01060b6:	e8 48 a3 ff ff       	call   c0100403 <__panic>
    assert(p0 + 2 == p1);
c01060bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060be:	83 c0 40             	add    $0x40,%eax
c01060c1:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01060c4:	74 24                	je     c01060ea <default_check+0x35d>
c01060c6:	c7 44 24 0c c6 a3 10 	movl   $0xc010a3c6,0xc(%esp)
c01060cd:	c0 
c01060ce:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01060d5:	c0 
c01060d6:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01060dd:	00 
c01060de:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01060e5:	e8 19 a3 ff ff       	call   c0100403 <__panic>

    p2 = p0 + 1;
c01060ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060ed:	83 c0 20             	add    $0x20,%eax
c01060f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01060f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01060fa:	00 
c01060fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01060fe:	89 04 24             	mov    %eax,(%esp)
c0106101:	e8 aa 06 00 00       	call   c01067b0 <free_pages>
    free_pages(p1, 3);
c0106106:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010610d:	00 
c010610e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106111:	89 04 24             	mov    %eax,(%esp)
c0106114:	e8 97 06 00 00       	call   c01067b0 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0106119:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010611c:	83 c0 04             	add    $0x4,%eax
c010611f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0106126:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106129:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010612c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010612f:	0f a3 10             	bt     %edx,(%eax)
c0106132:	19 c0                	sbb    %eax,%eax
c0106134:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0106137:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010613b:	0f 95 c0             	setne  %al
c010613e:	0f b6 c0             	movzbl %al,%eax
c0106141:	85 c0                	test   %eax,%eax
c0106143:	74 0b                	je     c0106150 <default_check+0x3c3>
c0106145:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106148:	8b 40 08             	mov    0x8(%eax),%eax
c010614b:	83 f8 01             	cmp    $0x1,%eax
c010614e:	74 24                	je     c0106174 <default_check+0x3e7>
c0106150:	c7 44 24 0c d4 a3 10 	movl   $0xc010a3d4,0xc(%esp)
c0106157:	c0 
c0106158:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c010615f:	c0 
c0106160:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0106167:	00 
c0106168:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c010616f:	e8 8f a2 ff ff       	call   c0100403 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0106174:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106177:	83 c0 04             	add    $0x4,%eax
c010617a:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0106181:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106184:	8b 45 90             	mov    -0x70(%ebp),%eax
c0106187:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010618a:	0f a3 10             	bt     %edx,(%eax)
c010618d:	19 c0                	sbb    %eax,%eax
c010618f:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0106192:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0106196:	0f 95 c0             	setne  %al
c0106199:	0f b6 c0             	movzbl %al,%eax
c010619c:	85 c0                	test   %eax,%eax
c010619e:	74 0b                	je     c01061ab <default_check+0x41e>
c01061a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061a3:	8b 40 08             	mov    0x8(%eax),%eax
c01061a6:	83 f8 03             	cmp    $0x3,%eax
c01061a9:	74 24                	je     c01061cf <default_check+0x442>
c01061ab:	c7 44 24 0c fc a3 10 	movl   $0xc010a3fc,0xc(%esp)
c01061b2:	c0 
c01061b3:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01061ba:	c0 
c01061bb:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01061c2:	00 
c01061c3:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01061ca:	e8 34 a2 ff ff       	call   c0100403 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01061cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061d6:	e8 6a 05 00 00       	call   c0106745 <alloc_pages>
c01061db:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01061de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061e1:	83 e8 20             	sub    $0x20,%eax
c01061e4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01061e7:	74 24                	je     c010620d <default_check+0x480>
c01061e9:	c7 44 24 0c 22 a4 10 	movl   $0xc010a422,0xc(%esp)
c01061f0:	c0 
c01061f1:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01061f8:	c0 
c01061f9:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0106200:	00 
c0106201:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0106208:	e8 f6 a1 ff ff       	call   c0100403 <__panic>
    free_page(p0);
c010620d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106214:	00 
c0106215:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106218:	89 04 24             	mov    %eax,(%esp)
c010621b:	e8 90 05 00 00       	call   c01067b0 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0106220:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0106227:	e8 19 05 00 00       	call   c0106745 <alloc_pages>
c010622c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010622f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106232:	83 c0 20             	add    $0x20,%eax
c0106235:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106238:	74 24                	je     c010625e <default_check+0x4d1>
c010623a:	c7 44 24 0c 40 a4 10 	movl   $0xc010a440,0xc(%esp)
c0106241:	c0 
c0106242:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0106249:	c0 
c010624a:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0106251:	00 
c0106252:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0106259:	e8 a5 a1 ff ff       	call   c0100403 <__panic>

    free_pages(p0, 2);
c010625e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106265:	00 
c0106266:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106269:	89 04 24             	mov    %eax,(%esp)
c010626c:	e8 3f 05 00 00       	call   c01067b0 <free_pages>
    free_page(p2);
c0106271:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106278:	00 
c0106279:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010627c:	89 04 24             	mov    %eax,(%esp)
c010627f:	e8 2c 05 00 00       	call   c01067b0 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0106284:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010628b:	e8 b5 04 00 00       	call   c0106745 <alloc_pages>
c0106290:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106293:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106297:	75 24                	jne    c01062bd <default_check+0x530>
c0106299:	c7 44 24 0c 60 a4 10 	movl   $0xc010a460,0xc(%esp)
c01062a0:	c0 
c01062a1:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01062a8:	c0 
c01062a9:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c01062b0:	00 
c01062b1:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01062b8:	e8 46 a1 ff ff       	call   c0100403 <__panic>
    assert(alloc_page() == NULL);
c01062bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062c4:	e8 7c 04 00 00       	call   c0106745 <alloc_pages>
c01062c9:	85 c0                	test   %eax,%eax
c01062cb:	74 24                	je     c01062f1 <default_check+0x564>
c01062cd:	c7 44 24 0c be a2 10 	movl   $0xc010a2be,0xc(%esp)
c01062d4:	c0 
c01062d5:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01062dc:	c0 
c01062dd:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c01062e4:	00 
c01062e5:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01062ec:	e8 12 a1 ff ff       	call   c0100403 <__panic>

    assert(nr_free == 0);
c01062f1:	a1 f4 40 12 c0       	mov    0xc01240f4,%eax
c01062f6:	85 c0                	test   %eax,%eax
c01062f8:	74 24                	je     c010631e <default_check+0x591>
c01062fa:	c7 44 24 0c 11 a3 10 	movl   $0xc010a311,0xc(%esp)
c0106301:	c0 
c0106302:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c0106309:	c0 
c010630a:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0106311:	00 
c0106312:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0106319:	e8 e5 a0 ff ff       	call   c0100403 <__panic>
    nr_free = nr_free_store;
c010631e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106321:	a3 f4 40 12 c0       	mov    %eax,0xc01240f4

    free_list = free_list_store;
c0106326:	8b 45 80             	mov    -0x80(%ebp),%eax
c0106329:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010632c:	a3 ec 40 12 c0       	mov    %eax,0xc01240ec
c0106331:	89 15 f0 40 12 c0    	mov    %edx,0xc01240f0
    free_pages(p0, 5);
c0106337:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010633e:	00 
c010633f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106342:	89 04 24             	mov    %eax,(%esp)
c0106345:	e8 66 04 00 00       	call   c01067b0 <free_pages>

    le = &free_list;
c010634a:	c7 45 ec ec 40 12 c0 	movl   $0xc01240ec,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106351:	eb 1c                	jmp    c010636f <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c0106353:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106356:	83 e8 0c             	sub    $0xc,%eax
c0106359:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c010635c:	ff 4d f4             	decl   -0xc(%ebp)
c010635f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106362:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106365:	8b 40 08             	mov    0x8(%eax),%eax
c0106368:	29 c2                	sub    %eax,%edx
c010636a:	89 d0                	mov    %edx,%eax
c010636c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010636f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106372:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0106375:	8b 45 88             	mov    -0x78(%ebp),%eax
c0106378:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010637b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010637e:	81 7d ec ec 40 12 c0 	cmpl   $0xc01240ec,-0x14(%ebp)
c0106385:	75 cc                	jne    c0106353 <default_check+0x5c6>
    }
    assert(count == 0);
c0106387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010638b:	74 24                	je     c01063b1 <default_check+0x624>
c010638d:	c7 44 24 0c 7e a4 10 	movl   $0xc010a47e,0xc(%esp)
c0106394:	c0 
c0106395:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c010639c:	c0 
c010639d:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01063a4:	00 
c01063a5:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01063ac:	e8 52 a0 ff ff       	call   c0100403 <__panic>
    assert(total == 0);
c01063b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01063b5:	74 24                	je     c01063db <default_check+0x64e>
c01063b7:	c7 44 24 0c 89 a4 10 	movl   $0xc010a489,0xc(%esp)
c01063be:	c0 
c01063bf:	c7 44 24 08 36 a1 10 	movl   $0xc010a136,0x8(%esp)
c01063c6:	c0 
c01063c7:	c7 44 24 04 3c 01 00 	movl   $0x13c,0x4(%esp)
c01063ce:	00 
c01063cf:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c01063d6:	e8 28 a0 ff ff       	call   c0100403 <__panic>
}
c01063db:	90                   	nop
c01063dc:	c9                   	leave  
c01063dd:	c3                   	ret    

c01063de <page2ppn>:
page2ppn(struct Page *page) {
c01063de:	55                   	push   %ebp
c01063df:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01063e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01063e4:	8b 15 00 41 12 c0    	mov    0xc0124100,%edx
c01063ea:	29 d0                	sub    %edx,%eax
c01063ec:	c1 f8 05             	sar    $0x5,%eax
}
c01063ef:	5d                   	pop    %ebp
c01063f0:	c3                   	ret    

c01063f1 <page2pa>:
page2pa(struct Page *page) {
c01063f1:	55                   	push   %ebp
c01063f2:	89 e5                	mov    %esp,%ebp
c01063f4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01063f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01063fa:	89 04 24             	mov    %eax,(%esp)
c01063fd:	e8 dc ff ff ff       	call   c01063de <page2ppn>
c0106402:	c1 e0 0c             	shl    $0xc,%eax
}
c0106405:	c9                   	leave  
c0106406:	c3                   	ret    

c0106407 <pa2page>:
pa2page(uintptr_t pa) {
c0106407:	55                   	push   %ebp
c0106408:	89 e5                	mov    %esp,%ebp
c010640a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010640d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106410:	c1 e8 0c             	shr    $0xc,%eax
c0106413:	89 c2                	mov    %eax,%edx
c0106415:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c010641a:	39 c2                	cmp    %eax,%edx
c010641c:	72 1c                	jb     c010643a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010641e:	c7 44 24 08 c4 a4 10 	movl   $0xc010a4c4,0x8(%esp)
c0106425:	c0 
c0106426:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010642d:	00 
c010642e:	c7 04 24 e3 a4 10 c0 	movl   $0xc010a4e3,(%esp)
c0106435:	e8 c9 9f ff ff       	call   c0100403 <__panic>
    return &pages[PPN(pa)];
c010643a:	a1 00 41 12 c0       	mov    0xc0124100,%eax
c010643f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106442:	c1 ea 0c             	shr    $0xc,%edx
c0106445:	c1 e2 05             	shl    $0x5,%edx
c0106448:	01 d0                	add    %edx,%eax
}
c010644a:	c9                   	leave  
c010644b:	c3                   	ret    

c010644c <page2kva>:
page2kva(struct Page *page) {
c010644c:	55                   	push   %ebp
c010644d:	89 e5                	mov    %esp,%ebp
c010644f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0106452:	8b 45 08             	mov    0x8(%ebp),%eax
c0106455:	89 04 24             	mov    %eax,(%esp)
c0106458:	e8 94 ff ff ff       	call   c01063f1 <page2pa>
c010645d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106460:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106463:	c1 e8 0c             	shr    $0xc,%eax
c0106466:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106469:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c010646e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106471:	72 23                	jb     c0106496 <page2kva+0x4a>
c0106473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106476:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010647a:	c7 44 24 08 f4 a4 10 	movl   $0xc010a4f4,0x8(%esp)
c0106481:	c0 
c0106482:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0106489:	00 
c010648a:	c7 04 24 e3 a4 10 c0 	movl   $0xc010a4e3,(%esp)
c0106491:	e8 6d 9f ff ff       	call   c0100403 <__panic>
c0106496:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106499:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010649e:	c9                   	leave  
c010649f:	c3                   	ret    

c01064a0 <kva2page>:
kva2page(void *kva) {
c01064a0:	55                   	push   %ebp
c01064a1:	89 e5                	mov    %esp,%ebp
c01064a3:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01064a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01064a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01064ac:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01064b3:	77 23                	ja     c01064d8 <kva2page+0x38>
c01064b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01064b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01064bc:	c7 44 24 08 18 a5 10 	movl   $0xc010a518,0x8(%esp)
c01064c3:	c0 
c01064c4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01064cb:	00 
c01064cc:	c7 04 24 e3 a4 10 c0 	movl   $0xc010a4e3,(%esp)
c01064d3:	e8 2b 9f ff ff       	call   c0100403 <__panic>
c01064d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01064db:	05 00 00 00 40       	add    $0x40000000,%eax
c01064e0:	89 04 24             	mov    %eax,(%esp)
c01064e3:	e8 1f ff ff ff       	call   c0106407 <pa2page>
}
c01064e8:	c9                   	leave  
c01064e9:	c3                   	ret    

c01064ea <pte2page>:
pte2page(pte_t pte) {
c01064ea:	55                   	push   %ebp
c01064eb:	89 e5                	mov    %esp,%ebp
c01064ed:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01064f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01064f3:	83 e0 01             	and    $0x1,%eax
c01064f6:	85 c0                	test   %eax,%eax
c01064f8:	75 1c                	jne    c0106516 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01064fa:	c7 44 24 08 3c a5 10 	movl   $0xc010a53c,0x8(%esp)
c0106501:	c0 
c0106502:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106509:	00 
c010650a:	c7 04 24 e3 a4 10 c0 	movl   $0xc010a4e3,(%esp)
c0106511:	e8 ed 9e ff ff       	call   c0100403 <__panic>
    return pa2page(PTE_ADDR(pte));
c0106516:	8b 45 08             	mov    0x8(%ebp),%eax
c0106519:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010651e:	89 04 24             	mov    %eax,(%esp)
c0106521:	e8 e1 fe ff ff       	call   c0106407 <pa2page>
}
c0106526:	c9                   	leave  
c0106527:	c3                   	ret    

c0106528 <pde2page>:
pde2page(pde_t pde) {
c0106528:	55                   	push   %ebp
c0106529:	89 e5                	mov    %esp,%ebp
c010652b:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010652e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106531:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106536:	89 04 24             	mov    %eax,(%esp)
c0106539:	e8 c9 fe ff ff       	call   c0106407 <pa2page>
}
c010653e:	c9                   	leave  
c010653f:	c3                   	ret    

c0106540 <page_ref>:
page_ref(struct Page *page) {
c0106540:	55                   	push   %ebp
c0106541:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106543:	8b 45 08             	mov    0x8(%ebp),%eax
c0106546:	8b 00                	mov    (%eax),%eax
}
c0106548:	5d                   	pop    %ebp
c0106549:	c3                   	ret    

c010654a <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c010654a:	55                   	push   %ebp
c010654b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010654d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106550:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106553:	89 10                	mov    %edx,(%eax)
}
c0106555:	90                   	nop
c0106556:	5d                   	pop    %ebp
c0106557:	c3                   	ret    

c0106558 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106558:	55                   	push   %ebp
c0106559:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010655b:	8b 45 08             	mov    0x8(%ebp),%eax
c010655e:	8b 00                	mov    (%eax),%eax
c0106560:	8d 50 01             	lea    0x1(%eax),%edx
c0106563:	8b 45 08             	mov    0x8(%ebp),%eax
c0106566:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106568:	8b 45 08             	mov    0x8(%ebp),%eax
c010656b:	8b 00                	mov    (%eax),%eax
}
c010656d:	5d                   	pop    %ebp
c010656e:	c3                   	ret    

c010656f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010656f:	55                   	push   %ebp
c0106570:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106572:	8b 45 08             	mov    0x8(%ebp),%eax
c0106575:	8b 00                	mov    (%eax),%eax
c0106577:	8d 50 ff             	lea    -0x1(%eax),%edx
c010657a:	8b 45 08             	mov    0x8(%ebp),%eax
c010657d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010657f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106582:	8b 00                	mov    (%eax),%eax
}
c0106584:	5d                   	pop    %ebp
c0106585:	c3                   	ret    

c0106586 <__intr_save>:
__intr_save(void) {
c0106586:	55                   	push   %ebp
c0106587:	89 e5                	mov    %esp,%ebp
c0106589:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010658c:	9c                   	pushf  
c010658d:	58                   	pop    %eax
c010658e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106591:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106594:	25 00 02 00 00       	and    $0x200,%eax
c0106599:	85 c0                	test   %eax,%eax
c010659b:	74 0c                	je     c01065a9 <__intr_save+0x23>
        intr_disable();
c010659d:	e8 29 bb ff ff       	call   c01020cb <intr_disable>
        return 1;
c01065a2:	b8 01 00 00 00       	mov    $0x1,%eax
c01065a7:	eb 05                	jmp    c01065ae <__intr_save+0x28>
    return 0;
c01065a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01065ae:	c9                   	leave  
c01065af:	c3                   	ret    

c01065b0 <__intr_restore>:
__intr_restore(bool flag) {
c01065b0:	55                   	push   %ebp
c01065b1:	89 e5                	mov    %esp,%ebp
c01065b3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01065b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01065ba:	74 05                	je     c01065c1 <__intr_restore+0x11>
        intr_enable();
c01065bc:	e8 03 bb ff ff       	call   c01020c4 <intr_enable>
}
c01065c1:	90                   	nop
c01065c2:	c9                   	leave  
c01065c3:	c3                   	ret    

c01065c4 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01065c4:	55                   	push   %ebp
c01065c5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01065c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01065ca:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01065cd:	b8 23 00 00 00       	mov    $0x23,%eax
c01065d2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01065d4:	b8 23 00 00 00       	mov    $0x23,%eax
c01065d9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01065db:	b8 10 00 00 00       	mov    $0x10,%eax
c01065e0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01065e2:	b8 10 00 00 00       	mov    $0x10,%eax
c01065e7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01065e9:	b8 10 00 00 00       	mov    $0x10,%eax
c01065ee:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01065f0:	ea f7 65 10 c0 08 00 	ljmp   $0x8,$0xc01065f7
}
c01065f7:	90                   	nop
c01065f8:	5d                   	pop    %ebp
c01065f9:	c3                   	ret    

c01065fa <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01065fa:	55                   	push   %ebp
c01065fb:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01065fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106600:	a3 a4 3f 12 c0       	mov    %eax,0xc0123fa4
}
c0106605:	90                   	nop
c0106606:	5d                   	pop    %ebp
c0106607:	c3                   	ret    

c0106608 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106608:	55                   	push   %ebp
c0106609:	89 e5                	mov    %esp,%ebp
c010660b:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010660e:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c0106613:	89 04 24             	mov    %eax,(%esp)
c0106616:	e8 df ff ff ff       	call   c01065fa <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c010661b:	66 c7 05 a8 3f 12 c0 	movw   $0x10,0xc0123fa8
c0106622:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106624:	66 c7 05 48 0a 12 c0 	movw   $0x68,0xc0120a48
c010662b:	68 00 
c010662d:	b8 a0 3f 12 c0       	mov    $0xc0123fa0,%eax
c0106632:	0f b7 c0             	movzwl %ax,%eax
c0106635:	66 a3 4a 0a 12 c0    	mov    %ax,0xc0120a4a
c010663b:	b8 a0 3f 12 c0       	mov    $0xc0123fa0,%eax
c0106640:	c1 e8 10             	shr    $0x10,%eax
c0106643:	a2 4c 0a 12 c0       	mov    %al,0xc0120a4c
c0106648:	0f b6 05 4d 0a 12 c0 	movzbl 0xc0120a4d,%eax
c010664f:	24 f0                	and    $0xf0,%al
c0106651:	0c 09                	or     $0x9,%al
c0106653:	a2 4d 0a 12 c0       	mov    %al,0xc0120a4d
c0106658:	0f b6 05 4d 0a 12 c0 	movzbl 0xc0120a4d,%eax
c010665f:	24 ef                	and    $0xef,%al
c0106661:	a2 4d 0a 12 c0       	mov    %al,0xc0120a4d
c0106666:	0f b6 05 4d 0a 12 c0 	movzbl 0xc0120a4d,%eax
c010666d:	24 9f                	and    $0x9f,%al
c010666f:	a2 4d 0a 12 c0       	mov    %al,0xc0120a4d
c0106674:	0f b6 05 4d 0a 12 c0 	movzbl 0xc0120a4d,%eax
c010667b:	0c 80                	or     $0x80,%al
c010667d:	a2 4d 0a 12 c0       	mov    %al,0xc0120a4d
c0106682:	0f b6 05 4e 0a 12 c0 	movzbl 0xc0120a4e,%eax
c0106689:	24 f0                	and    $0xf0,%al
c010668b:	a2 4e 0a 12 c0       	mov    %al,0xc0120a4e
c0106690:	0f b6 05 4e 0a 12 c0 	movzbl 0xc0120a4e,%eax
c0106697:	24 ef                	and    $0xef,%al
c0106699:	a2 4e 0a 12 c0       	mov    %al,0xc0120a4e
c010669e:	0f b6 05 4e 0a 12 c0 	movzbl 0xc0120a4e,%eax
c01066a5:	24 df                	and    $0xdf,%al
c01066a7:	a2 4e 0a 12 c0       	mov    %al,0xc0120a4e
c01066ac:	0f b6 05 4e 0a 12 c0 	movzbl 0xc0120a4e,%eax
c01066b3:	0c 40                	or     $0x40,%al
c01066b5:	a2 4e 0a 12 c0       	mov    %al,0xc0120a4e
c01066ba:	0f b6 05 4e 0a 12 c0 	movzbl 0xc0120a4e,%eax
c01066c1:	24 7f                	and    $0x7f,%al
c01066c3:	a2 4e 0a 12 c0       	mov    %al,0xc0120a4e
c01066c8:	b8 a0 3f 12 c0       	mov    $0xc0123fa0,%eax
c01066cd:	c1 e8 18             	shr    $0x18,%eax
c01066d0:	a2 4f 0a 12 c0       	mov    %al,0xc0120a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c01066d5:	c7 04 24 50 0a 12 c0 	movl   $0xc0120a50,(%esp)
c01066dc:	e8 e3 fe ff ff       	call   c01065c4 <lgdt>
c01066e1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01066e7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01066eb:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01066ee:	90                   	nop
c01066ef:	c9                   	leave  
c01066f0:	c3                   	ret    

c01066f1 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01066f1:	55                   	push   %ebp
c01066f2:	89 e5                	mov    %esp,%ebp
c01066f4:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01066f7:	c7 05 f8 40 12 c0 a8 	movl   $0xc010a4a8,0xc01240f8
c01066fe:	a4 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106701:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c0106706:	8b 00                	mov    (%eax),%eax
c0106708:	89 44 24 04          	mov    %eax,0x4(%esp)
c010670c:	c7 04 24 68 a5 10 c0 	movl   $0xc010a568,(%esp)
c0106713:	e8 94 9b ff ff       	call   c01002ac <cprintf>
    pmm_manager->init();
c0106718:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c010671d:	8b 40 04             	mov    0x4(%eax),%eax
c0106720:	ff d0                	call   *%eax
}
c0106722:	90                   	nop
c0106723:	c9                   	leave  
c0106724:	c3                   	ret    

c0106725 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106725:	55                   	push   %ebp
c0106726:	89 e5                	mov    %esp,%ebp
c0106728:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c010672b:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c0106730:	8b 40 08             	mov    0x8(%eax),%eax
c0106733:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106736:	89 54 24 04          	mov    %edx,0x4(%esp)
c010673a:	8b 55 08             	mov    0x8(%ebp),%edx
c010673d:	89 14 24             	mov    %edx,(%esp)
c0106740:	ff d0                	call   *%eax
}
c0106742:	90                   	nop
c0106743:	c9                   	leave  
c0106744:	c3                   	ret    

c0106745 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106745:	55                   	push   %ebp
c0106746:	89 e5                	mov    %esp,%ebp
c0106748:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010674b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106752:	e8 2f fe ff ff       	call   c0106586 <__intr_save>
c0106757:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c010675a:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c010675f:	8b 40 0c             	mov    0xc(%eax),%eax
c0106762:	8b 55 08             	mov    0x8(%ebp),%edx
c0106765:	89 14 24             	mov    %edx,(%esp)
c0106768:	ff d0                	call   *%eax
c010676a:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c010676d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106770:	89 04 24             	mov    %eax,(%esp)
c0106773:	e8 38 fe ff ff       	call   c01065b0 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010677c:	75 2d                	jne    c01067ab <alloc_pages+0x66>
c010677e:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106782:	77 27                	ja     c01067ab <alloc_pages+0x66>
c0106784:	a1 68 3f 12 c0       	mov    0xc0123f68,%eax
c0106789:	85 c0                	test   %eax,%eax
c010678b:	74 1e                	je     c01067ab <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c010678d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106790:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0106795:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010679c:	00 
c010679d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01067a1:	89 04 24             	mov    %eax,(%esp)
c01067a4:	e8 cf da ff ff       	call   c0104278 <swap_out>
    {
c01067a9:	eb a7                	jmp    c0106752 <alloc_pages+0xd>
    }
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01067ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01067ae:	c9                   	leave  
c01067af:	c3                   	ret    

c01067b0 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01067b0:	55                   	push   %ebp
c01067b1:	89 e5                	mov    %esp,%ebp
c01067b3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01067b6:	e8 cb fd ff ff       	call   c0106586 <__intr_save>
c01067bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01067be:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c01067c3:	8b 40 10             	mov    0x10(%eax),%eax
c01067c6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01067c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01067cd:	8b 55 08             	mov    0x8(%ebp),%edx
c01067d0:	89 14 24             	mov    %edx,(%esp)
c01067d3:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01067d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067d8:	89 04 24             	mov    %eax,(%esp)
c01067db:	e8 d0 fd ff ff       	call   c01065b0 <__intr_restore>
}
c01067e0:	90                   	nop
c01067e1:	c9                   	leave  
c01067e2:	c3                   	ret    

c01067e3 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01067e3:	55                   	push   %ebp
c01067e4:	89 e5                	mov    %esp,%ebp
c01067e6:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01067e9:	e8 98 fd ff ff       	call   c0106586 <__intr_save>
c01067ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01067f1:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c01067f6:	8b 40 14             	mov    0x14(%eax),%eax
c01067f9:	ff d0                	call   *%eax
c01067fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01067fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106801:	89 04 24             	mov    %eax,(%esp)
c0106804:	e8 a7 fd ff ff       	call   c01065b0 <__intr_restore>
    return ret;
c0106809:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010680c:	c9                   	leave  
c010680d:	c3                   	ret    

c010680e <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010680e:	55                   	push   %ebp
c010680f:	89 e5                	mov    %esp,%ebp
c0106811:	57                   	push   %edi
c0106812:	56                   	push   %esi
c0106813:	53                   	push   %ebx
c0106814:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010681a:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0106821:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106828:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010682f:	c7 04 24 7f a5 10 c0 	movl   $0xc010a57f,(%esp)
c0106836:	e8 71 9a ff ff       	call   c01002ac <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010683b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106842:	e9 22 01 00 00       	jmp    c0106969 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106847:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010684a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010684d:	89 d0                	mov    %edx,%eax
c010684f:	c1 e0 02             	shl    $0x2,%eax
c0106852:	01 d0                	add    %edx,%eax
c0106854:	c1 e0 02             	shl    $0x2,%eax
c0106857:	01 c8                	add    %ecx,%eax
c0106859:	8b 50 08             	mov    0x8(%eax),%edx
c010685c:	8b 40 04             	mov    0x4(%eax),%eax
c010685f:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0106862:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0106865:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106868:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010686b:	89 d0                	mov    %edx,%eax
c010686d:	c1 e0 02             	shl    $0x2,%eax
c0106870:	01 d0                	add    %edx,%eax
c0106872:	c1 e0 02             	shl    $0x2,%eax
c0106875:	01 c8                	add    %ecx,%eax
c0106877:	8b 48 0c             	mov    0xc(%eax),%ecx
c010687a:	8b 58 10             	mov    0x10(%eax),%ebx
c010687d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106880:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0106883:	01 c8                	add    %ecx,%eax
c0106885:	11 da                	adc    %ebx,%edx
c0106887:	89 45 98             	mov    %eax,-0x68(%ebp)
c010688a:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010688d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106890:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106893:	89 d0                	mov    %edx,%eax
c0106895:	c1 e0 02             	shl    $0x2,%eax
c0106898:	01 d0                	add    %edx,%eax
c010689a:	c1 e0 02             	shl    $0x2,%eax
c010689d:	01 c8                	add    %ecx,%eax
c010689f:	83 c0 14             	add    $0x14,%eax
c01068a2:	8b 00                	mov    (%eax),%eax
c01068a4:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01068a7:	8b 45 98             	mov    -0x68(%ebp),%eax
c01068aa:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01068ad:	83 c0 ff             	add    $0xffffffff,%eax
c01068b0:	83 d2 ff             	adc    $0xffffffff,%edx
c01068b3:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c01068b9:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c01068bf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01068c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01068c5:	89 d0                	mov    %edx,%eax
c01068c7:	c1 e0 02             	shl    $0x2,%eax
c01068ca:	01 d0                	add    %edx,%eax
c01068cc:	c1 e0 02             	shl    $0x2,%eax
c01068cf:	01 c8                	add    %ecx,%eax
c01068d1:	8b 48 0c             	mov    0xc(%eax),%ecx
c01068d4:	8b 58 10             	mov    0x10(%eax),%ebx
c01068d7:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01068da:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c01068de:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c01068e4:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c01068ea:	89 44 24 14          	mov    %eax,0x14(%esp)
c01068ee:	89 54 24 18          	mov    %edx,0x18(%esp)
c01068f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01068f5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01068f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01068fc:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106900:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0106904:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0106908:	c7 04 24 8c a5 10 c0 	movl   $0xc010a58c,(%esp)
c010690f:	e8 98 99 ff ff       	call   c01002ac <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106914:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106917:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010691a:	89 d0                	mov    %edx,%eax
c010691c:	c1 e0 02             	shl    $0x2,%eax
c010691f:	01 d0                	add    %edx,%eax
c0106921:	c1 e0 02             	shl    $0x2,%eax
c0106924:	01 c8                	add    %ecx,%eax
c0106926:	83 c0 14             	add    $0x14,%eax
c0106929:	8b 00                	mov    (%eax),%eax
c010692b:	83 f8 01             	cmp    $0x1,%eax
c010692e:	75 36                	jne    c0106966 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0106930:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106933:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106936:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0106939:	77 2b                	ja     c0106966 <page_init+0x158>
c010693b:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c010693e:	72 05                	jb     c0106945 <page_init+0x137>
c0106940:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0106943:	73 21                	jae    c0106966 <page_init+0x158>
c0106945:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0106949:	77 1b                	ja     c0106966 <page_init+0x158>
c010694b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010694f:	72 09                	jb     c010695a <page_init+0x14c>
c0106951:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0106958:	77 0c                	ja     c0106966 <page_init+0x158>
                maxpa = end;
c010695a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010695d:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106960:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106963:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0106966:	ff 45 dc             	incl   -0x24(%ebp)
c0106969:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010696c:	8b 00                	mov    (%eax),%eax
c010696e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106971:	0f 8c d0 fe ff ff    	jl     c0106847 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106977:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010697b:	72 1d                	jb     c010699a <page_init+0x18c>
c010697d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106981:	77 09                	ja     c010698c <page_init+0x17e>
c0106983:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010698a:	76 0e                	jbe    c010699a <page_init+0x18c>
        maxpa = KMEMSIZE;
c010698c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106993:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010699a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010699d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01069a0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01069a4:	c1 ea 0c             	shr    $0xc,%edx
c01069a7:	89 c1                	mov    %eax,%ecx
c01069a9:	89 d3                	mov    %edx,%ebx
c01069ab:	89 c8                	mov    %ecx,%eax
c01069ad:	a3 80 3f 12 c0       	mov    %eax,0xc0123f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01069b2:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c01069b9:	b8 04 41 12 c0       	mov    $0xc0124104,%eax
c01069be:	8d 50 ff             	lea    -0x1(%eax),%edx
c01069c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01069c4:	01 d0                	add    %edx,%eax
c01069c6:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01069c9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01069cc:	ba 00 00 00 00       	mov    $0x0,%edx
c01069d1:	f7 75 c0             	divl   -0x40(%ebp)
c01069d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01069d7:	29 d0                	sub    %edx,%eax
c01069d9:	a3 00 41 12 c0       	mov    %eax,0xc0124100

    for (i = 0; i < npage; i ++) {
c01069de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01069e5:	eb 26                	jmp    c0106a0d <page_init+0x1ff>
        SetPageReserved(pages + i);
c01069e7:	a1 00 41 12 c0       	mov    0xc0124100,%eax
c01069ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01069ef:	c1 e2 05             	shl    $0x5,%edx
c01069f2:	01 d0                	add    %edx,%eax
c01069f4:	83 c0 04             	add    $0x4,%eax
c01069f7:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c01069fe:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106a01:	8b 45 90             	mov    -0x70(%ebp),%eax
c0106a04:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0106a07:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0106a0a:	ff 45 dc             	incl   -0x24(%ebp)
c0106a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a10:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0106a15:	39 c2                	cmp    %eax,%edx
c0106a17:	72 ce                	jb     c01069e7 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106a19:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0106a1e:	c1 e0 05             	shl    $0x5,%eax
c0106a21:	89 c2                	mov    %eax,%edx
c0106a23:	a1 00 41 12 c0       	mov    0xc0124100,%eax
c0106a28:	01 d0                	add    %edx,%eax
c0106a2a:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106a2d:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0106a34:	77 23                	ja     c0106a59 <page_init+0x24b>
c0106a36:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106a39:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a3d:	c7 44 24 08 18 a5 10 	movl   $0xc010a518,0x8(%esp)
c0106a44:	c0 
c0106a45:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0106a4c:	00 
c0106a4d:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106a54:	e8 aa 99 ff ff       	call   c0100403 <__panic>
c0106a59:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106a5c:	05 00 00 00 40       	add    $0x40000000,%eax
c0106a61:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0106a64:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106a6b:	e9 69 01 00 00       	jmp    c0106bd9 <page_init+0x3cb>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106a70:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a73:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a76:	89 d0                	mov    %edx,%eax
c0106a78:	c1 e0 02             	shl    $0x2,%eax
c0106a7b:	01 d0                	add    %edx,%eax
c0106a7d:	c1 e0 02             	shl    $0x2,%eax
c0106a80:	01 c8                	add    %ecx,%eax
c0106a82:	8b 50 08             	mov    0x8(%eax),%edx
c0106a85:	8b 40 04             	mov    0x4(%eax),%eax
c0106a88:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106a8b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106a8e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106a91:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106a94:	89 d0                	mov    %edx,%eax
c0106a96:	c1 e0 02             	shl    $0x2,%eax
c0106a99:	01 d0                	add    %edx,%eax
c0106a9b:	c1 e0 02             	shl    $0x2,%eax
c0106a9e:	01 c8                	add    %ecx,%eax
c0106aa0:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106aa3:	8b 58 10             	mov    0x10(%eax),%ebx
c0106aa6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106aa9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106aac:	01 c8                	add    %ecx,%eax
c0106aae:	11 da                	adc    %ebx,%edx
c0106ab0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106ab3:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0106ab6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106ab9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106abc:	89 d0                	mov    %edx,%eax
c0106abe:	c1 e0 02             	shl    $0x2,%eax
c0106ac1:	01 d0                	add    %edx,%eax
c0106ac3:	c1 e0 02             	shl    $0x2,%eax
c0106ac6:	01 c8                	add    %ecx,%eax
c0106ac8:	83 c0 14             	add    $0x14,%eax
c0106acb:	8b 00                	mov    (%eax),%eax
c0106acd:	83 f8 01             	cmp    $0x1,%eax
c0106ad0:	0f 85 00 01 00 00    	jne    c0106bd6 <page_init+0x3c8>
            if (begin < freemem) {
c0106ad6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106ad9:	ba 00 00 00 00       	mov    $0x0,%edx
c0106ade:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0106ae1:	77 17                	ja     c0106afa <page_init+0x2ec>
c0106ae3:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0106ae6:	72 05                	jb     c0106aed <page_init+0x2df>
c0106ae8:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0106aeb:	73 0d                	jae    c0106afa <page_init+0x2ec>
                begin = freemem;
c0106aed:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106af0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106af3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0106afa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106afe:	72 1d                	jb     c0106b1d <page_init+0x30f>
c0106b00:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106b04:	77 09                	ja     c0106b0f <page_init+0x301>
c0106b06:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0106b0d:	76 0e                	jbe    c0106b1d <page_init+0x30f>
                end = KMEMSIZE;
c0106b0f:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0106b16:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0106b1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106b23:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106b26:	0f 87 aa 00 00 00    	ja     c0106bd6 <page_init+0x3c8>
c0106b2c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106b2f:	72 09                	jb     c0106b3a <page_init+0x32c>
c0106b31:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106b34:	0f 83 9c 00 00 00    	jae    c0106bd6 <page_init+0x3c8>
                begin = ROUNDUP(begin, PGSIZE);
c0106b3a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0106b41:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106b44:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106b47:	01 d0                	add    %edx,%eax
c0106b49:	48                   	dec    %eax
c0106b4a:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0106b4d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106b50:	ba 00 00 00 00       	mov    $0x0,%edx
c0106b55:	f7 75 b0             	divl   -0x50(%ebp)
c0106b58:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106b5b:	29 d0                	sub    %edx,%eax
c0106b5d:	ba 00 00 00 00       	mov    $0x0,%edx
c0106b62:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106b65:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0106b68:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106b6b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106b6e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106b71:	ba 00 00 00 00       	mov    $0x0,%edx
c0106b76:	89 c3                	mov    %eax,%ebx
c0106b78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0106b7e:	89 de                	mov    %ebx,%esi
c0106b80:	89 d0                	mov    %edx,%eax
c0106b82:	83 e0 00             	and    $0x0,%eax
c0106b85:	89 c7                	mov    %eax,%edi
c0106b87:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0106b8a:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0106b8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106b93:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106b96:	77 3e                	ja     c0106bd6 <page_init+0x3c8>
c0106b98:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106b9b:	72 05                	jb     c0106ba2 <page_init+0x394>
c0106b9d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106ba0:	73 34                	jae    c0106bd6 <page_init+0x3c8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0106ba2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106ba5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0106ba8:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0106bab:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0106bae:	89 c1                	mov    %eax,%ecx
c0106bb0:	89 d3                	mov    %edx,%ebx
c0106bb2:	89 c8                	mov    %ecx,%eax
c0106bb4:	89 da                	mov    %ebx,%edx
c0106bb6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106bba:	c1 ea 0c             	shr    $0xc,%edx
c0106bbd:	89 c3                	mov    %eax,%ebx
c0106bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106bc2:	89 04 24             	mov    %eax,(%esp)
c0106bc5:	e8 3d f8 ff ff       	call   c0106407 <pa2page>
c0106bca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0106bce:	89 04 24             	mov    %eax,(%esp)
c0106bd1:	e8 4f fb ff ff       	call   c0106725 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0106bd6:	ff 45 dc             	incl   -0x24(%ebp)
c0106bd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106bdc:	8b 00                	mov    (%eax),%eax
c0106bde:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106be1:	0f 8c 89 fe ff ff    	jl     c0106a70 <page_init+0x262>
                }
            }
        }
    }
}
c0106be7:	90                   	nop
c0106be8:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0106bee:	5b                   	pop    %ebx
c0106bef:	5e                   	pop    %esi
c0106bf0:	5f                   	pop    %edi
c0106bf1:	5d                   	pop    %ebp
c0106bf2:	c3                   	ret    

c0106bf3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0106bf3:	55                   	push   %ebp
c0106bf4:	89 e5                	mov    %esp,%ebp
c0106bf6:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0106bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106bfc:	33 45 14             	xor    0x14(%ebp),%eax
c0106bff:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106c04:	85 c0                	test   %eax,%eax
c0106c06:	74 24                	je     c0106c2c <boot_map_segment+0x39>
c0106c08:	c7 44 24 0c ca a5 10 	movl   $0xc010a5ca,0xc(%esp)
c0106c0f:	c0 
c0106c10:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0106c17:	c0 
c0106c18:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0106c1f:	00 
c0106c20:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106c27:	e8 d7 97 ff ff       	call   c0100403 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0106c2c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0106c33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c36:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106c3b:	89 c2                	mov    %eax,%edx
c0106c3d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106c40:	01 c2                	add    %eax,%edx
c0106c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c45:	01 d0                	add    %edx,%eax
c0106c47:	48                   	dec    %eax
c0106c48:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c4e:	ba 00 00 00 00       	mov    $0x0,%edx
c0106c53:	f7 75 f0             	divl   -0x10(%ebp)
c0106c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c59:	29 d0                	sub    %edx,%eax
c0106c5b:	c1 e8 0c             	shr    $0xc,%eax
c0106c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0106c61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c64:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106c6f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0106c72:	8b 45 14             	mov    0x14(%ebp),%eax
c0106c75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106c80:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106c83:	eb 68                	jmp    c0106ced <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0106c85:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106c8c:	00 
c0106c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106c90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c97:	89 04 24             	mov    %eax,(%esp)
c0106c9a:	e8 81 01 00 00       	call   c0106e20 <get_pte>
c0106c9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0106ca2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106ca6:	75 24                	jne    c0106ccc <boot_map_segment+0xd9>
c0106ca8:	c7 44 24 0c f6 a5 10 	movl   $0xc010a5f6,0xc(%esp)
c0106caf:	c0 
c0106cb0:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0106cb7:	c0 
c0106cb8:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0106cbf:	00 
c0106cc0:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106cc7:	e8 37 97 ff ff       	call   c0100403 <__panic>
        *ptep = pa | PTE_P | perm;
c0106ccc:	8b 45 14             	mov    0x14(%ebp),%eax
c0106ccf:	0b 45 18             	or     0x18(%ebp),%eax
c0106cd2:	83 c8 01             	or     $0x1,%eax
c0106cd5:	89 c2                	mov    %eax,%edx
c0106cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cda:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0106cdc:	ff 4d f4             	decl   -0xc(%ebp)
c0106cdf:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0106ce6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0106ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106cf1:	75 92                	jne    c0106c85 <boot_map_segment+0x92>
    }
}
c0106cf3:	90                   	nop
c0106cf4:	c9                   	leave  
c0106cf5:	c3                   	ret    

c0106cf6 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0106cf6:	55                   	push   %ebp
c0106cf7:	89 e5                	mov    %esp,%ebp
c0106cf9:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0106cfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106d03:	e8 3d fa ff ff       	call   c0106745 <alloc_pages>
c0106d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0106d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d0f:	75 1c                	jne    c0106d2d <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0106d11:	c7 44 24 08 03 a6 10 	movl   $0xc010a603,0x8(%esp)
c0106d18:	c0 
c0106d19:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0106d20:	00 
c0106d21:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106d28:	e8 d6 96 ff ff       	call   c0100403 <__panic>
    }
    return page2kva(p);
c0106d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d30:	89 04 24             	mov    %eax,(%esp)
c0106d33:	e8 14 f7 ff ff       	call   c010644c <page2kva>
}
c0106d38:	c9                   	leave  
c0106d39:	c3                   	ret    

c0106d3a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0106d3a:	55                   	push   %ebp
c0106d3b:	89 e5                	mov    %esp,%ebp
c0106d3d:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    //一级页表的起始物理地址
    boot_cr3 = PADDR(boot_pgdir);
c0106d40:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0106d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106d48:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0106d4f:	77 23                	ja     c0106d74 <pmm_init+0x3a>
c0106d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d54:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106d58:	c7 44 24 08 18 a5 10 	movl   $0xc010a518,0x8(%esp)
c0106d5f:	c0 
c0106d60:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0106d67:	00 
c0106d68:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106d6f:	e8 8f 96 ff ff       	call   c0100403 <__panic>
c0106d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d77:	05 00 00 00 40       	add    $0x40000000,%eax
c0106d7c:	a3 fc 40 12 c0       	mov    %eax,0xc01240fc
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0106d81:	e8 6b f9 ff ff       	call   c01066f1 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0106d86:	e8 83 fa ff ff       	call   c010680e <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0106d8b:	e8 d7 04 00 00       	call   c0107267 <check_alloc_page>

    check_pgdir();
c0106d90:	e8 f1 04 00 00       	call   c0107286 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0106d95:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0106d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d9d:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0106da4:	77 23                	ja     c0106dc9 <pmm_init+0x8f>
c0106da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106da9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106dad:	c7 44 24 08 18 a5 10 	movl   $0xc010a518,0x8(%esp)
c0106db4:	c0 
c0106db5:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c0106dbc:	00 
c0106dbd:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106dc4:	e8 3a 96 ff ff       	call   c0100403 <__panic>
c0106dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dcc:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0106dd2:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0106dd7:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106ddc:	83 ca 03             	or     $0x3,%edx
c0106ddf:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0106de1:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0106de6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0106ded:	00 
c0106dee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106df5:	00 
c0106df6:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0106dfd:	38 
c0106dfe:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0106e05:	c0 
c0106e06:	89 04 24             	mov    %eax,(%esp)
c0106e09:	e8 e5 fd ff ff       	call   c0106bf3 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0106e0e:	e8 f5 f7 ff ff       	call   c0106608 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0106e13:	e8 0a 0b 00 00       	call   c0107922 <check_boot_pgdir>

    print_pgdir();
c0106e18:	e8 83 0f 00 00       	call   c0107da0 <print_pgdir>

}
c0106e1d:	90                   	nop
c0106e1e:	c9                   	leave  
c0106e1f:	c3                   	ret    

c0106e20 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0106e20:	55                   	push   %ebp
c0106e21:	89 e5                	mov    %esp,%ebp
c0106e23:	83 ec 38             	sub    $0x38,%esp
    }
    return NULL;          // (8) return page table entry
#endif
    //mycode
    //最后返回的是虚拟地址la对应的页表项地址
    pde_t *pdep = &pgdir[PDX(la)];
c0106e26:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e29:	c1 e8 16             	shr    $0x16,%eax
c0106e2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106e33:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e36:	01 d0                	add    %edx,%eax
c0106e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (!(*pdep & PTE_P)) {
c0106e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e3e:	8b 00                	mov    (%eax),%eax
c0106e40:	83 e0 01             	and    $0x1,%eax
c0106e43:	85 c0                	test   %eax,%eax
c0106e45:	0f 85 af 00 00 00    	jne    c0106efa <get_pte+0xda>
            struct Page *page;
            if (!create || (page = alloc_page()) == NULL) { 
c0106e4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106e4f:	74 15                	je     c0106e66 <get_pte+0x46>
c0106e51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106e58:	e8 e8 f8 ff ff       	call   c0106745 <alloc_pages>
c0106e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106e60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106e64:	75 0a                	jne    c0106e70 <get_pte+0x50>
                return NULL;
c0106e66:	b8 00 00 00 00       	mov    $0x0,%eax
c0106e6b:	e9 e7 00 00 00       	jmp    c0106f57 <get_pte+0x137>
        }
        set_page_ref(page, 1);
c0106e70:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106e77:	00 
c0106e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e7b:	89 04 24             	mov    %eax,(%esp)
c0106e7e:	e8 c7 f6 ff ff       	call   c010654a <set_page_ref>
        uintptr_t pa = page2pa(page);
c0106e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e86:	89 04 24             	mov    %eax,(%esp)
c0106e89:	e8 63 f5 ff ff       	call   c01063f1 <page2pa>
c0106e8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0106e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e94:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106e97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106e9a:	c1 e8 0c             	shr    $0xc,%eax
c0106e9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106ea0:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0106ea5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0106ea8:	72 23                	jb     c0106ecd <get_pte+0xad>
c0106eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ead:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106eb1:	c7 44 24 08 f4 a4 10 	movl   $0xc010a4f4,0x8(%esp)
c0106eb8:	c0 
c0106eb9:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c0106ec0:	00 
c0106ec1:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106ec8:	e8 36 95 ff ff       	call   c0100403 <__panic>
c0106ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ed0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106ed5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0106edc:	00 
c0106edd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106ee4:	00 
c0106ee5:	89 04 24             	mov    %eax,(%esp)
c0106ee8:	e8 27 16 00 00       	call   c0108514 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P; 
c0106eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ef0:	83 c8 07             	or     $0x7,%eax
c0106ef3:	89 c2                	mov    %eax,%edx
c0106ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ef8:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; 
c0106efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106efd:	8b 00                	mov    (%eax),%eax
c0106eff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106f04:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f0a:	c1 e8 0c             	shr    $0xc,%eax
c0106f0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106f10:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0106f15:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106f18:	72 23                	jb     c0106f3d <get_pte+0x11d>
c0106f1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f21:	c7 44 24 08 f4 a4 10 	movl   $0xc010a4f4,0x8(%esp)
c0106f28:	c0 
c0106f29:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c0106f30:	00 
c0106f31:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0106f38:	e8 c6 94 ff ff       	call   c0100403 <__panic>
c0106f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106f40:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106f45:	89 c2                	mov    %eax,%edx
c0106f47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f4a:	c1 e8 0c             	shr    $0xc,%eax
c0106f4d:	25 ff 03 00 00       	and    $0x3ff,%eax
c0106f52:	c1 e0 02             	shl    $0x2,%eax
c0106f55:	01 d0                	add    %edx,%eax
    //mycode
}
c0106f57:	c9                   	leave  
c0106f58:	c3                   	ret    

c0106f59 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0106f59:	55                   	push   %ebp
c0106f5a:	89 e5                	mov    %esp,%ebp
c0106f5c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0106f5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106f66:	00 
c0106f67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f71:	89 04 24             	mov    %eax,(%esp)
c0106f74:	e8 a7 fe ff ff       	call   c0106e20 <get_pte>
c0106f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0106f7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106f80:	74 08                	je     c0106f8a <get_page+0x31>
        *ptep_store = ptep;
c0106f82:	8b 45 10             	mov    0x10(%ebp),%eax
c0106f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106f88:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0106f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106f8e:	74 1b                	je     c0106fab <get_page+0x52>
c0106f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f93:	8b 00                	mov    (%eax),%eax
c0106f95:	83 e0 01             	and    $0x1,%eax
c0106f98:	85 c0                	test   %eax,%eax
c0106f9a:	74 0f                	je     c0106fab <get_page+0x52>
        return pte2page(*ptep);
c0106f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f9f:	8b 00                	mov    (%eax),%eax
c0106fa1:	89 04 24             	mov    %eax,(%esp)
c0106fa4:	e8 41 f5 ff ff       	call   c01064ea <pte2page>
c0106fa9:	eb 05                	jmp    c0106fb0 <get_page+0x57>
    }
    return NULL;
c0106fab:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fb0:	c9                   	leave  
c0106fb1:	c3                   	ret    

c0106fb2 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0106fb2:	55                   	push   %ebp
c0106fb3:	89 e5                	mov    %esp,%ebp
c0106fb5:	83 ec 28             	sub    $0x28,%esp
#endif
    //mycode
    pte_t *pt_addr;
    struct Page *p;
    uintptr_t *page_la; 
    if ((pgdir[(PDX(la))] & PTE_P) && (*ptep & PTE_P)) {
c0106fb8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fbb:	c1 e8 16             	shr    $0x16,%eax
c0106fbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106fc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fc8:	01 d0                	add    %edx,%eax
c0106fca:	8b 00                	mov    (%eax),%eax
c0106fcc:	83 e0 01             	and    $0x1,%eax
c0106fcf:	85 c0                	test   %eax,%eax
c0106fd1:	74 60                	je     c0107033 <page_remove_pte+0x81>
c0106fd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0106fd6:	8b 00                	mov    (%eax),%eax
c0106fd8:	83 e0 01             	and    $0x1,%eax
c0106fdb:	85 c0                	test   %eax,%eax
c0106fdd:	74 54                	je     c0107033 <page_remove_pte+0x81>
        p = pte2page(*ptep);   
c0106fdf:	8b 45 10             	mov    0x10(%ebp),%eax
c0106fe2:	8b 00                	mov    (%eax),%eax
c0106fe4:	89 04 24             	mov    %eax,(%esp)
c0106fe7:	e8 fe f4 ff ff       	call   c01064ea <pte2page>
c0106fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(p); 
c0106fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ff2:	89 04 24             	mov    %eax,(%esp)
c0106ff5:	e8 75 f5 ff ff       	call   c010656f <page_ref_dec>
        if (p->ref == 0) 
c0106ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ffd:	8b 00                	mov    (%eax),%eax
c0106fff:	85 c0                	test   %eax,%eax
c0107001:	75 13                	jne    c0107016 <page_remove_pte+0x64>
            free_page(p); 
c0107003:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010700a:	00 
c010700b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010700e:	89 04 24             	mov    %eax,(%esp)
c0107011:	e8 9a f7 ff ff       	call   c01067b0 <free_pages>
        *ptep = 0;
c0107016:	8b 45 10             	mov    0x10(%ebp),%eax
c0107019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c010701f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107022:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107026:	8b 45 08             	mov    0x8(%ebp),%eax
c0107029:	89 04 24             	mov    %eax,(%esp)
c010702c:	e8 0f 01 00 00       	call   c0107140 <tlb_invalidate>
c0107031:	eb 0c                	jmp    c010703f <page_remove_pte+0x8d>
    }
    else {
        cprintf("This pte is empty!\n"); 
c0107033:	c7 04 24 1c a6 10 c0 	movl   $0xc010a61c,(%esp)
c010703a:	e8 6d 92 ff ff       	call   c01002ac <cprintf>
    }
    //mycode
}
c010703f:	90                   	nop
c0107040:	c9                   	leave  
c0107041:	c3                   	ret    

c0107042 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0107042:	55                   	push   %ebp
c0107043:	89 e5                	mov    %esp,%ebp
c0107045:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0107048:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010704f:	00 
c0107050:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107053:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107057:	8b 45 08             	mov    0x8(%ebp),%eax
c010705a:	89 04 24             	mov    %eax,(%esp)
c010705d:	e8 be fd ff ff       	call   c0106e20 <get_pte>
c0107062:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0107065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107069:	74 19                	je     c0107084 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010706b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010706e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107072:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107075:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107079:	8b 45 08             	mov    0x8(%ebp),%eax
c010707c:	89 04 24             	mov    %eax,(%esp)
c010707f:	e8 2e ff ff ff       	call   c0106fb2 <page_remove_pte>
    }
}
c0107084:	90                   	nop
c0107085:	c9                   	leave  
c0107086:	c3                   	ret    

c0107087 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0107087:	55                   	push   %ebp
c0107088:	89 e5                	mov    %esp,%ebp
c010708a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010708d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107094:	00 
c0107095:	8b 45 10             	mov    0x10(%ebp),%eax
c0107098:	89 44 24 04          	mov    %eax,0x4(%esp)
c010709c:	8b 45 08             	mov    0x8(%ebp),%eax
c010709f:	89 04 24             	mov    %eax,(%esp)
c01070a2:	e8 79 fd ff ff       	call   c0106e20 <get_pte>
c01070a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01070aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070ae:	75 0a                	jne    c01070ba <page_insert+0x33>
        return -E_NO_MEM;
c01070b0:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01070b5:	e9 84 00 00 00       	jmp    c010713e <page_insert+0xb7>
    }
    page_ref_inc(page);
c01070ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070bd:	89 04 24             	mov    %eax,(%esp)
c01070c0:	e8 93 f4 ff ff       	call   c0106558 <page_ref_inc>
    if (*ptep & PTE_P) {
c01070c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070c8:	8b 00                	mov    (%eax),%eax
c01070ca:	83 e0 01             	and    $0x1,%eax
c01070cd:	85 c0                	test   %eax,%eax
c01070cf:	74 3e                	je     c010710f <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01070d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070d4:	8b 00                	mov    (%eax),%eax
c01070d6:	89 04 24             	mov    %eax,(%esp)
c01070d9:	e8 0c f4 ff ff       	call   c01064ea <pte2page>
c01070de:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01070e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070e7:	75 0d                	jne    c01070f6 <page_insert+0x6f>
            page_ref_dec(page);
c01070e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070ec:	89 04 24             	mov    %eax,(%esp)
c01070ef:	e8 7b f4 ff ff       	call   c010656f <page_ref_dec>
c01070f4:	eb 19                	jmp    c010710f <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01070f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01070fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0107100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107104:	8b 45 08             	mov    0x8(%ebp),%eax
c0107107:	89 04 24             	mov    %eax,(%esp)
c010710a:	e8 a3 fe ff ff       	call   c0106fb2 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010710f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107112:	89 04 24             	mov    %eax,(%esp)
c0107115:	e8 d7 f2 ff ff       	call   c01063f1 <page2pa>
c010711a:	0b 45 14             	or     0x14(%ebp),%eax
c010711d:	83 c8 01             	or     $0x1,%eax
c0107120:	89 c2                	mov    %eax,%edx
c0107122:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107125:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0107127:	8b 45 10             	mov    0x10(%ebp),%eax
c010712a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010712e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107131:	89 04 24             	mov    %eax,(%esp)
c0107134:	e8 07 00 00 00       	call   c0107140 <tlb_invalidate>
    return 0;
c0107139:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010713e:	c9                   	leave  
c010713f:	c3                   	ret    

c0107140 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0107140:	55                   	push   %ebp
c0107141:	89 e5                	mov    %esp,%ebp
c0107143:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0107146:	0f 20 d8             	mov    %cr3,%eax
c0107149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010714c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010714f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107152:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107155:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010715c:	77 23                	ja     c0107181 <tlb_invalidate+0x41>
c010715e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107161:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107165:	c7 44 24 08 18 a5 10 	movl   $0xc010a518,0x8(%esp)
c010716c:	c0 
c010716d:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0107174:	00 
c0107175:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010717c:	e8 82 92 ff ff       	call   c0100403 <__panic>
c0107181:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107184:	05 00 00 00 40       	add    $0x40000000,%eax
c0107189:	39 d0                	cmp    %edx,%eax
c010718b:	75 0c                	jne    c0107199 <tlb_invalidate+0x59>
        invlpg((void *)la);
c010718d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107190:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0107193:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107196:	0f 01 38             	invlpg (%eax)
    }
}
c0107199:	90                   	nop
c010719a:	c9                   	leave  
c010719b:	c3                   	ret    

c010719c <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010719c:	55                   	push   %ebp
c010719d:	89 e5                	mov    %esp,%ebp
c010719f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01071a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01071a9:	e8 97 f5 ff ff       	call   c0106745 <alloc_pages>
c01071ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01071b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071b5:	0f 84 a7 00 00 00    	je     c0107262 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01071bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01071be:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01071c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071c5:	89 44 24 08          	mov    %eax,0x8(%esp)
c01071c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01071d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01071d3:	89 04 24             	mov    %eax,(%esp)
c01071d6:	e8 ac fe ff ff       	call   c0107087 <page_insert>
c01071db:	85 c0                	test   %eax,%eax
c01071dd:	74 1a                	je     c01071f9 <pgdir_alloc_page+0x5d>
            free_page(page);
c01071df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01071e6:	00 
c01071e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071ea:	89 04 24             	mov    %eax,(%esp)
c01071ed:	e8 be f5 ff ff       	call   c01067b0 <free_pages>
            return NULL;
c01071f2:	b8 00 00 00 00       	mov    $0x0,%eax
c01071f7:	eb 6c                	jmp    c0107265 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01071f9:	a1 68 3f 12 c0       	mov    0xc0123f68,%eax
c01071fe:	85 c0                	test   %eax,%eax
c0107200:	74 60                	je     c0107262 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0107202:	a1 10 40 12 c0       	mov    0xc0124010,%eax
c0107207:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010720e:	00 
c010720f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107212:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107216:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107219:	89 54 24 04          	mov    %edx,0x4(%esp)
c010721d:	89 04 24             	mov    %eax,(%esp)
c0107220:	e8 07 d0 ff ff       	call   c010422c <swap_map_swappable>
            page->pra_vaddr=la;
c0107225:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107228:	8b 55 0c             	mov    0xc(%ebp),%edx
c010722b:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c010722e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107231:	89 04 24             	mov    %eax,(%esp)
c0107234:	e8 07 f3 ff ff       	call   c0106540 <page_ref>
c0107239:	83 f8 01             	cmp    $0x1,%eax
c010723c:	74 24                	je     c0107262 <pgdir_alloc_page+0xc6>
c010723e:	c7 44 24 0c 30 a6 10 	movl   $0xc010a630,0xc(%esp)
c0107245:	c0 
c0107246:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c010724d:	c0 
c010724e:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0107255:	00 
c0107256:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010725d:	e8 a1 91 ff ff       	call   c0100403 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0107262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107265:	c9                   	leave  
c0107266:	c3                   	ret    

c0107267 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107267:	55                   	push   %ebp
c0107268:	89 e5                	mov    %esp,%ebp
c010726a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010726d:	a1 f8 40 12 c0       	mov    0xc01240f8,%eax
c0107272:	8b 40 18             	mov    0x18(%eax),%eax
c0107275:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107277:	c7 04 24 44 a6 10 c0 	movl   $0xc010a644,(%esp)
c010727e:	e8 29 90 ff ff       	call   c01002ac <cprintf>
}
c0107283:	90                   	nop
c0107284:	c9                   	leave  
c0107285:	c3                   	ret    

c0107286 <check_pgdir>:

static void
check_pgdir(void) {
c0107286:	55                   	push   %ebp
c0107287:	89 e5                	mov    %esp,%ebp
c0107289:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010728c:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0107291:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0107296:	76 24                	jbe    c01072bc <check_pgdir+0x36>
c0107298:	c7 44 24 0c 63 a6 10 	movl   $0xc010a663,0xc(%esp)
c010729f:	c0 
c01072a0:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01072a7:	c0 
c01072a8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c01072af:	00 
c01072b0:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01072b7:	e8 47 91 ff ff       	call   c0100403 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01072bc:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01072c1:	85 c0                	test   %eax,%eax
c01072c3:	74 0e                	je     c01072d3 <check_pgdir+0x4d>
c01072c5:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01072ca:	25 ff 0f 00 00       	and    $0xfff,%eax
c01072cf:	85 c0                	test   %eax,%eax
c01072d1:	74 24                	je     c01072f7 <check_pgdir+0x71>
c01072d3:	c7 44 24 0c 80 a6 10 	movl   $0xc010a680,0xc(%esp)
c01072da:	c0 
c01072db:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01072e2:	c0 
c01072e3:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c01072ea:	00 
c01072eb:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01072f2:	e8 0c 91 ff ff       	call   c0100403 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01072f7:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01072fc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107303:	00 
c0107304:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010730b:	00 
c010730c:	89 04 24             	mov    %eax,(%esp)
c010730f:	e8 45 fc ff ff       	call   c0106f59 <get_page>
c0107314:	85 c0                	test   %eax,%eax
c0107316:	74 24                	je     c010733c <check_pgdir+0xb6>
c0107318:	c7 44 24 0c b8 a6 10 	movl   $0xc010a6b8,0xc(%esp)
c010731f:	c0 
c0107320:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107327:	c0 
c0107328:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c010732f:	00 
c0107330:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107337:	e8 c7 90 ff ff       	call   c0100403 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010733c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107343:	e8 fd f3 ff ff       	call   c0106745 <alloc_pages>
c0107348:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010734b:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107350:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107357:	00 
c0107358:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010735f:	00 
c0107360:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107363:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107367:	89 04 24             	mov    %eax,(%esp)
c010736a:	e8 18 fd ff ff       	call   c0107087 <page_insert>
c010736f:	85 c0                	test   %eax,%eax
c0107371:	74 24                	je     c0107397 <check_pgdir+0x111>
c0107373:	c7 44 24 0c e0 a6 10 	movl   $0xc010a6e0,0xc(%esp)
c010737a:	c0 
c010737b:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107382:	c0 
c0107383:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c010738a:	00 
c010738b:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107392:	e8 6c 90 ff ff       	call   c0100403 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107397:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c010739c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01073a3:	00 
c01073a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01073ab:	00 
c01073ac:	89 04 24             	mov    %eax,(%esp)
c01073af:	e8 6c fa ff ff       	call   c0106e20 <get_pte>
c01073b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01073bb:	75 24                	jne    c01073e1 <check_pgdir+0x15b>
c01073bd:	c7 44 24 0c 0c a7 10 	movl   $0xc010a70c,0xc(%esp)
c01073c4:	c0 
c01073c5:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01073cc:	c0 
c01073cd:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01073d4:	00 
c01073d5:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01073dc:	e8 22 90 ff ff       	call   c0100403 <__panic>
    assert(pte2page(*ptep) == p1);
c01073e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073e4:	8b 00                	mov    (%eax),%eax
c01073e6:	89 04 24             	mov    %eax,(%esp)
c01073e9:	e8 fc f0 ff ff       	call   c01064ea <pte2page>
c01073ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01073f1:	74 24                	je     c0107417 <check_pgdir+0x191>
c01073f3:	c7 44 24 0c 39 a7 10 	movl   $0xc010a739,0xc(%esp)
c01073fa:	c0 
c01073fb:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107402:	c0 
c0107403:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c010740a:	00 
c010740b:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107412:	e8 ec 8f ff ff       	call   c0100403 <__panic>
    assert(page_ref(p1) == 1);
c0107417:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010741a:	89 04 24             	mov    %eax,(%esp)
c010741d:	e8 1e f1 ff ff       	call   c0106540 <page_ref>
c0107422:	83 f8 01             	cmp    $0x1,%eax
c0107425:	74 24                	je     c010744b <check_pgdir+0x1c5>
c0107427:	c7 44 24 0c 4f a7 10 	movl   $0xc010a74f,0xc(%esp)
c010742e:	c0 
c010742f:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107436:	c0 
c0107437:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c010743e:	00 
c010743f:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107446:	e8 b8 8f ff ff       	call   c0100403 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010744b:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107450:	8b 00                	mov    (%eax),%eax
c0107452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107457:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010745a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010745d:	c1 e8 0c             	shr    $0xc,%eax
c0107460:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107463:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0107468:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010746b:	72 23                	jb     c0107490 <check_pgdir+0x20a>
c010746d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107470:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107474:	c7 44 24 08 f4 a4 10 	movl   $0xc010a4f4,0x8(%esp)
c010747b:	c0 
c010747c:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0107483:	00 
c0107484:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010748b:	e8 73 8f ff ff       	call   c0100403 <__panic>
c0107490:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107493:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107498:	83 c0 04             	add    $0x4,%eax
c010749b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010749e:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01074a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074aa:	00 
c01074ab:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01074b2:	00 
c01074b3:	89 04 24             	mov    %eax,(%esp)
c01074b6:	e8 65 f9 ff ff       	call   c0106e20 <get_pte>
c01074bb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01074be:	74 24                	je     c01074e4 <check_pgdir+0x25e>
c01074c0:	c7 44 24 0c 64 a7 10 	movl   $0xc010a764,0xc(%esp)
c01074c7:	c0 
c01074c8:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01074cf:	c0 
c01074d0:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01074d7:	00 
c01074d8:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01074df:	e8 1f 8f ff ff       	call   c0100403 <__panic>

    p2 = alloc_page();
c01074e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01074eb:	e8 55 f2 ff ff       	call   c0106745 <alloc_pages>
c01074f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01074f3:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01074f8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01074ff:	00 
c0107500:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107507:	00 
c0107508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010750b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010750f:	89 04 24             	mov    %eax,(%esp)
c0107512:	e8 70 fb ff ff       	call   c0107087 <page_insert>
c0107517:	85 c0                	test   %eax,%eax
c0107519:	74 24                	je     c010753f <check_pgdir+0x2b9>
c010751b:	c7 44 24 0c 8c a7 10 	movl   $0xc010a78c,0xc(%esp)
c0107522:	c0 
c0107523:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c010752a:	c0 
c010752b:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0107532:	00 
c0107533:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010753a:	e8 c4 8e ff ff       	call   c0100403 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010753f:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107544:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010754b:	00 
c010754c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107553:	00 
c0107554:	89 04 24             	mov    %eax,(%esp)
c0107557:	e8 c4 f8 ff ff       	call   c0106e20 <get_pte>
c010755c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010755f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107563:	75 24                	jne    c0107589 <check_pgdir+0x303>
c0107565:	c7 44 24 0c c4 a7 10 	movl   $0xc010a7c4,0xc(%esp)
c010756c:	c0 
c010756d:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107574:	c0 
c0107575:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c010757c:	00 
c010757d:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107584:	e8 7a 8e ff ff       	call   c0100403 <__panic>
    assert(*ptep & PTE_U);
c0107589:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010758c:	8b 00                	mov    (%eax),%eax
c010758e:	83 e0 04             	and    $0x4,%eax
c0107591:	85 c0                	test   %eax,%eax
c0107593:	75 24                	jne    c01075b9 <check_pgdir+0x333>
c0107595:	c7 44 24 0c f4 a7 10 	movl   $0xc010a7f4,0xc(%esp)
c010759c:	c0 
c010759d:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01075a4:	c0 
c01075a5:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c01075ac:	00 
c01075ad:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01075b4:	e8 4a 8e ff ff       	call   c0100403 <__panic>
    assert(*ptep & PTE_W);
c01075b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075bc:	8b 00                	mov    (%eax),%eax
c01075be:	83 e0 02             	and    $0x2,%eax
c01075c1:	85 c0                	test   %eax,%eax
c01075c3:	75 24                	jne    c01075e9 <check_pgdir+0x363>
c01075c5:	c7 44 24 0c 02 a8 10 	movl   $0xc010a802,0xc(%esp)
c01075cc:	c0 
c01075cd:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01075d4:	c0 
c01075d5:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c01075dc:	00 
c01075dd:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01075e4:	e8 1a 8e ff ff       	call   c0100403 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01075e9:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01075ee:	8b 00                	mov    (%eax),%eax
c01075f0:	83 e0 04             	and    $0x4,%eax
c01075f3:	85 c0                	test   %eax,%eax
c01075f5:	75 24                	jne    c010761b <check_pgdir+0x395>
c01075f7:	c7 44 24 0c 10 a8 10 	movl   $0xc010a810,0xc(%esp)
c01075fe:	c0 
c01075ff:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107606:	c0 
c0107607:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c010760e:	00 
c010760f:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107616:	e8 e8 8d ff ff       	call   c0100403 <__panic>
    assert(page_ref(p2) == 1);
c010761b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010761e:	89 04 24             	mov    %eax,(%esp)
c0107621:	e8 1a ef ff ff       	call   c0106540 <page_ref>
c0107626:	83 f8 01             	cmp    $0x1,%eax
c0107629:	74 24                	je     c010764f <check_pgdir+0x3c9>
c010762b:	c7 44 24 0c 26 a8 10 	movl   $0xc010a826,0xc(%esp)
c0107632:	c0 
c0107633:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c010763a:	c0 
c010763b:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0107642:	00 
c0107643:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010764a:	e8 b4 8d ff ff       	call   c0100403 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010764f:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107654:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010765b:	00 
c010765c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107663:	00 
c0107664:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107667:	89 54 24 04          	mov    %edx,0x4(%esp)
c010766b:	89 04 24             	mov    %eax,(%esp)
c010766e:	e8 14 fa ff ff       	call   c0107087 <page_insert>
c0107673:	85 c0                	test   %eax,%eax
c0107675:	74 24                	je     c010769b <check_pgdir+0x415>
c0107677:	c7 44 24 0c 38 a8 10 	movl   $0xc010a838,0xc(%esp)
c010767e:	c0 
c010767f:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107686:	c0 
c0107687:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010768e:	00 
c010768f:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107696:	e8 68 8d ff ff       	call   c0100403 <__panic>
    assert(page_ref(p1) == 2);
c010769b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010769e:	89 04 24             	mov    %eax,(%esp)
c01076a1:	e8 9a ee ff ff       	call   c0106540 <page_ref>
c01076a6:	83 f8 02             	cmp    $0x2,%eax
c01076a9:	74 24                	je     c01076cf <check_pgdir+0x449>
c01076ab:	c7 44 24 0c 64 a8 10 	movl   $0xc010a864,0xc(%esp)
c01076b2:	c0 
c01076b3:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01076ba:	c0 
c01076bb:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c01076c2:	00 
c01076c3:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01076ca:	e8 34 8d ff ff       	call   c0100403 <__panic>
    assert(page_ref(p2) == 0);
c01076cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01076d2:	89 04 24             	mov    %eax,(%esp)
c01076d5:	e8 66 ee ff ff       	call   c0106540 <page_ref>
c01076da:	85 c0                	test   %eax,%eax
c01076dc:	74 24                	je     c0107702 <check_pgdir+0x47c>
c01076de:	c7 44 24 0c 76 a8 10 	movl   $0xc010a876,0xc(%esp)
c01076e5:	c0 
c01076e6:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01076ed:	c0 
c01076ee:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c01076f5:	00 
c01076f6:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01076fd:	e8 01 8d ff ff       	call   c0100403 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107702:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107707:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010770e:	00 
c010770f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107716:	00 
c0107717:	89 04 24             	mov    %eax,(%esp)
c010771a:	e8 01 f7 ff ff       	call   c0106e20 <get_pte>
c010771f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107722:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107726:	75 24                	jne    c010774c <check_pgdir+0x4c6>
c0107728:	c7 44 24 0c c4 a7 10 	movl   $0xc010a7c4,0xc(%esp)
c010772f:	c0 
c0107730:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107737:	c0 
c0107738:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c010773f:	00 
c0107740:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107747:	e8 b7 8c ff ff       	call   c0100403 <__panic>
    assert(pte2page(*ptep) == p1);
c010774c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010774f:	8b 00                	mov    (%eax),%eax
c0107751:	89 04 24             	mov    %eax,(%esp)
c0107754:	e8 91 ed ff ff       	call   c01064ea <pte2page>
c0107759:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010775c:	74 24                	je     c0107782 <check_pgdir+0x4fc>
c010775e:	c7 44 24 0c 39 a7 10 	movl   $0xc010a739,0xc(%esp)
c0107765:	c0 
c0107766:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c010776d:	c0 
c010776e:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0107775:	00 
c0107776:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010777d:	e8 81 8c ff ff       	call   c0100403 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107782:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107785:	8b 00                	mov    (%eax),%eax
c0107787:	83 e0 04             	and    $0x4,%eax
c010778a:	85 c0                	test   %eax,%eax
c010778c:	74 24                	je     c01077b2 <check_pgdir+0x52c>
c010778e:	c7 44 24 0c 88 a8 10 	movl   $0xc010a888,0xc(%esp)
c0107795:	c0 
c0107796:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c010779d:	c0 
c010779e:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01077a5:	00 
c01077a6:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01077ad:	e8 51 8c ff ff       	call   c0100403 <__panic>

    page_remove(boot_pgdir, 0x0);
c01077b2:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01077b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01077be:	00 
c01077bf:	89 04 24             	mov    %eax,(%esp)
c01077c2:	e8 7b f8 ff ff       	call   c0107042 <page_remove>
    assert(page_ref(p1) == 1);
c01077c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077ca:	89 04 24             	mov    %eax,(%esp)
c01077cd:	e8 6e ed ff ff       	call   c0106540 <page_ref>
c01077d2:	83 f8 01             	cmp    $0x1,%eax
c01077d5:	74 24                	je     c01077fb <check_pgdir+0x575>
c01077d7:	c7 44 24 0c 4f a7 10 	movl   $0xc010a74f,0xc(%esp)
c01077de:	c0 
c01077df:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01077e6:	c0 
c01077e7:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01077ee:	00 
c01077ef:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01077f6:	e8 08 8c ff ff       	call   c0100403 <__panic>
    assert(page_ref(p2) == 0);
c01077fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077fe:	89 04 24             	mov    %eax,(%esp)
c0107801:	e8 3a ed ff ff       	call   c0106540 <page_ref>
c0107806:	85 c0                	test   %eax,%eax
c0107808:	74 24                	je     c010782e <check_pgdir+0x5a8>
c010780a:	c7 44 24 0c 76 a8 10 	movl   $0xc010a876,0xc(%esp)
c0107811:	c0 
c0107812:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107819:	c0 
c010781a:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0107821:	00 
c0107822:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107829:	e8 d5 8b ff ff       	call   c0100403 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010782e:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107833:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010783a:	00 
c010783b:	89 04 24             	mov    %eax,(%esp)
c010783e:	e8 ff f7 ff ff       	call   c0107042 <page_remove>
    assert(page_ref(p1) == 0);
c0107843:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107846:	89 04 24             	mov    %eax,(%esp)
c0107849:	e8 f2 ec ff ff       	call   c0106540 <page_ref>
c010784e:	85 c0                	test   %eax,%eax
c0107850:	74 24                	je     c0107876 <check_pgdir+0x5f0>
c0107852:	c7 44 24 0c 9d a8 10 	movl   $0xc010a89d,0xc(%esp)
c0107859:	c0 
c010785a:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107861:	c0 
c0107862:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0107869:	00 
c010786a:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107871:	e8 8d 8b ff ff       	call   c0100403 <__panic>
    assert(page_ref(p2) == 0);
c0107876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107879:	89 04 24             	mov    %eax,(%esp)
c010787c:	e8 bf ec ff ff       	call   c0106540 <page_ref>
c0107881:	85 c0                	test   %eax,%eax
c0107883:	74 24                	je     c01078a9 <check_pgdir+0x623>
c0107885:	c7 44 24 0c 76 a8 10 	movl   $0xc010a876,0xc(%esp)
c010788c:	c0 
c010788d:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107894:	c0 
c0107895:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c010789c:	00 
c010789d:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01078a4:	e8 5a 8b ff ff       	call   c0100403 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01078a9:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01078ae:	8b 00                	mov    (%eax),%eax
c01078b0:	89 04 24             	mov    %eax,(%esp)
c01078b3:	e8 70 ec ff ff       	call   c0106528 <pde2page>
c01078b8:	89 04 24             	mov    %eax,(%esp)
c01078bb:	e8 80 ec ff ff       	call   c0106540 <page_ref>
c01078c0:	83 f8 01             	cmp    $0x1,%eax
c01078c3:	74 24                	je     c01078e9 <check_pgdir+0x663>
c01078c5:	c7 44 24 0c b0 a8 10 	movl   $0xc010a8b0,0xc(%esp)
c01078cc:	c0 
c01078cd:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01078d4:	c0 
c01078d5:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01078dc:	00 
c01078dd:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01078e4:	e8 1a 8b ff ff       	call   c0100403 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01078e9:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c01078ee:	8b 00                	mov    (%eax),%eax
c01078f0:	89 04 24             	mov    %eax,(%esp)
c01078f3:	e8 30 ec ff ff       	call   c0106528 <pde2page>
c01078f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01078ff:	00 
c0107900:	89 04 24             	mov    %eax,(%esp)
c0107903:	e8 a8 ee ff ff       	call   c01067b0 <free_pages>
    boot_pgdir[0] = 0;
c0107908:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c010790d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107913:	c7 04 24 d7 a8 10 c0 	movl   $0xc010a8d7,(%esp)
c010791a:	e8 8d 89 ff ff       	call   c01002ac <cprintf>
}
c010791f:	90                   	nop
c0107920:	c9                   	leave  
c0107921:	c3                   	ret    

c0107922 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107922:	55                   	push   %ebp
c0107923:	89 e5                	mov    %esp,%ebp
c0107925:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107928:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010792f:	e9 ca 00 00 00       	jmp    c01079fe <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107937:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010793a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010793d:	c1 e8 0c             	shr    $0xc,%eax
c0107940:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107943:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0107948:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010794b:	72 23                	jb     c0107970 <check_boot_pgdir+0x4e>
c010794d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107950:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107954:	c7 44 24 08 f4 a4 10 	movl   $0xc010a4f4,0x8(%esp)
c010795b:	c0 
c010795c:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0107963:	00 
c0107964:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010796b:	e8 93 8a ff ff       	call   c0100403 <__panic>
c0107970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107973:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107978:	89 c2                	mov    %eax,%edx
c010797a:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c010797f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107986:	00 
c0107987:	89 54 24 04          	mov    %edx,0x4(%esp)
c010798b:	89 04 24             	mov    %eax,(%esp)
c010798e:	e8 8d f4 ff ff       	call   c0106e20 <get_pte>
c0107993:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107996:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010799a:	75 24                	jne    c01079c0 <check_boot_pgdir+0x9e>
c010799c:	c7 44 24 0c f4 a8 10 	movl   $0xc010a8f4,0xc(%esp)
c01079a3:	c0 
c01079a4:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01079ab:	c0 
c01079ac:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c01079b3:	00 
c01079b4:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01079bb:	e8 43 8a ff ff       	call   c0100403 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01079c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079c3:	8b 00                	mov    (%eax),%eax
c01079c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01079ca:	89 c2                	mov    %eax,%edx
c01079cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079cf:	39 c2                	cmp    %eax,%edx
c01079d1:	74 24                	je     c01079f7 <check_boot_pgdir+0xd5>
c01079d3:	c7 44 24 0c 31 a9 10 	movl   $0xc010a931,0xc(%esp)
c01079da:	c0 
c01079db:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c01079e2:	c0 
c01079e3:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c01079ea:	00 
c01079eb:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c01079f2:	e8 0c 8a ff ff       	call   c0100403 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01079f7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01079fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a01:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0107a06:	39 c2                	cmp    %eax,%edx
c0107a08:	0f 82 26 ff ff ff    	jb     c0107934 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0107a0e:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107a13:	05 ac 0f 00 00       	add    $0xfac,%eax
c0107a18:	8b 00                	mov    (%eax),%eax
c0107a1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107a1f:	89 c2                	mov    %eax,%edx
c0107a21:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107a29:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107a30:	77 23                	ja     c0107a55 <check_boot_pgdir+0x133>
c0107a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a35:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107a39:	c7 44 24 08 18 a5 10 	movl   $0xc010a518,0x8(%esp)
c0107a40:	c0 
c0107a41:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0107a48:	00 
c0107a49:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107a50:	e8 ae 89 ff ff       	call   c0100403 <__panic>
c0107a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a58:	05 00 00 00 40       	add    $0x40000000,%eax
c0107a5d:	39 d0                	cmp    %edx,%eax
c0107a5f:	74 24                	je     c0107a85 <check_boot_pgdir+0x163>
c0107a61:	c7 44 24 0c 48 a9 10 	movl   $0xc010a948,0xc(%esp)
c0107a68:	c0 
c0107a69:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107a70:	c0 
c0107a71:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0107a78:	00 
c0107a79:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107a80:	e8 7e 89 ff ff       	call   c0100403 <__panic>

    assert(boot_pgdir[0] == 0);
c0107a85:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107a8a:	8b 00                	mov    (%eax),%eax
c0107a8c:	85 c0                	test   %eax,%eax
c0107a8e:	74 24                	je     c0107ab4 <check_boot_pgdir+0x192>
c0107a90:	c7 44 24 0c 7c a9 10 	movl   $0xc010a97c,0xc(%esp)
c0107a97:	c0 
c0107a98:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107a9f:	c0 
c0107aa0:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c0107aa7:	00 
c0107aa8:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107aaf:	e8 4f 89 ff ff       	call   c0100403 <__panic>

    struct Page *p;
    p = alloc_page();
c0107ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107abb:	e8 85 ec ff ff       	call   c0106745 <alloc_pages>
c0107ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0107ac3:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107ac8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0107acf:	00 
c0107ad0:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0107ad7:	00 
c0107ad8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107adb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107adf:	89 04 24             	mov    %eax,(%esp)
c0107ae2:	e8 a0 f5 ff ff       	call   c0107087 <page_insert>
c0107ae7:	85 c0                	test   %eax,%eax
c0107ae9:	74 24                	je     c0107b0f <check_boot_pgdir+0x1ed>
c0107aeb:	c7 44 24 0c 90 a9 10 	movl   $0xc010a990,0xc(%esp)
c0107af2:	c0 
c0107af3:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107afa:	c0 
c0107afb:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0107b02:	00 
c0107b03:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107b0a:	e8 f4 88 ff ff       	call   c0100403 <__panic>
    assert(page_ref(p) == 1);
c0107b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b12:	89 04 24             	mov    %eax,(%esp)
c0107b15:	e8 26 ea ff ff       	call   c0106540 <page_ref>
c0107b1a:	83 f8 01             	cmp    $0x1,%eax
c0107b1d:	74 24                	je     c0107b43 <check_boot_pgdir+0x221>
c0107b1f:	c7 44 24 0c be a9 10 	movl   $0xc010a9be,0xc(%esp)
c0107b26:	c0 
c0107b27:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107b2e:	c0 
c0107b2f:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c0107b36:	00 
c0107b37:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107b3e:	e8 c0 88 ff ff       	call   c0100403 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0107b43:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107b48:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0107b4f:	00 
c0107b50:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0107b57:	00 
c0107b58:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107b5b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107b5f:	89 04 24             	mov    %eax,(%esp)
c0107b62:	e8 20 f5 ff ff       	call   c0107087 <page_insert>
c0107b67:	85 c0                	test   %eax,%eax
c0107b69:	74 24                	je     c0107b8f <check_boot_pgdir+0x26d>
c0107b6b:	c7 44 24 0c d0 a9 10 	movl   $0xc010a9d0,0xc(%esp)
c0107b72:	c0 
c0107b73:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107b7a:	c0 
c0107b7b:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0107b82:	00 
c0107b83:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107b8a:	e8 74 88 ff ff       	call   c0100403 <__panic>
    assert(page_ref(p) == 2);
c0107b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b92:	89 04 24             	mov    %eax,(%esp)
c0107b95:	e8 a6 e9 ff ff       	call   c0106540 <page_ref>
c0107b9a:	83 f8 02             	cmp    $0x2,%eax
c0107b9d:	74 24                	je     c0107bc3 <check_boot_pgdir+0x2a1>
c0107b9f:	c7 44 24 0c 07 aa 10 	movl   $0xc010aa07,0xc(%esp)
c0107ba6:	c0 
c0107ba7:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107bae:	c0 
c0107baf:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0107bb6:	00 
c0107bb7:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107bbe:	e8 40 88 ff ff       	call   c0100403 <__panic>

    const char *str = "ucore: Hello world!!";
c0107bc3:	c7 45 e8 18 aa 10 c0 	movl   $0xc010aa18,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0107bca:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107bd1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0107bd8:	e8 6d 06 00 00       	call   c010824a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0107bdd:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0107be4:	00 
c0107be5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0107bec:	e8 d0 06 00 00       	call   c01082c1 <strcmp>
c0107bf1:	85 c0                	test   %eax,%eax
c0107bf3:	74 24                	je     c0107c19 <check_boot_pgdir+0x2f7>
c0107bf5:	c7 44 24 0c 30 aa 10 	movl   $0xc010aa30,0xc(%esp)
c0107bfc:	c0 
c0107bfd:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107c04:	c0 
c0107c05:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c0107c0c:	00 
c0107c0d:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107c14:	e8 ea 87 ff ff       	call   c0100403 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0107c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c1c:	89 04 24             	mov    %eax,(%esp)
c0107c1f:	e8 28 e8 ff ff       	call   c010644c <page2kva>
c0107c24:	05 00 01 00 00       	add    $0x100,%eax
c0107c29:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0107c2c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0107c33:	e8 bc 05 00 00       	call   c01081f4 <strlen>
c0107c38:	85 c0                	test   %eax,%eax
c0107c3a:	74 24                	je     c0107c60 <check_boot_pgdir+0x33e>
c0107c3c:	c7 44 24 0c 68 aa 10 	movl   $0xc010aa68,0xc(%esp)
c0107c43:	c0 
c0107c44:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107c4b:	c0 
c0107c4c:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0107c53:	00 
c0107c54:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107c5b:	e8 a3 87 ff ff       	call   c0100403 <__panic>

    free_page(p);
c0107c60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107c67:	00 
c0107c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c6b:	89 04 24             	mov    %eax,(%esp)
c0107c6e:	e8 3d eb ff ff       	call   c01067b0 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0107c73:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107c78:	8b 00                	mov    (%eax),%eax
c0107c7a:	89 04 24             	mov    %eax,(%esp)
c0107c7d:	e8 a6 e8 ff ff       	call   c0106528 <pde2page>
c0107c82:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107c89:	00 
c0107c8a:	89 04 24             	mov    %eax,(%esp)
c0107c8d:	e8 1e eb ff ff       	call   c01067b0 <free_pages>
    boot_pgdir[0] = 0;
c0107c92:	a1 00 0a 12 c0       	mov    0xc0120a00,%eax
c0107c97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0107c9d:	c7 04 24 8c aa 10 c0 	movl   $0xc010aa8c,(%esp)
c0107ca4:	e8 03 86 ff ff       	call   c01002ac <cprintf>
}
c0107ca9:	90                   	nop
c0107caa:	c9                   	leave  
c0107cab:	c3                   	ret    

c0107cac <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0107cac:	55                   	push   %ebp
c0107cad:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0107caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cb2:	83 e0 04             	and    $0x4,%eax
c0107cb5:	85 c0                	test   %eax,%eax
c0107cb7:	74 04                	je     c0107cbd <perm2str+0x11>
c0107cb9:	b0 75                	mov    $0x75,%al
c0107cbb:	eb 02                	jmp    c0107cbf <perm2str+0x13>
c0107cbd:	b0 2d                	mov    $0x2d,%al
c0107cbf:	a2 08 40 12 c0       	mov    %al,0xc0124008
    str[1] = 'r';
c0107cc4:	c6 05 09 40 12 c0 72 	movb   $0x72,0xc0124009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0107ccb:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cce:	83 e0 02             	and    $0x2,%eax
c0107cd1:	85 c0                	test   %eax,%eax
c0107cd3:	74 04                	je     c0107cd9 <perm2str+0x2d>
c0107cd5:	b0 77                	mov    $0x77,%al
c0107cd7:	eb 02                	jmp    c0107cdb <perm2str+0x2f>
c0107cd9:	b0 2d                	mov    $0x2d,%al
c0107cdb:	a2 0a 40 12 c0       	mov    %al,0xc012400a
    str[3] = '\0';
c0107ce0:	c6 05 0b 40 12 c0 00 	movb   $0x0,0xc012400b
    return str;
c0107ce7:	b8 08 40 12 c0       	mov    $0xc0124008,%eax
}
c0107cec:	5d                   	pop    %ebp
c0107ced:	c3                   	ret    

c0107cee <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0107cee:	55                   	push   %ebp
c0107cef:	89 e5                	mov    %esp,%ebp
c0107cf1:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0107cf4:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cf7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107cfa:	72 0d                	jb     c0107d09 <get_pgtable_items+0x1b>
        return 0;
c0107cfc:	b8 00 00 00 00       	mov    $0x0,%eax
c0107d01:	e9 98 00 00 00       	jmp    c0107d9e <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0107d06:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0107d09:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d0c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d0f:	73 18                	jae    c0107d29 <get_pgtable_items+0x3b>
c0107d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d14:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107d1b:	8b 45 14             	mov    0x14(%ebp),%eax
c0107d1e:	01 d0                	add    %edx,%eax
c0107d20:	8b 00                	mov    (%eax),%eax
c0107d22:	83 e0 01             	and    $0x1,%eax
c0107d25:	85 c0                	test   %eax,%eax
c0107d27:	74 dd                	je     c0107d06 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0107d29:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d2f:	73 68                	jae    c0107d99 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0107d31:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0107d35:	74 08                	je     c0107d3f <get_pgtable_items+0x51>
            *left_store = start;
c0107d37:	8b 45 18             	mov    0x18(%ebp),%eax
c0107d3a:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d3d:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0107d3f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d42:	8d 50 01             	lea    0x1(%eax),%edx
c0107d45:	89 55 10             	mov    %edx,0x10(%ebp)
c0107d48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107d4f:	8b 45 14             	mov    0x14(%ebp),%eax
c0107d52:	01 d0                	add    %edx,%eax
c0107d54:	8b 00                	mov    (%eax),%eax
c0107d56:	83 e0 07             	and    $0x7,%eax
c0107d59:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0107d5c:	eb 03                	jmp    c0107d61 <get_pgtable_items+0x73>
            start ++;
c0107d5e:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0107d61:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d64:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d67:	73 1d                	jae    c0107d86 <get_pgtable_items+0x98>
c0107d69:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d6c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107d73:	8b 45 14             	mov    0x14(%ebp),%eax
c0107d76:	01 d0                	add    %edx,%eax
c0107d78:	8b 00                	mov    (%eax),%eax
c0107d7a:	83 e0 07             	and    $0x7,%eax
c0107d7d:	89 c2                	mov    %eax,%edx
c0107d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d82:	39 c2                	cmp    %eax,%edx
c0107d84:	74 d8                	je     c0107d5e <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0107d86:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107d8a:	74 08                	je     c0107d94 <get_pgtable_items+0xa6>
            *right_store = start;
c0107d8c:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107d8f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107d92:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0107d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d97:	eb 05                	jmp    c0107d9e <get_pgtable_items+0xb0>
    }
    return 0;
c0107d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107d9e:	c9                   	leave  
c0107d9f:	c3                   	ret    

c0107da0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0107da0:	55                   	push   %ebp
c0107da1:	89 e5                	mov    %esp,%ebp
c0107da3:	57                   	push   %edi
c0107da4:	56                   	push   %esi
c0107da5:	53                   	push   %ebx
c0107da6:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0107da9:	c7 04 24 ac aa 10 c0 	movl   $0xc010aaac,(%esp)
c0107db0:	e8 f7 84 ff ff       	call   c01002ac <cprintf>
    size_t left, right = 0, perm;
c0107db5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107dbc:	e9 fa 00 00 00       	jmp    c0107ebb <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107dc4:	89 04 24             	mov    %eax,(%esp)
c0107dc7:	e8 e0 fe ff ff       	call   c0107cac <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0107dcc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0107dcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107dd2:	29 d1                	sub    %edx,%ecx
c0107dd4:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0107dd6:	89 d6                	mov    %edx,%esi
c0107dd8:	c1 e6 16             	shl    $0x16,%esi
c0107ddb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107dde:	89 d3                	mov    %edx,%ebx
c0107de0:	c1 e3 16             	shl    $0x16,%ebx
c0107de3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107de6:	89 d1                	mov    %edx,%ecx
c0107de8:	c1 e1 16             	shl    $0x16,%ecx
c0107deb:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0107dee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107df1:	29 d7                	sub    %edx,%edi
c0107df3:	89 fa                	mov    %edi,%edx
c0107df5:	89 44 24 14          	mov    %eax,0x14(%esp)
c0107df9:	89 74 24 10          	mov    %esi,0x10(%esp)
c0107dfd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0107e01:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107e05:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e09:	c7 04 24 dd aa 10 c0 	movl   $0xc010aadd,(%esp)
c0107e10:	e8 97 84 ff ff       	call   c01002ac <cprintf>
        size_t l, r = left * NPTEENTRY;
c0107e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e18:	c1 e0 0a             	shl    $0xa,%eax
c0107e1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0107e1e:	eb 54                	jmp    c0107e74 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e23:	89 04 24             	mov    %eax,(%esp)
c0107e26:	e8 81 fe ff ff       	call   c0107cac <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0107e2b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0107e2e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107e31:	29 d1                	sub    %edx,%ecx
c0107e33:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0107e35:	89 d6                	mov    %edx,%esi
c0107e37:	c1 e6 0c             	shl    $0xc,%esi
c0107e3a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107e3d:	89 d3                	mov    %edx,%ebx
c0107e3f:	c1 e3 0c             	shl    $0xc,%ebx
c0107e42:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107e45:	89 d1                	mov    %edx,%ecx
c0107e47:	c1 e1 0c             	shl    $0xc,%ecx
c0107e4a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0107e4d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107e50:	29 d7                	sub    %edx,%edi
c0107e52:	89 fa                	mov    %edi,%edx
c0107e54:	89 44 24 14          	mov    %eax,0x14(%esp)
c0107e58:	89 74 24 10          	mov    %esi,0x10(%esp)
c0107e5c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0107e60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107e64:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e68:	c7 04 24 fc aa 10 c0 	movl   $0xc010aafc,(%esp)
c0107e6f:	e8 38 84 ff ff       	call   c01002ac <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0107e74:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0107e79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107e7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107e7f:	89 d3                	mov    %edx,%ebx
c0107e81:	c1 e3 0a             	shl    $0xa,%ebx
c0107e84:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107e87:	89 d1                	mov    %edx,%ecx
c0107e89:	c1 e1 0a             	shl    $0xa,%ecx
c0107e8c:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0107e8f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107e93:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0107e96:	89 54 24 10          	mov    %edx,0x10(%esp)
c0107e9a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0107e9e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ea2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0107ea6:	89 0c 24             	mov    %ecx,(%esp)
c0107ea9:	e8 40 fe ff ff       	call   c0107cee <get_pgtable_items>
c0107eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107eb1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107eb5:	0f 85 65 ff ff ff    	jne    c0107e20 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0107ebb:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0107ec0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ec3:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0107ec6:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107eca:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0107ecd:	89 54 24 10          	mov    %edx,0x10(%esp)
c0107ed1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ed9:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0107ee0:	00 
c0107ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107ee8:	e8 01 fe ff ff       	call   c0107cee <get_pgtable_items>
c0107eed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107ef0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107ef4:	0f 85 c7 fe ff ff    	jne    c0107dc1 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0107efa:	c7 04 24 20 ab 10 c0 	movl   $0xc010ab20,(%esp)
c0107f01:	e8 a6 83 ff ff       	call   c01002ac <cprintf>
}
c0107f06:	90                   	nop
c0107f07:	83 c4 4c             	add    $0x4c,%esp
c0107f0a:	5b                   	pop    %ebx
c0107f0b:	5e                   	pop    %esi
c0107f0c:	5f                   	pop    %edi
c0107f0d:	5d                   	pop    %ebp
c0107f0e:	c3                   	ret    

c0107f0f <kmalloc>:

void *
kmalloc(size_t n) {
c0107f0f:	55                   	push   %ebp
c0107f10:	89 e5                	mov    %esp,%ebp
c0107f12:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0107f15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0107f1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0107f23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107f27:	74 09                	je     c0107f32 <kmalloc+0x23>
c0107f29:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0107f30:	76 24                	jbe    c0107f56 <kmalloc+0x47>
c0107f32:	c7 44 24 0c 51 ab 10 	movl   $0xc010ab51,0xc(%esp)
c0107f39:	c0 
c0107f3a:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107f41:	c0 
c0107f42:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c0107f49:	00 
c0107f4a:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107f51:	e8 ad 84 ff ff       	call   c0100403 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0107f56:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f59:	05 ff 0f 00 00       	add    $0xfff,%eax
c0107f5e:	c1 e8 0c             	shr    $0xc,%eax
c0107f61:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0107f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f67:	89 04 24             	mov    %eax,(%esp)
c0107f6a:	e8 d6 e7 ff ff       	call   c0106745 <alloc_pages>
c0107f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0107f72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107f76:	75 24                	jne    c0107f9c <kmalloc+0x8d>
c0107f78:	c7 44 24 0c 68 ab 10 	movl   $0xc010ab68,0xc(%esp)
c0107f7f:	c0 
c0107f80:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107f87:	c0 
c0107f88:	c7 44 24 04 aa 02 00 	movl   $0x2aa,0x4(%esp)
c0107f8f:	00 
c0107f90:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107f97:	e8 67 84 ff ff       	call   c0100403 <__panic>
    ptr=page2kva(base);
c0107f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f9f:	89 04 24             	mov    %eax,(%esp)
c0107fa2:	e8 a5 e4 ff ff       	call   c010644c <page2kva>
c0107fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0107faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107fad:	c9                   	leave  
c0107fae:	c3                   	ret    

c0107faf <kfree>:

void 
kfree(void *ptr, size_t n) {
c0107faf:	55                   	push   %ebp
c0107fb0:	89 e5                	mov    %esp,%ebp
c0107fb2:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0107fb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107fb9:	74 09                	je     c0107fc4 <kfree+0x15>
c0107fbb:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0107fc2:	76 24                	jbe    c0107fe8 <kfree+0x39>
c0107fc4:	c7 44 24 0c 51 ab 10 	movl   $0xc010ab51,0xc(%esp)
c0107fcb:	c0 
c0107fcc:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107fd3:	c0 
c0107fd4:	c7 44 24 04 b1 02 00 	movl   $0x2b1,0x4(%esp)
c0107fdb:	00 
c0107fdc:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c0107fe3:	e8 1b 84 ff ff       	call   c0100403 <__panic>
    assert(ptr != NULL);
c0107fe8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107fec:	75 24                	jne    c0108012 <kfree+0x63>
c0107fee:	c7 44 24 0c 75 ab 10 	movl   $0xc010ab75,0xc(%esp)
c0107ff5:	c0 
c0107ff6:	c7 44 24 08 e1 a5 10 	movl   $0xc010a5e1,0x8(%esp)
c0107ffd:	c0 
c0107ffe:	c7 44 24 04 b2 02 00 	movl   $0x2b2,0x4(%esp)
c0108005:	00 
c0108006:	c7 04 24 bc a5 10 c0 	movl   $0xc010a5bc,(%esp)
c010800d:	e8 f1 83 ff ff       	call   c0100403 <__panic>
    struct Page *base=NULL;
c0108012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0108019:	8b 45 0c             	mov    0xc(%ebp),%eax
c010801c:	05 ff 0f 00 00       	add    $0xfff,%eax
c0108021:	c1 e8 0c             	shr    $0xc,%eax
c0108024:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0108027:	8b 45 08             	mov    0x8(%ebp),%eax
c010802a:	89 04 24             	mov    %eax,(%esp)
c010802d:	e8 6e e4 ff ff       	call   c01064a0 <kva2page>
c0108032:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0108035:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108038:	89 44 24 04          	mov    %eax,0x4(%esp)
c010803c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010803f:	89 04 24             	mov    %eax,(%esp)
c0108042:	e8 69 e7 ff ff       	call   c01067b0 <free_pages>
}
c0108047:	90                   	nop
c0108048:	c9                   	leave  
c0108049:	c3                   	ret    

c010804a <page2ppn>:
page2ppn(struct Page *page) {
c010804a:	55                   	push   %ebp
c010804b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010804d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108050:	8b 15 00 41 12 c0    	mov    0xc0124100,%edx
c0108056:	29 d0                	sub    %edx,%eax
c0108058:	c1 f8 05             	sar    $0x5,%eax
}
c010805b:	5d                   	pop    %ebp
c010805c:	c3                   	ret    

c010805d <page2pa>:
page2pa(struct Page *page) {
c010805d:	55                   	push   %ebp
c010805e:	89 e5                	mov    %esp,%ebp
c0108060:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108063:	8b 45 08             	mov    0x8(%ebp),%eax
c0108066:	89 04 24             	mov    %eax,(%esp)
c0108069:	e8 dc ff ff ff       	call   c010804a <page2ppn>
c010806e:	c1 e0 0c             	shl    $0xc,%eax
}
c0108071:	c9                   	leave  
c0108072:	c3                   	ret    

c0108073 <page2kva>:
page2kva(struct Page *page) {
c0108073:	55                   	push   %ebp
c0108074:	89 e5                	mov    %esp,%ebp
c0108076:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108079:	8b 45 08             	mov    0x8(%ebp),%eax
c010807c:	89 04 24             	mov    %eax,(%esp)
c010807f:	e8 d9 ff ff ff       	call   c010805d <page2pa>
c0108084:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108087:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010808a:	c1 e8 0c             	shr    $0xc,%eax
c010808d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108090:	a1 80 3f 12 c0       	mov    0xc0123f80,%eax
c0108095:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108098:	72 23                	jb     c01080bd <page2kva+0x4a>
c010809a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010809d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01080a1:	c7 44 24 08 84 ab 10 	movl   $0xc010ab84,0x8(%esp)
c01080a8:	c0 
c01080a9:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01080b0:	00 
c01080b1:	c7 04 24 a7 ab 10 c0 	movl   $0xc010aba7,(%esp)
c01080b8:	e8 46 83 ff ff       	call   c0100403 <__panic>
c01080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080c0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01080c5:	c9                   	leave  
c01080c6:	c3                   	ret    

c01080c7 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01080c7:	55                   	push   %ebp
c01080c8:	89 e5                	mov    %esp,%ebp
c01080ca:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01080cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01080d4:	e8 04 90 ff ff       	call   c01010dd <ide_device_valid>
c01080d9:	85 c0                	test   %eax,%eax
c01080db:	75 1c                	jne    c01080f9 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01080dd:	c7 44 24 08 b5 ab 10 	movl   $0xc010abb5,0x8(%esp)
c01080e4:	c0 
c01080e5:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01080ec:	00 
c01080ed:	c7 04 24 cf ab 10 c0 	movl   $0xc010abcf,(%esp)
c01080f4:	e8 0a 83 ff ff       	call   c0100403 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01080f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108100:	e8 16 90 ff ff       	call   c010111b <ide_device_size>
c0108105:	c1 e8 03             	shr    $0x3,%eax
c0108108:	a3 bc 40 12 c0       	mov    %eax,0xc01240bc
}
c010810d:	90                   	nop
c010810e:	c9                   	leave  
c010810f:	c3                   	ret    

c0108110 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108110:	55                   	push   %ebp
c0108111:	89 e5                	mov    %esp,%ebp
c0108113:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108116:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108119:	89 04 24             	mov    %eax,(%esp)
c010811c:	e8 52 ff ff ff       	call   c0108073 <page2kva>
c0108121:	8b 55 08             	mov    0x8(%ebp),%edx
c0108124:	c1 ea 08             	shr    $0x8,%edx
c0108127:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010812a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010812e:	74 0b                	je     c010813b <swapfs_read+0x2b>
c0108130:	8b 15 bc 40 12 c0    	mov    0xc01240bc,%edx
c0108136:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108139:	72 23                	jb     c010815e <swapfs_read+0x4e>
c010813b:	8b 45 08             	mov    0x8(%ebp),%eax
c010813e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108142:	c7 44 24 08 e0 ab 10 	movl   $0xc010abe0,0x8(%esp)
c0108149:	c0 
c010814a:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108151:	00 
c0108152:	c7 04 24 cf ab 10 c0 	movl   $0xc010abcf,(%esp)
c0108159:	e8 a5 82 ff ff       	call   c0100403 <__panic>
c010815e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108161:	c1 e2 03             	shl    $0x3,%edx
c0108164:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010816b:	00 
c010816c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108170:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108174:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010817b:	e8 d6 8f ff ff       	call   c0101156 <ide_read_secs>
}
c0108180:	c9                   	leave  
c0108181:	c3                   	ret    

c0108182 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108182:	55                   	push   %ebp
c0108183:	89 e5                	mov    %esp,%ebp
c0108185:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108188:	8b 45 0c             	mov    0xc(%ebp),%eax
c010818b:	89 04 24             	mov    %eax,(%esp)
c010818e:	e8 e0 fe ff ff       	call   c0108073 <page2kva>
c0108193:	8b 55 08             	mov    0x8(%ebp),%edx
c0108196:	c1 ea 08             	shr    $0x8,%edx
c0108199:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010819c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01081a0:	74 0b                	je     c01081ad <swapfs_write+0x2b>
c01081a2:	8b 15 bc 40 12 c0    	mov    0xc01240bc,%edx
c01081a8:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01081ab:	72 23                	jb     c01081d0 <swapfs_write+0x4e>
c01081ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01081b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01081b4:	c7 44 24 08 e0 ab 10 	movl   $0xc010abe0,0x8(%esp)
c01081bb:	c0 
c01081bc:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01081c3:	00 
c01081c4:	c7 04 24 cf ab 10 c0 	movl   $0xc010abcf,(%esp)
c01081cb:	e8 33 82 ff ff       	call   c0100403 <__panic>
c01081d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081d3:	c1 e2 03             	shl    $0x3,%edx
c01081d6:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01081dd:	00 
c01081de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01081e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01081ed:	e8 9d 91 ff ff       	call   c010138f <ide_write_secs>
}
c01081f2:	c9                   	leave  
c01081f3:	c3                   	ret    

c01081f4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01081f4:	55                   	push   %ebp
c01081f5:	89 e5                	mov    %esp,%ebp
c01081f7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01081fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108201:	eb 03                	jmp    c0108206 <strlen+0x12>
        cnt ++;
c0108203:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0108206:	8b 45 08             	mov    0x8(%ebp),%eax
c0108209:	8d 50 01             	lea    0x1(%eax),%edx
c010820c:	89 55 08             	mov    %edx,0x8(%ebp)
c010820f:	0f b6 00             	movzbl (%eax),%eax
c0108212:	84 c0                	test   %al,%al
c0108214:	75 ed                	jne    c0108203 <strlen+0xf>
    }
    return cnt;
c0108216:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108219:	c9                   	leave  
c010821a:	c3                   	ret    

c010821b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010821b:	55                   	push   %ebp
c010821c:	89 e5                	mov    %esp,%ebp
c010821e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108228:	eb 03                	jmp    c010822d <strnlen+0x12>
        cnt ++;
c010822a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010822d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108230:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108233:	73 10                	jae    c0108245 <strnlen+0x2a>
c0108235:	8b 45 08             	mov    0x8(%ebp),%eax
c0108238:	8d 50 01             	lea    0x1(%eax),%edx
c010823b:	89 55 08             	mov    %edx,0x8(%ebp)
c010823e:	0f b6 00             	movzbl (%eax),%eax
c0108241:	84 c0                	test   %al,%al
c0108243:	75 e5                	jne    c010822a <strnlen+0xf>
    }
    return cnt;
c0108245:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108248:	c9                   	leave  
c0108249:	c3                   	ret    

c010824a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010824a:	55                   	push   %ebp
c010824b:	89 e5                	mov    %esp,%ebp
c010824d:	57                   	push   %edi
c010824e:	56                   	push   %esi
c010824f:	83 ec 20             	sub    $0x20,%esp
c0108252:	8b 45 08             	mov    0x8(%ebp),%eax
c0108255:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108258:	8b 45 0c             	mov    0xc(%ebp),%eax
c010825b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010825e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108261:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108264:	89 d1                	mov    %edx,%ecx
c0108266:	89 c2                	mov    %eax,%edx
c0108268:	89 ce                	mov    %ecx,%esi
c010826a:	89 d7                	mov    %edx,%edi
c010826c:	ac                   	lods   %ds:(%esi),%al
c010826d:	aa                   	stos   %al,%es:(%edi)
c010826e:	84 c0                	test   %al,%al
c0108270:	75 fa                	jne    c010826c <strcpy+0x22>
c0108272:	89 fa                	mov    %edi,%edx
c0108274:	89 f1                	mov    %esi,%ecx
c0108276:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108279:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010827c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010827f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0108282:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108283:	83 c4 20             	add    $0x20,%esp
c0108286:	5e                   	pop    %esi
c0108287:	5f                   	pop    %edi
c0108288:	5d                   	pop    %ebp
c0108289:	c3                   	ret    

c010828a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010828a:	55                   	push   %ebp
c010828b:	89 e5                	mov    %esp,%ebp
c010828d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108290:	8b 45 08             	mov    0x8(%ebp),%eax
c0108293:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108296:	eb 1e                	jmp    c01082b6 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0108298:	8b 45 0c             	mov    0xc(%ebp),%eax
c010829b:	0f b6 10             	movzbl (%eax),%edx
c010829e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01082a1:	88 10                	mov    %dl,(%eax)
c01082a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01082a6:	0f b6 00             	movzbl (%eax),%eax
c01082a9:	84 c0                	test   %al,%al
c01082ab:	74 03                	je     c01082b0 <strncpy+0x26>
            src ++;
c01082ad:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01082b0:	ff 45 fc             	incl   -0x4(%ebp)
c01082b3:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01082b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01082ba:	75 dc                	jne    c0108298 <strncpy+0xe>
    }
    return dst;
c01082bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01082bf:	c9                   	leave  
c01082c0:	c3                   	ret    

c01082c1 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01082c1:	55                   	push   %ebp
c01082c2:	89 e5                	mov    %esp,%ebp
c01082c4:	57                   	push   %edi
c01082c5:	56                   	push   %esi
c01082c6:	83 ec 20             	sub    $0x20,%esp
c01082c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01082cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01082d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01082d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082db:	89 d1                	mov    %edx,%ecx
c01082dd:	89 c2                	mov    %eax,%edx
c01082df:	89 ce                	mov    %ecx,%esi
c01082e1:	89 d7                	mov    %edx,%edi
c01082e3:	ac                   	lods   %ds:(%esi),%al
c01082e4:	ae                   	scas   %es:(%edi),%al
c01082e5:	75 08                	jne    c01082ef <strcmp+0x2e>
c01082e7:	84 c0                	test   %al,%al
c01082e9:	75 f8                	jne    c01082e3 <strcmp+0x22>
c01082eb:	31 c0                	xor    %eax,%eax
c01082ed:	eb 04                	jmp    c01082f3 <strcmp+0x32>
c01082ef:	19 c0                	sbb    %eax,%eax
c01082f1:	0c 01                	or     $0x1,%al
c01082f3:	89 fa                	mov    %edi,%edx
c01082f5:	89 f1                	mov    %esi,%ecx
c01082f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01082fa:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01082fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0108300:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0108303:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108304:	83 c4 20             	add    $0x20,%esp
c0108307:	5e                   	pop    %esi
c0108308:	5f                   	pop    %edi
c0108309:	5d                   	pop    %ebp
c010830a:	c3                   	ret    

c010830b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010830b:	55                   	push   %ebp
c010830c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010830e:	eb 09                	jmp    c0108319 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0108310:	ff 4d 10             	decl   0x10(%ebp)
c0108313:	ff 45 08             	incl   0x8(%ebp)
c0108316:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108319:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010831d:	74 1a                	je     c0108339 <strncmp+0x2e>
c010831f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108322:	0f b6 00             	movzbl (%eax),%eax
c0108325:	84 c0                	test   %al,%al
c0108327:	74 10                	je     c0108339 <strncmp+0x2e>
c0108329:	8b 45 08             	mov    0x8(%ebp),%eax
c010832c:	0f b6 10             	movzbl (%eax),%edx
c010832f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108332:	0f b6 00             	movzbl (%eax),%eax
c0108335:	38 c2                	cmp    %al,%dl
c0108337:	74 d7                	je     c0108310 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010833d:	74 18                	je     c0108357 <strncmp+0x4c>
c010833f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108342:	0f b6 00             	movzbl (%eax),%eax
c0108345:	0f b6 d0             	movzbl %al,%edx
c0108348:	8b 45 0c             	mov    0xc(%ebp),%eax
c010834b:	0f b6 00             	movzbl (%eax),%eax
c010834e:	0f b6 c0             	movzbl %al,%eax
c0108351:	29 c2                	sub    %eax,%edx
c0108353:	89 d0                	mov    %edx,%eax
c0108355:	eb 05                	jmp    c010835c <strncmp+0x51>
c0108357:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010835c:	5d                   	pop    %ebp
c010835d:	c3                   	ret    

c010835e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010835e:	55                   	push   %ebp
c010835f:	89 e5                	mov    %esp,%ebp
c0108361:	83 ec 04             	sub    $0x4,%esp
c0108364:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108367:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010836a:	eb 13                	jmp    c010837f <strchr+0x21>
        if (*s == c) {
c010836c:	8b 45 08             	mov    0x8(%ebp),%eax
c010836f:	0f b6 00             	movzbl (%eax),%eax
c0108372:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0108375:	75 05                	jne    c010837c <strchr+0x1e>
            return (char *)s;
c0108377:	8b 45 08             	mov    0x8(%ebp),%eax
c010837a:	eb 12                	jmp    c010838e <strchr+0x30>
        }
        s ++;
c010837c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010837f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108382:	0f b6 00             	movzbl (%eax),%eax
c0108385:	84 c0                	test   %al,%al
c0108387:	75 e3                	jne    c010836c <strchr+0xe>
    }
    return NULL;
c0108389:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010838e:	c9                   	leave  
c010838f:	c3                   	ret    

c0108390 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108390:	55                   	push   %ebp
c0108391:	89 e5                	mov    %esp,%ebp
c0108393:	83 ec 04             	sub    $0x4,%esp
c0108396:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108399:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010839c:	eb 0e                	jmp    c01083ac <strfind+0x1c>
        if (*s == c) {
c010839e:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a1:	0f b6 00             	movzbl (%eax),%eax
c01083a4:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01083a7:	74 0f                	je     c01083b8 <strfind+0x28>
            break;
        }
        s ++;
c01083a9:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01083ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01083af:	0f b6 00             	movzbl (%eax),%eax
c01083b2:	84 c0                	test   %al,%al
c01083b4:	75 e8                	jne    c010839e <strfind+0xe>
c01083b6:	eb 01                	jmp    c01083b9 <strfind+0x29>
            break;
c01083b8:	90                   	nop
    }
    return (char *)s;
c01083b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01083bc:	c9                   	leave  
c01083bd:	c3                   	ret    

c01083be <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01083be:	55                   	push   %ebp
c01083bf:	89 e5                	mov    %esp,%ebp
c01083c1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01083c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01083cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01083d2:	eb 03                	jmp    c01083d7 <strtol+0x19>
        s ++;
c01083d4:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01083d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01083da:	0f b6 00             	movzbl (%eax),%eax
c01083dd:	3c 20                	cmp    $0x20,%al
c01083df:	74 f3                	je     c01083d4 <strtol+0x16>
c01083e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01083e4:	0f b6 00             	movzbl (%eax),%eax
c01083e7:	3c 09                	cmp    $0x9,%al
c01083e9:	74 e9                	je     c01083d4 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01083eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ee:	0f b6 00             	movzbl (%eax),%eax
c01083f1:	3c 2b                	cmp    $0x2b,%al
c01083f3:	75 05                	jne    c01083fa <strtol+0x3c>
        s ++;
c01083f5:	ff 45 08             	incl   0x8(%ebp)
c01083f8:	eb 14                	jmp    c010840e <strtol+0x50>
    }
    else if (*s == '-') {
c01083fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01083fd:	0f b6 00             	movzbl (%eax),%eax
c0108400:	3c 2d                	cmp    $0x2d,%al
c0108402:	75 0a                	jne    c010840e <strtol+0x50>
        s ++, neg = 1;
c0108404:	ff 45 08             	incl   0x8(%ebp)
c0108407:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010840e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108412:	74 06                	je     c010841a <strtol+0x5c>
c0108414:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108418:	75 22                	jne    c010843c <strtol+0x7e>
c010841a:	8b 45 08             	mov    0x8(%ebp),%eax
c010841d:	0f b6 00             	movzbl (%eax),%eax
c0108420:	3c 30                	cmp    $0x30,%al
c0108422:	75 18                	jne    c010843c <strtol+0x7e>
c0108424:	8b 45 08             	mov    0x8(%ebp),%eax
c0108427:	40                   	inc    %eax
c0108428:	0f b6 00             	movzbl (%eax),%eax
c010842b:	3c 78                	cmp    $0x78,%al
c010842d:	75 0d                	jne    c010843c <strtol+0x7e>
        s += 2, base = 16;
c010842f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108433:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010843a:	eb 29                	jmp    c0108465 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c010843c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108440:	75 16                	jne    c0108458 <strtol+0x9a>
c0108442:	8b 45 08             	mov    0x8(%ebp),%eax
c0108445:	0f b6 00             	movzbl (%eax),%eax
c0108448:	3c 30                	cmp    $0x30,%al
c010844a:	75 0c                	jne    c0108458 <strtol+0x9a>
        s ++, base = 8;
c010844c:	ff 45 08             	incl   0x8(%ebp)
c010844f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108456:	eb 0d                	jmp    c0108465 <strtol+0xa7>
    }
    else if (base == 0) {
c0108458:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010845c:	75 07                	jne    c0108465 <strtol+0xa7>
        base = 10;
c010845e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108465:	8b 45 08             	mov    0x8(%ebp),%eax
c0108468:	0f b6 00             	movzbl (%eax),%eax
c010846b:	3c 2f                	cmp    $0x2f,%al
c010846d:	7e 1b                	jle    c010848a <strtol+0xcc>
c010846f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108472:	0f b6 00             	movzbl (%eax),%eax
c0108475:	3c 39                	cmp    $0x39,%al
c0108477:	7f 11                	jg     c010848a <strtol+0xcc>
            dig = *s - '0';
c0108479:	8b 45 08             	mov    0x8(%ebp),%eax
c010847c:	0f b6 00             	movzbl (%eax),%eax
c010847f:	0f be c0             	movsbl %al,%eax
c0108482:	83 e8 30             	sub    $0x30,%eax
c0108485:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108488:	eb 48                	jmp    c01084d2 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010848a:	8b 45 08             	mov    0x8(%ebp),%eax
c010848d:	0f b6 00             	movzbl (%eax),%eax
c0108490:	3c 60                	cmp    $0x60,%al
c0108492:	7e 1b                	jle    c01084af <strtol+0xf1>
c0108494:	8b 45 08             	mov    0x8(%ebp),%eax
c0108497:	0f b6 00             	movzbl (%eax),%eax
c010849a:	3c 7a                	cmp    $0x7a,%al
c010849c:	7f 11                	jg     c01084af <strtol+0xf1>
            dig = *s - 'a' + 10;
c010849e:	8b 45 08             	mov    0x8(%ebp),%eax
c01084a1:	0f b6 00             	movzbl (%eax),%eax
c01084a4:	0f be c0             	movsbl %al,%eax
c01084a7:	83 e8 57             	sub    $0x57,%eax
c01084aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084ad:	eb 23                	jmp    c01084d2 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01084af:	8b 45 08             	mov    0x8(%ebp),%eax
c01084b2:	0f b6 00             	movzbl (%eax),%eax
c01084b5:	3c 40                	cmp    $0x40,%al
c01084b7:	7e 3b                	jle    c01084f4 <strtol+0x136>
c01084b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01084bc:	0f b6 00             	movzbl (%eax),%eax
c01084bf:	3c 5a                	cmp    $0x5a,%al
c01084c1:	7f 31                	jg     c01084f4 <strtol+0x136>
            dig = *s - 'A' + 10;
c01084c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c6:	0f b6 00             	movzbl (%eax),%eax
c01084c9:	0f be c0             	movsbl %al,%eax
c01084cc:	83 e8 37             	sub    $0x37,%eax
c01084cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01084d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084d5:	3b 45 10             	cmp    0x10(%ebp),%eax
c01084d8:	7d 19                	jge    c01084f3 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c01084da:	ff 45 08             	incl   0x8(%ebp)
c01084dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01084e0:	0f af 45 10          	imul   0x10(%ebp),%eax
c01084e4:	89 c2                	mov    %eax,%edx
c01084e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084e9:	01 d0                	add    %edx,%eax
c01084eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01084ee:	e9 72 ff ff ff       	jmp    c0108465 <strtol+0xa7>
            break;
c01084f3:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01084f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01084f8:	74 08                	je     c0108502 <strtol+0x144>
        *endptr = (char *) s;
c01084fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0108500:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108502:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108506:	74 07                	je     c010850f <strtol+0x151>
c0108508:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010850b:	f7 d8                	neg    %eax
c010850d:	eb 03                	jmp    c0108512 <strtol+0x154>
c010850f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108512:	c9                   	leave  
c0108513:	c3                   	ret    

c0108514 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108514:	55                   	push   %ebp
c0108515:	89 e5                	mov    %esp,%ebp
c0108517:	57                   	push   %edi
c0108518:	83 ec 24             	sub    $0x24,%esp
c010851b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010851e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108521:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108525:	8b 55 08             	mov    0x8(%ebp),%edx
c0108528:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010852b:	88 45 f7             	mov    %al,-0x9(%ebp)
c010852e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108531:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108534:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108537:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010853b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010853e:	89 d7                	mov    %edx,%edi
c0108540:	f3 aa                	rep stos %al,%es:(%edi)
c0108542:	89 fa                	mov    %edi,%edx
c0108544:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108547:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010854a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010854d:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010854e:	83 c4 24             	add    $0x24,%esp
c0108551:	5f                   	pop    %edi
c0108552:	5d                   	pop    %ebp
c0108553:	c3                   	ret    

c0108554 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108554:	55                   	push   %ebp
c0108555:	89 e5                	mov    %esp,%ebp
c0108557:	57                   	push   %edi
c0108558:	56                   	push   %esi
c0108559:	53                   	push   %ebx
c010855a:	83 ec 30             	sub    $0x30,%esp
c010855d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108560:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108566:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108569:	8b 45 10             	mov    0x10(%ebp),%eax
c010856c:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010856f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108572:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108575:	73 42                	jae    c01085b9 <memmove+0x65>
c0108577:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010857a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010857d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108580:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108583:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108586:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108589:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010858c:	c1 e8 02             	shr    $0x2,%eax
c010858f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108591:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108594:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108597:	89 d7                	mov    %edx,%edi
c0108599:	89 c6                	mov    %eax,%esi
c010859b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010859d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01085a0:	83 e1 03             	and    $0x3,%ecx
c01085a3:	74 02                	je     c01085a7 <memmove+0x53>
c01085a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01085a7:	89 f0                	mov    %esi,%eax
c01085a9:	89 fa                	mov    %edi,%edx
c01085ab:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01085ae:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01085b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01085b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01085b7:	eb 36                	jmp    c01085ef <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01085b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085bc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01085bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01085c2:	01 c2                	add    %eax,%edx
c01085c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085c7:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01085ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085cd:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01085d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085d3:	89 c1                	mov    %eax,%ecx
c01085d5:	89 d8                	mov    %ebx,%eax
c01085d7:	89 d6                	mov    %edx,%esi
c01085d9:	89 c7                	mov    %eax,%edi
c01085db:	fd                   	std    
c01085dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01085de:	fc                   	cld    
c01085df:	89 f8                	mov    %edi,%eax
c01085e1:	89 f2                	mov    %esi,%edx
c01085e3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01085e6:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01085e9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01085ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01085ef:	83 c4 30             	add    $0x30,%esp
c01085f2:	5b                   	pop    %ebx
c01085f3:	5e                   	pop    %esi
c01085f4:	5f                   	pop    %edi
c01085f5:	5d                   	pop    %ebp
c01085f6:	c3                   	ret    

c01085f7 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01085f7:	55                   	push   %ebp
c01085f8:	89 e5                	mov    %esp,%ebp
c01085fa:	57                   	push   %edi
c01085fb:	56                   	push   %esi
c01085fc:	83 ec 20             	sub    $0x20,%esp
c01085ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108602:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108605:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108608:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010860b:	8b 45 10             	mov    0x10(%ebp),%eax
c010860e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108611:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108614:	c1 e8 02             	shr    $0x2,%eax
c0108617:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108619:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010861c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010861f:	89 d7                	mov    %edx,%edi
c0108621:	89 c6                	mov    %eax,%esi
c0108623:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108625:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108628:	83 e1 03             	and    $0x3,%ecx
c010862b:	74 02                	je     c010862f <memcpy+0x38>
c010862d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010862f:	89 f0                	mov    %esi,%eax
c0108631:	89 fa                	mov    %edi,%edx
c0108633:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108636:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108639:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010863c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010863f:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108640:	83 c4 20             	add    $0x20,%esp
c0108643:	5e                   	pop    %esi
c0108644:	5f                   	pop    %edi
c0108645:	5d                   	pop    %ebp
c0108646:	c3                   	ret    

c0108647 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108647:	55                   	push   %ebp
c0108648:	89 e5                	mov    %esp,%ebp
c010864a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010864d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108650:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108653:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108656:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108659:	eb 2e                	jmp    c0108689 <memcmp+0x42>
        if (*s1 != *s2) {
c010865b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010865e:	0f b6 10             	movzbl (%eax),%edx
c0108661:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108664:	0f b6 00             	movzbl (%eax),%eax
c0108667:	38 c2                	cmp    %al,%dl
c0108669:	74 18                	je     c0108683 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010866b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010866e:	0f b6 00             	movzbl (%eax),%eax
c0108671:	0f b6 d0             	movzbl %al,%edx
c0108674:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108677:	0f b6 00             	movzbl (%eax),%eax
c010867a:	0f b6 c0             	movzbl %al,%eax
c010867d:	29 c2                	sub    %eax,%edx
c010867f:	89 d0                	mov    %edx,%eax
c0108681:	eb 18                	jmp    c010869b <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0108683:	ff 45 fc             	incl   -0x4(%ebp)
c0108686:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0108689:	8b 45 10             	mov    0x10(%ebp),%eax
c010868c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010868f:	89 55 10             	mov    %edx,0x10(%ebp)
c0108692:	85 c0                	test   %eax,%eax
c0108694:	75 c5                	jne    c010865b <memcmp+0x14>
    }
    return 0;
c0108696:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010869b:	c9                   	leave  
c010869c:	c3                   	ret    

c010869d <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010869d:	55                   	push   %ebp
c010869e:	89 e5                	mov    %esp,%ebp
c01086a0:	83 ec 58             	sub    $0x58,%esp
c01086a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01086a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01086a9:	8b 45 14             	mov    0x14(%ebp),%eax
c01086ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01086af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01086b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01086b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01086b8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01086bb:	8b 45 18             	mov    0x18(%ebp),%eax
c01086be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01086c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01086c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01086ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01086cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01086d7:	74 1c                	je     c01086f5 <printnum+0x58>
c01086d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01086e1:	f7 75 e4             	divl   -0x1c(%ebp)
c01086e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01086e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086ea:	ba 00 00 00 00       	mov    $0x0,%edx
c01086ef:	f7 75 e4             	divl   -0x1c(%ebp)
c01086f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086fb:	f7 75 e4             	divl   -0x1c(%ebp)
c01086fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108701:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108704:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108707:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010870a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010870d:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108710:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108713:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108716:	8b 45 18             	mov    0x18(%ebp),%eax
c0108719:	ba 00 00 00 00       	mov    $0x0,%edx
c010871e:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0108721:	72 56                	jb     c0108779 <printnum+0xdc>
c0108723:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0108726:	77 05                	ja     c010872d <printnum+0x90>
c0108728:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010872b:	72 4c                	jb     c0108779 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010872d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108730:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108733:	8b 45 20             	mov    0x20(%ebp),%eax
c0108736:	89 44 24 18          	mov    %eax,0x18(%esp)
c010873a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010873e:	8b 45 18             	mov    0x18(%ebp),%eax
c0108741:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108745:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108748:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010874b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010874f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108753:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108756:	89 44 24 04          	mov    %eax,0x4(%esp)
c010875a:	8b 45 08             	mov    0x8(%ebp),%eax
c010875d:	89 04 24             	mov    %eax,(%esp)
c0108760:	e8 38 ff ff ff       	call   c010869d <printnum>
c0108765:	eb 1b                	jmp    c0108782 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108767:	8b 45 0c             	mov    0xc(%ebp),%eax
c010876a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010876e:	8b 45 20             	mov    0x20(%ebp),%eax
c0108771:	89 04 24             	mov    %eax,(%esp)
c0108774:	8b 45 08             	mov    0x8(%ebp),%eax
c0108777:	ff d0                	call   *%eax
        while (-- width > 0)
c0108779:	ff 4d 1c             	decl   0x1c(%ebp)
c010877c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108780:	7f e5                	jg     c0108767 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108782:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108785:	05 80 ac 10 c0       	add    $0xc010ac80,%eax
c010878a:	0f b6 00             	movzbl (%eax),%eax
c010878d:	0f be c0             	movsbl %al,%eax
c0108790:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108793:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108797:	89 04 24             	mov    %eax,(%esp)
c010879a:	8b 45 08             	mov    0x8(%ebp),%eax
c010879d:	ff d0                	call   *%eax
}
c010879f:	90                   	nop
c01087a0:	c9                   	leave  
c01087a1:	c3                   	ret    

c01087a2 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01087a2:	55                   	push   %ebp
c01087a3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01087a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01087a9:	7e 14                	jle    c01087bf <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01087ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ae:	8b 00                	mov    (%eax),%eax
c01087b0:	8d 48 08             	lea    0x8(%eax),%ecx
c01087b3:	8b 55 08             	mov    0x8(%ebp),%edx
c01087b6:	89 0a                	mov    %ecx,(%edx)
c01087b8:	8b 50 04             	mov    0x4(%eax),%edx
c01087bb:	8b 00                	mov    (%eax),%eax
c01087bd:	eb 30                	jmp    c01087ef <getuint+0x4d>
    }
    else if (lflag) {
c01087bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01087c3:	74 16                	je     c01087db <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01087c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01087c8:	8b 00                	mov    (%eax),%eax
c01087ca:	8d 48 04             	lea    0x4(%eax),%ecx
c01087cd:	8b 55 08             	mov    0x8(%ebp),%edx
c01087d0:	89 0a                	mov    %ecx,(%edx)
c01087d2:	8b 00                	mov    (%eax),%eax
c01087d4:	ba 00 00 00 00       	mov    $0x0,%edx
c01087d9:	eb 14                	jmp    c01087ef <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01087db:	8b 45 08             	mov    0x8(%ebp),%eax
c01087de:	8b 00                	mov    (%eax),%eax
c01087e0:	8d 48 04             	lea    0x4(%eax),%ecx
c01087e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01087e6:	89 0a                	mov    %ecx,(%edx)
c01087e8:	8b 00                	mov    (%eax),%eax
c01087ea:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01087ef:	5d                   	pop    %ebp
c01087f0:	c3                   	ret    

c01087f1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01087f1:	55                   	push   %ebp
c01087f2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01087f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01087f8:	7e 14                	jle    c010880e <getint+0x1d>
        return va_arg(*ap, long long);
c01087fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fd:	8b 00                	mov    (%eax),%eax
c01087ff:	8d 48 08             	lea    0x8(%eax),%ecx
c0108802:	8b 55 08             	mov    0x8(%ebp),%edx
c0108805:	89 0a                	mov    %ecx,(%edx)
c0108807:	8b 50 04             	mov    0x4(%eax),%edx
c010880a:	8b 00                	mov    (%eax),%eax
c010880c:	eb 28                	jmp    c0108836 <getint+0x45>
    }
    else if (lflag) {
c010880e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108812:	74 12                	je     c0108826 <getint+0x35>
        return va_arg(*ap, long);
c0108814:	8b 45 08             	mov    0x8(%ebp),%eax
c0108817:	8b 00                	mov    (%eax),%eax
c0108819:	8d 48 04             	lea    0x4(%eax),%ecx
c010881c:	8b 55 08             	mov    0x8(%ebp),%edx
c010881f:	89 0a                	mov    %ecx,(%edx)
c0108821:	8b 00                	mov    (%eax),%eax
c0108823:	99                   	cltd   
c0108824:	eb 10                	jmp    c0108836 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108826:	8b 45 08             	mov    0x8(%ebp),%eax
c0108829:	8b 00                	mov    (%eax),%eax
c010882b:	8d 48 04             	lea    0x4(%eax),%ecx
c010882e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108831:	89 0a                	mov    %ecx,(%edx)
c0108833:	8b 00                	mov    (%eax),%eax
c0108835:	99                   	cltd   
    }
}
c0108836:	5d                   	pop    %ebp
c0108837:	c3                   	ret    

c0108838 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108838:	55                   	push   %ebp
c0108839:	89 e5                	mov    %esp,%ebp
c010883b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010883e:	8d 45 14             	lea    0x14(%ebp),%eax
c0108841:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108844:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108847:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010884b:	8b 45 10             	mov    0x10(%ebp),%eax
c010884e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108852:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108855:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108859:	8b 45 08             	mov    0x8(%ebp),%eax
c010885c:	89 04 24             	mov    %eax,(%esp)
c010885f:	e8 03 00 00 00       	call   c0108867 <vprintfmt>
    va_end(ap);
}
c0108864:	90                   	nop
c0108865:	c9                   	leave  
c0108866:	c3                   	ret    

c0108867 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108867:	55                   	push   %ebp
c0108868:	89 e5                	mov    %esp,%ebp
c010886a:	56                   	push   %esi
c010886b:	53                   	push   %ebx
c010886c:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010886f:	eb 17                	jmp    c0108888 <vprintfmt+0x21>
            if (ch == '\0') {
c0108871:	85 db                	test   %ebx,%ebx
c0108873:	0f 84 bf 03 00 00    	je     c0108c38 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0108879:	8b 45 0c             	mov    0xc(%ebp),%eax
c010887c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108880:	89 1c 24             	mov    %ebx,(%esp)
c0108883:	8b 45 08             	mov    0x8(%ebp),%eax
c0108886:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108888:	8b 45 10             	mov    0x10(%ebp),%eax
c010888b:	8d 50 01             	lea    0x1(%eax),%edx
c010888e:	89 55 10             	mov    %edx,0x10(%ebp)
c0108891:	0f b6 00             	movzbl (%eax),%eax
c0108894:	0f b6 d8             	movzbl %al,%ebx
c0108897:	83 fb 25             	cmp    $0x25,%ebx
c010889a:	75 d5                	jne    c0108871 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010889c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01088a0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01088a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01088ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01088b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01088b7:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01088ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01088bd:	8d 50 01             	lea    0x1(%eax),%edx
c01088c0:	89 55 10             	mov    %edx,0x10(%ebp)
c01088c3:	0f b6 00             	movzbl (%eax),%eax
c01088c6:	0f b6 d8             	movzbl %al,%ebx
c01088c9:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01088cc:	83 f8 55             	cmp    $0x55,%eax
c01088cf:	0f 87 37 03 00 00    	ja     c0108c0c <vprintfmt+0x3a5>
c01088d5:	8b 04 85 a4 ac 10 c0 	mov    -0x3fef535c(,%eax,4),%eax
c01088dc:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01088de:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01088e2:	eb d6                	jmp    c01088ba <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01088e4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01088e8:	eb d0                	jmp    c01088ba <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01088ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01088f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01088f4:	89 d0                	mov    %edx,%eax
c01088f6:	c1 e0 02             	shl    $0x2,%eax
c01088f9:	01 d0                	add    %edx,%eax
c01088fb:	01 c0                	add    %eax,%eax
c01088fd:	01 d8                	add    %ebx,%eax
c01088ff:	83 e8 30             	sub    $0x30,%eax
c0108902:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108905:	8b 45 10             	mov    0x10(%ebp),%eax
c0108908:	0f b6 00             	movzbl (%eax),%eax
c010890b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010890e:	83 fb 2f             	cmp    $0x2f,%ebx
c0108911:	7e 38                	jle    c010894b <vprintfmt+0xe4>
c0108913:	83 fb 39             	cmp    $0x39,%ebx
c0108916:	7f 33                	jg     c010894b <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0108918:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010891b:	eb d4                	jmp    c01088f1 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010891d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108920:	8d 50 04             	lea    0x4(%eax),%edx
c0108923:	89 55 14             	mov    %edx,0x14(%ebp)
c0108926:	8b 00                	mov    (%eax),%eax
c0108928:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010892b:	eb 1f                	jmp    c010894c <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010892d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108931:	79 87                	jns    c01088ba <vprintfmt+0x53>
                width = 0;
c0108933:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010893a:	e9 7b ff ff ff       	jmp    c01088ba <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010893f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108946:	e9 6f ff ff ff       	jmp    c01088ba <vprintfmt+0x53>
            goto process_precision;
c010894b:	90                   	nop

        process_precision:
            if (width < 0)
c010894c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108950:	0f 89 64 ff ff ff    	jns    c01088ba <vprintfmt+0x53>
                width = precision, precision = -1;
c0108956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108959:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010895c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108963:	e9 52 ff ff ff       	jmp    c01088ba <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108968:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c010896b:	e9 4a ff ff ff       	jmp    c01088ba <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108970:	8b 45 14             	mov    0x14(%ebp),%eax
c0108973:	8d 50 04             	lea    0x4(%eax),%edx
c0108976:	89 55 14             	mov    %edx,0x14(%ebp)
c0108979:	8b 00                	mov    (%eax),%eax
c010897b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010897e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108982:	89 04 24             	mov    %eax,(%esp)
c0108985:	8b 45 08             	mov    0x8(%ebp),%eax
c0108988:	ff d0                	call   *%eax
            break;
c010898a:	e9 a4 02 00 00       	jmp    c0108c33 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010898f:	8b 45 14             	mov    0x14(%ebp),%eax
c0108992:	8d 50 04             	lea    0x4(%eax),%edx
c0108995:	89 55 14             	mov    %edx,0x14(%ebp)
c0108998:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010899a:	85 db                	test   %ebx,%ebx
c010899c:	79 02                	jns    c01089a0 <vprintfmt+0x139>
                err = -err;
c010899e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01089a0:	83 fb 06             	cmp    $0x6,%ebx
c01089a3:	7f 0b                	jg     c01089b0 <vprintfmt+0x149>
c01089a5:	8b 34 9d 64 ac 10 c0 	mov    -0x3fef539c(,%ebx,4),%esi
c01089ac:	85 f6                	test   %esi,%esi
c01089ae:	75 23                	jne    c01089d3 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01089b0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01089b4:	c7 44 24 08 91 ac 10 	movl   $0xc010ac91,0x8(%esp)
c01089bb:	c0 
c01089bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01089c6:	89 04 24             	mov    %eax,(%esp)
c01089c9:	e8 6a fe ff ff       	call   c0108838 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01089ce:	e9 60 02 00 00       	jmp    c0108c33 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01089d3:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01089d7:	c7 44 24 08 9a ac 10 	movl   $0xc010ac9a,0x8(%esp)
c01089de:	c0 
c01089df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e9:	89 04 24             	mov    %eax,(%esp)
c01089ec:	e8 47 fe ff ff       	call   c0108838 <printfmt>
            break;
c01089f1:	e9 3d 02 00 00       	jmp    c0108c33 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01089f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01089f9:	8d 50 04             	lea    0x4(%eax),%edx
c01089fc:	89 55 14             	mov    %edx,0x14(%ebp)
c01089ff:	8b 30                	mov    (%eax),%esi
c0108a01:	85 f6                	test   %esi,%esi
c0108a03:	75 05                	jne    c0108a0a <vprintfmt+0x1a3>
                p = "(null)";
c0108a05:	be 9d ac 10 c0       	mov    $0xc010ac9d,%esi
            }
            if (width > 0 && padc != '-') {
c0108a0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108a0e:	7e 76                	jle    c0108a86 <vprintfmt+0x21f>
c0108a10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108a14:	74 70                	je     c0108a86 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a1d:	89 34 24             	mov    %esi,(%esp)
c0108a20:	e8 f6 f7 ff ff       	call   c010821b <strnlen>
c0108a25:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108a28:	29 c2                	sub    %eax,%edx
c0108a2a:	89 d0                	mov    %edx,%eax
c0108a2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108a2f:	eb 16                	jmp    c0108a47 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0108a31:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108a35:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108a38:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108a3c:	89 04 24             	mov    %eax,(%esp)
c0108a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a42:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108a44:	ff 4d e8             	decl   -0x18(%ebp)
c0108a47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108a4b:	7f e4                	jg     c0108a31 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108a4d:	eb 37                	jmp    c0108a86 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108a4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108a53:	74 1f                	je     c0108a74 <vprintfmt+0x20d>
c0108a55:	83 fb 1f             	cmp    $0x1f,%ebx
c0108a58:	7e 05                	jle    c0108a5f <vprintfmt+0x1f8>
c0108a5a:	83 fb 7e             	cmp    $0x7e,%ebx
c0108a5d:	7e 15                	jle    c0108a74 <vprintfmt+0x20d>
                    putch('?', putdat);
c0108a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a66:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a70:	ff d0                	call   *%eax
c0108a72:	eb 0f                	jmp    c0108a83 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0108a74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a7b:	89 1c 24             	mov    %ebx,(%esp)
c0108a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a81:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108a83:	ff 4d e8             	decl   -0x18(%ebp)
c0108a86:	89 f0                	mov    %esi,%eax
c0108a88:	8d 70 01             	lea    0x1(%eax),%esi
c0108a8b:	0f b6 00             	movzbl (%eax),%eax
c0108a8e:	0f be d8             	movsbl %al,%ebx
c0108a91:	85 db                	test   %ebx,%ebx
c0108a93:	74 27                	je     c0108abc <vprintfmt+0x255>
c0108a95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108a99:	78 b4                	js     c0108a4f <vprintfmt+0x1e8>
c0108a9b:	ff 4d e4             	decl   -0x1c(%ebp)
c0108a9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108aa2:	79 ab                	jns    c0108a4f <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0108aa4:	eb 16                	jmp    c0108abc <vprintfmt+0x255>
                putch(' ', putdat);
c0108aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108aad:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ab7:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0108ab9:	ff 4d e8             	decl   -0x18(%ebp)
c0108abc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108ac0:	7f e4                	jg     c0108aa6 <vprintfmt+0x23f>
            }
            break;
c0108ac2:	e9 6c 01 00 00       	jmp    c0108c33 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108aca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ace:	8d 45 14             	lea    0x14(%ebp),%eax
c0108ad1:	89 04 24             	mov    %eax,(%esp)
c0108ad4:	e8 18 fd ff ff       	call   c01087f1 <getint>
c0108ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108ae5:	85 d2                	test   %edx,%edx
c0108ae7:	79 26                	jns    c0108b0f <vprintfmt+0x2a8>
                putch('-', putdat);
c0108ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108af0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0108af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afa:	ff d0                	call   *%eax
                num = -(long long)num;
c0108afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b02:	f7 d8                	neg    %eax
c0108b04:	83 d2 00             	adc    $0x0,%edx
c0108b07:	f7 da                	neg    %edx
c0108b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108b0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108b16:	e9 a8 00 00 00       	jmp    c0108bc3 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0108b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b22:	8d 45 14             	lea    0x14(%ebp),%eax
c0108b25:	89 04 24             	mov    %eax,(%esp)
c0108b28:	e8 75 fc ff ff       	call   c01087a2 <getuint>
c0108b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b30:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108b33:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108b3a:	e9 84 00 00 00       	jmp    c0108bc3 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b46:	8d 45 14             	lea    0x14(%ebp),%eax
c0108b49:	89 04 24             	mov    %eax,(%esp)
c0108b4c:	e8 51 fc ff ff       	call   c01087a2 <getuint>
c0108b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b54:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0108b57:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108b5e:	eb 63                	jmp    c0108bc3 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0108b60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b67:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b71:	ff d0                	call   *%eax
            putch('x', putdat);
c0108b73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b7a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b84:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108b86:	8b 45 14             	mov    0x14(%ebp),%eax
c0108b89:	8d 50 04             	lea    0x4(%eax),%edx
c0108b8c:	89 55 14             	mov    %edx,0x14(%ebp)
c0108b8f:	8b 00                	mov    (%eax),%eax
c0108b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108b9b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108ba2:	eb 1f                	jmp    c0108bc3 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bab:	8d 45 14             	lea    0x14(%ebp),%eax
c0108bae:	89 04 24             	mov    %eax,(%esp)
c0108bb1:	e8 ec fb ff ff       	call   c01087a2 <getuint>
c0108bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108bb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108bbc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108bc3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108bca:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108bce:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108bd1:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108bd5:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108bdf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108be3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108be7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bf1:	89 04 24             	mov    %eax,(%esp)
c0108bf4:	e8 a4 fa ff ff       	call   c010869d <printnum>
            break;
c0108bf9:	eb 38                	jmp    c0108c33 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c02:	89 1c 24             	mov    %ebx,(%esp)
c0108c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c08:	ff d0                	call   *%eax
            break;
c0108c0a:	eb 27                	jmp    c0108c33 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c13:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0108c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c1d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108c1f:	ff 4d 10             	decl   0x10(%ebp)
c0108c22:	eb 03                	jmp    c0108c27 <vprintfmt+0x3c0>
c0108c24:	ff 4d 10             	decl   0x10(%ebp)
c0108c27:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c2a:	48                   	dec    %eax
c0108c2b:	0f b6 00             	movzbl (%eax),%eax
c0108c2e:	3c 25                	cmp    $0x25,%al
c0108c30:	75 f2                	jne    c0108c24 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0108c32:	90                   	nop
    while (1) {
c0108c33:	e9 37 fc ff ff       	jmp    c010886f <vprintfmt+0x8>
                return;
c0108c38:	90                   	nop
        }
    }
}
c0108c39:	83 c4 40             	add    $0x40,%esp
c0108c3c:	5b                   	pop    %ebx
c0108c3d:	5e                   	pop    %esi
c0108c3e:	5d                   	pop    %ebp
c0108c3f:	c3                   	ret    

c0108c40 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108c40:	55                   	push   %ebp
c0108c41:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0108c43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c46:	8b 40 08             	mov    0x8(%eax),%eax
c0108c49:	8d 50 01             	lea    0x1(%eax),%edx
c0108c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c4f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0108c52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c55:	8b 10                	mov    (%eax),%edx
c0108c57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c5a:	8b 40 04             	mov    0x4(%eax),%eax
c0108c5d:	39 c2                	cmp    %eax,%edx
c0108c5f:	73 12                	jae    c0108c73 <sprintputch+0x33>
        *b->buf ++ = ch;
c0108c61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c64:	8b 00                	mov    (%eax),%eax
c0108c66:	8d 48 01             	lea    0x1(%eax),%ecx
c0108c69:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c6c:	89 0a                	mov    %ecx,(%edx)
c0108c6e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108c71:	88 10                	mov    %dl,(%eax)
    }
}
c0108c73:	90                   	nop
c0108c74:	5d                   	pop    %ebp
c0108c75:	c3                   	ret    

c0108c76 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108c76:	55                   	push   %ebp
c0108c77:	89 e5                	mov    %esp,%ebp
c0108c79:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108c7c:	8d 45 14             	lea    0x14(%ebp),%eax
c0108c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c85:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108c89:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c8c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c90:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c9a:	89 04 24             	mov    %eax,(%esp)
c0108c9d:	e8 08 00 00 00       	call   c0108caa <vsnprintf>
c0108ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0108ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108ca8:	c9                   	leave  
c0108ca9:	c3                   	ret    

c0108caa <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108caa:	55                   	push   %ebp
c0108cab:	89 e5                	mov    %esp,%ebp
c0108cad:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cb9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cbf:	01 d0                	add    %edx,%eax
c0108cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108ccb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108ccf:	74 0a                	je     c0108cdb <vsnprintf+0x31>
c0108cd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cd7:	39 c2                	cmp    %eax,%edx
c0108cd9:	76 07                	jbe    c0108ce2 <vsnprintf+0x38>
        return -E_INVAL;
c0108cdb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108ce0:	eb 2a                	jmp    c0108d0c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108ce2:	8b 45 14             	mov    0x14(%ebp),%eax
c0108ce5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108ce9:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cec:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108cf0:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cf7:	c7 04 24 40 8c 10 c0 	movl   $0xc0108c40,(%esp)
c0108cfe:	e8 64 fb ff ff       	call   c0108867 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0108d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d06:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108d0c:	c9                   	leave  
c0108d0d:	c3                   	ret    

c0108d0e <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108d0e:	55                   	push   %ebp
c0108d0f:	89 e5                	mov    %esp,%ebp
c0108d11:	57                   	push   %edi
c0108d12:	56                   	push   %esi
c0108d13:	53                   	push   %ebx
c0108d14:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108d17:	a1 58 0a 12 c0       	mov    0xc0120a58,%eax
c0108d1c:	8b 15 5c 0a 12 c0    	mov    0xc0120a5c,%edx
c0108d22:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108d28:	6b f0 05             	imul   $0x5,%eax,%esi
c0108d2b:	01 fe                	add    %edi,%esi
c0108d2d:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0108d32:	f7 e7                	mul    %edi
c0108d34:	01 d6                	add    %edx,%esi
c0108d36:	89 f2                	mov    %esi,%edx
c0108d38:	83 c0 0b             	add    $0xb,%eax
c0108d3b:	83 d2 00             	adc    $0x0,%edx
c0108d3e:	89 c7                	mov    %eax,%edi
c0108d40:	83 e7 ff             	and    $0xffffffff,%edi
c0108d43:	89 f9                	mov    %edi,%ecx
c0108d45:	0f b7 da             	movzwl %dx,%ebx
c0108d48:	89 0d 58 0a 12 c0    	mov    %ecx,0xc0120a58
c0108d4e:	89 1d 5c 0a 12 c0    	mov    %ebx,0xc0120a5c
    unsigned long long result = (next >> 12);
c0108d54:	8b 1d 58 0a 12 c0    	mov    0xc0120a58,%ebx
c0108d5a:	8b 35 5c 0a 12 c0    	mov    0xc0120a5c,%esi
c0108d60:	89 d8                	mov    %ebx,%eax
c0108d62:	89 f2                	mov    %esi,%edx
c0108d64:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0108d68:	c1 ea 0c             	shr    $0xc,%edx
c0108d6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108d6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108d71:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108d7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108d81:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108d8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108d8e:	74 1c                	je     c0108dac <rand+0x9e>
c0108d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d93:	ba 00 00 00 00       	mov    $0x0,%edx
c0108d98:	f7 75 dc             	divl   -0x24(%ebp)
c0108d9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108da1:	ba 00 00 00 00       	mov    $0x0,%edx
c0108da6:	f7 75 dc             	divl   -0x24(%ebp)
c0108da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108dac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108daf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108db2:	f7 75 dc             	divl   -0x24(%ebp)
c0108db5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108db8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108dbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108dbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108dc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108dc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108dc7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108dca:	83 c4 24             	add    $0x24,%esp
c0108dcd:	5b                   	pop    %ebx
c0108dce:	5e                   	pop    %esi
c0108dcf:	5f                   	pop    %edi
c0108dd0:	5d                   	pop    %ebp
c0108dd1:	c3                   	ret    

c0108dd2 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108dd2:	55                   	push   %ebp
c0108dd3:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108dd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dd8:	ba 00 00 00 00       	mov    $0x0,%edx
c0108ddd:	a3 58 0a 12 c0       	mov    %eax,0xc0120a58
c0108de2:	89 15 5c 0a 12 c0    	mov    %edx,0xc0120a5c
}
c0108de8:	90                   	nop
c0108de9:	5d                   	pop    %ebp
c0108dea:	c3                   	ret    

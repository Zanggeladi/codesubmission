
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 60 12 00       	mov    $0x126000,%eax
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
c0100020:	a3 00 60 12 c0       	mov    %eax,0xc0126000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 50 12 c0       	mov    $0xc0125000,%esp
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
c010003c:	ba 4c b1 12 c0       	mov    $0xc012b14c,%edx
c0100041:	b8 00 80 12 c0       	mov    $0xc0128000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 80 12 c0 	movl   $0xc0128000,(%esp)
c010005d:	e8 35 94 00 00       	call   c0109497 <memset>

    cons_init();                // init the console
c0100062:	e8 25 1d 00 00       	call   c0101d8c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 a0 9d 10 c0 	movl   $0xc0109da0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010007c:	e8 28 02 00 00       	call   c01002a9 <cprintf>

    print_kerninfo();
c0100081:	e8 c9 08 00 00       	call   c010094f <print_kerninfo>

    grade_backtrace();
c0100086:	e8 a0 00 00 00       	call   c010012b <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 61 71 00 00       	call   c01071f1 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 5c 1e 00 00       	call   c0101ef1 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 e1 1f 00 00       	call   c010207b <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 9b 34 00 00       	call   c010353a <vmm_init>
    proc_init();                // init process table
c010009f:	e8 ad 8d 00 00       	call   c0108e51 <proc_init>
    
    ide_init();                 // init ide devices
c01000a4:	e8 9b 0c 00 00       	call   c0100d44 <ide_init>
    swap_init();                // init swap
c01000a9:	e8 2f 3e 00 00       	call   c0103edd <swap_init>

    clock_init();               // init clock interrupt
c01000ae:	e8 7c 14 00 00       	call   c010152f <clock_init>
    intr_enable();              // enable irq interrupt
c01000b3:	e8 73 1f 00 00       	call   c010202b <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b8:	e8 51 8f 00 00       	call   c010900e <cpu_idle>

c01000bd <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000bd:	55                   	push   %ebp
c01000be:	89 e5                	mov    %esp,%ebp
c01000c0:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ca:	00 
c01000cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000d2:	00 
c01000d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000da:	e8 fa 0b 00 00       	call   c0100cd9 <mon_backtrace>
}
c01000df:	90                   	nop
c01000e0:	c9                   	leave  
c01000e1:	c3                   	ret    

c01000e2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000e2:	55                   	push   %ebp
c01000e3:	89 e5                	mov    %esp,%ebp
c01000e5:	53                   	push   %ebx
c01000e6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000ec:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000ef:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01000f5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000f9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0100101:	89 04 24             	mov    %eax,(%esp)
c0100104:	e8 b4 ff ff ff       	call   c01000bd <grade_backtrace2>
}
c0100109:	90                   	nop
c010010a:	83 c4 14             	add    $0x14,%esp
c010010d:	5b                   	pop    %ebx
c010010e:	5d                   	pop    %ebp
c010010f:	c3                   	ret    

c0100110 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100110:	55                   	push   %ebp
c0100111:	89 e5                	mov    %esp,%ebp
c0100113:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100116:	8b 45 10             	mov    0x10(%ebp),%eax
c0100119:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100120:	89 04 24             	mov    %eax,(%esp)
c0100123:	e8 ba ff ff ff       	call   c01000e2 <grade_backtrace1>
}
c0100128:	90                   	nop
c0100129:	c9                   	leave  
c010012a:	c3                   	ret    

c010012b <grade_backtrace>:

void
grade_backtrace(void) {
c010012b:	55                   	push   %ebp
c010012c:	89 e5                	mov    %esp,%ebp
c010012e:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100131:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100136:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010013d:	ff 
c010013e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100149:	e8 c2 ff ff ff       	call   c0100110 <grade_backtrace0>
}
c010014e:	90                   	nop
c010014f:	c9                   	leave  
c0100150:	c3                   	ret    

c0100151 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100151:	55                   	push   %ebp
c0100152:	89 e5                	mov    %esp,%ebp
c0100154:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100157:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010015a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010015d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100160:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100163:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100167:	83 e0 03             	and    $0x3,%eax
c010016a:	89 c2                	mov    %eax,%edx
c010016c:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c0100171:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100175:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100179:	c7 04 24 c1 9d 10 c0 	movl   $0xc0109dc1,(%esp)
c0100180:	e8 24 01 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100185:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100189:	89 c2                	mov    %eax,%edx
c010018b:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c0100190:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100194:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100198:	c7 04 24 cf 9d 10 c0 	movl   $0xc0109dcf,(%esp)
c010019f:	e8 05 01 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c01001a4:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a8:	89 c2                	mov    %eax,%edx
c01001aa:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c01001af:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b7:	c7 04 24 dd 9d 10 c0 	movl   $0xc0109ddd,(%esp)
c01001be:	e8 e6 00 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001c3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c7:	89 c2                	mov    %eax,%edx
c01001c9:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c01001ce:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d6:	c7 04 24 eb 9d 10 c0 	movl   $0xc0109deb,(%esp)
c01001dd:	e8 c7 00 00 00       	call   c01002a9 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001e2:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e6:	89 c2                	mov    %eax,%edx
c01001e8:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c01001ed:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f5:	c7 04 24 f9 9d 10 c0 	movl   $0xc0109df9,(%esp)
c01001fc:	e8 a8 00 00 00       	call   c01002a9 <cprintf>
    round ++;
c0100201:	a1 00 80 12 c0       	mov    0xc0128000,%eax
c0100206:	40                   	inc    %eax
c0100207:	a3 00 80 12 c0       	mov    %eax,0xc0128000
}
c010020c:	90                   	nop
c010020d:	c9                   	leave  
c010020e:	c3                   	ret    

c010020f <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020f:	55                   	push   %ebp
c0100210:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100212:	90                   	nop
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100218:	90                   	nop
c0100219:	5d                   	pop    %ebp
c010021a:	c3                   	ret    

c010021b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010021b:	55                   	push   %ebp
c010021c:	89 e5                	mov    %esp,%ebp
c010021e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100221:	e8 2b ff ff ff       	call   c0100151 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100226:	c7 04 24 08 9e 10 c0 	movl   $0xc0109e08,(%esp)
c010022d:	e8 77 00 00 00       	call   c01002a9 <cprintf>
    lab1_switch_to_user();
c0100232:	e8 d8 ff ff ff       	call   c010020f <lab1_switch_to_user>
    lab1_print_cur_status();
c0100237:	e8 15 ff ff ff       	call   c0100151 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010023c:	c7 04 24 28 9e 10 c0 	movl   $0xc0109e28,(%esp)
c0100243:	e8 61 00 00 00       	call   c01002a9 <cprintf>
    lab1_switch_to_kernel();
c0100248:	e8 c8 ff ff ff       	call   c0100215 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010024d:	e8 ff fe ff ff       	call   c0100151 <lab1_print_cur_status>
}
c0100252:	90                   	nop
c0100253:	c9                   	leave  
c0100254:	c3                   	ret    

c0100255 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100255:	55                   	push   %ebp
c0100256:	89 e5                	mov    %esp,%ebp
c0100258:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010025b:	8b 45 08             	mov    0x8(%ebp),%eax
c010025e:	89 04 24             	mov    %eax,(%esp)
c0100261:	e8 53 1b 00 00       	call   c0101db9 <cons_putc>
    (*cnt) ++;
c0100266:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100269:	8b 00                	mov    (%eax),%eax
c010026b:	8d 50 01             	lea    0x1(%eax),%edx
c010026e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100271:	89 10                	mov    %edx,(%eax)
}
c0100273:	90                   	nop
c0100274:	c9                   	leave  
c0100275:	c3                   	ret    

c0100276 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100276:	55                   	push   %ebp
c0100277:	89 e5                	mov    %esp,%ebp
c0100279:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010027c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100286:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010028a:	8b 45 08             	mov    0x8(%ebp),%eax
c010028d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100291:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100294:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100298:	c7 04 24 55 02 10 c0 	movl   $0xc0100255,(%esp)
c010029f:	e8 46 95 00 00       	call   c01097ea <vprintfmt>
    return cnt;
c01002a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002a7:	c9                   	leave  
c01002a8:	c3                   	ret    

c01002a9 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002a9:	55                   	push   %ebp
c01002aa:	89 e5                	mov    %esp,%ebp
c01002ac:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002af:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002bf:	89 04 24             	mov    %eax,(%esp)
c01002c2:	e8 af ff ff ff       	call   c0100276 <vcprintf>
c01002c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002cd:	c9                   	leave  
c01002ce:	c3                   	ret    

c01002cf <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002cf:	55                   	push   %ebp
c01002d0:	89 e5                	mov    %esp,%ebp
c01002d2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d8:	89 04 24             	mov    %eax,(%esp)
c01002db:	e8 d9 1a 00 00       	call   c0101db9 <cons_putc>
}
c01002e0:	90                   	nop
c01002e1:	c9                   	leave  
c01002e2:	c3                   	ret    

c01002e3 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002e3:	55                   	push   %ebp
c01002e4:	89 e5                	mov    %esp,%ebp
c01002e6:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002f0:	eb 13                	jmp    c0100305 <cputs+0x22>
        cputch(c, &cnt);
c01002f2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002f6:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 50 ff ff ff       	call   c0100255 <cputch>
    while ((c = *str ++) != '\0') {
c0100305:	8b 45 08             	mov    0x8(%ebp),%eax
c0100308:	8d 50 01             	lea    0x1(%eax),%edx
c010030b:	89 55 08             	mov    %edx,0x8(%ebp)
c010030e:	0f b6 00             	movzbl (%eax),%eax
c0100311:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100314:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100318:	75 d8                	jne    c01002f2 <cputs+0xf>
    }
    cputch('\n', &cnt);
c010031a:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010031d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100321:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100328:	e8 28 ff ff ff       	call   c0100255 <cputch>
    return cnt;
c010032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100330:	c9                   	leave  
c0100331:	c3                   	ret    

c0100332 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100332:	55                   	push   %ebp
c0100333:	89 e5                	mov    %esp,%ebp
c0100335:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100338:	e8 b9 1a 00 00       	call   c0101df6 <cons_getc>
c010033d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100344:	74 f2                	je     c0100338 <getchar+0x6>
        /* do nothing */;
    return c;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100355:	74 13                	je     c010036a <readline+0x1f>
        cprintf("%s", prompt);
c0100357:	8b 45 08             	mov    0x8(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	c7 04 24 47 9e 10 c0 	movl   $0xc0109e47,(%esp)
c0100365:	e8 3f ff ff ff       	call   c01002a9 <cprintf>
    }
    int i = 0, c;
c010036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100371:	e8 bc ff ff ff       	call   c0100332 <getchar>
c0100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010037d:	79 07                	jns    c0100386 <readline+0x3b>
            return NULL;
c010037f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100384:	eb 78                	jmp    c01003fe <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010038a:	7e 28                	jle    c01003b4 <readline+0x69>
c010038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100393:	7f 1f                	jg     c01003b4 <readline+0x69>
            cputchar(c);
c0100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100398:	89 04 24             	mov    %eax,(%esp)
c010039b:	e8 2f ff ff ff       	call   c01002cf <cputchar>
            buf[i ++] = c;
c01003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003a3:	8d 50 01             	lea    0x1(%eax),%edx
c01003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003ac:	88 90 20 80 12 c0    	mov    %dl,-0x3fed7fe0(%eax)
c01003b2:	eb 45                	jmp    c01003f9 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003b8:	75 16                	jne    c01003d0 <readline+0x85>
c01003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003be:	7e 10                	jle    c01003d0 <readline+0x85>
            cputchar(c);
c01003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c3:	89 04 24             	mov    %eax,(%esp)
c01003c6:	e8 04 ff ff ff       	call   c01002cf <cputchar>
            i --;
c01003cb:	ff 4d f4             	decl   -0xc(%ebp)
c01003ce:	eb 29                	jmp    c01003f9 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003d4:	74 06                	je     c01003dc <readline+0x91>
c01003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003da:	75 95                	jne    c0100371 <readline+0x26>
            cputchar(c);
c01003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003df:	89 04 24             	mov    %eax,(%esp)
c01003e2:	e8 e8 fe ff ff       	call   c01002cf <cputchar>
            buf[i] = '\0';
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ea:	05 20 80 12 c0       	add    $0xc0128020,%eax
c01003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003f2:	b8 20 80 12 c0       	mov    $0xc0128020,%eax
c01003f7:	eb 05                	jmp    c01003fe <readline+0xb3>
        c = getchar();
c01003f9:	e9 73 ff ff ff       	jmp    c0100371 <readline+0x26>
        }
    }
}
c01003fe:	c9                   	leave  
c01003ff:	c3                   	ret    

c0100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100400:	55                   	push   %ebp
c0100401:	89 e5                	mov    %esp,%ebp
c0100403:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100406:	a1 20 84 12 c0       	mov    0xc0128420,%eax
c010040b:	85 c0                	test   %eax,%eax
c010040d:	75 5b                	jne    c010046a <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c010040f:	c7 05 20 84 12 c0 01 	movl   $0x1,0xc0128420
c0100416:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100419:	8d 45 14             	lea    0x14(%ebp),%eax
c010041c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c010041f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100422:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100426:	8b 45 08             	mov    0x8(%ebp),%eax
c0100429:	89 44 24 04          	mov    %eax,0x4(%esp)
c010042d:	c7 04 24 4a 9e 10 c0 	movl   $0xc0109e4a,(%esp)
c0100434:	e8 70 fe ff ff       	call   c01002a9 <cprintf>
    vcprintf(fmt, ap);
c0100439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010043c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100440:	8b 45 10             	mov    0x10(%ebp),%eax
c0100443:	89 04 24             	mov    %eax,(%esp)
c0100446:	e8 2b fe ff ff       	call   c0100276 <vcprintf>
    cprintf("\n");
c010044b:	c7 04 24 66 9e 10 c0 	movl   $0xc0109e66,(%esp)
c0100452:	e8 52 fe ff ff       	call   c01002a9 <cprintf>
    
    cprintf("stack trackback:\n");
c0100457:	c7 04 24 68 9e 10 c0 	movl   $0xc0109e68,(%esp)
c010045e:	e8 46 fe ff ff       	call   c01002a9 <cprintf>
    print_stackframe();
c0100463:	e8 32 06 00 00       	call   c0100a9a <print_stackframe>
c0100468:	eb 01                	jmp    c010046b <__panic+0x6b>
        goto panic_dead;
c010046a:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c010046b:	e8 c2 1b 00 00       	call   c0102032 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100477:	e8 90 07 00 00       	call   c0100c0c <kmonitor>
c010047c:	eb f2                	jmp    c0100470 <__panic+0x70>

c010047e <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010047e:	55                   	push   %ebp
c010047f:	89 e5                	mov    %esp,%ebp
c0100481:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100484:	8d 45 14             	lea    0x14(%ebp),%eax
c0100487:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100491:	8b 45 08             	mov    0x8(%ebp),%eax
c0100494:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100498:	c7 04 24 7a 9e 10 c0 	movl   $0xc0109e7a,(%esp)
c010049f:	e8 05 fe ff ff       	call   c01002a9 <cprintf>
    vcprintf(fmt, ap);
c01004a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01004a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ae:	89 04 24             	mov    %eax,(%esp)
c01004b1:	e8 c0 fd ff ff       	call   c0100276 <vcprintf>
    cprintf("\n");
c01004b6:	c7 04 24 66 9e 10 c0 	movl   $0xc0109e66,(%esp)
c01004bd:	e8 e7 fd ff ff       	call   c01002a9 <cprintf>
    va_end(ap);
}
c01004c2:	90                   	nop
c01004c3:	c9                   	leave  
c01004c4:	c3                   	ret    

c01004c5 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004c5:	55                   	push   %ebp
c01004c6:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004c8:	a1 20 84 12 c0       	mov    0xc0128420,%eax
}
c01004cd:	5d                   	pop    %ebp
c01004ce:	c3                   	ret    

c01004cf <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004cf:	55                   	push   %ebp
c01004d0:	89 e5                	mov    %esp,%ebp
c01004d2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d8:	8b 00                	mov    (%eax),%eax
c01004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e0:	8b 00                	mov    (%eax),%eax
c01004e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004ec:	e9 ca 00 00 00       	jmp    c01005bb <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004f7:	01 d0                	add    %edx,%eax
c01004f9:	89 c2                	mov    %eax,%edx
c01004fb:	c1 ea 1f             	shr    $0x1f,%edx
c01004fe:	01 d0                	add    %edx,%eax
c0100500:	d1 f8                	sar    %eax
c0100502:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100505:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100508:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010050b:	eb 03                	jmp    c0100510 <stab_binsearch+0x41>
            m --;
c010050d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100510:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100513:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100516:	7c 1f                	jl     c0100537 <stab_binsearch+0x68>
c0100518:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010051b:	89 d0                	mov    %edx,%eax
c010051d:	01 c0                	add    %eax,%eax
c010051f:	01 d0                	add    %edx,%eax
c0100521:	c1 e0 02             	shl    $0x2,%eax
c0100524:	89 c2                	mov    %eax,%edx
c0100526:	8b 45 08             	mov    0x8(%ebp),%eax
c0100529:	01 d0                	add    %edx,%eax
c010052b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052f:	0f b6 c0             	movzbl %al,%eax
c0100532:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100535:	75 d6                	jne    c010050d <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100537:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010053a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010053d:	7d 09                	jge    c0100548 <stab_binsearch+0x79>
            l = true_m + 1;
c010053f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100542:	40                   	inc    %eax
c0100543:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100546:	eb 73                	jmp    c01005bb <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100548:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100552:	89 d0                	mov    %edx,%eax
c0100554:	01 c0                	add    %eax,%eax
c0100556:	01 d0                	add    %edx,%eax
c0100558:	c1 e0 02             	shl    $0x2,%eax
c010055b:	89 c2                	mov    %eax,%edx
c010055d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	8b 40 08             	mov    0x8(%eax),%eax
c0100565:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100568:	76 11                	jbe    c010057b <stab_binsearch+0xac>
            *region_left = m;
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100570:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100572:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100575:	40                   	inc    %eax
c0100576:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100579:	eb 40                	jmp    c01005bb <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c010057b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010057e:	89 d0                	mov    %edx,%eax
c0100580:	01 c0                	add    %eax,%eax
c0100582:	01 d0                	add    %edx,%eax
c0100584:	c1 e0 02             	shl    $0x2,%eax
c0100587:	89 c2                	mov    %eax,%edx
c0100589:	8b 45 08             	mov    0x8(%ebp),%eax
c010058c:	01 d0                	add    %edx,%eax
c010058e:	8b 40 08             	mov    0x8(%eax),%eax
c0100591:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100594:	73 14                	jae    c01005aa <stab_binsearch+0xdb>
            *region_right = m - 1;
c0100596:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100599:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059c:	8b 45 10             	mov    0x10(%ebp),%eax
c010059f:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005a4:	48                   	dec    %eax
c01005a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a8:	eb 11                	jmp    c01005bb <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b0:	89 10                	mov    %edx,(%eax)
            l = m;
c01005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005c1:	0f 8e 2a ff ff ff    	jle    c01004f1 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005cb:	75 0f                	jne    c01005dc <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d0:	8b 00                	mov    (%eax),%eax
c01005d2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005da:	eb 3e                	jmp    c010061a <stab_binsearch+0x14b>
        l = *region_right;
c01005dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01005df:	8b 00                	mov    (%eax),%eax
c01005e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e4:	eb 03                	jmp    c01005e9 <stab_binsearch+0x11a>
c01005e6:	ff 4d fc             	decl   -0x4(%ebp)
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	8b 00                	mov    (%eax),%eax
c01005ee:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005f1:	7e 1f                	jle    c0100612 <stab_binsearch+0x143>
c01005f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f6:	89 d0                	mov    %edx,%eax
c01005f8:	01 c0                	add    %eax,%eax
c01005fa:	01 d0                	add    %edx,%eax
c01005fc:	c1 e0 02             	shl    $0x2,%eax
c01005ff:	89 c2                	mov    %eax,%edx
c0100601:	8b 45 08             	mov    0x8(%ebp),%eax
c0100604:	01 d0                	add    %edx,%eax
c0100606:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010060a:	0f b6 c0             	movzbl %al,%eax
c010060d:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100610:	75 d4                	jne    c01005e6 <stab_binsearch+0x117>
        *region_left = l;
c0100612:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100615:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100618:	89 10                	mov    %edx,(%eax)
}
c010061a:	90                   	nop
c010061b:	c9                   	leave  
c010061c:	c3                   	ret    

c010061d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010061d:	55                   	push   %ebp
c010061e:	89 e5                	mov    %esp,%ebp
c0100620:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100626:	c7 00 98 9e 10 c0    	movl   $0xc0109e98,(%eax)
    info->eip_line = 0;
c010062c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100636:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100639:	c7 40 08 98 9e 10 c0 	movl   $0xc0109e98,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100640:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100643:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010064a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064d:	8b 55 08             	mov    0x8(%ebp),%edx
c0100650:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100653:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100656:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010065d:	c7 45 f4 78 c0 10 c0 	movl   $0xc010c078,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100664:	c7 45 f0 dc dc 11 c0 	movl   $0xc011dcdc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010066b:	c7 45 ec dd dc 11 c0 	movl   $0xc011dcdd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100672:	c7 45 e8 9a 25 12 c0 	movl   $0xc012259a,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100679:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010067f:	76 0b                	jbe    c010068c <debuginfo_eip+0x6f>
c0100681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100684:	48                   	dec    %eax
c0100685:	0f b6 00             	movzbl (%eax),%eax
c0100688:	84 c0                	test   %al,%al
c010068a:	74 0a                	je     c0100696 <debuginfo_eip+0x79>
        return -1;
c010068c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100691:	e9 b7 02 00 00       	jmp    c010094d <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100696:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010069d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a3:	29 c2                	sub    %eax,%edx
c01006a5:	89 d0                	mov    %edx,%eax
c01006a7:	c1 f8 02             	sar    $0x2,%eax
c01006aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b0:	48                   	dec    %eax
c01006b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c2:	00 
c01006c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d4:	89 04 24             	mov    %eax,(%esp)
c01006d7:	e8 f3 fd ff ff       	call   c01004cf <stab_binsearch>
    if (lfile == 0)
c01006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006df:	85 c0                	test   %eax,%eax
c01006e1:	75 0a                	jne    c01006ed <debuginfo_eip+0xd0>
        return -1;
c01006e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006e8:	e9 60 02 00 00       	jmp    c010094d <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fc:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100700:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100707:	00 
c0100708:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010070b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100719:	89 04 24             	mov    %eax,(%esp)
c010071c:	e8 ae fd ff ff       	call   c01004cf <stab_binsearch>

    if (lfun <= rfun) {
c0100721:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100724:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100727:	39 c2                	cmp    %eax,%edx
c0100729:	7f 7c                	jg     c01007a7 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010072e:	89 c2                	mov    %eax,%edx
c0100730:	89 d0                	mov    %edx,%eax
c0100732:	01 c0                	add    %eax,%eax
c0100734:	01 d0                	add    %edx,%eax
c0100736:	c1 e0 02             	shl    $0x2,%eax
c0100739:	89 c2                	mov    %eax,%edx
c010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073e:	01 d0                	add    %edx,%eax
c0100740:	8b 00                	mov    (%eax),%eax
c0100742:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100745:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100748:	29 d1                	sub    %edx,%ecx
c010074a:	89 ca                	mov    %ecx,%edx
c010074c:	39 d0                	cmp    %edx,%eax
c010074e:	73 22                	jae    c0100772 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100750:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	89 d0                	mov    %edx,%eax
c0100757:	01 c0                	add    %eax,%eax
c0100759:	01 d0                	add    %edx,%eax
c010075b:	c1 e0 02             	shl    $0x2,%eax
c010075e:	89 c2                	mov    %eax,%edx
c0100760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100763:	01 d0                	add    %edx,%eax
c0100765:	8b 10                	mov    (%eax),%edx
c0100767:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010076a:	01 c2                	add    %eax,%edx
c010076c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100772:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100775:	89 c2                	mov    %eax,%edx
c0100777:	89 d0                	mov    %edx,%eax
c0100779:	01 c0                	add    %eax,%eax
c010077b:	01 d0                	add    %edx,%eax
c010077d:	c1 e0 02             	shl    $0x2,%eax
c0100780:	89 c2                	mov    %eax,%edx
c0100782:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100785:	01 d0                	add    %edx,%eax
c0100787:	8b 50 08             	mov    0x8(%eax),%edx
c010078a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100790:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100793:	8b 40 10             	mov    0x10(%eax),%eax
c0100796:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100799:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010079f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a5:	eb 15                	jmp    c01007bc <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bf:	8b 40 08             	mov    0x8(%eax),%eax
c01007c2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007c9:	00 
c01007ca:	89 04 24             	mov    %eax,(%esp)
c01007cd:	e8 41 8b 00 00       	call   c0109313 <strfind>
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d7:	8b 40 08             	mov    0x8(%eax),%eax
c01007da:	29 c2                	sub    %eax,%edx
c01007dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007df:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007e9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007f0:	00 
c01007f1:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100802:	89 04 24             	mov    %eax,(%esp)
c0100805:	e8 c5 fc ff ff       	call   c01004cf <stab_binsearch>
    if (lline <= rline) {
c010080a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100810:	39 c2                	cmp    %eax,%edx
c0100812:	7f 23                	jg     c0100837 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c0100814:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100817:	89 c2                	mov    %eax,%edx
c0100819:	89 d0                	mov    %edx,%eax
c010081b:	01 c0                	add    %eax,%eax
c010081d:	01 d0                	add    %edx,%eax
c010081f:	c1 e0 02             	shl    $0x2,%eax
c0100822:	89 c2                	mov    %eax,%edx
c0100824:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100827:	01 d0                	add    %edx,%eax
c0100829:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100832:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100835:	eb 11                	jmp    c0100848 <debuginfo_eip+0x22b>
        return -1;
c0100837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083c:	e9 0c 01 00 00       	jmp    c010094d <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100844:	48                   	dec    %eax
c0100845:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100848:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084e:	39 c2                	cmp    %eax,%edx
c0100850:	7c 56                	jl     c01008a8 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c0100852:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100855:	89 c2                	mov    %eax,%edx
c0100857:	89 d0                	mov    %edx,%eax
c0100859:	01 c0                	add    %eax,%eax
c010085b:	01 d0                	add    %edx,%eax
c010085d:	c1 e0 02             	shl    $0x2,%eax
c0100860:	89 c2                	mov    %eax,%edx
c0100862:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100865:	01 d0                	add    %edx,%eax
c0100867:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086b:	3c 84                	cmp    $0x84,%al
c010086d:	74 39                	je     c01008a8 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010086f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100872:	89 c2                	mov    %eax,%edx
c0100874:	89 d0                	mov    %edx,%eax
c0100876:	01 c0                	add    %eax,%eax
c0100878:	01 d0                	add    %edx,%eax
c010087a:	c1 e0 02             	shl    $0x2,%eax
c010087d:	89 c2                	mov    %eax,%edx
c010087f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100882:	01 d0                	add    %edx,%eax
c0100884:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100888:	3c 64                	cmp    $0x64,%al
c010088a:	75 b5                	jne    c0100841 <debuginfo_eip+0x224>
c010088c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010088f:	89 c2                	mov    %eax,%edx
c0100891:	89 d0                	mov    %edx,%eax
c0100893:	01 c0                	add    %eax,%eax
c0100895:	01 d0                	add    %edx,%eax
c0100897:	c1 e0 02             	shl    $0x2,%eax
c010089a:	89 c2                	mov    %eax,%edx
c010089c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	8b 40 08             	mov    0x8(%eax),%eax
c01008a4:	85 c0                	test   %eax,%eax
c01008a6:	74 99                	je     c0100841 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008ae:	39 c2                	cmp    %eax,%edx
c01008b0:	7c 46                	jl     c01008f8 <debuginfo_eip+0x2db>
c01008b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b5:	89 c2                	mov    %eax,%edx
c01008b7:	89 d0                	mov    %edx,%eax
c01008b9:	01 c0                	add    %eax,%eax
c01008bb:	01 d0                	add    %edx,%eax
c01008bd:	c1 e0 02             	shl    $0x2,%eax
c01008c0:	89 c2                	mov    %eax,%edx
c01008c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c5:	01 d0                	add    %edx,%eax
c01008c7:	8b 00                	mov    (%eax),%eax
c01008c9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008cf:	29 d1                	sub    %edx,%ecx
c01008d1:	89 ca                	mov    %ecx,%edx
c01008d3:	39 d0                	cmp    %edx,%eax
c01008d5:	73 21                	jae    c01008f8 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008da:	89 c2                	mov    %eax,%edx
c01008dc:	89 d0                	mov    %edx,%eax
c01008de:	01 c0                	add    %eax,%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	c1 e0 02             	shl    $0x2,%eax
c01008e5:	89 c2                	mov    %eax,%edx
c01008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ea:	01 d0                	add    %edx,%eax
c01008ec:	8b 10                	mov    (%eax),%edx
c01008ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f1:	01 c2                	add    %eax,%edx
c01008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f6:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008fe:	39 c2                	cmp    %eax,%edx
c0100900:	7d 46                	jge    c0100948 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c0100902:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100905:	40                   	inc    %eax
c0100906:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100909:	eb 16                	jmp    c0100921 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010090b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010090e:	8b 40 14             	mov    0x14(%eax),%eax
c0100911:	8d 50 01             	lea    0x1(%eax),%edx
c0100914:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100917:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c010091a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010091d:	40                   	inc    %eax
c010091e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100921:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100924:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100927:	39 c2                	cmp    %eax,%edx
c0100929:	7d 1d                	jge    c0100948 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010092b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010092e:	89 c2                	mov    %eax,%edx
c0100930:	89 d0                	mov    %edx,%eax
c0100932:	01 c0                	add    %eax,%eax
c0100934:	01 d0                	add    %edx,%eax
c0100936:	c1 e0 02             	shl    $0x2,%eax
c0100939:	89 c2                	mov    %eax,%edx
c010093b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010093e:	01 d0                	add    %edx,%eax
c0100940:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100944:	3c a0                	cmp    $0xa0,%al
c0100946:	74 c3                	je     c010090b <debuginfo_eip+0x2ee>
        }
    }
    return 0;
c0100948:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010094d:	c9                   	leave  
c010094e:	c3                   	ret    

c010094f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010094f:	55                   	push   %ebp
c0100950:	89 e5                	mov    %esp,%ebp
c0100952:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100955:	c7 04 24 a2 9e 10 c0 	movl   $0xc0109ea2,(%esp)
c010095c:	e8 48 f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100961:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100968:	c0 
c0100969:	c7 04 24 bb 9e 10 c0 	movl   $0xc0109ebb,(%esp)
c0100970:	e8 34 f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100975:	c7 44 24 04 93 9d 10 	movl   $0xc0109d93,0x4(%esp)
c010097c:	c0 
c010097d:	c7 04 24 d3 9e 10 c0 	movl   $0xc0109ed3,(%esp)
c0100984:	e8 20 f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100989:	c7 44 24 04 00 80 12 	movl   $0xc0128000,0x4(%esp)
c0100990:	c0 
c0100991:	c7 04 24 eb 9e 10 c0 	movl   $0xc0109eeb,(%esp)
c0100998:	e8 0c f9 ff ff       	call   c01002a9 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c010099d:	c7 44 24 04 4c b1 12 	movl   $0xc012b14c,0x4(%esp)
c01009a4:	c0 
c01009a5:	c7 04 24 03 9f 10 c0 	movl   $0xc0109f03,(%esp)
c01009ac:	e8 f8 f8 ff ff       	call   c01002a9 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009b1:	b8 4c b1 12 c0       	mov    $0xc012b14c,%eax
c01009b6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009bc:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009c1:	29 c2                	sub    %eax,%edx
c01009c3:	89 d0                	mov    %edx,%eax
c01009c5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009cb:	85 c0                	test   %eax,%eax
c01009cd:	0f 48 c2             	cmovs  %edx,%eax
c01009d0:	c1 f8 0a             	sar    $0xa,%eax
c01009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d7:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01009de:	e8 c6 f8 ff ff       	call   c01002a9 <cprintf>
}
c01009e3:	90                   	nop
c01009e4:	c9                   	leave  
c01009e5:	c3                   	ret    

c01009e6 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009e6:	55                   	push   %ebp
c01009e7:	89 e5                	mov    %esp,%ebp
c01009e9:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009ef:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f9:	89 04 24             	mov    %eax,(%esp)
c01009fc:	e8 1c fc ff ff       	call   c010061d <debuginfo_eip>
c0100a01:	85 c0                	test   %eax,%eax
c0100a03:	74 15                	je     c0100a1a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0c:	c7 04 24 46 9f 10 c0 	movl   $0xc0109f46,(%esp)
c0100a13:	e8 91 f8 ff ff       	call   c01002a9 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a18:	eb 6c                	jmp    c0100a86 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a21:	eb 1b                	jmp    c0100a3e <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a29:	01 d0                	add    %edx,%eax
c0100a2b:	0f b6 00             	movzbl (%eax),%eax
c0100a2e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a37:	01 ca                	add    %ecx,%edx
c0100a39:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a3b:	ff 45 f4             	incl   -0xc(%ebp)
c0100a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a41:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a44:	7c dd                	jl     c0100a23 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a46:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4f:	01 d0                	add    %edx,%eax
c0100a51:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a57:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a5a:	89 d1                	mov    %edx,%ecx
c0100a5c:	29 c1                	sub    %eax,%ecx
c0100a5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a64:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a68:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a6e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a72:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a7a:	c7 04 24 62 9f 10 c0 	movl   $0xc0109f62,(%esp)
c0100a81:	e8 23 f8 ff ff       	call   c01002a9 <cprintf>
}
c0100a86:	90                   	nop
c0100a87:	c9                   	leave  
c0100a88:	c3                   	ret    

c0100a89 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a89:	55                   	push   %ebp
c0100a8a:	89 e5                	mov    %esp,%ebp
c0100a8c:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a8f:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a92:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a98:	c9                   	leave  
c0100a99:	c3                   	ret    

c0100a9a <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a9a:	55                   	push   %ebp
c0100a9b:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a9d:	90                   	nop
c0100a9e:	5d                   	pop    %ebp
c0100a9f:	c3                   	ret    

c0100aa0 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aa0:	55                   	push   %ebp
c0100aa1:	89 e5                	mov    %esp,%ebp
c0100aa3:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100aa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aad:	eb 0c                	jmp    c0100abb <parse+0x1b>
            *buf ++ = '\0';
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	8d 50 01             	lea    0x1(%eax),%edx
c0100ab5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ab8:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	74 1d                	je     c0100ae2 <parse+0x42>
c0100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac8:	0f b6 00             	movzbl (%eax),%eax
c0100acb:	0f be c0             	movsbl %al,%eax
c0100ace:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad2:	c7 04 24 f4 9f 10 c0 	movl   $0xc0109ff4,(%esp)
c0100ad9:	e8 03 88 00 00       	call   c01092e1 <strchr>
c0100ade:	85 c0                	test   %eax,%eax
c0100ae0:	75 cd                	jne    c0100aaf <parse+0xf>
        }
        if (*buf == '\0') {
c0100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae5:	0f b6 00             	movzbl (%eax),%eax
c0100ae8:	84 c0                	test   %al,%al
c0100aea:	74 65                	je     c0100b51 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100aec:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100af0:	75 14                	jne    c0100b06 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100af2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100af9:	00 
c0100afa:	c7 04 24 f9 9f 10 c0 	movl   $0xc0109ff9,(%esp)
c0100b01:	e8 a3 f7 ff ff       	call   c01002a9 <cprintf>
        }
        argv[argc ++] = buf;
c0100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b09:	8d 50 01             	lea    0x1(%eax),%edx
c0100b0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b19:	01 c2                	add    %eax,%edx
c0100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b20:	eb 03                	jmp    c0100b25 <parse+0x85>
            buf ++;
c0100b22:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b28:	0f b6 00             	movzbl (%eax),%eax
c0100b2b:	84 c0                	test   %al,%al
c0100b2d:	74 8c                	je     c0100abb <parse+0x1b>
c0100b2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b32:	0f b6 00             	movzbl (%eax),%eax
c0100b35:	0f be c0             	movsbl %al,%eax
c0100b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3c:	c7 04 24 f4 9f 10 c0 	movl   $0xc0109ff4,(%esp)
c0100b43:	e8 99 87 00 00       	call   c01092e1 <strchr>
c0100b48:	85 c0                	test   %eax,%eax
c0100b4a:	74 d6                	je     c0100b22 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b4c:	e9 6a ff ff ff       	jmp    c0100abb <parse+0x1b>
            break;
c0100b51:	90                   	nop
        }
    }
    return argc;
c0100b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b55:	c9                   	leave  
c0100b56:	c3                   	ret    

c0100b57 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b57:	55                   	push   %ebp
c0100b58:	89 e5                	mov    %esp,%ebp
c0100b5a:	53                   	push   %ebx
c0100b5b:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b5e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b68:	89 04 24             	mov    %eax,(%esp)
c0100b6b:	e8 30 ff ff ff       	call   c0100aa0 <parse>
c0100b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b77:	75 0a                	jne    c0100b83 <runcmd+0x2c>
        return 0;
c0100b79:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b7e:	e9 83 00 00 00       	jmp    c0100c06 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b8a:	eb 5a                	jmp    c0100be6 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b8c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b92:	89 d0                	mov    %edx,%eax
c0100b94:	01 c0                	add    %eax,%eax
c0100b96:	01 d0                	add    %edx,%eax
c0100b98:	c1 e0 02             	shl    $0x2,%eax
c0100b9b:	05 00 50 12 c0       	add    $0xc0125000,%eax
c0100ba0:	8b 00                	mov    (%eax),%eax
c0100ba2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ba6:	89 04 24             	mov    %eax,(%esp)
c0100ba9:	e8 96 86 00 00       	call   c0109244 <strcmp>
c0100bae:	85 c0                	test   %eax,%eax
c0100bb0:	75 31                	jne    c0100be3 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bb5:	89 d0                	mov    %edx,%eax
c0100bb7:	01 c0                	add    %eax,%eax
c0100bb9:	01 d0                	add    %edx,%eax
c0100bbb:	c1 e0 02             	shl    $0x2,%eax
c0100bbe:	05 08 50 12 c0       	add    $0xc0125008,%eax
c0100bc3:	8b 10                	mov    (%eax),%edx
c0100bc5:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc8:	83 c0 04             	add    $0x4,%eax
c0100bcb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bce:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bd4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdc:	89 1c 24             	mov    %ebx,(%esp)
c0100bdf:	ff d2                	call   *%edx
c0100be1:	eb 23                	jmp    c0100c06 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be3:	ff 45 f4             	incl   -0xc(%ebp)
c0100be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100be9:	83 f8 02             	cmp    $0x2,%eax
c0100bec:	76 9e                	jbe    c0100b8c <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bee:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bf5:	c7 04 24 17 a0 10 c0 	movl   $0xc010a017,(%esp)
c0100bfc:	e8 a8 f6 ff ff       	call   c01002a9 <cprintf>
    return 0;
c0100c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c06:	83 c4 64             	add    $0x64,%esp
c0100c09:	5b                   	pop    %ebx
c0100c0a:	5d                   	pop    %ebp
c0100c0b:	c3                   	ret    

c0100c0c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c0c:	55                   	push   %ebp
c0100c0d:	89 e5                	mov    %esp,%ebp
c0100c0f:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c12:	c7 04 24 30 a0 10 c0 	movl   $0xc010a030,(%esp)
c0100c19:	e8 8b f6 ff ff       	call   c01002a9 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c1e:	c7 04 24 58 a0 10 c0 	movl   $0xc010a058,(%esp)
c0100c25:	e8 7f f6 ff ff       	call   c01002a9 <cprintf>

    if (tf != NULL) {
c0100c2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c2e:	74 0b                	je     c0100c3b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 7a 15 00 00       	call   c01021b5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c3b:	c7 04 24 7d a0 10 c0 	movl   $0xc010a07d,(%esp)
c0100c42:	e8 04 f7 ff ff       	call   c010034b <readline>
c0100c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c4e:	74 eb                	je     c0100c3b <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5a:	89 04 24             	mov    %eax,(%esp)
c0100c5d:	e8 f5 fe ff ff       	call   c0100b57 <runcmd>
c0100c62:	85 c0                	test   %eax,%eax
c0100c64:	78 02                	js     c0100c68 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c66:	eb d3                	jmp    c0100c3b <kmonitor+0x2f>
                break;
c0100c68:	90                   	nop
            }
        }
    }
}
c0100c69:	90                   	nop
c0100c6a:	c9                   	leave  
c0100c6b:	c3                   	ret    

c0100c6c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c6c:	55                   	push   %ebp
c0100c6d:	89 e5                	mov    %esp,%ebp
c0100c6f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c79:	eb 3d                	jmp    c0100cb8 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7e:	89 d0                	mov    %edx,%eax
c0100c80:	01 c0                	add    %eax,%eax
c0100c82:	01 d0                	add    %edx,%eax
c0100c84:	c1 e0 02             	shl    $0x2,%eax
c0100c87:	05 04 50 12 c0       	add    $0xc0125004,%eax
c0100c8c:	8b 08                	mov    (%eax),%ecx
c0100c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c91:	89 d0                	mov    %edx,%eax
c0100c93:	01 c0                	add    %eax,%eax
c0100c95:	01 d0                	add    %edx,%eax
c0100c97:	c1 e0 02             	shl    $0x2,%eax
c0100c9a:	05 00 50 12 c0       	add    $0xc0125000,%eax
c0100c9f:	8b 00                	mov    (%eax),%eax
c0100ca1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca9:	c7 04 24 81 a0 10 c0 	movl   $0xc010a081,(%esp)
c0100cb0:	e8 f4 f5 ff ff       	call   c01002a9 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cb5:	ff 45 f4             	incl   -0xc(%ebp)
c0100cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cbb:	83 f8 02             	cmp    $0x2,%eax
c0100cbe:	76 bb                	jbe    c0100c7b <mon_help+0xf>
    }
    return 0;
c0100cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc5:	c9                   	leave  
c0100cc6:	c3                   	ret    

c0100cc7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cc7:	55                   	push   %ebp
c0100cc8:	89 e5                	mov    %esp,%ebp
c0100cca:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ccd:	e8 7d fc ff ff       	call   c010094f <print_kerninfo>
    return 0;
c0100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd7:	c9                   	leave  
c0100cd8:	c3                   	ret    

c0100cd9 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cd9:	55                   	push   %ebp
c0100cda:	89 e5                	mov    %esp,%ebp
c0100cdc:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cdf:	e8 b6 fd ff ff       	call   c0100a9a <print_stackframe>
    return 0;
c0100ce4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ce9:	c9                   	leave  
c0100cea:	c3                   	ret    

c0100ceb <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100ceb:	55                   	push   %ebp
c0100cec:	89 e5                	mov    %esp,%ebp
c0100cee:	83 ec 14             	sub    $0x14,%esp
c0100cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100cf8:	90                   	nop
c0100cf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100cfc:	83 c0 07             	add    $0x7,%eax
c0100cff:	0f b7 c0             	movzwl %ax,%eax
c0100d02:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d06:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d0a:	89 c2                	mov    %eax,%edx
c0100d0c:	ec                   	in     (%dx),%al
c0100d0d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100d10:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100d14:	0f b6 c0             	movzbl %al,%eax
c0100d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100d1d:	25 80 00 00 00       	and    $0x80,%eax
c0100d22:	85 c0                	test   %eax,%eax
c0100d24:	75 d3                	jne    c0100cf9 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100d26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100d2a:	74 11                	je     c0100d3d <ide_wait_ready+0x52>
c0100d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100d2f:	83 e0 21             	and    $0x21,%eax
c0100d32:	85 c0                	test   %eax,%eax
c0100d34:	74 07                	je     c0100d3d <ide_wait_ready+0x52>
        return -1;
c0100d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100d3b:	eb 05                	jmp    c0100d42 <ide_wait_ready+0x57>
    }
    return 0;
c0100d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d42:	c9                   	leave  
c0100d43:	c3                   	ret    

c0100d44 <ide_init>:

void
ide_init(void) {
c0100d44:	55                   	push   %ebp
c0100d45:	89 e5                	mov    %esp,%ebp
c0100d47:	57                   	push   %edi
c0100d48:	53                   	push   %ebx
c0100d49:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100d4f:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100d55:	e9 ba 02 00 00       	jmp    c0101014 <ide_init+0x2d0>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100d5a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d5e:	89 d0                	mov    %edx,%eax
c0100d60:	c1 e0 03             	shl    $0x3,%eax
c0100d63:	29 d0                	sub    %edx,%eax
c0100d65:	c1 e0 03             	shl    $0x3,%eax
c0100d68:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0100d6d:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100d70:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100d74:	d1 e8                	shr    %eax
c0100d76:	0f b7 c0             	movzwl %ax,%eax
c0100d79:	8b 04 85 8c a0 10 c0 	mov    -0x3fef5f74(,%eax,4),%eax
c0100d80:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100d84:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100d88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100d8f:	00 
c0100d90:	89 04 24             	mov    %eax,(%esp)
c0100d93:	e8 53 ff ff ff       	call   c0100ceb <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100d98:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100d9c:	c1 e0 04             	shl    $0x4,%eax
c0100d9f:	24 10                	and    $0x10,%al
c0100da1:	0c e0                	or     $0xe0,%al
c0100da3:	0f b6 c0             	movzbl %al,%eax
c0100da6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100daa:	83 c2 06             	add    $0x6,%edx
c0100dad:	0f b7 d2             	movzwl %dx,%edx
c0100db0:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c0100db4:	88 45 c9             	mov    %al,-0x37(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100db7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100dbb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0100dbf:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100dc0:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100dc4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100dcb:	00 
c0100dcc:	89 04 24             	mov    %eax,(%esp)
c0100dcf:	e8 17 ff ff ff       	call   c0100ceb <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100dd4:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100dd8:	83 c0 07             	add    $0x7,%eax
c0100ddb:	0f b7 c0             	movzwl %ax,%eax
c0100dde:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c0100de2:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c0100de6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0100dea:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0100dee:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100def:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100df3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100dfa:	00 
c0100dfb:	89 04 24             	mov    %eax,(%esp)
c0100dfe:	e8 e8 fe ff ff       	call   c0100ceb <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100e03:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e07:	83 c0 07             	add    $0x7,%eax
c0100e0a:	0f b7 c0             	movzwl %ax,%eax
c0100e0d:	66 89 45 d2          	mov    %ax,-0x2e(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e11:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100e15:	89 c2                	mov    %eax,%edx
c0100e17:	ec                   	in     (%dx),%al
c0100e18:	88 45 d1             	mov    %al,-0x2f(%ebp)
    return data;
c0100e1b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100e1f:	84 c0                	test   %al,%al
c0100e21:	0f 84 e3 01 00 00    	je     c010100a <ide_init+0x2c6>
c0100e27:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e2b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0100e32:	00 
c0100e33:	89 04 24             	mov    %eax,(%esp)
c0100e36:	e8 b0 fe ff ff       	call   c0100ceb <ide_wait_ready>
c0100e3b:	85 c0                	test   %eax,%eax
c0100e3d:	0f 85 c7 01 00 00    	jne    c010100a <ide_init+0x2c6>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100e43:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e47:	89 d0                	mov    %edx,%eax
c0100e49:	c1 e0 03             	shl    $0x3,%eax
c0100e4c:	29 d0                	sub    %edx,%eax
c0100e4e:	c1 e0 03             	shl    $0x3,%eax
c0100e51:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0100e56:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100e59:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e5d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0100e60:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100e66:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100e69:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c0100e70:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0100e73:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100e76:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100e79:	89 cb                	mov    %ecx,%ebx
c0100e7b:	89 df                	mov    %ebx,%edi
c0100e7d:	89 c1                	mov    %eax,%ecx
c0100e7f:	fc                   	cld    
c0100e80:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100e82:	89 c8                	mov    %ecx,%eax
c0100e84:	89 fb                	mov    %edi,%ebx
c0100e86:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100e89:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100e8c:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100e98:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100e9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100ea1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100ea4:	25 00 00 00 04       	and    $0x4000000,%eax
c0100ea9:	85 c0                	test   %eax,%eax
c0100eab:	74 0e                	je     c0100ebb <ide_init+0x177>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100eb0:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100eb9:	eb 09                	jmp    c0100ec4 <ide_init+0x180>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100ebb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ebe:	8b 40 78             	mov    0x78(%eax),%eax
c0100ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100ec4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ec8:	89 d0                	mov    %edx,%eax
c0100eca:	c1 e0 03             	shl    $0x3,%eax
c0100ecd:	29 d0                	sub    %edx,%eax
c0100ecf:	c1 e0 03             	shl    $0x3,%eax
c0100ed2:	8d 90 44 84 12 c0    	lea    -0x3fed7bbc(%eax),%edx
c0100ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100edb:	89 02                	mov    %eax,(%edx)
        ide_devices[ideno].size = sectors;
c0100edd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ee1:	89 d0                	mov    %edx,%eax
c0100ee3:	c1 e0 03             	shl    $0x3,%eax
c0100ee6:	29 d0                	sub    %edx,%eax
c0100ee8:	c1 e0 03             	shl    $0x3,%eax
c0100eeb:	8d 90 48 84 12 c0    	lea    -0x3fed7bb8(%eax),%edx
c0100ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ef4:	89 02                	mov    %eax,(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100ef9:	83 c0 62             	add    $0x62,%eax
c0100efc:	0f b7 00             	movzwl (%eax),%eax
c0100eff:	25 00 02 00 00       	and    $0x200,%eax
c0100f04:	85 c0                	test   %eax,%eax
c0100f06:	75 24                	jne    c0100f2c <ide_init+0x1e8>
c0100f08:	c7 44 24 0c 94 a0 10 	movl   $0xc010a094,0xc(%esp)
c0100f0f:	c0 
c0100f10:	c7 44 24 08 d7 a0 10 	movl   $0xc010a0d7,0x8(%esp)
c0100f17:	c0 
c0100f18:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0100f1f:	00 
c0100f20:	c7 04 24 ec a0 10 c0 	movl   $0xc010a0ec,(%esp)
c0100f27:	e8 d4 f4 ff ff       	call   c0100400 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0100f2c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f30:	89 d0                	mov    %edx,%eax
c0100f32:	c1 e0 03             	shl    $0x3,%eax
c0100f35:	29 d0                	sub    %edx,%eax
c0100f37:	c1 e0 03             	shl    $0x3,%eax
c0100f3a:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0100f3f:	83 c0 0c             	add    $0xc,%eax
c0100f42:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f48:	83 c0 36             	add    $0x36,%eax
c0100f4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0100f4e:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0100f55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100f5c:	eb 34                	jmp    c0100f92 <ide_init+0x24e>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0100f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100f61:	8d 50 01             	lea    0x1(%eax),%edx
c0100f64:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100f67:	01 d0                	add    %edx,%eax
c0100f69:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100f6f:	01 ca                	add    %ecx,%edx
c0100f71:	0f b6 00             	movzbl (%eax),%eax
c0100f74:	88 02                	mov    %al,(%edx)
c0100f76:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100f7c:	01 d0                	add    %edx,%eax
c0100f7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100f81:	8d 4a 01             	lea    0x1(%edx),%ecx
c0100f84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100f87:	01 ca                	add    %ecx,%edx
c0100f89:	0f b6 00             	movzbl (%eax),%eax
c0100f8c:	88 02                	mov    %al,(%edx)
        for (i = 0; i < length; i += 2) {
c0100f8e:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0100f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100f95:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0100f98:	72 c4                	jb     c0100f5e <ide_init+0x21a>
        }
        do {
            model[i] = '\0';
c0100f9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100fa0:	01 d0                	add    %edx,%eax
c0100fa2:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0100fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100fa8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100fab:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0100fae:	85 c0                	test   %eax,%eax
c0100fb0:	74 0f                	je     c0100fc1 <ide_init+0x27d>
c0100fb2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100fb8:	01 d0                	add    %edx,%eax
c0100fba:	0f b6 00             	movzbl (%eax),%eax
c0100fbd:	3c 20                	cmp    $0x20,%al
c0100fbf:	74 d9                	je     c0100f9a <ide_init+0x256>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0100fc1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fc5:	89 d0                	mov    %edx,%eax
c0100fc7:	c1 e0 03             	shl    $0x3,%eax
c0100fca:	29 d0                	sub    %edx,%eax
c0100fcc:	c1 e0 03             	shl    $0x3,%eax
c0100fcf:	05 40 84 12 c0       	add    $0xc0128440,%eax
c0100fd4:	8d 48 0c             	lea    0xc(%eax),%ecx
c0100fd7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fdb:	89 d0                	mov    %edx,%eax
c0100fdd:	c1 e0 03             	shl    $0x3,%eax
c0100fe0:	29 d0                	sub    %edx,%eax
c0100fe2:	c1 e0 03             	shl    $0x3,%eax
c0100fe5:	05 48 84 12 c0       	add    $0xc0128448,%eax
c0100fea:	8b 10                	mov    (%eax),%edx
c0100fec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100ff0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100ff4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ffc:	c7 04 24 fe a0 10 c0 	movl   $0xc010a0fe,(%esp)
c0101003:	e8 a1 f2 ff ff       	call   c01002a9 <cprintf>
c0101008:	eb 01                	jmp    c010100b <ide_init+0x2c7>
            continue ;
c010100a:	90                   	nop
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010100b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010100f:	40                   	inc    %eax
c0101010:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101014:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101018:	83 f8 03             	cmp    $0x3,%eax
c010101b:	0f 86 39 fd ff ff    	jbe    c0100d5a <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101021:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101028:	e8 91 0e 00 00       	call   c0101ebe <pic_enable>
    pic_enable(IRQ_IDE2);
c010102d:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101034:	e8 85 0e 00 00       	call   c0101ebe <pic_enable>
}
c0101039:	90                   	nop
c010103a:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101040:	5b                   	pop    %ebx
c0101041:	5f                   	pop    %edi
c0101042:	5d                   	pop    %ebp
c0101043:	c3                   	ret    

c0101044 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101044:	55                   	push   %ebp
c0101045:	89 e5                	mov    %esp,%ebp
c0101047:	83 ec 04             	sub    $0x4,%esp
c010104a:	8b 45 08             	mov    0x8(%ebp),%eax
c010104d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101051:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101055:	83 f8 03             	cmp    $0x3,%eax
c0101058:	77 21                	ja     c010107b <ide_device_valid+0x37>
c010105a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c010105e:	89 d0                	mov    %edx,%eax
c0101060:	c1 e0 03             	shl    $0x3,%eax
c0101063:	29 d0                	sub    %edx,%eax
c0101065:	c1 e0 03             	shl    $0x3,%eax
c0101068:	05 40 84 12 c0       	add    $0xc0128440,%eax
c010106d:	0f b6 00             	movzbl (%eax),%eax
c0101070:	84 c0                	test   %al,%al
c0101072:	74 07                	je     c010107b <ide_device_valid+0x37>
c0101074:	b8 01 00 00 00       	mov    $0x1,%eax
c0101079:	eb 05                	jmp    c0101080 <ide_device_valid+0x3c>
c010107b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101080:	c9                   	leave  
c0101081:	c3                   	ret    

c0101082 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101082:	55                   	push   %ebp
c0101083:	89 e5                	mov    %esp,%ebp
c0101085:	83 ec 08             	sub    $0x8,%esp
c0101088:	8b 45 08             	mov    0x8(%ebp),%eax
c010108b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c010108f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101093:	89 04 24             	mov    %eax,(%esp)
c0101096:	e8 a9 ff ff ff       	call   c0101044 <ide_device_valid>
c010109b:	85 c0                	test   %eax,%eax
c010109d:	74 17                	je     c01010b6 <ide_device_size+0x34>
        return ide_devices[ideno].size;
c010109f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01010a3:	89 d0                	mov    %edx,%eax
c01010a5:	c1 e0 03             	shl    $0x3,%eax
c01010a8:	29 d0                	sub    %edx,%eax
c01010aa:	c1 e0 03             	shl    $0x3,%eax
c01010ad:	05 48 84 12 c0       	add    $0xc0128448,%eax
c01010b2:	8b 00                	mov    (%eax),%eax
c01010b4:	eb 05                	jmp    c01010bb <ide_device_size+0x39>
    }
    return 0;
c01010b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01010bb:	c9                   	leave  
c01010bc:	c3                   	ret    

c01010bd <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c01010bd:	55                   	push   %ebp
c01010be:	89 e5                	mov    %esp,%ebp
c01010c0:	57                   	push   %edi
c01010c1:	53                   	push   %ebx
c01010c2:	83 ec 50             	sub    $0x50,%esp
c01010c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01010cc:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01010d3:	77 23                	ja     c01010f8 <ide_read_secs+0x3b>
c01010d5:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01010d9:	83 f8 03             	cmp    $0x3,%eax
c01010dc:	77 1a                	ja     c01010f8 <ide_read_secs+0x3b>
c01010de:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c01010e2:	89 d0                	mov    %edx,%eax
c01010e4:	c1 e0 03             	shl    $0x3,%eax
c01010e7:	29 d0                	sub    %edx,%eax
c01010e9:	c1 e0 03             	shl    $0x3,%eax
c01010ec:	05 40 84 12 c0       	add    $0xc0128440,%eax
c01010f1:	0f b6 00             	movzbl (%eax),%eax
c01010f4:	84 c0                	test   %al,%al
c01010f6:	75 24                	jne    c010111c <ide_read_secs+0x5f>
c01010f8:	c7 44 24 0c 1c a1 10 	movl   $0xc010a11c,0xc(%esp)
c01010ff:	c0 
c0101100:	c7 44 24 08 d7 a0 10 	movl   $0xc010a0d7,0x8(%esp)
c0101107:	c0 
c0101108:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010110f:	00 
c0101110:	c7 04 24 ec a0 10 c0 	movl   $0xc010a0ec,(%esp)
c0101117:	e8 e4 f2 ff ff       	call   c0100400 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c010111c:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101123:	77 0f                	ja     c0101134 <ide_read_secs+0x77>
c0101125:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101128:	8b 45 14             	mov    0x14(%ebp),%eax
c010112b:	01 d0                	add    %edx,%eax
c010112d:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101132:	76 24                	jbe    c0101158 <ide_read_secs+0x9b>
c0101134:	c7 44 24 0c 44 a1 10 	movl   $0xc010a144,0xc(%esp)
c010113b:	c0 
c010113c:	c7 44 24 08 d7 a0 10 	movl   $0xc010a0d7,0x8(%esp)
c0101143:	c0 
c0101144:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010114b:	00 
c010114c:	c7 04 24 ec a0 10 c0 	movl   $0xc010a0ec,(%esp)
c0101153:	e8 a8 f2 ff ff       	call   c0100400 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101158:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010115c:	d1 e8                	shr    %eax
c010115e:	0f b7 c0             	movzwl %ax,%eax
c0101161:	8b 04 85 8c a0 10 c0 	mov    -0x3fef5f74(,%eax,4),%eax
c0101168:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010116c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101170:	d1 e8                	shr    %eax
c0101172:	0f b7 c0             	movzwl %ax,%eax
c0101175:	0f b7 04 85 8e a0 10 	movzwl -0x3fef5f72(,%eax,4),%eax
c010117c:	c0 
c010117d:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101181:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101185:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010118c:	00 
c010118d:	89 04 24             	mov    %eax,(%esp)
c0101190:	e8 56 fb ff ff       	call   c0100ceb <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101195:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101198:	83 c0 02             	add    $0x2,%eax
c010119b:	0f b7 c0             	movzwl %ax,%eax
c010119e:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c01011a2:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01011a6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01011aa:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01011ae:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01011af:	8b 45 14             	mov    0x14(%ebp),%eax
c01011b2:	0f b6 c0             	movzbl %al,%eax
c01011b5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011b9:	83 c2 02             	add    $0x2,%edx
c01011bc:	0f b7 d2             	movzwl %dx,%edx
c01011bf:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01011c3:	88 45 d9             	mov    %al,-0x27(%ebp)
c01011c6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01011ca:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01011ce:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01011d2:	0f b6 c0             	movzbl %al,%eax
c01011d5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011d9:	83 c2 03             	add    $0x3,%edx
c01011dc:	0f b7 d2             	movzwl %dx,%edx
c01011df:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c01011e3:	88 45 dd             	mov    %al,-0x23(%ebp)
c01011e6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01011ea:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01011ee:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01011f2:	c1 e8 08             	shr    $0x8,%eax
c01011f5:	0f b6 c0             	movzbl %al,%eax
c01011f8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011fc:	83 c2 04             	add    $0x4,%edx
c01011ff:	0f b7 d2             	movzwl %dx,%edx
c0101202:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101206:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101209:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010120d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101211:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101212:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101215:	c1 e8 10             	shr    $0x10,%eax
c0101218:	0f b6 c0             	movzbl %al,%eax
c010121b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010121f:	83 c2 05             	add    $0x5,%edx
c0101222:	0f b7 d2             	movzwl %dx,%edx
c0101225:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101229:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010122c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101230:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101234:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101235:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101238:	c0 e0 04             	shl    $0x4,%al
c010123b:	24 10                	and    $0x10,%al
c010123d:	88 c2                	mov    %al,%dl
c010123f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101242:	c1 e8 18             	shr    $0x18,%eax
c0101245:	24 0f                	and    $0xf,%al
c0101247:	08 d0                	or     %dl,%al
c0101249:	0c e0                	or     $0xe0,%al
c010124b:	0f b6 c0             	movzbl %al,%eax
c010124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101252:	83 c2 06             	add    $0x6,%edx
c0101255:	0f b7 d2             	movzwl %dx,%edx
c0101258:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010125c:	88 45 e9             	mov    %al,-0x17(%ebp)
c010125f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101263:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101267:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101268:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010126c:	83 c0 07             	add    $0x7,%eax
c010126f:	0f b7 c0             	movzwl %ax,%eax
c0101272:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101276:	c6 45 ed 20          	movb   $0x20,-0x13(%ebp)
c010127a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010127e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101282:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101283:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c010128a:	eb 57                	jmp    c01012e3 <ide_read_secs+0x226>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c010128c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101290:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101297:	00 
c0101298:	89 04 24             	mov    %eax,(%esp)
c010129b:	e8 4b fa ff ff       	call   c0100ceb <ide_wait_ready>
c01012a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012a7:	75 42                	jne    c01012eb <ide_read_secs+0x22e>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c01012a9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01012ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01012b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01012b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01012b6:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c01012bd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01012c0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01012c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01012c6:	89 cb                	mov    %ecx,%ebx
c01012c8:	89 df                	mov    %ebx,%edi
c01012ca:	89 c1                	mov    %eax,%ecx
c01012cc:	fc                   	cld    
c01012cd:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01012cf:	89 c8                	mov    %ecx,%eax
c01012d1:	89 fb                	mov    %edi,%ebx
c01012d3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c01012d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c01012d9:	ff 4d 14             	decl   0x14(%ebp)
c01012dc:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01012e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01012e7:	75 a3                	jne    c010128c <ide_read_secs+0x1cf>
    }

out:
c01012e9:	eb 01                	jmp    c01012ec <ide_read_secs+0x22f>
            goto out;
c01012eb:	90                   	nop
    return ret;
c01012ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01012ef:	83 c4 50             	add    $0x50,%esp
c01012f2:	5b                   	pop    %ebx
c01012f3:	5f                   	pop    %edi
c01012f4:	5d                   	pop    %ebp
c01012f5:	c3                   	ret    

c01012f6 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c01012f6:	55                   	push   %ebp
c01012f7:	89 e5                	mov    %esp,%ebp
c01012f9:	56                   	push   %esi
c01012fa:	53                   	push   %ebx
c01012fb:	83 ec 50             	sub    $0x50,%esp
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101305:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c010130c:	77 23                	ja     c0101331 <ide_write_secs+0x3b>
c010130e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101312:	83 f8 03             	cmp    $0x3,%eax
c0101315:	77 1a                	ja     c0101331 <ide_write_secs+0x3b>
c0101317:	0f b7 55 c4          	movzwl -0x3c(%ebp),%edx
c010131b:	89 d0                	mov    %edx,%eax
c010131d:	c1 e0 03             	shl    $0x3,%eax
c0101320:	29 d0                	sub    %edx,%eax
c0101322:	c1 e0 03             	shl    $0x3,%eax
c0101325:	05 40 84 12 c0       	add    $0xc0128440,%eax
c010132a:	0f b6 00             	movzbl (%eax),%eax
c010132d:	84 c0                	test   %al,%al
c010132f:	75 24                	jne    c0101355 <ide_write_secs+0x5f>
c0101331:	c7 44 24 0c 1c a1 10 	movl   $0xc010a11c,0xc(%esp)
c0101338:	c0 
c0101339:	c7 44 24 08 d7 a0 10 	movl   $0xc010a0d7,0x8(%esp)
c0101340:	c0 
c0101341:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101348:	00 
c0101349:	c7 04 24 ec a0 10 c0 	movl   $0xc010a0ec,(%esp)
c0101350:	e8 ab f0 ff ff       	call   c0100400 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101355:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c010135c:	77 0f                	ja     c010136d <ide_write_secs+0x77>
c010135e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101361:	8b 45 14             	mov    0x14(%ebp),%eax
c0101364:	01 d0                	add    %edx,%eax
c0101366:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c010136b:	76 24                	jbe    c0101391 <ide_write_secs+0x9b>
c010136d:	c7 44 24 0c 44 a1 10 	movl   $0xc010a144,0xc(%esp)
c0101374:	c0 
c0101375:	c7 44 24 08 d7 a0 10 	movl   $0xc010a0d7,0x8(%esp)
c010137c:	c0 
c010137d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101384:	00 
c0101385:	c7 04 24 ec a0 10 c0 	movl   $0xc010a0ec,(%esp)
c010138c:	e8 6f f0 ff ff       	call   c0100400 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101391:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101395:	d1 e8                	shr    %eax
c0101397:	0f b7 c0             	movzwl %ax,%eax
c010139a:	8b 04 85 8c a0 10 c0 	mov    -0x3fef5f74(,%eax,4),%eax
c01013a1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01013a5:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01013a9:	d1 e8                	shr    %eax
c01013ab:	0f b7 c0             	movzwl %ax,%eax
c01013ae:	0f b7 04 85 8e a0 10 	movzwl -0x3fef5f72(,%eax,4),%eax
c01013b5:	c0 
c01013b6:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c01013ba:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01013be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01013c5:	00 
c01013c6:	89 04 24             	mov    %eax,(%esp)
c01013c9:	e8 1d f9 ff ff       	call   c0100ceb <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01013ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01013d1:	83 c0 02             	add    $0x2,%eax
c01013d4:	0f b7 c0             	movzwl %ax,%eax
c01013d7:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c01013db:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01013df:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01013e3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01013e7:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01013e8:	8b 45 14             	mov    0x14(%ebp),%eax
c01013eb:	0f b6 c0             	movzbl %al,%eax
c01013ee:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01013f2:	83 c2 02             	add    $0x2,%edx
c01013f5:	0f b7 d2             	movzwl %dx,%edx
c01013f8:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01013fc:	88 45 d9             	mov    %al,-0x27(%ebp)
c01013ff:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101403:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101407:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010140b:	0f b6 c0             	movzbl %al,%eax
c010140e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101412:	83 c2 03             	add    $0x3,%edx
c0101415:	0f b7 d2             	movzwl %dx,%edx
c0101418:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c010141c:	88 45 dd             	mov    %al,-0x23(%ebp)
c010141f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101423:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101427:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101428:	8b 45 0c             	mov    0xc(%ebp),%eax
c010142b:	c1 e8 08             	shr    $0x8,%eax
c010142e:	0f b6 c0             	movzbl %al,%eax
c0101431:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101435:	83 c2 04             	add    $0x4,%edx
c0101438:	0f b7 d2             	movzwl %dx,%edx
c010143b:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c010143f:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101442:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101446:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010144a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c010144b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010144e:	c1 e8 10             	shr    $0x10,%eax
c0101451:	0f b6 c0             	movzbl %al,%eax
c0101454:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101458:	83 c2 05             	add    $0x5,%edx
c010145b:	0f b7 d2             	movzwl %dx,%edx
c010145e:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101462:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101465:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101469:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010146d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010146e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0101471:	c0 e0 04             	shl    $0x4,%al
c0101474:	24 10                	and    $0x10,%al
c0101476:	88 c2                	mov    %al,%dl
c0101478:	8b 45 0c             	mov    0xc(%ebp),%eax
c010147b:	c1 e8 18             	shr    $0x18,%eax
c010147e:	24 0f                	and    $0xf,%al
c0101480:	08 d0                	or     %dl,%al
c0101482:	0c e0                	or     $0xe0,%al
c0101484:	0f b6 c0             	movzbl %al,%eax
c0101487:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010148b:	83 c2 06             	add    $0x6,%edx
c010148e:	0f b7 d2             	movzwl %dx,%edx
c0101491:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101495:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101498:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010149c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01014a0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c01014a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014a5:	83 c0 07             	add    $0x7,%eax
c01014a8:	0f b7 c0             	movzwl %ax,%eax
c01014ab:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01014af:	c6 45 ed 30          	movb   $0x30,-0x13(%ebp)
c01014b3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01014b7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01014bb:	ee                   	out    %al,(%dx)

    int ret = 0;
c01014bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01014c3:	eb 57                	jmp    c010151c <ide_write_secs+0x226>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c01014c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01014d0:	00 
c01014d1:	89 04 24             	mov    %eax,(%esp)
c01014d4:	e8 12 f8 ff ff       	call   c0100ceb <ide_wait_ready>
c01014d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01014e0:	75 42                	jne    c0101524 <ide_write_secs+0x22e>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c01014e2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01014e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01014ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01014ef:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c01014f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01014f9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01014fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01014ff:	89 cb                	mov    %ecx,%ebx
c0101501:	89 de                	mov    %ebx,%esi
c0101503:	89 c1                	mov    %eax,%ecx
c0101505:	fc                   	cld    
c0101506:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101508:	89 c8                	mov    %ecx,%eax
c010150a:	89 f3                	mov    %esi,%ebx
c010150c:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c010150f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101512:	ff 4d 14             	decl   0x14(%ebp)
c0101515:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c010151c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101520:	75 a3                	jne    c01014c5 <ide_write_secs+0x1cf>
    }

out:
c0101522:	eb 01                	jmp    c0101525 <ide_write_secs+0x22f>
            goto out;
c0101524:	90                   	nop
    return ret;
c0101525:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101528:	83 c4 50             	add    $0x50,%esp
c010152b:	5b                   	pop    %ebx
c010152c:	5e                   	pop    %esi
c010152d:	5d                   	pop    %ebp
c010152e:	c3                   	ret    

c010152f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c010152f:	55                   	push   %ebp
c0101530:	89 e5                	mov    %esp,%ebp
c0101532:	83 ec 28             	sub    $0x28,%esp
c0101535:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c010153b:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010153f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101543:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101547:	ee                   	out    %al,(%dx)
c0101548:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c010154e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0101552:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101556:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010155a:	ee                   	out    %al,(%dx)
c010155b:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0101561:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0101565:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101569:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010156d:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c010156e:	c7 05 54 b0 12 c0 00 	movl   $0x0,0xc012b054
c0101575:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0101578:	c7 04 24 7e a1 10 c0 	movl   $0xc010a17e,(%esp)
c010157f:	e8 25 ed ff ff       	call   c01002a9 <cprintf>
    pic_enable(IRQ_TIMER);
c0101584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010158b:	e8 2e 09 00 00       	call   c0101ebe <pic_enable>
}
c0101590:	90                   	nop
c0101591:	c9                   	leave  
c0101592:	c3                   	ret    

c0101593 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0101593:	55                   	push   %ebp
c0101594:	89 e5                	mov    %esp,%ebp
c0101596:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0101599:	9c                   	pushf  
c010159a:	58                   	pop    %eax
c010159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010159e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01015a1:	25 00 02 00 00       	and    $0x200,%eax
c01015a6:	85 c0                	test   %eax,%eax
c01015a8:	74 0c                	je     c01015b6 <__intr_save+0x23>
        intr_disable();
c01015aa:	e8 83 0a 00 00       	call   c0102032 <intr_disable>
        return 1;
c01015af:	b8 01 00 00 00       	mov    $0x1,%eax
c01015b4:	eb 05                	jmp    c01015bb <__intr_save+0x28>
    }
    return 0;
c01015b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01015bb:	c9                   	leave  
c01015bc:	c3                   	ret    

c01015bd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01015bd:	55                   	push   %ebp
c01015be:	89 e5                	mov    %esp,%ebp
c01015c0:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01015c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01015c7:	74 05                	je     c01015ce <__intr_restore+0x11>
        intr_enable();
c01015c9:	e8 5d 0a 00 00       	call   c010202b <intr_enable>
    }
}
c01015ce:	90                   	nop
c01015cf:	c9                   	leave  
c01015d0:	c3                   	ret    

c01015d1 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c01015d1:	55                   	push   %ebp
c01015d2:	89 e5                	mov    %esp,%ebp
c01015d4:	83 ec 10             	sub    $0x10,%esp
c01015d7:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01015dd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015e1:	89 c2                	mov    %eax,%edx
c01015e3:	ec                   	in     (%dx),%al
c01015e4:	88 45 f1             	mov    %al,-0xf(%ebp)
c01015e7:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c01015ed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01015f1:	89 c2                	mov    %eax,%edx
c01015f3:	ec                   	in     (%dx),%al
c01015f4:	88 45 f5             	mov    %al,-0xb(%ebp)
c01015f7:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c01015fd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101601:	89 c2                	mov    %eax,%edx
c0101603:	ec                   	in     (%dx),%al
c0101604:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101607:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c010160d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0101611:	89 c2                	mov    %eax,%edx
c0101613:	ec                   	in     (%dx),%al
c0101614:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0101617:	90                   	nop
c0101618:	c9                   	leave  
c0101619:	c3                   	ret    

c010161a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c010161a:	55                   	push   %ebp
c010161b:	89 e5                	mov    %esp,%ebp
c010161d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0101620:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0101627:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010162a:	0f b7 00             	movzwl (%eax),%eax
c010162d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0101631:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101634:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0101639:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010163c:	0f b7 00             	movzwl (%eax),%eax
c010163f:	0f b7 c0             	movzwl %ax,%eax
c0101642:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0101647:	74 12                	je     c010165b <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0101649:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0101650:	66 c7 05 26 85 12 c0 	movw   $0x3b4,0xc0128526
c0101657:	b4 03 
c0101659:	eb 13                	jmp    c010166e <cga_init+0x54>
    } else {
        *cp = was;
c010165b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010165e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101662:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0101665:	66 c7 05 26 85 12 c0 	movw   $0x3d4,0xc0128526
c010166c:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c010166e:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c0101675:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101679:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010167d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101681:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101685:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0101686:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c010168d:	40                   	inc    %eax
c010168e:	0f b7 c0             	movzwl %ax,%eax
c0101691:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101695:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101699:	89 c2                	mov    %eax,%edx
c010169b:	ec                   	in     (%dx),%al
c010169c:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c010169f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01016a3:	0f b6 c0             	movzbl %al,%eax
c01016a6:	c1 e0 08             	shl    $0x8,%eax
c01016a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c01016ac:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c01016b3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01016b7:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016bb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01016bf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01016c3:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c01016c4:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c01016cb:	40                   	inc    %eax
c01016cc:	0f b7 c0             	movzwl %ax,%eax
c01016cf:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01016d7:	89 c2                	mov    %eax,%edx
c01016d9:	ec                   	in     (%dx),%al
c01016da:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c01016dd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01016e1:	0f b6 c0             	movzbl %al,%eax
c01016e4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01016e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ea:	a3 20 85 12 c0       	mov    %eax,0xc0128520
    crt_pos = pos;
c01016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016f2:	0f b7 c0             	movzwl %ax,%eax
c01016f5:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
}
c01016fb:	90                   	nop
c01016fc:	c9                   	leave  
c01016fd:	c3                   	ret    

c01016fe <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c01016fe:	55                   	push   %ebp
c01016ff:	89 e5                	mov    %esp,%ebp
c0101701:	83 ec 48             	sub    $0x48,%esp
c0101704:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c010170a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010170e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101712:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101716:	ee                   	out    %al,(%dx)
c0101717:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c010171d:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0101721:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101725:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101729:	ee                   	out    %al,(%dx)
c010172a:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0101730:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0101734:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101738:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010173c:	ee                   	out    %al,(%dx)
c010173d:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101743:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0101747:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010174b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010174f:	ee                   	out    %al,(%dx)
c0101750:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0101756:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c010175a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010175e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101762:	ee                   	out    %al,(%dx)
c0101763:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0101769:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c010176d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101771:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101775:	ee                   	out    %al,(%dx)
c0101776:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010177c:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0101780:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101784:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101788:	ee                   	out    %al,(%dx)
c0101789:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010178f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101793:	89 c2                	mov    %eax,%edx
c0101795:	ec                   	in     (%dx),%al
c0101796:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101799:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010179d:	3c ff                	cmp    $0xff,%al
c010179f:	0f 95 c0             	setne  %al
c01017a2:	0f b6 c0             	movzbl %al,%eax
c01017a5:	a3 28 85 12 c0       	mov    %eax,0xc0128528
c01017aa:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01017b4:	89 c2                	mov    %eax,%edx
c01017b6:	ec                   	in     (%dx),%al
c01017b7:	88 45 f1             	mov    %al,-0xf(%ebp)
c01017ba:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01017c0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017c4:	89 c2                	mov    %eax,%edx
c01017c6:	ec                   	in     (%dx),%al
c01017c7:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01017ca:	a1 28 85 12 c0       	mov    0xc0128528,%eax
c01017cf:	85 c0                	test   %eax,%eax
c01017d1:	74 0c                	je     c01017df <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c01017d3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01017da:	e8 df 06 00 00       	call   c0101ebe <pic_enable>
    }
}
c01017df:	90                   	nop
c01017e0:	c9                   	leave  
c01017e1:	c3                   	ret    

c01017e2 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01017e2:	55                   	push   %ebp
c01017e3:	89 e5                	mov    %esp,%ebp
c01017e5:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01017e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01017ef:	eb 08                	jmp    c01017f9 <lpt_putc_sub+0x17>
        delay();
c01017f1:	e8 db fd ff ff       	call   c01015d1 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01017f6:	ff 45 fc             	incl   -0x4(%ebp)
c01017f9:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01017ff:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101803:	89 c2                	mov    %eax,%edx
c0101805:	ec                   	in     (%dx),%al
c0101806:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101809:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010180d:	84 c0                	test   %al,%al
c010180f:	78 09                	js     c010181a <lpt_putc_sub+0x38>
c0101811:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101818:	7e d7                	jle    c01017f1 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010181a:	8b 45 08             	mov    0x8(%ebp),%eax
c010181d:	0f b6 c0             	movzbl %al,%eax
c0101820:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101826:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101829:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010182d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101831:	ee                   	out    %al,(%dx)
c0101832:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101838:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010183c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101840:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101844:	ee                   	out    %al,(%dx)
c0101845:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010184b:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c010184f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101853:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101857:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101858:	90                   	nop
c0101859:	c9                   	leave  
c010185a:	c3                   	ret    

c010185b <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010185b:	55                   	push   %ebp
c010185c:	89 e5                	mov    %esp,%ebp
c010185e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101861:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101865:	74 0d                	je     c0101874 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101867:	8b 45 08             	mov    0x8(%ebp),%eax
c010186a:	89 04 24             	mov    %eax,(%esp)
c010186d:	e8 70 ff ff ff       	call   c01017e2 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101872:	eb 24                	jmp    c0101898 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c0101874:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010187b:	e8 62 ff ff ff       	call   c01017e2 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101880:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101887:	e8 56 ff ff ff       	call   c01017e2 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010188c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101893:	e8 4a ff ff ff       	call   c01017e2 <lpt_putc_sub>
}
c0101898:	90                   	nop
c0101899:	c9                   	leave  
c010189a:	c3                   	ret    

c010189b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010189b:	55                   	push   %ebp
c010189c:	89 e5                	mov    %esp,%ebp
c010189e:	53                   	push   %ebx
c010189f:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01018a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01018a5:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01018aa:	85 c0                	test   %eax,%eax
c01018ac:	75 07                	jne    c01018b5 <cga_putc+0x1a>
        c |= 0x0700;
c01018ae:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01018b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01018b8:	0f b6 c0             	movzbl %al,%eax
c01018bb:	83 f8 0a             	cmp    $0xa,%eax
c01018be:	74 55                	je     c0101915 <cga_putc+0x7a>
c01018c0:	83 f8 0d             	cmp    $0xd,%eax
c01018c3:	74 63                	je     c0101928 <cga_putc+0x8d>
c01018c5:	83 f8 08             	cmp    $0x8,%eax
c01018c8:	0f 85 94 00 00 00    	jne    c0101962 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c01018ce:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c01018d5:	85 c0                	test   %eax,%eax
c01018d7:	0f 84 af 00 00 00    	je     c010198c <cga_putc+0xf1>
            crt_pos --;
c01018dd:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c01018e4:	48                   	dec    %eax
c01018e5:	0f b7 c0             	movzwl %ax,%eax
c01018e8:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01018ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01018f1:	98                   	cwtl   
c01018f2:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01018f7:	98                   	cwtl   
c01018f8:	83 c8 20             	or     $0x20,%eax
c01018fb:	98                   	cwtl   
c01018fc:	8b 15 20 85 12 c0    	mov    0xc0128520,%edx
c0101902:	0f b7 0d 24 85 12 c0 	movzwl 0xc0128524,%ecx
c0101909:	01 c9                	add    %ecx,%ecx
c010190b:	01 ca                	add    %ecx,%edx
c010190d:	0f b7 c0             	movzwl %ax,%eax
c0101910:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101913:	eb 77                	jmp    c010198c <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c0101915:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c010191c:	83 c0 50             	add    $0x50,%eax
c010191f:	0f b7 c0             	movzwl %ax,%eax
c0101922:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101928:	0f b7 1d 24 85 12 c0 	movzwl 0xc0128524,%ebx
c010192f:	0f b7 0d 24 85 12 c0 	movzwl 0xc0128524,%ecx
c0101936:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010193b:	89 c8                	mov    %ecx,%eax
c010193d:	f7 e2                	mul    %edx
c010193f:	c1 ea 06             	shr    $0x6,%edx
c0101942:	89 d0                	mov    %edx,%eax
c0101944:	c1 e0 02             	shl    $0x2,%eax
c0101947:	01 d0                	add    %edx,%eax
c0101949:	c1 e0 04             	shl    $0x4,%eax
c010194c:	29 c1                	sub    %eax,%ecx
c010194e:	89 c8                	mov    %ecx,%eax
c0101950:	0f b7 c0             	movzwl %ax,%eax
c0101953:	29 c3                	sub    %eax,%ebx
c0101955:	89 d8                	mov    %ebx,%eax
c0101957:	0f b7 c0             	movzwl %ax,%eax
c010195a:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
        break;
c0101960:	eb 2b                	jmp    c010198d <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101962:	8b 0d 20 85 12 c0    	mov    0xc0128520,%ecx
c0101968:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c010196f:	8d 50 01             	lea    0x1(%eax),%edx
c0101972:	0f b7 d2             	movzwl %dx,%edx
c0101975:	66 89 15 24 85 12 c0 	mov    %dx,0xc0128524
c010197c:	01 c0                	add    %eax,%eax
c010197e:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101981:	8b 45 08             	mov    0x8(%ebp),%eax
c0101984:	0f b7 c0             	movzwl %ax,%eax
c0101987:	66 89 02             	mov    %ax,(%edx)
        break;
c010198a:	eb 01                	jmp    c010198d <cga_putc+0xf2>
        break;
c010198c:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010198d:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101994:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101999:	76 5d                	jbe    c01019f8 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010199b:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c01019a0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01019a6:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c01019ab:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01019b2:	00 
c01019b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01019b7:	89 04 24             	mov    %eax,(%esp)
c01019ba:	e8 18 7b 00 00       	call   c01094d7 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01019bf:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01019c6:	eb 14                	jmp    c01019dc <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c01019c8:	a1 20 85 12 c0       	mov    0xc0128520,%eax
c01019cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01019d0:	01 d2                	add    %edx,%edx
c01019d2:	01 d0                	add    %edx,%eax
c01019d4:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01019d9:	ff 45 f4             	incl   -0xc(%ebp)
c01019dc:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01019e3:	7e e3                	jle    c01019c8 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c01019e5:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c01019ec:	83 e8 50             	sub    $0x50,%eax
c01019ef:	0f b7 c0             	movzwl %ax,%eax
c01019f2:	66 a3 24 85 12 c0    	mov    %ax,0xc0128524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01019f8:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c01019ff:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101a03:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101a07:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101a0b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101a0f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101a10:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101a17:	c1 e8 08             	shr    $0x8,%eax
c0101a1a:	0f b7 c0             	movzwl %ax,%eax
c0101a1d:	0f b6 c0             	movzbl %al,%eax
c0101a20:	0f b7 15 26 85 12 c0 	movzwl 0xc0128526,%edx
c0101a27:	42                   	inc    %edx
c0101a28:	0f b7 d2             	movzwl %dx,%edx
c0101a2b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101a2f:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101a32:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101a36:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101a3a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101a3b:	0f b7 05 26 85 12 c0 	movzwl 0xc0128526,%eax
c0101a42:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101a46:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c0101a4a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101a4e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101a52:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101a53:	0f b7 05 24 85 12 c0 	movzwl 0xc0128524,%eax
c0101a5a:	0f b6 c0             	movzbl %al,%eax
c0101a5d:	0f b7 15 26 85 12 c0 	movzwl 0xc0128526,%edx
c0101a64:	42                   	inc    %edx
c0101a65:	0f b7 d2             	movzwl %dx,%edx
c0101a68:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101a6c:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101a6f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101a73:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101a77:	ee                   	out    %al,(%dx)
}
c0101a78:	90                   	nop
c0101a79:	83 c4 34             	add    $0x34,%esp
c0101a7c:	5b                   	pop    %ebx
c0101a7d:	5d                   	pop    %ebp
c0101a7e:	c3                   	ret    

c0101a7f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101a7f:	55                   	push   %ebp
c0101a80:	89 e5                	mov    %esp,%ebp
c0101a82:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101a85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101a8c:	eb 08                	jmp    c0101a96 <serial_putc_sub+0x17>
        delay();
c0101a8e:	e8 3e fb ff ff       	call   c01015d1 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101a93:	ff 45 fc             	incl   -0x4(%ebp)
c0101a96:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101a9c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101aa0:	89 c2                	mov    %eax,%edx
c0101aa2:	ec                   	in     (%dx),%al
c0101aa3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101aa6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101aaa:	0f b6 c0             	movzbl %al,%eax
c0101aad:	83 e0 20             	and    $0x20,%eax
c0101ab0:	85 c0                	test   %eax,%eax
c0101ab2:	75 09                	jne    c0101abd <serial_putc_sub+0x3e>
c0101ab4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101abb:	7e d1                	jle    c0101a8e <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac0:	0f b6 c0             	movzbl %al,%eax
c0101ac3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101ac9:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101acc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ad0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101ad4:	ee                   	out    %al,(%dx)
}
c0101ad5:	90                   	nop
c0101ad6:	c9                   	leave  
c0101ad7:	c3                   	ret    

c0101ad8 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101ad8:	55                   	push   %ebp
c0101ad9:	89 e5                	mov    %esp,%ebp
c0101adb:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101ade:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101ae2:	74 0d                	je     c0101af1 <serial_putc+0x19>
        serial_putc_sub(c);
c0101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae7:	89 04 24             	mov    %eax,(%esp)
c0101aea:	e8 90 ff ff ff       	call   c0101a7f <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101aef:	eb 24                	jmp    c0101b15 <serial_putc+0x3d>
        serial_putc_sub('\b');
c0101af1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101af8:	e8 82 ff ff ff       	call   c0101a7f <serial_putc_sub>
        serial_putc_sub(' ');
c0101afd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101b04:	e8 76 ff ff ff       	call   c0101a7f <serial_putc_sub>
        serial_putc_sub('\b');
c0101b09:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101b10:	e8 6a ff ff ff       	call   c0101a7f <serial_putc_sub>
}
c0101b15:	90                   	nop
c0101b16:	c9                   	leave  
c0101b17:	c3                   	ret    

c0101b18 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101b18:	55                   	push   %ebp
c0101b19:	89 e5                	mov    %esp,%ebp
c0101b1b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101b1e:	eb 33                	jmp    c0101b53 <cons_intr+0x3b>
        if (c != 0) {
c0101b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101b24:	74 2d                	je     c0101b53 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101b26:	a1 44 87 12 c0       	mov    0xc0128744,%eax
c0101b2b:	8d 50 01             	lea    0x1(%eax),%edx
c0101b2e:	89 15 44 87 12 c0    	mov    %edx,0xc0128744
c0101b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101b37:	88 90 40 85 12 c0    	mov    %dl,-0x3fed7ac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101b3d:	a1 44 87 12 c0       	mov    0xc0128744,%eax
c0101b42:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101b47:	75 0a                	jne    c0101b53 <cons_intr+0x3b>
                cons.wpos = 0;
c0101b49:	c7 05 44 87 12 c0 00 	movl   $0x0,0xc0128744
c0101b50:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101b53:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b56:	ff d0                	call   *%eax
c0101b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101b5b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101b5f:	75 bf                	jne    c0101b20 <cons_intr+0x8>
            }
        }
    }
}
c0101b61:	90                   	nop
c0101b62:	c9                   	leave  
c0101b63:	c3                   	ret    

c0101b64 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101b64:	55                   	push   %ebp
c0101b65:	89 e5                	mov    %esp,%ebp
c0101b67:	83 ec 10             	sub    $0x10,%esp
c0101b6a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b70:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101b74:	89 c2                	mov    %eax,%edx
c0101b76:	ec                   	in     (%dx),%al
c0101b77:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101b7a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101b7e:	0f b6 c0             	movzbl %al,%eax
c0101b81:	83 e0 01             	and    $0x1,%eax
c0101b84:	85 c0                	test   %eax,%eax
c0101b86:	75 07                	jne    c0101b8f <serial_proc_data+0x2b>
        return -1;
c0101b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101b8d:	eb 2a                	jmp    c0101bb9 <serial_proc_data+0x55>
c0101b8f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b95:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101b99:	89 c2                	mov    %eax,%edx
c0101b9b:	ec                   	in     (%dx),%al
c0101b9c:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101b9f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101ba3:	0f b6 c0             	movzbl %al,%eax
c0101ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101ba9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101bad:	75 07                	jne    c0101bb6 <serial_proc_data+0x52>
        c = '\b';
c0101baf:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101bb9:	c9                   	leave  
c0101bba:	c3                   	ret    

c0101bbb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101bbb:	55                   	push   %ebp
c0101bbc:	89 e5                	mov    %esp,%ebp
c0101bbe:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101bc1:	a1 28 85 12 c0       	mov    0xc0128528,%eax
c0101bc6:	85 c0                	test   %eax,%eax
c0101bc8:	74 0c                	je     c0101bd6 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101bca:	c7 04 24 64 1b 10 c0 	movl   $0xc0101b64,(%esp)
c0101bd1:	e8 42 ff ff ff       	call   c0101b18 <cons_intr>
    }
}
c0101bd6:	90                   	nop
c0101bd7:	c9                   	leave  
c0101bd8:	c3                   	ret    

c0101bd9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101bd9:	55                   	push   %ebp
c0101bda:	89 e5                	mov    %esp,%ebp
c0101bdc:	83 ec 38             	sub    $0x38,%esp
c0101bdf:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101be8:	89 c2                	mov    %eax,%edx
c0101bea:	ec                   	in     (%dx),%al
c0101beb:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101bee:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101bf2:	0f b6 c0             	movzbl %al,%eax
c0101bf5:	83 e0 01             	and    $0x1,%eax
c0101bf8:	85 c0                	test   %eax,%eax
c0101bfa:	75 0a                	jne    c0101c06 <kbd_proc_data+0x2d>
        return -1;
c0101bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c01:	e9 55 01 00 00       	jmp    c0101d5b <kbd_proc_data+0x182>
c0101c06:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101c0f:	89 c2                	mov    %eax,%edx
c0101c11:	ec                   	in     (%dx),%al
c0101c12:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101c15:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101c19:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101c1c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101c20:	75 17                	jne    c0101c39 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101c22:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101c27:	83 c8 40             	or     $0x40,%eax
c0101c2a:	a3 48 87 12 c0       	mov    %eax,0xc0128748
        return 0;
c0101c2f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c34:	e9 22 01 00 00       	jmp    c0101d5b <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c0101c39:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101c3d:	84 c0                	test   %al,%al
c0101c3f:	79 45                	jns    c0101c86 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101c41:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101c46:	83 e0 40             	and    $0x40,%eax
c0101c49:	85 c0                	test   %eax,%eax
c0101c4b:	75 08                	jne    c0101c55 <kbd_proc_data+0x7c>
c0101c4d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101c51:	24 7f                	and    $0x7f,%al
c0101c53:	eb 04                	jmp    c0101c59 <kbd_proc_data+0x80>
c0101c55:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101c59:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101c5c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101c60:	0f b6 80 40 50 12 c0 	movzbl -0x3fedafc0(%eax),%eax
c0101c67:	0c 40                	or     $0x40,%al
c0101c69:	0f b6 c0             	movzbl %al,%eax
c0101c6c:	f7 d0                	not    %eax
c0101c6e:	89 c2                	mov    %eax,%edx
c0101c70:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101c75:	21 d0                	and    %edx,%eax
c0101c77:	a3 48 87 12 c0       	mov    %eax,0xc0128748
        return 0;
c0101c7c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101c81:	e9 d5 00 00 00       	jmp    c0101d5b <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c0101c86:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101c8b:	83 e0 40             	and    $0x40,%eax
c0101c8e:	85 c0                	test   %eax,%eax
c0101c90:	74 11                	je     c0101ca3 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101c92:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101c96:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101c9b:	83 e0 bf             	and    $0xffffffbf,%eax
c0101c9e:	a3 48 87 12 c0       	mov    %eax,0xc0128748
    }

    shift |= shiftcode[data];
c0101ca3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101ca7:	0f b6 80 40 50 12 c0 	movzbl -0x3fedafc0(%eax),%eax
c0101cae:	0f b6 d0             	movzbl %al,%edx
c0101cb1:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101cb6:	09 d0                	or     %edx,%eax
c0101cb8:	a3 48 87 12 c0       	mov    %eax,0xc0128748
    shift ^= togglecode[data];
c0101cbd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cc1:	0f b6 80 40 51 12 c0 	movzbl -0x3fedaec0(%eax),%eax
c0101cc8:	0f b6 d0             	movzbl %al,%edx
c0101ccb:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101cd0:	31 d0                	xor    %edx,%eax
c0101cd2:	a3 48 87 12 c0       	mov    %eax,0xc0128748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101cd7:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101cdc:	83 e0 03             	and    $0x3,%eax
c0101cdf:	8b 14 85 40 55 12 c0 	mov    -0x3fedaac0(,%eax,4),%edx
c0101ce6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101cea:	01 d0                	add    %edx,%eax
c0101cec:	0f b6 00             	movzbl (%eax),%eax
c0101cef:	0f b6 c0             	movzbl %al,%eax
c0101cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101cf5:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101cfa:	83 e0 08             	and    $0x8,%eax
c0101cfd:	85 c0                	test   %eax,%eax
c0101cff:	74 22                	je     c0101d23 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101d01:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101d05:	7e 0c                	jle    c0101d13 <kbd_proc_data+0x13a>
c0101d07:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101d0b:	7f 06                	jg     c0101d13 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c0101d0d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101d11:	eb 10                	jmp    c0101d23 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101d13:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101d17:	7e 0a                	jle    c0101d23 <kbd_proc_data+0x14a>
c0101d19:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101d1d:	7f 04                	jg     c0101d23 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101d1f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101d23:	a1 48 87 12 c0       	mov    0xc0128748,%eax
c0101d28:	f7 d0                	not    %eax
c0101d2a:	83 e0 06             	and    $0x6,%eax
c0101d2d:	85 c0                	test   %eax,%eax
c0101d2f:	75 27                	jne    c0101d58 <kbd_proc_data+0x17f>
c0101d31:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101d38:	75 1e                	jne    c0101d58 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c0101d3a:	c7 04 24 99 a1 10 c0 	movl   $0xc010a199,(%esp)
c0101d41:	e8 63 e5 ff ff       	call   c01002a9 <cprintf>
c0101d46:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101d4c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101d50:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101d54:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101d57:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101d5b:	c9                   	leave  
c0101d5c:	c3                   	ret    

c0101d5d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101d5d:	55                   	push   %ebp
c0101d5e:	89 e5                	mov    %esp,%ebp
c0101d60:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101d63:	c7 04 24 d9 1b 10 c0 	movl   $0xc0101bd9,(%esp)
c0101d6a:	e8 a9 fd ff ff       	call   c0101b18 <cons_intr>
}
c0101d6f:	90                   	nop
c0101d70:	c9                   	leave  
c0101d71:	c3                   	ret    

c0101d72 <kbd_init>:

static void
kbd_init(void) {
c0101d72:	55                   	push   %ebp
c0101d73:	89 e5                	mov    %esp,%ebp
c0101d75:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101d78:	e8 e0 ff ff ff       	call   c0101d5d <kbd_intr>
    pic_enable(IRQ_KBD);
c0101d7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101d84:	e8 35 01 00 00       	call   c0101ebe <pic_enable>
}
c0101d89:	90                   	nop
c0101d8a:	c9                   	leave  
c0101d8b:	c3                   	ret    

c0101d8c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101d8c:	55                   	push   %ebp
c0101d8d:	89 e5                	mov    %esp,%ebp
c0101d8f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101d92:	e8 83 f8 ff ff       	call   c010161a <cga_init>
    serial_init();
c0101d97:	e8 62 f9 ff ff       	call   c01016fe <serial_init>
    kbd_init();
c0101d9c:	e8 d1 ff ff ff       	call   c0101d72 <kbd_init>
    if (!serial_exists) {
c0101da1:	a1 28 85 12 c0       	mov    0xc0128528,%eax
c0101da6:	85 c0                	test   %eax,%eax
c0101da8:	75 0c                	jne    c0101db6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101daa:	c7 04 24 a5 a1 10 c0 	movl   $0xc010a1a5,(%esp)
c0101db1:	e8 f3 e4 ff ff       	call   c01002a9 <cprintf>
    }
}
c0101db6:	90                   	nop
c0101db7:	c9                   	leave  
c0101db8:	c3                   	ret    

c0101db9 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101db9:	55                   	push   %ebp
c0101dba:	89 e5                	mov    %esp,%ebp
c0101dbc:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101dbf:	e8 cf f7 ff ff       	call   c0101593 <__intr_save>
c0101dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dca:	89 04 24             	mov    %eax,(%esp)
c0101dcd:	e8 89 fa ff ff       	call   c010185b <lpt_putc>
        cga_putc(c);
c0101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd5:	89 04 24             	mov    %eax,(%esp)
c0101dd8:	e8 be fa ff ff       	call   c010189b <cga_putc>
        serial_putc(c);
c0101ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de0:	89 04 24             	mov    %eax,(%esp)
c0101de3:	e8 f0 fc ff ff       	call   c0101ad8 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101deb:	89 04 24             	mov    %eax,(%esp)
c0101dee:	e8 ca f7 ff ff       	call   c01015bd <__intr_restore>
}
c0101df3:	90                   	nop
c0101df4:	c9                   	leave  
c0101df5:	c3                   	ret    

c0101df6 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101df6:	55                   	push   %ebp
c0101df7:	89 e5                	mov    %esp,%ebp
c0101df9:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101dfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e03:	e8 8b f7 ff ff       	call   c0101593 <__intr_save>
c0101e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101e0b:	e8 ab fd ff ff       	call   c0101bbb <serial_intr>
        kbd_intr();
c0101e10:	e8 48 ff ff ff       	call   c0101d5d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101e15:	8b 15 40 87 12 c0    	mov    0xc0128740,%edx
c0101e1b:	a1 44 87 12 c0       	mov    0xc0128744,%eax
c0101e20:	39 c2                	cmp    %eax,%edx
c0101e22:	74 31                	je     c0101e55 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101e24:	a1 40 87 12 c0       	mov    0xc0128740,%eax
c0101e29:	8d 50 01             	lea    0x1(%eax),%edx
c0101e2c:	89 15 40 87 12 c0    	mov    %edx,0xc0128740
c0101e32:	0f b6 80 40 85 12 c0 	movzbl -0x3fed7ac0(%eax),%eax
c0101e39:	0f b6 c0             	movzbl %al,%eax
c0101e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101e3f:	a1 40 87 12 c0       	mov    0xc0128740,%eax
c0101e44:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101e49:	75 0a                	jne    c0101e55 <cons_getc+0x5f>
                cons.rpos = 0;
c0101e4b:	c7 05 40 87 12 c0 00 	movl   $0x0,0xc0128740
c0101e52:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101e58:	89 04 24             	mov    %eax,(%esp)
c0101e5b:	e8 5d f7 ff ff       	call   c01015bd <__intr_restore>
    return c;
c0101e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e63:	c9                   	leave  
c0101e64:	c3                   	ret    

c0101e65 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101e65:	55                   	push   %ebp
c0101e66:	89 e5                	mov    %esp,%ebp
c0101e68:	83 ec 14             	sub    $0x14,%esp
c0101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e6e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101e75:	66 a3 50 55 12 c0    	mov    %ax,0xc0125550
    if (did_init) {
c0101e7b:	a1 4c 87 12 c0       	mov    0xc012874c,%eax
c0101e80:	85 c0                	test   %eax,%eax
c0101e82:	74 37                	je     c0101ebb <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101e87:	0f b6 c0             	movzbl %al,%eax
c0101e8a:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101e90:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101e93:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101e9b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101e9c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101ea0:	c1 e8 08             	shr    $0x8,%eax
c0101ea3:	0f b7 c0             	movzwl %ax,%eax
c0101ea6:	0f b6 c0             	movzbl %al,%eax
c0101ea9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101eaf:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101eb2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101eb6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101eba:	ee                   	out    %al,(%dx)
    }
}
c0101ebb:	90                   	nop
c0101ebc:	c9                   	leave  
c0101ebd:	c3                   	ret    

c0101ebe <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101ebe:	55                   	push   %ebp
c0101ebf:	89 e5                	mov    %esp,%ebp
c0101ec1:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101ec4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec7:	ba 01 00 00 00       	mov    $0x1,%edx
c0101ecc:	88 c1                	mov    %al,%cl
c0101ece:	d3 e2                	shl    %cl,%edx
c0101ed0:	89 d0                	mov    %edx,%eax
c0101ed2:	98                   	cwtl   
c0101ed3:	f7 d0                	not    %eax
c0101ed5:	0f bf d0             	movswl %ax,%edx
c0101ed8:	0f b7 05 50 55 12 c0 	movzwl 0xc0125550,%eax
c0101edf:	98                   	cwtl   
c0101ee0:	21 d0                	and    %edx,%eax
c0101ee2:	98                   	cwtl   
c0101ee3:	0f b7 c0             	movzwl %ax,%eax
c0101ee6:	89 04 24             	mov    %eax,(%esp)
c0101ee9:	e8 77 ff ff ff       	call   c0101e65 <pic_setmask>
}
c0101eee:	90                   	nop
c0101eef:	c9                   	leave  
c0101ef0:	c3                   	ret    

c0101ef1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101ef1:	55                   	push   %ebp
c0101ef2:	89 e5                	mov    %esp,%ebp
c0101ef4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101ef7:	c7 05 4c 87 12 c0 01 	movl   $0x1,0xc012874c
c0101efe:	00 00 00 
c0101f01:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101f07:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c0101f0b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101f0f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101f13:	ee                   	out    %al,(%dx)
c0101f14:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101f1a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c0101f1e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101f22:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101f26:	ee                   	out    %al,(%dx)
c0101f27:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101f2d:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101f31:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101f35:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101f39:	ee                   	out    %al,(%dx)
c0101f3a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101f40:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101f44:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101f48:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101f4c:	ee                   	out    %al,(%dx)
c0101f4d:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101f53:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c0101f57:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f5b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f5f:	ee                   	out    %al,(%dx)
c0101f60:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101f66:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c0101f6a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f6e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f72:	ee                   	out    %al,(%dx)
c0101f73:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c0101f79:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c0101f7d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f81:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f85:	ee                   	out    %al,(%dx)
c0101f86:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101f8c:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c0101f90:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f94:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f98:	ee                   	out    %al,(%dx)
c0101f99:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101f9f:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c0101fa3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101fa7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101fab:	ee                   	out    %al,(%dx)
c0101fac:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101fb2:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c0101fb6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101fba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101fbe:	ee                   	out    %al,(%dx)
c0101fbf:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101fc5:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c0101fc9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101fcd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101fd1:	ee                   	out    %al,(%dx)
c0101fd2:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101fd8:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c0101fdc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101fe0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101fe4:	ee                   	out    %al,(%dx)
c0101fe5:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c0101feb:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101fef:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff7:	ee                   	out    %al,(%dx)
c0101ff8:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101ffe:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0102002:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102006:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010200a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010200b:	0f b7 05 50 55 12 c0 	movzwl 0xc0125550,%eax
c0102012:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0102017:	74 0f                	je     c0102028 <pic_init+0x137>
        pic_setmask(irq_mask);
c0102019:	0f b7 05 50 55 12 c0 	movzwl 0xc0125550,%eax
c0102020:	89 04 24             	mov    %eax,(%esp)
c0102023:	e8 3d fe ff ff       	call   c0101e65 <pic_setmask>
    }
}
c0102028:	90                   	nop
c0102029:	c9                   	leave  
c010202a:	c3                   	ret    

c010202b <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010202b:	55                   	push   %ebp
c010202c:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010202e:	fb                   	sti    
    sti();
}
c010202f:	90                   	nop
c0102030:	5d                   	pop    %ebp
c0102031:	c3                   	ret    

c0102032 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0102032:	55                   	push   %ebp
c0102033:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0102035:	fa                   	cli    
    cli();
}
c0102036:	90                   	nop
c0102037:	5d                   	pop    %ebp
c0102038:	c3                   	ret    

c0102039 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102039:	55                   	push   %ebp
c010203a:	89 e5                	mov    %esp,%ebp
c010203c:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010203f:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102046:	00 
c0102047:	c7 04 24 e0 a1 10 c0 	movl   $0xc010a1e0,(%esp)
c010204e:	e8 56 e2 ff ff       	call   c01002a9 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102053:	c7 04 24 ea a1 10 c0 	movl   $0xc010a1ea,(%esp)
c010205a:	e8 4a e2 ff ff       	call   c01002a9 <cprintf>
    panic("EOT: kernel seems ok.");
c010205f:	c7 44 24 08 f8 a1 10 	movl   $0xc010a1f8,0x8(%esp)
c0102066:	c0 
c0102067:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c010206e:	00 
c010206f:	c7 04 24 0e a2 10 c0 	movl   $0xc010a20e,(%esp)
c0102076:	e8 85 e3 ff ff       	call   c0100400 <__panic>

c010207b <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010207b:	55                   	push   %ebp
c010207c:	89 e5                	mov    %esp,%ebp
c010207e:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102081:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102088:	e9 c4 00 00 00       	jmp    c0102151 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010208d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102090:	8b 04 85 e0 55 12 c0 	mov    -0x3fedaa20(,%eax,4),%eax
c0102097:	0f b7 d0             	movzwl %ax,%edx
c010209a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010209d:	66 89 14 c5 60 87 12 	mov    %dx,-0x3fed78a0(,%eax,8)
c01020a4:	c0 
c01020a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020a8:	66 c7 04 c5 62 87 12 	movw   $0x8,-0x3fed789e(,%eax,8)
c01020af:	c0 08 00 
c01020b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020b5:	0f b6 14 c5 64 87 12 	movzbl -0x3fed789c(,%eax,8),%edx
c01020bc:	c0 
c01020bd:	80 e2 e0             	and    $0xe0,%dl
c01020c0:	88 14 c5 64 87 12 c0 	mov    %dl,-0x3fed789c(,%eax,8)
c01020c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020ca:	0f b6 14 c5 64 87 12 	movzbl -0x3fed789c(,%eax,8),%edx
c01020d1:	c0 
c01020d2:	80 e2 1f             	and    $0x1f,%dl
c01020d5:	88 14 c5 64 87 12 c0 	mov    %dl,-0x3fed789c(,%eax,8)
c01020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020df:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c01020e6:	c0 
c01020e7:	80 e2 f0             	and    $0xf0,%dl
c01020ea:	80 ca 0e             	or     $0xe,%dl
c01020ed:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c01020f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01020f7:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c01020fe:	c0 
c01020ff:	80 e2 ef             	and    $0xef,%dl
c0102102:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c0102109:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010210c:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c0102113:	c0 
c0102114:	80 e2 9f             	and    $0x9f,%dl
c0102117:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c010211e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102121:	0f b6 14 c5 65 87 12 	movzbl -0x3fed789b(,%eax,8),%edx
c0102128:	c0 
c0102129:	80 ca 80             	or     $0x80,%dl
c010212c:	88 14 c5 65 87 12 c0 	mov    %dl,-0x3fed789b(,%eax,8)
c0102133:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102136:	8b 04 85 e0 55 12 c0 	mov    -0x3fedaa20(,%eax,4),%eax
c010213d:	c1 e8 10             	shr    $0x10,%eax
c0102140:	0f b7 d0             	movzwl %ax,%edx
c0102143:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102146:	66 89 14 c5 66 87 12 	mov    %dx,-0x3fed789a(,%eax,8)
c010214d:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010214e:	ff 45 fc             	incl   -0x4(%ebp)
c0102151:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102154:	3d ff 00 00 00       	cmp    $0xff,%eax
c0102159:	0f 86 2e ff ff ff    	jbe    c010208d <idt_init+0x12>
c010215f:	c7 45 f8 60 55 12 c0 	movl   $0xc0125560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102166:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102169:	0f 01 18             	lidtl  (%eax)
    }
    lidt(&idt_pd);
}
c010216c:	90                   	nop
c010216d:	c9                   	leave  
c010216e:	c3                   	ret    

c010216f <trapname>:

static const char *
trapname(int trapno) {
c010216f:	55                   	push   %ebp
c0102170:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102172:	8b 45 08             	mov    0x8(%ebp),%eax
c0102175:	83 f8 13             	cmp    $0x13,%eax
c0102178:	77 0c                	ja     c0102186 <trapname+0x17>
        return excnames[trapno];
c010217a:	8b 45 08             	mov    0x8(%ebp),%eax
c010217d:	8b 04 85 e0 a5 10 c0 	mov    -0x3fef5a20(,%eax,4),%eax
c0102184:	eb 18                	jmp    c010219e <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102186:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010218a:	7e 0d                	jle    c0102199 <trapname+0x2a>
c010218c:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102190:	7f 07                	jg     c0102199 <trapname+0x2a>
        return "Hardware Interrupt";
c0102192:	b8 1f a2 10 c0       	mov    $0xc010a21f,%eax
c0102197:	eb 05                	jmp    c010219e <trapname+0x2f>
    }
    return "(unknown trap)";
c0102199:	b8 32 a2 10 c0       	mov    $0xc010a232,%eax
}
c010219e:	5d                   	pop    %ebp
c010219f:	c3                   	ret    

c01021a0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01021a0:	55                   	push   %ebp
c01021a1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01021a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01021a6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01021aa:	83 f8 08             	cmp    $0x8,%eax
c01021ad:	0f 94 c0             	sete   %al
c01021b0:	0f b6 c0             	movzbl %al,%eax
}
c01021b3:	5d                   	pop    %ebp
c01021b4:	c3                   	ret    

c01021b5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01021b5:	55                   	push   %ebp
c01021b6:	89 e5                	mov    %esp,%ebp
c01021b8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01021bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01021be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01021c2:	c7 04 24 73 a2 10 c0 	movl   $0xc010a273,(%esp)
c01021c9:	e8 db e0 ff ff       	call   c01002a9 <cprintf>
    print_regs(&tf->tf_regs);
c01021ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01021d1:	89 04 24             	mov    %eax,(%esp)
c01021d4:	e8 8f 01 00 00       	call   c0102368 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01021d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01021dc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01021e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01021e4:	c7 04 24 84 a2 10 c0 	movl   $0xc010a284,(%esp)
c01021eb:	e8 b9 e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01021f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01021f3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01021f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01021fb:	c7 04 24 97 a2 10 c0 	movl   $0xc010a297,(%esp)
c0102202:	e8 a2 e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102207:	8b 45 08             	mov    0x8(%ebp),%eax
c010220a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010220e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102212:	c7 04 24 aa a2 10 c0 	movl   $0xc010a2aa,(%esp)
c0102219:	e8 8b e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010221e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102221:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102225:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102229:	c7 04 24 bd a2 10 c0 	movl   $0xc010a2bd,(%esp)
c0102230:	e8 74 e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102235:	8b 45 08             	mov    0x8(%ebp),%eax
c0102238:	8b 40 30             	mov    0x30(%eax),%eax
c010223b:	89 04 24             	mov    %eax,(%esp)
c010223e:	e8 2c ff ff ff       	call   c010216f <trapname>
c0102243:	89 c2                	mov    %eax,%edx
c0102245:	8b 45 08             	mov    0x8(%ebp),%eax
c0102248:	8b 40 30             	mov    0x30(%eax),%eax
c010224b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010224f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102253:	c7 04 24 d0 a2 10 c0 	movl   $0xc010a2d0,(%esp)
c010225a:	e8 4a e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010225f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102262:	8b 40 34             	mov    0x34(%eax),%eax
c0102265:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102269:	c7 04 24 e2 a2 10 c0 	movl   $0xc010a2e2,(%esp)
c0102270:	e8 34 e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102275:	8b 45 08             	mov    0x8(%ebp),%eax
c0102278:	8b 40 38             	mov    0x38(%eax),%eax
c010227b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010227f:	c7 04 24 f1 a2 10 c0 	movl   $0xc010a2f1,(%esp)
c0102286:	e8 1e e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c010228b:	8b 45 08             	mov    0x8(%ebp),%eax
c010228e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102292:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102296:	c7 04 24 00 a3 10 c0 	movl   $0xc010a300,(%esp)
c010229d:	e8 07 e0 ff ff       	call   c01002a9 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01022a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a5:	8b 40 40             	mov    0x40(%eax),%eax
c01022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022ac:	c7 04 24 13 a3 10 c0 	movl   $0xc010a313,(%esp)
c01022b3:	e8 f1 df ff ff       	call   c01002a9 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01022b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01022bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01022c6:	eb 3d                	jmp    c0102305 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01022c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022cb:	8b 50 40             	mov    0x40(%eax),%edx
c01022ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01022d1:	21 d0                	and    %edx,%eax
c01022d3:	85 c0                	test   %eax,%eax
c01022d5:	74 28                	je     c01022ff <print_trapframe+0x14a>
c01022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01022da:	8b 04 85 80 55 12 c0 	mov    -0x3fedaa80(,%eax,4),%eax
c01022e1:	85 c0                	test   %eax,%eax
c01022e3:	74 1a                	je     c01022ff <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c01022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01022e8:	8b 04 85 80 55 12 c0 	mov    -0x3fedaa80(,%eax,4),%eax
c01022ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022f3:	c7 04 24 22 a3 10 c0 	movl   $0xc010a322,(%esp)
c01022fa:	e8 aa df ff ff       	call   c01002a9 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01022ff:	ff 45 f4             	incl   -0xc(%ebp)
c0102302:	d1 65 f0             	shll   -0x10(%ebp)
c0102305:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102308:	83 f8 17             	cmp    $0x17,%eax
c010230b:	76 bb                	jbe    c01022c8 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010230d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102310:	8b 40 40             	mov    0x40(%eax),%eax
c0102313:	c1 e8 0c             	shr    $0xc,%eax
c0102316:	83 e0 03             	and    $0x3,%eax
c0102319:	89 44 24 04          	mov    %eax,0x4(%esp)
c010231d:	c7 04 24 26 a3 10 c0 	movl   $0xc010a326,(%esp)
c0102324:	e8 80 df ff ff       	call   c01002a9 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102329:	8b 45 08             	mov    0x8(%ebp),%eax
c010232c:	89 04 24             	mov    %eax,(%esp)
c010232f:	e8 6c fe ff ff       	call   c01021a0 <trap_in_kernel>
c0102334:	85 c0                	test   %eax,%eax
c0102336:	75 2d                	jne    c0102365 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102338:	8b 45 08             	mov    0x8(%ebp),%eax
c010233b:	8b 40 44             	mov    0x44(%eax),%eax
c010233e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102342:	c7 04 24 2f a3 10 c0 	movl   $0xc010a32f,(%esp)
c0102349:	e8 5b df ff ff       	call   c01002a9 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010234e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102351:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102355:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102359:	c7 04 24 3e a3 10 c0 	movl   $0xc010a33e,(%esp)
c0102360:	e8 44 df ff ff       	call   c01002a9 <cprintf>
    }
}
c0102365:	90                   	nop
c0102366:	c9                   	leave  
c0102367:	c3                   	ret    

c0102368 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102368:	55                   	push   %ebp
c0102369:	89 e5                	mov    %esp,%ebp
c010236b:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010236e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102371:	8b 00                	mov    (%eax),%eax
c0102373:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102377:	c7 04 24 51 a3 10 c0 	movl   $0xc010a351,(%esp)
c010237e:	e8 26 df ff ff       	call   c01002a9 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102383:	8b 45 08             	mov    0x8(%ebp),%eax
c0102386:	8b 40 04             	mov    0x4(%eax),%eax
c0102389:	89 44 24 04          	mov    %eax,0x4(%esp)
c010238d:	c7 04 24 60 a3 10 c0 	movl   $0xc010a360,(%esp)
c0102394:	e8 10 df ff ff       	call   c01002a9 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102399:	8b 45 08             	mov    0x8(%ebp),%eax
c010239c:	8b 40 08             	mov    0x8(%eax),%eax
c010239f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a3:	c7 04 24 6f a3 10 c0 	movl   $0xc010a36f,(%esp)
c01023aa:	e8 fa de ff ff       	call   c01002a9 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01023af:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b2:	8b 40 0c             	mov    0xc(%eax),%eax
c01023b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b9:	c7 04 24 7e a3 10 c0 	movl   $0xc010a37e,(%esp)
c01023c0:	e8 e4 de ff ff       	call   c01002a9 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01023c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c8:	8b 40 10             	mov    0x10(%eax),%eax
c01023cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023cf:	c7 04 24 8d a3 10 c0 	movl   $0xc010a38d,(%esp)
c01023d6:	e8 ce de ff ff       	call   c01002a9 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01023db:	8b 45 08             	mov    0x8(%ebp),%eax
c01023de:	8b 40 14             	mov    0x14(%eax),%eax
c01023e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e5:	c7 04 24 9c a3 10 c0 	movl   $0xc010a39c,(%esp)
c01023ec:	e8 b8 de ff ff       	call   c01002a9 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01023f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f4:	8b 40 18             	mov    0x18(%eax),%eax
c01023f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023fb:	c7 04 24 ab a3 10 c0 	movl   $0xc010a3ab,(%esp)
c0102402:	e8 a2 de ff ff       	call   c01002a9 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102407:	8b 45 08             	mov    0x8(%ebp),%eax
c010240a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010240d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102411:	c7 04 24 ba a3 10 c0 	movl   $0xc010a3ba,(%esp)
c0102418:	e8 8c de ff ff       	call   c01002a9 <cprintf>
}
c010241d:	90                   	nop
c010241e:	c9                   	leave  
c010241f:	c3                   	ret    

c0102420 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102420:	55                   	push   %ebp
c0102421:	89 e5                	mov    %esp,%ebp
c0102423:	53                   	push   %ebx
c0102424:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102427:	8b 45 08             	mov    0x8(%ebp),%eax
c010242a:	8b 40 34             	mov    0x34(%eax),%eax
c010242d:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102430:	85 c0                	test   %eax,%eax
c0102432:	74 07                	je     c010243b <print_pgfault+0x1b>
c0102434:	bb c9 a3 10 c0       	mov    $0xc010a3c9,%ebx
c0102439:	eb 05                	jmp    c0102440 <print_pgfault+0x20>
c010243b:	bb da a3 10 c0       	mov    $0xc010a3da,%ebx
            (tf->tf_err & 2) ? 'W' : 'R',
c0102440:	8b 45 08             	mov    0x8(%ebp),%eax
c0102443:	8b 40 34             	mov    0x34(%eax),%eax
c0102446:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102449:	85 c0                	test   %eax,%eax
c010244b:	74 07                	je     c0102454 <print_pgfault+0x34>
c010244d:	b9 57 00 00 00       	mov    $0x57,%ecx
c0102452:	eb 05                	jmp    c0102459 <print_pgfault+0x39>
c0102454:	b9 52 00 00 00       	mov    $0x52,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102459:	8b 45 08             	mov    0x8(%ebp),%eax
c010245c:	8b 40 34             	mov    0x34(%eax),%eax
c010245f:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102462:	85 c0                	test   %eax,%eax
c0102464:	74 07                	je     c010246d <print_pgfault+0x4d>
c0102466:	ba 55 00 00 00       	mov    $0x55,%edx
c010246b:	eb 05                	jmp    c0102472 <print_pgfault+0x52>
c010246d:	ba 4b 00 00 00       	mov    $0x4b,%edx
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102472:	0f 20 d0             	mov    %cr2,%eax
c0102475:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102478:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010247b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c010247f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0102483:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248b:	c7 04 24 e8 a3 10 c0 	movl   $0xc010a3e8,(%esp)
c0102492:	e8 12 de ff ff       	call   c01002a9 <cprintf>
}
c0102497:	90                   	nop
c0102498:	83 c4 34             	add    $0x34,%esp
c010249b:	5b                   	pop    %ebx
c010249c:	5d                   	pop    %ebp
c010249d:	c3                   	ret    

c010249e <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010249e:	55                   	push   %ebp
c010249f:	89 e5                	mov    %esp,%ebp
c01024a1:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01024a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a7:	89 04 24             	mov    %eax,(%esp)
c01024aa:	e8 71 ff ff ff       	call   c0102420 <print_pgfault>
    if (check_mm_struct != NULL) {
c01024af:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c01024b4:	85 c0                	test   %eax,%eax
c01024b6:	74 26                	je     c01024de <pgfault_handler+0x40>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01024b8:	0f 20 d0             	mov    %cr2,%eax
c01024bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01024be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01024c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c4:	8b 50 34             	mov    0x34(%eax),%edx
c01024c7:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c01024cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01024d0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01024d4:	89 04 24             	mov    %eax,(%esp)
c01024d7:	e8 69 17 00 00       	call   c0103c45 <do_pgfault>
c01024dc:	eb 1c                	jmp    c01024fa <pgfault_handler+0x5c>
    }
    panic("unhandled page fault.\n");
c01024de:	c7 44 24 08 0b a4 10 	movl   $0xc010a40b,0x8(%esp)
c01024e5:	c0 
c01024e6:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c01024ed:	00 
c01024ee:	c7 04 24 0e a2 10 c0 	movl   $0xc010a20e,(%esp)
c01024f5:	e8 06 df ff ff       	call   c0100400 <__panic>
}
c01024fa:	c9                   	leave  
c01024fb:	c3                   	ret    

c01024fc <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01024fc:	55                   	push   %ebp
c01024fd:	89 e5                	mov    %esp,%ebp
c01024ff:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	8b 40 30             	mov    0x30(%eax),%eax
c0102508:	83 f8 24             	cmp    $0x24,%eax
c010250b:	0f 84 cc 00 00 00    	je     c01025dd <trap_dispatch+0xe1>
c0102511:	83 f8 24             	cmp    $0x24,%eax
c0102514:	77 18                	ja     c010252e <trap_dispatch+0x32>
c0102516:	83 f8 20             	cmp    $0x20,%eax
c0102519:	74 7c                	je     c0102597 <trap_dispatch+0x9b>
c010251b:	83 f8 21             	cmp    $0x21,%eax
c010251e:	0f 84 df 00 00 00    	je     c0102603 <trap_dispatch+0x107>
c0102524:	83 f8 0e             	cmp    $0xe,%eax
c0102527:	74 28                	je     c0102551 <trap_dispatch+0x55>
c0102529:	e9 17 01 00 00       	jmp    c0102645 <trap_dispatch+0x149>
c010252e:	83 f8 2e             	cmp    $0x2e,%eax
c0102531:	0f 82 0e 01 00 00    	jb     c0102645 <trap_dispatch+0x149>
c0102537:	83 f8 2f             	cmp    $0x2f,%eax
c010253a:	0f 86 3a 01 00 00    	jbe    c010267a <trap_dispatch+0x17e>
c0102540:	83 e8 78             	sub    $0x78,%eax
c0102543:	83 f8 01             	cmp    $0x1,%eax
c0102546:	0f 87 f9 00 00 00    	ja     c0102645 <trap_dispatch+0x149>
c010254c:	e9 d8 00 00 00       	jmp    c0102629 <trap_dispatch+0x12d>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102551:	8b 45 08             	mov    0x8(%ebp),%eax
c0102554:	89 04 24             	mov    %eax,(%esp)
c0102557:	e8 42 ff ff ff       	call   c010249e <pgfault_handler>
c010255c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010255f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102563:	0f 84 14 01 00 00    	je     c010267d <trap_dispatch+0x181>
            print_trapframe(tf);
c0102569:	8b 45 08             	mov    0x8(%ebp),%eax
c010256c:	89 04 24             	mov    %eax,(%esp)
c010256f:	e8 41 fc ff ff       	call   c01021b5 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102574:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102577:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010257b:	c7 44 24 08 22 a4 10 	movl   $0xc010a422,0x8(%esp)
c0102582:	c0 
c0102583:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c010258a:	00 
c010258b:	c7 04 24 0e a2 10 c0 	movl   $0xc010a20e,(%esp)
c0102592:	e8 69 de ff ff       	call   c0100400 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0102597:	a1 54 b0 12 c0       	mov    0xc012b054,%eax
c010259c:	40                   	inc    %eax
c010259d:	a3 54 b0 12 c0       	mov    %eax,0xc012b054
        if (ticks % TICK_NUM == 0) {
c01025a2:	8b 0d 54 b0 12 c0    	mov    0xc012b054,%ecx
c01025a8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01025ad:	89 c8                	mov    %ecx,%eax
c01025af:	f7 e2                	mul    %edx
c01025b1:	c1 ea 05             	shr    $0x5,%edx
c01025b4:	89 d0                	mov    %edx,%eax
c01025b6:	c1 e0 02             	shl    $0x2,%eax
c01025b9:	01 d0                	add    %edx,%eax
c01025bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01025c2:	01 d0                	add    %edx,%eax
c01025c4:	c1 e0 02             	shl    $0x2,%eax
c01025c7:	29 c1                	sub    %eax,%ecx
c01025c9:	89 ca                	mov    %ecx,%edx
c01025cb:	85 d2                	test   %edx,%edx
c01025cd:	0f 85 ad 00 00 00    	jne    c0102680 <trap_dispatch+0x184>
            print_ticks();
c01025d3:	e8 61 fa ff ff       	call   c0102039 <print_ticks>
        }
        break;
c01025d8:	e9 a3 00 00 00       	jmp    c0102680 <trap_dispatch+0x184>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01025dd:	e8 14 f8 ff ff       	call   c0101df6 <cons_getc>
c01025e2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01025e5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c01025e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01025ed:	89 54 24 08          	mov    %edx,0x8(%esp)
c01025f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f5:	c7 04 24 3d a4 10 c0 	movl   $0xc010a43d,(%esp)
c01025fc:	e8 a8 dc ff ff       	call   c01002a9 <cprintf>
        break;
c0102601:	eb 7e                	jmp    c0102681 <trap_dispatch+0x185>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102603:	e8 ee f7 ff ff       	call   c0101df6 <cons_getc>
c0102608:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c010260b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c010260f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0102613:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102617:	89 44 24 04          	mov    %eax,0x4(%esp)
c010261b:	c7 04 24 4f a4 10 c0 	movl   $0xc010a44f,(%esp)
c0102622:	e8 82 dc ff ff       	call   c01002a9 <cprintf>
        break;
c0102627:	eb 58                	jmp    c0102681 <trap_dispatch+0x185>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102629:	c7 44 24 08 5e a4 10 	movl   $0xc010a45e,0x8(%esp)
c0102630:	c0 
c0102631:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0102638:	00 
c0102639:	c7 04 24 0e a2 10 c0 	movl   $0xc010a20e,(%esp)
c0102640:	e8 bb dd ff ff       	call   c0100400 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102645:	8b 45 08             	mov    0x8(%ebp),%eax
c0102648:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010264c:	83 e0 03             	and    $0x3,%eax
c010264f:	85 c0                	test   %eax,%eax
c0102651:	75 2e                	jne    c0102681 <trap_dispatch+0x185>
            print_trapframe(tf);
c0102653:	8b 45 08             	mov    0x8(%ebp),%eax
c0102656:	89 04 24             	mov    %eax,(%esp)
c0102659:	e8 57 fb ff ff       	call   c01021b5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010265e:	c7 44 24 08 6e a4 10 	movl   $0xc010a46e,0x8(%esp)
c0102665:	c0 
c0102666:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010266d:	00 
c010266e:	c7 04 24 0e a2 10 c0 	movl   $0xc010a20e,(%esp)
c0102675:	e8 86 dd ff ff       	call   c0100400 <__panic>
        break;
c010267a:	90                   	nop
c010267b:	eb 04                	jmp    c0102681 <trap_dispatch+0x185>
        break;
c010267d:	90                   	nop
c010267e:	eb 01                	jmp    c0102681 <trap_dispatch+0x185>
        break;
c0102680:	90                   	nop
        }
    }
}
c0102681:	90                   	nop
c0102682:	c9                   	leave  
c0102683:	c3                   	ret    

c0102684 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102684:	55                   	push   %ebp
c0102685:	89 e5                	mov    %esp,%ebp
c0102687:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010268a:	8b 45 08             	mov    0x8(%ebp),%eax
c010268d:	89 04 24             	mov    %eax,(%esp)
c0102690:	e8 67 fe ff ff       	call   c01024fc <trap_dispatch>
}
c0102695:	90                   	nop
c0102696:	c9                   	leave  
c0102697:	c3                   	ret    

c0102698 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $0
c010269a:	6a 00                	push   $0x0
  jmp __alltraps
c010269c:	e9 69 0a 00 00       	jmp    c010310a <__alltraps>

c01026a1 <vector1>:
.globl vector1
vector1:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $1
c01026a3:	6a 01                	push   $0x1
  jmp __alltraps
c01026a5:	e9 60 0a 00 00       	jmp    c010310a <__alltraps>

c01026aa <vector2>:
.globl vector2
vector2:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $2
c01026ac:	6a 02                	push   $0x2
  jmp __alltraps
c01026ae:	e9 57 0a 00 00       	jmp    c010310a <__alltraps>

c01026b3 <vector3>:
.globl vector3
vector3:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $3
c01026b5:	6a 03                	push   $0x3
  jmp __alltraps
c01026b7:	e9 4e 0a 00 00       	jmp    c010310a <__alltraps>

c01026bc <vector4>:
.globl vector4
vector4:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $4
c01026be:	6a 04                	push   $0x4
  jmp __alltraps
c01026c0:	e9 45 0a 00 00       	jmp    c010310a <__alltraps>

c01026c5 <vector5>:
.globl vector5
vector5:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $5
c01026c7:	6a 05                	push   $0x5
  jmp __alltraps
c01026c9:	e9 3c 0a 00 00       	jmp    c010310a <__alltraps>

c01026ce <vector6>:
.globl vector6
vector6:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $6
c01026d0:	6a 06                	push   $0x6
  jmp __alltraps
c01026d2:	e9 33 0a 00 00       	jmp    c010310a <__alltraps>

c01026d7 <vector7>:
.globl vector7
vector7:
  pushl $0
c01026d7:	6a 00                	push   $0x0
  pushl $7
c01026d9:	6a 07                	push   $0x7
  jmp __alltraps
c01026db:	e9 2a 0a 00 00       	jmp    c010310a <__alltraps>

c01026e0 <vector8>:
.globl vector8
vector8:
  pushl $8
c01026e0:	6a 08                	push   $0x8
  jmp __alltraps
c01026e2:	e9 23 0a 00 00       	jmp    c010310a <__alltraps>

c01026e7 <vector9>:
.globl vector9
vector9:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $9
c01026e9:	6a 09                	push   $0x9
  jmp __alltraps
c01026eb:	e9 1a 0a 00 00       	jmp    c010310a <__alltraps>

c01026f0 <vector10>:
.globl vector10
vector10:
  pushl $10
c01026f0:	6a 0a                	push   $0xa
  jmp __alltraps
c01026f2:	e9 13 0a 00 00       	jmp    c010310a <__alltraps>

c01026f7 <vector11>:
.globl vector11
vector11:
  pushl $11
c01026f7:	6a 0b                	push   $0xb
  jmp __alltraps
c01026f9:	e9 0c 0a 00 00       	jmp    c010310a <__alltraps>

c01026fe <vector12>:
.globl vector12
vector12:
  pushl $12
c01026fe:	6a 0c                	push   $0xc
  jmp __alltraps
c0102700:	e9 05 0a 00 00       	jmp    c010310a <__alltraps>

c0102705 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102705:	6a 0d                	push   $0xd
  jmp __alltraps
c0102707:	e9 fe 09 00 00       	jmp    c010310a <__alltraps>

c010270c <vector14>:
.globl vector14
vector14:
  pushl $14
c010270c:	6a 0e                	push   $0xe
  jmp __alltraps
c010270e:	e9 f7 09 00 00       	jmp    c010310a <__alltraps>

c0102713 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102713:	6a 00                	push   $0x0
  pushl $15
c0102715:	6a 0f                	push   $0xf
  jmp __alltraps
c0102717:	e9 ee 09 00 00       	jmp    c010310a <__alltraps>

c010271c <vector16>:
.globl vector16
vector16:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $16
c010271e:	6a 10                	push   $0x10
  jmp __alltraps
c0102720:	e9 e5 09 00 00       	jmp    c010310a <__alltraps>

c0102725 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102725:	6a 11                	push   $0x11
  jmp __alltraps
c0102727:	e9 de 09 00 00       	jmp    c010310a <__alltraps>

c010272c <vector18>:
.globl vector18
vector18:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $18
c010272e:	6a 12                	push   $0x12
  jmp __alltraps
c0102730:	e9 d5 09 00 00       	jmp    c010310a <__alltraps>

c0102735 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $19
c0102737:	6a 13                	push   $0x13
  jmp __alltraps
c0102739:	e9 cc 09 00 00       	jmp    c010310a <__alltraps>

c010273e <vector20>:
.globl vector20
vector20:
  pushl $0
c010273e:	6a 00                	push   $0x0
  pushl $20
c0102740:	6a 14                	push   $0x14
  jmp __alltraps
c0102742:	e9 c3 09 00 00       	jmp    c010310a <__alltraps>

c0102747 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102747:	6a 00                	push   $0x0
  pushl $21
c0102749:	6a 15                	push   $0x15
  jmp __alltraps
c010274b:	e9 ba 09 00 00       	jmp    c010310a <__alltraps>

c0102750 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $22
c0102752:	6a 16                	push   $0x16
  jmp __alltraps
c0102754:	e9 b1 09 00 00       	jmp    c010310a <__alltraps>

c0102759 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $23
c010275b:	6a 17                	push   $0x17
  jmp __alltraps
c010275d:	e9 a8 09 00 00       	jmp    c010310a <__alltraps>

c0102762 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102762:	6a 00                	push   $0x0
  pushl $24
c0102764:	6a 18                	push   $0x18
  jmp __alltraps
c0102766:	e9 9f 09 00 00       	jmp    c010310a <__alltraps>

c010276b <vector25>:
.globl vector25
vector25:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $25
c010276d:	6a 19                	push   $0x19
  jmp __alltraps
c010276f:	e9 96 09 00 00       	jmp    c010310a <__alltraps>

c0102774 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $26
c0102776:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102778:	e9 8d 09 00 00       	jmp    c010310a <__alltraps>

c010277d <vector27>:
.globl vector27
vector27:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $27
c010277f:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102781:	e9 84 09 00 00       	jmp    c010310a <__alltraps>

c0102786 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102786:	6a 00                	push   $0x0
  pushl $28
c0102788:	6a 1c                	push   $0x1c
  jmp __alltraps
c010278a:	e9 7b 09 00 00       	jmp    c010310a <__alltraps>

c010278f <vector29>:
.globl vector29
vector29:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $29
c0102791:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102793:	e9 72 09 00 00       	jmp    c010310a <__alltraps>

c0102798 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $30
c010279a:	6a 1e                	push   $0x1e
  jmp __alltraps
c010279c:	e9 69 09 00 00       	jmp    c010310a <__alltraps>

c01027a1 <vector31>:
.globl vector31
vector31:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $31
c01027a3:	6a 1f                	push   $0x1f
  jmp __alltraps
c01027a5:	e9 60 09 00 00       	jmp    c010310a <__alltraps>

c01027aa <vector32>:
.globl vector32
vector32:
  pushl $0
c01027aa:	6a 00                	push   $0x0
  pushl $32
c01027ac:	6a 20                	push   $0x20
  jmp __alltraps
c01027ae:	e9 57 09 00 00       	jmp    c010310a <__alltraps>

c01027b3 <vector33>:
.globl vector33
vector33:
  pushl $0
c01027b3:	6a 00                	push   $0x0
  pushl $33
c01027b5:	6a 21                	push   $0x21
  jmp __alltraps
c01027b7:	e9 4e 09 00 00       	jmp    c010310a <__alltraps>

c01027bc <vector34>:
.globl vector34
vector34:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $34
c01027be:	6a 22                	push   $0x22
  jmp __alltraps
c01027c0:	e9 45 09 00 00       	jmp    c010310a <__alltraps>

c01027c5 <vector35>:
.globl vector35
vector35:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $35
c01027c7:	6a 23                	push   $0x23
  jmp __alltraps
c01027c9:	e9 3c 09 00 00       	jmp    c010310a <__alltraps>

c01027ce <vector36>:
.globl vector36
vector36:
  pushl $0
c01027ce:	6a 00                	push   $0x0
  pushl $36
c01027d0:	6a 24                	push   $0x24
  jmp __alltraps
c01027d2:	e9 33 09 00 00       	jmp    c010310a <__alltraps>

c01027d7 <vector37>:
.globl vector37
vector37:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $37
c01027d9:	6a 25                	push   $0x25
  jmp __alltraps
c01027db:	e9 2a 09 00 00       	jmp    c010310a <__alltraps>

c01027e0 <vector38>:
.globl vector38
vector38:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $38
c01027e2:	6a 26                	push   $0x26
  jmp __alltraps
c01027e4:	e9 21 09 00 00       	jmp    c010310a <__alltraps>

c01027e9 <vector39>:
.globl vector39
vector39:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $39
c01027eb:	6a 27                	push   $0x27
  jmp __alltraps
c01027ed:	e9 18 09 00 00       	jmp    c010310a <__alltraps>

c01027f2 <vector40>:
.globl vector40
vector40:
  pushl $0
c01027f2:	6a 00                	push   $0x0
  pushl $40
c01027f4:	6a 28                	push   $0x28
  jmp __alltraps
c01027f6:	e9 0f 09 00 00       	jmp    c010310a <__alltraps>

c01027fb <vector41>:
.globl vector41
vector41:
  pushl $0
c01027fb:	6a 00                	push   $0x0
  pushl $41
c01027fd:	6a 29                	push   $0x29
  jmp __alltraps
c01027ff:	e9 06 09 00 00       	jmp    c010310a <__alltraps>

c0102804 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $42
c0102806:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102808:	e9 fd 08 00 00       	jmp    c010310a <__alltraps>

c010280d <vector43>:
.globl vector43
vector43:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $43
c010280f:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102811:	e9 f4 08 00 00       	jmp    c010310a <__alltraps>

c0102816 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102816:	6a 00                	push   $0x0
  pushl $44
c0102818:	6a 2c                	push   $0x2c
  jmp __alltraps
c010281a:	e9 eb 08 00 00       	jmp    c010310a <__alltraps>

c010281f <vector45>:
.globl vector45
vector45:
  pushl $0
c010281f:	6a 00                	push   $0x0
  pushl $45
c0102821:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102823:	e9 e2 08 00 00       	jmp    c010310a <__alltraps>

c0102828 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $46
c010282a:	6a 2e                	push   $0x2e
  jmp __alltraps
c010282c:	e9 d9 08 00 00       	jmp    c010310a <__alltraps>

c0102831 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $47
c0102833:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102835:	e9 d0 08 00 00       	jmp    c010310a <__alltraps>

c010283a <vector48>:
.globl vector48
vector48:
  pushl $0
c010283a:	6a 00                	push   $0x0
  pushl $48
c010283c:	6a 30                	push   $0x30
  jmp __alltraps
c010283e:	e9 c7 08 00 00       	jmp    c010310a <__alltraps>

c0102843 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102843:	6a 00                	push   $0x0
  pushl $49
c0102845:	6a 31                	push   $0x31
  jmp __alltraps
c0102847:	e9 be 08 00 00       	jmp    c010310a <__alltraps>

c010284c <vector50>:
.globl vector50
vector50:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $50
c010284e:	6a 32                	push   $0x32
  jmp __alltraps
c0102850:	e9 b5 08 00 00       	jmp    c010310a <__alltraps>

c0102855 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $51
c0102857:	6a 33                	push   $0x33
  jmp __alltraps
c0102859:	e9 ac 08 00 00       	jmp    c010310a <__alltraps>

c010285e <vector52>:
.globl vector52
vector52:
  pushl $0
c010285e:	6a 00                	push   $0x0
  pushl $52
c0102860:	6a 34                	push   $0x34
  jmp __alltraps
c0102862:	e9 a3 08 00 00       	jmp    c010310a <__alltraps>

c0102867 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $53
c0102869:	6a 35                	push   $0x35
  jmp __alltraps
c010286b:	e9 9a 08 00 00       	jmp    c010310a <__alltraps>

c0102870 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $54
c0102872:	6a 36                	push   $0x36
  jmp __alltraps
c0102874:	e9 91 08 00 00       	jmp    c010310a <__alltraps>

c0102879 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $55
c010287b:	6a 37                	push   $0x37
  jmp __alltraps
c010287d:	e9 88 08 00 00       	jmp    c010310a <__alltraps>

c0102882 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102882:	6a 00                	push   $0x0
  pushl $56
c0102884:	6a 38                	push   $0x38
  jmp __alltraps
c0102886:	e9 7f 08 00 00       	jmp    c010310a <__alltraps>

c010288b <vector57>:
.globl vector57
vector57:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $57
c010288d:	6a 39                	push   $0x39
  jmp __alltraps
c010288f:	e9 76 08 00 00       	jmp    c010310a <__alltraps>

c0102894 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $58
c0102896:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102898:	e9 6d 08 00 00       	jmp    c010310a <__alltraps>

c010289d <vector59>:
.globl vector59
vector59:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $59
c010289f:	6a 3b                	push   $0x3b
  jmp __alltraps
c01028a1:	e9 64 08 00 00       	jmp    c010310a <__alltraps>

c01028a6 <vector60>:
.globl vector60
vector60:
  pushl $0
c01028a6:	6a 00                	push   $0x0
  pushl $60
c01028a8:	6a 3c                	push   $0x3c
  jmp __alltraps
c01028aa:	e9 5b 08 00 00       	jmp    c010310a <__alltraps>

c01028af <vector61>:
.globl vector61
vector61:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $61
c01028b1:	6a 3d                	push   $0x3d
  jmp __alltraps
c01028b3:	e9 52 08 00 00       	jmp    c010310a <__alltraps>

c01028b8 <vector62>:
.globl vector62
vector62:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $62
c01028ba:	6a 3e                	push   $0x3e
  jmp __alltraps
c01028bc:	e9 49 08 00 00       	jmp    c010310a <__alltraps>

c01028c1 <vector63>:
.globl vector63
vector63:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $63
c01028c3:	6a 3f                	push   $0x3f
  jmp __alltraps
c01028c5:	e9 40 08 00 00       	jmp    c010310a <__alltraps>

c01028ca <vector64>:
.globl vector64
vector64:
  pushl $0
c01028ca:	6a 00                	push   $0x0
  pushl $64
c01028cc:	6a 40                	push   $0x40
  jmp __alltraps
c01028ce:	e9 37 08 00 00       	jmp    c010310a <__alltraps>

c01028d3 <vector65>:
.globl vector65
vector65:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $65
c01028d5:	6a 41                	push   $0x41
  jmp __alltraps
c01028d7:	e9 2e 08 00 00       	jmp    c010310a <__alltraps>

c01028dc <vector66>:
.globl vector66
vector66:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $66
c01028de:	6a 42                	push   $0x42
  jmp __alltraps
c01028e0:	e9 25 08 00 00       	jmp    c010310a <__alltraps>

c01028e5 <vector67>:
.globl vector67
vector67:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $67
c01028e7:	6a 43                	push   $0x43
  jmp __alltraps
c01028e9:	e9 1c 08 00 00       	jmp    c010310a <__alltraps>

c01028ee <vector68>:
.globl vector68
vector68:
  pushl $0
c01028ee:	6a 00                	push   $0x0
  pushl $68
c01028f0:	6a 44                	push   $0x44
  jmp __alltraps
c01028f2:	e9 13 08 00 00       	jmp    c010310a <__alltraps>

c01028f7 <vector69>:
.globl vector69
vector69:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $69
c01028f9:	6a 45                	push   $0x45
  jmp __alltraps
c01028fb:	e9 0a 08 00 00       	jmp    c010310a <__alltraps>

c0102900 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $70
c0102902:	6a 46                	push   $0x46
  jmp __alltraps
c0102904:	e9 01 08 00 00       	jmp    c010310a <__alltraps>

c0102909 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $71
c010290b:	6a 47                	push   $0x47
  jmp __alltraps
c010290d:	e9 f8 07 00 00       	jmp    c010310a <__alltraps>

c0102912 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102912:	6a 00                	push   $0x0
  pushl $72
c0102914:	6a 48                	push   $0x48
  jmp __alltraps
c0102916:	e9 ef 07 00 00       	jmp    c010310a <__alltraps>

c010291b <vector73>:
.globl vector73
vector73:
  pushl $0
c010291b:	6a 00                	push   $0x0
  pushl $73
c010291d:	6a 49                	push   $0x49
  jmp __alltraps
c010291f:	e9 e6 07 00 00       	jmp    c010310a <__alltraps>

c0102924 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $74
c0102926:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102928:	e9 dd 07 00 00       	jmp    c010310a <__alltraps>

c010292d <vector75>:
.globl vector75
vector75:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $75
c010292f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102931:	e9 d4 07 00 00       	jmp    c010310a <__alltraps>

c0102936 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102936:	6a 00                	push   $0x0
  pushl $76
c0102938:	6a 4c                	push   $0x4c
  jmp __alltraps
c010293a:	e9 cb 07 00 00       	jmp    c010310a <__alltraps>

c010293f <vector77>:
.globl vector77
vector77:
  pushl $0
c010293f:	6a 00                	push   $0x0
  pushl $77
c0102941:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102943:	e9 c2 07 00 00       	jmp    c010310a <__alltraps>

c0102948 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $78
c010294a:	6a 4e                	push   $0x4e
  jmp __alltraps
c010294c:	e9 b9 07 00 00       	jmp    c010310a <__alltraps>

c0102951 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $79
c0102953:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102955:	e9 b0 07 00 00       	jmp    c010310a <__alltraps>

c010295a <vector80>:
.globl vector80
vector80:
  pushl $0
c010295a:	6a 00                	push   $0x0
  pushl $80
c010295c:	6a 50                	push   $0x50
  jmp __alltraps
c010295e:	e9 a7 07 00 00       	jmp    c010310a <__alltraps>

c0102963 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102963:	6a 00                	push   $0x0
  pushl $81
c0102965:	6a 51                	push   $0x51
  jmp __alltraps
c0102967:	e9 9e 07 00 00       	jmp    c010310a <__alltraps>

c010296c <vector82>:
.globl vector82
vector82:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $82
c010296e:	6a 52                	push   $0x52
  jmp __alltraps
c0102970:	e9 95 07 00 00       	jmp    c010310a <__alltraps>

c0102975 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $83
c0102977:	6a 53                	push   $0x53
  jmp __alltraps
c0102979:	e9 8c 07 00 00       	jmp    c010310a <__alltraps>

c010297e <vector84>:
.globl vector84
vector84:
  pushl $0
c010297e:	6a 00                	push   $0x0
  pushl $84
c0102980:	6a 54                	push   $0x54
  jmp __alltraps
c0102982:	e9 83 07 00 00       	jmp    c010310a <__alltraps>

c0102987 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102987:	6a 00                	push   $0x0
  pushl $85
c0102989:	6a 55                	push   $0x55
  jmp __alltraps
c010298b:	e9 7a 07 00 00       	jmp    c010310a <__alltraps>

c0102990 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $86
c0102992:	6a 56                	push   $0x56
  jmp __alltraps
c0102994:	e9 71 07 00 00       	jmp    c010310a <__alltraps>

c0102999 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $87
c010299b:	6a 57                	push   $0x57
  jmp __alltraps
c010299d:	e9 68 07 00 00       	jmp    c010310a <__alltraps>

c01029a2 <vector88>:
.globl vector88
vector88:
  pushl $0
c01029a2:	6a 00                	push   $0x0
  pushl $88
c01029a4:	6a 58                	push   $0x58
  jmp __alltraps
c01029a6:	e9 5f 07 00 00       	jmp    c010310a <__alltraps>

c01029ab <vector89>:
.globl vector89
vector89:
  pushl $0
c01029ab:	6a 00                	push   $0x0
  pushl $89
c01029ad:	6a 59                	push   $0x59
  jmp __alltraps
c01029af:	e9 56 07 00 00       	jmp    c010310a <__alltraps>

c01029b4 <vector90>:
.globl vector90
vector90:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $90
c01029b6:	6a 5a                	push   $0x5a
  jmp __alltraps
c01029b8:	e9 4d 07 00 00       	jmp    c010310a <__alltraps>

c01029bd <vector91>:
.globl vector91
vector91:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $91
c01029bf:	6a 5b                	push   $0x5b
  jmp __alltraps
c01029c1:	e9 44 07 00 00       	jmp    c010310a <__alltraps>

c01029c6 <vector92>:
.globl vector92
vector92:
  pushl $0
c01029c6:	6a 00                	push   $0x0
  pushl $92
c01029c8:	6a 5c                	push   $0x5c
  jmp __alltraps
c01029ca:	e9 3b 07 00 00       	jmp    c010310a <__alltraps>

c01029cf <vector93>:
.globl vector93
vector93:
  pushl $0
c01029cf:	6a 00                	push   $0x0
  pushl $93
c01029d1:	6a 5d                	push   $0x5d
  jmp __alltraps
c01029d3:	e9 32 07 00 00       	jmp    c010310a <__alltraps>

c01029d8 <vector94>:
.globl vector94
vector94:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $94
c01029da:	6a 5e                	push   $0x5e
  jmp __alltraps
c01029dc:	e9 29 07 00 00       	jmp    c010310a <__alltraps>

c01029e1 <vector95>:
.globl vector95
vector95:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $95
c01029e3:	6a 5f                	push   $0x5f
  jmp __alltraps
c01029e5:	e9 20 07 00 00       	jmp    c010310a <__alltraps>

c01029ea <vector96>:
.globl vector96
vector96:
  pushl $0
c01029ea:	6a 00                	push   $0x0
  pushl $96
c01029ec:	6a 60                	push   $0x60
  jmp __alltraps
c01029ee:	e9 17 07 00 00       	jmp    c010310a <__alltraps>

c01029f3 <vector97>:
.globl vector97
vector97:
  pushl $0
c01029f3:	6a 00                	push   $0x0
  pushl $97
c01029f5:	6a 61                	push   $0x61
  jmp __alltraps
c01029f7:	e9 0e 07 00 00       	jmp    c010310a <__alltraps>

c01029fc <vector98>:
.globl vector98
vector98:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $98
c01029fe:	6a 62                	push   $0x62
  jmp __alltraps
c0102a00:	e9 05 07 00 00       	jmp    c010310a <__alltraps>

c0102a05 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $99
c0102a07:	6a 63                	push   $0x63
  jmp __alltraps
c0102a09:	e9 fc 06 00 00       	jmp    c010310a <__alltraps>

c0102a0e <vector100>:
.globl vector100
vector100:
  pushl $0
c0102a0e:	6a 00                	push   $0x0
  pushl $100
c0102a10:	6a 64                	push   $0x64
  jmp __alltraps
c0102a12:	e9 f3 06 00 00       	jmp    c010310a <__alltraps>

c0102a17 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102a17:	6a 00                	push   $0x0
  pushl $101
c0102a19:	6a 65                	push   $0x65
  jmp __alltraps
c0102a1b:	e9 ea 06 00 00       	jmp    c010310a <__alltraps>

c0102a20 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $102
c0102a22:	6a 66                	push   $0x66
  jmp __alltraps
c0102a24:	e9 e1 06 00 00       	jmp    c010310a <__alltraps>

c0102a29 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $103
c0102a2b:	6a 67                	push   $0x67
  jmp __alltraps
c0102a2d:	e9 d8 06 00 00       	jmp    c010310a <__alltraps>

c0102a32 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102a32:	6a 00                	push   $0x0
  pushl $104
c0102a34:	6a 68                	push   $0x68
  jmp __alltraps
c0102a36:	e9 cf 06 00 00       	jmp    c010310a <__alltraps>

c0102a3b <vector105>:
.globl vector105
vector105:
  pushl $0
c0102a3b:	6a 00                	push   $0x0
  pushl $105
c0102a3d:	6a 69                	push   $0x69
  jmp __alltraps
c0102a3f:	e9 c6 06 00 00       	jmp    c010310a <__alltraps>

c0102a44 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $106
c0102a46:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102a48:	e9 bd 06 00 00       	jmp    c010310a <__alltraps>

c0102a4d <vector107>:
.globl vector107
vector107:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $107
c0102a4f:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102a51:	e9 b4 06 00 00       	jmp    c010310a <__alltraps>

c0102a56 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102a56:	6a 00                	push   $0x0
  pushl $108
c0102a58:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102a5a:	e9 ab 06 00 00       	jmp    c010310a <__alltraps>

c0102a5f <vector109>:
.globl vector109
vector109:
  pushl $0
c0102a5f:	6a 00                	push   $0x0
  pushl $109
c0102a61:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102a63:	e9 a2 06 00 00       	jmp    c010310a <__alltraps>

c0102a68 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102a68:	6a 00                	push   $0x0
  pushl $110
c0102a6a:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102a6c:	e9 99 06 00 00       	jmp    c010310a <__alltraps>

c0102a71 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $111
c0102a73:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102a75:	e9 90 06 00 00       	jmp    c010310a <__alltraps>

c0102a7a <vector112>:
.globl vector112
vector112:
  pushl $0
c0102a7a:	6a 00                	push   $0x0
  pushl $112
c0102a7c:	6a 70                	push   $0x70
  jmp __alltraps
c0102a7e:	e9 87 06 00 00       	jmp    c010310a <__alltraps>

c0102a83 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $113
c0102a85:	6a 71                	push   $0x71
  jmp __alltraps
c0102a87:	e9 7e 06 00 00       	jmp    c010310a <__alltraps>

c0102a8c <vector114>:
.globl vector114
vector114:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $114
c0102a8e:	6a 72                	push   $0x72
  jmp __alltraps
c0102a90:	e9 75 06 00 00       	jmp    c010310a <__alltraps>

c0102a95 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $115
c0102a97:	6a 73                	push   $0x73
  jmp __alltraps
c0102a99:	e9 6c 06 00 00       	jmp    c010310a <__alltraps>

c0102a9e <vector116>:
.globl vector116
vector116:
  pushl $0
c0102a9e:	6a 00                	push   $0x0
  pushl $116
c0102aa0:	6a 74                	push   $0x74
  jmp __alltraps
c0102aa2:	e9 63 06 00 00       	jmp    c010310a <__alltraps>

c0102aa7 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102aa7:	6a 00                	push   $0x0
  pushl $117
c0102aa9:	6a 75                	push   $0x75
  jmp __alltraps
c0102aab:	e9 5a 06 00 00       	jmp    c010310a <__alltraps>

c0102ab0 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $118
c0102ab2:	6a 76                	push   $0x76
  jmp __alltraps
c0102ab4:	e9 51 06 00 00       	jmp    c010310a <__alltraps>

c0102ab9 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $119
c0102abb:	6a 77                	push   $0x77
  jmp __alltraps
c0102abd:	e9 48 06 00 00       	jmp    c010310a <__alltraps>

c0102ac2 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102ac2:	6a 00                	push   $0x0
  pushl $120
c0102ac4:	6a 78                	push   $0x78
  jmp __alltraps
c0102ac6:	e9 3f 06 00 00       	jmp    c010310a <__alltraps>

c0102acb <vector121>:
.globl vector121
vector121:
  pushl $0
c0102acb:	6a 00                	push   $0x0
  pushl $121
c0102acd:	6a 79                	push   $0x79
  jmp __alltraps
c0102acf:	e9 36 06 00 00       	jmp    c010310a <__alltraps>

c0102ad4 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102ad4:	6a 00                	push   $0x0
  pushl $122
c0102ad6:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102ad8:	e9 2d 06 00 00       	jmp    c010310a <__alltraps>

c0102add <vector123>:
.globl vector123
vector123:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $123
c0102adf:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102ae1:	e9 24 06 00 00       	jmp    c010310a <__alltraps>

c0102ae6 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102ae6:	6a 00                	push   $0x0
  pushl $124
c0102ae8:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102aea:	e9 1b 06 00 00       	jmp    c010310a <__alltraps>

c0102aef <vector125>:
.globl vector125
vector125:
  pushl $0
c0102aef:	6a 00                	push   $0x0
  pushl $125
c0102af1:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102af3:	e9 12 06 00 00       	jmp    c010310a <__alltraps>

c0102af8 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102af8:	6a 00                	push   $0x0
  pushl $126
c0102afa:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102afc:	e9 09 06 00 00       	jmp    c010310a <__alltraps>

c0102b01 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $127
c0102b03:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102b05:	e9 00 06 00 00       	jmp    c010310a <__alltraps>

c0102b0a <vector128>:
.globl vector128
vector128:
  pushl $0
c0102b0a:	6a 00                	push   $0x0
  pushl $128
c0102b0c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102b11:	e9 f4 05 00 00       	jmp    c010310a <__alltraps>

c0102b16 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102b16:	6a 00                	push   $0x0
  pushl $129
c0102b18:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102b1d:	e9 e8 05 00 00       	jmp    c010310a <__alltraps>

c0102b22 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102b22:	6a 00                	push   $0x0
  pushl $130
c0102b24:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102b29:	e9 dc 05 00 00       	jmp    c010310a <__alltraps>

c0102b2e <vector131>:
.globl vector131
vector131:
  pushl $0
c0102b2e:	6a 00                	push   $0x0
  pushl $131
c0102b30:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102b35:	e9 d0 05 00 00       	jmp    c010310a <__alltraps>

c0102b3a <vector132>:
.globl vector132
vector132:
  pushl $0
c0102b3a:	6a 00                	push   $0x0
  pushl $132
c0102b3c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102b41:	e9 c4 05 00 00       	jmp    c010310a <__alltraps>

c0102b46 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102b46:	6a 00                	push   $0x0
  pushl $133
c0102b48:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102b4d:	e9 b8 05 00 00       	jmp    c010310a <__alltraps>

c0102b52 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102b52:	6a 00                	push   $0x0
  pushl $134
c0102b54:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102b59:	e9 ac 05 00 00       	jmp    c010310a <__alltraps>

c0102b5e <vector135>:
.globl vector135
vector135:
  pushl $0
c0102b5e:	6a 00                	push   $0x0
  pushl $135
c0102b60:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102b65:	e9 a0 05 00 00       	jmp    c010310a <__alltraps>

c0102b6a <vector136>:
.globl vector136
vector136:
  pushl $0
c0102b6a:	6a 00                	push   $0x0
  pushl $136
c0102b6c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102b71:	e9 94 05 00 00       	jmp    c010310a <__alltraps>

c0102b76 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102b76:	6a 00                	push   $0x0
  pushl $137
c0102b78:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102b7d:	e9 88 05 00 00       	jmp    c010310a <__alltraps>

c0102b82 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102b82:	6a 00                	push   $0x0
  pushl $138
c0102b84:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102b89:	e9 7c 05 00 00       	jmp    c010310a <__alltraps>

c0102b8e <vector139>:
.globl vector139
vector139:
  pushl $0
c0102b8e:	6a 00                	push   $0x0
  pushl $139
c0102b90:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102b95:	e9 70 05 00 00       	jmp    c010310a <__alltraps>

c0102b9a <vector140>:
.globl vector140
vector140:
  pushl $0
c0102b9a:	6a 00                	push   $0x0
  pushl $140
c0102b9c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102ba1:	e9 64 05 00 00       	jmp    c010310a <__alltraps>

c0102ba6 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102ba6:	6a 00                	push   $0x0
  pushl $141
c0102ba8:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102bad:	e9 58 05 00 00       	jmp    c010310a <__alltraps>

c0102bb2 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102bb2:	6a 00                	push   $0x0
  pushl $142
c0102bb4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102bb9:	e9 4c 05 00 00       	jmp    c010310a <__alltraps>

c0102bbe <vector143>:
.globl vector143
vector143:
  pushl $0
c0102bbe:	6a 00                	push   $0x0
  pushl $143
c0102bc0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102bc5:	e9 40 05 00 00       	jmp    c010310a <__alltraps>

c0102bca <vector144>:
.globl vector144
vector144:
  pushl $0
c0102bca:	6a 00                	push   $0x0
  pushl $144
c0102bcc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102bd1:	e9 34 05 00 00       	jmp    c010310a <__alltraps>

c0102bd6 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102bd6:	6a 00                	push   $0x0
  pushl $145
c0102bd8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102bdd:	e9 28 05 00 00       	jmp    c010310a <__alltraps>

c0102be2 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102be2:	6a 00                	push   $0x0
  pushl $146
c0102be4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102be9:	e9 1c 05 00 00       	jmp    c010310a <__alltraps>

c0102bee <vector147>:
.globl vector147
vector147:
  pushl $0
c0102bee:	6a 00                	push   $0x0
  pushl $147
c0102bf0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102bf5:	e9 10 05 00 00       	jmp    c010310a <__alltraps>

c0102bfa <vector148>:
.globl vector148
vector148:
  pushl $0
c0102bfa:	6a 00                	push   $0x0
  pushl $148
c0102bfc:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102c01:	e9 04 05 00 00       	jmp    c010310a <__alltraps>

c0102c06 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102c06:	6a 00                	push   $0x0
  pushl $149
c0102c08:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102c0d:	e9 f8 04 00 00       	jmp    c010310a <__alltraps>

c0102c12 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102c12:	6a 00                	push   $0x0
  pushl $150
c0102c14:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102c19:	e9 ec 04 00 00       	jmp    c010310a <__alltraps>

c0102c1e <vector151>:
.globl vector151
vector151:
  pushl $0
c0102c1e:	6a 00                	push   $0x0
  pushl $151
c0102c20:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102c25:	e9 e0 04 00 00       	jmp    c010310a <__alltraps>

c0102c2a <vector152>:
.globl vector152
vector152:
  pushl $0
c0102c2a:	6a 00                	push   $0x0
  pushl $152
c0102c2c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102c31:	e9 d4 04 00 00       	jmp    c010310a <__alltraps>

c0102c36 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102c36:	6a 00                	push   $0x0
  pushl $153
c0102c38:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102c3d:	e9 c8 04 00 00       	jmp    c010310a <__alltraps>

c0102c42 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102c42:	6a 00                	push   $0x0
  pushl $154
c0102c44:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102c49:	e9 bc 04 00 00       	jmp    c010310a <__alltraps>

c0102c4e <vector155>:
.globl vector155
vector155:
  pushl $0
c0102c4e:	6a 00                	push   $0x0
  pushl $155
c0102c50:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102c55:	e9 b0 04 00 00       	jmp    c010310a <__alltraps>

c0102c5a <vector156>:
.globl vector156
vector156:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $156
c0102c5c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102c61:	e9 a4 04 00 00       	jmp    c010310a <__alltraps>

c0102c66 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102c66:	6a 00                	push   $0x0
  pushl $157
c0102c68:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102c6d:	e9 98 04 00 00       	jmp    c010310a <__alltraps>

c0102c72 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102c72:	6a 00                	push   $0x0
  pushl $158
c0102c74:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102c79:	e9 8c 04 00 00       	jmp    c010310a <__alltraps>

c0102c7e <vector159>:
.globl vector159
vector159:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $159
c0102c80:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102c85:	e9 80 04 00 00       	jmp    c010310a <__alltraps>

c0102c8a <vector160>:
.globl vector160
vector160:
  pushl $0
c0102c8a:	6a 00                	push   $0x0
  pushl $160
c0102c8c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102c91:	e9 74 04 00 00       	jmp    c010310a <__alltraps>

c0102c96 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $161
c0102c98:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102c9d:	e9 68 04 00 00       	jmp    c010310a <__alltraps>

c0102ca2 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $162
c0102ca4:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102ca9:	e9 5c 04 00 00       	jmp    c010310a <__alltraps>

c0102cae <vector163>:
.globl vector163
vector163:
  pushl $0
c0102cae:	6a 00                	push   $0x0
  pushl $163
c0102cb0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102cb5:	e9 50 04 00 00       	jmp    c010310a <__alltraps>

c0102cba <vector164>:
.globl vector164
vector164:
  pushl $0
c0102cba:	6a 00                	push   $0x0
  pushl $164
c0102cbc:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102cc1:	e9 44 04 00 00       	jmp    c010310a <__alltraps>

c0102cc6 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $165
c0102cc8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ccd:	e9 38 04 00 00       	jmp    c010310a <__alltraps>

c0102cd2 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102cd2:	6a 00                	push   $0x0
  pushl $166
c0102cd4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102cd9:	e9 2c 04 00 00       	jmp    c010310a <__alltraps>

c0102cde <vector167>:
.globl vector167
vector167:
  pushl $0
c0102cde:	6a 00                	push   $0x0
  pushl $167
c0102ce0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102ce5:	e9 20 04 00 00       	jmp    c010310a <__alltraps>

c0102cea <vector168>:
.globl vector168
vector168:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $168
c0102cec:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102cf1:	e9 14 04 00 00       	jmp    c010310a <__alltraps>

c0102cf6 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102cf6:	6a 00                	push   $0x0
  pushl $169
c0102cf8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102cfd:	e9 08 04 00 00       	jmp    c010310a <__alltraps>

c0102d02 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102d02:	6a 00                	push   $0x0
  pushl $170
c0102d04:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102d09:	e9 fc 03 00 00       	jmp    c010310a <__alltraps>

c0102d0e <vector171>:
.globl vector171
vector171:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $171
c0102d10:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102d15:	e9 f0 03 00 00       	jmp    c010310a <__alltraps>

c0102d1a <vector172>:
.globl vector172
vector172:
  pushl $0
c0102d1a:	6a 00                	push   $0x0
  pushl $172
c0102d1c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102d21:	e9 e4 03 00 00       	jmp    c010310a <__alltraps>

c0102d26 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102d26:	6a 00                	push   $0x0
  pushl $173
c0102d28:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102d2d:	e9 d8 03 00 00       	jmp    c010310a <__alltraps>

c0102d32 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $174
c0102d34:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102d39:	e9 cc 03 00 00       	jmp    c010310a <__alltraps>

c0102d3e <vector175>:
.globl vector175
vector175:
  pushl $0
c0102d3e:	6a 00                	push   $0x0
  pushl $175
c0102d40:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102d45:	e9 c0 03 00 00       	jmp    c010310a <__alltraps>

c0102d4a <vector176>:
.globl vector176
vector176:
  pushl $0
c0102d4a:	6a 00                	push   $0x0
  pushl $176
c0102d4c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102d51:	e9 b4 03 00 00       	jmp    c010310a <__alltraps>

c0102d56 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102d56:	6a 00                	push   $0x0
  pushl $177
c0102d58:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102d5d:	e9 a8 03 00 00       	jmp    c010310a <__alltraps>

c0102d62 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102d62:	6a 00                	push   $0x0
  pushl $178
c0102d64:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102d69:	e9 9c 03 00 00       	jmp    c010310a <__alltraps>

c0102d6e <vector179>:
.globl vector179
vector179:
  pushl $0
c0102d6e:	6a 00                	push   $0x0
  pushl $179
c0102d70:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102d75:	e9 90 03 00 00       	jmp    c010310a <__alltraps>

c0102d7a <vector180>:
.globl vector180
vector180:
  pushl $0
c0102d7a:	6a 00                	push   $0x0
  pushl $180
c0102d7c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102d81:	e9 84 03 00 00       	jmp    c010310a <__alltraps>

c0102d86 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102d86:	6a 00                	push   $0x0
  pushl $181
c0102d88:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102d8d:	e9 78 03 00 00       	jmp    c010310a <__alltraps>

c0102d92 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102d92:	6a 00                	push   $0x0
  pushl $182
c0102d94:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102d99:	e9 6c 03 00 00       	jmp    c010310a <__alltraps>

c0102d9e <vector183>:
.globl vector183
vector183:
  pushl $0
c0102d9e:	6a 00                	push   $0x0
  pushl $183
c0102da0:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102da5:	e9 60 03 00 00       	jmp    c010310a <__alltraps>

c0102daa <vector184>:
.globl vector184
vector184:
  pushl $0
c0102daa:	6a 00                	push   $0x0
  pushl $184
c0102dac:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102db1:	e9 54 03 00 00       	jmp    c010310a <__alltraps>

c0102db6 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102db6:	6a 00                	push   $0x0
  pushl $185
c0102db8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102dbd:	e9 48 03 00 00       	jmp    c010310a <__alltraps>

c0102dc2 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102dc2:	6a 00                	push   $0x0
  pushl $186
c0102dc4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102dc9:	e9 3c 03 00 00       	jmp    c010310a <__alltraps>

c0102dce <vector187>:
.globl vector187
vector187:
  pushl $0
c0102dce:	6a 00                	push   $0x0
  pushl $187
c0102dd0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102dd5:	e9 30 03 00 00       	jmp    c010310a <__alltraps>

c0102dda <vector188>:
.globl vector188
vector188:
  pushl $0
c0102dda:	6a 00                	push   $0x0
  pushl $188
c0102ddc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102de1:	e9 24 03 00 00       	jmp    c010310a <__alltraps>

c0102de6 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102de6:	6a 00                	push   $0x0
  pushl $189
c0102de8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ded:	e9 18 03 00 00       	jmp    c010310a <__alltraps>

c0102df2 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102df2:	6a 00                	push   $0x0
  pushl $190
c0102df4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102df9:	e9 0c 03 00 00       	jmp    c010310a <__alltraps>

c0102dfe <vector191>:
.globl vector191
vector191:
  pushl $0
c0102dfe:	6a 00                	push   $0x0
  pushl $191
c0102e00:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102e05:	e9 00 03 00 00       	jmp    c010310a <__alltraps>

c0102e0a <vector192>:
.globl vector192
vector192:
  pushl $0
c0102e0a:	6a 00                	push   $0x0
  pushl $192
c0102e0c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102e11:	e9 f4 02 00 00       	jmp    c010310a <__alltraps>

c0102e16 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102e16:	6a 00                	push   $0x0
  pushl $193
c0102e18:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102e1d:	e9 e8 02 00 00       	jmp    c010310a <__alltraps>

c0102e22 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102e22:	6a 00                	push   $0x0
  pushl $194
c0102e24:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102e29:	e9 dc 02 00 00       	jmp    c010310a <__alltraps>

c0102e2e <vector195>:
.globl vector195
vector195:
  pushl $0
c0102e2e:	6a 00                	push   $0x0
  pushl $195
c0102e30:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102e35:	e9 d0 02 00 00       	jmp    c010310a <__alltraps>

c0102e3a <vector196>:
.globl vector196
vector196:
  pushl $0
c0102e3a:	6a 00                	push   $0x0
  pushl $196
c0102e3c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102e41:	e9 c4 02 00 00       	jmp    c010310a <__alltraps>

c0102e46 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102e46:	6a 00                	push   $0x0
  pushl $197
c0102e48:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102e4d:	e9 b8 02 00 00       	jmp    c010310a <__alltraps>

c0102e52 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102e52:	6a 00                	push   $0x0
  pushl $198
c0102e54:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102e59:	e9 ac 02 00 00       	jmp    c010310a <__alltraps>

c0102e5e <vector199>:
.globl vector199
vector199:
  pushl $0
c0102e5e:	6a 00                	push   $0x0
  pushl $199
c0102e60:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102e65:	e9 a0 02 00 00       	jmp    c010310a <__alltraps>

c0102e6a <vector200>:
.globl vector200
vector200:
  pushl $0
c0102e6a:	6a 00                	push   $0x0
  pushl $200
c0102e6c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102e71:	e9 94 02 00 00       	jmp    c010310a <__alltraps>

c0102e76 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102e76:	6a 00                	push   $0x0
  pushl $201
c0102e78:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102e7d:	e9 88 02 00 00       	jmp    c010310a <__alltraps>

c0102e82 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102e82:	6a 00                	push   $0x0
  pushl $202
c0102e84:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102e89:	e9 7c 02 00 00       	jmp    c010310a <__alltraps>

c0102e8e <vector203>:
.globl vector203
vector203:
  pushl $0
c0102e8e:	6a 00                	push   $0x0
  pushl $203
c0102e90:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102e95:	e9 70 02 00 00       	jmp    c010310a <__alltraps>

c0102e9a <vector204>:
.globl vector204
vector204:
  pushl $0
c0102e9a:	6a 00                	push   $0x0
  pushl $204
c0102e9c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102ea1:	e9 64 02 00 00       	jmp    c010310a <__alltraps>

c0102ea6 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102ea6:	6a 00                	push   $0x0
  pushl $205
c0102ea8:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102ead:	e9 58 02 00 00       	jmp    c010310a <__alltraps>

c0102eb2 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102eb2:	6a 00                	push   $0x0
  pushl $206
c0102eb4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102eb9:	e9 4c 02 00 00       	jmp    c010310a <__alltraps>

c0102ebe <vector207>:
.globl vector207
vector207:
  pushl $0
c0102ebe:	6a 00                	push   $0x0
  pushl $207
c0102ec0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102ec5:	e9 40 02 00 00       	jmp    c010310a <__alltraps>

c0102eca <vector208>:
.globl vector208
vector208:
  pushl $0
c0102eca:	6a 00                	push   $0x0
  pushl $208
c0102ecc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102ed1:	e9 34 02 00 00       	jmp    c010310a <__alltraps>

c0102ed6 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102ed6:	6a 00                	push   $0x0
  pushl $209
c0102ed8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102edd:	e9 28 02 00 00       	jmp    c010310a <__alltraps>

c0102ee2 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102ee2:	6a 00                	push   $0x0
  pushl $210
c0102ee4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102ee9:	e9 1c 02 00 00       	jmp    c010310a <__alltraps>

c0102eee <vector211>:
.globl vector211
vector211:
  pushl $0
c0102eee:	6a 00                	push   $0x0
  pushl $211
c0102ef0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102ef5:	e9 10 02 00 00       	jmp    c010310a <__alltraps>

c0102efa <vector212>:
.globl vector212
vector212:
  pushl $0
c0102efa:	6a 00                	push   $0x0
  pushl $212
c0102efc:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102f01:	e9 04 02 00 00       	jmp    c010310a <__alltraps>

c0102f06 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102f06:	6a 00                	push   $0x0
  pushl $213
c0102f08:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102f0d:	e9 f8 01 00 00       	jmp    c010310a <__alltraps>

c0102f12 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102f12:	6a 00                	push   $0x0
  pushl $214
c0102f14:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102f19:	e9 ec 01 00 00       	jmp    c010310a <__alltraps>

c0102f1e <vector215>:
.globl vector215
vector215:
  pushl $0
c0102f1e:	6a 00                	push   $0x0
  pushl $215
c0102f20:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102f25:	e9 e0 01 00 00       	jmp    c010310a <__alltraps>

c0102f2a <vector216>:
.globl vector216
vector216:
  pushl $0
c0102f2a:	6a 00                	push   $0x0
  pushl $216
c0102f2c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102f31:	e9 d4 01 00 00       	jmp    c010310a <__alltraps>

c0102f36 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102f36:	6a 00                	push   $0x0
  pushl $217
c0102f38:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102f3d:	e9 c8 01 00 00       	jmp    c010310a <__alltraps>

c0102f42 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102f42:	6a 00                	push   $0x0
  pushl $218
c0102f44:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102f49:	e9 bc 01 00 00       	jmp    c010310a <__alltraps>

c0102f4e <vector219>:
.globl vector219
vector219:
  pushl $0
c0102f4e:	6a 00                	push   $0x0
  pushl $219
c0102f50:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102f55:	e9 b0 01 00 00       	jmp    c010310a <__alltraps>

c0102f5a <vector220>:
.globl vector220
vector220:
  pushl $0
c0102f5a:	6a 00                	push   $0x0
  pushl $220
c0102f5c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102f61:	e9 a4 01 00 00       	jmp    c010310a <__alltraps>

c0102f66 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102f66:	6a 00                	push   $0x0
  pushl $221
c0102f68:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102f6d:	e9 98 01 00 00       	jmp    c010310a <__alltraps>

c0102f72 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102f72:	6a 00                	push   $0x0
  pushl $222
c0102f74:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102f79:	e9 8c 01 00 00       	jmp    c010310a <__alltraps>

c0102f7e <vector223>:
.globl vector223
vector223:
  pushl $0
c0102f7e:	6a 00                	push   $0x0
  pushl $223
c0102f80:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102f85:	e9 80 01 00 00       	jmp    c010310a <__alltraps>

c0102f8a <vector224>:
.globl vector224
vector224:
  pushl $0
c0102f8a:	6a 00                	push   $0x0
  pushl $224
c0102f8c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102f91:	e9 74 01 00 00       	jmp    c010310a <__alltraps>

c0102f96 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102f96:	6a 00                	push   $0x0
  pushl $225
c0102f98:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102f9d:	e9 68 01 00 00       	jmp    c010310a <__alltraps>

c0102fa2 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102fa2:	6a 00                	push   $0x0
  pushl $226
c0102fa4:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102fa9:	e9 5c 01 00 00       	jmp    c010310a <__alltraps>

c0102fae <vector227>:
.globl vector227
vector227:
  pushl $0
c0102fae:	6a 00                	push   $0x0
  pushl $227
c0102fb0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102fb5:	e9 50 01 00 00       	jmp    c010310a <__alltraps>

c0102fba <vector228>:
.globl vector228
vector228:
  pushl $0
c0102fba:	6a 00                	push   $0x0
  pushl $228
c0102fbc:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102fc1:	e9 44 01 00 00       	jmp    c010310a <__alltraps>

c0102fc6 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102fc6:	6a 00                	push   $0x0
  pushl $229
c0102fc8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102fcd:	e9 38 01 00 00       	jmp    c010310a <__alltraps>

c0102fd2 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102fd2:	6a 00                	push   $0x0
  pushl $230
c0102fd4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102fd9:	e9 2c 01 00 00       	jmp    c010310a <__alltraps>

c0102fde <vector231>:
.globl vector231
vector231:
  pushl $0
c0102fde:	6a 00                	push   $0x0
  pushl $231
c0102fe0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102fe5:	e9 20 01 00 00       	jmp    c010310a <__alltraps>

c0102fea <vector232>:
.globl vector232
vector232:
  pushl $0
c0102fea:	6a 00                	push   $0x0
  pushl $232
c0102fec:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102ff1:	e9 14 01 00 00       	jmp    c010310a <__alltraps>

c0102ff6 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102ff6:	6a 00                	push   $0x0
  pushl $233
c0102ff8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102ffd:	e9 08 01 00 00       	jmp    c010310a <__alltraps>

c0103002 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103002:	6a 00                	push   $0x0
  pushl $234
c0103004:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103009:	e9 fc 00 00 00       	jmp    c010310a <__alltraps>

c010300e <vector235>:
.globl vector235
vector235:
  pushl $0
c010300e:	6a 00                	push   $0x0
  pushl $235
c0103010:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103015:	e9 f0 00 00 00       	jmp    c010310a <__alltraps>

c010301a <vector236>:
.globl vector236
vector236:
  pushl $0
c010301a:	6a 00                	push   $0x0
  pushl $236
c010301c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103021:	e9 e4 00 00 00       	jmp    c010310a <__alltraps>

c0103026 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103026:	6a 00                	push   $0x0
  pushl $237
c0103028:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010302d:	e9 d8 00 00 00       	jmp    c010310a <__alltraps>

c0103032 <vector238>:
.globl vector238
vector238:
  pushl $0
c0103032:	6a 00                	push   $0x0
  pushl $238
c0103034:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103039:	e9 cc 00 00 00       	jmp    c010310a <__alltraps>

c010303e <vector239>:
.globl vector239
vector239:
  pushl $0
c010303e:	6a 00                	push   $0x0
  pushl $239
c0103040:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103045:	e9 c0 00 00 00       	jmp    c010310a <__alltraps>

c010304a <vector240>:
.globl vector240
vector240:
  pushl $0
c010304a:	6a 00                	push   $0x0
  pushl $240
c010304c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103051:	e9 b4 00 00 00       	jmp    c010310a <__alltraps>

c0103056 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103056:	6a 00                	push   $0x0
  pushl $241
c0103058:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010305d:	e9 a8 00 00 00       	jmp    c010310a <__alltraps>

c0103062 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103062:	6a 00                	push   $0x0
  pushl $242
c0103064:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103069:	e9 9c 00 00 00       	jmp    c010310a <__alltraps>

c010306e <vector243>:
.globl vector243
vector243:
  pushl $0
c010306e:	6a 00                	push   $0x0
  pushl $243
c0103070:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103075:	e9 90 00 00 00       	jmp    c010310a <__alltraps>

c010307a <vector244>:
.globl vector244
vector244:
  pushl $0
c010307a:	6a 00                	push   $0x0
  pushl $244
c010307c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103081:	e9 84 00 00 00       	jmp    c010310a <__alltraps>

c0103086 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103086:	6a 00                	push   $0x0
  pushl $245
c0103088:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010308d:	e9 78 00 00 00       	jmp    c010310a <__alltraps>

c0103092 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103092:	6a 00                	push   $0x0
  pushl $246
c0103094:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103099:	e9 6c 00 00 00       	jmp    c010310a <__alltraps>

c010309e <vector247>:
.globl vector247
vector247:
  pushl $0
c010309e:	6a 00                	push   $0x0
  pushl $247
c01030a0:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01030a5:	e9 60 00 00 00       	jmp    c010310a <__alltraps>

c01030aa <vector248>:
.globl vector248
vector248:
  pushl $0
c01030aa:	6a 00                	push   $0x0
  pushl $248
c01030ac:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01030b1:	e9 54 00 00 00       	jmp    c010310a <__alltraps>

c01030b6 <vector249>:
.globl vector249
vector249:
  pushl $0
c01030b6:	6a 00                	push   $0x0
  pushl $249
c01030b8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01030bd:	e9 48 00 00 00       	jmp    c010310a <__alltraps>

c01030c2 <vector250>:
.globl vector250
vector250:
  pushl $0
c01030c2:	6a 00                	push   $0x0
  pushl $250
c01030c4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01030c9:	e9 3c 00 00 00       	jmp    c010310a <__alltraps>

c01030ce <vector251>:
.globl vector251
vector251:
  pushl $0
c01030ce:	6a 00                	push   $0x0
  pushl $251
c01030d0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01030d5:	e9 30 00 00 00       	jmp    c010310a <__alltraps>

c01030da <vector252>:
.globl vector252
vector252:
  pushl $0
c01030da:	6a 00                	push   $0x0
  pushl $252
c01030dc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01030e1:	e9 24 00 00 00       	jmp    c010310a <__alltraps>

c01030e6 <vector253>:
.globl vector253
vector253:
  pushl $0
c01030e6:	6a 00                	push   $0x0
  pushl $253
c01030e8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01030ed:	e9 18 00 00 00       	jmp    c010310a <__alltraps>

c01030f2 <vector254>:
.globl vector254
vector254:
  pushl $0
c01030f2:	6a 00                	push   $0x0
  pushl $254
c01030f4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01030f9:	e9 0c 00 00 00       	jmp    c010310a <__alltraps>

c01030fe <vector255>:
.globl vector255
vector255:
  pushl $0
c01030fe:	6a 00                	push   $0x0
  pushl $255
c0103100:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103105:	e9 00 00 00 00       	jmp    c010310a <__alltraps>

c010310a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010310a:	1e                   	push   %ds
    pushl %es
c010310b:	06                   	push   %es
    pushl %fs
c010310c:	0f a0                	push   %fs
    pushl %gs
c010310e:	0f a8                	push   %gs
    pushal
c0103110:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0103111:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0103116:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0103118:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010311a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010311b:	e8 64 f5 ff ff       	call   c0102684 <trap>

    # pop the pushed stack pointer
    popl %esp
c0103120:	5c                   	pop    %esp

c0103121 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0103121:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0103122:	0f a9                	pop    %gs
    popl %fs
c0103124:	0f a1                	pop    %fs
    popl %es
c0103126:	07                   	pop    %es
    popl %ds
c0103127:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0103128:	83 c4 08             	add    $0x8,%esp
    iret
c010312b:	cf                   	iret   

c010312c <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c010312c:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0103130:	eb ef                	jmp    c0103121 <__trapret>

c0103132 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0103132:	55                   	push   %ebp
c0103133:	89 e5                	mov    %esp,%ebp
c0103135:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103138:	8b 45 08             	mov    0x8(%ebp),%eax
c010313b:	c1 e8 0c             	shr    $0xc,%eax
c010313e:	89 c2                	mov    %eax,%edx
c0103140:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0103145:	39 c2                	cmp    %eax,%edx
c0103147:	72 1c                	jb     c0103165 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103149:	c7 44 24 08 30 a6 10 	movl   $0xc010a630,0x8(%esp)
c0103150:	c0 
c0103151:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0103158:	00 
c0103159:	c7 04 24 4f a6 10 c0 	movl   $0xc010a64f,(%esp)
c0103160:	e8 9b d2 ff ff       	call   c0100400 <__panic>
    }
    return &pages[PPN(pa)];
c0103165:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c010316a:	8b 55 08             	mov    0x8(%ebp),%edx
c010316d:	c1 ea 0c             	shr    $0xc,%edx
c0103170:	c1 e2 05             	shl    $0x5,%edx
c0103173:	01 d0                	add    %edx,%eax
}
c0103175:	c9                   	leave  
c0103176:	c3                   	ret    

c0103177 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103177:	55                   	push   %ebp
c0103178:	89 e5                	mov    %esp,%ebp
c010317a:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010317d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103180:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103185:	89 04 24             	mov    %eax,(%esp)
c0103188:	e8 a5 ff ff ff       	call   c0103132 <pa2page>
}
c010318d:	c9                   	leave  
c010318e:	c3                   	ret    

c010318f <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c010318f:	55                   	push   %ebp
c0103190:	89 e5                	mov    %esp,%ebp
c0103192:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103195:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010319c:	e8 c7 1e 00 00       	call   c0105068 <kmalloc>
c01031a1:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01031a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031a8:	74 58                	je     c0103202 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01031b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01031b6:	89 50 04             	mov    %edx,0x4(%eax)
c01031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031bc:	8b 50 04             	mov    0x4(%eax),%edx
c01031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031c2:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c01031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c01031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c01031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031db:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c01031e2:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c01031e7:	85 c0                	test   %eax,%eax
c01031e9:	74 0d                	je     c01031f8 <mm_create+0x69>
c01031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ee:	89 04 24             	mov    %eax,(%esp)
c01031f1:	e8 77 0d 00 00       	call   c0103f6d <swap_init_mm>
c01031f6:	eb 0a                	jmp    c0103202 <mm_create+0x73>
        else mm->sm_priv = NULL;
c01031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031fb:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0103202:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103205:	c9                   	leave  
c0103206:	c3                   	ret    

c0103207 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0103207:	55                   	push   %ebp
c0103208:	89 e5                	mov    %esp,%ebp
c010320a:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010320d:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0103214:	e8 4f 1e 00 00       	call   c0105068 <kmalloc>
c0103219:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010321c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103220:	74 1b                	je     c010323d <vma_create+0x36>
        vma->vm_start = vm_start;
c0103222:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103225:	8b 55 08             	mov    0x8(%ebp),%edx
c0103228:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010322e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103231:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0103234:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103237:	8b 55 10             	mov    0x10(%ebp),%edx
c010323a:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103240:	c9                   	leave  
c0103241:	c3                   	ret    

c0103242 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0103242:	55                   	push   %ebp
c0103243:	89 e5                	mov    %esp,%ebp
c0103245:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0103248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010324f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103253:	0f 84 95 00 00 00    	je     c01032ee <find_vma+0xac>
        vma = mm->mmap_cache;
c0103259:	8b 45 08             	mov    0x8(%ebp),%eax
c010325c:	8b 40 08             	mov    0x8(%eax),%eax
c010325f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103262:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103266:	74 16                	je     c010327e <find_vma+0x3c>
c0103268:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010326b:	8b 40 04             	mov    0x4(%eax),%eax
c010326e:	39 45 0c             	cmp    %eax,0xc(%ebp)
c0103271:	72 0b                	jb     c010327e <find_vma+0x3c>
c0103273:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103276:	8b 40 08             	mov    0x8(%eax),%eax
c0103279:	39 45 0c             	cmp    %eax,0xc(%ebp)
c010327c:	72 61                	jb     c01032df <find_vma+0x9d>
                bool found = 0;
c010327e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103285:	8b 45 08             	mov    0x8(%ebp),%eax
c0103288:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010328b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103291:	eb 28                	jmp    c01032bb <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103293:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103296:	83 e8 10             	sub    $0x10,%eax
c0103299:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c010329c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010329f:	8b 40 04             	mov    0x4(%eax),%eax
c01032a2:	39 45 0c             	cmp    %eax,0xc(%ebp)
c01032a5:	72 14                	jb     c01032bb <find_vma+0x79>
c01032a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01032aa:	8b 40 08             	mov    0x8(%eax),%eax
c01032ad:	39 45 0c             	cmp    %eax,0xc(%ebp)
c01032b0:	73 09                	jae    c01032bb <find_vma+0x79>
                        found = 1;
c01032b2:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01032b9:	eb 17                	jmp    c01032d2 <find_vma+0x90>
c01032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01032c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032c4:	8b 40 04             	mov    0x4(%eax),%eax
                while ((le = list_next(le)) != list) {
c01032c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01032d0:	75 c1                	jne    c0103293 <find_vma+0x51>
                    }
                }
                if (!found) {
c01032d2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01032d6:	75 07                	jne    c01032df <find_vma+0x9d>
                    vma = NULL;
c01032d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c01032df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01032e3:	74 09                	je     c01032ee <find_vma+0xac>
            mm->mmap_cache = vma;
c01032e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01032e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01032eb:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c01032ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01032f1:	c9                   	leave  
c01032f2:	c3                   	ret    

c01032f3 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c01032f3:	55                   	push   %ebp
c01032f4:	89 e5                	mov    %esp,%ebp
c01032f6:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c01032f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01032fc:	8b 50 04             	mov    0x4(%eax),%edx
c01032ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103302:	8b 40 08             	mov    0x8(%eax),%eax
c0103305:	39 c2                	cmp    %eax,%edx
c0103307:	72 24                	jb     c010332d <check_vma_overlap+0x3a>
c0103309:	c7 44 24 0c 5d a6 10 	movl   $0xc010a65d,0xc(%esp)
c0103310:	c0 
c0103311:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103318:	c0 
c0103319:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0103320:	00 
c0103321:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103328:	e8 d3 d0 ff ff       	call   c0100400 <__panic>
    assert(prev->vm_end <= next->vm_start);
c010332d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103330:	8b 50 08             	mov    0x8(%eax),%edx
c0103333:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103336:	8b 40 04             	mov    0x4(%eax),%eax
c0103339:	39 c2                	cmp    %eax,%edx
c010333b:	76 24                	jbe    c0103361 <check_vma_overlap+0x6e>
c010333d:	c7 44 24 0c a0 a6 10 	movl   $0xc010a6a0,0xc(%esp)
c0103344:	c0 
c0103345:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c010334c:	c0 
c010334d:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0103354:	00 
c0103355:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c010335c:	e8 9f d0 ff ff       	call   c0100400 <__panic>
    assert(next->vm_start < next->vm_end);
c0103361:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103364:	8b 50 04             	mov    0x4(%eax),%edx
c0103367:	8b 45 0c             	mov    0xc(%ebp),%eax
c010336a:	8b 40 08             	mov    0x8(%eax),%eax
c010336d:	39 c2                	cmp    %eax,%edx
c010336f:	72 24                	jb     c0103395 <check_vma_overlap+0xa2>
c0103371:	c7 44 24 0c bf a6 10 	movl   $0xc010a6bf,0xc(%esp)
c0103378:	c0 
c0103379:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103380:	c0 
c0103381:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0103388:	00 
c0103389:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103390:	e8 6b d0 ff ff       	call   c0100400 <__panic>
}
c0103395:	90                   	nop
c0103396:	c9                   	leave  
c0103397:	c3                   	ret    

c0103398 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103398:	55                   	push   %ebp
c0103399:	89 e5                	mov    %esp,%ebp
c010339b:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c010339e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a1:	8b 50 04             	mov    0x4(%eax),%edx
c01033a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a7:	8b 40 08             	mov    0x8(%eax),%eax
c01033aa:	39 c2                	cmp    %eax,%edx
c01033ac:	72 24                	jb     c01033d2 <insert_vma_struct+0x3a>
c01033ae:	c7 44 24 0c dd a6 10 	movl   $0xc010a6dd,0xc(%esp)
c01033b5:	c0 
c01033b6:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01033bd:	c0 
c01033be:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01033c5:	00 
c01033c6:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c01033cd:	e8 2e d0 ff ff       	call   c0100400 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c01033d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c01033d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033db:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c01033de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c01033e4:	eb 1f                	jmp    c0103405 <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c01033e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e9:	83 e8 10             	sub    $0x10,%eax
c01033ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c01033ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033f2:	8b 50 04             	mov    0x4(%eax),%edx
c01033f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033f8:	8b 40 04             	mov    0x4(%eax),%eax
c01033fb:	39 c2                	cmp    %eax,%edx
c01033fd:	77 1f                	ja     c010341e <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c01033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103402:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103405:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103408:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010340b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010340e:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0103411:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103414:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103417:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010341a:	75 ca                	jne    c01033e6 <insert_vma_struct+0x4e>
c010341c:	eb 01                	jmp    c010341f <insert_vma_struct+0x87>
                break;
c010341e:	90                   	nop
c010341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103422:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103425:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103428:	8b 40 04             	mov    0x4(%eax),%eax
        }

    le_next = list_next(le_prev);
c010342b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c010342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103431:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103434:	74 15                	je     c010344b <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103436:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103439:	8d 50 f0             	lea    -0x10(%eax),%edx
c010343c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010343f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103443:	89 14 24             	mov    %edx,(%esp)
c0103446:	e8 a8 fe ff ff       	call   c01032f3 <check_vma_overlap>
    }
    if (le_next != list) {
c010344b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010344e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103451:	74 15                	je     c0103468 <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103456:	83 e8 10             	sub    $0x10,%eax
c0103459:	89 44 24 04          	mov    %eax,0x4(%esp)
c010345d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103460:	89 04 24             	mov    %eax,(%esp)
c0103463:	e8 8b fe ff ff       	call   c01032f3 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0103468:	8b 45 0c             	mov    0xc(%ebp),%eax
c010346b:	8b 55 08             	mov    0x8(%ebp),%edx
c010346e:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103470:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103473:	8d 50 10             	lea    0x10(%eax),%edx
c0103476:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103479:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010347c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c010347f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103482:	8b 40 04             	mov    0x4(%eax),%eax
c0103485:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103488:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010348b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010348e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103491:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103494:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103497:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010349a:	89 10                	mov    %edx,(%eax)
c010349c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010349f:	8b 10                	mov    (%eax),%edx
c01034a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034a4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01034a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034aa:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01034ad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01034b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034b3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01034b6:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c01034b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01034bb:	8b 40 10             	mov    0x10(%eax),%eax
c01034be:	8d 50 01             	lea    0x1(%eax),%edx
c01034c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01034c4:	89 50 10             	mov    %edx,0x10(%eax)
}
c01034c7:	90                   	nop
c01034c8:	c9                   	leave  
c01034c9:	c3                   	ret    

c01034ca <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c01034ca:	55                   	push   %ebp
c01034cb:	89 e5                	mov    %esp,%ebp
c01034cd:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c01034d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01034d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c01034d6:	eb 36                	jmp    c010350e <mm_destroy+0x44>
c01034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034db:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c01034de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034e1:	8b 40 04             	mov    0x4(%eax),%eax
c01034e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01034e7:	8b 12                	mov    (%edx),%edx
c01034e9:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01034ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01034ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01034f5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01034f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01034fe:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0103500:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103503:	83 e8 10             	sub    $0x10,%eax
c0103506:	89 04 24             	mov    %eax,(%esp)
c0103509:	e8 75 1b 00 00       	call   c0105083 <kfree>
c010350e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103511:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0103514:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103517:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list) {
c010351a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010351d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103523:	75 b3                	jne    c01034d8 <mm_destroy+0xe>
    }
    kfree(mm); //kfree mm
c0103525:	8b 45 08             	mov    0x8(%ebp),%eax
c0103528:	89 04 24             	mov    %eax,(%esp)
c010352b:	e8 53 1b 00 00       	call   c0105083 <kfree>
    mm=NULL;
c0103530:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103537:	90                   	nop
c0103538:	c9                   	leave  
c0103539:	c3                   	ret    

c010353a <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010353a:	55                   	push   %ebp
c010353b:	89 e5                	mov    %esp,%ebp
c010353d:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103540:	e8 03 00 00 00       	call   c0103548 <check_vmm>
}
c0103545:	90                   	nop
c0103546:	c9                   	leave  
c0103547:	c3                   	ret    

c0103548 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103548:	55                   	push   %ebp
c0103549:	89 e5                	mov    %esp,%ebp
c010354b:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010354e:	e8 47 37 00 00       	call   c0106c9a <nr_free_pages>
c0103553:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103556:	e8 14 00 00 00       	call   c010356f <check_vma_struct>
    check_pgfault();
c010355b:	e8 a1 04 00 00       	call   c0103a01 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0103560:	c7 04 24 f9 a6 10 c0 	movl   $0xc010a6f9,(%esp)
c0103567:	e8 3d cd ff ff       	call   c01002a9 <cprintf>
}
c010356c:	90                   	nop
c010356d:	c9                   	leave  
c010356e:	c3                   	ret    

c010356f <check_vma_struct>:

static void
check_vma_struct(void) {
c010356f:	55                   	push   %ebp
c0103570:	89 e5                	mov    %esp,%ebp
c0103572:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103575:	e8 20 37 00 00       	call   c0106c9a <nr_free_pages>
c010357a:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010357d:	e8 0d fc ff ff       	call   c010318f <mm_create>
c0103582:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103585:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103589:	75 24                	jne    c01035af <check_vma_struct+0x40>
c010358b:	c7 44 24 0c 11 a7 10 	movl   $0xc010a711,0xc(%esp)
c0103592:	c0 
c0103593:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c010359a:	c0 
c010359b:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01035a2:	00 
c01035a3:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c01035aa:	e8 51 ce ff ff       	call   c0100400 <__panic>

    int step1 = 10, step2 = step1 * 10;
c01035af:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01035b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01035b9:	89 d0                	mov    %edx,%eax
c01035bb:	c1 e0 02             	shl    $0x2,%eax
c01035be:	01 d0                	add    %edx,%eax
c01035c0:	01 c0                	add    %eax,%eax
c01035c2:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01035c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035cb:	eb 6f                	jmp    c010363c <check_vma_struct+0xcd>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01035cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01035d0:	89 d0                	mov    %edx,%eax
c01035d2:	c1 e0 02             	shl    $0x2,%eax
c01035d5:	01 d0                	add    %edx,%eax
c01035d7:	83 c0 02             	add    $0x2,%eax
c01035da:	89 c1                	mov    %eax,%ecx
c01035dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01035df:	89 d0                	mov    %edx,%eax
c01035e1:	c1 e0 02             	shl    $0x2,%eax
c01035e4:	01 d0                	add    %edx,%eax
c01035e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01035ed:	00 
c01035ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01035f2:	89 04 24             	mov    %eax,(%esp)
c01035f5:	e8 0d fc ff ff       	call   c0103207 <vma_create>
c01035fa:	89 45 bc             	mov    %eax,-0x44(%ebp)
        assert(vma != NULL);
c01035fd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103601:	75 24                	jne    c0103627 <check_vma_struct+0xb8>
c0103603:	c7 44 24 0c 1c a7 10 	movl   $0xc010a71c,0xc(%esp)
c010360a:	c0 
c010360b:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103612:	c0 
c0103613:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c010361a:	00 
c010361b:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103622:	e8 d9 cd ff ff       	call   c0100400 <__panic>
        insert_vma_struct(mm, vma);
c0103627:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010362a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010362e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103631:	89 04 24             	mov    %eax,(%esp)
c0103634:	e8 5f fd ff ff       	call   c0103398 <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
c0103639:	ff 4d f4             	decl   -0xc(%ebp)
c010363c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103640:	7f 8b                	jg     c01035cd <check_vma_struct+0x5e>
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103645:	40                   	inc    %eax
c0103646:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103649:	eb 6f                	jmp    c01036ba <check_vma_struct+0x14b>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010364b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010364e:	89 d0                	mov    %edx,%eax
c0103650:	c1 e0 02             	shl    $0x2,%eax
c0103653:	01 d0                	add    %edx,%eax
c0103655:	83 c0 02             	add    $0x2,%eax
c0103658:	89 c1                	mov    %eax,%ecx
c010365a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010365d:	89 d0                	mov    %edx,%eax
c010365f:	c1 e0 02             	shl    $0x2,%eax
c0103662:	01 d0                	add    %edx,%eax
c0103664:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010366b:	00 
c010366c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103670:	89 04 24             	mov    %eax,(%esp)
c0103673:	e8 8f fb ff ff       	call   c0103207 <vma_create>
c0103678:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma != NULL);
c010367b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010367f:	75 24                	jne    c01036a5 <check_vma_struct+0x136>
c0103681:	c7 44 24 0c 1c a7 10 	movl   $0xc010a71c,0xc(%esp)
c0103688:	c0 
c0103689:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103690:	c0 
c0103691:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103698:	00 
c0103699:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c01036a0:	e8 5b cd ff ff       	call   c0100400 <__panic>
        insert_vma_struct(mm, vma);
c01036a5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01036a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036af:	89 04 24             	mov    %eax,(%esp)
c01036b2:	e8 e1 fc ff ff       	call   c0103398 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
c01036b7:	ff 45 f4             	incl   -0xc(%ebp)
c01036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036bd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01036c0:	7e 89                	jle    c010364b <check_vma_struct+0xdc>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01036c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036c5:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01036c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036cb:	8b 40 04             	mov    0x4(%eax),%eax
c01036ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01036d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01036d8:	e9 96 00 00 00       	jmp    c0103773 <check_vma_struct+0x204>
        assert(le != &(mm->mmap_list));
c01036dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036e0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01036e3:	75 24                	jne    c0103709 <check_vma_struct+0x19a>
c01036e5:	c7 44 24 0c 28 a7 10 	movl   $0xc010a728,0xc(%esp)
c01036ec:	c0 
c01036ed:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01036f4:	c0 
c01036f5:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01036fc:	00 
c01036fd:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103704:	e8 f7 cc ff ff       	call   c0100400 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103709:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010370c:	83 e8 10             	sub    $0x10,%eax
c010370f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103712:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103715:	8b 48 04             	mov    0x4(%eax),%ecx
c0103718:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010371b:	89 d0                	mov    %edx,%eax
c010371d:	c1 e0 02             	shl    $0x2,%eax
c0103720:	01 d0                	add    %edx,%eax
c0103722:	39 c1                	cmp    %eax,%ecx
c0103724:	75 17                	jne    c010373d <check_vma_struct+0x1ce>
c0103726:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103729:	8b 48 08             	mov    0x8(%eax),%ecx
c010372c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010372f:	89 d0                	mov    %edx,%eax
c0103731:	c1 e0 02             	shl    $0x2,%eax
c0103734:	01 d0                	add    %edx,%eax
c0103736:	83 c0 02             	add    $0x2,%eax
c0103739:	39 c1                	cmp    %eax,%ecx
c010373b:	74 24                	je     c0103761 <check_vma_struct+0x1f2>
c010373d:	c7 44 24 0c 40 a7 10 	movl   $0xc010a740,0xc(%esp)
c0103744:	c0 
c0103745:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c010374c:	c0 
c010374d:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103754:	00 
c0103755:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c010375c:	e8 9f cc ff ff       	call   c0100400 <__panic>
c0103761:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103764:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103767:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010376a:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010376d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i ++) {
c0103770:	ff 45 f4             	incl   -0xc(%ebp)
c0103773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103776:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103779:	0f 8e 5e ff ff ff    	jle    c01036dd <check_vma_struct+0x16e>
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010377f:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0103786:	e9 cb 01 00 00       	jmp    c0103956 <check_vma_struct+0x3e7>
        struct vma_struct *vma1 = find_vma(mm, i);
c010378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010378e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103792:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103795:	89 04 24             	mov    %eax,(%esp)
c0103798:	e8 a5 fa ff ff       	call   c0103242 <find_vma>
c010379d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma1 != NULL);
c01037a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01037a4:	75 24                	jne    c01037ca <check_vma_struct+0x25b>
c01037a6:	c7 44 24 0c 75 a7 10 	movl   $0xc010a775,0xc(%esp)
c01037ad:	c0 
c01037ae:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01037b5:	c0 
c01037b6:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01037bd:	00 
c01037be:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c01037c5:	e8 36 cc ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01037ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037cd:	40                   	inc    %eax
c01037ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01037d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037d5:	89 04 24             	mov    %eax,(%esp)
c01037d8:	e8 65 fa ff ff       	call   c0103242 <find_vma>
c01037dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(vma2 != NULL);
c01037e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01037e4:	75 24                	jne    c010380a <check_vma_struct+0x29b>
c01037e6:	c7 44 24 0c 82 a7 10 	movl   $0xc010a782,0xc(%esp)
c01037ed:	c0 
c01037ee:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01037f5:	c0 
c01037f6:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01037fd:	00 
c01037fe:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103805:	e8 f6 cb ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c010380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010380d:	83 c0 02             	add    $0x2,%eax
c0103810:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103814:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103817:	89 04 24             	mov    %eax,(%esp)
c010381a:	e8 23 fa ff ff       	call   c0103242 <find_vma>
c010381f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma3 == NULL);
c0103822:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103826:	74 24                	je     c010384c <check_vma_struct+0x2dd>
c0103828:	c7 44 24 0c 8f a7 10 	movl   $0xc010a78f,0xc(%esp)
c010382f:	c0 
c0103830:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103837:	c0 
c0103838:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c010383f:	00 
c0103840:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103847:	e8 b4 cb ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c010384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010384f:	83 c0 03             	add    $0x3,%eax
c0103852:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103856:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103859:	89 04 24             	mov    %eax,(%esp)
c010385c:	e8 e1 f9 ff ff       	call   c0103242 <find_vma>
c0103861:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma4 == NULL);
c0103864:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103868:	74 24                	je     c010388e <check_vma_struct+0x31f>
c010386a:	c7 44 24 0c 9c a7 10 	movl   $0xc010a79c,0xc(%esp)
c0103871:	c0 
c0103872:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103879:	c0 
c010387a:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103881:	00 
c0103882:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103889:	e8 72 cb ff ff       	call   c0100400 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c010388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103891:	83 c0 04             	add    $0x4,%eax
c0103894:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103898:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010389b:	89 04 24             	mov    %eax,(%esp)
c010389e:	e8 9f f9 ff ff       	call   c0103242 <find_vma>
c01038a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma5 == NULL);
c01038a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01038aa:	74 24                	je     c01038d0 <check_vma_struct+0x361>
c01038ac:	c7 44 24 0c a9 a7 10 	movl   $0xc010a7a9,0xc(%esp)
c01038b3:	c0 
c01038b4:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01038bb:	c0 
c01038bc:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01038c3:	00 
c01038c4:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c01038cb:	e8 30 cb ff ff       	call   c0100400 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01038d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038d3:	8b 50 04             	mov    0x4(%eax),%edx
c01038d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038d9:	39 c2                	cmp    %eax,%edx
c01038db:	75 10                	jne    c01038ed <check_vma_struct+0x37e>
c01038dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038e0:	8b 40 08             	mov    0x8(%eax),%eax
c01038e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01038e6:	83 c2 02             	add    $0x2,%edx
c01038e9:	39 d0                	cmp    %edx,%eax
c01038eb:	74 24                	je     c0103911 <check_vma_struct+0x3a2>
c01038ed:	c7 44 24 0c b8 a7 10 	movl   $0xc010a7b8,0xc(%esp)
c01038f4:	c0 
c01038f5:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01038fc:	c0 
c01038fd:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0103904:	00 
c0103905:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c010390c:	e8 ef ca ff ff       	call   c0100400 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0103911:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103914:	8b 50 04             	mov    0x4(%eax),%edx
c0103917:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010391a:	39 c2                	cmp    %eax,%edx
c010391c:	75 10                	jne    c010392e <check_vma_struct+0x3bf>
c010391e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103921:	8b 40 08             	mov    0x8(%eax),%eax
c0103924:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103927:	83 c2 02             	add    $0x2,%edx
c010392a:	39 d0                	cmp    %edx,%eax
c010392c:	74 24                	je     c0103952 <check_vma_struct+0x3e3>
c010392e:	c7 44 24 0c e8 a7 10 	movl   $0xc010a7e8,0xc(%esp)
c0103935:	c0 
c0103936:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c010393d:	c0 
c010393e:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0103945:	00 
c0103946:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c010394d:	e8 ae ca ff ff       	call   c0100400 <__panic>
    for (i = 5; i <= 5 * step2; i +=5) {
c0103952:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0103956:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103959:	89 d0                	mov    %edx,%eax
c010395b:	c1 e0 02             	shl    $0x2,%eax
c010395e:	01 d0                	add    %edx,%eax
c0103960:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103963:	0f 8e 22 fe ff ff    	jle    c010378b <check_vma_struct+0x21c>
    }

    for (i =4; i>=0; i--) {
c0103969:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0103970:	eb 6f                	jmp    c01039e1 <check_vma_struct+0x472>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0103972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103975:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103979:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010397c:	89 04 24             	mov    %eax,(%esp)
c010397f:	e8 be f8 ff ff       	call   c0103242 <find_vma>
c0103984:	89 45 dc             	mov    %eax,-0x24(%ebp)
        if (vma_below_5 != NULL ) {
c0103987:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010398b:	74 27                	je     c01039b4 <check_vma_struct+0x445>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010398d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103990:	8b 50 08             	mov    0x8(%eax),%edx
c0103993:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103996:	8b 40 04             	mov    0x4(%eax),%eax
c0103999:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010399d:	89 44 24 08          	mov    %eax,0x8(%esp)
c01039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01039a8:	c7 04 24 18 a8 10 c0 	movl   $0xc010a818,(%esp)
c01039af:	e8 f5 c8 ff ff       	call   c01002a9 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01039b4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01039b8:	74 24                	je     c01039de <check_vma_struct+0x46f>
c01039ba:	c7 44 24 0c 3d a8 10 	movl   $0xc010a83d,0xc(%esp)
c01039c1:	c0 
c01039c2:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c01039c9:	c0 
c01039ca:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01039d1:	00 
c01039d2:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c01039d9:	e8 22 ca ff ff       	call   c0100400 <__panic>
    for (i =4; i>=0; i--) {
c01039de:	ff 4d f4             	decl   -0xc(%ebp)
c01039e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039e5:	79 8b                	jns    c0103972 <check_vma_struct+0x403>
    }

    mm_destroy(mm);
c01039e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039ea:	89 04 24             	mov    %eax,(%esp)
c01039ed:	e8 d8 fa ff ff       	call   c01034ca <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c01039f2:	c7 04 24 54 a8 10 c0 	movl   $0xc010a854,(%esp)
c01039f9:	e8 ab c8 ff ff       	call   c01002a9 <cprintf>
}
c01039fe:	90                   	nop
c01039ff:	c9                   	leave  
c0103a00:	c3                   	ret    

c0103a01 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0103a01:	55                   	push   %ebp
c0103a02:	89 e5                	mov    %esp,%ebp
c0103a04:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103a07:	e8 8e 32 00 00       	call   c0106c9a <nr_free_pages>
c0103a0c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0103a0f:	e8 7b f7 ff ff       	call   c010318f <mm_create>
c0103a14:	a3 58 b0 12 c0       	mov    %eax,0xc012b058
    assert(check_mm_struct != NULL);
c0103a19:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0103a1e:	85 c0                	test   %eax,%eax
c0103a20:	75 24                	jne    c0103a46 <check_pgfault+0x45>
c0103a22:	c7 44 24 0c 73 a8 10 	movl   $0xc010a873,0xc(%esp)
c0103a29:	c0 
c0103a2a:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103a31:	c0 
c0103a32:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103a39:	00 
c0103a3a:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103a41:	e8 ba c9 ff ff       	call   c0100400 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0103a46:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0103a4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0103a4e:	8b 15 20 5a 12 c0    	mov    0xc0125a20,%edx
c0103a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a57:	89 50 0c             	mov    %edx,0xc(%eax)
c0103a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a5d:	8b 40 0c             	mov    0xc(%eax),%eax
c0103a60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0103a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a66:	8b 00                	mov    (%eax),%eax
c0103a68:	85 c0                	test   %eax,%eax
c0103a6a:	74 24                	je     c0103a90 <check_pgfault+0x8f>
c0103a6c:	c7 44 24 0c 8b a8 10 	movl   $0xc010a88b,0xc(%esp)
c0103a73:	c0 
c0103a74:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103a7b:	c0 
c0103a7c:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103a83:	00 
c0103a84:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103a8b:	e8 70 c9 ff ff       	call   c0100400 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0103a90:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0103a97:	00 
c0103a98:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0103a9f:	00 
c0103aa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0103aa7:	e8 5b f7 ff ff       	call   c0103207 <vma_create>
c0103aac:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0103aaf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103ab3:	75 24                	jne    c0103ad9 <check_pgfault+0xd8>
c0103ab5:	c7 44 24 0c 1c a7 10 	movl   $0xc010a71c,0xc(%esp)
c0103abc:	c0 
c0103abd:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103ac4:	c0 
c0103ac5:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103acc:	00 
c0103acd:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103ad4:	e8 27 c9 ff ff       	call   c0100400 <__panic>

    insert_vma_struct(mm, vma);
c0103ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103adc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ae3:	89 04 24             	mov    %eax,(%esp)
c0103ae6:	e8 ad f8 ff ff       	call   c0103398 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0103aeb:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0103af2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103af5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103afc:	89 04 24             	mov    %eax,(%esp)
c0103aff:	e8 3e f7 ff ff       	call   c0103242 <find_vma>
c0103b04:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103b07:	74 24                	je     c0103b2d <check_pgfault+0x12c>
c0103b09:	c7 44 24 0c 99 a8 10 	movl   $0xc010a899,0xc(%esp)
c0103b10:	c0 
c0103b11:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103b18:	c0 
c0103b19:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103b20:	00 
c0103b21:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103b28:	e8 d3 c8 ff ff       	call   c0100400 <__panic>

    int i, sum = 0;
c0103b2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b3b:	eb 16                	jmp    c0103b53 <check_pgfault+0x152>
        *(char *)(addr + i) = i;
c0103b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b43:	01 d0                	add    %edx,%eax
c0103b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b48:	88 10                	mov    %dl,(%eax)
        sum += i;
c0103b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b4d:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103b50:	ff 45 f4             	incl   -0xc(%ebp)
c0103b53:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103b57:	7e e4                	jle    c0103b3d <check_pgfault+0x13c>
    }
    for (i = 0; i < 100; i ++) {
c0103b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b60:	eb 14                	jmp    c0103b76 <check_pgfault+0x175>
        sum -= *(char *)(addr + i);
c0103b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b65:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b68:	01 d0                	add    %edx,%eax
c0103b6a:	0f b6 00             	movzbl (%eax),%eax
c0103b6d:	0f be c0             	movsbl %al,%eax
c0103b70:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0103b73:	ff 45 f4             	incl   -0xc(%ebp)
c0103b76:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0103b7a:	7e e6                	jle    c0103b62 <check_pgfault+0x161>
    }
    assert(sum == 0);
c0103b7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b80:	74 24                	je     c0103ba6 <check_pgfault+0x1a5>
c0103b82:	c7 44 24 0c b3 a8 10 	movl   $0xc010a8b3,0xc(%esp)
c0103b89:	c0 
c0103b8a:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103b91:	c0 
c0103b92:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0103b99:	00 
c0103b9a:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103ba1:	e8 5a c8 ff ff       	call   c0100400 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0103ba6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ba9:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103bac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103baf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103bb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bbb:	89 04 24             	mov    %eax,(%esp)
c0103bbe:	e8 0d 39 00 00       	call   c01074d0 <page_remove>
    free_page(pde2page(pgdir[0]));
c0103bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bc6:	8b 00                	mov    (%eax),%eax
c0103bc8:	89 04 24             	mov    %eax,(%esp)
c0103bcb:	e8 a7 f5 ff ff       	call   c0103177 <pde2page>
c0103bd0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103bd7:	00 
c0103bd8:	89 04 24             	mov    %eax,(%esp)
c0103bdb:	e8 87 30 00 00       	call   c0106c67 <free_pages>
    pgdir[0] = 0;
c0103be0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103be3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0103be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103bec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0103bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103bf6:	89 04 24             	mov    %eax,(%esp)
c0103bf9:	e8 cc f8 ff ff       	call   c01034ca <mm_destroy>
    check_mm_struct = NULL;
c0103bfe:	c7 05 58 b0 12 c0 00 	movl   $0x0,0xc012b058
c0103c05:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0103c08:	e8 8d 30 00 00       	call   c0106c9a <nr_free_pages>
c0103c0d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103c10:	74 24                	je     c0103c36 <check_pgfault+0x235>
c0103c12:	c7 44 24 0c bc a8 10 	movl   $0xc010a8bc,0xc(%esp)
c0103c19:	c0 
c0103c1a:	c7 44 24 08 7b a6 10 	movl   $0xc010a67b,0x8(%esp)
c0103c21:	c0 
c0103c22:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0103c29:	00 
c0103c2a:	c7 04 24 90 a6 10 c0 	movl   $0xc010a690,(%esp)
c0103c31:	e8 ca c7 ff ff       	call   c0100400 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0103c36:	c7 04 24 e3 a8 10 c0 	movl   $0xc010a8e3,(%esp)
c0103c3d:	e8 67 c6 ff ff       	call   c01002a9 <cprintf>
}
c0103c42:	90                   	nop
c0103c43:	c9                   	leave  
c0103c44:	c3                   	ret    

c0103c45 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0103c45:	55                   	push   %ebp
c0103c46:	89 e5                	mov    %esp,%ebp
c0103c48:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0103c4b:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0103c52:	8b 45 10             	mov    0x10(%ebp),%eax
c0103c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c5c:	89 04 24             	mov    %eax,(%esp)
c0103c5f:	e8 de f5 ff ff       	call   c0103242 <find_vma>
c0103c64:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0103c67:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0103c6c:	40                   	inc    %eax
c0103c6d:	a3 64 8f 12 c0       	mov    %eax,0xc0128f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0103c72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103c76:	74 0b                	je     c0103c83 <do_pgfault+0x3e>
c0103c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c7b:	8b 40 04             	mov    0x4(%eax),%eax
c0103c7e:	39 45 10             	cmp    %eax,0x10(%ebp)
c0103c81:	73 18                	jae    c0103c9b <do_pgfault+0x56>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0103c83:	8b 45 10             	mov    0x10(%ebp),%eax
c0103c86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c8a:	c7 04 24 00 a9 10 c0 	movl   $0xc010a900,(%esp)
c0103c91:	e8 13 c6 ff ff       	call   c01002a9 <cprintf>
        goto failed;
c0103c96:	e9 ba 01 00 00       	jmp    c0103e55 <do_pgfault+0x210>
    }
    //check the error_code
    switch (error_code & 3) {
c0103c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c9e:	83 e0 03             	and    $0x3,%eax
c0103ca1:	85 c0                	test   %eax,%eax
c0103ca3:	74 34                	je     c0103cd9 <do_pgfault+0x94>
c0103ca5:	83 f8 01             	cmp    $0x1,%eax
c0103ca8:	74 1e                	je     c0103cc8 <do_pgfault+0x83>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0103caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cad:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cb0:	83 e0 02             	and    $0x2,%eax
c0103cb3:	85 c0                	test   %eax,%eax
c0103cb5:	75 40                	jne    c0103cf7 <do_pgfault+0xb2>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0103cb7:	c7 04 24 30 a9 10 c0 	movl   $0xc010a930,(%esp)
c0103cbe:	e8 e6 c5 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103cc3:	e9 8d 01 00 00       	jmp    c0103e55 <do_pgfault+0x210>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0103cc8:	c7 04 24 90 a9 10 c0 	movl   $0xc010a990,(%esp)
c0103ccf:	e8 d5 c5 ff ff       	call   c01002a9 <cprintf>
        goto failed;
c0103cd4:	e9 7c 01 00 00       	jmp    c0103e55 <do_pgfault+0x210>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0103cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cdc:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cdf:	83 e0 05             	and    $0x5,%eax
c0103ce2:	85 c0                	test   %eax,%eax
c0103ce4:	75 12                	jne    c0103cf8 <do_pgfault+0xb3>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0103ce6:	c7 04 24 c8 a9 10 c0 	movl   $0xc010a9c8,(%esp)
c0103ced:	e8 b7 c5 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103cf2:	e9 5e 01 00 00       	jmp    c0103e55 <do_pgfault+0x210>
        break;
c0103cf7:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0103cf8:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0103cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d02:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d05:	83 e0 02             	and    $0x2,%eax
c0103d08:	85 c0                	test   %eax,%eax
c0103d0a:	74 04                	je     c0103d10 <do_pgfault+0xcb>
        perm |= PTE_W;
c0103d0c:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0103d10:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d13:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d1e:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0103d21:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0103d28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        }
   }
#endif
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
c0103d2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d32:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d35:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103d3c:	00 
c0103d3d:	8b 55 10             	mov    0x10(%ebp),%edx
c0103d40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d44:	89 04 24             	mov    %eax,(%esp)
c0103d47:	e8 90 35 00 00       	call   c01072dc <get_pte>
c0103d4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103d53:	75 11                	jne    c0103d66 <do_pgfault+0x121>
        cprintf("get_pte in do_pgfault failed\n");
c0103d55:	c7 04 24 2b aa 10 c0 	movl   $0xc010aa2b,(%esp)
c0103d5c:	e8 48 c5 ff ff       	call   c01002a9 <cprintf>
        goto failed;
c0103d61:	e9 ef 00 00 00       	jmp    c0103e55 <do_pgfault+0x210>
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
c0103d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d69:	8b 00                	mov    (%eax),%eax
c0103d6b:	85 c0                	test   %eax,%eax
c0103d6d:	75 35                	jne    c0103da4 <do_pgfault+0x15f>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0103d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d72:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103d78:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103d7c:	8b 55 10             	mov    0x10(%ebp),%edx
c0103d7f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d83:	89 04 24             	mov    %eax,(%esp)
c0103d86:	e8 9f 38 00 00       	call   c010762a <pgdir_alloc_page>
c0103d8b:	85 c0                	test   %eax,%eax
c0103d8d:	0f 85 bb 00 00 00    	jne    c0103e4e <do_pgfault+0x209>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0103d93:	c7 04 24 4c aa 10 c0 	movl   $0xc010aa4c,(%esp)
c0103d9a:	e8 0a c5 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103d9f:	e9 b1 00 00 00       	jmp    c0103e55 <do_pgfault+0x210>
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
c0103da4:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c0103da9:	85 c0                	test   %eax,%eax
c0103dab:	0f 84 86 00 00 00    	je     c0103e37 <do_pgfault+0x1f2>
            struct Page *page=NULL;
c0103db1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
c0103db8:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0103dbb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103dbf:	8b 45 10             	mov    0x10(%ebp),%eax
c0103dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103dc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc9:	89 04 24             	mov    %eax,(%esp)
c0103dcc:	e8 8e 03 00 00       	call   c010415f <swap_in>
c0103dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103dd8:	74 0e                	je     c0103de8 <do_pgfault+0x1a3>
                cprintf("swap_in in do_pgfault failed\n");
c0103dda:	c7 04 24 73 aa 10 c0 	movl   $0xc010aa73,(%esp)
c0103de1:	e8 c3 c4 ff ff       	call   c01002a9 <cprintf>
c0103de6:	eb 6d                	jmp    c0103e55 <do_pgfault+0x210>
                goto failed;
            }    
            page_insert(mm->pgdir, page, addr, perm);
c0103de8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dee:	8b 40 0c             	mov    0xc(%eax),%eax
c0103df1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0103df4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0103df8:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0103dfb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103dff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e03:	89 04 24             	mov    %eax,(%esp)
c0103e06:	e8 0a 37 00 00       	call   c0107515 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0103e0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e0e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0103e15:	00 
c0103e16:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103e1a:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e21:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e24:	89 04 24             	mov    %eax,(%esp)
c0103e27:	e8 71 01 00 00       	call   c0103f9d <swap_map_swappable>
            page->pra_vaddr = addr;
c0103e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e2f:	8b 55 10             	mov    0x10(%ebp),%edx
c0103e32:	89 50 1c             	mov    %edx,0x1c(%eax)
c0103e35:	eb 17                	jmp    c0103e4e <do_pgfault+0x209>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0103e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e3a:	8b 00                	mov    (%eax),%eax
c0103e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e40:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0103e47:	e8 5d c4 ff ff       	call   c01002a9 <cprintf>
            goto failed;
c0103e4c:	eb 07                	jmp    c0103e55 <do_pgfault+0x210>
        }
   }
   ret = 0;
c0103e4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0103e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103e58:	c9                   	leave  
c0103e59:	c3                   	ret    

c0103e5a <pa2page>:
pa2page(uintptr_t pa) {
c0103e5a:	55                   	push   %ebp
c0103e5b:	89 e5                	mov    %esp,%ebp
c0103e5d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e63:	c1 e8 0c             	shr    $0xc,%eax
c0103e66:	89 c2                	mov    %eax,%edx
c0103e68:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0103e6d:	39 c2                	cmp    %eax,%edx
c0103e6f:	72 1c                	jb     c0103e8d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103e71:	c7 44 24 08 bc aa 10 	movl   $0xc010aabc,0x8(%esp)
c0103e78:	c0 
c0103e79:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0103e80:	00 
c0103e81:	c7 04 24 db aa 10 c0 	movl   $0xc010aadb,(%esp)
c0103e88:	e8 73 c5 ff ff       	call   c0100400 <__panic>
    return &pages[PPN(pa)];
c0103e8d:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0103e92:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e95:	c1 ea 0c             	shr    $0xc,%edx
c0103e98:	c1 e2 05             	shl    $0x5,%edx
c0103e9b:	01 d0                	add    %edx,%eax
}
c0103e9d:	c9                   	leave  
c0103e9e:	c3                   	ret    

c0103e9f <pte2page>:
pte2page(pte_t pte) {
c0103e9f:	55                   	push   %ebp
c0103ea0:	89 e5                	mov    %esp,%ebp
c0103ea2:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ea5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ea8:	83 e0 01             	and    $0x1,%eax
c0103eab:	85 c0                	test   %eax,%eax
c0103ead:	75 1c                	jne    c0103ecb <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103eaf:	c7 44 24 08 ec aa 10 	movl   $0xc010aaec,0x8(%esp)
c0103eb6:	c0 
c0103eb7:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0103ebe:	00 
c0103ebf:	c7 04 24 db aa 10 c0 	movl   $0xc010aadb,(%esp)
c0103ec6:	e8 35 c5 ff ff       	call   c0100400 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103ecb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ece:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ed3:	89 04 24             	mov    %eax,(%esp)
c0103ed6:	e8 7f ff ff ff       	call   c0103e5a <pa2page>
}
c0103edb:	c9                   	leave  
c0103edc:	c3                   	ret    

c0103edd <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0103edd:	55                   	push   %ebp
c0103ede:	89 e5                	mov    %esp,%ebp
c0103ee0:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0103ee3:	e8 32 45 00 00       	call   c010841a <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0103ee8:	a1 fc b0 12 c0       	mov    0xc012b0fc,%eax
c0103eed:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0103ef2:	76 0c                	jbe    c0103f00 <swap_init+0x23>
c0103ef4:	a1 fc b0 12 c0       	mov    0xc012b0fc,%eax
c0103ef9:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0103efe:	76 25                	jbe    c0103f25 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0103f00:	a1 fc b0 12 c0       	mov    0xc012b0fc,%eax
c0103f05:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f09:	c7 44 24 08 0d ab 10 	movl   $0xc010ab0d,0x8(%esp)
c0103f10:	c0 
c0103f11:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0103f18:	00 
c0103f19:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0103f20:	e8 db c4 ff ff       	call   c0100400 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0103f25:	c7 05 70 8f 12 c0 00 	movl   $0xc0125a00,0xc0128f70
c0103f2c:	5a 12 c0 
     int r = sm->init();
c0103f2f:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0103f34:	8b 40 04             	mov    0x4(%eax),%eax
c0103f37:	ff d0                	call   *%eax
c0103f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0103f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103f40:	75 26                	jne    c0103f68 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0103f42:	c7 05 68 8f 12 c0 01 	movl   $0x1,0xc0128f68
c0103f49:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0103f4c:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0103f51:	8b 00                	mov    (%eax),%eax
c0103f53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f57:	c7 04 24 37 ab 10 c0 	movl   $0xc010ab37,(%esp)
c0103f5e:	e8 46 c3 ff ff       	call   c01002a9 <cprintf>
          check_swap();
c0103f63:	e8 9e 04 00 00       	call   c0104406 <check_swap>
     }

     return r;
c0103f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f6b:	c9                   	leave  
c0103f6c:	c3                   	ret    

c0103f6d <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0103f6d:	55                   	push   %ebp
c0103f6e:	89 e5                	mov    %esp,%ebp
c0103f70:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0103f73:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0103f78:	8b 40 08             	mov    0x8(%eax),%eax
c0103f7b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f7e:	89 14 24             	mov    %edx,(%esp)
c0103f81:	ff d0                	call   *%eax
}
c0103f83:	c9                   	leave  
c0103f84:	c3                   	ret    

c0103f85 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0103f85:	55                   	push   %ebp
c0103f86:	89 e5                	mov    %esp,%ebp
c0103f88:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0103f8b:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0103f90:	8b 40 0c             	mov    0xc(%eax),%eax
c0103f93:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f96:	89 14 24             	mov    %edx,(%esp)
c0103f99:	ff d0                	call   *%eax
}
c0103f9b:	c9                   	leave  
c0103f9c:	c3                   	ret    

c0103f9d <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103f9d:	55                   	push   %ebp
c0103f9e:	89 e5                	mov    %esp,%ebp
c0103fa0:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0103fa3:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0103fa8:	8b 40 10             	mov    0x10(%eax),%eax
c0103fab:	8b 55 14             	mov    0x14(%ebp),%edx
c0103fae:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103fb2:	8b 55 10             	mov    0x10(%ebp),%edx
c0103fb5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103fb9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fc0:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fc3:	89 14 24             	mov    %edx,(%esp)
c0103fc6:	ff d0                	call   *%eax
}
c0103fc8:	c9                   	leave  
c0103fc9:	c3                   	ret    

c0103fca <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0103fca:	55                   	push   %ebp
c0103fcb:	89 e5                	mov    %esp,%ebp
c0103fcd:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0103fd0:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0103fd5:	8b 40 14             	mov    0x14(%eax),%eax
c0103fd8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103fdb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103fdf:	8b 55 08             	mov    0x8(%ebp),%edx
c0103fe2:	89 14 24             	mov    %edx,(%esp)
c0103fe5:	ff d0                	call   *%eax
}
c0103fe7:	c9                   	leave  
c0103fe8:	c3                   	ret    

c0103fe9 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0103fe9:	55                   	push   %ebp
c0103fea:	89 e5                	mov    %esp,%ebp
c0103fec:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0103fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103ff6:	e9 53 01 00 00       	jmp    c010414e <swap_out+0x165>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0103ffb:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c0104000:	8b 40 18             	mov    0x18(%eax),%eax
c0104003:	8b 55 10             	mov    0x10(%ebp),%edx
c0104006:	89 54 24 08          	mov    %edx,0x8(%esp)
c010400a:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c010400d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104011:	8b 55 08             	mov    0x8(%ebp),%edx
c0104014:	89 14 24             	mov    %edx,(%esp)
c0104017:	ff d0                	call   *%eax
c0104019:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c010401c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104020:	74 18                	je     c010403a <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0104022:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104025:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104029:	c7 04 24 4c ab 10 c0 	movl   $0xc010ab4c,(%esp)
c0104030:	e8 74 c2 ff ff       	call   c01002a9 <cprintf>
c0104035:	e9 20 01 00 00       	jmp    c010415a <swap_out+0x171>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c010403a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010403d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104040:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0104043:	8b 45 08             	mov    0x8(%ebp),%eax
c0104046:	8b 40 0c             	mov    0xc(%eax),%eax
c0104049:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104050:	00 
c0104051:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104054:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104058:	89 04 24             	mov    %eax,(%esp)
c010405b:	e8 7c 32 00 00       	call   c01072dc <get_pte>
c0104060:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0104063:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104066:	8b 00                	mov    (%eax),%eax
c0104068:	83 e0 01             	and    $0x1,%eax
c010406b:	85 c0                	test   %eax,%eax
c010406d:	75 24                	jne    c0104093 <swap_out+0xaa>
c010406f:	c7 44 24 0c 79 ab 10 	movl   $0xc010ab79,0xc(%esp)
c0104076:	c0 
c0104077:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c010407e:	c0 
c010407f:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104086:	00 
c0104087:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010408e:	e8 6d c3 ff ff       	call   c0100400 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0104093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104096:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104099:	8b 52 1c             	mov    0x1c(%edx),%edx
c010409c:	c1 ea 0c             	shr    $0xc,%edx
c010409f:	42                   	inc    %edx
c01040a0:	c1 e2 08             	shl    $0x8,%edx
c01040a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040a7:	89 14 24             	mov    %edx,(%esp)
c01040aa:	e8 26 44 00 00       	call   c01084d5 <swapfs_write>
c01040af:	85 c0                	test   %eax,%eax
c01040b1:	74 34                	je     c01040e7 <swap_out+0xfe>
                    cprintf("SWAP: failed to save\n");
c01040b3:	c7 04 24 a3 ab 10 c0 	movl   $0xc010aba3,(%esp)
c01040ba:	e8 ea c1 ff ff       	call   c01002a9 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01040bf:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c01040c4:	8b 40 10             	mov    0x10(%eax),%eax
c01040c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040ca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01040d1:	00 
c01040d2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01040d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01040d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040dd:	8b 55 08             	mov    0x8(%ebp),%edx
c01040e0:	89 14 24             	mov    %edx,(%esp)
c01040e3:	ff d0                	call   *%eax
c01040e5:	eb 64                	jmp    c010414b <swap_out+0x162>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01040e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040ea:	8b 40 1c             	mov    0x1c(%eax),%eax
c01040ed:	c1 e8 0c             	shr    $0xc,%eax
c01040f0:	40                   	inc    %eax
c01040f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01040fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104103:	c7 04 24 bc ab 10 c0 	movl   $0xc010abbc,(%esp)
c010410a:	e8 9a c1 ff ff       	call   c01002a9 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010410f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104112:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104115:	c1 e8 0c             	shr    $0xc,%eax
c0104118:	40                   	inc    %eax
c0104119:	c1 e0 08             	shl    $0x8,%eax
c010411c:	89 c2                	mov    %eax,%edx
c010411e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104121:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0104123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104126:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010412d:	00 
c010412e:	89 04 24             	mov    %eax,(%esp)
c0104131:	e8 31 2b 00 00       	call   c0106c67 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0104136:	8b 45 08             	mov    0x8(%ebp),%eax
c0104139:	8b 40 0c             	mov    0xc(%eax),%eax
c010413c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010413f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104143:	89 04 24             	mov    %eax,(%esp)
c0104146:	e8 83 34 00 00       	call   c01075ce <tlb_invalidate>
     for (i = 0; i != n; ++ i)
c010414b:	ff 45 f4             	incl   -0xc(%ebp)
c010414e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104151:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104154:	0f 85 a1 fe ff ff    	jne    c0103ffb <swap_out+0x12>
     }
     return i;
c010415a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010415d:	c9                   	leave  
c010415e:	c3                   	ret    

c010415f <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c010415f:	55                   	push   %ebp
c0104160:	89 e5                	mov    %esp,%ebp
c0104162:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0104165:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010416c:	e8 8b 2a 00 00       	call   c0106bfc <alloc_pages>
c0104171:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0104174:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104178:	75 24                	jne    c010419e <swap_in+0x3f>
c010417a:	c7 44 24 0c fc ab 10 	movl   $0xc010abfc,0xc(%esp)
c0104181:	c0 
c0104182:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104189:	c0 
c010418a:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0104191:	00 
c0104192:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104199:	e8 62 c2 ff ff       	call   c0100400 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010419e:	8b 45 08             	mov    0x8(%ebp),%eax
c01041a1:	8b 40 0c             	mov    0xc(%eax),%eax
c01041a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01041ab:	00 
c01041ac:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041b3:	89 04 24             	mov    %eax,(%esp)
c01041b6:	e8 21 31 00 00       	call   c01072dc <get_pte>
c01041bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01041be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041c1:	8b 00                	mov    (%eax),%eax
c01041c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01041c6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01041ca:	89 04 24             	mov    %eax,(%esp)
c01041cd:	e8 91 42 00 00       	call   c0108463 <swapfs_read>
c01041d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01041d9:	74 2a                	je     c0104205 <swap_in+0xa6>
     {
        assert(r!=0);
c01041db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01041df:	75 24                	jne    c0104205 <swap_in+0xa6>
c01041e1:	c7 44 24 0c 09 ac 10 	movl   $0xc010ac09,0xc(%esp)
c01041e8:	c0 
c01041e9:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01041f0:	c0 
c01041f1:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01041f8:	00 
c01041f9:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104200:	e8 fb c1 ff ff       	call   c0100400 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0104205:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104208:	8b 00                	mov    (%eax),%eax
c010420a:	c1 e8 08             	shr    $0x8,%eax
c010420d:	89 c2                	mov    %eax,%edx
c010420f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104212:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104216:	89 54 24 04          	mov    %edx,0x4(%esp)
c010421a:	c7 04 24 10 ac 10 c0 	movl   $0xc010ac10,(%esp)
c0104221:	e8 83 c0 ff ff       	call   c01002a9 <cprintf>
     *ptr_result=result;
c0104226:	8b 45 10             	mov    0x10(%ebp),%eax
c0104229:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010422c:	89 10                	mov    %edx,(%eax)
     return 0;
c010422e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104233:	c9                   	leave  
c0104234:	c3                   	ret    

c0104235 <check_content_set>:



static inline void
check_content_set(void)
{
c0104235:	55                   	push   %ebp
c0104236:	89 e5                	mov    %esp,%ebp
c0104238:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010423b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104240:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104243:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0104248:	83 f8 01             	cmp    $0x1,%eax
c010424b:	74 24                	je     c0104271 <check_content_set+0x3c>
c010424d:	c7 44 24 0c 4e ac 10 	movl   $0xc010ac4e,0xc(%esp)
c0104254:	c0 
c0104255:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c010425c:	c0 
c010425d:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0104264:	00 
c0104265:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010426c:	e8 8f c1 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0104271:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104276:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104279:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010427e:	83 f8 01             	cmp    $0x1,%eax
c0104281:	74 24                	je     c01042a7 <check_content_set+0x72>
c0104283:	c7 44 24 0c 4e ac 10 	movl   $0xc010ac4e,0xc(%esp)
c010428a:	c0 
c010428b:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104292:	c0 
c0104293:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010429a:	00 
c010429b:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01042a2:	e8 59 c1 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01042a7:	b8 00 20 00 00       	mov    $0x2000,%eax
c01042ac:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01042af:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01042b4:	83 f8 02             	cmp    $0x2,%eax
c01042b7:	74 24                	je     c01042dd <check_content_set+0xa8>
c01042b9:	c7 44 24 0c 5d ac 10 	movl   $0xc010ac5d,0xc(%esp)
c01042c0:	c0 
c01042c1:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01042c8:	c0 
c01042c9:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01042d0:	00 
c01042d1:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01042d8:	e8 23 c1 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c01042dd:	b8 10 20 00 00       	mov    $0x2010,%eax
c01042e2:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01042e5:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01042ea:	83 f8 02             	cmp    $0x2,%eax
c01042ed:	74 24                	je     c0104313 <check_content_set+0xde>
c01042ef:	c7 44 24 0c 5d ac 10 	movl   $0xc010ac5d,0xc(%esp)
c01042f6:	c0 
c01042f7:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01042fe:	c0 
c01042ff:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0104306:	00 
c0104307:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010430e:	e8 ed c0 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0104313:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104318:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010431b:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0104320:	83 f8 03             	cmp    $0x3,%eax
c0104323:	74 24                	je     c0104349 <check_content_set+0x114>
c0104325:	c7 44 24 0c 6c ac 10 	movl   $0xc010ac6c,0xc(%esp)
c010432c:	c0 
c010432d:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104334:	c0 
c0104335:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010433c:	00 
c010433d:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104344:	e8 b7 c0 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0104349:	b8 10 30 00 00       	mov    $0x3010,%eax
c010434e:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104351:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0104356:	83 f8 03             	cmp    $0x3,%eax
c0104359:	74 24                	je     c010437f <check_content_set+0x14a>
c010435b:	c7 44 24 0c 6c ac 10 	movl   $0xc010ac6c,0xc(%esp)
c0104362:	c0 
c0104363:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c010436a:	c0 
c010436b:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0104372:	00 
c0104373:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010437a:	e8 81 c0 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010437f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104384:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104387:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010438c:	83 f8 04             	cmp    $0x4,%eax
c010438f:	74 24                	je     c01043b5 <check_content_set+0x180>
c0104391:	c7 44 24 0c 7b ac 10 	movl   $0xc010ac7b,0xc(%esp)
c0104398:	c0 
c0104399:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01043a0:	c0 
c01043a1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01043a8:	00 
c01043a9:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01043b0:	e8 4b c0 ff ff       	call   c0100400 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01043b5:	b8 10 40 00 00       	mov    $0x4010,%eax
c01043ba:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01043bd:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01043c2:	83 f8 04             	cmp    $0x4,%eax
c01043c5:	74 24                	je     c01043eb <check_content_set+0x1b6>
c01043c7:	c7 44 24 0c 7b ac 10 	movl   $0xc010ac7b,0xc(%esp)
c01043ce:	c0 
c01043cf:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01043d6:	c0 
c01043d7:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01043de:	00 
c01043df:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01043e6:	e8 15 c0 ff ff       	call   c0100400 <__panic>
}
c01043eb:	90                   	nop
c01043ec:	c9                   	leave  
c01043ed:	c3                   	ret    

c01043ee <check_content_access>:

static inline int
check_content_access(void)
{
c01043ee:	55                   	push   %ebp
c01043ef:	89 e5                	mov    %esp,%ebp
c01043f1:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c01043f4:	a1 70 8f 12 c0       	mov    0xc0128f70,%eax
c01043f9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01043fc:	ff d0                	call   *%eax
c01043fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0104401:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104404:	c9                   	leave  
c0104405:	c3                   	ret    

c0104406 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0104406:	55                   	push   %ebp
c0104407:	89 e5                	mov    %esp,%ebp
c0104409:	83 ec 78             	sub    $0x78,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010440c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104413:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010441a:	c7 45 e8 2c b1 12 c0 	movl   $0xc012b12c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104421:	eb 6a                	jmp    c010448d <check_swap+0x87>
        struct Page *p = le2page(le, page_link);
c0104423:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104426:	83 e8 0c             	sub    $0xc,%eax
c0104429:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(PageProperty(p));
c010442c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010442f:	83 c0 04             	add    $0x4,%eax
c0104432:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104439:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010443c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010443f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104442:	0f a3 10             	bt     %edx,(%eax)
c0104445:	19 c0                	sbb    %eax,%eax
c0104447:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c010444a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010444e:	0f 95 c0             	setne  %al
c0104451:	0f b6 c0             	movzbl %al,%eax
c0104454:	85 c0                	test   %eax,%eax
c0104456:	75 24                	jne    c010447c <check_swap+0x76>
c0104458:	c7 44 24 0c 8a ac 10 	movl   $0xc010ac8a,0xc(%esp)
c010445f:	c0 
c0104460:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104467:	c0 
c0104468:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c010446f:	00 
c0104470:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104477:	e8 84 bf ff ff       	call   c0100400 <__panic>
        count ++, total += p->property;
c010447c:	ff 45 f4             	incl   -0xc(%ebp)
c010447f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104482:	8b 50 08             	mov    0x8(%eax),%edx
c0104485:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104488:	01 d0                	add    %edx,%eax
c010448a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010448d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104490:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104493:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104496:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0104499:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010449c:	81 7d e8 2c b1 12 c0 	cmpl   $0xc012b12c,-0x18(%ebp)
c01044a3:	0f 85 7a ff ff ff    	jne    c0104423 <check_swap+0x1d>
     }
     assert(total == nr_free_pages());
c01044a9:	e8 ec 27 00 00       	call   c0106c9a <nr_free_pages>
c01044ae:	89 c2                	mov    %eax,%edx
c01044b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044b3:	39 c2                	cmp    %eax,%edx
c01044b5:	74 24                	je     c01044db <check_swap+0xd5>
c01044b7:	c7 44 24 0c 9a ac 10 	movl   $0xc010ac9a,0xc(%esp)
c01044be:	c0 
c01044bf:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01044c6:	c0 
c01044c7:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01044ce:	00 
c01044cf:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01044d6:	e8 25 bf ff ff       	call   c0100400 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c01044db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044de:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044e9:	c7 04 24 b4 ac 10 c0 	movl   $0xc010acb4,(%esp)
c01044f0:	e8 b4 bd ff ff       	call   c01002a9 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c01044f5:	e8 95 ec ff ff       	call   c010318f <mm_create>
c01044fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     assert(mm != NULL);
c01044fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104501:	75 24                	jne    c0104527 <check_swap+0x121>
c0104503:	c7 44 24 0c da ac 10 	movl   $0xc010acda,0xc(%esp)
c010450a:	c0 
c010450b:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104512:	c0 
c0104513:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010451a:	00 
c010451b:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104522:	e8 d9 be ff ff       	call   c0100400 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0104527:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c010452c:	85 c0                	test   %eax,%eax
c010452e:	74 24                	je     c0104554 <check_swap+0x14e>
c0104530:	c7 44 24 0c e5 ac 10 	movl   $0xc010ace5,0xc(%esp)
c0104537:	c0 
c0104538:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c010453f:	c0 
c0104540:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0104547:	00 
c0104548:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010454f:	e8 ac be ff ff       	call   c0100400 <__panic>

     check_mm_struct = mm;
c0104554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104557:	a3 58 b0 12 c0       	mov    %eax,0xc012b058

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010455c:	8b 15 20 5a 12 c0    	mov    0xc0125a20,%edx
c0104562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104565:	89 50 0c             	mov    %edx,0xc(%eax)
c0104568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010456b:	8b 40 0c             	mov    0xc(%eax),%eax
c010456e:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(pgdir[0] == 0);
c0104571:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104574:	8b 00                	mov    (%eax),%eax
c0104576:	85 c0                	test   %eax,%eax
c0104578:	74 24                	je     c010459e <check_swap+0x198>
c010457a:	c7 44 24 0c fd ac 10 	movl   $0xc010acfd,0xc(%esp)
c0104581:	c0 
c0104582:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104589:	c0 
c010458a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104591:	00 
c0104592:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104599:	e8 62 be ff ff       	call   c0100400 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010459e:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01045a5:	00 
c01045a6:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01045ad:	00 
c01045ae:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01045b5:	e8 4d ec ff ff       	call   c0103207 <vma_create>
c01045ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(vma != NULL);
c01045bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01045c1:	75 24                	jne    c01045e7 <check_swap+0x1e1>
c01045c3:	c7 44 24 0c 0b ad 10 	movl   $0xc010ad0b,0xc(%esp)
c01045ca:	c0 
c01045cb:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01045d2:	c0 
c01045d3:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01045da:	00 
c01045db:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01045e2:	e8 19 be ff ff       	call   c0100400 <__panic>

     insert_vma_struct(mm, vma);
c01045e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045f1:	89 04 24             	mov    %eax,(%esp)
c01045f4:	e8 9f ed ff ff       	call   c0103398 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01045f9:	c7 04 24 18 ad 10 c0 	movl   $0xc010ad18,(%esp)
c0104600:	e8 a4 bc ff ff       	call   c01002a9 <cprintf>
     pte_t *temp_ptep=NULL;
c0104605:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010460c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010460f:	8b 40 0c             	mov    0xc(%eax),%eax
c0104612:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104619:	00 
c010461a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104621:	00 
c0104622:	89 04 24             	mov    %eax,(%esp)
c0104625:	e8 b2 2c 00 00       	call   c01072dc <get_pte>
c010462a:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(temp_ptep!= NULL);
c010462d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104631:	75 24                	jne    c0104657 <check_swap+0x251>
c0104633:	c7 44 24 0c 4c ad 10 	movl   $0xc010ad4c,0xc(%esp)
c010463a:	c0 
c010463b:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104642:	c0 
c0104643:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010464a:	00 
c010464b:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104652:	e8 a9 bd ff ff       	call   c0100400 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0104657:	c7 04 24 60 ad 10 c0 	movl   $0xc010ad60,(%esp)
c010465e:	e8 46 bc ff ff       	call   c01002a9 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104663:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010466a:	e9 a4 00 00 00       	jmp    c0104713 <check_swap+0x30d>
          check_rp[i] = alloc_page();
c010466f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104676:	e8 81 25 00 00       	call   c0106bfc <alloc_pages>
c010467b:	89 c2                	mov    %eax,%edx
c010467d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104680:	89 14 85 60 b0 12 c0 	mov    %edx,-0x3fed4fa0(,%eax,4)
          assert(check_rp[i] != NULL );
c0104687:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010468a:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c0104691:	85 c0                	test   %eax,%eax
c0104693:	75 24                	jne    c01046b9 <check_swap+0x2b3>
c0104695:	c7 44 24 0c 84 ad 10 	movl   $0xc010ad84,0xc(%esp)
c010469c:	c0 
c010469d:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01046a4:	c0 
c01046a5:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01046ac:	00 
c01046ad:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01046b4:	e8 47 bd ff ff       	call   c0100400 <__panic>
          assert(!PageProperty(check_rp[i]));
c01046b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046bc:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c01046c3:	83 c0 04             	add    $0x4,%eax
c01046c6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01046cd:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01046d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01046d3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01046d6:	0f a3 10             	bt     %edx,(%eax)
c01046d9:	19 c0                	sbb    %eax,%eax
c01046db:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c01046de:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01046e2:	0f 95 c0             	setne  %al
c01046e5:	0f b6 c0             	movzbl %al,%eax
c01046e8:	85 c0                	test   %eax,%eax
c01046ea:	74 24                	je     c0104710 <check_swap+0x30a>
c01046ec:	c7 44 24 0c 98 ad 10 	movl   $0xc010ad98,0xc(%esp)
c01046f3:	c0 
c01046f4:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01046fb:	c0 
c01046fc:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104703:	00 
c0104704:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010470b:	e8 f0 bc ff ff       	call   c0100400 <__panic>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104710:	ff 45 ec             	incl   -0x14(%ebp)
c0104713:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104717:	0f 8e 52 ff ff ff    	jle    c010466f <check_swap+0x269>
     }
     list_entry_t free_list_store = free_list;
c010471d:	a1 2c b1 12 c0       	mov    0xc012b12c,%eax
c0104722:	8b 15 30 b1 12 c0    	mov    0xc012b130,%edx
c0104728:	89 45 98             	mov    %eax,-0x68(%ebp)
c010472b:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010472e:	c7 45 a4 2c b1 12 c0 	movl   $0xc012b12c,-0x5c(%ebp)
    elm->prev = elm->next = elm;
c0104735:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104738:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c010473b:	89 50 04             	mov    %edx,0x4(%eax)
c010473e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104741:	8b 50 04             	mov    0x4(%eax),%edx
c0104744:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104747:	89 10                	mov    %edx,(%eax)
c0104749:	c7 45 a8 2c b1 12 c0 	movl   $0xc012b12c,-0x58(%ebp)
    return list->next == list;
c0104750:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104753:	8b 40 04             	mov    0x4(%eax),%eax
c0104756:	39 45 a8             	cmp    %eax,-0x58(%ebp)
c0104759:	0f 94 c0             	sete   %al
c010475c:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010475f:	85 c0                	test   %eax,%eax
c0104761:	75 24                	jne    c0104787 <check_swap+0x381>
c0104763:	c7 44 24 0c b3 ad 10 	movl   $0xc010adb3,0xc(%esp)
c010476a:	c0 
c010476b:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104772:	c0 
c0104773:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010477a:	00 
c010477b:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104782:	e8 79 bc ff ff       	call   c0100400 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0104787:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c010478c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     nr_free = 0;
c010478f:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c0104796:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104799:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01047a0:	eb 1d                	jmp    c01047bf <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01047a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a5:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c01047ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047b3:	00 
c01047b4:	89 04 24             	mov    %eax,(%esp)
c01047b7:	e8 ab 24 00 00       	call   c0106c67 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01047bc:	ff 45 ec             	incl   -0x14(%ebp)
c01047bf:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01047c3:	7e dd                	jle    c01047a2 <check_swap+0x39c>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01047c5:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c01047ca:	83 f8 04             	cmp    $0x4,%eax
c01047cd:	74 24                	je     c01047f3 <check_swap+0x3ed>
c01047cf:	c7 44 24 0c cc ad 10 	movl   $0xc010adcc,0xc(%esp)
c01047d6:	c0 
c01047d7:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01047de:	c0 
c01047df:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01047e6:	00 
c01047e7:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01047ee:	e8 0d bc ff ff       	call   c0100400 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01047f3:	c7 04 24 f0 ad 10 c0 	movl   $0xc010adf0,(%esp)
c01047fa:	e8 aa ba ff ff       	call   c01002a9 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01047ff:	c7 05 64 8f 12 c0 00 	movl   $0x0,0xc0128f64
c0104806:	00 00 00 
     
     check_content_set();
c0104809:	e8 27 fa ff ff       	call   c0104235 <check_content_set>
     assert( nr_free == 0);         
c010480e:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0104813:	85 c0                	test   %eax,%eax
c0104815:	74 24                	je     c010483b <check_swap+0x435>
c0104817:	c7 44 24 0c 17 ae 10 	movl   $0xc010ae17,0xc(%esp)
c010481e:	c0 
c010481f:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104826:	c0 
c0104827:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010482e:	00 
c010482f:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104836:	e8 c5 bb ff ff       	call   c0100400 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010483b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104842:	eb 25                	jmp    c0104869 <check_swap+0x463>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0104844:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104847:	c7 04 85 80 b0 12 c0 	movl   $0xffffffff,-0x3fed4f80(,%eax,4)
c010484e:	ff ff ff ff 
c0104852:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104855:	8b 14 85 80 b0 12 c0 	mov    -0x3fed4f80(,%eax,4),%edx
c010485c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010485f:	89 14 85 c0 b0 12 c0 	mov    %edx,-0x3fed4f40(,%eax,4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0104866:	ff 45 ec             	incl   -0x14(%ebp)
c0104869:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010486d:	7e d5                	jle    c0104844 <check_swap+0x43e>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010486f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104876:	e9 ec 00 00 00       	jmp    c0104967 <check_swap+0x561>
         check_ptep[i]=0;
c010487b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010487e:	c7 04 85 14 b1 12 c0 	movl   $0x0,-0x3fed4eec(,%eax,4)
c0104885:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0104889:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010488c:	40                   	inc    %eax
c010488d:	c1 e0 0c             	shl    $0xc,%eax
c0104890:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104897:	00 
c0104898:	89 44 24 04          	mov    %eax,0x4(%esp)
c010489c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010489f:	89 04 24             	mov    %eax,(%esp)
c01048a2:	e8 35 2a 00 00       	call   c01072dc <get_pte>
c01048a7:	89 c2                	mov    %eax,%edx
c01048a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048ac:	89 14 85 14 b1 12 c0 	mov    %edx,-0x3fed4eec(,%eax,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01048b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048b6:	8b 04 85 14 b1 12 c0 	mov    -0x3fed4eec(,%eax,4),%eax
c01048bd:	85 c0                	test   %eax,%eax
c01048bf:	75 24                	jne    c01048e5 <check_swap+0x4df>
c01048c1:	c7 44 24 0c 24 ae 10 	movl   $0xc010ae24,0xc(%esp)
c01048c8:	c0 
c01048c9:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c01048d0:	c0 
c01048d1:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01048d8:	00 
c01048d9:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01048e0:	e8 1b bb ff ff       	call   c0100400 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01048e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048e8:	8b 04 85 14 b1 12 c0 	mov    -0x3fed4eec(,%eax,4),%eax
c01048ef:	8b 00                	mov    (%eax),%eax
c01048f1:	89 04 24             	mov    %eax,(%esp)
c01048f4:	e8 a6 f5 ff ff       	call   c0103e9f <pte2page>
c01048f9:	89 c2                	mov    %eax,%edx
c01048fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048fe:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c0104905:	39 c2                	cmp    %eax,%edx
c0104907:	74 24                	je     c010492d <check_swap+0x527>
c0104909:	c7 44 24 0c 3c ae 10 	movl   $0xc010ae3c,0xc(%esp)
c0104910:	c0 
c0104911:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c0104918:	c0 
c0104919:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0104920:	00 
c0104921:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c0104928:	e8 d3 ba ff ff       	call   c0100400 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c010492d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104930:	8b 04 85 14 b1 12 c0 	mov    -0x3fed4eec(,%eax,4),%eax
c0104937:	8b 00                	mov    (%eax),%eax
c0104939:	83 e0 01             	and    $0x1,%eax
c010493c:	85 c0                	test   %eax,%eax
c010493e:	75 24                	jne    c0104964 <check_swap+0x55e>
c0104940:	c7 44 24 0c 64 ae 10 	movl   $0xc010ae64,0xc(%esp)
c0104947:	c0 
c0104948:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c010494f:	c0 
c0104950:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104957:	00 
c0104958:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c010495f:	e8 9c ba ff ff       	call   c0100400 <__panic>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104964:	ff 45 ec             	incl   -0x14(%ebp)
c0104967:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010496b:	0f 8e 0a ff ff ff    	jle    c010487b <check_swap+0x475>
     }
     cprintf("set up init env for check_swap over!\n");
c0104971:	c7 04 24 80 ae 10 c0 	movl   $0xc010ae80,(%esp)
c0104978:	e8 2c b9 ff ff       	call   c01002a9 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c010497d:	e8 6c fa ff ff       	call   c01043ee <check_content_access>
c0104982:	89 45 d0             	mov    %eax,-0x30(%ebp)
     assert(ret==0);
c0104985:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0104989:	74 24                	je     c01049af <check_swap+0x5a9>
c010498b:	c7 44 24 0c a6 ae 10 	movl   $0xc010aea6,0xc(%esp)
c0104992:	c0 
c0104993:	c7 44 24 08 8e ab 10 	movl   $0xc010ab8e,0x8(%esp)
c010499a:	c0 
c010499b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01049a2:	00 
c01049a3:	c7 04 24 28 ab 10 c0 	movl   $0xc010ab28,(%esp)
c01049aa:	e8 51 ba ff ff       	call   c0100400 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01049af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01049b6:	eb 1d                	jmp    c01049d5 <check_swap+0x5cf>
         free_pages(check_rp[i],1);
c01049b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049bb:	8b 04 85 60 b0 12 c0 	mov    -0x3fed4fa0(,%eax,4),%eax
c01049c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01049c9:	00 
c01049ca:	89 04 24             	mov    %eax,(%esp)
c01049cd:	e8 95 22 00 00       	call   c0106c67 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01049d2:	ff 45 ec             	incl   -0x14(%ebp)
c01049d5:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01049d9:	7e dd                	jle    c01049b8 <check_swap+0x5b2>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01049db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049de:	89 04 24             	mov    %eax,(%esp)
c01049e1:	e8 e4 ea ff ff       	call   c01034ca <mm_destroy>
         
     nr_free = nr_free_store;
c01049e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01049e9:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
     free_list = free_list_store;
c01049ee:	8b 45 98             	mov    -0x68(%ebp),%eax
c01049f1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01049f4:	a3 2c b1 12 c0       	mov    %eax,0xc012b12c
c01049f9:	89 15 30 b1 12 c0    	mov    %edx,0xc012b130

     
     le = &free_list;
c01049ff:	c7 45 e8 2c b1 12 c0 	movl   $0xc012b12c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104a06:	eb 1c                	jmp    c0104a24 <check_swap+0x61e>
         struct Page *p = le2page(le, page_link);
c0104a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a0b:	83 e8 0c             	sub    $0xc,%eax
c0104a0e:	89 45 cc             	mov    %eax,-0x34(%ebp)
         count --, total -= p->property;
c0104a11:	ff 4d f4             	decl   -0xc(%ebp)
c0104a14:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104a17:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104a1a:	8b 40 08             	mov    0x8(%eax),%eax
c0104a1d:	29 c2                	sub    %eax,%edx
c0104a1f:	89 d0                	mov    %edx,%eax
c0104a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a27:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0104a2a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104a2d:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0104a30:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a33:	81 7d e8 2c b1 12 c0 	cmpl   $0xc012b12c,-0x18(%ebp)
c0104a3a:	75 cc                	jne    c0104a08 <check_swap+0x602>
     }
     cprintf("count is %d, total is %d\n",count,total);
c0104a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a3f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a4a:	c7 04 24 ad ae 10 c0 	movl   $0xc010aead,(%esp)
c0104a51:	e8 53 b8 ff ff       	call   c01002a9 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0104a56:	c7 04 24 c7 ae 10 c0 	movl   $0xc010aec7,(%esp)
c0104a5d:	e8 47 b8 ff ff       	call   c01002a9 <cprintf>
}
c0104a62:	90                   	nop
c0104a63:	c9                   	leave  
c0104a64:	c3                   	ret    

c0104a65 <__intr_save>:
__intr_save(void) {
c0104a65:	55                   	push   %ebp
c0104a66:	89 e5                	mov    %esp,%ebp
c0104a68:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104a6b:	9c                   	pushf  
c0104a6c:	58                   	pop    %eax
c0104a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104a73:	25 00 02 00 00       	and    $0x200,%eax
c0104a78:	85 c0                	test   %eax,%eax
c0104a7a:	74 0c                	je     c0104a88 <__intr_save+0x23>
        intr_disable();
c0104a7c:	e8 b1 d5 ff ff       	call   c0102032 <intr_disable>
        return 1;
c0104a81:	b8 01 00 00 00       	mov    $0x1,%eax
c0104a86:	eb 05                	jmp    c0104a8d <__intr_save+0x28>
    return 0;
c0104a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a8d:	c9                   	leave  
c0104a8e:	c3                   	ret    

c0104a8f <__intr_restore>:
__intr_restore(bool flag) {
c0104a8f:	55                   	push   %ebp
c0104a90:	89 e5                	mov    %esp,%ebp
c0104a92:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104a95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a99:	74 05                	je     c0104aa0 <__intr_restore+0x11>
        intr_enable();
c0104a9b:	e8 8b d5 ff ff       	call   c010202b <intr_enable>
}
c0104aa0:	90                   	nop
c0104aa1:	c9                   	leave  
c0104aa2:	c3                   	ret    

c0104aa3 <page2ppn>:
page2ppn(struct Page *page) {
c0104aa3:	55                   	push   %ebp
c0104aa4:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aa9:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c0104aaf:	29 d0                	sub    %edx,%eax
c0104ab1:	c1 f8 05             	sar    $0x5,%eax
}
c0104ab4:	5d                   	pop    %ebp
c0104ab5:	c3                   	ret    

c0104ab6 <page2pa>:
page2pa(struct Page *page) {
c0104ab6:	55                   	push   %ebp
c0104ab7:	89 e5                	mov    %esp,%ebp
c0104ab9:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104abc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104abf:	89 04 24             	mov    %eax,(%esp)
c0104ac2:	e8 dc ff ff ff       	call   c0104aa3 <page2ppn>
c0104ac7:	c1 e0 0c             	shl    $0xc,%eax
}
c0104aca:	c9                   	leave  
c0104acb:	c3                   	ret    

c0104acc <pa2page>:
pa2page(uintptr_t pa) {
c0104acc:	55                   	push   %ebp
c0104acd:	89 e5                	mov    %esp,%ebp
c0104acf:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ad5:	c1 e8 0c             	shr    $0xc,%eax
c0104ad8:	89 c2                	mov    %eax,%edx
c0104ada:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0104adf:	39 c2                	cmp    %eax,%edx
c0104ae1:	72 1c                	jb     c0104aff <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104ae3:	c7 44 24 08 e0 ae 10 	movl   $0xc010aee0,0x8(%esp)
c0104aea:	c0 
c0104aeb:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104af2:	00 
c0104af3:	c7 04 24 ff ae 10 c0 	movl   $0xc010aeff,(%esp)
c0104afa:	e8 01 b9 ff ff       	call   c0100400 <__panic>
    return &pages[PPN(pa)];
c0104aff:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0104b04:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b07:	c1 ea 0c             	shr    $0xc,%edx
c0104b0a:	c1 e2 05             	shl    $0x5,%edx
c0104b0d:	01 d0                	add    %edx,%eax
}
c0104b0f:	c9                   	leave  
c0104b10:	c3                   	ret    

c0104b11 <page2kva>:
page2kva(struct Page *page) {
c0104b11:	55                   	push   %ebp
c0104b12:	89 e5                	mov    %esp,%ebp
c0104b14:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b1a:	89 04 24             	mov    %eax,(%esp)
c0104b1d:	e8 94 ff ff ff       	call   c0104ab6 <page2pa>
c0104b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b28:	c1 e8 0c             	shr    $0xc,%eax
c0104b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b2e:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0104b33:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104b36:	72 23                	jb     c0104b5b <page2kva+0x4a>
c0104b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b3f:	c7 44 24 08 10 af 10 	movl   $0xc010af10,0x8(%esp)
c0104b46:	c0 
c0104b47:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104b4e:	00 
c0104b4f:	c7 04 24 ff ae 10 c0 	movl   $0xc010aeff,(%esp)
c0104b56:	e8 a5 b8 ff ff       	call   c0100400 <__panic>
c0104b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b5e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104b63:	c9                   	leave  
c0104b64:	c3                   	ret    

c0104b65 <kva2page>:
kva2page(void *kva) {
c0104b65:	55                   	push   %ebp
c0104b66:	89 e5                	mov    %esp,%ebp
c0104b68:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b71:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104b78:	77 23                	ja     c0104b9d <kva2page+0x38>
c0104b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b81:	c7 44 24 08 34 af 10 	movl   $0xc010af34,0x8(%esp)
c0104b88:	c0 
c0104b89:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104b90:	00 
c0104b91:	c7 04 24 ff ae 10 c0 	movl   $0xc010aeff,(%esp)
c0104b98:	e8 63 b8 ff ff       	call   c0100400 <__panic>
c0104b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ba0:	05 00 00 00 40       	add    $0x40000000,%eax
c0104ba5:	89 04 24             	mov    %eax,(%esp)
c0104ba8:	e8 1f ff ff ff       	call   c0104acc <pa2page>
}
c0104bad:	c9                   	leave  
c0104bae:	c3                   	ret    

c0104baf <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104baf:	55                   	push   %ebp
c0104bb0:	89 e5                	mov    %esp,%ebp
c0104bb2:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c0104bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bb8:	ba 01 00 00 00       	mov    $0x1,%edx
c0104bbd:	88 c1                	mov    %al,%cl
c0104bbf:	d3 e2                	shl    %cl,%edx
c0104bc1:	89 d0                	mov    %edx,%eax
c0104bc3:	89 04 24             	mov    %eax,(%esp)
c0104bc6:	e8 31 20 00 00       	call   c0106bfc <alloc_pages>
c0104bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bd2:	75 07                	jne    c0104bdb <__slob_get_free_pages+0x2c>
    return NULL;
c0104bd4:	b8 00 00 00 00       	mov    $0x0,%eax
c0104bd9:	eb 0b                	jmp    c0104be6 <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bde:	89 04 24             	mov    %eax,(%esp)
c0104be1:	e8 2b ff ff ff       	call   c0104b11 <page2kva>
}
c0104be6:	c9                   	leave  
c0104be7:	c3                   	ret    

c0104be8 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104be8:	55                   	push   %ebp
c0104be9:	89 e5                	mov    %esp,%ebp
c0104beb:	53                   	push   %ebx
c0104bec:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104bef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104bf2:	ba 01 00 00 00       	mov    $0x1,%edx
c0104bf7:	88 c1                	mov    %al,%cl
c0104bf9:	d3 e2                	shl    %cl,%edx
c0104bfb:	89 d0                	mov    %edx,%eax
c0104bfd:	89 c3                	mov    %eax,%ebx
c0104bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c02:	89 04 24             	mov    %eax,(%esp)
c0104c05:	e8 5b ff ff ff       	call   c0104b65 <kva2page>
c0104c0a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104c0e:	89 04 24             	mov    %eax,(%esp)
c0104c11:	e8 51 20 00 00       	call   c0106c67 <free_pages>
}
c0104c16:	90                   	nop
c0104c17:	83 c4 14             	add    $0x14,%esp
c0104c1a:	5b                   	pop    %ebx
c0104c1b:	5d                   	pop    %ebp
c0104c1c:	c3                   	ret    

c0104c1d <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104c1d:	55                   	push   %ebp
c0104c1e:	89 e5                	mov    %esp,%ebp
c0104c20:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c26:	83 c0 08             	add    $0x8,%eax
c0104c29:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104c2e:	76 24                	jbe    c0104c54 <slob_alloc+0x37>
c0104c30:	c7 44 24 0c 58 af 10 	movl   $0xc010af58,0xc(%esp)
c0104c37:	c0 
c0104c38:	c7 44 24 08 77 af 10 	movl   $0xc010af77,0x8(%esp)
c0104c3f:	c0 
c0104c40:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0104c47:	00 
c0104c48:	c7 04 24 8c af 10 c0 	movl   $0xc010af8c,(%esp)
c0104c4f:	e8 ac b7 ff ff       	call   c0100400 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104c54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104c5b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104c62:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c65:	83 c0 07             	add    $0x7,%eax
c0104c68:	c1 e8 03             	shr    $0x3,%eax
c0104c6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104c6e:	e8 f2 fd ff ff       	call   c0104a65 <__intr_save>
c0104c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104c76:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c81:	8b 40 04             	mov    0x4(%eax),%eax
c0104c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104c8b:	74 25                	je     c0104cb2 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104c8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c90:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c93:	01 d0                	add    %edx,%eax
c0104c95:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104c98:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c9b:	f7 d8                	neg    %eax
c0104c9d:	21 d0                	and    %edx,%eax
c0104c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104ca2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca8:	29 c2                	sub    %eax,%edx
c0104caa:	89 d0                	mov    %edx,%eax
c0104cac:	c1 f8 03             	sar    $0x3,%eax
c0104caf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cb5:	8b 00                	mov    (%eax),%eax
c0104cb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104cba:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104cbd:	01 ca                	add    %ecx,%edx
c0104cbf:	39 d0                	cmp    %edx,%eax
c0104cc1:	0f 8c aa 00 00 00    	jl     c0104d71 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c0104cc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ccb:	74 38                	je     c0104d05 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cd0:	8b 00                	mov    (%eax),%eax
c0104cd2:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104cd5:	89 c2                	mov    %eax,%edx
c0104cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cda:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cdf:	8b 50 04             	mov    0x4(%eax),%edx
c0104ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ce5:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ceb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104cee:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cf4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104cf7:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d08:	8b 00                	mov    (%eax),%eax
c0104d0a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104d0d:	75 0e                	jne    c0104d1d <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d12:	8b 50 04             	mov    0x4(%eax),%edx
c0104d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d18:	89 50 04             	mov    %edx,0x4(%eax)
c0104d1b:	eb 3c                	jmp    c0104d59 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d20:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d2a:	01 c2                	add    %eax,%edx
c0104d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d2f:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d35:	8b 10                	mov    (%eax),%edx
c0104d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d3a:	8b 40 04             	mov    0x4(%eax),%eax
c0104d3d:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104d40:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d45:	8b 40 04             	mov    0x4(%eax),%eax
c0104d48:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104d4b:	8b 52 04             	mov    0x4(%edx),%edx
c0104d4e:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d54:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104d57:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d5c:	a3 e8 59 12 c0       	mov    %eax,0xc01259e8
			spin_unlock_irqrestore(&slob_lock, flags);
c0104d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d64:	89 04 24             	mov    %eax,(%esp)
c0104d67:	e8 23 fd ff ff       	call   c0104a8f <__intr_restore>
			return cur;
c0104d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d6f:	eb 7f                	jmp    c0104df0 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104d71:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104d76:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104d79:	75 61                	jne    c0104ddc <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d7e:	89 04 24             	mov    %eax,(%esp)
c0104d81:	e8 09 fd ff ff       	call   c0104a8f <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104d86:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104d8d:	75 07                	jne    c0104d96 <slob_alloc+0x179>
				return 0;
c0104d8f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104d94:	eb 5a                	jmp    c0104df0 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104d96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d9d:	00 
c0104d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104da1:	89 04 24             	mov    %eax,(%esp)
c0104da4:	e8 06 fe ff ff       	call   c0104baf <__slob_get_free_pages>
c0104da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104dac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104db0:	75 07                	jne    c0104db9 <slob_alloc+0x19c>
				return 0;
c0104db2:	b8 00 00 00 00       	mov    $0x0,%eax
c0104db7:	eb 37                	jmp    c0104df0 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104db9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dc0:	00 
c0104dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dc4:	89 04 24             	mov    %eax,(%esp)
c0104dc7:	e8 26 00 00 00       	call   c0104df2 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104dcc:	e8 94 fc ff ff       	call   c0104a65 <__intr_save>
c0104dd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104dd4:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104de5:	8b 40 04             	mov    0x4(%eax),%eax
c0104de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104deb:	e9 97 fe ff ff       	jmp    c0104c87 <slob_alloc+0x6a>
		}
	}
}
c0104df0:	c9                   	leave  
c0104df1:	c3                   	ret    

c0104df2 <slob_free>:

static void slob_free(void *block, int size)
{
c0104df2:	55                   	push   %ebp
c0104df3:	89 e5                	mov    %esp,%ebp
c0104df5:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104dfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104dfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104e02:	0f 84 01 01 00 00    	je     c0104f09 <slob_free+0x117>
		return;

	if (size)
c0104e08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104e0c:	74 10                	je     c0104e1e <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c0104e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e11:	83 c0 07             	add    $0x7,%eax
c0104e14:	c1 e8 03             	shr    $0x3,%eax
c0104e17:	89 c2                	mov    %eax,%edx
c0104e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e1c:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104e1e:	e8 42 fc ff ff       	call   c0104a65 <__intr_save>
c0104e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104e26:	a1 e8 59 12 c0       	mov    0xc01259e8,%eax
c0104e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e2e:	eb 27                	jmp    c0104e57 <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e33:	8b 40 04             	mov    0x4(%eax),%eax
c0104e36:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104e39:	72 13                	jb     c0104e4e <slob_free+0x5c>
c0104e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e41:	77 27                	ja     c0104e6a <slob_free+0x78>
c0104e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e46:	8b 40 04             	mov    0x4(%eax),%eax
c0104e49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104e4c:	72 1c                	jb     c0104e6a <slob_free+0x78>
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e51:	8b 40 04             	mov    0x4(%eax),%eax
c0104e54:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e5d:	76 d1                	jbe    c0104e30 <slob_free+0x3e>
c0104e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e62:	8b 40 04             	mov    0x4(%eax),%eax
c0104e65:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104e68:	73 c6                	jae    c0104e30 <slob_free+0x3e>
			break;

	if (b + b->units == cur->next) {
c0104e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e6d:	8b 00                	mov    (%eax),%eax
c0104e6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e79:	01 c2                	add    %eax,%edx
c0104e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e7e:	8b 40 04             	mov    0x4(%eax),%eax
c0104e81:	39 c2                	cmp    %eax,%edx
c0104e83:	75 25                	jne    c0104eaa <slob_free+0xb8>
		b->units += cur->next->units;
c0104e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e88:	8b 10                	mov    (%eax),%edx
c0104e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e8d:	8b 40 04             	mov    0x4(%eax),%eax
c0104e90:	8b 00                	mov    (%eax),%eax
c0104e92:	01 c2                	add    %eax,%edx
c0104e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e97:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e9c:	8b 40 04             	mov    0x4(%eax),%eax
c0104e9f:	8b 50 04             	mov    0x4(%eax),%edx
c0104ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ea5:	89 50 04             	mov    %edx,0x4(%eax)
c0104ea8:	eb 0c                	jmp    c0104eb6 <slob_free+0xc4>
	} else
		b->next = cur->next;
c0104eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ead:	8b 50 04             	mov    0x4(%eax),%edx
c0104eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104eb3:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb9:	8b 00                	mov    (%eax),%eax
c0104ebb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ec5:	01 d0                	add    %edx,%eax
c0104ec7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104eca:	75 1f                	jne    c0104eeb <slob_free+0xf9>
		cur->units += b->units;
c0104ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ecf:	8b 10                	mov    (%eax),%edx
c0104ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ed4:	8b 00                	mov    (%eax),%eax
c0104ed6:	01 c2                	add    %eax,%edx
c0104ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104edb:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee0:	8b 50 04             	mov    0x4(%eax),%edx
c0104ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ee6:	89 50 04             	mov    %edx,0x4(%eax)
c0104ee9:	eb 09                	jmp    c0104ef4 <slob_free+0x102>
	} else
		cur->next = b;
c0104eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104ef1:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef7:	a3 e8 59 12 c0       	mov    %eax,0xc01259e8

	spin_unlock_irqrestore(&slob_lock, flags);
c0104efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104eff:	89 04 24             	mov    %eax,(%esp)
c0104f02:	e8 88 fb ff ff       	call   c0104a8f <__intr_restore>
c0104f07:	eb 01                	jmp    c0104f0a <slob_free+0x118>
		return;
c0104f09:	90                   	nop
}
c0104f0a:	c9                   	leave  
c0104f0b:	c3                   	ret    

c0104f0c <slob_init>:



void
slob_init(void) {
c0104f0c:	55                   	push   %ebp
c0104f0d:	89 e5                	mov    %esp,%ebp
c0104f0f:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104f12:	c7 04 24 9e af 10 c0 	movl   $0xc010af9e,(%esp)
c0104f19:	e8 8b b3 ff ff       	call   c01002a9 <cprintf>
}
c0104f1e:	90                   	nop
c0104f1f:	c9                   	leave  
c0104f20:	c3                   	ret    

c0104f21 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104f21:	55                   	push   %ebp
c0104f22:	89 e5                	mov    %esp,%ebp
c0104f24:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104f27:	e8 e0 ff ff ff       	call   c0104f0c <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104f2c:	c7 04 24 b2 af 10 c0 	movl   $0xc010afb2,(%esp)
c0104f33:	e8 71 b3 ff ff       	call   c01002a9 <cprintf>
}
c0104f38:	90                   	nop
c0104f39:	c9                   	leave  
c0104f3a:	c3                   	ret    

c0104f3b <slob_allocated>:

size_t
slob_allocated(void) {
c0104f3b:	55                   	push   %ebp
c0104f3c:	89 e5                	mov    %esp,%ebp
  return 0;
c0104f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f43:	5d                   	pop    %ebp
c0104f44:	c3                   	ret    

c0104f45 <kallocated>:

size_t
kallocated(void) {
c0104f45:	55                   	push   %ebp
c0104f46:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104f48:	e8 ee ff ff ff       	call   c0104f3b <slob_allocated>
}
c0104f4d:	5d                   	pop    %ebp
c0104f4e:	c3                   	ret    

c0104f4f <find_order>:

static int find_order(int size)
{
c0104f4f:	55                   	push   %ebp
c0104f50:	89 e5                	mov    %esp,%ebp
c0104f52:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104f55:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104f5c:	eb 06                	jmp    c0104f64 <find_order+0x15>
		order++;
c0104f5e:	ff 45 fc             	incl   -0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104f61:	d1 7d 08             	sarl   0x8(%ebp)
c0104f64:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104f6b:	7f f1                	jg     c0104f5e <find_order+0xf>
	return order;
c0104f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104f70:	c9                   	leave  
c0104f71:	c3                   	ret    

c0104f72 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104f72:	55                   	push   %ebp
c0104f73:	89 e5                	mov    %esp,%ebp
c0104f75:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104f78:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104f7f:	77 3b                	ja     c0104fbc <__kmalloc+0x4a>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104f81:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f84:	8d 50 08             	lea    0x8(%eax),%edx
c0104f87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f8e:	00 
c0104f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f96:	89 14 24             	mov    %edx,(%esp)
c0104f99:	e8 7f fc ff ff       	call   c0104c1d <slob_alloc>
c0104f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104fa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104fa5:	74 0b                	je     c0104fb2 <__kmalloc+0x40>
c0104fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104faa:	83 c0 08             	add    $0x8,%eax
c0104fad:	e9 b4 00 00 00       	jmp    c0105066 <__kmalloc+0xf4>
c0104fb2:	b8 00 00 00 00       	mov    $0x0,%eax
c0104fb7:	e9 aa 00 00 00       	jmp    c0105066 <__kmalloc+0xf4>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104fbc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fc3:	00 
c0104fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fcb:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104fd2:	e8 46 fc ff ff       	call   c0104c1d <slob_alloc>
c0104fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!bb)
c0104fda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fde:	75 07                	jne    c0104fe7 <__kmalloc+0x75>
		return 0;
c0104fe0:	b8 00 00 00 00       	mov    $0x0,%eax
c0104fe5:	eb 7f                	jmp    c0105066 <__kmalloc+0xf4>

	bb->order = find_order(size);
c0104fe7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fea:	89 04 24             	mov    %eax,(%esp)
c0104fed:	e8 5d ff ff ff       	call   c0104f4f <find_order>
c0104ff2:	89 c2                	mov    %eax,%edx
c0104ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff7:	89 10                	mov    %edx,(%eax)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ffc:	8b 00                	mov    (%eax),%eax
c0104ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105002:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105005:	89 04 24             	mov    %eax,(%esp)
c0105008:	e8 a2 fb ff ff       	call   c0104baf <__slob_get_free_pages>
c010500d:	89 c2                	mov    %eax,%edx
c010500f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105012:	89 50 04             	mov    %edx,0x4(%eax)

	if (bb->pages) {
c0105015:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105018:	8b 40 04             	mov    0x4(%eax),%eax
c010501b:	85 c0                	test   %eax,%eax
c010501d:	74 2f                	je     c010504e <__kmalloc+0xdc>
		spin_lock_irqsave(&block_lock, flags);
c010501f:	e8 41 fa ff ff       	call   c0104a65 <__intr_save>
c0105024:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bb->next = bigblocks;
c0105027:	8b 15 74 8f 12 c0    	mov    0xc0128f74,%edx
c010502d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105030:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0105033:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105036:	a3 74 8f 12 c0       	mov    %eax,0xc0128f74
		spin_unlock_irqrestore(&block_lock, flags);
c010503b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010503e:	89 04 24             	mov    %eax,(%esp)
c0105041:	e8 49 fa ff ff       	call   c0104a8f <__intr_restore>
		return bb->pages;
c0105046:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105049:	8b 40 04             	mov    0x4(%eax),%eax
c010504c:	eb 18                	jmp    c0105066 <__kmalloc+0xf4>
	}

	slob_free(bb, sizeof(bigblock_t));
c010504e:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0105055:	00 
c0105056:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105059:	89 04 24             	mov    %eax,(%esp)
c010505c:	e8 91 fd ff ff       	call   c0104df2 <slob_free>
	return 0;
c0105061:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105066:	c9                   	leave  
c0105067:	c3                   	ret    

c0105068 <kmalloc>:

void *
kmalloc(size_t size)
{
c0105068:	55                   	push   %ebp
c0105069:	89 e5                	mov    %esp,%ebp
c010506b:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c010506e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105075:	00 
c0105076:	8b 45 08             	mov    0x8(%ebp),%eax
c0105079:	89 04 24             	mov    %eax,(%esp)
c010507c:	e8 f1 fe ff ff       	call   c0104f72 <__kmalloc>
}
c0105081:	c9                   	leave  
c0105082:	c3                   	ret    

c0105083 <kfree>:


void kfree(void *block)
{
c0105083:	55                   	push   %ebp
c0105084:	89 e5                	mov    %esp,%ebp
c0105086:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0105089:	c7 45 f0 74 8f 12 c0 	movl   $0xc0128f74,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0105090:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105094:	0f 84 a4 00 00 00    	je     c010513e <kfree+0xbb>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c010509a:	8b 45 08             	mov    0x8(%ebp),%eax
c010509d:	25 ff 0f 00 00       	and    $0xfff,%eax
c01050a2:	85 c0                	test   %eax,%eax
c01050a4:	75 7f                	jne    c0105125 <kfree+0xa2>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c01050a6:	e8 ba f9 ff ff       	call   c0104a65 <__intr_save>
c01050ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01050ae:	a1 74 8f 12 c0       	mov    0xc0128f74,%eax
c01050b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050b6:	eb 5c                	jmp    c0105114 <kfree+0x91>
			if (bb->pages == block) {
c01050b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050bb:	8b 40 04             	mov    0x4(%eax),%eax
c01050be:	39 45 08             	cmp    %eax,0x8(%ebp)
c01050c1:	75 3f                	jne    c0105102 <kfree+0x7f>
				*last = bb->next;
c01050c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050c6:	8b 50 08             	mov    0x8(%eax),%edx
c01050c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050cc:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c01050ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050d1:	89 04 24             	mov    %eax,(%esp)
c01050d4:	e8 b6 f9 ff ff       	call   c0104a8f <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c01050d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050dc:	8b 10                	mov    (%eax),%edx
c01050de:	8b 45 08             	mov    0x8(%ebp),%eax
c01050e1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050e5:	89 04 24             	mov    %eax,(%esp)
c01050e8:	e8 fb fa ff ff       	call   c0104be8 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c01050ed:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c01050f4:	00 
c01050f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f8:	89 04 24             	mov    %eax,(%esp)
c01050fb:	e8 f2 fc ff ff       	call   c0104df2 <slob_free>
				return;
c0105100:	eb 3d                	jmp    c010513f <kfree+0xbc>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0105102:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105105:	83 c0 08             	add    $0x8,%eax
c0105108:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010510b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010510e:	8b 40 08             	mov    0x8(%eax),%eax
c0105111:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105114:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105118:	75 9e                	jne    c01050b8 <kfree+0x35>
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c010511a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010511d:	89 04 24             	mov    %eax,(%esp)
c0105120:	e8 6a f9 ff ff       	call   c0104a8f <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0105125:	8b 45 08             	mov    0x8(%ebp),%eax
c0105128:	83 e8 08             	sub    $0x8,%eax
c010512b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105132:	00 
c0105133:	89 04 24             	mov    %eax,(%esp)
c0105136:	e8 b7 fc ff ff       	call   c0104df2 <slob_free>
	return;
c010513b:	90                   	nop
c010513c:	eb 01                	jmp    c010513f <kfree+0xbc>
		return;
c010513e:	90                   	nop
}
c010513f:	c9                   	leave  
c0105140:	c3                   	ret    

c0105141 <ksize>:


unsigned int ksize(const void *block)
{
c0105141:	55                   	push   %ebp
c0105142:	89 e5                	mov    %esp,%ebp
c0105144:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0105147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010514b:	75 07                	jne    c0105154 <ksize+0x13>
		return 0;
c010514d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105152:	eb 6b                	jmp    c01051bf <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0105154:	8b 45 08             	mov    0x8(%ebp),%eax
c0105157:	25 ff 0f 00 00       	and    $0xfff,%eax
c010515c:	85 c0                	test   %eax,%eax
c010515e:	75 54                	jne    c01051b4 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0105160:	e8 00 f9 ff ff       	call   c0104a65 <__intr_save>
c0105165:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0105168:	a1 74 8f 12 c0       	mov    0xc0128f74,%eax
c010516d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105170:	eb 31                	jmp    c01051a3 <ksize+0x62>
			if (bb->pages == block) {
c0105172:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105175:	8b 40 04             	mov    0x4(%eax),%eax
c0105178:	39 45 08             	cmp    %eax,0x8(%ebp)
c010517b:	75 1d                	jne    c010519a <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c010517d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105180:	89 04 24             	mov    %eax,(%esp)
c0105183:	e8 07 f9 ff ff       	call   c0104a8f <__intr_restore>
				return PAGE_SIZE << bb->order;
c0105188:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010518b:	8b 00                	mov    (%eax),%eax
c010518d:	ba 00 10 00 00       	mov    $0x1000,%edx
c0105192:	88 c1                	mov    %al,%cl
c0105194:	d3 e2                	shl    %cl,%edx
c0105196:	89 d0                	mov    %edx,%eax
c0105198:	eb 25                	jmp    c01051bf <ksize+0x7e>
		for (bb = bigblocks; bb; bb = bb->next)
c010519a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010519d:	8b 40 08             	mov    0x8(%eax),%eax
c01051a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01051a7:	75 c9                	jne    c0105172 <ksize+0x31>
			}
		spin_unlock_irqrestore(&block_lock, flags);
c01051a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051ac:	89 04 24             	mov    %eax,(%esp)
c01051af:	e8 db f8 ff ff       	call   c0104a8f <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c01051b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b7:	83 e8 08             	sub    $0x8,%eax
c01051ba:	8b 00                	mov    (%eax),%eax
c01051bc:	c1 e0 03             	shl    $0x3,%eax
}
c01051bf:	c9                   	leave  
c01051c0:	c3                   	ret    

c01051c1 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01051c1:	55                   	push   %ebp
c01051c2:	89 e5                	mov    %esp,%ebp
c01051c4:	83 ec 10             	sub    $0x10,%esp
c01051c7:	c7 45 fc 24 b1 12 c0 	movl   $0xc012b124,-0x4(%ebp)
    elm->prev = elm->next = elm;
c01051ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01051d4:	89 50 04             	mov    %edx,0x4(%eax)
c01051d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051da:	8b 50 04             	mov    0x4(%eax),%edx
c01051dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051e0:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01051e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e5:	c7 40 14 24 b1 12 c0 	movl   $0xc012b124,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01051ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01051f1:	c9                   	leave  
c01051f2:	c3                   	ret    

c01051f3 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01051f3:	55                   	push   %ebp
c01051f4:	89 e5                	mov    %esp,%ebp
c01051f6:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01051f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fc:	8b 40 14             	mov    0x14(%eax),%eax
c01051ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0105202:	8b 45 10             	mov    0x10(%ebp),%eax
c0105205:	83 c0 14             	add    $0x14,%eax
c0105208:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c010520b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010520f:	74 06                	je     c0105217 <_fifo_map_swappable+0x24>
c0105211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105215:	75 24                	jne    c010523b <_fifo_map_swappable+0x48>
c0105217:	c7 44 24 0c d0 af 10 	movl   $0xc010afd0,0xc(%esp)
c010521e:	c0 
c010521f:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105226:	c0 
c0105227:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010522e:	00 
c010522f:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105236:	e8 c5 b1 ff ff       	call   c0100400 <__panic>
c010523b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010523e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105241:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105244:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105247:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010524a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010524d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105250:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c0105253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105256:	8b 40 04             	mov    0x4(%eax),%eax
c0105259:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010525c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010525f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105262:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0105265:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0105268:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010526b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010526e:	89 10                	mov    %edx,(%eax)
c0105270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105273:	8b 10                	mov    (%eax),%edx
c0105275:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105278:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010527b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010527e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105281:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105284:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105287:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010528a:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head, entry);
    return 0;
c010528c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105291:	c9                   	leave  
c0105292:	c3                   	ret    

c0105293 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0105293:	55                   	push   %ebp
c0105294:	89 e5                	mov    %esp,%ebp
c0105296:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0105299:	8b 45 08             	mov    0x8(%ebp),%eax
c010529c:	8b 40 14             	mov    0x14(%eax),%eax
c010529f:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01052a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01052a6:	75 24                	jne    c01052cc <_fifo_swap_out_victim+0x39>
c01052a8:	c7 44 24 0c 17 b0 10 	movl   $0xc010b017,0xc(%esp)
c01052af:	c0 
c01052b0:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c01052b7:	c0 
c01052b8:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c01052bf:	00 
c01052c0:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01052c7:	e8 34 b1 ff ff       	call   c0100400 <__panic>
     assert(in_tick==0);
c01052cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052d0:	74 24                	je     c01052f6 <_fifo_swap_out_victim+0x63>
c01052d2:	c7 44 24 0c 24 b0 10 	movl   $0xc010b024,0xc(%esp)
c01052d9:	c0 
c01052da:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c01052e1:	c0 
c01052e2:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01052e9:	00 
c01052ea:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01052f1:	e8 0a b1 ff ff       	call   c0100400 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     /* Select the tail */
     list_entry_t *le = head->prev;
c01052f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052f9:	8b 00                	mov    (%eax),%eax
c01052fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c01052fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105301:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105304:	75 24                	jne    c010532a <_fifo_swap_out_victim+0x97>
c0105306:	c7 44 24 0c 2f b0 10 	movl   $0xc010b02f,0xc(%esp)
c010530d:	c0 
c010530e:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105315:	c0 
c0105316:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010531d:	00 
c010531e:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105325:	e8 d6 b0 ff ff       	call   c0100400 <__panic>
     struct Page *p = le2page(le, pra_page_link);
c010532a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010532d:	83 e8 14             	sub    $0x14,%eax
c0105330:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105333:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105336:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105339:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010533c:	8b 40 04             	mov    0x4(%eax),%eax
c010533f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105342:	8b 12                	mov    (%edx),%edx
c0105344:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105347:	89 45 e0             	mov    %eax,-0x20(%ebp)
    prev->next = next;
c010534a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010534d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105350:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105353:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105356:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105359:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c010535b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010535f:	75 24                	jne    c0105385 <_fifo_swap_out_victim+0xf2>
c0105361:	c7 44 24 0c 38 b0 10 	movl   $0xc010b038,0xc(%esp)
c0105368:	c0 
c0105369:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105370:	c0 
c0105371:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
c0105378:	00 
c0105379:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105380:	e8 7b b0 ff ff       	call   c0100400 <__panic>
     *ptr_page = p;
c0105385:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105388:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010538b:	89 10                	mov    %edx,(%eax)
     return 0;
c010538d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105392:	c9                   	leave  
c0105393:	c3                   	ret    

c0105394 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0105394:	55                   	push   %ebp
c0105395:	89 e5                	mov    %esp,%ebp
c0105397:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c010539a:	c7 04 24 44 b0 10 c0 	movl   $0xc010b044,(%esp)
c01053a1:	e8 03 af ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01053a6:	b8 00 30 00 00       	mov    $0x3000,%eax
c01053ab:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01053ae:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01053b3:	83 f8 04             	cmp    $0x4,%eax
c01053b6:	74 24                	je     c01053dc <_fifo_check_swap+0x48>
c01053b8:	c7 44 24 0c 6a b0 10 	movl   $0xc010b06a,0xc(%esp)
c01053bf:	c0 
c01053c0:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c01053c7:	c0 
c01053c8:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01053cf:	00 
c01053d0:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01053d7:	e8 24 b0 ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01053dc:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01053e3:	e8 c1 ae ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01053e8:	b8 00 10 00 00       	mov    $0x1000,%eax
c01053ed:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01053f0:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01053f5:	83 f8 04             	cmp    $0x4,%eax
c01053f8:	74 24                	je     c010541e <_fifo_check_swap+0x8a>
c01053fa:	c7 44 24 0c 6a b0 10 	movl   $0xc010b06a,0xc(%esp)
c0105401:	c0 
c0105402:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105409:	c0 
c010540a:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0105411:	00 
c0105412:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105419:	e8 e2 af ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010541e:	c7 04 24 a4 b0 10 c0 	movl   $0xc010b0a4,(%esp)
c0105425:	e8 7f ae ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010542a:	b8 00 40 00 00       	mov    $0x4000,%eax
c010542f:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0105432:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105437:	83 f8 04             	cmp    $0x4,%eax
c010543a:	74 24                	je     c0105460 <_fifo_check_swap+0xcc>
c010543c:	c7 44 24 0c 6a b0 10 	movl   $0xc010b06a,0xc(%esp)
c0105443:	c0 
c0105444:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c010544b:	c0 
c010544c:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0105453:	00 
c0105454:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c010545b:	e8 a0 af ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105460:	c7 04 24 cc b0 10 c0 	movl   $0xc010b0cc,(%esp)
c0105467:	e8 3d ae ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010546c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105471:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0105474:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105479:	83 f8 04             	cmp    $0x4,%eax
c010547c:	74 24                	je     c01054a2 <_fifo_check_swap+0x10e>
c010547e:	c7 44 24 0c 6a b0 10 	movl   $0xc010b06a,0xc(%esp)
c0105485:	c0 
c0105486:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c010548d:	c0 
c010548e:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0105495:	00 
c0105496:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c010549d:	e8 5e af ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01054a2:	c7 04 24 f4 b0 10 c0 	movl   $0xc010b0f4,(%esp)
c01054a9:	e8 fb ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01054ae:	b8 00 50 00 00       	mov    $0x5000,%eax
c01054b3:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01054b6:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01054bb:	83 f8 05             	cmp    $0x5,%eax
c01054be:	74 24                	je     c01054e4 <_fifo_check_swap+0x150>
c01054c0:	c7 44 24 0c 1a b1 10 	movl   $0xc010b11a,0xc(%esp)
c01054c7:	c0 
c01054c8:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c01054cf:	c0 
c01054d0:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01054d7:	00 
c01054d8:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01054df:	e8 1c af ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01054e4:	c7 04 24 cc b0 10 c0 	movl   $0xc010b0cc,(%esp)
c01054eb:	e8 b9 ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01054f0:	b8 00 20 00 00       	mov    $0x2000,%eax
c01054f5:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01054f8:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01054fd:	83 f8 05             	cmp    $0x5,%eax
c0105500:	74 24                	je     c0105526 <_fifo_check_swap+0x192>
c0105502:	c7 44 24 0c 1a b1 10 	movl   $0xc010b11a,0xc(%esp)
c0105509:	c0 
c010550a:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105511:	c0 
c0105512:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0105519:	00 
c010551a:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105521:	e8 da ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105526:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c010552d:	e8 77 ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105532:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105537:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c010553a:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c010553f:	83 f8 06             	cmp    $0x6,%eax
c0105542:	74 24                	je     c0105568 <_fifo_check_swap+0x1d4>
c0105544:	c7 44 24 0c 29 b1 10 	movl   $0xc010b129,0xc(%esp)
c010554b:	c0 
c010554c:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105553:	c0 
c0105554:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010555b:	00 
c010555c:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105563:	e8 98 ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105568:	c7 04 24 cc b0 10 c0 	movl   $0xc010b0cc,(%esp)
c010556f:	e8 35 ad ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105574:	b8 00 20 00 00       	mov    $0x2000,%eax
c0105579:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c010557c:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105581:	83 f8 07             	cmp    $0x7,%eax
c0105584:	74 24                	je     c01055aa <_fifo_check_swap+0x216>
c0105586:	c7 44 24 0c 38 b1 10 	movl   $0xc010b138,0xc(%esp)
c010558d:	c0 
c010558e:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105595:	c0 
c0105596:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010559d:	00 
c010559e:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01055a5:	e8 56 ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01055aa:	c7 04 24 44 b0 10 c0 	movl   $0xc010b044,(%esp)
c01055b1:	e8 f3 ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01055b6:	b8 00 30 00 00       	mov    $0x3000,%eax
c01055bb:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c01055be:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01055c3:	83 f8 08             	cmp    $0x8,%eax
c01055c6:	74 24                	je     c01055ec <_fifo_check_swap+0x258>
c01055c8:	c7 44 24 0c 47 b1 10 	movl   $0xc010b147,0xc(%esp)
c01055cf:	c0 
c01055d0:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c01055d7:	c0 
c01055d8:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01055df:	00 
c01055e0:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01055e7:	e8 14 ae ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01055ec:	c7 04 24 a4 b0 10 c0 	movl   $0xc010b0a4,(%esp)
c01055f3:	e8 b1 ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01055f8:	b8 00 40 00 00       	mov    $0x4000,%eax
c01055fd:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0105600:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105605:	83 f8 09             	cmp    $0x9,%eax
c0105608:	74 24                	je     c010562e <_fifo_check_swap+0x29a>
c010560a:	c7 44 24 0c 56 b1 10 	movl   $0xc010b156,0xc(%esp)
c0105611:	c0 
c0105612:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105619:	c0 
c010561a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0105621:	00 
c0105622:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c0105629:	e8 d2 ad ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010562e:	c7 04 24 f4 b0 10 c0 	movl   $0xc010b0f4,(%esp)
c0105635:	e8 6f ac ff ff       	call   c01002a9 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010563a:	b8 00 50 00 00       	mov    $0x5000,%eax
c010563f:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0105642:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c0105647:	83 f8 0a             	cmp    $0xa,%eax
c010564a:	74 24                	je     c0105670 <_fifo_check_swap+0x2dc>
c010564c:	c7 44 24 0c 65 b1 10 	movl   $0xc010b165,0xc(%esp)
c0105653:	c0 
c0105654:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c010565b:	c0 
c010565c:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
c0105663:	00 
c0105664:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c010566b:	e8 90 ad ff ff       	call   c0100400 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105670:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0105677:	e8 2d ac ff ff       	call   c01002a9 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c010567c:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105681:	0f b6 00             	movzbl (%eax),%eax
c0105684:	3c 0a                	cmp    $0xa,%al
c0105686:	74 24                	je     c01056ac <_fifo_check_swap+0x318>
c0105688:	c7 44 24 0c 78 b1 10 	movl   $0xc010b178,0xc(%esp)
c010568f:	c0 
c0105690:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c0105697:	c0 
c0105698:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
c010569f:	00 
c01056a0:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01056a7:	e8 54 ad ff ff       	call   c0100400 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c01056ac:	b8 00 10 00 00       	mov    $0x1000,%eax
c01056b1:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c01056b4:	a1 64 8f 12 c0       	mov    0xc0128f64,%eax
c01056b9:	83 f8 0b             	cmp    $0xb,%eax
c01056bc:	74 24                	je     c01056e2 <_fifo_check_swap+0x34e>
c01056be:	c7 44 24 0c 99 b1 10 	movl   $0xc010b199,0xc(%esp)
c01056c5:	c0 
c01056c6:	c7 44 24 08 ee af 10 	movl   $0xc010afee,0x8(%esp)
c01056cd:	c0 
c01056ce:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c01056d5:	00 
c01056d6:	c7 04 24 03 b0 10 c0 	movl   $0xc010b003,(%esp)
c01056dd:	e8 1e ad ff ff       	call   c0100400 <__panic>
    return 0;
c01056e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056e7:	c9                   	leave  
c01056e8:	c3                   	ret    

c01056e9 <_fifo_init>:


static int
_fifo_init(void)
{
c01056e9:	55                   	push   %ebp
c01056ea:	89 e5                	mov    %esp,%ebp
    return 0;
c01056ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056f1:	5d                   	pop    %ebp
c01056f2:	c3                   	ret    

c01056f3 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01056f3:	55                   	push   %ebp
c01056f4:	89 e5                	mov    %esp,%ebp
    return 0;
c01056f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056fb:	5d                   	pop    %ebp
c01056fc:	c3                   	ret    

c01056fd <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c01056fd:	55                   	push   %ebp
c01056fe:	89 e5                	mov    %esp,%ebp
c0105700:	b8 00 00 00 00       	mov    $0x0,%eax
c0105705:	5d                   	pop    %ebp
c0105706:	c3                   	ret    

c0105707 <page2ppn>:
page2ppn(struct Page *page) {
c0105707:	55                   	push   %ebp
c0105708:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010570a:	8b 45 08             	mov    0x8(%ebp),%eax
c010570d:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c0105713:	29 d0                	sub    %edx,%eax
c0105715:	c1 f8 05             	sar    $0x5,%eax
}
c0105718:	5d                   	pop    %ebp
c0105719:	c3                   	ret    

c010571a <page2pa>:
page2pa(struct Page *page) {
c010571a:	55                   	push   %ebp
c010571b:	89 e5                	mov    %esp,%ebp
c010571d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105720:	8b 45 08             	mov    0x8(%ebp),%eax
c0105723:	89 04 24             	mov    %eax,(%esp)
c0105726:	e8 dc ff ff ff       	call   c0105707 <page2ppn>
c010572b:	c1 e0 0c             	shl    $0xc,%eax
}
c010572e:	c9                   	leave  
c010572f:	c3                   	ret    

c0105730 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0105730:	55                   	push   %ebp
c0105731:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105733:	8b 45 08             	mov    0x8(%ebp),%eax
c0105736:	8b 00                	mov    (%eax),%eax
}
c0105738:	5d                   	pop    %ebp
c0105739:	c3                   	ret    

c010573a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010573a:	55                   	push   %ebp
c010573b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010573d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105740:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105743:	89 10                	mov    %edx,(%eax)
}
c0105745:	90                   	nop
c0105746:	5d                   	pop    %ebp
c0105747:	c3                   	ret    

c0105748 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0105748:	55                   	push   %ebp
c0105749:	89 e5                	mov    %esp,%ebp
c010574b:	83 ec 10             	sub    $0x10,%esp
c010574e:	c7 45 fc 2c b1 12 c0 	movl   $0xc012b12c,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0105755:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105758:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010575b:	89 50 04             	mov    %edx,0x4(%eax)
c010575e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105761:	8b 50 04             	mov    0x4(%eax),%edx
c0105764:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105767:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0105769:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c0105770:	00 00 00 
}
c0105773:	90                   	nop
c0105774:	c9                   	leave  
c0105775:	c3                   	ret    

c0105776 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0105776:	55                   	push   %ebp
c0105777:	89 e5                	mov    %esp,%ebp
c0105779:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010577c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105780:	75 24                	jne    c01057a6 <default_init_memmap+0x30>
c0105782:	c7 44 24 0c bc b1 10 	movl   $0xc010b1bc,0xc(%esp)
c0105789:	c0 
c010578a:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105791:	c0 
c0105792:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105799:	00 
c010579a:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01057a1:	e8 5a ac ff ff       	call   c0100400 <__panic>
    struct Page *p = base;
c01057a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01057ac:	eb 7d                	jmp    c010582b <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01057ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057b1:	83 c0 04             	add    $0x4,%eax
c01057b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01057bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01057be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01057c4:	0f a3 10             	bt     %edx,(%eax)
c01057c7:	19 c0                	sbb    %eax,%eax
c01057c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01057cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057d0:	0f 95 c0             	setne  %al
c01057d3:	0f b6 c0             	movzbl %al,%eax
c01057d6:	85 c0                	test   %eax,%eax
c01057d8:	75 24                	jne    c01057fe <default_init_memmap+0x88>
c01057da:	c7 44 24 0c ed b1 10 	movl   $0xc010b1ed,0xc(%esp)
c01057e1:	c0 
c01057e2:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01057e9:	c0 
c01057ea:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01057f1:	00 
c01057f2:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01057f9:	e8 02 ac ff ff       	call   c0100400 <__panic>
        p->flags = p->property = 0;
c01057fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105801:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0105808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010580b:	8b 50 08             	mov    0x8(%eax),%edx
c010580e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105811:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105814:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010581b:	00 
c010581c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010581f:	89 04 24             	mov    %eax,(%esp)
c0105822:	e8 13 ff ff ff       	call   c010573a <set_page_ref>
    for (; p != base + n; p ++) {
c0105827:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010582b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582e:	c1 e0 05             	shl    $0x5,%eax
c0105831:	89 c2                	mov    %eax,%edx
c0105833:	8b 45 08             	mov    0x8(%ebp),%eax
c0105836:	01 d0                	add    %edx,%eax
c0105838:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010583b:	0f 85 6d ff ff ff    	jne    c01057ae <default_init_memmap+0x38>
    }
    base->property = n;
c0105841:	8b 45 08             	mov    0x8(%ebp),%eax
c0105844:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105847:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010584a:	8b 45 08             	mov    0x8(%ebp),%eax
c010584d:	83 c0 04             	add    $0x4,%eax
c0105850:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105857:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010585a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010585d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105860:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0105863:	8b 15 34 b1 12 c0    	mov    0xc012b134,%edx
c0105869:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586c:	01 d0                	add    %edx,%eax
c010586e:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
    list_add_before(&free_list, &(base->page_link));
c0105873:	8b 45 08             	mov    0x8(%ebp),%eax
c0105876:	83 c0 0c             	add    $0xc,%eax
c0105879:	c7 45 e4 2c b1 12 c0 	movl   $0xc012b12c,-0x1c(%ebp)
c0105880:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105886:	8b 00                	mov    (%eax),%eax
c0105888:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010588b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010588e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0105891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105894:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0105897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010589a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010589d:	89 10                	mov    %edx,(%eax)
c010589f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01058a2:	8b 10                	mov    (%eax),%edx
c01058a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01058a7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01058aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058b0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01058b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01058b9:	89 10                	mov    %edx,(%eax)
}
c01058bb:	90                   	nop
c01058bc:	c9                   	leave  
c01058bd:	c3                   	ret    

c01058be <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01058be:	55                   	push   %ebp
c01058bf:	89 e5                	mov    %esp,%ebp
c01058c1:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01058c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01058c8:	75 24                	jne    c01058ee <default_alloc_pages+0x30>
c01058ca:	c7 44 24 0c bc b1 10 	movl   $0xc010b1bc,0xc(%esp)
c01058d1:	c0 
c01058d2:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01058d9:	c0 
c01058da:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01058e1:	00 
c01058e2:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01058e9:	e8 12 ab ff ff       	call   c0100400 <__panic>
    if (n > nr_free) {
c01058ee:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c01058f3:	39 45 08             	cmp    %eax,0x8(%ebp)
c01058f6:	76 0a                	jbe    c0105902 <default_alloc_pages+0x44>
        return NULL;
c01058f8:	b8 00 00 00 00       	mov    $0x0,%eax
c01058fd:	e9 36 01 00 00       	jmp    c0105a38 <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c0105902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0105909:	c7 45 f0 2c b1 12 c0 	movl   $0xc012b12c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0105910:	eb 1c                	jmp    c010592e <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0105912:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105915:	83 e8 0c             	sub    $0xc,%eax
c0105918:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010591b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010591e:	8b 40 08             	mov    0x8(%eax),%eax
c0105921:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105924:	77 08                	ja     c010592e <default_alloc_pages+0x70>
            page = p;
c0105926:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105929:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010592c:	eb 18                	jmp    c0105946 <default_alloc_pages+0x88>
c010592e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0105934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105937:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010593a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010593d:	81 7d f0 2c b1 12 c0 	cmpl   $0xc012b12c,-0x10(%ebp)
c0105944:	75 cc                	jne    c0105912 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0105946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010594a:	0f 84 e5 00 00 00    	je     c0105a35 <default_alloc_pages+0x177>
        if (page->property > n) {
c0105950:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105953:	8b 40 08             	mov    0x8(%eax),%eax
c0105956:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105959:	0f 83 85 00 00 00    	jae    c01059e4 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c010595f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105962:	c1 e0 05             	shl    $0x5,%eax
c0105965:	89 c2                	mov    %eax,%edx
c0105967:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010596a:	01 d0                	add    %edx,%eax
c010596c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010596f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105972:	8b 40 08             	mov    0x8(%eax),%eax
c0105975:	2b 45 08             	sub    0x8(%ebp),%eax
c0105978:	89 c2                	mov    %eax,%edx
c010597a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010597d:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0105980:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105983:	83 c0 04             	add    $0x4,%eax
c0105986:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010598d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105990:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105993:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105996:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0105999:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010599c:	83 c0 0c             	add    $0xc,%eax
c010599f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a2:	83 c2 0c             	add    $0xc,%edx
c01059a5:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01059a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c01059ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059ae:	8b 40 04             	mov    0x4(%eax),%eax
c01059b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01059b4:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01059b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01059ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01059bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c01059c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01059c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01059c6:	89 10                	mov    %edx,(%eax)
c01059c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01059cb:	8b 10                	mov    (%eax),%edx
c01059cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01059d0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01059d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059d6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01059d9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01059dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01059df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01059e2:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c01059e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059e7:	83 c0 0c             	add    $0xc,%eax
c01059ea:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01059ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01059f0:	8b 40 04             	mov    0x4(%eax),%eax
c01059f3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01059f6:	8b 12                	mov    (%edx),%edx
c01059f8:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01059fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c01059fe:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105a01:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105a04:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105a07:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105a0a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105a0d:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0105a0f:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0105a14:	2b 45 08             	sub    0x8(%ebp),%eax
c0105a17:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
        ClearPageProperty(page);
c0105a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a1f:	83 c0 04             	add    $0x4,%eax
c0105a22:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105a29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105a2c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a2f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105a32:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0105a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a38:	c9                   	leave  
c0105a39:	c3                   	ret    

c0105a3a <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105a3a:	55                   	push   %ebp
c0105a3b:	89 e5                	mov    %esp,%ebp
c0105a3d:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0105a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a47:	75 24                	jne    c0105a6d <default_free_pages+0x33>
c0105a49:	c7 44 24 0c bc b1 10 	movl   $0xc010b1bc,0xc(%esp)
c0105a50:	c0 
c0105a51:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105a58:	c0 
c0105a59:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0105a60:	00 
c0105a61:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105a68:	e8 93 a9 ff ff       	call   c0100400 <__panic>
    struct Page *p = base;
c0105a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105a73:	e9 9d 00 00 00       	jmp    c0105b15 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0105a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a7b:	83 c0 04             	add    $0x4,%eax
c0105a7e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105a85:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a8e:	0f a3 10             	bt     %edx,(%eax)
c0105a91:	19 c0                	sbb    %eax,%eax
c0105a93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0105a96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a9a:	0f 95 c0             	setne  %al
c0105a9d:	0f b6 c0             	movzbl %al,%eax
c0105aa0:	85 c0                	test   %eax,%eax
c0105aa2:	75 2c                	jne    c0105ad0 <default_free_pages+0x96>
c0105aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105aa7:	83 c0 04             	add    $0x4,%eax
c0105aaa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105ab1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105ab4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ab7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105aba:	0f a3 10             	bt     %edx,(%eax)
c0105abd:	19 c0                	sbb    %eax,%eax
c0105abf:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0105ac2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105ac6:	0f 95 c0             	setne  %al
c0105ac9:	0f b6 c0             	movzbl %al,%eax
c0105acc:	85 c0                	test   %eax,%eax
c0105ace:	74 24                	je     c0105af4 <default_free_pages+0xba>
c0105ad0:	c7 44 24 0c 00 b2 10 	movl   $0xc010b200,0xc(%esp)
c0105ad7:	c0 
c0105ad8:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105adf:	c0 
c0105ae0:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0105ae7:	00 
c0105ae8:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105aef:	e8 0c a9 ff ff       	call   c0100400 <__panic>
        p->flags = 0;
c0105af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0105afe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b05:	00 
c0105b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b09:	89 04 24             	mov    %eax,(%esp)
c0105b0c:	e8 29 fc ff ff       	call   c010573a <set_page_ref>
    for (; p != base + n; p ++) {
c0105b11:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105b15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b18:	c1 e0 05             	shl    $0x5,%eax
c0105b1b:	89 c2                	mov    %eax,%edx
c0105b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b20:	01 d0                	add    %edx,%eax
c0105b22:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105b25:	0f 85 4d ff ff ff    	jne    c0105a78 <default_free_pages+0x3e>
    }
    base->property = n;
c0105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b31:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b37:	83 c0 04             	add    $0x4,%eax
c0105b3a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0105b41:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105b44:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105b47:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105b4a:	0f ab 10             	bts    %edx,(%eax)
c0105b4d:	c7 45 d4 2c b1 12 c0 	movl   $0xc012b12c,-0x2c(%ebp)
    return listelm->next;
c0105b54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105b57:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0105b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105b5d:	e9 fa 00 00 00       	jmp    c0105c5c <default_free_pages+0x222>
        p = le2page(le, page_link);
c0105b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b65:	83 e8 0c             	sub    $0xc,%eax
c0105b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105b71:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105b74:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0105b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7d:	8b 40 08             	mov    0x8(%eax),%eax
c0105b80:	c1 e0 05             	shl    $0x5,%eax
c0105b83:	89 c2                	mov    %eax,%edx
c0105b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b88:	01 d0                	add    %edx,%eax
c0105b8a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105b8d:	75 5a                	jne    c0105be9 <default_free_pages+0x1af>
            base->property += p->property;
c0105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b92:	8b 50 08             	mov    0x8(%eax),%edx
c0105b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b98:	8b 40 08             	mov    0x8(%eax),%eax
c0105b9b:	01 c2                	add    %eax,%edx
c0105b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba0:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0105ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ba6:	83 c0 04             	add    $0x4,%eax
c0105ba9:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0105bb0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105bb3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105bb6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105bb9:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bbf:	83 c0 0c             	add    $0xc,%eax
c0105bc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105bc5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105bc8:	8b 40 04             	mov    0x4(%eax),%eax
c0105bcb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105bce:	8b 12                	mov    (%edx),%edx
c0105bd0:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105bd3:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0105bd6:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105bd9:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105bdc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105bdf:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105be2:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105be5:	89 10                	mov    %edx,(%eax)
c0105be7:	eb 73                	jmp    c0105c5c <default_free_pages+0x222>
        }
        else if (p + p->property == base) {
c0105be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bec:	8b 40 08             	mov    0x8(%eax),%eax
c0105bef:	c1 e0 05             	shl    $0x5,%eax
c0105bf2:	89 c2                	mov    %eax,%edx
c0105bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bf7:	01 d0                	add    %edx,%eax
c0105bf9:	39 45 08             	cmp    %eax,0x8(%ebp)
c0105bfc:	75 5e                	jne    c0105c5c <default_free_pages+0x222>
            p->property += base->property;
c0105bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c01:	8b 50 08             	mov    0x8(%eax),%edx
c0105c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c07:	8b 40 08             	mov    0x8(%eax),%eax
c0105c0a:	01 c2                	add    %eax,%edx
c0105c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c0f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0105c12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c15:	83 c0 04             	add    $0x4,%eax
c0105c18:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0105c1f:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0105c22:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105c25:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105c28:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c2e:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c34:	83 c0 0c             	add    $0xc,%eax
c0105c37:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105c3a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105c3d:	8b 40 04             	mov    0x4(%eax),%eax
c0105c40:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105c43:	8b 12                	mov    (%edx),%edx
c0105c45:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0105c48:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0105c4b:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105c4e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105c51:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c54:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105c57:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0105c5a:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0105c5c:	81 7d f0 2c b1 12 c0 	cmpl   $0xc012b12c,-0x10(%ebp)
c0105c63:	0f 85 f9 fe ff ff    	jne    c0105b62 <default_free_pages+0x128>
        }
    }
    nr_free += n;
c0105c69:	8b 15 34 b1 12 c0    	mov    0xc012b134,%edx
c0105c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c72:	01 d0                	add    %edx,%eax
c0105c74:	a3 34 b1 12 c0       	mov    %eax,0xc012b134
c0105c79:	c7 45 9c 2c b1 12 c0 	movl   $0xc012b12c,-0x64(%ebp)
    return listelm->next;
c0105c80:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105c83:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0105c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105c89:	eb 66                	jmp    c0105cf1 <default_free_pages+0x2b7>
        p = le2page(le, page_link);
c0105c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c8e:	83 e8 0c             	sub    $0xc,%eax
c0105c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0105c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c97:	8b 40 08             	mov    0x8(%eax),%eax
c0105c9a:	c1 e0 05             	shl    $0x5,%eax
c0105c9d:	89 c2                	mov    %eax,%edx
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	01 d0                	add    %edx,%eax
c0105ca4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105ca7:	72 39                	jb     c0105ce2 <default_free_pages+0x2a8>
            assert(base + base->property != p);
c0105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cac:	8b 40 08             	mov    0x8(%eax),%eax
c0105caf:	c1 e0 05             	shl    $0x5,%eax
c0105cb2:	89 c2                	mov    %eax,%edx
c0105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb7:	01 d0                	add    %edx,%eax
c0105cb9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0105cbc:	75 3e                	jne    c0105cfc <default_free_pages+0x2c2>
c0105cbe:	c7 44 24 0c 25 b2 10 	movl   $0xc010b225,0xc(%esp)
c0105cc5:	c0 
c0105cc6:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105ccd:	c0 
c0105cce:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0105cd5:	00 
c0105cd6:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105cdd:	e8 1e a7 ff ff       	call   c0100400 <__panic>
c0105ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce5:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105ce8:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105ceb:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0105cee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105cf1:	81 7d f0 2c b1 12 c0 	cmpl   $0xc012b12c,-0x10(%ebp)
c0105cf8:	75 91                	jne    c0105c8b <default_free_pages+0x251>
c0105cfa:	eb 01                	jmp    c0105cfd <default_free_pages+0x2c3>
            break;
c0105cfc:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0105cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d00:	8d 50 0c             	lea    0xc(%eax),%edx
c0105d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d06:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105d09:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105d0c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105d0f:	8b 00                	mov    (%eax),%eax
c0105d11:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105d14:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105d17:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105d1a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105d1d:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0105d20:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105d23:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105d26:	89 10                	mov    %edx,(%eax)
c0105d28:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105d2b:	8b 10                	mov    (%eax),%edx
c0105d2d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105d30:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105d33:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105d36:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105d39:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105d3c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105d3f:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105d42:	89 10                	mov    %edx,(%eax)
}
c0105d44:	90                   	nop
c0105d45:	c9                   	leave  
c0105d46:	c3                   	ret    

c0105d47 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105d47:	55                   	push   %ebp
c0105d48:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105d4a:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
}
c0105d4f:	5d                   	pop    %ebp
c0105d50:	c3                   	ret    

c0105d51 <basic_check>:

static void
basic_check(void) {
c0105d51:	55                   	push   %ebp
c0105d52:	89 e5                	mov    %esp,%ebp
c0105d54:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d67:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105d6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105d71:	e8 86 0e 00 00       	call   c0106bfc <alloc_pages>
c0105d76:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105d7d:	75 24                	jne    c0105da3 <basic_check+0x52>
c0105d7f:	c7 44 24 0c 40 b2 10 	movl   $0xc010b240,0xc(%esp)
c0105d86:	c0 
c0105d87:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105d8e:	c0 
c0105d8f:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0105d96:	00 
c0105d97:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105d9e:	e8 5d a6 ff ff       	call   c0100400 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105da3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105daa:	e8 4d 0e 00 00       	call   c0106bfc <alloc_pages>
c0105daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105db2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105db6:	75 24                	jne    c0105ddc <basic_check+0x8b>
c0105db8:	c7 44 24 0c 5c b2 10 	movl   $0xc010b25c,0xc(%esp)
c0105dbf:	c0 
c0105dc0:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105dc7:	c0 
c0105dc8:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0105dcf:	00 
c0105dd0:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105dd7:	e8 24 a6 ff ff       	call   c0100400 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105ddc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105de3:	e8 14 0e 00 00       	call   c0106bfc <alloc_pages>
c0105de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105def:	75 24                	jne    c0105e15 <basic_check+0xc4>
c0105df1:	c7 44 24 0c 78 b2 10 	movl   $0xc010b278,0xc(%esp)
c0105df8:	c0 
c0105df9:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105e00:	c0 
c0105e01:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0105e08:	00 
c0105e09:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105e10:	e8 eb a5 ff ff       	call   c0100400 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e18:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105e1b:	74 10                	je     c0105e2d <basic_check+0xdc>
c0105e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e20:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e23:	74 08                	je     c0105e2d <basic_check+0xdc>
c0105e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e2b:	75 24                	jne    c0105e51 <basic_check+0x100>
c0105e2d:	c7 44 24 0c 94 b2 10 	movl   $0xc010b294,0xc(%esp)
c0105e34:	c0 
c0105e35:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105e3c:	c0 
c0105e3d:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0105e44:	00 
c0105e45:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105e4c:	e8 af a5 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e54:	89 04 24             	mov    %eax,(%esp)
c0105e57:	e8 d4 f8 ff ff       	call   c0105730 <page_ref>
c0105e5c:	85 c0                	test   %eax,%eax
c0105e5e:	75 1e                	jne    c0105e7e <basic_check+0x12d>
c0105e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e63:	89 04 24             	mov    %eax,(%esp)
c0105e66:	e8 c5 f8 ff ff       	call   c0105730 <page_ref>
c0105e6b:	85 c0                	test   %eax,%eax
c0105e6d:	75 0f                	jne    c0105e7e <basic_check+0x12d>
c0105e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e72:	89 04 24             	mov    %eax,(%esp)
c0105e75:	e8 b6 f8 ff ff       	call   c0105730 <page_ref>
c0105e7a:	85 c0                	test   %eax,%eax
c0105e7c:	74 24                	je     c0105ea2 <basic_check+0x151>
c0105e7e:	c7 44 24 0c b8 b2 10 	movl   $0xc010b2b8,0xc(%esp)
c0105e85:	c0 
c0105e86:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105e8d:	c0 
c0105e8e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0105e95:	00 
c0105e96:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105e9d:	e8 5e a5 ff ff       	call   c0100400 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ea5:	89 04 24             	mov    %eax,(%esp)
c0105ea8:	e8 6d f8 ff ff       	call   c010571a <page2pa>
c0105ead:	8b 15 80 8f 12 c0    	mov    0xc0128f80,%edx
c0105eb3:	c1 e2 0c             	shl    $0xc,%edx
c0105eb6:	39 d0                	cmp    %edx,%eax
c0105eb8:	72 24                	jb     c0105ede <basic_check+0x18d>
c0105eba:	c7 44 24 0c f4 b2 10 	movl   $0xc010b2f4,0xc(%esp)
c0105ec1:	c0 
c0105ec2:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105ec9:	c0 
c0105eca:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0105ed1:	00 
c0105ed2:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105ed9:	e8 22 a5 ff ff       	call   c0100400 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee1:	89 04 24             	mov    %eax,(%esp)
c0105ee4:	e8 31 f8 ff ff       	call   c010571a <page2pa>
c0105ee9:	8b 15 80 8f 12 c0    	mov    0xc0128f80,%edx
c0105eef:	c1 e2 0c             	shl    $0xc,%edx
c0105ef2:	39 d0                	cmp    %edx,%eax
c0105ef4:	72 24                	jb     c0105f1a <basic_check+0x1c9>
c0105ef6:	c7 44 24 0c 11 b3 10 	movl   $0xc010b311,0xc(%esp)
c0105efd:	c0 
c0105efe:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105f05:	c0 
c0105f06:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0105f0d:	00 
c0105f0e:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105f15:	e8 e6 a4 ff ff       	call   c0100400 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f1d:	89 04 24             	mov    %eax,(%esp)
c0105f20:	e8 f5 f7 ff ff       	call   c010571a <page2pa>
c0105f25:	8b 15 80 8f 12 c0    	mov    0xc0128f80,%edx
c0105f2b:	c1 e2 0c             	shl    $0xc,%edx
c0105f2e:	39 d0                	cmp    %edx,%eax
c0105f30:	72 24                	jb     c0105f56 <basic_check+0x205>
c0105f32:	c7 44 24 0c 2e b3 10 	movl   $0xc010b32e,0xc(%esp)
c0105f39:	c0 
c0105f3a:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105f41:	c0 
c0105f42:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0105f49:	00 
c0105f4a:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105f51:	e8 aa a4 ff ff       	call   c0100400 <__panic>

    list_entry_t free_list_store = free_list;
c0105f56:	a1 2c b1 12 c0       	mov    0xc012b12c,%eax
c0105f5b:	8b 15 30 b1 12 c0    	mov    0xc012b130,%edx
c0105f61:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105f64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105f67:	c7 45 dc 2c b1 12 c0 	movl   $0xc012b12c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0105f6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105f74:	89 50 04             	mov    %edx,0x4(%eax)
c0105f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f7a:	8b 50 04             	mov    0x4(%eax),%edx
c0105f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f80:	89 10                	mov    %edx,(%eax)
c0105f82:	c7 45 e0 2c b1 12 c0 	movl   $0xc012b12c,-0x20(%ebp)
    return list->next == list;
c0105f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f8c:	8b 40 04             	mov    0x4(%eax),%eax
c0105f8f:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0105f92:	0f 94 c0             	sete   %al
c0105f95:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105f98:	85 c0                	test   %eax,%eax
c0105f9a:	75 24                	jne    c0105fc0 <basic_check+0x26f>
c0105f9c:	c7 44 24 0c 4b b3 10 	movl   $0xc010b34b,0xc(%esp)
c0105fa3:	c0 
c0105fa4:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105fab:	c0 
c0105fac:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0105fb3:	00 
c0105fb4:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0105fbb:	e8 40 a4 ff ff       	call   c0100400 <__panic>

    unsigned int nr_free_store = nr_free;
c0105fc0:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0105fc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0105fc8:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c0105fcf:	00 00 00 

    assert(alloc_page() == NULL);
c0105fd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105fd9:	e8 1e 0c 00 00       	call   c0106bfc <alloc_pages>
c0105fde:	85 c0                	test   %eax,%eax
c0105fe0:	74 24                	je     c0106006 <basic_check+0x2b5>
c0105fe2:	c7 44 24 0c 62 b3 10 	movl   $0xc010b362,0xc(%esp)
c0105fe9:	c0 
c0105fea:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0105ff1:	c0 
c0105ff2:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0105ff9:	00 
c0105ffa:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106001:	e8 fa a3 ff ff       	call   c0100400 <__panic>

    free_page(p0);
c0106006:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010600d:	00 
c010600e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106011:	89 04 24             	mov    %eax,(%esp)
c0106014:	e8 4e 0c 00 00       	call   c0106c67 <free_pages>
    free_page(p1);
c0106019:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106020:	00 
c0106021:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106024:	89 04 24             	mov    %eax,(%esp)
c0106027:	e8 3b 0c 00 00       	call   c0106c67 <free_pages>
    free_page(p2);
c010602c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106033:	00 
c0106034:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106037:	89 04 24             	mov    %eax,(%esp)
c010603a:	e8 28 0c 00 00       	call   c0106c67 <free_pages>
    assert(nr_free == 3);
c010603f:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106044:	83 f8 03             	cmp    $0x3,%eax
c0106047:	74 24                	je     c010606d <basic_check+0x31c>
c0106049:	c7 44 24 0c 77 b3 10 	movl   $0xc010b377,0xc(%esp)
c0106050:	c0 
c0106051:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106058:	c0 
c0106059:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0106060:	00 
c0106061:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106068:	e8 93 a3 ff ff       	call   c0100400 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010606d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106074:	e8 83 0b 00 00       	call   c0106bfc <alloc_pages>
c0106079:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010607c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106080:	75 24                	jne    c01060a6 <basic_check+0x355>
c0106082:	c7 44 24 0c 40 b2 10 	movl   $0xc010b240,0xc(%esp)
c0106089:	c0 
c010608a:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106091:	c0 
c0106092:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0106099:	00 
c010609a:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01060a1:	e8 5a a3 ff ff       	call   c0100400 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01060a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060ad:	e8 4a 0b 00 00       	call   c0106bfc <alloc_pages>
c01060b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01060b9:	75 24                	jne    c01060df <basic_check+0x38e>
c01060bb:	c7 44 24 0c 5c b2 10 	movl   $0xc010b25c,0xc(%esp)
c01060c2:	c0 
c01060c3:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01060ca:	c0 
c01060cb:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01060d2:	00 
c01060d3:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01060da:	e8 21 a3 ff ff       	call   c0100400 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01060df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060e6:	e8 11 0b 00 00       	call   c0106bfc <alloc_pages>
c01060eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01060ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01060f2:	75 24                	jne    c0106118 <basic_check+0x3c7>
c01060f4:	c7 44 24 0c 78 b2 10 	movl   $0xc010b278,0xc(%esp)
c01060fb:	c0 
c01060fc:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106103:	c0 
c0106104:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010610b:	00 
c010610c:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106113:	e8 e8 a2 ff ff       	call   c0100400 <__panic>

    assert(alloc_page() == NULL);
c0106118:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010611f:	e8 d8 0a 00 00       	call   c0106bfc <alloc_pages>
c0106124:	85 c0                	test   %eax,%eax
c0106126:	74 24                	je     c010614c <basic_check+0x3fb>
c0106128:	c7 44 24 0c 62 b3 10 	movl   $0xc010b362,0xc(%esp)
c010612f:	c0 
c0106130:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106137:	c0 
c0106138:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010613f:	00 
c0106140:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106147:	e8 b4 a2 ff ff       	call   c0100400 <__panic>

    free_page(p0);
c010614c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106153:	00 
c0106154:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106157:	89 04 24             	mov    %eax,(%esp)
c010615a:	e8 08 0b 00 00       	call   c0106c67 <free_pages>
c010615f:	c7 45 d8 2c b1 12 c0 	movl   $0xc012b12c,-0x28(%ebp)
c0106166:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106169:	8b 40 04             	mov    0x4(%eax),%eax
c010616c:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010616f:	0f 94 c0             	sete   %al
c0106172:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0106175:	85 c0                	test   %eax,%eax
c0106177:	74 24                	je     c010619d <basic_check+0x44c>
c0106179:	c7 44 24 0c 84 b3 10 	movl   $0xc010b384,0xc(%esp)
c0106180:	c0 
c0106181:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106188:	c0 
c0106189:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0106190:	00 
c0106191:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106198:	e8 63 a2 ff ff       	call   c0100400 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010619d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061a4:	e8 53 0a 00 00       	call   c0106bfc <alloc_pages>
c01061a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01061b2:	74 24                	je     c01061d8 <basic_check+0x487>
c01061b4:	c7 44 24 0c 9c b3 10 	movl   $0xc010b39c,0xc(%esp)
c01061bb:	c0 
c01061bc:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01061c3:	c0 
c01061c4:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01061cb:	00 
c01061cc:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01061d3:	e8 28 a2 ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c01061d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061df:	e8 18 0a 00 00       	call   c0106bfc <alloc_pages>
c01061e4:	85 c0                	test   %eax,%eax
c01061e6:	74 24                	je     c010620c <basic_check+0x4bb>
c01061e8:	c7 44 24 0c 62 b3 10 	movl   $0xc010b362,0xc(%esp)
c01061ef:	c0 
c01061f0:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01061f7:	c0 
c01061f8:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01061ff:	00 
c0106200:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106207:	e8 f4 a1 ff ff       	call   c0100400 <__panic>

    assert(nr_free == 0);
c010620c:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106211:	85 c0                	test   %eax,%eax
c0106213:	74 24                	je     c0106239 <basic_check+0x4e8>
c0106215:	c7 44 24 0c b5 b3 10 	movl   $0xc010b3b5,0xc(%esp)
c010621c:	c0 
c010621d:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106224:	c0 
c0106225:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010622c:	00 
c010622d:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106234:	e8 c7 a1 ff ff       	call   c0100400 <__panic>
    free_list = free_list_store;
c0106239:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010623c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010623f:	a3 2c b1 12 c0       	mov    %eax,0xc012b12c
c0106244:	89 15 30 b1 12 c0    	mov    %edx,0xc012b130
    nr_free = nr_free_store;
c010624a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010624d:	a3 34 b1 12 c0       	mov    %eax,0xc012b134

    free_page(p);
c0106252:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106259:	00 
c010625a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010625d:	89 04 24             	mov    %eax,(%esp)
c0106260:	e8 02 0a 00 00       	call   c0106c67 <free_pages>
    free_page(p1);
c0106265:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010626c:	00 
c010626d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106270:	89 04 24             	mov    %eax,(%esp)
c0106273:	e8 ef 09 00 00       	call   c0106c67 <free_pages>
    free_page(p2);
c0106278:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010627f:	00 
c0106280:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106283:	89 04 24             	mov    %eax,(%esp)
c0106286:	e8 dc 09 00 00       	call   c0106c67 <free_pages>
}
c010628b:	90                   	nop
c010628c:	c9                   	leave  
c010628d:	c3                   	ret    

c010628e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010628e:	55                   	push   %ebp
c010628f:	89 e5                	mov    %esp,%ebp
c0106291:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0106297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010629e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01062a5:	c7 45 ec 2c b1 12 c0 	movl   $0xc012b12c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01062ac:	eb 6a                	jmp    c0106318 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c01062ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062b1:	83 e8 0c             	sub    $0xc,%eax
c01062b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01062b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01062ba:	83 c0 04             	add    $0x4,%eax
c01062bd:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01062c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01062c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01062ca:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01062cd:	0f a3 10             	bt     %edx,(%eax)
c01062d0:	19 c0                	sbb    %eax,%eax
c01062d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01062d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01062d9:	0f 95 c0             	setne  %al
c01062dc:	0f b6 c0             	movzbl %al,%eax
c01062df:	85 c0                	test   %eax,%eax
c01062e1:	75 24                	jne    c0106307 <default_check+0x79>
c01062e3:	c7 44 24 0c c2 b3 10 	movl   $0xc010b3c2,0xc(%esp)
c01062ea:	c0 
c01062eb:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01062f2:	c0 
c01062f3:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01062fa:	00 
c01062fb:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106302:	e8 f9 a0 ff ff       	call   c0100400 <__panic>
        count ++, total += p->property;
c0106307:	ff 45 f4             	incl   -0xc(%ebp)
c010630a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010630d:	8b 50 08             	mov    0x8(%eax),%edx
c0106310:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106313:	01 d0                	add    %edx,%eax
c0106315:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106318:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010631b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c010631e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106321:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0106324:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106327:	81 7d ec 2c b1 12 c0 	cmpl   $0xc012b12c,-0x14(%ebp)
c010632e:	0f 85 7a ff ff ff    	jne    c01062ae <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0106334:	e8 61 09 00 00       	call   c0106c9a <nr_free_pages>
c0106339:	89 c2                	mov    %eax,%edx
c010633b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010633e:	39 c2                	cmp    %eax,%edx
c0106340:	74 24                	je     c0106366 <default_check+0xd8>
c0106342:	c7 44 24 0c d2 b3 10 	movl   $0xc010b3d2,0xc(%esp)
c0106349:	c0 
c010634a:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106351:	c0 
c0106352:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0106359:	00 
c010635a:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106361:	e8 9a a0 ff ff       	call   c0100400 <__panic>

    basic_check();
c0106366:	e8 e6 f9 ff ff       	call   c0105d51 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010636b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0106372:	e8 85 08 00 00       	call   c0106bfc <alloc_pages>
c0106377:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c010637a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010637e:	75 24                	jne    c01063a4 <default_check+0x116>
c0106380:	c7 44 24 0c eb b3 10 	movl   $0xc010b3eb,0xc(%esp)
c0106387:	c0 
c0106388:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c010638f:	c0 
c0106390:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0106397:	00 
c0106398:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c010639f:	e8 5c a0 ff ff       	call   c0100400 <__panic>
    assert(!PageProperty(p0));
c01063a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01063a7:	83 c0 04             	add    $0x4,%eax
c01063aa:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01063b1:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01063b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01063b7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01063ba:	0f a3 10             	bt     %edx,(%eax)
c01063bd:	19 c0                	sbb    %eax,%eax
c01063bf:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01063c2:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01063c6:	0f 95 c0             	setne  %al
c01063c9:	0f b6 c0             	movzbl %al,%eax
c01063cc:	85 c0                	test   %eax,%eax
c01063ce:	74 24                	je     c01063f4 <default_check+0x166>
c01063d0:	c7 44 24 0c f6 b3 10 	movl   $0xc010b3f6,0xc(%esp)
c01063d7:	c0 
c01063d8:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01063df:	c0 
c01063e0:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01063e7:	00 
c01063e8:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01063ef:	e8 0c a0 ff ff       	call   c0100400 <__panic>

    list_entry_t free_list_store = free_list;
c01063f4:	a1 2c b1 12 c0       	mov    0xc012b12c,%eax
c01063f9:	8b 15 30 b1 12 c0    	mov    0xc012b130,%edx
c01063ff:	89 45 80             	mov    %eax,-0x80(%ebp)
c0106402:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0106405:	c7 45 b0 2c b1 12 c0 	movl   $0xc012b12c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c010640c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010640f:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0106412:	89 50 04             	mov    %edx,0x4(%eax)
c0106415:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106418:	8b 50 04             	mov    0x4(%eax),%edx
c010641b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010641e:	89 10                	mov    %edx,(%eax)
c0106420:	c7 45 b4 2c b1 12 c0 	movl   $0xc012b12c,-0x4c(%ebp)
    return list->next == list;
c0106427:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010642a:	8b 40 04             	mov    0x4(%eax),%eax
c010642d:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0106430:	0f 94 c0             	sete   %al
c0106433:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0106436:	85 c0                	test   %eax,%eax
c0106438:	75 24                	jne    c010645e <default_check+0x1d0>
c010643a:	c7 44 24 0c 4b b3 10 	movl   $0xc010b34b,0xc(%esp)
c0106441:	c0 
c0106442:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106449:	c0 
c010644a:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0106451:	00 
c0106452:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106459:	e8 a2 9f ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c010645e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106465:	e8 92 07 00 00       	call   c0106bfc <alloc_pages>
c010646a:	85 c0                	test   %eax,%eax
c010646c:	74 24                	je     c0106492 <default_check+0x204>
c010646e:	c7 44 24 0c 62 b3 10 	movl   $0xc010b362,0xc(%esp)
c0106475:	c0 
c0106476:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c010647d:	c0 
c010647e:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0106485:	00 
c0106486:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c010648d:	e8 6e 9f ff ff       	call   c0100400 <__panic>

    unsigned int nr_free_store = nr_free;
c0106492:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c0106497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010649a:	c7 05 34 b1 12 c0 00 	movl   $0x0,0xc012b134
c01064a1:	00 00 00 

    free_pages(p0 + 2, 3);
c01064a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01064a7:	83 c0 40             	add    $0x40,%eax
c01064aa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01064b1:	00 
c01064b2:	89 04 24             	mov    %eax,(%esp)
c01064b5:	e8 ad 07 00 00       	call   c0106c67 <free_pages>
    assert(alloc_pages(4) == NULL);
c01064ba:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01064c1:	e8 36 07 00 00       	call   c0106bfc <alloc_pages>
c01064c6:	85 c0                	test   %eax,%eax
c01064c8:	74 24                	je     c01064ee <default_check+0x260>
c01064ca:	c7 44 24 0c 08 b4 10 	movl   $0xc010b408,0xc(%esp)
c01064d1:	c0 
c01064d2:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01064d9:	c0 
c01064da:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01064e1:	00 
c01064e2:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01064e9:	e8 12 9f ff ff       	call   c0100400 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01064ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01064f1:	83 c0 40             	add    $0x40,%eax
c01064f4:	83 c0 04             	add    $0x4,%eax
c01064f7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01064fe:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106501:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106504:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0106507:	0f a3 10             	bt     %edx,(%eax)
c010650a:	19 c0                	sbb    %eax,%eax
c010650c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010650f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0106513:	0f 95 c0             	setne  %al
c0106516:	0f b6 c0             	movzbl %al,%eax
c0106519:	85 c0                	test   %eax,%eax
c010651b:	74 0e                	je     c010652b <default_check+0x29d>
c010651d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106520:	83 c0 40             	add    $0x40,%eax
c0106523:	8b 40 08             	mov    0x8(%eax),%eax
c0106526:	83 f8 03             	cmp    $0x3,%eax
c0106529:	74 24                	je     c010654f <default_check+0x2c1>
c010652b:	c7 44 24 0c 20 b4 10 	movl   $0xc010b420,0xc(%esp)
c0106532:	c0 
c0106533:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c010653a:	c0 
c010653b:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0106542:	00 
c0106543:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c010654a:	e8 b1 9e ff ff       	call   c0100400 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010654f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0106556:	e8 a1 06 00 00       	call   c0106bfc <alloc_pages>
c010655b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010655e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106562:	75 24                	jne    c0106588 <default_check+0x2fa>
c0106564:	c7 44 24 0c 4c b4 10 	movl   $0xc010b44c,0xc(%esp)
c010656b:	c0 
c010656c:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106573:	c0 
c0106574:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c010657b:	00 
c010657c:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106583:	e8 78 9e ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c0106588:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010658f:	e8 68 06 00 00       	call   c0106bfc <alloc_pages>
c0106594:	85 c0                	test   %eax,%eax
c0106596:	74 24                	je     c01065bc <default_check+0x32e>
c0106598:	c7 44 24 0c 62 b3 10 	movl   $0xc010b362,0xc(%esp)
c010659f:	c0 
c01065a0:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01065a7:	c0 
c01065a8:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01065af:	00 
c01065b0:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01065b7:	e8 44 9e ff ff       	call   c0100400 <__panic>
    assert(p0 + 2 == p1);
c01065bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065bf:	83 c0 40             	add    $0x40,%eax
c01065c2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01065c5:	74 24                	je     c01065eb <default_check+0x35d>
c01065c7:	c7 44 24 0c 6a b4 10 	movl   $0xc010b46a,0xc(%esp)
c01065ce:	c0 
c01065cf:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01065d6:	c0 
c01065d7:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01065de:	00 
c01065df:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01065e6:	e8 15 9e ff ff       	call   c0100400 <__panic>

    p2 = p0 + 1;
c01065eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065ee:	83 c0 20             	add    $0x20,%eax
c01065f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01065f4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01065fb:	00 
c01065fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065ff:	89 04 24             	mov    %eax,(%esp)
c0106602:	e8 60 06 00 00       	call   c0106c67 <free_pages>
    free_pages(p1, 3);
c0106607:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010660e:	00 
c010660f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106612:	89 04 24             	mov    %eax,(%esp)
c0106615:	e8 4d 06 00 00       	call   c0106c67 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010661a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010661d:	83 c0 04             	add    $0x4,%eax
c0106620:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0106627:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010662a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010662d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0106630:	0f a3 10             	bt     %edx,(%eax)
c0106633:	19 c0                	sbb    %eax,%eax
c0106635:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0106638:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010663c:	0f 95 c0             	setne  %al
c010663f:	0f b6 c0             	movzbl %al,%eax
c0106642:	85 c0                	test   %eax,%eax
c0106644:	74 0b                	je     c0106651 <default_check+0x3c3>
c0106646:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106649:	8b 40 08             	mov    0x8(%eax),%eax
c010664c:	83 f8 01             	cmp    $0x1,%eax
c010664f:	74 24                	je     c0106675 <default_check+0x3e7>
c0106651:	c7 44 24 0c 78 b4 10 	movl   $0xc010b478,0xc(%esp)
c0106658:	c0 
c0106659:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c0106660:	c0 
c0106661:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0106668:	00 
c0106669:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106670:	e8 8b 9d ff ff       	call   c0100400 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0106675:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106678:	83 c0 04             	add    $0x4,%eax
c010667b:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0106682:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106685:	8b 45 90             	mov    -0x70(%ebp),%eax
c0106688:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010668b:	0f a3 10             	bt     %edx,(%eax)
c010668e:	19 c0                	sbb    %eax,%eax
c0106690:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0106693:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0106697:	0f 95 c0             	setne  %al
c010669a:	0f b6 c0             	movzbl %al,%eax
c010669d:	85 c0                	test   %eax,%eax
c010669f:	74 0b                	je     c01066ac <default_check+0x41e>
c01066a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066a4:	8b 40 08             	mov    0x8(%eax),%eax
c01066a7:	83 f8 03             	cmp    $0x3,%eax
c01066aa:	74 24                	je     c01066d0 <default_check+0x442>
c01066ac:	c7 44 24 0c a0 b4 10 	movl   $0xc010b4a0,0xc(%esp)
c01066b3:	c0 
c01066b4:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01066bb:	c0 
c01066bc:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01066c3:	00 
c01066c4:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01066cb:	e8 30 9d ff ff       	call   c0100400 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01066d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01066d7:	e8 20 05 00 00       	call   c0106bfc <alloc_pages>
c01066dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01066df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066e2:	83 e8 20             	sub    $0x20,%eax
c01066e5:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01066e8:	74 24                	je     c010670e <default_check+0x480>
c01066ea:	c7 44 24 0c c6 b4 10 	movl   $0xc010b4c6,0xc(%esp)
c01066f1:	c0 
c01066f2:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01066f9:	c0 
c01066fa:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0106701:	00 
c0106702:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c0106709:	e8 f2 9c ff ff       	call   c0100400 <__panic>
    free_page(p0);
c010670e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106715:	00 
c0106716:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106719:	89 04 24             	mov    %eax,(%esp)
c010671c:	e8 46 05 00 00       	call   c0106c67 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0106721:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0106728:	e8 cf 04 00 00       	call   c0106bfc <alloc_pages>
c010672d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106730:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106733:	83 c0 20             	add    $0x20,%eax
c0106736:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106739:	74 24                	je     c010675f <default_check+0x4d1>
c010673b:	c7 44 24 0c e4 b4 10 	movl   $0xc010b4e4,0xc(%esp)
c0106742:	c0 
c0106743:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c010674a:	c0 
c010674b:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0106752:	00 
c0106753:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c010675a:	e8 a1 9c ff ff       	call   c0100400 <__panic>

    free_pages(p0, 2);
c010675f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0106766:	00 
c0106767:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010676a:	89 04 24             	mov    %eax,(%esp)
c010676d:	e8 f5 04 00 00       	call   c0106c67 <free_pages>
    free_page(p2);
c0106772:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106779:	00 
c010677a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010677d:	89 04 24             	mov    %eax,(%esp)
c0106780:	e8 e2 04 00 00       	call   c0106c67 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0106785:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010678c:	e8 6b 04 00 00       	call   c0106bfc <alloc_pages>
c0106791:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106794:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106798:	75 24                	jne    c01067be <default_check+0x530>
c010679a:	c7 44 24 0c 04 b5 10 	movl   $0xc010b504,0xc(%esp)
c01067a1:	c0 
c01067a2:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01067a9:	c0 
c01067aa:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01067b1:	00 
c01067b2:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01067b9:	e8 42 9c ff ff       	call   c0100400 <__panic>
    assert(alloc_page() == NULL);
c01067be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01067c5:	e8 32 04 00 00       	call   c0106bfc <alloc_pages>
c01067ca:	85 c0                	test   %eax,%eax
c01067cc:	74 24                	je     c01067f2 <default_check+0x564>
c01067ce:	c7 44 24 0c 62 b3 10 	movl   $0xc010b362,0xc(%esp)
c01067d5:	c0 
c01067d6:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01067dd:	c0 
c01067de:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01067e5:	00 
c01067e6:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01067ed:	e8 0e 9c ff ff       	call   c0100400 <__panic>

    assert(nr_free == 0);
c01067f2:	a1 34 b1 12 c0       	mov    0xc012b134,%eax
c01067f7:	85 c0                	test   %eax,%eax
c01067f9:	74 24                	je     c010681f <default_check+0x591>
c01067fb:	c7 44 24 0c b5 b3 10 	movl   $0xc010b3b5,0xc(%esp)
c0106802:	c0 
c0106803:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c010680a:	c0 
c010680b:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0106812:	00 
c0106813:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c010681a:	e8 e1 9b ff ff       	call   c0100400 <__panic>
    nr_free = nr_free_store;
c010681f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106822:	a3 34 b1 12 c0       	mov    %eax,0xc012b134

    free_list = free_list_store;
c0106827:	8b 45 80             	mov    -0x80(%ebp),%eax
c010682a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010682d:	a3 2c b1 12 c0       	mov    %eax,0xc012b12c
c0106832:	89 15 30 b1 12 c0    	mov    %edx,0xc012b130
    free_pages(p0, 5);
c0106838:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010683f:	00 
c0106840:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106843:	89 04 24             	mov    %eax,(%esp)
c0106846:	e8 1c 04 00 00       	call   c0106c67 <free_pages>

    le = &free_list;
c010684b:	c7 45 ec 2c b1 12 c0 	movl   $0xc012b12c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0106852:	eb 1c                	jmp    c0106870 <default_check+0x5e2>
        struct Page *p = le2page(le, page_link);
c0106854:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106857:	83 e8 0c             	sub    $0xc,%eax
c010685a:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c010685d:	ff 4d f4             	decl   -0xc(%ebp)
c0106860:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106863:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106866:	8b 40 08             	mov    0x8(%eax),%eax
c0106869:	29 c2                	sub    %eax,%edx
c010686b:	89 d0                	mov    %edx,%eax
c010686d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106870:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106873:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0106876:	8b 45 88             	mov    -0x78(%ebp),%eax
c0106879:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010687c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010687f:	81 7d ec 2c b1 12 c0 	cmpl   $0xc012b12c,-0x14(%ebp)
c0106886:	75 cc                	jne    c0106854 <default_check+0x5c6>
    }
    assert(count == 0);
c0106888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010688c:	74 24                	je     c01068b2 <default_check+0x624>
c010688e:	c7 44 24 0c 22 b5 10 	movl   $0xc010b522,0xc(%esp)
c0106895:	c0 
c0106896:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c010689d:	c0 
c010689e:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01068a5:	00 
c01068a6:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01068ad:	e8 4e 9b ff ff       	call   c0100400 <__panic>
    assert(total == 0);
c01068b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068b6:	74 24                	je     c01068dc <default_check+0x64e>
c01068b8:	c7 44 24 0c 2d b5 10 	movl   $0xc010b52d,0xc(%esp)
c01068bf:	c0 
c01068c0:	c7 44 24 08 c2 b1 10 	movl   $0xc010b1c2,0x8(%esp)
c01068c7:	c0 
c01068c8:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c01068cf:	00 
c01068d0:	c7 04 24 d7 b1 10 c0 	movl   $0xc010b1d7,(%esp)
c01068d7:	e8 24 9b ff ff       	call   c0100400 <__panic>
}
c01068dc:	90                   	nop
c01068dd:	c9                   	leave  
c01068de:	c3                   	ret    

c01068df <page2ppn>:
page2ppn(struct Page *page) {
c01068df:	55                   	push   %ebp
c01068e0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01068e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01068e5:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c01068eb:	29 d0                	sub    %edx,%eax
c01068ed:	c1 f8 05             	sar    $0x5,%eax
}
c01068f0:	5d                   	pop    %ebp
c01068f1:	c3                   	ret    

c01068f2 <page2pa>:
page2pa(struct Page *page) {
c01068f2:	55                   	push   %ebp
c01068f3:	89 e5                	mov    %esp,%ebp
c01068f5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01068f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01068fb:	89 04 24             	mov    %eax,(%esp)
c01068fe:	e8 dc ff ff ff       	call   c01068df <page2ppn>
c0106903:	c1 e0 0c             	shl    $0xc,%eax
}
c0106906:	c9                   	leave  
c0106907:	c3                   	ret    

c0106908 <pa2page>:
pa2page(uintptr_t pa) {
c0106908:	55                   	push   %ebp
c0106909:	89 e5                	mov    %esp,%ebp
c010690b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010690e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106911:	c1 e8 0c             	shr    $0xc,%eax
c0106914:	89 c2                	mov    %eax,%edx
c0106916:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c010691b:	39 c2                	cmp    %eax,%edx
c010691d:	72 1c                	jb     c010693b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010691f:	c7 44 24 08 68 b5 10 	movl   $0xc010b568,0x8(%esp)
c0106926:	c0 
c0106927:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010692e:	00 
c010692f:	c7 04 24 87 b5 10 c0 	movl   $0xc010b587,(%esp)
c0106936:	e8 c5 9a ff ff       	call   c0100400 <__panic>
    return &pages[PPN(pa)];
c010693b:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0106940:	8b 55 08             	mov    0x8(%ebp),%edx
c0106943:	c1 ea 0c             	shr    $0xc,%edx
c0106946:	c1 e2 05             	shl    $0x5,%edx
c0106949:	01 d0                	add    %edx,%eax
}
c010694b:	c9                   	leave  
c010694c:	c3                   	ret    

c010694d <page2kva>:
page2kva(struct Page *page) {
c010694d:	55                   	push   %ebp
c010694e:	89 e5                	mov    %esp,%ebp
c0106950:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0106953:	8b 45 08             	mov    0x8(%ebp),%eax
c0106956:	89 04 24             	mov    %eax,(%esp)
c0106959:	e8 94 ff ff ff       	call   c01068f2 <page2pa>
c010695e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106964:	c1 e8 0c             	shr    $0xc,%eax
c0106967:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010696a:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c010696f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0106972:	72 23                	jb     c0106997 <page2kva+0x4a>
c0106974:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106977:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010697b:	c7 44 24 08 98 b5 10 	movl   $0xc010b598,0x8(%esp)
c0106982:	c0 
c0106983:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010698a:	00 
c010698b:	c7 04 24 87 b5 10 c0 	movl   $0xc010b587,(%esp)
c0106992:	e8 69 9a ff ff       	call   c0100400 <__panic>
c0106997:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010699a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010699f:	c9                   	leave  
c01069a0:	c3                   	ret    

c01069a1 <pte2page>:
pte2page(pte_t pte) {
c01069a1:	55                   	push   %ebp
c01069a2:	89 e5                	mov    %esp,%ebp
c01069a4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01069a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01069aa:	83 e0 01             	and    $0x1,%eax
c01069ad:	85 c0                	test   %eax,%eax
c01069af:	75 1c                	jne    c01069cd <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01069b1:	c7 44 24 08 bc b5 10 	movl   $0xc010b5bc,0x8(%esp)
c01069b8:	c0 
c01069b9:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01069c0:	00 
c01069c1:	c7 04 24 87 b5 10 c0 	movl   $0xc010b587,(%esp)
c01069c8:	e8 33 9a ff ff       	call   c0100400 <__panic>
    return pa2page(PTE_ADDR(pte));
c01069cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01069d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01069d5:	89 04 24             	mov    %eax,(%esp)
c01069d8:	e8 2b ff ff ff       	call   c0106908 <pa2page>
}
c01069dd:	c9                   	leave  
c01069de:	c3                   	ret    

c01069df <pde2page>:
pde2page(pde_t pde) {
c01069df:	55                   	push   %ebp
c01069e0:	89 e5                	mov    %esp,%ebp
c01069e2:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01069e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01069e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01069ed:	89 04 24             	mov    %eax,(%esp)
c01069f0:	e8 13 ff ff ff       	call   c0106908 <pa2page>
}
c01069f5:	c9                   	leave  
c01069f6:	c3                   	ret    

c01069f7 <page_ref>:
page_ref(struct Page *page) {
c01069f7:	55                   	push   %ebp
c01069f8:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01069fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01069fd:	8b 00                	mov    (%eax),%eax
}
c01069ff:	5d                   	pop    %ebp
c0106a00:	c3                   	ret    

c0106a01 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0106a01:	55                   	push   %ebp
c0106a02:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a07:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106a0a:	89 10                	mov    %edx,(%eax)
}
c0106a0c:	90                   	nop
c0106a0d:	5d                   	pop    %ebp
c0106a0e:	c3                   	ret    

c0106a0f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106a0f:	55                   	push   %ebp
c0106a10:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a15:	8b 00                	mov    (%eax),%eax
c0106a17:	8d 50 01             	lea    0x1(%eax),%edx
c0106a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a1d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a22:	8b 00                	mov    (%eax),%eax
}
c0106a24:	5d                   	pop    %ebp
c0106a25:	c3                   	ret    

c0106a26 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106a26:	55                   	push   %ebp
c0106a27:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a2c:	8b 00                	mov    (%eax),%eax
c0106a2e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a34:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a39:	8b 00                	mov    (%eax),%eax
}
c0106a3b:	5d                   	pop    %ebp
c0106a3c:	c3                   	ret    

c0106a3d <__intr_save>:
__intr_save(void) {
c0106a3d:	55                   	push   %ebp
c0106a3e:	89 e5                	mov    %esp,%ebp
c0106a40:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106a43:	9c                   	pushf  
c0106a44:	58                   	pop    %eax
c0106a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106a4b:	25 00 02 00 00       	and    $0x200,%eax
c0106a50:	85 c0                	test   %eax,%eax
c0106a52:	74 0c                	je     c0106a60 <__intr_save+0x23>
        intr_disable();
c0106a54:	e8 d9 b5 ff ff       	call   c0102032 <intr_disable>
        return 1;
c0106a59:	b8 01 00 00 00       	mov    $0x1,%eax
c0106a5e:	eb 05                	jmp    c0106a65 <__intr_save+0x28>
    return 0;
c0106a60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106a65:	c9                   	leave  
c0106a66:	c3                   	ret    

c0106a67 <__intr_restore>:
__intr_restore(bool flag) {
c0106a67:	55                   	push   %ebp
c0106a68:	89 e5                	mov    %esp,%ebp
c0106a6a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106a6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106a71:	74 05                	je     c0106a78 <__intr_restore+0x11>
        intr_enable();
c0106a73:	e8 b3 b5 ff ff       	call   c010202b <intr_enable>
}
c0106a78:	90                   	nop
c0106a79:	c9                   	leave  
c0106a7a:	c3                   	ret    

c0106a7b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106a7b:	55                   	push   %ebp
c0106a7c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a81:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106a84:	b8 23 00 00 00       	mov    $0x23,%eax
c0106a89:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106a8b:	b8 23 00 00 00       	mov    $0x23,%eax
c0106a90:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106a92:	b8 10 00 00 00       	mov    $0x10,%eax
c0106a97:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106a99:	b8 10 00 00 00       	mov    $0x10,%eax
c0106a9e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106aa0:	b8 10 00 00 00       	mov    $0x10,%eax
c0106aa5:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106aa7:	ea ae 6a 10 c0 08 00 	ljmp   $0x8,$0xc0106aae
}
c0106aae:	90                   	nop
c0106aaf:	5d                   	pop    %ebp
c0106ab0:	c3                   	ret    

c0106ab1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106ab1:	55                   	push   %ebp
c0106ab2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ab7:	a3 a4 8f 12 c0       	mov    %eax,0xc0128fa4
}
c0106abc:	90                   	nop
c0106abd:	5d                   	pop    %ebp
c0106abe:	c3                   	ret    

c0106abf <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106abf:	55                   	push   %ebp
c0106ac0:	89 e5                	mov    %esp,%ebp
c0106ac2:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106ac5:	b8 00 50 12 c0       	mov    $0xc0125000,%eax
c0106aca:	89 04 24             	mov    %eax,(%esp)
c0106acd:	e8 df ff ff ff       	call   c0106ab1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0106ad2:	66 c7 05 a8 8f 12 c0 	movw   $0x10,0xc0128fa8
c0106ad9:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106adb:	66 c7 05 68 5a 12 c0 	movw   $0x68,0xc0125a68
c0106ae2:	68 00 
c0106ae4:	b8 a0 8f 12 c0       	mov    $0xc0128fa0,%eax
c0106ae9:	0f b7 c0             	movzwl %ax,%eax
c0106aec:	66 a3 6a 5a 12 c0    	mov    %ax,0xc0125a6a
c0106af2:	b8 a0 8f 12 c0       	mov    $0xc0128fa0,%eax
c0106af7:	c1 e8 10             	shr    $0x10,%eax
c0106afa:	a2 6c 5a 12 c0       	mov    %al,0xc0125a6c
c0106aff:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106b06:	24 f0                	and    $0xf0,%al
c0106b08:	0c 09                	or     $0x9,%al
c0106b0a:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106b0f:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106b16:	24 ef                	and    $0xef,%al
c0106b18:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106b1d:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106b24:	24 9f                	and    $0x9f,%al
c0106b26:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106b2b:	0f b6 05 6d 5a 12 c0 	movzbl 0xc0125a6d,%eax
c0106b32:	0c 80                	or     $0x80,%al
c0106b34:	a2 6d 5a 12 c0       	mov    %al,0xc0125a6d
c0106b39:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106b40:	24 f0                	and    $0xf0,%al
c0106b42:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106b47:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106b4e:	24 ef                	and    $0xef,%al
c0106b50:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106b55:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106b5c:	24 df                	and    $0xdf,%al
c0106b5e:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106b63:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106b6a:	0c 40                	or     $0x40,%al
c0106b6c:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106b71:	0f b6 05 6e 5a 12 c0 	movzbl 0xc0125a6e,%eax
c0106b78:	24 7f                	and    $0x7f,%al
c0106b7a:	a2 6e 5a 12 c0       	mov    %al,0xc0125a6e
c0106b7f:	b8 a0 8f 12 c0       	mov    $0xc0128fa0,%eax
c0106b84:	c1 e8 18             	shr    $0x18,%eax
c0106b87:	a2 6f 5a 12 c0       	mov    %al,0xc0125a6f

    // reload all segment registers
    lgdt(&gdt_pd);
c0106b8c:	c7 04 24 70 5a 12 c0 	movl   $0xc0125a70,(%esp)
c0106b93:	e8 e3 fe ff ff       	call   c0106a7b <lgdt>
c0106b98:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106b9e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106ba2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106ba5:	90                   	nop
c0106ba6:	c9                   	leave  
c0106ba7:	c3                   	ret    

c0106ba8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106ba8:	55                   	push   %ebp
c0106ba9:	89 e5                	mov    %esp,%ebp
c0106bab:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0106bae:	c7 05 38 b1 12 c0 4c 	movl   $0xc010b54c,0xc012b138
c0106bb5:	b5 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106bb8:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106bbd:	8b 00                	mov    (%eax),%eax
c0106bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bc3:	c7 04 24 e8 b5 10 c0 	movl   $0xc010b5e8,(%esp)
c0106bca:	e8 da 96 ff ff       	call   c01002a9 <cprintf>
    pmm_manager->init();
c0106bcf:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106bd4:	8b 40 04             	mov    0x4(%eax),%eax
c0106bd7:	ff d0                	call   *%eax
}
c0106bd9:	90                   	nop
c0106bda:	c9                   	leave  
c0106bdb:	c3                   	ret    

c0106bdc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106bdc:	55                   	push   %ebp
c0106bdd:	89 e5                	mov    %esp,%ebp
c0106bdf:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0106be2:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106be7:	8b 40 08             	mov    0x8(%eax),%eax
c0106bea:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106bed:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106bf1:	8b 55 08             	mov    0x8(%ebp),%edx
c0106bf4:	89 14 24             	mov    %edx,(%esp)
c0106bf7:	ff d0                	call   *%eax
}
c0106bf9:	90                   	nop
c0106bfa:	c9                   	leave  
c0106bfb:	c3                   	ret    

c0106bfc <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106bfc:	55                   	push   %ebp
c0106bfd:	89 e5                	mov    %esp,%ebp
c0106bff:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0106c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106c09:	e8 2f fe ff ff       	call   c0106a3d <__intr_save>
c0106c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106c11:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106c16:	8b 40 0c             	mov    0xc(%eax),%eax
c0106c19:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c1c:	89 14 24             	mov    %edx,(%esp)
c0106c1f:	ff d0                	call   *%eax
c0106c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c27:	89 04 24             	mov    %eax,(%esp)
c0106c2a:	e8 38 fe ff ff       	call   c0106a67 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c33:	75 2d                	jne    c0106c62 <alloc_pages+0x66>
c0106c35:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106c39:	77 27                	ja     c0106c62 <alloc_pages+0x66>
c0106c3b:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c0106c40:	85 c0                	test   %eax,%eax
c0106c42:	74 1e                	je     c0106c62 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0106c44:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c47:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0106c4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106c53:	00 
c0106c54:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c58:	89 04 24             	mov    %eax,(%esp)
c0106c5b:	e8 89 d3 ff ff       	call   c0103fe9 <swap_out>
    {
c0106c60:	eb a7                	jmp    c0106c09 <alloc_pages+0xd>
    }
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106c65:	c9                   	leave  
c0106c66:	c3                   	ret    

c0106c67 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106c67:	55                   	push   %ebp
c0106c68:	89 e5                	mov    %esp,%ebp
c0106c6a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106c6d:	e8 cb fd ff ff       	call   c0106a3d <__intr_save>
c0106c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106c75:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106c7a:	8b 40 10             	mov    0x10(%eax),%eax
c0106c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c80:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c84:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c87:	89 14 24             	mov    %edx,(%esp)
c0106c8a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0106c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c8f:	89 04 24             	mov    %eax,(%esp)
c0106c92:	e8 d0 fd ff ff       	call   c0106a67 <__intr_restore>
}
c0106c97:	90                   	nop
c0106c98:	c9                   	leave  
c0106c99:	c3                   	ret    

c0106c9a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0106c9a:	55                   	push   %ebp
c0106c9b:	89 e5                	mov    %esp,%ebp
c0106c9d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0106ca0:	e8 98 fd ff ff       	call   c0106a3d <__intr_save>
c0106ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0106ca8:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0106cad:	8b 40 14             	mov    0x14(%eax),%eax
c0106cb0:	ff d0                	call   *%eax
c0106cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0106cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106cb8:	89 04 24             	mov    %eax,(%esp)
c0106cbb:	e8 a7 fd ff ff       	call   c0106a67 <__intr_restore>
    return ret;
c0106cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0106cc3:	c9                   	leave  
c0106cc4:	c3                   	ret    

c0106cc5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0106cc5:	55                   	push   %ebp
c0106cc6:	89 e5                	mov    %esp,%ebp
c0106cc8:	57                   	push   %edi
c0106cc9:	56                   	push   %esi
c0106cca:	53                   	push   %ebx
c0106ccb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0106cd1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0106cd8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0106ce6:	c7 04 24 ff b5 10 c0 	movl   $0xc010b5ff,(%esp)
c0106ced:	e8 b7 95 ff ff       	call   c01002a9 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106cf2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106cf9:	e9 22 01 00 00       	jmp    c0106e20 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106cfe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106d01:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d04:	89 d0                	mov    %edx,%eax
c0106d06:	c1 e0 02             	shl    $0x2,%eax
c0106d09:	01 d0                	add    %edx,%eax
c0106d0b:	c1 e0 02             	shl    $0x2,%eax
c0106d0e:	01 c8                	add    %ecx,%eax
c0106d10:	8b 50 08             	mov    0x8(%eax),%edx
c0106d13:	8b 40 04             	mov    0x4(%eax),%eax
c0106d16:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0106d19:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0106d1c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106d1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d22:	89 d0                	mov    %edx,%eax
c0106d24:	c1 e0 02             	shl    $0x2,%eax
c0106d27:	01 d0                	add    %edx,%eax
c0106d29:	c1 e0 02             	shl    $0x2,%eax
c0106d2c:	01 c8                	add    %ecx,%eax
c0106d2e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106d31:	8b 58 10             	mov    0x10(%eax),%ebx
c0106d34:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106d37:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0106d3a:	01 c8                	add    %ecx,%eax
c0106d3c:	11 da                	adc    %ebx,%edx
c0106d3e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106d41:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106d44:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106d47:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d4a:	89 d0                	mov    %edx,%eax
c0106d4c:	c1 e0 02             	shl    $0x2,%eax
c0106d4f:	01 d0                	add    %edx,%eax
c0106d51:	c1 e0 02             	shl    $0x2,%eax
c0106d54:	01 c8                	add    %ecx,%eax
c0106d56:	83 c0 14             	add    $0x14,%eax
c0106d59:	8b 00                	mov    (%eax),%eax
c0106d5b:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0106d5e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106d61:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106d64:	83 c0 ff             	add    $0xffffffff,%eax
c0106d67:	83 d2 ff             	adc    $0xffffffff,%edx
c0106d6a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0106d70:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0106d76:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106d79:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106d7c:	89 d0                	mov    %edx,%eax
c0106d7e:	c1 e0 02             	shl    $0x2,%eax
c0106d81:	01 d0                	add    %edx,%eax
c0106d83:	c1 e0 02             	shl    $0x2,%eax
c0106d86:	01 c8                	add    %ecx,%eax
c0106d88:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106d8b:	8b 58 10             	mov    0x10(%eax),%ebx
c0106d8e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0106d91:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0106d95:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0106d9b:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0106da1:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106da5:	89 54 24 18          	mov    %edx,0x18(%esp)
c0106da9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106dac:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0106daf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106db3:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106db7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0106dbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0106dbf:	c7 04 24 0c b6 10 c0 	movl   $0xc010b60c,(%esp)
c0106dc6:	e8 de 94 ff ff       	call   c01002a9 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106dcb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106dce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106dd1:	89 d0                	mov    %edx,%eax
c0106dd3:	c1 e0 02             	shl    $0x2,%eax
c0106dd6:	01 d0                	add    %edx,%eax
c0106dd8:	c1 e0 02             	shl    $0x2,%eax
c0106ddb:	01 c8                	add    %ecx,%eax
c0106ddd:	83 c0 14             	add    $0x14,%eax
c0106de0:	8b 00                	mov    (%eax),%eax
c0106de2:	83 f8 01             	cmp    $0x1,%eax
c0106de5:	75 36                	jne    c0106e1d <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0106de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106dea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ded:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0106df0:	77 2b                	ja     c0106e1d <page_init+0x158>
c0106df2:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0106df5:	72 05                	jb     c0106dfc <page_init+0x137>
c0106df7:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0106dfa:	73 21                	jae    c0106e1d <page_init+0x158>
c0106dfc:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0106e00:	77 1b                	ja     c0106e1d <page_init+0x158>
c0106e02:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0106e06:	72 09                	jb     c0106e11 <page_init+0x14c>
c0106e08:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0106e0f:	77 0c                	ja     c0106e1d <page_init+0x158>
                maxpa = end;
c0106e11:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106e14:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106e17:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106e1a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0106e1d:	ff 45 dc             	incl   -0x24(%ebp)
c0106e20:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106e23:	8b 00                	mov    (%eax),%eax
c0106e25:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0106e28:	0f 8c d0 fe ff ff    	jl     c0106cfe <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106e2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106e32:	72 1d                	jb     c0106e51 <page_init+0x18c>
c0106e34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106e38:	77 09                	ja     c0106e43 <page_init+0x17e>
c0106e3a:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0106e41:	76 0e                	jbe    c0106e51 <page_init+0x18c>
        maxpa = KMEMSIZE;
c0106e43:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106e4a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0106e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e57:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106e5b:	c1 ea 0c             	shr    $0xc,%edx
c0106e5e:	89 c1                	mov    %eax,%ecx
c0106e60:	89 d3                	mov    %edx,%ebx
c0106e62:	89 c8                	mov    %ecx,%eax
c0106e64:	a3 80 8f 12 c0       	mov    %eax,0xc0128f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0106e69:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0106e70:	b8 4c b1 12 c0       	mov    $0xc012b14c,%eax
c0106e75:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106e78:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106e7b:	01 d0                	add    %edx,%eax
c0106e7d:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0106e80:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106e83:	ba 00 00 00 00       	mov    $0x0,%edx
c0106e88:	f7 75 c0             	divl   -0x40(%ebp)
c0106e8b:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106e8e:	29 d0                	sub    %edx,%eax
c0106e90:	a3 40 b1 12 c0       	mov    %eax,0xc012b140

    for (i = 0; i < npage; i ++) {
c0106e95:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106e9c:	eb 26                	jmp    c0106ec4 <page_init+0x1ff>
        SetPageReserved(pages + i);
c0106e9e:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0106ea3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ea6:	c1 e2 05             	shl    $0x5,%edx
c0106ea9:	01 d0                	add    %edx,%eax
c0106eab:	83 c0 04             	add    $0x4,%eax
c0106eae:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0106eb5:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106eb8:	8b 45 90             	mov    -0x70(%ebp),%eax
c0106ebb:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0106ebe:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0106ec1:	ff 45 dc             	incl   -0x24(%ebp)
c0106ec4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ec7:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0106ecc:	39 c2                	cmp    %eax,%edx
c0106ece:	72 ce                	jb     c0106e9e <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106ed0:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0106ed5:	c1 e0 05             	shl    $0x5,%eax
c0106ed8:	89 c2                	mov    %eax,%edx
c0106eda:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0106edf:	01 d0                	add    %edx,%eax
c0106ee1:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106ee4:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0106eeb:	77 23                	ja     c0106f10 <page_init+0x24b>
c0106eed:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106ef0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106ef4:	c7 44 24 08 3c b6 10 	movl   $0xc010b63c,0x8(%esp)
c0106efb:	c0 
c0106efc:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0106f03:	00 
c0106f04:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0106f0b:	e8 f0 94 ff ff       	call   c0100400 <__panic>
c0106f10:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106f13:	05 00 00 00 40       	add    $0x40000000,%eax
c0106f18:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0106f1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106f22:	e9 69 01 00 00       	jmp    c0107090 <page_init+0x3cb>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106f27:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106f2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f2d:	89 d0                	mov    %edx,%eax
c0106f2f:	c1 e0 02             	shl    $0x2,%eax
c0106f32:	01 d0                	add    %edx,%eax
c0106f34:	c1 e0 02             	shl    $0x2,%eax
c0106f37:	01 c8                	add    %ecx,%eax
c0106f39:	8b 50 08             	mov    0x8(%eax),%edx
c0106f3c:	8b 40 04             	mov    0x4(%eax),%eax
c0106f3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106f42:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106f45:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106f48:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f4b:	89 d0                	mov    %edx,%eax
c0106f4d:	c1 e0 02             	shl    $0x2,%eax
c0106f50:	01 d0                	add    %edx,%eax
c0106f52:	c1 e0 02             	shl    $0x2,%eax
c0106f55:	01 c8                	add    %ecx,%eax
c0106f57:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106f5a:	8b 58 10             	mov    0x10(%eax),%ebx
c0106f5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106f60:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106f63:	01 c8                	add    %ecx,%eax
c0106f65:	11 da                	adc    %ebx,%edx
c0106f67:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106f6a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0106f6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106f70:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f73:	89 d0                	mov    %edx,%eax
c0106f75:	c1 e0 02             	shl    $0x2,%eax
c0106f78:	01 d0                	add    %edx,%eax
c0106f7a:	c1 e0 02             	shl    $0x2,%eax
c0106f7d:	01 c8                	add    %ecx,%eax
c0106f7f:	83 c0 14             	add    $0x14,%eax
c0106f82:	8b 00                	mov    (%eax),%eax
c0106f84:	83 f8 01             	cmp    $0x1,%eax
c0106f87:	0f 85 00 01 00 00    	jne    c010708d <page_init+0x3c8>
            if (begin < freemem) {
c0106f8d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106f90:	ba 00 00 00 00       	mov    $0x0,%edx
c0106f95:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0106f98:	77 17                	ja     c0106fb1 <page_init+0x2ec>
c0106f9a:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0106f9d:	72 05                	jb     c0106fa4 <page_init+0x2df>
c0106f9f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0106fa2:	73 0d                	jae    c0106fb1 <page_init+0x2ec>
                begin = freemem;
c0106fa4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106fa7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106faa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0106fb1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106fb5:	72 1d                	jb     c0106fd4 <page_init+0x30f>
c0106fb7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106fbb:	77 09                	ja     c0106fc6 <page_init+0x301>
c0106fbd:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0106fc4:	76 0e                	jbe    c0106fd4 <page_init+0x30f>
                end = KMEMSIZE;
c0106fc6:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0106fcd:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0106fd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106fd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106fda:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106fdd:	0f 87 aa 00 00 00    	ja     c010708d <page_init+0x3c8>
c0106fe3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0106fe6:	72 09                	jb     c0106ff1 <page_init+0x32c>
c0106fe8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0106feb:	0f 83 9c 00 00 00    	jae    c010708d <page_init+0x3c8>
                begin = ROUNDUP(begin, PGSIZE);
c0106ff1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0106ff8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0106ffb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106ffe:	01 d0                	add    %edx,%eax
c0107000:	48                   	dec    %eax
c0107001:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0107004:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107007:	ba 00 00 00 00       	mov    $0x0,%edx
c010700c:	f7 75 b0             	divl   -0x50(%ebp)
c010700f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0107012:	29 d0                	sub    %edx,%eax
c0107014:	ba 00 00 00 00       	mov    $0x0,%edx
c0107019:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010701c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010701f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107022:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0107025:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107028:	ba 00 00 00 00       	mov    $0x0,%edx
c010702d:	89 c3                	mov    %eax,%ebx
c010702f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0107035:	89 de                	mov    %ebx,%esi
c0107037:	89 d0                	mov    %edx,%eax
c0107039:	83 e0 00             	and    $0x0,%eax
c010703c:	89 c7                	mov    %eax,%edi
c010703e:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0107041:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0107044:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107047:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010704a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010704d:	77 3e                	ja     c010708d <page_init+0x3c8>
c010704f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107052:	72 05                	jb     c0107059 <page_init+0x394>
c0107054:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0107057:	73 34                	jae    c010708d <page_init+0x3c8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0107059:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010705c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010705f:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0107062:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0107065:	89 c1                	mov    %eax,%ecx
c0107067:	89 d3                	mov    %edx,%ebx
c0107069:	89 c8                	mov    %ecx,%eax
c010706b:	89 da                	mov    %ebx,%edx
c010706d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0107071:	c1 ea 0c             	shr    $0xc,%edx
c0107074:	89 c3                	mov    %eax,%ebx
c0107076:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107079:	89 04 24             	mov    %eax,(%esp)
c010707c:	e8 87 f8 ff ff       	call   c0106908 <pa2page>
c0107081:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0107085:	89 04 24             	mov    %eax,(%esp)
c0107088:	e8 4f fb ff ff       	call   c0106bdc <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010708d:	ff 45 dc             	incl   -0x24(%ebp)
c0107090:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107093:	8b 00                	mov    (%eax),%eax
c0107095:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0107098:	0f 8c 89 fe ff ff    	jl     c0106f27 <page_init+0x262>
                }
            }
        }
    }
}
c010709e:	90                   	nop
c010709f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01070a5:	5b                   	pop    %ebx
c01070a6:	5e                   	pop    %esi
c01070a7:	5f                   	pop    %edi
c01070a8:	5d                   	pop    %ebp
c01070a9:	c3                   	ret    

c01070aa <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01070aa:	55                   	push   %ebp
c01070ab:	89 e5                	mov    %esp,%ebp
c01070ad:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01070b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070b3:	33 45 14             	xor    0x14(%ebp),%eax
c01070b6:	25 ff 0f 00 00       	and    $0xfff,%eax
c01070bb:	85 c0                	test   %eax,%eax
c01070bd:	74 24                	je     c01070e3 <boot_map_segment+0x39>
c01070bf:	c7 44 24 0c 6e b6 10 	movl   $0xc010b66e,0xc(%esp)
c01070c6:	c0 
c01070c7:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c01070ce:	c0 
c01070cf:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c01070d6:	00 
c01070d7:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01070de:	e8 1d 93 ff ff       	call   c0100400 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01070e3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01070ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01070ed:	25 ff 0f 00 00       	and    $0xfff,%eax
c01070f2:	89 c2                	mov    %eax,%edx
c01070f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01070f7:	01 c2                	add    %eax,%edx
c01070f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070fc:	01 d0                	add    %edx,%eax
c01070fe:	48                   	dec    %eax
c01070ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107102:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107105:	ba 00 00 00 00       	mov    $0x0,%edx
c010710a:	f7 75 f0             	divl   -0x10(%ebp)
c010710d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107110:	29 d0                	sub    %edx,%eax
c0107112:	c1 e8 0c             	shr    $0xc,%eax
c0107115:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0107118:	8b 45 0c             	mov    0xc(%ebp),%eax
c010711b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010711e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107121:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107126:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0107129:	8b 45 14             	mov    0x14(%ebp),%eax
c010712c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010712f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107132:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107137:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010713a:	eb 68                	jmp    c01071a4 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010713c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107143:	00 
c0107144:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107147:	89 44 24 04          	mov    %eax,0x4(%esp)
c010714b:	8b 45 08             	mov    0x8(%ebp),%eax
c010714e:	89 04 24             	mov    %eax,(%esp)
c0107151:	e8 86 01 00 00       	call   c01072dc <get_pte>
c0107156:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0107159:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010715d:	75 24                	jne    c0107183 <boot_map_segment+0xd9>
c010715f:	c7 44 24 0c 9a b6 10 	movl   $0xc010b69a,0xc(%esp)
c0107166:	c0 
c0107167:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c010716e:	c0 
c010716f:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0107176:	00 
c0107177:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c010717e:	e8 7d 92 ff ff       	call   c0100400 <__panic>
        *ptep = pa | PTE_P | perm;
c0107183:	8b 45 14             	mov    0x14(%ebp),%eax
c0107186:	0b 45 18             	or     0x18(%ebp),%eax
c0107189:	83 c8 01             	or     $0x1,%eax
c010718c:	89 c2                	mov    %eax,%edx
c010718e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107191:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0107193:	ff 4d f4             	decl   -0xc(%ebp)
c0107196:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010719d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01071a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071a8:	75 92                	jne    c010713c <boot_map_segment+0x92>
    }
}
c01071aa:	90                   	nop
c01071ab:	c9                   	leave  
c01071ac:	c3                   	ret    

c01071ad <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01071ad:	55                   	push   %ebp
c01071ae:	89 e5                	mov    %esp,%ebp
c01071b0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01071b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01071ba:	e8 3d fa ff ff       	call   c0106bfc <alloc_pages>
c01071bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01071c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071c6:	75 1c                	jne    c01071e4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01071c8:	c7 44 24 08 a7 b6 10 	movl   $0xc010b6a7,0x8(%esp)
c01071cf:	c0 
c01071d0:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01071d7:	00 
c01071d8:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01071df:	e8 1c 92 ff ff       	call   c0100400 <__panic>
    }
    return page2kva(p);
c01071e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071e7:	89 04 24             	mov    %eax,(%esp)
c01071ea:	e8 5e f7 ff ff       	call   c010694d <page2kva>
}
c01071ef:	c9                   	leave  
c01071f0:	c3                   	ret    

c01071f1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01071f1:	55                   	push   %ebp
c01071f2:	89 e5                	mov    %esp,%ebp
c01071f4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01071f7:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01071fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01071ff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0107206:	77 23                	ja     c010722b <pmm_init+0x3a>
c0107208:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010720b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010720f:	c7 44 24 08 3c b6 10 	movl   $0xc010b63c,0x8(%esp)
c0107216:	c0 
c0107217:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010721e:	00 
c010721f:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107226:	e8 d5 91 ff ff       	call   c0100400 <__panic>
c010722b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010722e:	05 00 00 00 40       	add    $0x40000000,%eax
c0107233:	a3 3c b1 12 c0       	mov    %eax,0xc012b13c
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0107238:	e8 6b f9 ff ff       	call   c0106ba8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010723d:	e8 83 fa ff ff       	call   c0106cc5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0107242:	e8 ae 04 00 00       	call   c01076f5 <check_alloc_page>

    check_pgdir();
c0107247:	e8 c8 04 00 00       	call   c0107714 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010724c:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107251:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107254:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010725b:	77 23                	ja     c0107280 <pmm_init+0x8f>
c010725d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107260:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107264:	c7 44 24 08 3c b6 10 	movl   $0xc010b63c,0x8(%esp)
c010726b:	c0 
c010726c:	c7 44 24 04 3a 01 00 	movl   $0x13a,0x4(%esp)
c0107273:	00 
c0107274:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c010727b:	e8 80 91 ff ff       	call   c0100400 <__panic>
c0107280:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107283:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0107289:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c010728e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0107293:	83 ca 03             	or     $0x3,%edx
c0107296:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0107298:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c010729d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01072a4:	00 
c01072a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01072ac:	00 
c01072ad:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01072b4:	38 
c01072b5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01072bc:	c0 
c01072bd:	89 04 24             	mov    %eax,(%esp)
c01072c0:	e8 e5 fd ff ff       	call   c01070aa <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01072c5:	e8 f5 f7 ff ff       	call   c0106abf <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01072ca:	e8 e1 0a 00 00       	call   c0107db0 <check_boot_pgdir>

    print_pgdir();
c01072cf:	e8 5a 0f 00 00       	call   c010822e <print_pgdir>
    
    kmalloc_init();
c01072d4:	e8 48 dc ff ff       	call   c0104f21 <kmalloc_init>

}
c01072d9:	90                   	nop
c01072da:	c9                   	leave  
c01072db:	c3                   	ret    

c01072dc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01072dc:	55                   	push   %ebp
c01072dd:	89 e5                	mov    %esp,%ebp
c01072df:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01072e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072e5:	c1 e8 16             	shr    $0x16,%eax
c01072e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01072ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01072f2:	01 d0                	add    %edx,%eax
c01072f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01072f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072fa:	8b 00                	mov    (%eax),%eax
c01072fc:	83 e0 01             	and    $0x1,%eax
c01072ff:	85 c0                	test   %eax,%eax
c0107301:	0f 85 af 00 00 00    	jne    c01073b6 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0107307:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010730b:	74 15                	je     c0107322 <get_pte+0x46>
c010730d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107314:	e8 e3 f8 ff ff       	call   c0106bfc <alloc_pages>
c0107319:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010731c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107320:	75 0a                	jne    c010732c <get_pte+0x50>
            return NULL;
c0107322:	b8 00 00 00 00       	mov    $0x0,%eax
c0107327:	e9 e7 00 00 00       	jmp    c0107413 <get_pte+0x137>
        }
        set_page_ref(page, 1);
c010732c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107333:	00 
c0107334:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107337:	89 04 24             	mov    %eax,(%esp)
c010733a:	e8 c2 f6 ff ff       	call   c0106a01 <set_page_ref>
        uintptr_t pa = page2pa(page);
c010733f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107342:	89 04 24             	mov    %eax,(%esp)
c0107345:	e8 a8 f5 ff ff       	call   c01068f2 <page2pa>
c010734a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010734d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107350:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107353:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107356:	c1 e8 0c             	shr    $0xc,%eax
c0107359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010735c:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107361:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0107364:	72 23                	jb     c0107389 <get_pte+0xad>
c0107366:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107369:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010736d:	c7 44 24 08 98 b5 10 	movl   $0xc010b598,0x8(%esp)
c0107374:	c0 
c0107375:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c010737c:	00 
c010737d:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107384:	e8 77 90 ff ff       	call   c0100400 <__panic>
c0107389:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010738c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107391:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107398:	00 
c0107399:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01073a0:	00 
c01073a1:	89 04 24             	mov    %eax,(%esp)
c01073a4:	e8 ee 20 00 00       	call   c0109497 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01073a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073ac:	83 c8 07             	or     $0x7,%eax
c01073af:	89 c2                	mov    %eax,%edx
c01073b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073b4:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01073b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073b9:	8b 00                	mov    (%eax),%eax
c01073bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01073c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01073c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073c6:	c1 e8 0c             	shr    $0xc,%eax
c01073c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01073cc:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c01073d1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01073d4:	72 23                	jb     c01073f9 <get_pte+0x11d>
c01073d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01073dd:	c7 44 24 08 98 b5 10 	movl   $0xc010b598,0x8(%esp)
c01073e4:	c0 
c01073e5:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c01073ec:	00 
c01073ed:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01073f4:	e8 07 90 ff ff       	call   c0100400 <__panic>
c01073f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073fc:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107401:	89 c2                	mov    %eax,%edx
c0107403:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107406:	c1 e8 0c             	shr    $0xc,%eax
c0107409:	25 ff 03 00 00       	and    $0x3ff,%eax
c010740e:	c1 e0 02             	shl    $0x2,%eax
c0107411:	01 d0                	add    %edx,%eax
}
c0107413:	c9                   	leave  
c0107414:	c3                   	ret    

c0107415 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0107415:	55                   	push   %ebp
c0107416:	89 e5                	mov    %esp,%ebp
c0107418:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010741b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107422:	00 
c0107423:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010742a:	8b 45 08             	mov    0x8(%ebp),%eax
c010742d:	89 04 24             	mov    %eax,(%esp)
c0107430:	e8 a7 fe ff ff       	call   c01072dc <get_pte>
c0107435:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0107438:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010743c:	74 08                	je     c0107446 <get_page+0x31>
        *ptep_store = ptep;
c010743e:	8b 45 10             	mov    0x10(%ebp),%eax
c0107441:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107444:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0107446:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010744a:	74 1b                	je     c0107467 <get_page+0x52>
c010744c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010744f:	8b 00                	mov    (%eax),%eax
c0107451:	83 e0 01             	and    $0x1,%eax
c0107454:	85 c0                	test   %eax,%eax
c0107456:	74 0f                	je     c0107467 <get_page+0x52>
        return pte2page(*ptep);
c0107458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010745b:	8b 00                	mov    (%eax),%eax
c010745d:	89 04 24             	mov    %eax,(%esp)
c0107460:	e8 3c f5 ff ff       	call   c01069a1 <pte2page>
c0107465:	eb 05                	jmp    c010746c <get_page+0x57>
    }
    return NULL;
c0107467:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010746c:	c9                   	leave  
c010746d:	c3                   	ret    

c010746e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010746e:	55                   	push   %ebp
c010746f:	89 e5                	mov    %esp,%ebp
c0107471:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0107474:	8b 45 10             	mov    0x10(%ebp),%eax
c0107477:	8b 00                	mov    (%eax),%eax
c0107479:	83 e0 01             	and    $0x1,%eax
c010747c:	85 c0                	test   %eax,%eax
c010747e:	74 4d                	je     c01074cd <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0107480:	8b 45 10             	mov    0x10(%ebp),%eax
c0107483:	8b 00                	mov    (%eax),%eax
c0107485:	89 04 24             	mov    %eax,(%esp)
c0107488:	e8 14 f5 ff ff       	call   c01069a1 <pte2page>
c010748d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0107490:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107493:	89 04 24             	mov    %eax,(%esp)
c0107496:	e8 8b f5 ff ff       	call   c0106a26 <page_ref_dec>
c010749b:	85 c0                	test   %eax,%eax
c010749d:	75 13                	jne    c01074b2 <page_remove_pte+0x44>
            free_page(page);
c010749f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01074a6:	00 
c01074a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074aa:	89 04 24             	mov    %eax,(%esp)
c01074ad:	e8 b5 f7 ff ff       	call   c0106c67 <free_pages>
        }
        *ptep = 0;
c01074b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01074b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01074bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01074c5:	89 04 24             	mov    %eax,(%esp)
c01074c8:	e8 01 01 00 00       	call   c01075ce <tlb_invalidate>
    }
}
c01074cd:	90                   	nop
c01074ce:	c9                   	leave  
c01074cf:	c3                   	ret    

c01074d0 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01074d0:	55                   	push   %ebp
c01074d1:	89 e5                	mov    %esp,%ebp
c01074d3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01074d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074dd:	00 
c01074de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01074e8:	89 04 24             	mov    %eax,(%esp)
c01074eb:	e8 ec fd ff ff       	call   c01072dc <get_pte>
c01074f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01074f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01074f7:	74 19                	je     c0107512 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01074f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107503:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107507:	8b 45 08             	mov    0x8(%ebp),%eax
c010750a:	89 04 24             	mov    %eax,(%esp)
c010750d:	e8 5c ff ff ff       	call   c010746e <page_remove_pte>
    }
}
c0107512:	90                   	nop
c0107513:	c9                   	leave  
c0107514:	c3                   	ret    

c0107515 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0107515:	55                   	push   %ebp
c0107516:	89 e5                	mov    %esp,%ebp
c0107518:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010751b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107522:	00 
c0107523:	8b 45 10             	mov    0x10(%ebp),%eax
c0107526:	89 44 24 04          	mov    %eax,0x4(%esp)
c010752a:	8b 45 08             	mov    0x8(%ebp),%eax
c010752d:	89 04 24             	mov    %eax,(%esp)
c0107530:	e8 a7 fd ff ff       	call   c01072dc <get_pte>
c0107535:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0107538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010753c:	75 0a                	jne    c0107548 <page_insert+0x33>
        return -E_NO_MEM;
c010753e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0107543:	e9 84 00 00 00       	jmp    c01075cc <page_insert+0xb7>
    }
    page_ref_inc(page);
c0107548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010754b:	89 04 24             	mov    %eax,(%esp)
c010754e:	e8 bc f4 ff ff       	call   c0106a0f <page_ref_inc>
    if (*ptep & PTE_P) {
c0107553:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107556:	8b 00                	mov    (%eax),%eax
c0107558:	83 e0 01             	and    $0x1,%eax
c010755b:	85 c0                	test   %eax,%eax
c010755d:	74 3e                	je     c010759d <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010755f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107562:	8b 00                	mov    (%eax),%eax
c0107564:	89 04 24             	mov    %eax,(%esp)
c0107567:	e8 35 f4 ff ff       	call   c01069a1 <pte2page>
c010756c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010756f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107572:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107575:	75 0d                	jne    c0107584 <page_insert+0x6f>
            page_ref_dec(page);
c0107577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010757a:	89 04 24             	mov    %eax,(%esp)
c010757d:	e8 a4 f4 ff ff       	call   c0106a26 <page_ref_dec>
c0107582:	eb 19                	jmp    c010759d <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0107584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107587:	89 44 24 08          	mov    %eax,0x8(%esp)
c010758b:	8b 45 10             	mov    0x10(%ebp),%eax
c010758e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107592:	8b 45 08             	mov    0x8(%ebp),%eax
c0107595:	89 04 24             	mov    %eax,(%esp)
c0107598:	e8 d1 fe ff ff       	call   c010746e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010759d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075a0:	89 04 24             	mov    %eax,(%esp)
c01075a3:	e8 4a f3 ff ff       	call   c01068f2 <page2pa>
c01075a8:	0b 45 14             	or     0x14(%ebp),%eax
c01075ab:	83 c8 01             	or     $0x1,%eax
c01075ae:	89 c2                	mov    %eax,%edx
c01075b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075b3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01075b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01075b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01075bf:	89 04 24             	mov    %eax,(%esp)
c01075c2:	e8 07 00 00 00       	call   c01075ce <tlb_invalidate>
    return 0;
c01075c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075cc:	c9                   	leave  
c01075cd:	c3                   	ret    

c01075ce <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01075ce:	55                   	push   %ebp
c01075cf:	89 e5                	mov    %esp,%ebp
c01075d1:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01075d4:	0f 20 d8             	mov    %cr3,%eax
c01075d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01075da:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01075dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01075e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01075e3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01075ea:	77 23                	ja     c010760f <tlb_invalidate+0x41>
c01075ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01075f3:	c7 44 24 08 3c b6 10 	movl   $0xc010b63c,0x8(%esp)
c01075fa:	c0 
c01075fb:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0107602:	00 
c0107603:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c010760a:	e8 f1 8d ff ff       	call   c0100400 <__panic>
c010760f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107612:	05 00 00 00 40       	add    $0x40000000,%eax
c0107617:	39 d0                	cmp    %edx,%eax
c0107619:	75 0c                	jne    c0107627 <tlb_invalidate+0x59>
        invlpg((void *)la);
c010761b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010761e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0107621:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107624:	0f 01 38             	invlpg (%eax)
    }
}
c0107627:	90                   	nop
c0107628:	c9                   	leave  
c0107629:	c3                   	ret    

c010762a <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010762a:	55                   	push   %ebp
c010762b:	89 e5                	mov    %esp,%ebp
c010762d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0107630:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107637:	e8 c0 f5 ff ff       	call   c0106bfc <alloc_pages>
c010763c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010763f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107643:	0f 84 a7 00 00 00    	je     c01076f0 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0107649:	8b 45 10             	mov    0x10(%ebp),%eax
c010764c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107653:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107657:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010765a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010765e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107661:	89 04 24             	mov    %eax,(%esp)
c0107664:	e8 ac fe ff ff       	call   c0107515 <page_insert>
c0107669:	85 c0                	test   %eax,%eax
c010766b:	74 1a                	je     c0107687 <pgdir_alloc_page+0x5d>
            free_page(page);
c010766d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107674:	00 
c0107675:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107678:	89 04 24             	mov    %eax,(%esp)
c010767b:	e8 e7 f5 ff ff       	call   c0106c67 <free_pages>
            return NULL;
c0107680:	b8 00 00 00 00       	mov    $0x0,%eax
c0107685:	eb 6c                	jmp    c01076f3 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0107687:	a1 68 8f 12 c0       	mov    0xc0128f68,%eax
c010768c:	85 c0                	test   %eax,%eax
c010768e:	74 60                	je     c01076f0 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0107690:	a1 58 b0 12 c0       	mov    0xc012b058,%eax
c0107695:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010769c:	00 
c010769d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01076a0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01076a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01076a7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01076ab:	89 04 24             	mov    %eax,(%esp)
c01076ae:	e8 ea c8 ff ff       	call   c0103f9d <swap_map_swappable>
            page->pra_vaddr=la;
c01076b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01076b9:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01076bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076bf:	89 04 24             	mov    %eax,(%esp)
c01076c2:	e8 30 f3 ff ff       	call   c01069f7 <page_ref>
c01076c7:	83 f8 01             	cmp    $0x1,%eax
c01076ca:	74 24                	je     c01076f0 <pgdir_alloc_page+0xc6>
c01076cc:	c7 44 24 0c c0 b6 10 	movl   $0xc010b6c0,0xc(%esp)
c01076d3:	c0 
c01076d4:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c01076db:	c0 
c01076dc:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c01076e3:	00 
c01076e4:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01076eb:	e8 10 8d ff ff       	call   c0100400 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01076f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01076f3:	c9                   	leave  
c01076f4:	c3                   	ret    

c01076f5 <check_alloc_page>:

static void
check_alloc_page(void) {
c01076f5:	55                   	push   %ebp
c01076f6:	89 e5                	mov    %esp,%ebp
c01076f8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01076fb:	a1 38 b1 12 c0       	mov    0xc012b138,%eax
c0107700:	8b 40 18             	mov    0x18(%eax),%eax
c0107703:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0107705:	c7 04 24 d4 b6 10 c0 	movl   $0xc010b6d4,(%esp)
c010770c:	e8 98 8b ff ff       	call   c01002a9 <cprintf>
}
c0107711:	90                   	nop
c0107712:	c9                   	leave  
c0107713:	c3                   	ret    

c0107714 <check_pgdir>:

static void
check_pgdir(void) {
c0107714:	55                   	push   %ebp
c0107715:	89 e5                	mov    %esp,%ebp
c0107717:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010771a:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c010771f:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0107724:	76 24                	jbe    c010774a <check_pgdir+0x36>
c0107726:	c7 44 24 0c f3 b6 10 	movl   $0xc010b6f3,0xc(%esp)
c010772d:	c0 
c010772e:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107735:	c0 
c0107736:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c010773d:	00 
c010773e:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107745:	e8 b6 8c ff ff       	call   c0100400 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010774a:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c010774f:	85 c0                	test   %eax,%eax
c0107751:	74 0e                	je     c0107761 <check_pgdir+0x4d>
c0107753:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107758:	25 ff 0f 00 00       	and    $0xfff,%eax
c010775d:	85 c0                	test   %eax,%eax
c010775f:	74 24                	je     c0107785 <check_pgdir+0x71>
c0107761:	c7 44 24 0c 10 b7 10 	movl   $0xc010b710,0xc(%esp)
c0107768:	c0 
c0107769:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107770:	c0 
c0107771:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0107778:	00 
c0107779:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107780:	e8 7b 8c ff ff       	call   c0100400 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0107785:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c010778a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107791:	00 
c0107792:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107799:	00 
c010779a:	89 04 24             	mov    %eax,(%esp)
c010779d:	e8 73 fc ff ff       	call   c0107415 <get_page>
c01077a2:	85 c0                	test   %eax,%eax
c01077a4:	74 24                	je     c01077ca <check_pgdir+0xb6>
c01077a6:	c7 44 24 0c 48 b7 10 	movl   $0xc010b748,0xc(%esp)
c01077ad:	c0 
c01077ae:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c01077b5:	c0 
c01077b6:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c01077bd:	00 
c01077be:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01077c5:	e8 36 8c ff ff       	call   c0100400 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01077ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01077d1:	e8 26 f4 ff ff       	call   c0106bfc <alloc_pages>
c01077d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01077d9:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01077de:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01077e5:	00 
c01077e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01077ed:	00 
c01077ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01077f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01077f5:	89 04 24             	mov    %eax,(%esp)
c01077f8:	e8 18 fd ff ff       	call   c0107515 <page_insert>
c01077fd:	85 c0                	test   %eax,%eax
c01077ff:	74 24                	je     c0107825 <check_pgdir+0x111>
c0107801:	c7 44 24 0c 70 b7 10 	movl   $0xc010b770,0xc(%esp)
c0107808:	c0 
c0107809:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107810:	c0 
c0107811:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0107818:	00 
c0107819:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107820:	e8 db 8b ff ff       	call   c0100400 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0107825:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c010782a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107831:	00 
c0107832:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107839:	00 
c010783a:	89 04 24             	mov    %eax,(%esp)
c010783d:	e8 9a fa ff ff       	call   c01072dc <get_pte>
c0107842:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107845:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107849:	75 24                	jne    c010786f <check_pgdir+0x15b>
c010784b:	c7 44 24 0c 9c b7 10 	movl   $0xc010b79c,0xc(%esp)
c0107852:	c0 
c0107853:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c010785a:	c0 
c010785b:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0107862:	00 
c0107863:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c010786a:	e8 91 8b ff ff       	call   c0100400 <__panic>
    assert(pte2page(*ptep) == p1);
c010786f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107872:	8b 00                	mov    (%eax),%eax
c0107874:	89 04 24             	mov    %eax,(%esp)
c0107877:	e8 25 f1 ff ff       	call   c01069a1 <pte2page>
c010787c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010787f:	74 24                	je     c01078a5 <check_pgdir+0x191>
c0107881:	c7 44 24 0c c9 b7 10 	movl   $0xc010b7c9,0xc(%esp)
c0107888:	c0 
c0107889:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107890:	c0 
c0107891:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0107898:	00 
c0107899:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01078a0:	e8 5b 8b ff ff       	call   c0100400 <__panic>
    assert(page_ref(p1) == 1);
c01078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078a8:	89 04 24             	mov    %eax,(%esp)
c01078ab:	e8 47 f1 ff ff       	call   c01069f7 <page_ref>
c01078b0:	83 f8 01             	cmp    $0x1,%eax
c01078b3:	74 24                	je     c01078d9 <check_pgdir+0x1c5>
c01078b5:	c7 44 24 0c df b7 10 	movl   $0xc010b7df,0xc(%esp)
c01078bc:	c0 
c01078bd:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c01078c4:	c0 
c01078c5:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01078cc:	00 
c01078cd:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01078d4:	e8 27 8b ff ff       	call   c0100400 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01078d9:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01078de:	8b 00                	mov    (%eax),%eax
c01078e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01078e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01078e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078eb:	c1 e8 0c             	shr    $0xc,%eax
c01078ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01078f1:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c01078f6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01078f9:	72 23                	jb     c010791e <check_pgdir+0x20a>
c01078fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01078fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107902:	c7 44 24 08 98 b5 10 	movl   $0xc010b598,0x8(%esp)
c0107909:	c0 
c010790a:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0107911:	00 
c0107912:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107919:	e8 e2 8a ff ff       	call   c0100400 <__panic>
c010791e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107921:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107926:	83 c0 04             	add    $0x4,%eax
c0107929:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010792c:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107931:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107938:	00 
c0107939:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107940:	00 
c0107941:	89 04 24             	mov    %eax,(%esp)
c0107944:	e8 93 f9 ff ff       	call   c01072dc <get_pte>
c0107949:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010794c:	74 24                	je     c0107972 <check_pgdir+0x25e>
c010794e:	c7 44 24 0c f4 b7 10 	movl   $0xc010b7f4,0xc(%esp)
c0107955:	c0 
c0107956:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c010795d:	c0 
c010795e:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0107965:	00 
c0107966:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c010796d:	e8 8e 8a ff ff       	call   c0100400 <__panic>

    p2 = alloc_page();
c0107972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107979:	e8 7e f2 ff ff       	call   c0106bfc <alloc_pages>
c010797e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107981:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107986:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010798d:	00 
c010798e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107995:	00 
c0107996:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107999:	89 54 24 04          	mov    %edx,0x4(%esp)
c010799d:	89 04 24             	mov    %eax,(%esp)
c01079a0:	e8 70 fb ff ff       	call   c0107515 <page_insert>
c01079a5:	85 c0                	test   %eax,%eax
c01079a7:	74 24                	je     c01079cd <check_pgdir+0x2b9>
c01079a9:	c7 44 24 0c 1c b8 10 	movl   $0xc010b81c,0xc(%esp)
c01079b0:	c0 
c01079b1:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c01079b8:	c0 
c01079b9:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c01079c0:	00 
c01079c1:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01079c8:	e8 33 8a ff ff       	call   c0100400 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01079cd:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c01079d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01079d9:	00 
c01079da:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01079e1:	00 
c01079e2:	89 04 24             	mov    %eax,(%esp)
c01079e5:	e8 f2 f8 ff ff       	call   c01072dc <get_pte>
c01079ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01079f1:	75 24                	jne    c0107a17 <check_pgdir+0x303>
c01079f3:	c7 44 24 0c 54 b8 10 	movl   $0xc010b854,0xc(%esp)
c01079fa:	c0 
c01079fb:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107a02:	c0 
c0107a03:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0107a0a:	00 
c0107a0b:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107a12:	e8 e9 89 ff ff       	call   c0100400 <__panic>
    assert(*ptep & PTE_U);
c0107a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a1a:	8b 00                	mov    (%eax),%eax
c0107a1c:	83 e0 04             	and    $0x4,%eax
c0107a1f:	85 c0                	test   %eax,%eax
c0107a21:	75 24                	jne    c0107a47 <check_pgdir+0x333>
c0107a23:	c7 44 24 0c 84 b8 10 	movl   $0xc010b884,0xc(%esp)
c0107a2a:	c0 
c0107a2b:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107a32:	c0 
c0107a33:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0107a3a:	00 
c0107a3b:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107a42:	e8 b9 89 ff ff       	call   c0100400 <__panic>
    assert(*ptep & PTE_W);
c0107a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a4a:	8b 00                	mov    (%eax),%eax
c0107a4c:	83 e0 02             	and    $0x2,%eax
c0107a4f:	85 c0                	test   %eax,%eax
c0107a51:	75 24                	jne    c0107a77 <check_pgdir+0x363>
c0107a53:	c7 44 24 0c 92 b8 10 	movl   $0xc010b892,0xc(%esp)
c0107a5a:	c0 
c0107a5b:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107a62:	c0 
c0107a63:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0107a6a:	00 
c0107a6b:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107a72:	e8 89 89 ff ff       	call   c0100400 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107a77:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107a7c:	8b 00                	mov    (%eax),%eax
c0107a7e:	83 e0 04             	and    $0x4,%eax
c0107a81:	85 c0                	test   %eax,%eax
c0107a83:	75 24                	jne    c0107aa9 <check_pgdir+0x395>
c0107a85:	c7 44 24 0c a0 b8 10 	movl   $0xc010b8a0,0xc(%esp)
c0107a8c:	c0 
c0107a8d:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107a94:	c0 
c0107a95:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0107a9c:	00 
c0107a9d:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107aa4:	e8 57 89 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 1);
c0107aa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107aac:	89 04 24             	mov    %eax,(%esp)
c0107aaf:	e8 43 ef ff ff       	call   c01069f7 <page_ref>
c0107ab4:	83 f8 01             	cmp    $0x1,%eax
c0107ab7:	74 24                	je     c0107add <check_pgdir+0x3c9>
c0107ab9:	c7 44 24 0c b6 b8 10 	movl   $0xc010b8b6,0xc(%esp)
c0107ac0:	c0 
c0107ac1:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107ac8:	c0 
c0107ac9:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0107ad0:	00 
c0107ad1:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107ad8:	e8 23 89 ff ff       	call   c0100400 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107add:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107ae2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107ae9:	00 
c0107aea:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107af1:	00 
c0107af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107af5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107af9:	89 04 24             	mov    %eax,(%esp)
c0107afc:	e8 14 fa ff ff       	call   c0107515 <page_insert>
c0107b01:	85 c0                	test   %eax,%eax
c0107b03:	74 24                	je     c0107b29 <check_pgdir+0x415>
c0107b05:	c7 44 24 0c c8 b8 10 	movl   $0xc010b8c8,0xc(%esp)
c0107b0c:	c0 
c0107b0d:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107b14:	c0 
c0107b15:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0107b1c:	00 
c0107b1d:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107b24:	e8 d7 88 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p1) == 2);
c0107b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b2c:	89 04 24             	mov    %eax,(%esp)
c0107b2f:	e8 c3 ee ff ff       	call   c01069f7 <page_ref>
c0107b34:	83 f8 02             	cmp    $0x2,%eax
c0107b37:	74 24                	je     c0107b5d <check_pgdir+0x449>
c0107b39:	c7 44 24 0c f4 b8 10 	movl   $0xc010b8f4,0xc(%esp)
c0107b40:	c0 
c0107b41:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107b48:	c0 
c0107b49:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0107b50:	00 
c0107b51:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107b58:	e8 a3 88 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 0);
c0107b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b60:	89 04 24             	mov    %eax,(%esp)
c0107b63:	e8 8f ee ff ff       	call   c01069f7 <page_ref>
c0107b68:	85 c0                	test   %eax,%eax
c0107b6a:	74 24                	je     c0107b90 <check_pgdir+0x47c>
c0107b6c:	c7 44 24 0c 06 b9 10 	movl   $0xc010b906,0xc(%esp)
c0107b73:	c0 
c0107b74:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107b7b:	c0 
c0107b7c:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0107b83:	00 
c0107b84:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107b8b:	e8 70 88 ff ff       	call   c0100400 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107b90:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107b95:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107b9c:	00 
c0107b9d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107ba4:	00 
c0107ba5:	89 04 24             	mov    %eax,(%esp)
c0107ba8:	e8 2f f7 ff ff       	call   c01072dc <get_pte>
c0107bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107bb4:	75 24                	jne    c0107bda <check_pgdir+0x4c6>
c0107bb6:	c7 44 24 0c 54 b8 10 	movl   $0xc010b854,0xc(%esp)
c0107bbd:	c0 
c0107bbe:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107bc5:	c0 
c0107bc6:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0107bcd:	00 
c0107bce:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107bd5:	e8 26 88 ff ff       	call   c0100400 <__panic>
    assert(pte2page(*ptep) == p1);
c0107bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bdd:	8b 00                	mov    (%eax),%eax
c0107bdf:	89 04 24             	mov    %eax,(%esp)
c0107be2:	e8 ba ed ff ff       	call   c01069a1 <pte2page>
c0107be7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0107bea:	74 24                	je     c0107c10 <check_pgdir+0x4fc>
c0107bec:	c7 44 24 0c c9 b7 10 	movl   $0xc010b7c9,0xc(%esp)
c0107bf3:	c0 
c0107bf4:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107bfb:	c0 
c0107bfc:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0107c03:	00 
c0107c04:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107c0b:	e8 f0 87 ff ff       	call   c0100400 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c13:	8b 00                	mov    (%eax),%eax
c0107c15:	83 e0 04             	and    $0x4,%eax
c0107c18:	85 c0                	test   %eax,%eax
c0107c1a:	74 24                	je     c0107c40 <check_pgdir+0x52c>
c0107c1c:	c7 44 24 0c 18 b9 10 	movl   $0xc010b918,0xc(%esp)
c0107c23:	c0 
c0107c24:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107c2b:	c0 
c0107c2c:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0107c33:	00 
c0107c34:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107c3b:	e8 c0 87 ff ff       	call   c0100400 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107c40:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107c45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107c4c:	00 
c0107c4d:	89 04 24             	mov    %eax,(%esp)
c0107c50:	e8 7b f8 ff ff       	call   c01074d0 <page_remove>
    assert(page_ref(p1) == 1);
c0107c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c58:	89 04 24             	mov    %eax,(%esp)
c0107c5b:	e8 97 ed ff ff       	call   c01069f7 <page_ref>
c0107c60:	83 f8 01             	cmp    $0x1,%eax
c0107c63:	74 24                	je     c0107c89 <check_pgdir+0x575>
c0107c65:	c7 44 24 0c df b7 10 	movl   $0xc010b7df,0xc(%esp)
c0107c6c:	c0 
c0107c6d:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107c74:	c0 
c0107c75:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0107c7c:	00 
c0107c7d:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107c84:	e8 77 87 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 0);
c0107c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c8c:	89 04 24             	mov    %eax,(%esp)
c0107c8f:	e8 63 ed ff ff       	call   c01069f7 <page_ref>
c0107c94:	85 c0                	test   %eax,%eax
c0107c96:	74 24                	je     c0107cbc <check_pgdir+0x5a8>
c0107c98:	c7 44 24 0c 06 b9 10 	movl   $0xc010b906,0xc(%esp)
c0107c9f:	c0 
c0107ca0:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107ca7:	c0 
c0107ca8:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0107caf:	00 
c0107cb0:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107cb7:	e8 44 87 ff ff       	call   c0100400 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107cbc:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107cc1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107cc8:	00 
c0107cc9:	89 04 24             	mov    %eax,(%esp)
c0107ccc:	e8 ff f7 ff ff       	call   c01074d0 <page_remove>
    assert(page_ref(p1) == 0);
c0107cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cd4:	89 04 24             	mov    %eax,(%esp)
c0107cd7:	e8 1b ed ff ff       	call   c01069f7 <page_ref>
c0107cdc:	85 c0                	test   %eax,%eax
c0107cde:	74 24                	je     c0107d04 <check_pgdir+0x5f0>
c0107ce0:	c7 44 24 0c 2d b9 10 	movl   $0xc010b92d,0xc(%esp)
c0107ce7:	c0 
c0107ce8:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107cef:	c0 
c0107cf0:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0107cf7:	00 
c0107cf8:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107cff:	e8 fc 86 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p2) == 0);
c0107d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d07:	89 04 24             	mov    %eax,(%esp)
c0107d0a:	e8 e8 ec ff ff       	call   c01069f7 <page_ref>
c0107d0f:	85 c0                	test   %eax,%eax
c0107d11:	74 24                	je     c0107d37 <check_pgdir+0x623>
c0107d13:	c7 44 24 0c 06 b9 10 	movl   $0xc010b906,0xc(%esp)
c0107d1a:	c0 
c0107d1b:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107d22:	c0 
c0107d23:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0107d2a:	00 
c0107d2b:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107d32:	e8 c9 86 ff ff       	call   c0100400 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107d37:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107d3c:	8b 00                	mov    (%eax),%eax
c0107d3e:	89 04 24             	mov    %eax,(%esp)
c0107d41:	e8 99 ec ff ff       	call   c01069df <pde2page>
c0107d46:	89 04 24             	mov    %eax,(%esp)
c0107d49:	e8 a9 ec ff ff       	call   c01069f7 <page_ref>
c0107d4e:	83 f8 01             	cmp    $0x1,%eax
c0107d51:	74 24                	je     c0107d77 <check_pgdir+0x663>
c0107d53:	c7 44 24 0c 40 b9 10 	movl   $0xc010b940,0xc(%esp)
c0107d5a:	c0 
c0107d5b:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107d62:	c0 
c0107d63:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0107d6a:	00 
c0107d6b:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107d72:	e8 89 86 ff ff       	call   c0100400 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0107d77:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107d7c:	8b 00                	mov    (%eax),%eax
c0107d7e:	89 04 24             	mov    %eax,(%esp)
c0107d81:	e8 59 ec ff ff       	call   c01069df <pde2page>
c0107d86:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107d8d:	00 
c0107d8e:	89 04 24             	mov    %eax,(%esp)
c0107d91:	e8 d1 ee ff ff       	call   c0106c67 <free_pages>
    boot_pgdir[0] = 0;
c0107d96:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107d9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107da1:	c7 04 24 67 b9 10 c0 	movl   $0xc010b967,(%esp)
c0107da8:	e8 fc 84 ff ff       	call   c01002a9 <cprintf>
}
c0107dad:	90                   	nop
c0107dae:	c9                   	leave  
c0107daf:	c3                   	ret    

c0107db0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107db0:	55                   	push   %ebp
c0107db1:	89 e5                	mov    %esp,%ebp
c0107db3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107dbd:	e9 ca 00 00 00       	jmp    c0107e8c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107dcb:	c1 e8 0c             	shr    $0xc,%eax
c0107dce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107dd1:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107dd6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0107dd9:	72 23                	jb     c0107dfe <check_boot_pgdir+0x4e>
c0107ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107dde:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107de2:	c7 44 24 08 98 b5 10 	movl   $0xc010b598,0x8(%esp)
c0107de9:	c0 
c0107dea:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0107df1:	00 
c0107df2:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107df9:	e8 02 86 ff ff       	call   c0100400 <__panic>
c0107dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e01:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107e06:	89 c2                	mov    %eax,%edx
c0107e08:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107e0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107e14:	00 
c0107e15:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e19:	89 04 24             	mov    %eax,(%esp)
c0107e1c:	e8 bb f4 ff ff       	call   c01072dc <get_pte>
c0107e21:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107e24:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107e28:	75 24                	jne    c0107e4e <check_boot_pgdir+0x9e>
c0107e2a:	c7 44 24 0c 84 b9 10 	movl   $0xc010b984,0xc(%esp)
c0107e31:	c0 
c0107e32:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107e39:	c0 
c0107e3a:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0107e41:	00 
c0107e42:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107e49:	e8 b2 85 ff ff       	call   c0100400 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0107e4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107e51:	8b 00                	mov    (%eax),%eax
c0107e53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107e58:	89 c2                	mov    %eax,%edx
c0107e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e5d:	39 c2                	cmp    %eax,%edx
c0107e5f:	74 24                	je     c0107e85 <check_boot_pgdir+0xd5>
c0107e61:	c7 44 24 0c c1 b9 10 	movl   $0xc010b9c1,0xc(%esp)
c0107e68:	c0 
c0107e69:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107e70:	c0 
c0107e71:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0107e78:	00 
c0107e79:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107e80:	e8 7b 85 ff ff       	call   c0100400 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0107e85:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0107e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e8f:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0107e94:	39 c2                	cmp    %eax,%edx
c0107e96:	0f 82 26 ff ff ff    	jb     c0107dc2 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0107e9c:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107ea1:	05 ac 0f 00 00       	add    $0xfac,%eax
c0107ea6:	8b 00                	mov    (%eax),%eax
c0107ea8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ead:	89 c2                	mov    %eax,%edx
c0107eaf:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107eb7:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0107ebe:	77 23                	ja     c0107ee3 <check_boot_pgdir+0x133>
c0107ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ec3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ec7:	c7 44 24 08 3c b6 10 	movl   $0xc010b63c,0x8(%esp)
c0107ece:	c0 
c0107ecf:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0107ed6:	00 
c0107ed7:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107ede:	e8 1d 85 ff ff       	call   c0100400 <__panic>
c0107ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ee6:	05 00 00 00 40       	add    $0x40000000,%eax
c0107eeb:	39 d0                	cmp    %edx,%eax
c0107eed:	74 24                	je     c0107f13 <check_boot_pgdir+0x163>
c0107eef:	c7 44 24 0c d8 b9 10 	movl   $0xc010b9d8,0xc(%esp)
c0107ef6:	c0 
c0107ef7:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107efe:	c0 
c0107eff:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0107f06:	00 
c0107f07:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107f0e:	e8 ed 84 ff ff       	call   c0100400 <__panic>

    assert(boot_pgdir[0] == 0);
c0107f13:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107f18:	8b 00                	mov    (%eax),%eax
c0107f1a:	85 c0                	test   %eax,%eax
c0107f1c:	74 24                	je     c0107f42 <check_boot_pgdir+0x192>
c0107f1e:	c7 44 24 0c 0c ba 10 	movl   $0xc010ba0c,0xc(%esp)
c0107f25:	c0 
c0107f26:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107f2d:	c0 
c0107f2e:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0107f35:	00 
c0107f36:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107f3d:	e8 be 84 ff ff       	call   c0100400 <__panic>

    struct Page *p;
    p = alloc_page();
c0107f42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107f49:	e8 ae ec ff ff       	call   c0106bfc <alloc_pages>
c0107f4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0107f51:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107f56:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0107f5d:	00 
c0107f5e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0107f65:	00 
c0107f66:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107f69:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f6d:	89 04 24             	mov    %eax,(%esp)
c0107f70:	e8 a0 f5 ff ff       	call   c0107515 <page_insert>
c0107f75:	85 c0                	test   %eax,%eax
c0107f77:	74 24                	je     c0107f9d <check_boot_pgdir+0x1ed>
c0107f79:	c7 44 24 0c 20 ba 10 	movl   $0xc010ba20,0xc(%esp)
c0107f80:	c0 
c0107f81:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107f88:	c0 
c0107f89:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c0107f90:	00 
c0107f91:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107f98:	e8 63 84 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p) == 1);
c0107f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107fa0:	89 04 24             	mov    %eax,(%esp)
c0107fa3:	e8 4f ea ff ff       	call   c01069f7 <page_ref>
c0107fa8:	83 f8 01             	cmp    $0x1,%eax
c0107fab:	74 24                	je     c0107fd1 <check_boot_pgdir+0x221>
c0107fad:	c7 44 24 0c 4e ba 10 	movl   $0xc010ba4e,0xc(%esp)
c0107fb4:	c0 
c0107fb5:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0107fbc:	c0 
c0107fbd:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0107fc4:	00 
c0107fc5:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0107fcc:	e8 2f 84 ff ff       	call   c0100400 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0107fd1:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0107fd6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0107fdd:	00 
c0107fde:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0107fe5:	00 
c0107fe6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107fe9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fed:	89 04 24             	mov    %eax,(%esp)
c0107ff0:	e8 20 f5 ff ff       	call   c0107515 <page_insert>
c0107ff5:	85 c0                	test   %eax,%eax
c0107ff7:	74 24                	je     c010801d <check_boot_pgdir+0x26d>
c0107ff9:	c7 44 24 0c 60 ba 10 	movl   $0xc010ba60,0xc(%esp)
c0108000:	c0 
c0108001:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0108008:	c0 
c0108009:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0108010:	00 
c0108011:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c0108018:	e8 e3 83 ff ff       	call   c0100400 <__panic>
    assert(page_ref(p) == 2);
c010801d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108020:	89 04 24             	mov    %eax,(%esp)
c0108023:	e8 cf e9 ff ff       	call   c01069f7 <page_ref>
c0108028:	83 f8 02             	cmp    $0x2,%eax
c010802b:	74 24                	je     c0108051 <check_boot_pgdir+0x2a1>
c010802d:	c7 44 24 0c 97 ba 10 	movl   $0xc010ba97,0xc(%esp)
c0108034:	c0 
c0108035:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c010803c:	c0 
c010803d:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0108044:	00 
c0108045:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c010804c:	e8 af 83 ff ff       	call   c0100400 <__panic>

    const char *str = "ucore: Hello world!!";
c0108051:	c7 45 e8 a8 ba 10 c0 	movl   $0xc010baa8,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0108058:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010805b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010805f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108066:	e8 62 11 00 00       	call   c01091cd <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010806b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0108072:	00 
c0108073:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010807a:	e8 c5 11 00 00       	call   c0109244 <strcmp>
c010807f:	85 c0                	test   %eax,%eax
c0108081:	74 24                	je     c01080a7 <check_boot_pgdir+0x2f7>
c0108083:	c7 44 24 0c c0 ba 10 	movl   $0xc010bac0,0xc(%esp)
c010808a:	c0 
c010808b:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c0108092:	c0 
c0108093:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c010809a:	00 
c010809b:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01080a2:	e8 59 83 ff ff       	call   c0100400 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01080a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01080aa:	89 04 24             	mov    %eax,(%esp)
c01080ad:	e8 9b e8 ff ff       	call   c010694d <page2kva>
c01080b2:	05 00 01 00 00       	add    $0x100,%eax
c01080b7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01080ba:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01080c1:	e8 b1 10 00 00       	call   c0109177 <strlen>
c01080c6:	85 c0                	test   %eax,%eax
c01080c8:	74 24                	je     c01080ee <check_boot_pgdir+0x33e>
c01080ca:	c7 44 24 0c f8 ba 10 	movl   $0xc010baf8,0xc(%esp)
c01080d1:	c0 
c01080d2:	c7 44 24 08 85 b6 10 	movl   $0xc010b685,0x8(%esp)
c01080d9:	c0 
c01080da:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c01080e1:	00 
c01080e2:	c7 04 24 60 b6 10 c0 	movl   $0xc010b660,(%esp)
c01080e9:	e8 12 83 ff ff       	call   c0100400 <__panic>

    free_page(p);
c01080ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01080f5:	00 
c01080f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01080f9:	89 04 24             	mov    %eax,(%esp)
c01080fc:	e8 66 eb ff ff       	call   c0106c67 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0108101:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108106:	8b 00                	mov    (%eax),%eax
c0108108:	89 04 24             	mov    %eax,(%esp)
c010810b:	e8 cf e8 ff ff       	call   c01069df <pde2page>
c0108110:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108117:	00 
c0108118:	89 04 24             	mov    %eax,(%esp)
c010811b:	e8 47 eb ff ff       	call   c0106c67 <free_pages>
    boot_pgdir[0] = 0;
c0108120:	a1 20 5a 12 c0       	mov    0xc0125a20,%eax
c0108125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010812b:	c7 04 24 1c bb 10 c0 	movl   $0xc010bb1c,(%esp)
c0108132:	e8 72 81 ff ff       	call   c01002a9 <cprintf>
}
c0108137:	90                   	nop
c0108138:	c9                   	leave  
c0108139:	c3                   	ret    

c010813a <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010813a:	55                   	push   %ebp
c010813b:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010813d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108140:	83 e0 04             	and    $0x4,%eax
c0108143:	85 c0                	test   %eax,%eax
c0108145:	74 04                	je     c010814b <perm2str+0x11>
c0108147:	b0 75                	mov    $0x75,%al
c0108149:	eb 02                	jmp    c010814d <perm2str+0x13>
c010814b:	b0 2d                	mov    $0x2d,%al
c010814d:	a2 08 90 12 c0       	mov    %al,0xc0129008
    str[1] = 'r';
c0108152:	c6 05 09 90 12 c0 72 	movb   $0x72,0xc0129009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0108159:	8b 45 08             	mov    0x8(%ebp),%eax
c010815c:	83 e0 02             	and    $0x2,%eax
c010815f:	85 c0                	test   %eax,%eax
c0108161:	74 04                	je     c0108167 <perm2str+0x2d>
c0108163:	b0 77                	mov    $0x77,%al
c0108165:	eb 02                	jmp    c0108169 <perm2str+0x2f>
c0108167:	b0 2d                	mov    $0x2d,%al
c0108169:	a2 0a 90 12 c0       	mov    %al,0xc012900a
    str[3] = '\0';
c010816e:	c6 05 0b 90 12 c0 00 	movb   $0x0,0xc012900b
    return str;
c0108175:	b8 08 90 12 c0       	mov    $0xc0129008,%eax
}
c010817a:	5d                   	pop    %ebp
c010817b:	c3                   	ret    

c010817c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010817c:	55                   	push   %ebp
c010817d:	89 e5                	mov    %esp,%ebp
c010817f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0108182:	8b 45 10             	mov    0x10(%ebp),%eax
c0108185:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108188:	72 0d                	jb     c0108197 <get_pgtable_items+0x1b>
        return 0;
c010818a:	b8 00 00 00 00       	mov    $0x0,%eax
c010818f:	e9 98 00 00 00       	jmp    c010822c <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0108194:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0108197:	8b 45 10             	mov    0x10(%ebp),%eax
c010819a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010819d:	73 18                	jae    c01081b7 <get_pgtable_items+0x3b>
c010819f:	8b 45 10             	mov    0x10(%ebp),%eax
c01081a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01081a9:	8b 45 14             	mov    0x14(%ebp),%eax
c01081ac:	01 d0                	add    %edx,%eax
c01081ae:	8b 00                	mov    (%eax),%eax
c01081b0:	83 e0 01             	and    $0x1,%eax
c01081b3:	85 c0                	test   %eax,%eax
c01081b5:	74 dd                	je     c0108194 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01081b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01081ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01081bd:	73 68                	jae    c0108227 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01081bf:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01081c3:	74 08                	je     c01081cd <get_pgtable_items+0x51>
            *left_store = start;
c01081c5:	8b 45 18             	mov    0x18(%ebp),%eax
c01081c8:	8b 55 10             	mov    0x10(%ebp),%edx
c01081cb:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01081cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01081d0:	8d 50 01             	lea    0x1(%eax),%edx
c01081d3:	89 55 10             	mov    %edx,0x10(%ebp)
c01081d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01081dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01081e0:	01 d0                	add    %edx,%eax
c01081e2:	8b 00                	mov    (%eax),%eax
c01081e4:	83 e0 07             	and    $0x7,%eax
c01081e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01081ea:	eb 03                	jmp    c01081ef <get_pgtable_items+0x73>
            start ++;
c01081ec:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01081ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01081f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01081f5:	73 1d                	jae    c0108214 <get_pgtable_items+0x98>
c01081f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01081fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108201:	8b 45 14             	mov    0x14(%ebp),%eax
c0108204:	01 d0                	add    %edx,%eax
c0108206:	8b 00                	mov    (%eax),%eax
c0108208:	83 e0 07             	and    $0x7,%eax
c010820b:	89 c2                	mov    %eax,%edx
c010820d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108210:	39 c2                	cmp    %eax,%edx
c0108212:	74 d8                	je     c01081ec <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0108214:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108218:	74 08                	je     c0108222 <get_pgtable_items+0xa6>
            *right_store = start;
c010821a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010821d:	8b 55 10             	mov    0x10(%ebp),%edx
c0108220:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0108222:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108225:	eb 05                	jmp    c010822c <get_pgtable_items+0xb0>
    }
    return 0;
c0108227:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010822c:	c9                   	leave  
c010822d:	c3                   	ret    

c010822e <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010822e:	55                   	push   %ebp
c010822f:	89 e5                	mov    %esp,%ebp
c0108231:	57                   	push   %edi
c0108232:	56                   	push   %esi
c0108233:	53                   	push   %ebx
c0108234:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0108237:	c7 04 24 3c bb 10 c0 	movl   $0xc010bb3c,(%esp)
c010823e:	e8 66 80 ff ff       	call   c01002a9 <cprintf>
    size_t left, right = 0, perm;
c0108243:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010824a:	e9 fa 00 00 00       	jmp    c0108349 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010824f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108252:	89 04 24             	mov    %eax,(%esp)
c0108255:	e8 e0 fe ff ff       	call   c010813a <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010825a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010825d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108260:	29 d1                	sub    %edx,%ecx
c0108262:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0108264:	89 d6                	mov    %edx,%esi
c0108266:	c1 e6 16             	shl    $0x16,%esi
c0108269:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010826c:	89 d3                	mov    %edx,%ebx
c010826e:	c1 e3 16             	shl    $0x16,%ebx
c0108271:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108274:	89 d1                	mov    %edx,%ecx
c0108276:	c1 e1 16             	shl    $0x16,%ecx
c0108279:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010827c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010827f:	29 d7                	sub    %edx,%edi
c0108281:	89 fa                	mov    %edi,%edx
c0108283:	89 44 24 14          	mov    %eax,0x14(%esp)
c0108287:	89 74 24 10          	mov    %esi,0x10(%esp)
c010828b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010828f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108293:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108297:	c7 04 24 6d bb 10 c0 	movl   $0xc010bb6d,(%esp)
c010829e:	e8 06 80 ff ff       	call   c01002a9 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01082a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082a6:	c1 e0 0a             	shl    $0xa,%eax
c01082a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01082ac:	eb 54                	jmp    c0108302 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01082ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082b1:	89 04 24             	mov    %eax,(%esp)
c01082b4:	e8 81 fe ff ff       	call   c010813a <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01082b9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01082bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01082bf:	29 d1                	sub    %edx,%ecx
c01082c1:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01082c3:	89 d6                	mov    %edx,%esi
c01082c5:	c1 e6 0c             	shl    $0xc,%esi
c01082c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01082cb:	89 d3                	mov    %edx,%ebx
c01082cd:	c1 e3 0c             	shl    $0xc,%ebx
c01082d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01082d3:	89 d1                	mov    %edx,%ecx
c01082d5:	c1 e1 0c             	shl    $0xc,%ecx
c01082d8:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01082db:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01082de:	29 d7                	sub    %edx,%edi
c01082e0:	89 fa                	mov    %edi,%edx
c01082e2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01082e6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01082ea:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01082ee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01082f2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01082f6:	c7 04 24 8c bb 10 c0 	movl   $0xc010bb8c,(%esp)
c01082fd:	e8 a7 7f ff ff       	call   c01002a9 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108302:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0108307:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010830a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010830d:	89 d3                	mov    %edx,%ebx
c010830f:	c1 e3 0a             	shl    $0xa,%ebx
c0108312:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108315:	89 d1                	mov    %edx,%ecx
c0108317:	c1 e1 0a             	shl    $0xa,%ecx
c010831a:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010831d:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108321:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0108324:	89 54 24 10          	mov    %edx,0x10(%esp)
c0108328:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010832c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108330:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0108334:	89 0c 24             	mov    %ecx,(%esp)
c0108337:	e8 40 fe ff ff       	call   c010817c <get_pgtable_items>
c010833c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010833f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108343:	0f 85 65 ff ff ff    	jne    c01082ae <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0108349:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010834e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108351:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0108354:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108358:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010835b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010835f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108363:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108367:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010836e:	00 
c010836f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108376:	e8 01 fe ff ff       	call   c010817c <get_pgtable_items>
c010837b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010837e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108382:	0f 85 c7 fe ff ff    	jne    c010824f <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0108388:	c7 04 24 b0 bb 10 c0 	movl   $0xc010bbb0,(%esp)
c010838f:	e8 15 7f ff ff       	call   c01002a9 <cprintf>
}
c0108394:	90                   	nop
c0108395:	83 c4 4c             	add    $0x4c,%esp
c0108398:	5b                   	pop    %ebx
c0108399:	5e                   	pop    %esi
c010839a:	5f                   	pop    %edi
c010839b:	5d                   	pop    %ebp
c010839c:	c3                   	ret    

c010839d <page2ppn>:
page2ppn(struct Page *page) {
c010839d:	55                   	push   %ebp
c010839e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01083a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01083a3:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c01083a9:	29 d0                	sub    %edx,%eax
c01083ab:	c1 f8 05             	sar    $0x5,%eax
}
c01083ae:	5d                   	pop    %ebp
c01083af:	c3                   	ret    

c01083b0 <page2pa>:
page2pa(struct Page *page) {
c01083b0:	55                   	push   %ebp
c01083b1:	89 e5                	mov    %esp,%ebp
c01083b3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01083b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01083b9:	89 04 24             	mov    %eax,(%esp)
c01083bc:	e8 dc ff ff ff       	call   c010839d <page2ppn>
c01083c1:	c1 e0 0c             	shl    $0xc,%eax
}
c01083c4:	c9                   	leave  
c01083c5:	c3                   	ret    

c01083c6 <page2kva>:
page2kva(struct Page *page) {
c01083c6:	55                   	push   %ebp
c01083c7:	89 e5                	mov    %esp,%ebp
c01083c9:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01083cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01083cf:	89 04 24             	mov    %eax,(%esp)
c01083d2:	e8 d9 ff ff ff       	call   c01083b0 <page2pa>
c01083d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01083da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083dd:	c1 e8 0c             	shr    $0xc,%eax
c01083e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083e3:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c01083e8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01083eb:	72 23                	jb     c0108410 <page2kva+0x4a>
c01083ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01083f4:	c7 44 24 08 e4 bb 10 	movl   $0xc010bbe4,0x8(%esp)
c01083fb:	c0 
c01083fc:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108403:	00 
c0108404:	c7 04 24 07 bc 10 c0 	movl   $0xc010bc07,(%esp)
c010840b:	e8 f0 7f ff ff       	call   c0100400 <__panic>
c0108410:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108413:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108418:	c9                   	leave  
c0108419:	c3                   	ret    

c010841a <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c010841a:	55                   	push   %ebp
c010841b:	89 e5                	mov    %esp,%ebp
c010841d:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108420:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108427:	e8 18 8c ff ff       	call   c0101044 <ide_device_valid>
c010842c:	85 c0                	test   %eax,%eax
c010842e:	75 1c                	jne    c010844c <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108430:	c7 44 24 08 15 bc 10 	movl   $0xc010bc15,0x8(%esp)
c0108437:	c0 
c0108438:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c010843f:	00 
c0108440:	c7 04 24 2f bc 10 c0 	movl   $0xc010bc2f,(%esp)
c0108447:	e8 b4 7f ff ff       	call   c0100400 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010844c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108453:	e8 2a 8c ff ff       	call   c0101082 <ide_device_size>
c0108458:	c1 e8 03             	shr    $0x3,%eax
c010845b:	a3 fc b0 12 c0       	mov    %eax,0xc012b0fc
}
c0108460:	90                   	nop
c0108461:	c9                   	leave  
c0108462:	c3                   	ret    

c0108463 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108463:	55                   	push   %ebp
c0108464:	89 e5                	mov    %esp,%ebp
c0108466:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108469:	8b 45 0c             	mov    0xc(%ebp),%eax
c010846c:	89 04 24             	mov    %eax,(%esp)
c010846f:	e8 52 ff ff ff       	call   c01083c6 <page2kva>
c0108474:	8b 55 08             	mov    0x8(%ebp),%edx
c0108477:	c1 ea 08             	shr    $0x8,%edx
c010847a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010847d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108481:	74 0b                	je     c010848e <swapfs_read+0x2b>
c0108483:	8b 15 fc b0 12 c0    	mov    0xc012b0fc,%edx
c0108489:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010848c:	72 23                	jb     c01084b1 <swapfs_read+0x4e>
c010848e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108491:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108495:	c7 44 24 08 40 bc 10 	movl   $0xc010bc40,0x8(%esp)
c010849c:	c0 
c010849d:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01084a4:	00 
c01084a5:	c7 04 24 2f bc 10 c0 	movl   $0xc010bc2f,(%esp)
c01084ac:	e8 4f 7f ff ff       	call   c0100400 <__panic>
c01084b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084b4:	c1 e2 03             	shl    $0x3,%edx
c01084b7:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01084be:	00 
c01084bf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084c3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01084c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01084ce:	e8 ea 8b ff ff       	call   c01010bd <ide_read_secs>
}
c01084d3:	c9                   	leave  
c01084d4:	c3                   	ret    

c01084d5 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01084d5:	55                   	push   %ebp
c01084d6:	89 e5                	mov    %esp,%ebp
c01084d8:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01084db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084de:	89 04 24             	mov    %eax,(%esp)
c01084e1:	e8 e0 fe ff ff       	call   c01083c6 <page2kva>
c01084e6:	8b 55 08             	mov    0x8(%ebp),%edx
c01084e9:	c1 ea 08             	shr    $0x8,%edx
c01084ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01084ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01084f3:	74 0b                	je     c0108500 <swapfs_write+0x2b>
c01084f5:	8b 15 fc b0 12 c0    	mov    0xc012b0fc,%edx
c01084fb:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01084fe:	72 23                	jb     c0108523 <swapfs_write+0x4e>
c0108500:	8b 45 08             	mov    0x8(%ebp),%eax
c0108503:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108507:	c7 44 24 08 40 bc 10 	movl   $0xc010bc40,0x8(%esp)
c010850e:	c0 
c010850f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108516:	00 
c0108517:	c7 04 24 2f bc 10 c0 	movl   $0xc010bc2f,(%esp)
c010851e:	e8 dd 7e ff ff       	call   c0100400 <__panic>
c0108523:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108526:	c1 e2 03             	shl    $0x3,%edx
c0108529:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108530:	00 
c0108531:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108535:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108540:	e8 b1 8d ff ff       	call   c01012f6 <ide_write_secs>
}
c0108545:	c9                   	leave  
c0108546:	c3                   	ret    

c0108547 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108547:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010854b:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)          # save esp::context of from
c010854d:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)          # save ebx::context of from
c0108550:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)         # save ecx::context of from
c0108553:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)         # save edx::context of from
c0108556:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)         # save esi::context of from
c0108559:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)         # save edi::context of from
c010855c:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)         # save ebp::context of from
c010855f:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108562:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp         # restore ebp::context of to
c0108566:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi         # restore edi::context of to
c0108569:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi         # restore esi::context of to
c010856c:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx         # restore edx::context of to
c010856f:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx         # restore ecx::context of to
c0108572:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx          # restore ebx::context of to
c0108575:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp          # restore esp::context of to
c0108578:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010857b:	ff 30                	pushl  (%eax)

    ret
c010857d:	c3                   	ret    

c010857e <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010857e:	52                   	push   %edx
    call *%ebx              # call fn
c010857f:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108581:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108582:	e8 51 08 00 00       	call   c0108dd8 <do_exit>

c0108587 <__intr_save>:
__intr_save(void) {
c0108587:	55                   	push   %ebp
c0108588:	89 e5                	mov    %esp,%ebp
c010858a:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010858d:	9c                   	pushf  
c010858e:	58                   	pop    %eax
c010858f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108592:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108595:	25 00 02 00 00       	and    $0x200,%eax
c010859a:	85 c0                	test   %eax,%eax
c010859c:	74 0c                	je     c01085aa <__intr_save+0x23>
        intr_disable();
c010859e:	e8 8f 9a ff ff       	call   c0102032 <intr_disable>
        return 1;
c01085a3:	b8 01 00 00 00       	mov    $0x1,%eax
c01085a8:	eb 05                	jmp    c01085af <__intr_save+0x28>
    return 0;
c01085aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01085af:	c9                   	leave  
c01085b0:	c3                   	ret    

c01085b1 <__intr_restore>:
__intr_restore(bool flag) {
c01085b1:	55                   	push   %ebp
c01085b2:	89 e5                	mov    %esp,%ebp
c01085b4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01085b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01085bb:	74 05                	je     c01085c2 <__intr_restore+0x11>
        intr_enable();
c01085bd:	e8 69 9a ff ff       	call   c010202b <intr_enable>
}
c01085c2:	90                   	nop
c01085c3:	c9                   	leave  
c01085c4:	c3                   	ret    

c01085c5 <page2ppn>:
page2ppn(struct Page *page) {
c01085c5:	55                   	push   %ebp
c01085c6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01085c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01085cb:	8b 15 40 b1 12 c0    	mov    0xc012b140,%edx
c01085d1:	29 d0                	sub    %edx,%eax
c01085d3:	c1 f8 05             	sar    $0x5,%eax
}
c01085d6:	5d                   	pop    %ebp
c01085d7:	c3                   	ret    

c01085d8 <page2pa>:
page2pa(struct Page *page) {
c01085d8:	55                   	push   %ebp
c01085d9:	89 e5                	mov    %esp,%ebp
c01085db:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01085de:	8b 45 08             	mov    0x8(%ebp),%eax
c01085e1:	89 04 24             	mov    %eax,(%esp)
c01085e4:	e8 dc ff ff ff       	call   c01085c5 <page2ppn>
c01085e9:	c1 e0 0c             	shl    $0xc,%eax
}
c01085ec:	c9                   	leave  
c01085ed:	c3                   	ret    

c01085ee <pa2page>:
pa2page(uintptr_t pa) {
c01085ee:	55                   	push   %ebp
c01085ef:	89 e5                	mov    %esp,%ebp
c01085f1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01085f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01085f7:	c1 e8 0c             	shr    $0xc,%eax
c01085fa:	89 c2                	mov    %eax,%edx
c01085fc:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0108601:	39 c2                	cmp    %eax,%edx
c0108603:	72 1c                	jb     c0108621 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0108605:	c7 44 24 08 60 bc 10 	movl   $0xc010bc60,0x8(%esp)
c010860c:	c0 
c010860d:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0108614:	00 
c0108615:	c7 04 24 7f bc 10 c0 	movl   $0xc010bc7f,(%esp)
c010861c:	e8 df 7d ff ff       	call   c0100400 <__panic>
    return &pages[PPN(pa)];
c0108621:	a1 40 b1 12 c0       	mov    0xc012b140,%eax
c0108626:	8b 55 08             	mov    0x8(%ebp),%edx
c0108629:	c1 ea 0c             	shr    $0xc,%edx
c010862c:	c1 e2 05             	shl    $0x5,%edx
c010862f:	01 d0                	add    %edx,%eax
}
c0108631:	c9                   	leave  
c0108632:	c3                   	ret    

c0108633 <page2kva>:
page2kva(struct Page *page) {
c0108633:	55                   	push   %ebp
c0108634:	89 e5                	mov    %esp,%ebp
c0108636:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108639:	8b 45 08             	mov    0x8(%ebp),%eax
c010863c:	89 04 24             	mov    %eax,(%esp)
c010863f:	e8 94 ff ff ff       	call   c01085d8 <page2pa>
c0108644:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010864a:	c1 e8 0c             	shr    $0xc,%eax
c010864d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108650:	a1 80 8f 12 c0       	mov    0xc0128f80,%eax
c0108655:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108658:	72 23                	jb     c010867d <page2kva+0x4a>
c010865a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010865d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108661:	c7 44 24 08 90 bc 10 	movl   $0xc010bc90,0x8(%esp)
c0108668:	c0 
c0108669:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108670:	00 
c0108671:	c7 04 24 7f bc 10 c0 	movl   $0xc010bc7f,(%esp)
c0108678:	e8 83 7d ff ff       	call   c0100400 <__panic>
c010867d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108680:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108685:	c9                   	leave  
c0108686:	c3                   	ret    

c0108687 <kva2page>:
kva2page(void *kva) {
c0108687:	55                   	push   %ebp
c0108688:	89 e5                	mov    %esp,%ebp
c010868a:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010868d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108690:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108693:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010869a:	77 23                	ja     c01086bf <kva2page+0x38>
c010869c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010869f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086a3:	c7 44 24 08 b4 bc 10 	movl   $0xc010bcb4,0x8(%esp)
c01086aa:	c0 
c01086ab:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01086b2:	00 
c01086b3:	c7 04 24 7f bc 10 c0 	movl   $0xc010bc7f,(%esp)
c01086ba:	e8 41 7d ff ff       	call   c0100400 <__panic>
c01086bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086c2:	05 00 00 00 40       	add    $0x40000000,%eax
c01086c7:	89 04 24             	mov    %eax,(%esp)
c01086ca:	e8 1f ff ff ff       	call   c01085ee <pa2page>
}
c01086cf:	c9                   	leave  
c01086d0:	c3                   	ret    

c01086d1 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
// alloc_proc -负责创建并初始化一个新的proc_struct结构存储内核线程信息
static struct proc_struct *
alloc_proc(void) {
c01086d1:	55                   	push   %ebp
c01086d2:	89 e5                	mov    %esp,%ebp
c01086d4:	83 ec 28             	sub    $0x28,%esp
    //为创建的线程申请空间
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01086d7:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c01086de:	e8 85 c9 ff ff       	call   c0105068 <kmalloc>
c01086e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01086e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01086ea:	0f 84 a1 00 00 00    	je     c0108791 <alloc_proc+0xc0>
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        //因为没有分配物理页，故将线程状态设置为未初始化状态
        proc->state=PROC_UNINIT;
c01086f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid=-1; 
c01086f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086fc:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->runs=0; 
c0108703:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108706:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack=0; 
c010870d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108710:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched=0; 
c0108717:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010871a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent=NULL; 
c0108721:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108724:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm=NULL;
c010872b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010872e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc -> context), 0, sizeof(struct context)); 
c0108735:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108738:	83 c0 1c             	add    $0x1c,%eax
c010873b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108742:	00 
c0108743:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010874a:	00 
c010874b:	89 04 24             	mov    %eax,(%esp)
c010874e:	e8 44 0d 00 00       	call   c0109497 <memset>
        proc->tf=NULL;
c0108753:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108756:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3=boot_cr3;
c010875d:	8b 15 3c b1 12 c0    	mov    0xc012b13c,%edx
c0108763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108766:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags=0;
c0108769:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010876c:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc -> name, 0, PROC_NAME_LEN);
c0108773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108776:	83 c0 48             	add    $0x48,%eax
c0108779:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108780:	00 
c0108781:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108788:	00 
c0108789:	89 04 24             	mov    %eax,(%esp)
c010878c:	e8 06 0d 00 00       	call   c0109497 <memset>
    }
    return proc;
c0108791:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108794:	c9                   	leave  
c0108795:	c3                   	ret    

c0108796 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108796:	55                   	push   %ebp
c0108797:	89 e5                	mov    %esp,%ebp
c0108799:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c010879c:	8b 45 08             	mov    0x8(%ebp),%eax
c010879f:	83 c0 48             	add    $0x48,%eax
c01087a2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01087a9:	00 
c01087aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01087b1:	00 
c01087b2:	89 04 24             	mov    %eax,(%esp)
c01087b5:	e8 dd 0c 00 00       	call   c0109497 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01087ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01087bd:	8d 50 48             	lea    0x48(%eax),%edx
c01087c0:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01087c7:	00 
c01087c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087cf:	89 14 24             	mov    %edx,(%esp)
c01087d2:	e8 a3 0d 00 00       	call   c010957a <memcpy>
}
c01087d7:	c9                   	leave  
c01087d8:	c3                   	ret    

c01087d9 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c01087d9:	55                   	push   %ebp
c01087da:	89 e5                	mov    %esp,%ebp
c01087dc:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c01087df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01087e6:	00 
c01087e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01087ee:	00 
c01087ef:	c7 04 24 44 b0 12 c0 	movl   $0xc012b044,(%esp)
c01087f6:	e8 9c 0c 00 00       	call   c0109497 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01087fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fe:	83 c0 48             	add    $0x48,%eax
c0108801:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108808:	00 
c0108809:	89 44 24 04          	mov    %eax,0x4(%esp)
c010880d:	c7 04 24 44 b0 12 c0 	movl   $0xc012b044,(%esp)
c0108814:	e8 61 0d 00 00       	call   c010957a <memcpy>
}
c0108819:	c9                   	leave  
c010881a:	c3                   	ret    

c010881b <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c010881b:	55                   	push   %ebp
c010881c:	89 e5                	mov    %esp,%ebp
c010881e:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108821:	c7 45 f8 44 b1 12 c0 	movl   $0xc012b144,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0108828:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c010882d:	40                   	inc    %eax
c010882e:	a3 78 5a 12 c0       	mov    %eax,0xc0125a78
c0108833:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108838:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c010883d:	7e 0c                	jle    c010884b <get_pid+0x30>
        last_pid = 1;
c010883f:	c7 05 78 5a 12 c0 01 	movl   $0x1,0xc0125a78
c0108846:	00 00 00 
        goto inside;
c0108849:	eb 14                	jmp    c010885f <get_pid+0x44>
    }
    if (last_pid >= next_safe) {
c010884b:	8b 15 78 5a 12 c0    	mov    0xc0125a78,%edx
c0108851:	a1 7c 5a 12 c0       	mov    0xc0125a7c,%eax
c0108856:	39 c2                	cmp    %eax,%edx
c0108858:	0f 8c ab 00 00 00    	jl     c0108909 <get_pid+0xee>
    inside:
c010885e:	90                   	nop
        next_safe = MAX_PID;
c010885f:	c7 05 7c 5a 12 c0 00 	movl   $0x2000,0xc0125a7c
c0108866:	20 00 00 
    repeat:
        le = list;
c0108869:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010886c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c010886f:	eb 7d                	jmp    c01088ee <get_pid+0xd3>
            proc = le2proc(le, list_link);
c0108871:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108874:	83 e8 58             	sub    $0x58,%eax
c0108877:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c010887a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010887d:	8b 50 04             	mov    0x4(%eax),%edx
c0108880:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c0108885:	39 c2                	cmp    %eax,%edx
c0108887:	75 3c                	jne    c01088c5 <get_pid+0xaa>
                if (++ last_pid >= next_safe) {
c0108889:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c010888e:	40                   	inc    %eax
c010888f:	a3 78 5a 12 c0       	mov    %eax,0xc0125a78
c0108894:	8b 15 78 5a 12 c0    	mov    0xc0125a78,%edx
c010889a:	a1 7c 5a 12 c0       	mov    0xc0125a7c,%eax
c010889f:	39 c2                	cmp    %eax,%edx
c01088a1:	7c 4b                	jl     c01088ee <get_pid+0xd3>
                    if (last_pid >= MAX_PID) {
c01088a3:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c01088a8:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01088ad:	7e 0a                	jle    c01088b9 <get_pid+0x9e>
                        last_pid = 1;
c01088af:	c7 05 78 5a 12 c0 01 	movl   $0x1,0xc0125a78
c01088b6:	00 00 00 
                    }
                    next_safe = MAX_PID;
c01088b9:	c7 05 7c 5a 12 c0 00 	movl   $0x2000,0xc0125a7c
c01088c0:	20 00 00 
                    goto repeat;
c01088c3:	eb a4                	jmp    c0108869 <get_pid+0x4e>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c01088c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088c8:	8b 50 04             	mov    0x4(%eax),%edx
c01088cb:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
c01088d0:	39 c2                	cmp    %eax,%edx
c01088d2:	7e 1a                	jle    c01088ee <get_pid+0xd3>
c01088d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088d7:	8b 50 04             	mov    0x4(%eax),%edx
c01088da:	a1 7c 5a 12 c0       	mov    0xc0125a7c,%eax
c01088df:	39 c2                	cmp    %eax,%edx
c01088e1:	7d 0b                	jge    c01088ee <get_pid+0xd3>
                next_safe = proc->pid;
c01088e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088e6:	8b 40 04             	mov    0x4(%eax),%eax
c01088e9:	a3 7c 5a 12 c0       	mov    %eax,0xc0125a7c
c01088ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01088f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01088f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088f7:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c01088fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01088fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108900:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108903:	0f 85 68 ff ff ff    	jne    c0108871 <get_pid+0x56>
            }
        }
    }
    return last_pid;
c0108909:	a1 78 5a 12 c0       	mov    0xc0125a78,%eax
}
c010890e:	c9                   	leave  
c010890f:	c3                   	ret    

c0108910 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108910:	55                   	push   %ebp
c0108911:	89 e5                	mov    %esp,%ebp
c0108913:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0108916:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c010891b:	39 45 08             	cmp    %eax,0x8(%ebp)
c010891e:	74 63                	je     c0108983 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108920:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108925:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108928:	8b 45 08             	mov    0x8(%ebp),%eax
c010892b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c010892e:	e8 54 fc ff ff       	call   c0108587 <__intr_save>
c0108933:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108936:	8b 45 08             	mov    0x8(%ebp),%eax
c0108939:	a3 28 90 12 c0       	mov    %eax,0xc0129028
            load_esp0(next->kstack + KSTACKSIZE);
c010893e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108941:	8b 40 0c             	mov    0xc(%eax),%eax
c0108944:	05 00 20 00 00       	add    $0x2000,%eax
c0108949:	89 04 24             	mov    %eax,(%esp)
c010894c:	e8 60 e1 ff ff       	call   c0106ab1 <load_esp0>
            lcr3(next->cr3);
c0108951:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108954:	8b 40 40             	mov    0x40(%eax),%eax
c0108957:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010895a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010895d:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108960:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108963:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108966:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108969:	83 c0 1c             	add    $0x1c,%eax
c010896c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108970:	89 04 24             	mov    %eax,(%esp)
c0108973:	e8 cf fb ff ff       	call   c0108547 <switch_to>
        }
        local_intr_restore(intr_flag);
c0108978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010897b:	89 04 24             	mov    %eax,(%esp)
c010897e:	e8 2e fc ff ff       	call   c01085b1 <__intr_restore>
    }
}
c0108983:	90                   	nop
c0108984:	c9                   	leave  
c0108985:	c3                   	ret    

c0108986 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108986:	55                   	push   %ebp
c0108987:	89 e5                	mov    %esp,%ebp
c0108989:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c010898c:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108991:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108994:	89 04 24             	mov    %eax,(%esp)
c0108997:	e8 90 a7 ff ff       	call   c010312c <forkrets>
}
c010899c:	90                   	nop
c010899d:	c9                   	leave  
c010899e:	c3                   	ret    

c010899f <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c010899f:	55                   	push   %ebp
c01089a0:	89 e5                	mov    %esp,%ebp
c01089a2:	53                   	push   %ebx
c01089a3:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c01089a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01089a9:	8d 58 60             	lea    0x60(%eax),%ebx
c01089ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01089af:	8b 40 04             	mov    0x4(%eax),%eax
c01089b2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01089b9:	00 
c01089ba:	89 04 24             	mov    %eax,(%esp)
c01089bd:	e8 cf 12 00 00       	call   c0109c91 <hash32>
c01089c2:	c1 e0 03             	shl    $0x3,%eax
c01089c5:	05 40 90 12 c0       	add    $0xc0129040,%eax
c01089ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089cd:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c01089d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01089d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_add(elm, listelm, listelm->next);
c01089dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089df:	8b 40 04             	mov    0x4(%eax),%eax
c01089e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01089e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01089e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01089eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01089ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
    prev->next = next->prev = elm;
c01089f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01089f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01089f7:	89 10                	mov    %edx,(%eax)
c01089f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01089fc:	8b 10                	mov    (%eax),%edx
c01089fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108a01:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a07:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108a0a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a10:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108a13:	89 10                	mov    %edx,(%eax)
}
c0108a15:	90                   	nop
c0108a16:	83 c4 34             	add    $0x34,%esp
c0108a19:	5b                   	pop    %ebx
c0108a1a:	5d                   	pop    %ebp
c0108a1b:	c3                   	ret    

c0108a1c <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108a1c:	55                   	push   %ebp
c0108a1d:	89 e5                	mov    %esp,%ebp
c0108a1f:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108a26:	7e 5f                	jle    c0108a87 <find_proc+0x6b>
c0108a28:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108a2f:	7f 56                	jg     c0108a87 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a34:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108a3b:	00 
c0108a3c:	89 04 24             	mov    %eax,(%esp)
c0108a3f:	e8 4d 12 00 00       	call   c0109c91 <hash32>
c0108a44:	c1 e0 03             	shl    $0x3,%eax
c0108a47:	05 40 90 12 c0       	add    $0xc0129040,%eax
c0108a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108a55:	eb 19                	jmp    c0108a70 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a5a:	83 e8 60             	sub    $0x60,%eax
c0108a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a63:	8b 40 04             	mov    0x4(%eax),%eax
c0108a66:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108a69:	75 05                	jne    c0108a70 <find_proc+0x54>
                return proc;
c0108a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a6e:	eb 1c                	jmp    c0108a8c <find_proc+0x70>
c0108a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a73:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return listelm->next;
c0108a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a79:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0108a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a82:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108a85:	75 d0                	jne    c0108a57 <find_proc+0x3b>
            }
        }
    }
    return NULL;
c0108a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108a8c:	c9                   	leave  
c0108a8d:	c3                   	ret    

c0108a8e <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108a8e:	55                   	push   %ebp
c0108a8f:	89 e5                	mov    %esp,%ebp
c0108a91:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108a94:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0108a9b:	00 
c0108a9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108aa3:	00 
c0108aa4:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108aa7:	89 04 24             	mov    %eax,(%esp)
c0108aaa:	e8 e8 09 00 00       	call   c0109497 <memset>
    tf.tf_cs = KERNEL_CS;
c0108aaf:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108ab5:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108abb:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108abf:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108ac3:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108ac7:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ace:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ad4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108ad7:	b8 7e 85 10 c0       	mov    $0xc010857e,%eax
c0108adc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108adf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ae2:	0d 00 01 00 00       	or     $0x100,%eax
c0108ae7:	89 c2                	mov    %eax,%edx
c0108ae9:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108aec:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108af7:	00 
c0108af8:	89 14 24             	mov    %edx,(%esp)
c0108afb:	e8 88 01 00 00       	call   c0108c88 <do_fork>
}
c0108b00:	c9                   	leave  
c0108b01:	c3                   	ret    

c0108b02 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108b02:	55                   	push   %ebp
c0108b03:	89 e5                	mov    %esp,%ebp
c0108b05:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108b08:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108b0f:	e8 e8 e0 ff ff       	call   c0106bfc <alloc_pages>
c0108b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108b1b:	74 1a                	je     c0108b37 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b20:	89 04 24             	mov    %eax,(%esp)
c0108b23:	e8 0b fb ff ff       	call   c0108633 <page2kva>
c0108b28:	89 c2                	mov    %eax,%edx
c0108b2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b2d:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108b30:	b8 00 00 00 00       	mov    $0x0,%eax
c0108b35:	eb 05                	jmp    c0108b3c <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108b37:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108b3c:	c9                   	leave  
c0108b3d:	c3                   	ret    

c0108b3e <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108b3e:	55                   	push   %ebp
c0108b3f:	89 e5                	mov    %esp,%ebp
c0108b41:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b47:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b4a:	89 04 24             	mov    %eax,(%esp)
c0108b4d:	e8 35 fb ff ff       	call   c0108687 <kva2page>
c0108b52:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108b59:	00 
c0108b5a:	89 04 24             	mov    %eax,(%esp)
c0108b5d:	e8 05 e1 ff ff       	call   c0106c67 <free_pages>
}
c0108b62:	90                   	nop
c0108b63:	c9                   	leave  
c0108b64:	c3                   	ret    

c0108b65 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108b65:	55                   	push   %ebp
c0108b66:	89 e5                	mov    %esp,%ebp
c0108b68:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108b6b:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108b70:	8b 40 18             	mov    0x18(%eax),%eax
c0108b73:	85 c0                	test   %eax,%eax
c0108b75:	74 24                	je     c0108b9b <copy_mm+0x36>
c0108b77:	c7 44 24 0c d8 bc 10 	movl   $0xc010bcd8,0xc(%esp)
c0108b7e:	c0 
c0108b7f:	c7 44 24 08 ec bc 10 	movl   $0xc010bcec,0x8(%esp)
c0108b86:	c0 
c0108b87:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0108b8e:	00 
c0108b8f:	c7 04 24 01 bd 10 c0 	movl   $0xc010bd01,(%esp)
c0108b96:	e8 65 78 ff ff       	call   c0100400 <__panic>
    /* do nothing in this project */
    return 0;
c0108b9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ba0:	c9                   	leave  
c0108ba1:	c3                   	ret    

c0108ba2 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108ba2:	55                   	push   %ebp
c0108ba3:	89 e5                	mov    %esp,%ebp
c0108ba5:	57                   	push   %edi
c0108ba6:	56                   	push   %esi
c0108ba7:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bab:	8b 40 0c             	mov    0xc(%eax),%eax
c0108bae:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108bb3:	89 c2                	mov    %eax,%edx
c0108bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb8:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bbe:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108bc1:	8b 55 10             	mov    0x10(%ebp),%edx
c0108bc4:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108bc9:	89 c1                	mov    %eax,%ecx
c0108bcb:	83 e1 01             	and    $0x1,%ecx
c0108bce:	85 c9                	test   %ecx,%ecx
c0108bd0:	74 0c                	je     c0108bde <copy_thread+0x3c>
c0108bd2:	0f b6 0a             	movzbl (%edx),%ecx
c0108bd5:	88 08                	mov    %cl,(%eax)
c0108bd7:	8d 40 01             	lea    0x1(%eax),%eax
c0108bda:	8d 52 01             	lea    0x1(%edx),%edx
c0108bdd:	4b                   	dec    %ebx
c0108bde:	89 c1                	mov    %eax,%ecx
c0108be0:	83 e1 02             	and    $0x2,%ecx
c0108be3:	85 c9                	test   %ecx,%ecx
c0108be5:	74 0f                	je     c0108bf6 <copy_thread+0x54>
c0108be7:	0f b7 0a             	movzwl (%edx),%ecx
c0108bea:	66 89 08             	mov    %cx,(%eax)
c0108bed:	8d 40 02             	lea    0x2(%eax),%eax
c0108bf0:	8d 52 02             	lea    0x2(%edx),%edx
c0108bf3:	83 eb 02             	sub    $0x2,%ebx
c0108bf6:	89 df                	mov    %ebx,%edi
c0108bf8:	83 e7 fc             	and    $0xfffffffc,%edi
c0108bfb:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108c00:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
c0108c03:	89 34 08             	mov    %esi,(%eax,%ecx,1)
c0108c06:	83 c1 04             	add    $0x4,%ecx
c0108c09:	39 f9                	cmp    %edi,%ecx
c0108c0b:	72 f3                	jb     c0108c00 <copy_thread+0x5e>
c0108c0d:	01 c8                	add    %ecx,%eax
c0108c0f:	01 ca                	add    %ecx,%edx
c0108c11:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108c16:	89 de                	mov    %ebx,%esi
c0108c18:	83 e6 02             	and    $0x2,%esi
c0108c1b:	85 f6                	test   %esi,%esi
c0108c1d:	74 0b                	je     c0108c2a <copy_thread+0x88>
c0108c1f:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108c23:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108c27:	83 c1 02             	add    $0x2,%ecx
c0108c2a:	83 e3 01             	and    $0x1,%ebx
c0108c2d:	85 db                	test   %ebx,%ebx
c0108c2f:	74 07                	je     c0108c38 <copy_thread+0x96>
c0108c31:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108c35:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c3b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c3e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c48:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c4e:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c54:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c57:	8b 50 40             	mov    0x40(%eax),%edx
c0108c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c5d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c60:	81 ca 00 02 00 00    	or     $0x200,%edx
c0108c66:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108c69:	ba 86 89 10 c0       	mov    $0xc0108986,%edx
c0108c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c71:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c77:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108c7a:	89 c2                	mov    %eax,%edx
c0108c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c7f:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108c82:	90                   	nop
c0108c83:	5b                   	pop    %ebx
c0108c84:	5e                   	pop    %esi
c0108c85:	5f                   	pop    %edi
c0108c86:	5d                   	pop    %ebp
c0108c87:	c3                   	ret    

c0108c88 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108c88:	55                   	push   %ebp
c0108c89:	89 e5                	mov    %esp,%ebp
c0108c8b:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108c8e:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108c95:	a1 40 b0 12 c0       	mov    0xc012b040,%eax
c0108c9a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108c9f:	0f 8f 0c 01 00 00    	jg     c0108db1 <do_fork+0x129>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0108ca5:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
    if ((proc = alloc_proc()) == NULL) {
c0108cac:	e8 20 fa ff ff       	call   c01086d1 <alloc_proc>
c0108cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108cb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108cb8:	0f 84 f6 00 00 00    	je     c0108db4 <do_fork+0x12c>
        goto fork_out;
    }
    proc->parent = current;
c0108cbe:	8b 15 28 90 12 c0    	mov    0xc0129028,%edx
c0108cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108cc7:	89 50 14             	mov    %edx,0x14(%eax)
    if (setup_kstack(proc) != 0) {
c0108cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ccd:	89 04 24             	mov    %eax,(%esp)
c0108cd0:	e8 2d fe ff ff       	call   c0108b02 <setup_kstack>
c0108cd5:	85 c0                	test   %eax,%eax
c0108cd7:	0f 85 eb 00 00 00    	jne    c0108dc8 <do_fork+0x140>
        goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc) != 0) {
c0108cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ce7:	89 04 24             	mov    %eax,(%esp)
c0108cea:	e8 76 fe ff ff       	call   c0108b65 <copy_mm>
c0108cef:	85 c0                	test   %eax,%eax
c0108cf1:	0f 85 c3 00 00 00    	jne    c0108dba <do_fork+0x132>
        goto bad_fork_cleanup_kstack;
    }
    copy_thread(proc, stack, tf);
c0108cf7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d08:	89 04 24             	mov    %eax,(%esp)
c0108d0b:	e8 92 fe ff ff       	call   c0108ba2 <copy_thread>
    bool intr_flag;
    local_intr_save(intr_flag);
c0108d10:	e8 72 f8 ff ff       	call   c0108587 <__intr_save>
c0108d15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        proc->pid = get_pid();
c0108d18:	e8 fe fa ff ff       	call   c010881b <get_pid>
c0108d1d:	89 c2                	mov    %eax,%edx
c0108d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d22:	89 50 04             	mov    %edx,0x4(%eax)
        hash_proc(proc); 
c0108d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d28:	89 04 24             	mov    %eax,(%esp)
c0108d2b:	e8 6f fc ff ff       	call   c010899f <hash_proc>
        nr_process ++; 
c0108d30:	a1 40 b0 12 c0       	mov    0xc012b040,%eax
c0108d35:	40                   	inc    %eax
c0108d36:	a3 40 b0 12 c0       	mov    %eax,0xc012b040
        list_add(&proc_list, &(proc->list_link));
c0108d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d3e:	83 c0 58             	add    $0x58,%eax
c0108d41:	c7 45 e8 44 b1 12 c0 	movl   $0xc012b144,-0x18(%ebp)
c0108d48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d54:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0108d57:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d5a:	8b 40 04             	mov    0x4(%eax),%eax
c0108d5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108d60:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108d63:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108d66:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108d69:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0108d6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108d6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108d72:	89 10                	mov    %edx,(%eax)
c0108d74:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108d77:	8b 10                	mov    (%eax),%edx
c0108d79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108d7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108d7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108d82:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108d85:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108d8b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108d8e:	89 10                	mov    %edx,(%eax)
    }
    local_intr_restore(intr_flag);
c0108d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d93:	89 04 24             	mov    %eax,(%esp)
c0108d96:	e8 16 f8 ff ff       	call   c01085b1 <__intr_restore>
    wakeup_proc(proc);
c0108d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d9e:	89 04 24             	mov    %eax,(%esp)
c0108da1:	e8 bf 02 00 00       	call   c0109065 <wakeup_proc>
    ret = proc->pid;
c0108da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108da9:	8b 40 04             	mov    0x4(%eax),%eax
c0108dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108daf:	eb 04                	jmp    c0108db5 <do_fork+0x12d>
        goto fork_out;
c0108db1:	90                   	nop
c0108db2:	eb 01                	jmp    c0108db5 <do_fork+0x12d>
        goto fork_out;
c0108db4:	90                   	nop
fork_out:
    return ret;
c0108db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108db8:	eb 1c                	jmp    c0108dd6 <do_fork+0x14e>
        goto bad_fork_cleanup_kstack;
c0108dba:	90                   	nop

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108dbe:	89 04 24             	mov    %eax,(%esp)
c0108dc1:	e8 78 fd ff ff       	call   c0108b3e <put_kstack>
c0108dc6:	eb 01                	jmp    c0108dc9 <do_fork+0x141>
        goto bad_fork_cleanup_proc;
c0108dc8:	90                   	nop
bad_fork_cleanup_proc:
    kfree(proc);
c0108dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108dcc:	89 04 24             	mov    %eax,(%esp)
c0108dcf:	e8 af c2 ff ff       	call   c0105083 <kfree>
    goto fork_out;
c0108dd4:	eb df                	jmp    c0108db5 <do_fork+0x12d>
}
c0108dd6:	c9                   	leave  
c0108dd7:	c3                   	ret    

c0108dd8 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108dd8:	55                   	push   %ebp
c0108dd9:	89 e5                	mov    %esp,%ebp
c0108ddb:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108dde:	c7 44 24 08 15 bd 10 	movl   $0xc010bd15,0x8(%esp)
c0108de5:	c0 
c0108de6:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
c0108ded:	00 
c0108dee:	c7 04 24 01 bd 10 c0 	movl   $0xc010bd01,(%esp)
c0108df5:	e8 06 76 ff ff       	call   c0100400 <__panic>

c0108dfa <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108dfa:	55                   	push   %ebp
c0108dfb:	89 e5                	mov    %esp,%ebp
c0108dfd:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108e00:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108e05:	89 04 24             	mov    %eax,(%esp)
c0108e08:	e8 cc f9 ff ff       	call   c01087d9 <get_proc_name>
c0108e0d:	89 c2                	mov    %eax,%edx
c0108e0f:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0108e14:	8b 40 04             	mov    0x4(%eax),%eax
c0108e17:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e1f:	c7 04 24 28 bd 10 c0 	movl   $0xc010bd28,(%esp)
c0108e26:	e8 7e 74 ff ff       	call   c01002a9 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108e2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e32:	c7 04 24 4e bd 10 c0 	movl   $0xc010bd4e,(%esp)
c0108e39:	e8 6b 74 ff ff       	call   c01002a9 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108e3e:	c7 04 24 5b bd 10 c0 	movl   $0xc010bd5b,(%esp)
c0108e45:	e8 5f 74 ff ff       	call   c01002a9 <cprintf>
    return 0;
c0108e4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108e4f:	c9                   	leave  
c0108e50:	c3                   	ret    

c0108e51 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
//完成了idleproc内核线程和initproc内核线程的创建或复制工作
void
proc_init(void) {
c0108e51:	55                   	push   %ebp
c0108e52:	89 e5                	mov    %esp,%ebp
c0108e54:	83 ec 28             	sub    $0x28,%esp
c0108e57:	c7 45 ec 44 b1 12 c0 	movl   $0xc012b144,-0x14(%ebp)
    elm->prev = elm->next = elm;
c0108e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e61:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108e64:	89 50 04             	mov    %edx,0x4(%eax)
c0108e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e6a:	8b 50 04             	mov    0x4(%eax),%edx
c0108e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e70:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108e79:	eb 25                	jmp    c0108ea0 <proc_init+0x4f>
        list_init(hash_list + i);
c0108e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108e7e:	c1 e0 03             	shl    $0x3,%eax
c0108e81:	05 40 90 12 c0       	add    $0xc0129040,%eax
c0108e86:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108e8f:	89 50 04             	mov    %edx,0x4(%eax)
c0108e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e95:	8b 50 04             	mov    0x4(%eax),%edx
c0108e98:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e9b:	89 10                	mov    %edx,(%eax)
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108e9d:	ff 45 f4             	incl   -0xc(%ebp)
c0108ea0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108ea7:	7e d2                	jle    c0108e7b <proc_init+0x2a>
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108ea9:	e8 23 f8 ff ff       	call   c01086d1 <alloc_proc>
c0108eae:	a3 20 90 12 c0       	mov    %eax,0xc0129020
c0108eb3:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108eb8:	85 c0                	test   %eax,%eax
c0108eba:	75 1c                	jne    c0108ed8 <proc_init+0x87>
        panic("cannot alloc idleproc.\n");
c0108ebc:	c7 44 24 08 77 bd 10 	movl   $0xc010bd77,0x8(%esp)
c0108ec3:	c0 
c0108ec4:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
c0108ecb:	00 
c0108ecc:	c7 04 24 01 bd 10 c0 	movl   $0xc010bd01,(%esp)
c0108ed3:	e8 28 75 ff ff       	call   c0100400 <__panic>
    }

    idleproc->pid = 0;
c0108ed8:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108edd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108ee4:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108ee9:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108eef:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108ef4:	ba 00 30 12 c0       	mov    $0xc0123000,%edx
c0108ef9:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108efc:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108f01:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108f08:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108f0d:	c7 44 24 04 8f bd 10 	movl   $0xc010bd8f,0x4(%esp)
c0108f14:	c0 
c0108f15:	89 04 24             	mov    %eax,(%esp)
c0108f18:	e8 79 f8 ff ff       	call   c0108796 <set_proc_name>
    nr_process ++;
c0108f1d:	a1 40 b0 12 c0       	mov    0xc012b040,%eax
c0108f22:	40                   	inc    %eax
c0108f23:	a3 40 b0 12 c0       	mov    %eax,0xc012b040

    current = idleproc;
c0108f28:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108f2d:	a3 28 90 12 c0       	mov    %eax,0xc0129028

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108f32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108f39:	00 
c0108f3a:	c7 44 24 04 94 bd 10 	movl   $0xc010bd94,0x4(%esp)
c0108f41:	c0 
c0108f42:	c7 04 24 fa 8d 10 c0 	movl   $0xc0108dfa,(%esp)
c0108f49:	e8 40 fb ff ff       	call   c0108a8e <kernel_thread>
c0108f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108f51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108f55:	7f 1c                	jg     c0108f73 <proc_init+0x122>
        panic("create init_main failed.\n");
c0108f57:	c7 44 24 08 a2 bd 10 	movl   $0xc010bda2,0x8(%esp)
c0108f5e:	c0 
c0108f5f:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c0108f66:	00 
c0108f67:	c7 04 24 01 bd 10 c0 	movl   $0xc010bd01,(%esp)
c0108f6e:	e8 8d 74 ff ff       	call   c0100400 <__panic>
    }

    initproc = find_proc(pid);
c0108f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f76:	89 04 24             	mov    %eax,(%esp)
c0108f79:	e8 9e fa ff ff       	call   c0108a1c <find_proc>
c0108f7e:	a3 24 90 12 c0       	mov    %eax,0xc0129024
    set_proc_name(initproc, "init");
c0108f83:	a1 24 90 12 c0       	mov    0xc0129024,%eax
c0108f88:	c7 44 24 04 bc bd 10 	movl   $0xc010bdbc,0x4(%esp)
c0108f8f:	c0 
c0108f90:	89 04 24             	mov    %eax,(%esp)
c0108f93:	e8 fe f7 ff ff       	call   c0108796 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108f98:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108f9d:	85 c0                	test   %eax,%eax
c0108f9f:	74 0c                	je     c0108fad <proc_init+0x15c>
c0108fa1:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0108fa6:	8b 40 04             	mov    0x4(%eax),%eax
c0108fa9:	85 c0                	test   %eax,%eax
c0108fab:	74 24                	je     c0108fd1 <proc_init+0x180>
c0108fad:	c7 44 24 0c c4 bd 10 	movl   $0xc010bdc4,0xc(%esp)
c0108fb4:	c0 
c0108fb5:	c7 44 24 08 ec bc 10 	movl   $0xc010bcec,0x8(%esp)
c0108fbc:	c0 
c0108fbd:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
c0108fc4:	00 
c0108fc5:	c7 04 24 01 bd 10 c0 	movl   $0xc010bd01,(%esp)
c0108fcc:	e8 2f 74 ff ff       	call   c0100400 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108fd1:	a1 24 90 12 c0       	mov    0xc0129024,%eax
c0108fd6:	85 c0                	test   %eax,%eax
c0108fd8:	74 0d                	je     c0108fe7 <proc_init+0x196>
c0108fda:	a1 24 90 12 c0       	mov    0xc0129024,%eax
c0108fdf:	8b 40 04             	mov    0x4(%eax),%eax
c0108fe2:	83 f8 01             	cmp    $0x1,%eax
c0108fe5:	74 24                	je     c010900b <proc_init+0x1ba>
c0108fe7:	c7 44 24 0c ec bd 10 	movl   $0xc010bdec,0xc(%esp)
c0108fee:	c0 
c0108fef:	c7 44 24 08 ec bc 10 	movl   $0xc010bcec,0x8(%esp)
c0108ff6:	c0 
c0108ff7:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
c0108ffe:	00 
c0108fff:	c7 04 24 01 bd 10 c0 	movl   $0xc010bd01,(%esp)
c0109006:	e8 f5 73 ff ff       	call   c0100400 <__panic>
}
c010900b:	90                   	nop
c010900c:	c9                   	leave  
c010900d:	c3                   	ret    

c010900e <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010900e:	55                   	push   %ebp
c010900f:	89 e5                	mov    %esp,%ebp
c0109011:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        //当前的idleproc线程need_resched置为1，则调用schedule函数
        if (current->need_resched) {
c0109014:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0109019:	8b 40 10             	mov    0x10(%eax),%eax
c010901c:	85 c0                	test   %eax,%eax
c010901e:	74 f4                	je     c0109014 <cpu_idle+0x6>
            schedule();
c0109020:	e8 8a 00 00 00       	call   c01090af <schedule>
        if (current->need_resched) {
c0109025:	eb ed                	jmp    c0109014 <cpu_idle+0x6>

c0109027 <__intr_save>:
__intr_save(void) {
c0109027:	55                   	push   %ebp
c0109028:	89 e5                	mov    %esp,%ebp
c010902a:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010902d:	9c                   	pushf  
c010902e:	58                   	pop    %eax
c010902f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0109032:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0109035:	25 00 02 00 00       	and    $0x200,%eax
c010903a:	85 c0                	test   %eax,%eax
c010903c:	74 0c                	je     c010904a <__intr_save+0x23>
        intr_disable();
c010903e:	e8 ef 8f ff ff       	call   c0102032 <intr_disable>
        return 1;
c0109043:	b8 01 00 00 00       	mov    $0x1,%eax
c0109048:	eb 05                	jmp    c010904f <__intr_save+0x28>
    return 0;
c010904a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010904f:	c9                   	leave  
c0109050:	c3                   	ret    

c0109051 <__intr_restore>:
__intr_restore(bool flag) {
c0109051:	55                   	push   %ebp
c0109052:	89 e5                	mov    %esp,%ebp
c0109054:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010905b:	74 05                	je     c0109062 <__intr_restore+0x11>
        intr_enable();
c010905d:	e8 c9 8f ff ff       	call   c010202b <intr_enable>
}
c0109062:	90                   	nop
c0109063:	c9                   	leave  
c0109064:	c3                   	ret    

c0109065 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0109065:	55                   	push   %ebp
c0109066:	89 e5                	mov    %esp,%ebp
c0109068:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c010906b:	8b 45 08             	mov    0x8(%ebp),%eax
c010906e:	8b 00                	mov    (%eax),%eax
c0109070:	83 f8 03             	cmp    $0x3,%eax
c0109073:	74 0a                	je     c010907f <wakeup_proc+0x1a>
c0109075:	8b 45 08             	mov    0x8(%ebp),%eax
c0109078:	8b 00                	mov    (%eax),%eax
c010907a:	83 f8 02             	cmp    $0x2,%eax
c010907d:	75 24                	jne    c01090a3 <wakeup_proc+0x3e>
c010907f:	c7 44 24 0c 14 be 10 	movl   $0xc010be14,0xc(%esp)
c0109086:	c0 
c0109087:	c7 44 24 08 4f be 10 	movl   $0xc010be4f,0x8(%esp)
c010908e:	c0 
c010908f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0109096:	00 
c0109097:	c7 04 24 64 be 10 c0 	movl   $0xc010be64,(%esp)
c010909e:	e8 5d 73 ff ff       	call   c0100400 <__panic>
    proc->state = PROC_RUNNABLE;
c01090a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01090a6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c01090ac:	90                   	nop
c01090ad:	c9                   	leave  
c01090ae:	c3                   	ret    

c01090af <schedule>:

void
schedule(void) {
c01090af:	55                   	push   %ebp
c01090b0:	89 e5                	mov    %esp,%ebp
c01090b2:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c01090b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c01090bc:	e8 66 ff ff ff       	call   c0109027 <__intr_save>
c01090c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c01090c4:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c01090c9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c01090d0:	8b 15 28 90 12 c0    	mov    0xc0129028,%edx
c01090d6:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c01090db:	39 c2                	cmp    %eax,%edx
c01090dd:	74 0a                	je     c01090e9 <schedule+0x3a>
c01090df:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c01090e4:	83 c0 58             	add    $0x58,%eax
c01090e7:	eb 05                	jmp    c01090ee <schedule+0x3f>
c01090e9:	b8 44 b1 12 c0       	mov    $0xc012b144,%eax
c01090ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c01090f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01090f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01090fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109100:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0109103:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109106:	81 7d f4 44 b1 12 c0 	cmpl   $0xc012b144,-0xc(%ebp)
c010910d:	74 13                	je     c0109122 <schedule+0x73>
                next = le2proc(le, list_link);
c010910f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109112:	83 e8 58             	sub    $0x58,%eax
c0109115:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0109118:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010911b:	8b 00                	mov    (%eax),%eax
c010911d:	83 f8 02             	cmp    $0x2,%eax
c0109120:	74 0a                	je     c010912c <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c0109122:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109125:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0109128:	75 cd                	jne    c01090f7 <schedule+0x48>
c010912a:	eb 01                	jmp    c010912d <schedule+0x7e>
                    break;
c010912c:	90                   	nop
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010912d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109131:	74 0a                	je     c010913d <schedule+0x8e>
c0109133:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109136:	8b 00                	mov    (%eax),%eax
c0109138:	83 f8 02             	cmp    $0x2,%eax
c010913b:	74 08                	je     c0109145 <schedule+0x96>
            next = idleproc;
c010913d:	a1 20 90 12 c0       	mov    0xc0129020,%eax
c0109142:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109145:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109148:	8b 40 08             	mov    0x8(%eax),%eax
c010914b:	8d 50 01             	lea    0x1(%eax),%edx
c010914e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109151:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109154:	a1 28 90 12 c0       	mov    0xc0129028,%eax
c0109159:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010915c:	74 0b                	je     c0109169 <schedule+0xba>
            proc_run(next);
c010915e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109161:	89 04 24             	mov    %eax,(%esp)
c0109164:	e8 a7 f7 ff ff       	call   c0108910 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c0109169:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010916c:	89 04 24             	mov    %eax,(%esp)
c010916f:	e8 dd fe ff ff       	call   c0109051 <__intr_restore>
}
c0109174:	90                   	nop
c0109175:	c9                   	leave  
c0109176:	c3                   	ret    

c0109177 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109177:	55                   	push   %ebp
c0109178:	89 e5                	mov    %esp,%ebp
c010917a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010917d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109184:	eb 03                	jmp    c0109189 <strlen+0x12>
        cnt ++;
c0109186:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0109189:	8b 45 08             	mov    0x8(%ebp),%eax
c010918c:	8d 50 01             	lea    0x1(%eax),%edx
c010918f:	89 55 08             	mov    %edx,0x8(%ebp)
c0109192:	0f b6 00             	movzbl (%eax),%eax
c0109195:	84 c0                	test   %al,%al
c0109197:	75 ed                	jne    c0109186 <strlen+0xf>
    }
    return cnt;
c0109199:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010919c:	c9                   	leave  
c010919d:	c3                   	ret    

c010919e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010919e:	55                   	push   %ebp
c010919f:	89 e5                	mov    %esp,%ebp
c01091a1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01091a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01091ab:	eb 03                	jmp    c01091b0 <strnlen+0x12>
        cnt ++;
c01091ad:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01091b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01091b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01091b6:	73 10                	jae    c01091c8 <strnlen+0x2a>
c01091b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01091bb:	8d 50 01             	lea    0x1(%eax),%edx
c01091be:	89 55 08             	mov    %edx,0x8(%ebp)
c01091c1:	0f b6 00             	movzbl (%eax),%eax
c01091c4:	84 c0                	test   %al,%al
c01091c6:	75 e5                	jne    c01091ad <strnlen+0xf>
    }
    return cnt;
c01091c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01091cb:	c9                   	leave  
c01091cc:	c3                   	ret    

c01091cd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01091cd:	55                   	push   %ebp
c01091ce:	89 e5                	mov    %esp,%ebp
c01091d0:	57                   	push   %edi
c01091d1:	56                   	push   %esi
c01091d2:	83 ec 20             	sub    $0x20,%esp
c01091d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01091d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01091db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091de:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01091e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01091e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01091e7:	89 d1                	mov    %edx,%ecx
c01091e9:	89 c2                	mov    %eax,%edx
c01091eb:	89 ce                	mov    %ecx,%esi
c01091ed:	89 d7                	mov    %edx,%edi
c01091ef:	ac                   	lods   %ds:(%esi),%al
c01091f0:	aa                   	stos   %al,%es:(%edi)
c01091f1:	84 c0                	test   %al,%al
c01091f3:	75 fa                	jne    c01091ef <strcpy+0x22>
c01091f5:	89 fa                	mov    %edi,%edx
c01091f7:	89 f1                	mov    %esi,%ecx
c01091f9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01091fc:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01091ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109202:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0109205:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109206:	83 c4 20             	add    $0x20,%esp
c0109209:	5e                   	pop    %esi
c010920a:	5f                   	pop    %edi
c010920b:	5d                   	pop    %ebp
c010920c:	c3                   	ret    

c010920d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010920d:	55                   	push   %ebp
c010920e:	89 e5                	mov    %esp,%ebp
c0109210:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109213:	8b 45 08             	mov    0x8(%ebp),%eax
c0109216:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109219:	eb 1e                	jmp    c0109239 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c010921b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010921e:	0f b6 10             	movzbl (%eax),%edx
c0109221:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109224:	88 10                	mov    %dl,(%eax)
c0109226:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109229:	0f b6 00             	movzbl (%eax),%eax
c010922c:	84 c0                	test   %al,%al
c010922e:	74 03                	je     c0109233 <strncpy+0x26>
            src ++;
c0109230:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0109233:	ff 45 fc             	incl   -0x4(%ebp)
c0109236:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0109239:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010923d:	75 dc                	jne    c010921b <strncpy+0xe>
    }
    return dst;
c010923f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109242:	c9                   	leave  
c0109243:	c3                   	ret    

c0109244 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109244:	55                   	push   %ebp
c0109245:	89 e5                	mov    %esp,%ebp
c0109247:	57                   	push   %edi
c0109248:	56                   	push   %esi
c0109249:	83 ec 20             	sub    $0x20,%esp
c010924c:	8b 45 08             	mov    0x8(%ebp),%eax
c010924f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109252:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109255:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0109258:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010925b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010925e:	89 d1                	mov    %edx,%ecx
c0109260:	89 c2                	mov    %eax,%edx
c0109262:	89 ce                	mov    %ecx,%esi
c0109264:	89 d7                	mov    %edx,%edi
c0109266:	ac                   	lods   %ds:(%esi),%al
c0109267:	ae                   	scas   %es:(%edi),%al
c0109268:	75 08                	jne    c0109272 <strcmp+0x2e>
c010926a:	84 c0                	test   %al,%al
c010926c:	75 f8                	jne    c0109266 <strcmp+0x22>
c010926e:	31 c0                	xor    %eax,%eax
c0109270:	eb 04                	jmp    c0109276 <strcmp+0x32>
c0109272:	19 c0                	sbb    %eax,%eax
c0109274:	0c 01                	or     $0x1,%al
c0109276:	89 fa                	mov    %edi,%edx
c0109278:	89 f1                	mov    %esi,%ecx
c010927a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010927d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109280:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0109283:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0109286:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109287:	83 c4 20             	add    $0x20,%esp
c010928a:	5e                   	pop    %esi
c010928b:	5f                   	pop    %edi
c010928c:	5d                   	pop    %ebp
c010928d:	c3                   	ret    

c010928e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010928e:	55                   	push   %ebp
c010928f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109291:	eb 09                	jmp    c010929c <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0109293:	ff 4d 10             	decl   0x10(%ebp)
c0109296:	ff 45 08             	incl   0x8(%ebp)
c0109299:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010929c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01092a0:	74 1a                	je     c01092bc <strncmp+0x2e>
c01092a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01092a5:	0f b6 00             	movzbl (%eax),%eax
c01092a8:	84 c0                	test   %al,%al
c01092aa:	74 10                	je     c01092bc <strncmp+0x2e>
c01092ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01092af:	0f b6 10             	movzbl (%eax),%edx
c01092b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092b5:	0f b6 00             	movzbl (%eax),%eax
c01092b8:	38 c2                	cmp    %al,%dl
c01092ba:	74 d7                	je     c0109293 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01092bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01092c0:	74 18                	je     c01092da <strncmp+0x4c>
c01092c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01092c5:	0f b6 00             	movzbl (%eax),%eax
c01092c8:	0f b6 d0             	movzbl %al,%edx
c01092cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092ce:	0f b6 00             	movzbl (%eax),%eax
c01092d1:	0f b6 c0             	movzbl %al,%eax
c01092d4:	29 c2                	sub    %eax,%edx
c01092d6:	89 d0                	mov    %edx,%eax
c01092d8:	eb 05                	jmp    c01092df <strncmp+0x51>
c01092da:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01092df:	5d                   	pop    %ebp
c01092e0:	c3                   	ret    

c01092e1 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01092e1:	55                   	push   %ebp
c01092e2:	89 e5                	mov    %esp,%ebp
c01092e4:	83 ec 04             	sub    $0x4,%esp
c01092e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01092ea:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01092ed:	eb 13                	jmp    c0109302 <strchr+0x21>
        if (*s == c) {
c01092ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01092f2:	0f b6 00             	movzbl (%eax),%eax
c01092f5:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01092f8:	75 05                	jne    c01092ff <strchr+0x1e>
            return (char *)s;
c01092fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01092fd:	eb 12                	jmp    c0109311 <strchr+0x30>
        }
        s ++;
c01092ff:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0109302:	8b 45 08             	mov    0x8(%ebp),%eax
c0109305:	0f b6 00             	movzbl (%eax),%eax
c0109308:	84 c0                	test   %al,%al
c010930a:	75 e3                	jne    c01092ef <strchr+0xe>
    }
    return NULL;
c010930c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109311:	c9                   	leave  
c0109312:	c3                   	ret    

c0109313 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109313:	55                   	push   %ebp
c0109314:	89 e5                	mov    %esp,%ebp
c0109316:	83 ec 04             	sub    $0x4,%esp
c0109319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010931c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010931f:	eb 0e                	jmp    c010932f <strfind+0x1c>
        if (*s == c) {
c0109321:	8b 45 08             	mov    0x8(%ebp),%eax
c0109324:	0f b6 00             	movzbl (%eax),%eax
c0109327:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010932a:	74 0f                	je     c010933b <strfind+0x28>
            break;
        }
        s ++;
c010932c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010932f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109332:	0f b6 00             	movzbl (%eax),%eax
c0109335:	84 c0                	test   %al,%al
c0109337:	75 e8                	jne    c0109321 <strfind+0xe>
c0109339:	eb 01                	jmp    c010933c <strfind+0x29>
            break;
c010933b:	90                   	nop
    }
    return (char *)s;
c010933c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010933f:	c9                   	leave  
c0109340:	c3                   	ret    

c0109341 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109341:	55                   	push   %ebp
c0109342:	89 e5                	mov    %esp,%ebp
c0109344:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109347:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010934e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109355:	eb 03                	jmp    c010935a <strtol+0x19>
        s ++;
c0109357:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c010935a:	8b 45 08             	mov    0x8(%ebp),%eax
c010935d:	0f b6 00             	movzbl (%eax),%eax
c0109360:	3c 20                	cmp    $0x20,%al
c0109362:	74 f3                	je     c0109357 <strtol+0x16>
c0109364:	8b 45 08             	mov    0x8(%ebp),%eax
c0109367:	0f b6 00             	movzbl (%eax),%eax
c010936a:	3c 09                	cmp    $0x9,%al
c010936c:	74 e9                	je     c0109357 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c010936e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109371:	0f b6 00             	movzbl (%eax),%eax
c0109374:	3c 2b                	cmp    $0x2b,%al
c0109376:	75 05                	jne    c010937d <strtol+0x3c>
        s ++;
c0109378:	ff 45 08             	incl   0x8(%ebp)
c010937b:	eb 14                	jmp    c0109391 <strtol+0x50>
    }
    else if (*s == '-') {
c010937d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109380:	0f b6 00             	movzbl (%eax),%eax
c0109383:	3c 2d                	cmp    $0x2d,%al
c0109385:	75 0a                	jne    c0109391 <strtol+0x50>
        s ++, neg = 1;
c0109387:	ff 45 08             	incl   0x8(%ebp)
c010938a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109391:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109395:	74 06                	je     c010939d <strtol+0x5c>
c0109397:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010939b:	75 22                	jne    c01093bf <strtol+0x7e>
c010939d:	8b 45 08             	mov    0x8(%ebp),%eax
c01093a0:	0f b6 00             	movzbl (%eax),%eax
c01093a3:	3c 30                	cmp    $0x30,%al
c01093a5:	75 18                	jne    c01093bf <strtol+0x7e>
c01093a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01093aa:	40                   	inc    %eax
c01093ab:	0f b6 00             	movzbl (%eax),%eax
c01093ae:	3c 78                	cmp    $0x78,%al
c01093b0:	75 0d                	jne    c01093bf <strtol+0x7e>
        s += 2, base = 16;
c01093b2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01093b6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01093bd:	eb 29                	jmp    c01093e8 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c01093bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01093c3:	75 16                	jne    c01093db <strtol+0x9a>
c01093c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01093c8:	0f b6 00             	movzbl (%eax),%eax
c01093cb:	3c 30                	cmp    $0x30,%al
c01093cd:	75 0c                	jne    c01093db <strtol+0x9a>
        s ++, base = 8;
c01093cf:	ff 45 08             	incl   0x8(%ebp)
c01093d2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01093d9:	eb 0d                	jmp    c01093e8 <strtol+0xa7>
    }
    else if (base == 0) {
c01093db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01093df:	75 07                	jne    c01093e8 <strtol+0xa7>
        base = 10;
c01093e1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01093e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01093eb:	0f b6 00             	movzbl (%eax),%eax
c01093ee:	3c 2f                	cmp    $0x2f,%al
c01093f0:	7e 1b                	jle    c010940d <strtol+0xcc>
c01093f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01093f5:	0f b6 00             	movzbl (%eax),%eax
c01093f8:	3c 39                	cmp    $0x39,%al
c01093fa:	7f 11                	jg     c010940d <strtol+0xcc>
            dig = *s - '0';
c01093fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01093ff:	0f b6 00             	movzbl (%eax),%eax
c0109402:	0f be c0             	movsbl %al,%eax
c0109405:	83 e8 30             	sub    $0x30,%eax
c0109408:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010940b:	eb 48                	jmp    c0109455 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010940d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109410:	0f b6 00             	movzbl (%eax),%eax
c0109413:	3c 60                	cmp    $0x60,%al
c0109415:	7e 1b                	jle    c0109432 <strtol+0xf1>
c0109417:	8b 45 08             	mov    0x8(%ebp),%eax
c010941a:	0f b6 00             	movzbl (%eax),%eax
c010941d:	3c 7a                	cmp    $0x7a,%al
c010941f:	7f 11                	jg     c0109432 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0109421:	8b 45 08             	mov    0x8(%ebp),%eax
c0109424:	0f b6 00             	movzbl (%eax),%eax
c0109427:	0f be c0             	movsbl %al,%eax
c010942a:	83 e8 57             	sub    $0x57,%eax
c010942d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109430:	eb 23                	jmp    c0109455 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109432:	8b 45 08             	mov    0x8(%ebp),%eax
c0109435:	0f b6 00             	movzbl (%eax),%eax
c0109438:	3c 40                	cmp    $0x40,%al
c010943a:	7e 3b                	jle    c0109477 <strtol+0x136>
c010943c:	8b 45 08             	mov    0x8(%ebp),%eax
c010943f:	0f b6 00             	movzbl (%eax),%eax
c0109442:	3c 5a                	cmp    $0x5a,%al
c0109444:	7f 31                	jg     c0109477 <strtol+0x136>
            dig = *s - 'A' + 10;
c0109446:	8b 45 08             	mov    0x8(%ebp),%eax
c0109449:	0f b6 00             	movzbl (%eax),%eax
c010944c:	0f be c0             	movsbl %al,%eax
c010944f:	83 e8 37             	sub    $0x37,%eax
c0109452:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109455:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109458:	3b 45 10             	cmp    0x10(%ebp),%eax
c010945b:	7d 19                	jge    c0109476 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c010945d:	ff 45 08             	incl   0x8(%ebp)
c0109460:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109463:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109467:	89 c2                	mov    %eax,%edx
c0109469:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010946c:	01 d0                	add    %edx,%eax
c010946e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0109471:	e9 72 ff ff ff       	jmp    c01093e8 <strtol+0xa7>
            break;
c0109476:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109477:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010947b:	74 08                	je     c0109485 <strtol+0x144>
        *endptr = (char *) s;
c010947d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109480:	8b 55 08             	mov    0x8(%ebp),%edx
c0109483:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109485:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109489:	74 07                	je     c0109492 <strtol+0x151>
c010948b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010948e:	f7 d8                	neg    %eax
c0109490:	eb 03                	jmp    c0109495 <strtol+0x154>
c0109492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109495:	c9                   	leave  
c0109496:	c3                   	ret    

c0109497 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109497:	55                   	push   %ebp
c0109498:	89 e5                	mov    %esp,%ebp
c010949a:	57                   	push   %edi
c010949b:	83 ec 24             	sub    $0x24,%esp
c010949e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094a1:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01094a4:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01094a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01094ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01094ae:	88 45 f7             	mov    %al,-0x9(%ebp)
c01094b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01094b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01094b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01094ba:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01094be:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01094c1:	89 d7                	mov    %edx,%edi
c01094c3:	f3 aa                	rep stos %al,%es:(%edi)
c01094c5:	89 fa                	mov    %edi,%edx
c01094c7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01094ca:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01094cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01094d0:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01094d1:	83 c4 24             	add    $0x24,%esp
c01094d4:	5f                   	pop    %edi
c01094d5:	5d                   	pop    %ebp
c01094d6:	c3                   	ret    

c01094d7 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01094d7:	55                   	push   %ebp
c01094d8:	89 e5                	mov    %esp,%ebp
c01094da:	57                   	push   %edi
c01094db:	56                   	push   %esi
c01094dc:	53                   	push   %ebx
c01094dd:	83 ec 30             	sub    $0x30,%esp
c01094e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01094e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01094e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01094ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01094ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01094f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01094f8:	73 42                	jae    c010953c <memmove+0x65>
c01094fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109500:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109503:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109506:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109509:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010950c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010950f:	c1 e8 02             	shr    $0x2,%eax
c0109512:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0109514:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109517:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010951a:	89 d7                	mov    %edx,%edi
c010951c:	89 c6                	mov    %eax,%esi
c010951e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109520:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109523:	83 e1 03             	and    $0x3,%ecx
c0109526:	74 02                	je     c010952a <memmove+0x53>
c0109528:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010952a:	89 f0                	mov    %esi,%eax
c010952c:	89 fa                	mov    %edi,%edx
c010952e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109531:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109534:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0109537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c010953a:	eb 36                	jmp    c0109572 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010953c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010953f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109542:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109545:	01 c2                	add    %eax,%edx
c0109547:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010954a:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010954d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109550:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0109553:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109556:	89 c1                	mov    %eax,%ecx
c0109558:	89 d8                	mov    %ebx,%eax
c010955a:	89 d6                	mov    %edx,%esi
c010955c:	89 c7                	mov    %eax,%edi
c010955e:	fd                   	std    
c010955f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109561:	fc                   	cld    
c0109562:	89 f8                	mov    %edi,%eax
c0109564:	89 f2                	mov    %esi,%edx
c0109566:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109569:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010956c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010956f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109572:	83 c4 30             	add    $0x30,%esp
c0109575:	5b                   	pop    %ebx
c0109576:	5e                   	pop    %esi
c0109577:	5f                   	pop    %edi
c0109578:	5d                   	pop    %ebp
c0109579:	c3                   	ret    

c010957a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010957a:	55                   	push   %ebp
c010957b:	89 e5                	mov    %esp,%ebp
c010957d:	57                   	push   %edi
c010957e:	56                   	push   %esi
c010957f:	83 ec 20             	sub    $0x20,%esp
c0109582:	8b 45 08             	mov    0x8(%ebp),%eax
c0109585:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109588:	8b 45 0c             	mov    0xc(%ebp),%eax
c010958b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010958e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109591:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109594:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109597:	c1 e8 02             	shr    $0x2,%eax
c010959a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010959c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010959f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01095a2:	89 d7                	mov    %edx,%edi
c01095a4:	89 c6                	mov    %eax,%esi
c01095a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01095a8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01095ab:	83 e1 03             	and    $0x3,%ecx
c01095ae:	74 02                	je     c01095b2 <memcpy+0x38>
c01095b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01095b2:	89 f0                	mov    %esi,%eax
c01095b4:	89 fa                	mov    %edi,%edx
c01095b6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01095b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01095bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01095bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01095c2:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01095c3:	83 c4 20             	add    $0x20,%esp
c01095c6:	5e                   	pop    %esi
c01095c7:	5f                   	pop    %edi
c01095c8:	5d                   	pop    %ebp
c01095c9:	c3                   	ret    

c01095ca <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01095ca:	55                   	push   %ebp
c01095cb:	89 e5                	mov    %esp,%ebp
c01095cd:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01095d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01095d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01095d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01095dc:	eb 2e                	jmp    c010960c <memcmp+0x42>
        if (*s1 != *s2) {
c01095de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095e1:	0f b6 10             	movzbl (%eax),%edx
c01095e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095e7:	0f b6 00             	movzbl (%eax),%eax
c01095ea:	38 c2                	cmp    %al,%dl
c01095ec:	74 18                	je     c0109606 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01095ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095f1:	0f b6 00             	movzbl (%eax),%eax
c01095f4:	0f b6 d0             	movzbl %al,%edx
c01095f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01095fa:	0f b6 00             	movzbl (%eax),%eax
c01095fd:	0f b6 c0             	movzbl %al,%eax
c0109600:	29 c2                	sub    %eax,%edx
c0109602:	89 d0                	mov    %edx,%eax
c0109604:	eb 18                	jmp    c010961e <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0109606:	ff 45 fc             	incl   -0x4(%ebp)
c0109609:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c010960c:	8b 45 10             	mov    0x10(%ebp),%eax
c010960f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109612:	89 55 10             	mov    %edx,0x10(%ebp)
c0109615:	85 c0                	test   %eax,%eax
c0109617:	75 c5                	jne    c01095de <memcmp+0x14>
    }
    return 0;
c0109619:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010961e:	c9                   	leave  
c010961f:	c3                   	ret    

c0109620 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0109620:	55                   	push   %ebp
c0109621:	89 e5                	mov    %esp,%ebp
c0109623:	83 ec 58             	sub    $0x58,%esp
c0109626:	8b 45 10             	mov    0x10(%ebp),%eax
c0109629:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010962c:	8b 45 14             	mov    0x14(%ebp),%eax
c010962f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0109632:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109635:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109638:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010963b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010963e:	8b 45 18             	mov    0x18(%ebp),%eax
c0109641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109644:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109647:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010964a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010964d:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109650:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109653:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109656:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010965a:	74 1c                	je     c0109678 <printnum+0x58>
c010965c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010965f:	ba 00 00 00 00       	mov    $0x0,%edx
c0109664:	f7 75 e4             	divl   -0x1c(%ebp)
c0109667:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010966a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010966d:	ba 00 00 00 00       	mov    $0x0,%edx
c0109672:	f7 75 e4             	divl   -0x1c(%ebp)
c0109675:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109678:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010967b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010967e:	f7 75 e4             	divl   -0x1c(%ebp)
c0109681:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109684:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0109687:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010968a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010968d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109690:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109693:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109696:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109699:	8b 45 18             	mov    0x18(%ebp),%eax
c010969c:	ba 00 00 00 00       	mov    $0x0,%edx
c01096a1:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01096a4:	72 56                	jb     c01096fc <printnum+0xdc>
c01096a6:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c01096a9:	77 05                	ja     c01096b0 <printnum+0x90>
c01096ab:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c01096ae:	72 4c                	jb     c01096fc <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01096b0:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01096b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01096b6:	8b 45 20             	mov    0x20(%ebp),%eax
c01096b9:	89 44 24 18          	mov    %eax,0x18(%esp)
c01096bd:	89 54 24 14          	mov    %edx,0x14(%esp)
c01096c1:	8b 45 18             	mov    0x18(%ebp),%eax
c01096c4:	89 44 24 10          	mov    %eax,0x10(%esp)
c01096c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01096cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01096ce:	89 44 24 08          	mov    %eax,0x8(%esp)
c01096d2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01096d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01096e0:	89 04 24             	mov    %eax,(%esp)
c01096e3:	e8 38 ff ff ff       	call   c0109620 <printnum>
c01096e8:	eb 1b                	jmp    c0109705 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01096ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096f1:	8b 45 20             	mov    0x20(%ebp),%eax
c01096f4:	89 04 24             	mov    %eax,(%esp)
c01096f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01096fa:	ff d0                	call   *%eax
        while (-- width > 0)
c01096fc:	ff 4d 1c             	decl   0x1c(%ebp)
c01096ff:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0109703:	7f e5                	jg     c01096ea <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109705:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109708:	05 fc be 10 c0       	add    $0xc010befc,%eax
c010970d:	0f b6 00             	movzbl (%eax),%eax
c0109710:	0f be c0             	movsbl %al,%eax
c0109713:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109716:	89 54 24 04          	mov    %edx,0x4(%esp)
c010971a:	89 04 24             	mov    %eax,(%esp)
c010971d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109720:	ff d0                	call   *%eax
}
c0109722:	90                   	nop
c0109723:	c9                   	leave  
c0109724:	c3                   	ret    

c0109725 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0109725:	55                   	push   %ebp
c0109726:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109728:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010972c:	7e 14                	jle    c0109742 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010972e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109731:	8b 00                	mov    (%eax),%eax
c0109733:	8d 48 08             	lea    0x8(%eax),%ecx
c0109736:	8b 55 08             	mov    0x8(%ebp),%edx
c0109739:	89 0a                	mov    %ecx,(%edx)
c010973b:	8b 50 04             	mov    0x4(%eax),%edx
c010973e:	8b 00                	mov    (%eax),%eax
c0109740:	eb 30                	jmp    c0109772 <getuint+0x4d>
    }
    else if (lflag) {
c0109742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109746:	74 16                	je     c010975e <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109748:	8b 45 08             	mov    0x8(%ebp),%eax
c010974b:	8b 00                	mov    (%eax),%eax
c010974d:	8d 48 04             	lea    0x4(%eax),%ecx
c0109750:	8b 55 08             	mov    0x8(%ebp),%edx
c0109753:	89 0a                	mov    %ecx,(%edx)
c0109755:	8b 00                	mov    (%eax),%eax
c0109757:	ba 00 00 00 00       	mov    $0x0,%edx
c010975c:	eb 14                	jmp    c0109772 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010975e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109761:	8b 00                	mov    (%eax),%eax
c0109763:	8d 48 04             	lea    0x4(%eax),%ecx
c0109766:	8b 55 08             	mov    0x8(%ebp),%edx
c0109769:	89 0a                	mov    %ecx,(%edx)
c010976b:	8b 00                	mov    (%eax),%eax
c010976d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0109772:	5d                   	pop    %ebp
c0109773:	c3                   	ret    

c0109774 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109774:	55                   	push   %ebp
c0109775:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109777:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010977b:	7e 14                	jle    c0109791 <getint+0x1d>
        return va_arg(*ap, long long);
c010977d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109780:	8b 00                	mov    (%eax),%eax
c0109782:	8d 48 08             	lea    0x8(%eax),%ecx
c0109785:	8b 55 08             	mov    0x8(%ebp),%edx
c0109788:	89 0a                	mov    %ecx,(%edx)
c010978a:	8b 50 04             	mov    0x4(%eax),%edx
c010978d:	8b 00                	mov    (%eax),%eax
c010978f:	eb 28                	jmp    c01097b9 <getint+0x45>
    }
    else if (lflag) {
c0109791:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109795:	74 12                	je     c01097a9 <getint+0x35>
        return va_arg(*ap, long);
c0109797:	8b 45 08             	mov    0x8(%ebp),%eax
c010979a:	8b 00                	mov    (%eax),%eax
c010979c:	8d 48 04             	lea    0x4(%eax),%ecx
c010979f:	8b 55 08             	mov    0x8(%ebp),%edx
c01097a2:	89 0a                	mov    %ecx,(%edx)
c01097a4:	8b 00                	mov    (%eax),%eax
c01097a6:	99                   	cltd   
c01097a7:	eb 10                	jmp    c01097b9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01097a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ac:	8b 00                	mov    (%eax),%eax
c01097ae:	8d 48 04             	lea    0x4(%eax),%ecx
c01097b1:	8b 55 08             	mov    0x8(%ebp),%edx
c01097b4:	89 0a                	mov    %ecx,(%edx)
c01097b6:	8b 00                	mov    (%eax),%eax
c01097b8:	99                   	cltd   
    }
}
c01097b9:	5d                   	pop    %ebp
c01097ba:	c3                   	ret    

c01097bb <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01097bb:	55                   	push   %ebp
c01097bc:	89 e5                	mov    %esp,%ebp
c01097be:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01097c1:	8d 45 14             	lea    0x14(%ebp),%eax
c01097c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01097c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01097ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01097ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01097d1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01097d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01097dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01097df:	89 04 24             	mov    %eax,(%esp)
c01097e2:	e8 03 00 00 00       	call   c01097ea <vprintfmt>
    va_end(ap);
}
c01097e7:	90                   	nop
c01097e8:	c9                   	leave  
c01097e9:	c3                   	ret    

c01097ea <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01097ea:	55                   	push   %ebp
c01097eb:	89 e5                	mov    %esp,%ebp
c01097ed:	56                   	push   %esi
c01097ee:	53                   	push   %ebx
c01097ef:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01097f2:	eb 17                	jmp    c010980b <vprintfmt+0x21>
            if (ch == '\0') {
c01097f4:	85 db                	test   %ebx,%ebx
c01097f6:	0f 84 bf 03 00 00    	je     c0109bbb <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01097fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109803:	89 1c 24             	mov    %ebx,(%esp)
c0109806:	8b 45 08             	mov    0x8(%ebp),%eax
c0109809:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010980b:	8b 45 10             	mov    0x10(%ebp),%eax
c010980e:	8d 50 01             	lea    0x1(%eax),%edx
c0109811:	89 55 10             	mov    %edx,0x10(%ebp)
c0109814:	0f b6 00             	movzbl (%eax),%eax
c0109817:	0f b6 d8             	movzbl %al,%ebx
c010981a:	83 fb 25             	cmp    $0x25,%ebx
c010981d:	75 d5                	jne    c01097f4 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c010981f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0109823:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010982a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010982d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0109830:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109837:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010983a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010983d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109840:	8d 50 01             	lea    0x1(%eax),%edx
c0109843:	89 55 10             	mov    %edx,0x10(%ebp)
c0109846:	0f b6 00             	movzbl (%eax),%eax
c0109849:	0f b6 d8             	movzbl %al,%ebx
c010984c:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010984f:	83 f8 55             	cmp    $0x55,%eax
c0109852:	0f 87 37 03 00 00    	ja     c0109b8f <vprintfmt+0x3a5>
c0109858:	8b 04 85 20 bf 10 c0 	mov    -0x3fef40e0(,%eax,4),%eax
c010985f:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109861:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109865:	eb d6                	jmp    c010983d <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109867:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010986b:	eb d0                	jmp    c010983d <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010986d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109874:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109877:	89 d0                	mov    %edx,%eax
c0109879:	c1 e0 02             	shl    $0x2,%eax
c010987c:	01 d0                	add    %edx,%eax
c010987e:	01 c0                	add    %eax,%eax
c0109880:	01 d8                	add    %ebx,%eax
c0109882:	83 e8 30             	sub    $0x30,%eax
c0109885:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109888:	8b 45 10             	mov    0x10(%ebp),%eax
c010988b:	0f b6 00             	movzbl (%eax),%eax
c010988e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109891:	83 fb 2f             	cmp    $0x2f,%ebx
c0109894:	7e 38                	jle    c01098ce <vprintfmt+0xe4>
c0109896:	83 fb 39             	cmp    $0x39,%ebx
c0109899:	7f 33                	jg     c01098ce <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c010989b:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010989e:	eb d4                	jmp    c0109874 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01098a0:	8b 45 14             	mov    0x14(%ebp),%eax
c01098a3:	8d 50 04             	lea    0x4(%eax),%edx
c01098a6:	89 55 14             	mov    %edx,0x14(%ebp)
c01098a9:	8b 00                	mov    (%eax),%eax
c01098ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01098ae:	eb 1f                	jmp    c01098cf <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c01098b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01098b4:	79 87                	jns    c010983d <vprintfmt+0x53>
                width = 0;
c01098b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01098bd:	e9 7b ff ff ff       	jmp    c010983d <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01098c2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01098c9:	e9 6f ff ff ff       	jmp    c010983d <vprintfmt+0x53>
            goto process_precision;
c01098ce:	90                   	nop

        process_precision:
            if (width < 0)
c01098cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01098d3:	0f 89 64 ff ff ff    	jns    c010983d <vprintfmt+0x53>
                width = precision, precision = -1;
c01098d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01098dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01098df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01098e6:	e9 52 ff ff ff       	jmp    c010983d <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01098eb:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01098ee:	e9 4a ff ff ff       	jmp    c010983d <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01098f3:	8b 45 14             	mov    0x14(%ebp),%eax
c01098f6:	8d 50 04             	lea    0x4(%eax),%edx
c01098f9:	89 55 14             	mov    %edx,0x14(%ebp)
c01098fc:	8b 00                	mov    (%eax),%eax
c01098fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109901:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109905:	89 04 24             	mov    %eax,(%esp)
c0109908:	8b 45 08             	mov    0x8(%ebp),%eax
c010990b:	ff d0                	call   *%eax
            break;
c010990d:	e9 a4 02 00 00       	jmp    c0109bb6 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109912:	8b 45 14             	mov    0x14(%ebp),%eax
c0109915:	8d 50 04             	lea    0x4(%eax),%edx
c0109918:	89 55 14             	mov    %edx,0x14(%ebp)
c010991b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010991d:	85 db                	test   %ebx,%ebx
c010991f:	79 02                	jns    c0109923 <vprintfmt+0x139>
                err = -err;
c0109921:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109923:	83 fb 06             	cmp    $0x6,%ebx
c0109926:	7f 0b                	jg     c0109933 <vprintfmt+0x149>
c0109928:	8b 34 9d e0 be 10 c0 	mov    -0x3fef4120(,%ebx,4),%esi
c010992f:	85 f6                	test   %esi,%esi
c0109931:	75 23                	jne    c0109956 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0109933:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109937:	c7 44 24 08 0d bf 10 	movl   $0xc010bf0d,0x8(%esp)
c010993e:	c0 
c010993f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109942:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109946:	8b 45 08             	mov    0x8(%ebp),%eax
c0109949:	89 04 24             	mov    %eax,(%esp)
c010994c:	e8 6a fe ff ff       	call   c01097bb <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109951:	e9 60 02 00 00       	jmp    c0109bb6 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0109956:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010995a:	c7 44 24 08 16 bf 10 	movl   $0xc010bf16,0x8(%esp)
c0109961:	c0 
c0109962:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109965:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109969:	8b 45 08             	mov    0x8(%ebp),%eax
c010996c:	89 04 24             	mov    %eax,(%esp)
c010996f:	e8 47 fe ff ff       	call   c01097bb <printfmt>
            break;
c0109974:	e9 3d 02 00 00       	jmp    c0109bb6 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0109979:	8b 45 14             	mov    0x14(%ebp),%eax
c010997c:	8d 50 04             	lea    0x4(%eax),%edx
c010997f:	89 55 14             	mov    %edx,0x14(%ebp)
c0109982:	8b 30                	mov    (%eax),%esi
c0109984:	85 f6                	test   %esi,%esi
c0109986:	75 05                	jne    c010998d <vprintfmt+0x1a3>
                p = "(null)";
c0109988:	be 19 bf 10 c0       	mov    $0xc010bf19,%esi
            }
            if (width > 0 && padc != '-') {
c010998d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109991:	7e 76                	jle    c0109a09 <vprintfmt+0x21f>
c0109993:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0109997:	74 70                	je     c0109a09 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010999c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099a0:	89 34 24             	mov    %esi,(%esp)
c01099a3:	e8 f6 f7 ff ff       	call   c010919e <strnlen>
c01099a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01099ab:	29 c2                	sub    %eax,%edx
c01099ad:	89 d0                	mov    %edx,%eax
c01099af:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01099b2:	eb 16                	jmp    c01099ca <vprintfmt+0x1e0>
                    putch(padc, putdat);
c01099b4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01099b8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01099bb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01099bf:	89 04 24             	mov    %eax,(%esp)
c01099c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c5:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c01099c7:	ff 4d e8             	decl   -0x18(%ebp)
c01099ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01099ce:	7f e4                	jg     c01099b4 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01099d0:	eb 37                	jmp    c0109a09 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c01099d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01099d6:	74 1f                	je     c01099f7 <vprintfmt+0x20d>
c01099d8:	83 fb 1f             	cmp    $0x1f,%ebx
c01099db:	7e 05                	jle    c01099e2 <vprintfmt+0x1f8>
c01099dd:	83 fb 7e             	cmp    $0x7e,%ebx
c01099e0:	7e 15                	jle    c01099f7 <vprintfmt+0x20d>
                    putch('?', putdat);
c01099e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099e9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01099f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01099f3:	ff d0                	call   *%eax
c01099f5:	eb 0f                	jmp    c0109a06 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c01099f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01099fe:	89 1c 24             	mov    %ebx,(%esp)
c0109a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a04:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109a06:	ff 4d e8             	decl   -0x18(%ebp)
c0109a09:	89 f0                	mov    %esi,%eax
c0109a0b:	8d 70 01             	lea    0x1(%eax),%esi
c0109a0e:	0f b6 00             	movzbl (%eax),%eax
c0109a11:	0f be d8             	movsbl %al,%ebx
c0109a14:	85 db                	test   %ebx,%ebx
c0109a16:	74 27                	je     c0109a3f <vprintfmt+0x255>
c0109a18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109a1c:	78 b4                	js     c01099d2 <vprintfmt+0x1e8>
c0109a1e:	ff 4d e4             	decl   -0x1c(%ebp)
c0109a21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109a25:	79 ab                	jns    c01099d2 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0109a27:	eb 16                	jmp    c0109a3f <vprintfmt+0x255>
                putch(' ', putdat);
c0109a29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a30:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a3a:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0109a3c:	ff 4d e8             	decl   -0x18(%ebp)
c0109a3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109a43:	7f e4                	jg     c0109a29 <vprintfmt+0x23f>
            }
            break;
c0109a45:	e9 6c 01 00 00       	jmp    c0109bb6 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109a4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a51:	8d 45 14             	lea    0x14(%ebp),%eax
c0109a54:	89 04 24             	mov    %eax,(%esp)
c0109a57:	e8 18 fd ff ff       	call   c0109774 <getint>
c0109a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109a68:	85 d2                	test   %edx,%edx
c0109a6a:	79 26                	jns    c0109a92 <vprintfmt+0x2a8>
                putch('-', putdat);
c0109a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a73:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a7d:	ff d0                	call   *%eax
                num = -(long long)num;
c0109a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109a85:	f7 d8                	neg    %eax
c0109a87:	83 d2 00             	adc    $0x0,%edx
c0109a8a:	f7 da                	neg    %edx
c0109a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109a8f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109a92:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109a99:	e9 a8 00 00 00       	jmp    c0109b46 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109aa5:	8d 45 14             	lea    0x14(%ebp),%eax
c0109aa8:	89 04 24             	mov    %eax,(%esp)
c0109aab:	e8 75 fc ff ff       	call   c0109725 <getuint>
c0109ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109ab6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109abd:	e9 84 00 00 00       	jmp    c0109b46 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ac9:	8d 45 14             	lea    0x14(%ebp),%eax
c0109acc:	89 04 24             	mov    %eax,(%esp)
c0109acf:	e8 51 fc ff ff       	call   c0109725 <getuint>
c0109ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109ad7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109ada:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109ae1:	eb 63                	jmp    c0109b46 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0109ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109aea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0109af4:	ff d0                	call   *%eax
            putch('x', putdat);
c0109af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109af9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109afd:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b07:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109b09:	8b 45 14             	mov    0x14(%ebp),%eax
c0109b0c:	8d 50 04             	lea    0x4(%eax),%edx
c0109b0f:	89 55 14             	mov    %edx,0x14(%ebp)
c0109b12:	8b 00                	mov    (%eax),%eax
c0109b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109b1e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109b25:	eb 1f                	jmp    c0109b46 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b2e:	8d 45 14             	lea    0x14(%ebp),%eax
c0109b31:	89 04 24             	mov    %eax,(%esp)
c0109b34:	e8 ec fb ff ff       	call   c0109725 <getuint>
c0109b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109b3f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109b46:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b4d:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109b51:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109b54:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109b58:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109b62:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109b66:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b74:	89 04 24             	mov    %eax,(%esp)
c0109b77:	e8 a4 fa ff ff       	call   c0109620 <printnum>
            break;
c0109b7c:	eb 38                	jmp    c0109bb6 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0109b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b85:	89 1c 24             	mov    %ebx,(%esp)
c0109b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b8b:	ff d0                	call   *%eax
            break;
c0109b8d:	eb 27                	jmp    c0109bb6 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109b96:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ba0:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109ba2:	ff 4d 10             	decl   0x10(%ebp)
c0109ba5:	eb 03                	jmp    c0109baa <vprintfmt+0x3c0>
c0109ba7:	ff 4d 10             	decl   0x10(%ebp)
c0109baa:	8b 45 10             	mov    0x10(%ebp),%eax
c0109bad:	48                   	dec    %eax
c0109bae:	0f b6 00             	movzbl (%eax),%eax
c0109bb1:	3c 25                	cmp    $0x25,%al
c0109bb3:	75 f2                	jne    c0109ba7 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0109bb5:	90                   	nop
    while (1) {
c0109bb6:	e9 37 fc ff ff       	jmp    c01097f2 <vprintfmt+0x8>
                return;
c0109bbb:	90                   	nop
        }
    }
}
c0109bbc:	83 c4 40             	add    $0x40,%esp
c0109bbf:	5b                   	pop    %ebx
c0109bc0:	5e                   	pop    %esi
c0109bc1:	5d                   	pop    %ebp
c0109bc2:	c3                   	ret    

c0109bc3 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109bc3:	55                   	push   %ebp
c0109bc4:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bc9:	8b 40 08             	mov    0x8(%eax),%eax
c0109bcc:	8d 50 01             	lea    0x1(%eax),%edx
c0109bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bd2:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bd8:	8b 10                	mov    (%eax),%edx
c0109bda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bdd:	8b 40 04             	mov    0x4(%eax),%eax
c0109be0:	39 c2                	cmp    %eax,%edx
c0109be2:	73 12                	jae    c0109bf6 <sprintputch+0x33>
        *b->buf ++ = ch;
c0109be4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109be7:	8b 00                	mov    (%eax),%eax
c0109be9:	8d 48 01             	lea    0x1(%eax),%ecx
c0109bec:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109bef:	89 0a                	mov    %ecx,(%edx)
c0109bf1:	8b 55 08             	mov    0x8(%ebp),%edx
c0109bf4:	88 10                	mov    %dl,(%eax)
    }
}
c0109bf6:	90                   	nop
c0109bf7:	5d                   	pop    %ebp
c0109bf8:	c3                   	ret    

c0109bf9 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109bf9:	55                   	push   %ebp
c0109bfa:	89 e5                	mov    %esp,%ebp
c0109bfc:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109bff:	8d 45 14             	lea    0x14(%ebp),%eax
c0109c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0109c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c08:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109c0c:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c0f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109c13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c1d:	89 04 24             	mov    %eax,(%esp)
c0109c20:	e8 08 00 00 00       	call   c0109c2d <vsnprintf>
c0109c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109c2b:	c9                   	leave  
c0109c2c:	c3                   	ret    

c0109c2d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109c2d:	55                   	push   %ebp
c0109c2e:	89 e5                	mov    %esp,%ebp
c0109c30:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109c39:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c3c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c42:	01 d0                	add    %edx,%eax
c0109c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109c4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109c52:	74 0a                	je     c0109c5e <vsnprintf+0x31>
c0109c54:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c5a:	39 c2                	cmp    %eax,%edx
c0109c5c:	76 07                	jbe    c0109c65 <vsnprintf+0x38>
        return -E_INVAL;
c0109c5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109c63:	eb 2a                	jmp    c0109c8f <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109c65:	8b 45 14             	mov    0x14(%ebp),%eax
c0109c68:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109c6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c6f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109c73:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109c76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c7a:	c7 04 24 c3 9b 10 c0 	movl   $0xc0109bc3,(%esp)
c0109c81:	e8 64 fb ff ff       	call   c01097ea <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0109c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c89:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109c8f:	c9                   	leave  
c0109c90:	c3                   	ret    

c0109c91 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109c91:	55                   	push   %ebp
c0109c92:	89 e5                	mov    %esp,%ebp
c0109c94:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c0109c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c9a:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109ca3:	b8 20 00 00 00       	mov    $0x20,%eax
c0109ca8:	2b 45 0c             	sub    0xc(%ebp),%eax
c0109cab:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109cae:	88 c1                	mov    %al,%cl
c0109cb0:	d3 ea                	shr    %cl,%edx
c0109cb2:	89 d0                	mov    %edx,%eax
}
c0109cb4:	c9                   	leave  
c0109cb5:	c3                   	ret    

c0109cb6 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109cb6:	55                   	push   %ebp
c0109cb7:	89 e5                	mov    %esp,%ebp
c0109cb9:	57                   	push   %edi
c0109cba:	56                   	push   %esi
c0109cbb:	53                   	push   %ebx
c0109cbc:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109cbf:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0109cc4:	8b 15 84 5a 12 c0    	mov    0xc0125a84,%edx
c0109cca:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109cd0:	6b f0 05             	imul   $0x5,%eax,%esi
c0109cd3:	01 fe                	add    %edi,%esi
c0109cd5:	bf 6d e6 ec de       	mov    $0xdeece66d,%edi
c0109cda:	f7 e7                	mul    %edi
c0109cdc:	01 d6                	add    %edx,%esi
c0109cde:	89 f2                	mov    %esi,%edx
c0109ce0:	83 c0 0b             	add    $0xb,%eax
c0109ce3:	83 d2 00             	adc    $0x0,%edx
c0109ce6:	89 c7                	mov    %eax,%edi
c0109ce8:	83 e7 ff             	and    $0xffffffff,%edi
c0109ceb:	89 f9                	mov    %edi,%ecx
c0109ced:	0f b7 da             	movzwl %dx,%ebx
c0109cf0:	89 0d 80 5a 12 c0    	mov    %ecx,0xc0125a80
c0109cf6:	89 1d 84 5a 12 c0    	mov    %ebx,0xc0125a84
    unsigned long long result = (next >> 12);
c0109cfc:	8b 1d 80 5a 12 c0    	mov    0xc0125a80,%ebx
c0109d02:	8b 35 84 5a 12 c0    	mov    0xc0125a84,%esi
c0109d08:	89 d8                	mov    %ebx,%eax
c0109d0a:	89 f2                	mov    %esi,%edx
c0109d0c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109d10:	c1 ea 0c             	shr    $0xc,%edx
c0109d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109d19:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109d20:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109d23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109d26:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109d29:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109d2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109d32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109d36:	74 1c                	je     c0109d54 <rand+0x9e>
c0109d38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d3b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109d40:	f7 75 dc             	divl   -0x24(%ebp)
c0109d43:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109d49:	ba 00 00 00 00       	mov    $0x0,%edx
c0109d4e:	f7 75 dc             	divl   -0x24(%ebp)
c0109d51:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109d54:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109d57:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109d5a:	f7 75 dc             	divl   -0x24(%ebp)
c0109d5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109d60:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109d63:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109d66:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109d69:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109d6c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109d72:	83 c4 24             	add    $0x24,%esp
c0109d75:	5b                   	pop    %ebx
c0109d76:	5e                   	pop    %esi
c0109d77:	5f                   	pop    %edi
c0109d78:	5d                   	pop    %ebp
c0109d79:	c3                   	ret    

c0109d7a <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109d7a:	55                   	push   %ebp
c0109d7b:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d80:	ba 00 00 00 00       	mov    $0x0,%edx
c0109d85:	a3 80 5a 12 c0       	mov    %eax,0xc0125a80
c0109d8a:	89 15 84 5a 12 c0    	mov    %edx,0xc0125a84
}
c0109d90:	90                   	nop
c0109d91:	5d                   	pop    %ebp
c0109d92:	c3                   	ret    

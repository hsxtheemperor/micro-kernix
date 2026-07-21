/* kernel/sysexcp.asm */

.syntax unified
.cpu cortex-m4
.thumb

.section text
.global svc_sys_exit
.global svc_sys_fork
.global svc_sys_write
.global svc_sys_read
.global svc_sys_creat

.thumb_func
svc_sys_exit:
    /* Exit Process Method */

.thumb_func
sys_svc_fork:
    /* Create Child Process */

.thumb_func
sys_svc_write:
    PUSH {r4, r5, r6, lr}
    BL _mkprintf
    POP {r4, r5, r6, lr}
    BX lr


.thumb_func
sysc_svc_read:
    PUSH {r4, r5, r6, lr}
    BL _mkscanf
    POP {r4, r5, r6, lr}
    BX lr

svc_sys_creat:
    PUSH {r4, r5, r6, lr}
    BL _mkpidtableentry_creat
    POP {r4, r5, r6, lr}
    BX lr
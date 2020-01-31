//
//  MemUsage.c
//  Ring
//
//  Created by Jonas De Vuyst (RingMD) on 26/09/14.
//  Copyright (c) 2014 Medpats Global Pte. Ltd. All rights reserved.
//

#include "MemUsage.h"

#include <mach/mach_init.h>
#include <mach/task.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

// Gratefully stolen from:
// http://www.platinumball.net/blog/2009/05/03/cocoa-app-memory-usage/
// http://stackoverflow.com/questions/787160/programmatically-retrieve-memory-usage-on-iphone
int64_t memoryUsage()
{
  struct task_basic_info  info;
  kern_return_t           rval = 0;
  mach_port_t             task = mach_task_self();
  mach_msg_type_number_t  tcnt = TASK_BASIC_INFO_COUNT;
  task_info_t             tptr = (task_info_t) &info;
  
  memset(&info, 0, sizeof(info));
  
  rval = task_info(task, TASK_BASIC_INFO, tptr, &tcnt);
  if (!(rval == KERN_SUCCESS)) return 0;
  
  return info.resident_size;
}
// Copyright 2010 Google Inc.
// All Right Reserved.
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DiffMatchPatch;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.IO;
using System.Resources;
using HebrewTexts.Logic.Tests;

[TestClass()]
public class Speedtest
{

    [TestMethod()]
    public void RunSpeedtest()
    {

        string text1 = ResourceForTests.Speedtest1; //System.IO.File.ReadAllText("Speedtest1.txt");
        string text2 = ResourceForTests.Speedtest2;  //System.IO.File.ReadAllText("Speedtest2.txt");

        diff_match_patch dmp = new diff_match_patch();
        dmp.Diff_Timeout = 0;

        // Execute one reverse diff as a warmup.
        dmp.diff_main(text2, text1);
        GC.Collect();
        GC.WaitForPendingFinalizers();

        DateTime ms_start = DateTime.Now;
        dmp.diff_main(text1, text2);
        DateTime ms_end = DateTime.Now;
        var elapsedTime = (ms_end - ms_start);
        System.Diagnostics.Debug.WriteLine("Elapsed time: " + elapsedTime);
    }
}


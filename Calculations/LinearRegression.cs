using Godot;
using System;
using System.Diagnostics;

public class LinearRegression : Node
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
        GD.Print("C# Script active");
    
        var xValues = new double[]
                        {
                                300437, 581449, 1359270, 2220774, 4328906
                            };
        var yValues = new double[]
                            {
                                10, 20, 40, 80, 160
                            };

        double rSquared, intercept, slope;
        //PerformLinearRegressionWithIntercept(xValues, yValues, out rSquared, out intercept, out slope);
       // GD.Print($"R-squared = {rSquared}");
       // GD.Print($"Intercept = {intercept}");
        //GD.Print($"Slope = {slope}");

        //var predictedValue = (slope * 2017) + intercept;
       // GD.Print($"Prediction for 2017: {predictedValue}");


        //PerformLinearRegressionWithoutIntercept(xValues, yValues, out rSquared, out intercept, out slope);
        //GD.Print($"R-squared = {rSquared}");
        //GD.Print($"Intercept = {intercept}");
        //GD.Print($"Slope = {slope}");

        //var predictedValue2 = (slope * 2017) + intercept;
        //GD.Print($"Prediction for 2017: {predictedValue}");
	}

        /// <summary>
        /// Fits a line to a collection of (x,y) points.
        /// </summary>
        /// <param name="xVals">The x-axis values.</param>
        /// <param name="yVals">The y-axis values.</param>
        /// <param name="rSquared">The r^2 value of the line.</param>
        /// <param name="yIntercept">The y-intercept value of the line (i.e. y = ax + b, yIntercept is b).</param>
        /// <param name="slope">The slop of the line (i.e. y = ax + b, slope is a).</param>

    public double[] PerformLinearRegressionWithIntercept(
        double[] xVals,
        double[] yVals)
        //out double rSquared,
        //out double yIntercept,
        //out double slope)
    {
        if (xVals.Length != yVals.Length)
        {
            throw new Exception("Input values should be with the same length.");    
        }

        double sumOfX = 0;
        double sumOfY = 0;
        double sumOfXSq = 0;
        double sumOfYSq = 0;
        double sumCodeviates = 0;

        double rSquared = 0;
        double yIntercept = 0;
        double slope = 0;

        for (var i = 0; i < xVals.Length; i++)
        {
            var x = xVals[i];
            var y = yVals[i];
            sumCodeviates += x * y;
            sumOfX += x;
            sumOfY += y;
            sumOfXSq += x * x;
            sumOfYSq += y * y;
        }

        var count = xVals.Length;
        var ssX = sumOfXSq - ((sumOfX * sumOfX) / count);
        var ssY = sumOfYSq - ((sumOfY * sumOfY) / count);

        var rNumerator = (count * sumCodeviates) - (sumOfX * sumOfY);
        var rDenom = (count * sumOfXSq - (sumOfX * sumOfX)) * (count * sumOfYSq - (sumOfY * sumOfY));
        var sCo = sumCodeviates - ((sumOfX * sumOfY) / count);

        var meanX = sumOfX / count;
        var meanY = sumOfY / count;
        var dblR = rNumerator / Math.Sqrt(rDenom);

        rSquared = dblR * dblR;
        yIntercept = meanY - ((sCo / ssX) * meanX);
        slope = sCo / ssX;

        double[] Params = new double[3];
        Params[0] = slope;
        Params[1] = yIntercept;
        Params[2] = rSquared;

        return Params;
    }

    public void PerformLinearRegressionWithoutIntercept(
        double[] xVals,
        double[] yVals,
        out double rSquared,
        out double yIntercept,
        out double slope)
    {
        if (xVals.Length != yVals.Length)
        {
            throw new Exception("Input values should be with the same length.");    
        }

        double sumOfXSq = 0;
        double sumOfYSq = 0;
        double sumCodeviates = 0;
        double sumCodeviatesSq = 0;

        for (var i = 0; i < xVals.Length; i++)
        {
            var x = xVals[i];
            var y = yVals[i];
            sumCodeviates += x * y;
            sumCodeviatesSq += Math.Pow(x * y, 2);
            sumOfXSq += x * x;
            sumOfYSq += y * y;
        }

        rSquared = sumCodeviatesSq / (sumOfXSq *sumOfYSq);
        yIntercept = 0;
        slope = sumCodeviates / sumOfXSq;
    }
}

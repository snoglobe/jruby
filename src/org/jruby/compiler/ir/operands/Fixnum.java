package org.jruby.compiler.ir.operands;

import org.jruby.compiler.ir.IR_Class;

import java.math.BigInteger;

public class Fixnum extends Constant
{
    final public Long _value;

    public Fixnum(Long val) { _value = val; }
    public Fixnum(BigInteger val) { _value = val.longValue(); }

    public String toString() { return _value + ":fixnum"; }

// ---------- These methods below are used during compile-time optimizations ------- 
    public Operand fetchCompileTimeArrayElement(int argIndex, boolean getSubArray) { return (argIndex == 0) ? this : Nil.NIL; }

    public IR_Class getTargetClass() { return IR_Class.getCoreClass("Fixnum"); }
}

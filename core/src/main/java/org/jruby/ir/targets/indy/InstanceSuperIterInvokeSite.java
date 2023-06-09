package org.jruby.ir.targets.indy;

import org.jruby.RubyClass;
import org.jruby.ir.runtime.IRRuntimeHelpers;
import org.jruby.runtime.Block;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

import java.lang.invoke.MethodType;

/**
* Created by headius on 10/23/14.
*/
public class InstanceSuperIterInvokeSite extends ResolvedSuperInvokeSite {
    public InstanceSuperIterInvokeSite(MethodType type, String name, String splatmapString, int flags, String file, int line) {
        super(type, name, splatmapString, flags, file, line);
    }

    @Override
    protected RubyClass getSuperClass(RubyClass definingModule) {
        return definingModule.getSuperClass();
    }

    // FIXME: indy cached version was not doing splat mapping; revert to slow logic for now

    public IRubyObject invoke(ThreadContext context, IRubyObject caller, IRubyObject self, RubyClass definingModule, IRubyObject[] args, Block block) throws Throwable {
        // TODO: get rid of caller
        // TODO: caching
        IRRuntimeHelpers.setCallInfo(context, flags);
        return IRRuntimeHelpers.instanceSuperIterSplatArgs(context, self, superName, definingModule, args, block, splatMap);
    }
}

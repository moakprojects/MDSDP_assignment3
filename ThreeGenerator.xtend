/*
 * generated by Xtext 2.20.0
 */
package org.xtext.assignment.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.assignment.three.MathExp
import java.util.List
import java.util.HashMap
import java.util.Map
import org.xtext.assignment.three.Let
import org.xtext.assignment.three.Var
import org.xtext.assignment.three.Num
import org.xtext.assignment.three.Div
import org.xtext.assignment.three.Mult
import org.xtext.assignment.three.Minus
import org.xtext.assignment.three.Plus
import org.xtext.assignment.three.Expression

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class ThreeGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val mathExps = resource.allContents.filter(MathExp).toList
		fsa.generateFile("output/MathCompiler.java", mathExps.fileBuilder)
	}
	
	def CharSequence fileBuilder(List<MathExp> mathExps) {
		'''
		package math.compiler;
		
		public class MathCalculation {
			public void calculate() {
				�FOR math : mathExps�
				System.out.println("�math.label� = " + �math.compute�);
				�ENDFOR�
			}
		}
		'''
	}
	
	def int compute(MathExp math) { 
		math.exp.computeExp(new HashMap<String,Integer>)
	}
	
	def int computeExp(Expression exp, Map<String,Integer> env) {
		switch exp {
			Plus: exp.left.computeExp(env)+exp.right.computeExp(env)
			Minus: exp.left.computeExp(env)-exp.right.computeExp(env)
			Mult: exp.left.computeExp(env)*exp.right.computeExp(env)
			Div: exp.left.computeExp(env)/exp.right.computeExp(env)
			Num: exp.value
			Var: env.get(exp.id)
			Let: exp.body.computeExp(env.bind(exp.id,exp.binding.computeExp(env)))
			default: throw new Error("Invalid expression")
		}
	}
	
	def Map<String, Integer> bind(Map<String, Integer> env1, String name, int value) {
		val env2 = new HashMap<String,Integer>(env1)
		env2.put(name,value)
		env2 
	}
	
}

<?xml version="1.0" encoding="UTF-8"?>
<!-- <cfsetting enablecfoutputonly="true" /> -->
<!DOCTYPE mach-ii PUBLIC "-//Mach-II//DTD Mach-II Configuration 1.9.0//EN"
	"http://www.mach-ii.com/dtds/mach-ii_1_9_0.dtd">

<mach-ii version="1.9">
    <properties>
		<property name="coldspringProperty" type="MachII.properties.ColdspringProperty">
			<parameters>
				<!-- Name of a Mach-II property name that will hold a reference to the ColdSpring beanFactory Default: 'coldspring.beanfactory.root' -->
				<parameter name="beanFactoryPropertyName" value="serviceFactory"/>
				<!-- Takes the path to the ColdSpring config file (required) -->
				<parameter name="configFile" value="config/coldspring.xml.cfm"/>
				<!-- Flag to indicate whether supplied config path is relative (mapped) or absolute	Default: FALSE (absolute path) -->				
				<parameter name="configFilePathIsRelative" value="true"/>
				<!-- Flag to indicate whether to resolve dependencies for listeners/filters/plugins Default: FALSE -->
				<parameter name="resolveMachIIDependencies" value="true"/>
				<!-- Indicate a scope to pull in a parent bean factory into a child bean factory  default: application -->
				<parameter name="parentBeanFactoryScope" value="application"/>
				<!-- Indicate a key to pull in a parent bean factory from the application scope Default: FALSE -->
				<parameter name="parentBeanFactoryKey" value="false"/>
				<!-- Indicate whether or not to place the bean factory in the application scope Default: FALSE -->
				<parameter name="placeFactoryInApplicationScope" value="false" />
				<!-- Indicate whether or not to place the bean factory in the application scope Default: FALSE -->
				<parameter name="placeFactoryInServerScope" value="false" />
				<!-- Struct of bean names and corresponding Mach-II property names for injecting back into Mach-II Default: does nothing if struct is not defined -->
				<parameter name="beansToMachIIProperties">
					<struct>
						<!-- 
						<key name="ColdSpringBeanName1" value="MachIIPropertyName1" />
						<key name="ColdSpringBeanName2" value="MachIIPropertyName2" />
						 -->
					</struct>
				</parameter>
			</parameters>
		</property>
    </properties>
</mach-ii>
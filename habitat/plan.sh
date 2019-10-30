pkg_name=retail-register-app
pkg_description="A sample JavaEE Web app deployed on Tomcat8 with configurable message"
pkg_origin=gsloan-chef
pkg_version=0.1.0
pkg_maintner="Greg Sloan <gsloan@chef.io>"
pkg_license=('Apache-2.0')
pkg_deps=(core/tomcat8 core/corretto)
pkg_build_deps=(core/corretto core/ant)
pkg_svc_user="root"


do_prepare()
{
    export JAVA_HOME=$(hab pkg path core/corretto)
    
}

do_build()
{
    cp -r $PLAN_CONTEXT/../ $HAB_CACHE_SRC_PATH/$pkg_dirname
    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}
    sed -e "s:{*tomcat-path}*:$(hab pkg path core/tomcat8):g" build_template.xml > build.xml
    ant clean
    ant build
    cp -rf build/classes WebContent/WEB-INF

    
    cd ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/WebContent
    jar -cvf ${pkg_name}.war *
}

do_install()
{
    cp ${HAB_CACHE_SRC_PATH}/${pkg_dirname}/WebContent/${pkg_name}.war ${PREFIX}/
}
void normalize(float[] v) {
	float d=v[0]*v[0]+v[1]*v[1]+v[2]*v[2];
	d=sqrt(d);
	if(d!=0.0) {
		v[0]=v[0]/d;
		v[1]=v[1]/d;
		v[2]=v[2]/d;
	}
}

float innerProduct(float[] va, float[] vb) {
	return (va[0]*vb[0]+va[1]*vb[1]+va[2]*vb[2]);
}

void outerProduct(float[] va, float[] vb, float[] vc) {
	vc[0]=va[1]*vb[2]-va[2]*vb[1];
	vc[1]=va[2]*vb[0]-va[0]*vb[2];
	vc[2]=va[0]*vb[1]-va[1]*vb[0];
}